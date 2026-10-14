#define _GNU_SOURCE
#include <pthread.h>
#include <dlfcn.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdatomic.h>
#include <stdint.h>
struct start { void *(*fn)(void *); void *arg; };
static _Atomic uint64_t cpu_ns, wall_ns, count;
static uint64_t now(clockid_t c) { struct timespec t; clock_gettime(c,&t); return (uint64_t)t.tv_sec*1000000000+t.tv_nsec; }
static void *run(void *p) {
  struct start s=*(struct start *)p; free(p);
  uint64_t c=now(CLOCK_THREAD_CPUTIME_ID), w=now(CLOCK_MONOTONIC);
  void *r=s.fn(s.arg);
  atomic_fetch_add(&cpu_ns,now(CLOCK_THREAD_CPUTIME_ID)-c);
  atomic_fetch_add(&wall_ns,now(CLOCK_MONOTONIC)-w);
  atomic_fetch_add(&count,1);
  return r;
}
int pthread_create(pthread_t *t,const pthread_attr_t *a,void *(*fn)(void *),void *arg) {
  int (*real)(pthread_t *,const pthread_attr_t *,void *(*)(void *),void *)=dlsym(RTLD_NEXT,"pthread_create");
  struct start *s=malloc(sizeof(*s)); *s=(struct start){fn,arg};
  int r=real(t,a,run,s); if(r) free(s); return r;
}
__attribute__((destructor)) static void report(void) {
  if (atomic_load(&count)) fprintf(stderr,"THREAD_CPU threads=%llu cpu_ns=%llu sum_wall_ns=%llu\n",(unsigned long long)atomic_load(&count),(unsigned long long)atomic_load(&cpu_ns),(unsigned long long)atomic_load(&wall_ns));
}
