// Kept in a separate archive member so bootstrap LLVM without the Skip-side
// worker bridge can link the core runtime without pulling in these references.
#include <algorithm>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <thread>
#include <vector>

#include "runtime64_support.h"

extern "C" {
void* sk_parallel_map_evaluate(void*, int64_t, int64_t);
void* sk_parallel_map_results_create(int64_t);
void* sk_parallel_map_result_get(void*, int64_t);
void sk_parallel_map_result_set(void*, int64_t, void*);
void* SKIP_detach_Obstack(void);
void* SKIP_transfer_Obstack(void*, void*);
void SKIP_adopt_Obstack(void*);
void SKIP_release_Obstack(void*);
}

namespace {
thread_local bool in_parallel_map = false;
thread_local int64_t parallel_map_worker_id = 0;
struct ParallelMapWorker {
  void* arena = nullptr;
  void* results = nullptr;
  std::exception_ptr error;
  int64_t start = 0;
  int64_t end = 0;
  ~ParallelMapWorker() {
    SKIP_release_Obstack(arena);
  }
};
struct ParallelMapThreads {
  std::vector<std::thread> threads;
  ~ParallelMapThreads() {
    for (auto& thread : threads)
      if (thread.joinable()) thread.join();
  }
};
}  // namespace

extern "C" void* SKIP_skstore_parallel_map(void* job, int64_t count,
                                           int64_t requested_workers,
                                           bool retain_arenas) {
  if (in_parallel_map || count < 0 || count > 256 || requested_workers < 0 ||
      requested_workers > 64) {
    SKIP_throw_cruntime(ERROR_CONTEXT_CHECK);
  }
  const bool profile = getenv("SKSTORE_PARALLEL_PROFILE") != nullptr;
  const auto started = std::chrono::steady_clock::now();
  int64_t workers = requested_workers;
  if (workers == 0) {
    workers = std::max<unsigned>(1, std::thread::hardware_concurrency());
  }
#ifdef MEMORY_CHECK
  // The diagnostic malloc registry is process-global and unsynchronized.
  workers = 1;
#endif
  workers = std::min(workers, count);
  if (workers <= 1) return sk_parallel_map_evaluate(job, 0, count);

  // State outlives the threads; RAII joins before releasing their arenas.
  std::vector<ParallelMapWorker> state(workers);
  ParallelMapThreads pool;
  pool.threads.reserve(workers);
  for (int64_t i = 0; i < workers; i++) {
    auto& worker = state[i];
    worker.start = count * i / workers;
    worker.end = count * (i + 1) / workers;
    pool.threads.emplace_back([&worker, job, i]() {
      in_parallel_map = true;
      parallel_map_worker_id = i + 1;
      SKIP_new_Obstack();
      try {
        worker.results =
            sk_parallel_map_evaluate(job, worker.start, worker.end);
      } catch (...) {
        worker.error = std::current_exception();
      }
      worker.arena = SKIP_detach_Obstack();
      in_parallel_map = false;
      parallel_map_worker_id = 0;
    });
  }
  for (auto& thread : pool.threads) thread.join();
  const auto computed = std::chrono::steady_clock::now();
  for (auto& worker : state) {
    // Skip exceptions are normally captured into a frozen outcome by the
    // bridge. This handles unexpected native failures before publishing any
    // result.
    if (worker.error) {
      try {
        std::rethrow_exception(worker.error);
      } catch (const skip::SkipException& error) {
        // Preserve a Skip exception even if allocation while constructing the
        // normal outcome caused it to escape the Skip-side catch boundary.
        throw skip::SkipException(
            SKIP_transfer_Obstack(worker.arena, error.m_skipException));
      }
    }
  }
  void* results = sk_parallel_map_results_create(count);
  for (auto& worker : state) {
    void* transferred;
    if (retain_arenas) {
      SKIP_adopt_Obstack(worker.arena);
      transferred = worker.results;
    } else {
      transferred = SKIP_transfer_Obstack(worker.arena, worker.results);
    }
    for (int64_t i = worker.start; i < worker.end; i++) {
      sk_parallel_map_result_set(
          results, i,
          sk_parallel_map_result_get(transferred, i - worker.start));
    }
  }
  if (profile) {
    const auto done = std::chrono::steady_clock::now();
    fprintf(
        stderr,
        "PARALLEL_MAP rows=%lld workers=%lld compute_ms=%.3f transfer_ms=%.3f "
        "retain=%d\n",
        (long long)count, (long long)workers,
        std::chrono::duration<double, std::milli>(computed - started).count(),
        std::chrono::duration<double, std::milli>(done - computed).count(),
        (int)retain_arenas);
  }
  return results;
}

// Diagnostics used by the allocator/thread regression tests.
extern "C" int64_t SKIP_parallel_map_worker_id() {
  return parallel_map_worker_id;
}
extern "C" bool SKIP_parallel_map_native() {
  return true;
}
