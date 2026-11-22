target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

declare void @SKIP_print_last_exception_stack_trace_and_exit(ptr) noreturn cold
; Called by assertions that only a development build keeps.
declare void @SKIP_print_stack_trace()
declare void @SKIP_throw(ptr) noreturn cold
declare void @SKIP_unreachableMethodCall(ptr, ptr) noreturn cold
declare void @SKIP_unreachableWithExplanation(ptr) noreturn cold
declare ptr @SKIP_intern(ptr)
define linkonce_odr ptr @SKIP_llvm_memcpy(ptr %dest, ptr %src, i64 %len) alwaysinline nounwind uwtable {
  call void @llvm.memcpy.p0.p0.i64(ptr %dest, ptr %src, i64 %len, i1 false)
  ret ptr %dest
}
define linkonce_odr void @SKIP_llvm_memset(ptr %dest, i8 %val, i64 %len) alwaysinline nounwind uwtable {
  call void @llvm.memset.p0.i64(ptr %dest, i8 %val, i64 %len, i1 false)
  ret void
}

; LLVM intrinsics

declare void @llvm.lifetime.start(i64 immarg, ptr nocapture)
declare void @llvm.lifetime.end(i64 immarg, ptr nocapture)

declare void @llvm.memcpy.p0.p0.i64(ptr noalias captures(none) writeonly, ptr noalias captures(none) readonly, i64, i1 immarg)
declare void @llvm.memset.p0.i64(ptr captures(none) writeonly, i8, i64, i1 immarg)

declare i32 @llvm.eh.typeid.for(ptr)

declare i64 @llvm.ctlz.i64(i64, i1)
declare i64 @llvm.cttz.i64(i64, i1)
declare i64 @llvm.ctpop.i64(i64)

declare i32 @__gxx_personality_v0(...)
declare ptr @__cxa_begin_catch(ptr)
declare void @__cxa_end_catch()

; Awaitable

define void @SKIP_awaitableNotifyWaitersValueIsReady(ptr) {
  ret void
}

define void @SKIP_awaitableSyncOrThrow(ptr) {
  ret void
}

define void @SKIP_awaitableThrow(ptr, ptr) {
  ret void
}

; Obstack

; Bump allocation inline; the runtime (obstack.c) takes over when the page is
; full. Must stay in sync with SKIP_Obstack_alloc there: size rounded up to 8.
@SKIP_obstack_head = external thread_local global ptr
@SKIP_obstack_end = external thread_local global ptr
declare noalias align 8 ptr @SKIP_Obstack_alloc_slow(i64) nofree

define linkonce_odr noalias align 8 ptr @SKIP_Obstack_alloc(i64 %size) alwaysinline nofree {
  %padded = add i64 %size, 7
  %total = and i64 %padded, -8
  %head = load ptr, ptr @SKIP_obstack_head, align 8
  %end = load ptr, ptr @SKIP_obstack_end, align 8
  %next = getelementptr i8, ptr %head, i64 %total
  %full = icmp uge ptr %next, %end
  br i1 %full, label %slow, label %fast

fast:
  store ptr %next, ptr @SKIP_obstack_head, align 8
  ret ptr %head

slow:
  %slow_result = call ptr @SKIP_Obstack_alloc_slow(i64 %size)
  ret ptr %slow_result
}

define linkonce_odr noalias align 8 ptr @SKIP_Obstack_calloc(i64 %size) alwaysinline nofree {
  %result = call ptr @SKIP_Obstack_alloc(i64 %size)
  call void @llvm.memset.p0.i64(ptr align 8 %result, i8 0, i64 %size, i1 false)
  ret ptr %result
}
define linkonce_odr void @SKIP_Obstack_vectorUnsafeSet(ptr %arr, ptr %x) alwaysinline nounwind uwtable {
  store ptr %x, ptr %arr
  ret void
}
; WARNING: SKIP_Obstack_collect is the moving-GC relocation hook (emitted by
; LowerLocalGC in gc.sk with mayRelocatePointers). Its C body is a no-op today
; (runtime.c: the collector is disabled), so only `nounwind willreturn` are sound.
; When the moving collector is re-enabled it will READ the root buffer and WRITE
; relocated pointers back, and may OOM-throw -- at which point `nounwind` becomes a
; SILENT MISCOMPILE. Revisit these attributes (drop nounwind; do NOT add
; memory()/nofree/captures) together with any GC re-enablement.
declare void @SKIP_Obstack_collect(ptr, ptr, i64) nounwind willreturn
declare noalias align 8 ptr @SKIP_Obstack_shallowClone(i64, ptr readonly captures(none) nonnull) nofree

