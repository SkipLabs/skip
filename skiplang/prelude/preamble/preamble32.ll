target datalayout = "e-m:e-p:32:32-p10:8:8-p20:8:8-i64:64-i128:128-n32:64-S128-ni:1:10:20"
target triple = "wasm32"

declare void @SKIP_print_last_exception_stack_trace_and_exit(ptr) noreturn cold
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

; Obstack

declare noalias align 8 ptr @SKIP_Obstack_alloc(i32) nofree
declare noalias align 8 ptr @SKIP_Obstack_calloc(i32) nofree
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
declare noalias align 4 ptr @SKIP_Obstack_shallowClone(i32, ptr readonly captures(none) nonnull) nofree

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
declare void @SKIP_etry(ptr, ptr)
