target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32"

declare i8* @SKIP_Obstack_alloc(i32)
declare i8* @SKIP_Obstack_calloc(i32) #0
declare i8* @SKIP_Int_toString(i64) #0
declare i1 @SKIP_String__contains(i8*, i8*)
declare i8* @SKIP_String_concat2(i8*, i8*)
declare void @SKIP_print_last_exception_stack_trace_and_exit(i8*)
declare void @SKIP_throw(i8*)
declare void @SKIP_unreachableMethodCall(i8*, i8*)
declare void @SKIP_unreachableWithExplanation(i8*)
declare i8* @SKIP_Array_concatStringArray(i8*)
declare i64 @SKIP_String_StringIterator__rawNext(i8*)
declare i64 @SKIP_String_StringIterator__rawPrev(i8*)
declare i8* @SKIP_String_StringIterator__substring(i8*, i8*)
declare i8* @SKIP_String__fromChars(i8*, i8*)
declare i64 @SKIP_String__length(i8*)
declare i64 @SKIP_Unsafe_string_utf8_size(i8*)
declare void @SKIP_print_error(i8*)
declare void @SKIP_Obstack_vectorUnsafeSet(i8**, i8*)
declare void @SKIP_print_raw(i8*)
declare void @SKIP_Obstack_collect(i8*, i8**, i64)
declare i8* @SKIP_Obstack_shallowClone(i32, i8*)
declare i64 @SKIP_String_StringIterator__rawCurrent(i8*)
declare void @SKIP_String_StringIterator__rawDrop(i8*, i64)
declare i64 @SKIP_String_cmp(i8*, i8*)
declare {i64, i64} @SKIP_String_toIntOptionHelper(i8*)
declare i8* @SKIP_arguments()
declare i8* @SKIP_intern(i8*)
declare void @SKIP_internalExit(i64)
declare void @SKIP_llvm_memcpy(i8*, i8*, i64)
declare i8* @SKIP_read_line()
declare void @SKIP_drop(i8*)
declare i8* @SKIP_getArgN(i64)
declare i64 @SKIP_getArgc()
declare i32 @SKIP_String_getByte(i8*, i64)
declare i64 @SKIP_String_byteSize(i8*)
declare void @SKIP_etry(i8*, i8*)

; LLVM

declare void @llvm.lifetime.start(i64, i8* nocapture) argmemonly nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) argmemonly nounwind

declare i32 @llvm.eh.typeid.for(i8*) nounwind readnone

declare i64 @llvm.ctlz.i64(i64, i1)
declare i64 @llvm.cttz.i64(i64, i1)
declare i64 @llvm.ctpop.i64(i64)

declare double @llvm.sin.f64(double %Val)
declare double @llvm.cos.f64(double %Val)
declare double @llvm.floor.f64(double %Val)
declare double @llvm.ceil.f64(double %Val)
declare double @llvm.round.f64(double %Val)
declare double @llvm.sqrt.f64(double %Val)
declare double @llvm.pow.f64(double %Val, double %Power)

declare i32 @__gxx_personality_v0(...)
declare i8* @__cxa_begin_catch(i8*)
declare void @__cxa_end_catch()

@_ZTIN4skip13SkipExceptionE = external constant { i8*, i8*, i8* }, align 8

; Delete after update_lkg
declare void @abort() noreturn

; Obstack code

; Function Attrs: alwaysinline nounwind uwtable
define void @SKIP_Obstack_inl_collect(i8*, i8**, i64) {
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define i8* @SKIP_Obstack_note_inl() {
  ret i8* null
}

; Function Attrs: alwaysinline nounwind uwtable
define void @SKIP_Obstack_inl_collect0(i8*) {
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define i8* @SKIP_Obstack_inl_collect1(i8*, i8*) {
  ret i8* %1
}

; Function Attrs: alwaysinline nounwind uwtable
define void @SKIP_Obstack_store(i8** %obj, i8* %val) {
  store i8* %val, i8** %obj
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define void @SKIP_debug_break() {
  ret void
}

; Function Attrs: noinline nounwind optnone
define i1 @SKIP_String_eq(i8* %0, i8* %1) #0 {
  %3 = alloca i8*, align 4
  %4 = alloca i8*, align 4
  store i8* %0, i8** %3, align 4
  store i8* %1, i8** %4, align 4
  %5 = load i8*, i8** %3, align 4
  %6 = load i8*, i8** %4, align 4
  %7 = call i64 @SKIP_String_cmp(i8* %5, i8* %6)
  %8 = icmp eq i64 %7, 0
  ret i1 %8
}


%struct._FunctionSignature = type { i8*, void (...)*, i8, i8, i8* }
