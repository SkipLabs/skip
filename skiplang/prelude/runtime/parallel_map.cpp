// Kept in a separate archive member so bootstrap LLVM without the Skip-side
// worker bridge can link the core runtime without pulling in these references.
#include <algorithm>
#include <atomic>
#include <chrono>
#include <condition_variable>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <mutex>
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
void* SKIP_intern_shared(void*);
}

namespace {
thread_local bool in_parallel_map = false;
thread_local int64_t parallel_map_worker_id = 0;

// ---- Persistent work-stealing thread pool ---------------------------------
// Replaces per-batch std::thread creation and static range partitioning with
// a reusable worker pool that dynamically claims individual items via an
// atomic index. Each worker runs in its own obstack per batch and detaches it
// at batch completion so results can be adopted or transferred cleanly.

struct PoolBatch {
  void* job = nullptr;
  int64_t count = 0;
  int64_t active_workers = 0;
  std::atomic<int64_t> next_index{0};
  std::vector<void*> item_results;
  std::vector<void*> worker_arenas;
  std::vector<std::exception_ptr> worker_errors;
  std::atomic<int64_t> done_workers{0};
};

class PersistentPool {
 public:
  void run(PoolBatch& batch, int64_t workers) {
    std::unique_lock<std::mutex> lock(mu_);
    ensure_workers_locked(workers);
    current_ = &batch;
    active_limit_ = workers;
    ++generation_;
    cv_work_.notify_all();
    cv_done_.wait(lock, [&]() {
      return batch.done_workers.load(std::memory_order_acquire) == workers;
    });
    current_ = nullptr;
  }

  ~PersistentPool() {
    {
      std::lock_guard<std::mutex> lock(mu_);
      stop_ = true;
      ++generation_;
    }
    cv_work_.notify_all();
    for (auto& t : threads_) {
      if (t.joinable()) t.join();
    }
  }

 private:
  void ensure_workers_locked(int64_t n) {
    while (static_cast<int64_t>(threads_.size()) < n) {
      int64_t id = static_cast<int64_t>(threads_.size());
      threads_.emplace_back([this, id]() { worker_loop(id); });
    }
  }

  void worker_loop(int64_t id) {
    uint64_t seen_gen = 0;
    for (;;) {
      PoolBatch* batch = nullptr;
      {
        std::unique_lock<std::mutex> lock(mu_);
        cv_work_.wait(lock, [&]() { return stop_ || generation_ != seen_gen; });
        if (stop_) return;
        seen_gen = generation_;
        if (id >= active_limit_) continue;
        batch = current_;
      }

      in_parallel_map = true;
      parallel_map_worker_id = id + 1;
      SKIP_new_Obstack();
      try {
        // First claim this worker's own slot (`id`) so every active worker
        // participates even on tiny/fast batches, then dynamically steal
        // remaining items starting at `active_workers`.
        int64_t idx = id;
        while (idx < batch->count) {
          void* single = sk_parallel_map_evaluate(batch->job, idx, idx + 1);
          batch->item_results[idx] = sk_parallel_map_result_get(single, 0);
          idx = batch->next_index.fetch_add(1, std::memory_order_relaxed);
        }
      } catch (...) {
        batch->worker_errors[id] = std::current_exception();
      }
      batch->worker_arenas[id] = SKIP_detach_Obstack();
      in_parallel_map = false;
      parallel_map_worker_id = 0;

      if (batch->done_workers.fetch_add(1, std::memory_order_acq_rel) + 1 ==
          batch->active_workers) {
        std::lock_guard<std::mutex> lock(mu_);
        cv_done_.notify_one();
      }
    }
  }