define void @SKIP_Obstack_inl_collect(ptr, ptr, i64) alwaysinline nounwind uwtable {
  ret void
}

define ptr @SKIP_Obstack_note_inl() alwaysinline nounwind uwtable {
  ret ptr null
}

define void @SKIP_Obstack_inl_collect0(ptr) alwaysinline nounwind uwtable {
  ret void
}

define ptr @SKIP_Obstack_inl_collect1(ptr, ptr) alwaysinline nounwind uwtable {
  ret ptr %1
}

define void @SKIP_Obstack_store(ptr %obj, ptr %val) alwaysinline nounwind uwtable {
  store ptr %val, ptr %obj
  ret void
}

; String

declare noalias align 8 ptr @SKIP_String_concat2(ptr readonly captures(none), ptr readonly captures(none)) nofree willreturn
declare i64 @SKIP_String_cmp(ptr captures(none), ptr captures(none)) memory(argmem: read) willreturn nounwind
declare i64 @SKIP_String_hash(ptr captures(none)) memory(argmem: read) willreturn nounwind
declare align 8 ptr @SKIP_Float_toString(double) nofree

define i1 @SKIP_String_eq(ptr captures(none) %0, ptr captures(none) %1) nounwind willreturn memory(argmem: read) {
  %3 = call i64 @SKIP_String_cmp(ptr %0, ptr %1)
  %4 = icmp eq i64 %3, 0
  ret i1 %4
}


; Exception

@_ZTIN4skip13SkipExceptionE = external constant { ptr, ptr, ptr }, align 8

declare void @SKIP_saveExn(ptr) nounwind willreturn memory(write, argmem: none) nofree

define void @SKIP_etry(ptr %f.0, ptr %onError.1) unnamed_addr uwtable personality ptr @__gxx_personality_v0 {
b0.entry:
  %r20 = getelementptr inbounds i8, ptr %f.0, i64 -8
  %r2 = load ptr, ptr %r20, align 8
  %r22 = getelementptr inbounds i8, ptr %r2, i64 0
  %r3 = load ptr, ptr %r22, align 8
  invoke void %r3(ptr %f.0) to label %b6.exit unwind label %b1.rawcatch_5
b1.rawcatch_5:
  %excpair.25 = landingpad { ptr, i32 }
          catch ptr @_ZTIN4skip13SkipExceptionE
  %caught_type_id.26 = extractvalue { ptr, i32 } %excpair.25, 1
  %expected_type_id.27 = tail call i32 @llvm.eh.typeid.for(ptr nonnull @_ZTIN4skip13SkipExceptionE) nounwind
  %eq_type_id.28 = icmp eq i32 %caught_type_id.26, %expected_type_id.27
  br i1 %eq_type_id.28, label %catch.29, label %no_catch.30
no_catch.30:
  resume { ptr, i32 } %excpair.25
catch.29:
  %r31 = extractvalue { ptr, i32 } %excpair.25, 0
  %cpp_exc.32 = tail call ptr @__cxa_begin_catch(ptr %r31) nounwind
  %exc_field_addr1.33 = getelementptr inbounds i8, ptr %cpp_exc.32, i64 8
  %r8 = load ptr, ptr %exc_field_addr1.33, align 8
  tail call void @__cxa_end_catch()
  br label %b2.record_exc_5
b2.record_exc_5:
  tail call void @SKIP_saveExn(ptr %r8)
  %r35 = getelementptr inbounds i8, ptr %onError.1, i64 -8
  %r6 = load ptr, ptr %r35, align 8
  %r37 = getelementptr inbounds i8, ptr %r6, i64 0
  %r9 = load ptr, ptr %r37, align 8
  tail call void %r9(ptr %onError.1)
  ret void
b6.exit:
  ret void
}
