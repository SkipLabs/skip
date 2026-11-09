/* Diagnostic Linux sampler when perf_event_open is unavailable. Sampling is
 * opt-in through LD_PRELOAD and LEAN_SKIP_SAMPLE; it changes no Lean/Skip code.
 * Optional frame-pointer samples are diagnostic: omitted/tail-call frames cannot
 * be recovered. Nothing here runs in the ordinary benchmark. */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include <ucontext.h>
#include <unistd.h>

static int samples = -1;
static int stacks = 0;
static int timestamps = 0;
static uintptr_t stack_begin, stack_end;
#define FRAME_COUNT 32

static void sample(int signal_number, siginfo_t *info, void *context) {
    (void)signal_number;
    (void)info;
    int saved_errno = errno;
    ucontext_t *state = context;
#if defined(__aarch64__)
    uint64_t pc = state->uc_mcontext.pc;
    uintptr_t sp = state->uc_mcontext.sp, fp = state->uc_mcontext.regs[29];
    uint64_t lr = state->uc_mcontext.regs[30];
#elif defined(__x86_64__)
    uint64_t pc = state->uc_mcontext.gregs[REG_RIP];
    uintptr_t sp = state->uc_mcontext.gregs[REG_RSP], fp = state->uc_mcontext.gregs[REG_RBP];
    uint64_t lr = 0;
#else
#error Unsupported CPU for the diagnostic sampler
#endif
    if (stacks) {
        uint64_t record[FRAME_COUNT + 1] = {0};
        uint64_t *frames = record + 1;
        frames[0] = pc;
        frames[1] = lr;
        if (timestamps) {
            struct timespec now;
            if (clock_gettime(CLOCK_MONOTONIC, &now) == 0)
                record[0] = (uint64_t)now.tv_sec * 1000000000 + now.tv_nsec;
        }
        unsigned n = 2;
        /* Only inspect the interrupted main thread's active stack. Frames above
         * SP are already mapped; increasing aligned links bound the traversal. */
        if (sp >= stack_begin && sp < stack_end) {
            uintptr_t lower = sp;
            while (n < FRAME_COUNT && fp >= lower && fp <= stack_end - 16 && !(fp & 15)) {
                const uintptr_t *frame = (const uintptr_t *)fp;
                frames[n++] = frame[1];
                lower = fp + 16;
                fp = frame[0];
            }
        }
        if (timestamps) (void)write(samples, record, sizeof(record));
        else (void)write(samples, frames, FRAME_COUNT * sizeof(uint64_t));
    } else {
        (void)write(samples, &pc, sizeof(pc));
    }
    errno = saved_errno;
}

__attribute__((constructor)) static void start_sampler(void) {
    const char *path = getenv("LEAN_SKIP_SAMPLE");
    if (!path) return;
    struct sigaction previous;
    if (sigaction(SIGPROF, NULL, &previous) || previous.sa_handler != SIG_DFL) {
        fprintf(stderr, "sampler: SIGPROF already in use\n");
        return;
    }
    char maps_path[4096];
    int path_length = snprintf(maps_path, sizeof(maps_path), "%s.maps", path);
    if (path_length < 0 || (size_t)path_length >= sizeof(maps_path)) return;
    int source = open("/proc/self/maps", O_RDONLY);
    int target = open(maps_path, O_WRONLY | O_CREAT | O_TRUNC, 0600);
    if (source < 0 || target < 0) { perror("sampler maps"); return; }
    char buffer[8192];
    ssize_t length;
    while ((length = read(source, buffer, sizeof(buffer))) > 0) {
        if (write(target, buffer, length) != length) { perror("sampler maps write"); break; }
    }
    close(source);
    close(target);
    samples = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0600);
    if (samples < 0) { perror("sampler output"); return; }
    stacks = getenv("LEAN_SKIP_SAMPLE_STACKS") != NULL;
    timestamps = stacks && getenv("LEAN_SKIP_SAMPLE_TIMESTAMPS") != NULL;
    if (stacks) {
        pthread_attr_t attr;
        void *base;
        size_t size;
        if (pthread_getattr_np(pthread_self(), &attr)) return;
        if (pthread_attr_getstack(&attr, &base, &size)) return;
        pthread_attr_destroy(&attr);
        stack_begin = (uintptr_t)base;
        stack_end = stack_begin + size;
        if (write(samples, timestamps ? "LSKSTK2\0" : "LSKSTK1\0", 8) != 8) return;
    }
    struct sigaction action = {.sa_sigaction = sample, .sa_flags = SA_SIGINFO | SA_RESTART};
    sigemptyset(&action.sa_mask);
    if (sigaction(SIGPROF, &action, NULL)) { perror("sampler sigaction"); return; }
    struct itimerval timer = {.it_interval = {.tv_usec = 2000}, .it_value = {.tv_usec = 2000}};
    if (setitimer(ITIMER_PROF, &timer, NULL)) perror("sampler timer");
}