  std::mutex mu_;
  std::condition_variable cv_work_;
  std::condition_variable cv_done_;
  std::vector<std::thread> threads_;
  PoolBatch* current_ = nullptr;
  int64_t active_limit_ = 0;
  uint64_t generation_ = 0;
  bool stop_ = false;
};

PersistentPool& global_pool() {
  static PersistentPool* pool = new PersistentPool();
  return *pool;
}

// ---- Append-only atomic dependency hash table -----------------------------
// Used when SKStore runs in atomic-deps mode (dependencyMode bit 1, i.e. 2):
// maps dep_hash (64-bit hash of Path) -> lock-free linked list of reader
// ArrowKey pointers (stored as interned/persistent heap pointers or raw
// handles). Workers insert edges directly with atomic CAS (zero serial
// dependency replay!). Deletions are intentionally omitted (false positives
// are safe; clear/reset reclaims the whole table).

struct DepNode {
  int64_t path_hash;
  int64_t reader_hash;
  void* reader;  // ArrowKey* interned in shared heap so it outlives obstacks
  DepNode* next;
};

class AtomicDepTable {
 public:
  static constexpr size_t kNumBuckets = 1 << 17;  // 131,072 buckets
  static constexpr size_t kMask = kNumBuckets - 1;

  AtomicDepTable() : buckets_(new std::atomic<DepNode*>[kNumBuckets]) {
    for (size_t i = 0; i < kNumBuckets; i++) {
      buckets_[i].store(nullptr, std::memory_order_relaxed);
    }
  }

  void insert(int64_t path_hash, int64_t reader_hash, void* reader) {
    size_t idx = static_cast<size_t>(path_hash) & kMask;
    auto& head = buckets_[idx];
    // Fast dedup scan before interning or allocating.
    DepNode* cur = head.load(std::memory_order_acquire);
    while (cur != nullptr) {
      if (cur->path_hash == path_hash && cur->reader_hash == reader_hash) {
        return;
      }
      cur = cur->next;
    }
    // Protect SKIP_intern_shared with a mutex so concurrent worker threads
    // never race on shared-heap interning / palloc.
    void* pinned;
    {
      std::lock_guard<std::mutex> lock(intern_mu_);
      pinned = SKIP_intern_shared(reader);
    }
    DepNode* node = new DepNode{path_hash, reader_hash, pinned, nullptr};
    DepNode* expected = head.load(std::memory_order_relaxed);
    do {
      node->next = expected;
    } while (!head.compare_exchange_weak(expected, node,
                                         std::memory_order_release,
                                         std::memory_order_relaxed));
  }

  // Copies matching reader pointers for `path_hash` into `out` (up to `cap`).
  // Returns total count found (may exceed `cap` if caller needs a larger buf).
  int64_t lookup(int64_t path_hash, void** out, int64_t cap) const {
    size_t idx = static_cast<size_t>(path_hash) & kMask;
    DepNode* cur = buckets_[idx].load(std::memory_order_acquire);
    int64_t n = 0;
    while (cur != nullptr) {
      if (cur->path_hash == path_hash) {
        if (n < cap) out[n] = cur->reader;
        ++n;
      }
      cur = cur->next;
    }
    return n;
  }

  void clear() {
    for (size_t i = 0; i < kNumBuckets; i++) {
      DepNode* cur = buckets_[i].exchange(nullptr, std::memory_order_acq_rel);
      while (cur != nullptr) {
        DepNode* next = cur->next;
        delete cur;
        cur = next;
      }
    }
  }

  ~AtomicDepTable() {
    clear();
    delete[] buckets_;
  }

 private:
  std::atomic<DepNode*>* buckets_;
  std::mutex intern_mu_;
};

// Registry of atomic dep tables indexed by integer table ID (1-based).
std::mutex g_tables_mu;
std::vector<AtomicDepTable*> g_tables;

AtomicDepTable* get_table(int64_t id) {
  if (id <= 0) return nullptr;
  std::lock_guard<std::mutex> lock(g_tables_mu);
  size_t idx = static_cast<size_t>(id - 1);
  return idx < g_tables.size() ? g_tables[idx] : nullptr;
}

}  // namespace

extern "C" void* SKIP_skstore_parallel_map(void* job, int64_t count,
                                           int64_t requested_workers,
                                           bool retain_arenas) {
  if (in_parallel_map || count < 0 || count > 4096 || requested_workers < 0 ||
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

  PoolBatch batch;
  batch.job = job;
  batch.count = count;
  batch.active_workers = workers;
  batch.next_index.store(workers, std::memory_order_relaxed);
  batch.item_results.assign(static_cast<size_t>(count), nullptr);
  batch.worker_arenas.assign(static_cast<size_t>(workers), nullptr);
  batch.worker_errors.resize(static_cast<size_t>(workers));

  global_pool().run(batch, workers);
  const auto computed = std::chrono::steady_clock::now();

  // Check for uncaught exceptions from any worker.
  for (int64_t w = 0; w < workers; w++) {
    if (batch.worker_errors[w]) {
      std::exception_ptr err = batch.worker_errors[w];
      void* arena = batch.worker_arenas[w];
      for (int64_t j = 0; j < workers; j++) {
        if (j != w) SKIP_release_Obstack(batch.worker_arenas[j]);
      }
      try {
        std::rethrow_exception(err);
      } catch (const skip::SkipException& error) {
        void* transferred = SKIP_transfer_Obstack(arena, error.m_skipException);
        SKIP_release_Obstack(arena);
        throw skip::SkipException(transferred);
      } catch (...) {
        SKIP_release_Obstack(arena);
        throw;
      }
    }
  }

  void* results = sk_parallel_map_results_create(count);
  if (retain_arenas) {
    for (int64_t w = 0; w < workers; w++) {
      SKIP_adopt_Obstack(batch.worker_arenas[w]);
      SKIP_release_Obstack(batch.worker_arenas[w]);
    }
    for (int64_t i = 0; i < count; i++) {
      sk_parallel_map_result_set(results, i, batch.item_results[i]);
    }
  } else {
    // Adopt all worker arenas into a temporary obstack? No — transfer each
    // item result from whichever worker arena owns it; adopting into the
    // caller's obstack is O(pages) and zero-copy, and the caller's `withRegion`
    // immediately copies out only the live results and frees the worker pages!
    for (int64_t w = 0; w < workers; w++) {
      SKIP_adopt_Obstack(batch.worker_arenas[w]);
      SKIP_release_Obstack(batch.worker_arenas[w]);
    }
    for (int64_t i = 0; i < count; i++) {
      sk_parallel_map_result_set(results, i, batch.item_results[i]);
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

// ---- Atomic dependency table C API ----------------------------------------

// Interning from worker threads uses SKIP_intern_shared, which allocates in
// the shared persistent heap (protected by its own spinlock) so concurrent
// worker inserts are thread-safe. For fast single-lookup iteration from Skip,
// we also expose `SKIP_skstore_atomic_deps_get_all`? No, count + get is fine
// when buckets are small (typically 1-8 readers per path).
extern "C" int64_t SKIP_skstore_atomic_deps_create(void) {
  std::lock_guard<std::mutex> lock(g_tables_mu);
  g_tables.push_back(new AtomicDepTable());
  return static_cast<int64_t>(g_tables.size());
}

extern "C" void SKIP_skstore_atomic_deps_insert(int64_t table_id,
                                                int64_t path_hash,
                                                int64_t reader_hash,
                                                void* reader) {
  AtomicDepTable* tbl = get_table(table_id);
  if (tbl == nullptr) return;
  tbl->insert(path_hash, reader_hash, reader);
}

extern "C" int64_t SKIP_skstore_atomic_deps_count(int64_t table_id,
                                                  int64_t path_hash) {
  AtomicDepTable* tbl = get_table(table_id);
  if (tbl == nullptr) return 0;
  return tbl->lookup(path_hash, nullptr, 0);
}

extern "C" void* SKIP_skstore_atomic_deps_get(int64_t table_id,
                                              int64_t path_hash,
                                              int64_t index) {
  AtomicDepTable* tbl = get_table(table_id);
  if (tbl == nullptr || index < 0) return nullptr;
  std::vector<void*> buf(static_cast<size_t>(index + 1), nullptr);
  int64_t n = tbl->lookup(path_hash, buf.data(), index + 1);
  return index < n ? buf[static_cast<size_t>(index)] : nullptr;
}

extern "C" void SKIP_skstore_atomic_deps_clear(int64_t table_id) {
  AtomicDepTable* tbl = get_table(table_id);
  if (tbl == nullptr) return;
  tbl->clear();
}

// Diagnostics used by the allocator/thread regression tests.
extern "C" int64_t SKIP_parallel_map_worker_id() {
  return parallel_map_worker_id;
}
extern "C" bool SKIP_parallel_map_native() {
  return true;
}
