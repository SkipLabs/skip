target triple = "x86_64-pc-linux-gnu"

declare i8* @SKIP_Obstack_alloc(i64)
declare i8* @SKIP_Obstack_calloc(i64) #0
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
declare void @SKIP_print_error_raw(i8*)
declare void @SKIP_Obstack_collect(i8*, i8**, i64)
declare i8* @SKIP_Obstack_shallowClone(i64, i8*)
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
declare i8* @SKIP_getArgN(i32)
declare i32 @SKIP_getArgc()
declare i32 @SKIP_String_getByte(i8*, i64)
declare i32 @SKIP_String_byteSize(i8*)
declare i8* @SKIP_Float_toString(double)
declare double @SKIP_String__toFloat_raw(i8*)

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

; Awaitable

define void @SKIP_awaitableNotifyWaitersValueIsReady(i8*) {
  ret void
}

define void @SKIP_awaitableSyncOrThrow(i8*) {
  ret void
}

define void @SKIP_awaitableThrow(i8*, i8*) {
  ret void
}

define void @SKIP_invocationOnStateChange(i8*, i64) {
  ret void
}

define void @SKIP_memoValueBoxObject(i8*, i8*) {
  ret void
}

define void @SKIP_memoizeCall(i8*, i8*) {
  ret void
}

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

declare void @SKIP_saveExn(i8*)

define void @SKIP_etry(i8* %f.0, i8* %onError.1) unnamed_addr uwtable personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
b0.entry:
  %r20 = getelementptr inbounds i8, i8* %f.0, i64 -8
  %r21 = bitcast i8* %r20 to i8**
  %r2 = load i8*, i8** %r21, align 8
  %r22 = getelementptr inbounds i8, i8* %r2, i64 0
  %r23 = bitcast i8* %r22 to i8**
  %r3 = load i8*, i8** %r23, align 8
  %methodCode.24 = bitcast i8* %r3 to void(i8*) *
  invoke void %methodCode.24(i8* %f.0) to label %b6.exit unwind label %b1.rawcatch_5
b1.rawcatch_5:
  %excpair.25 = landingpad { i8*, i32 }
          catch i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN4skip13SkipExceptionE to i8*)
  %caught_type_id.26 = extractvalue { i8*, i32 } %excpair.25, 1
  %expected_type_id.27 = tail call i32 @llvm.eh.typeid.for(i8* nonnull bitcast ({ i8*, i8*, i8* }* @_ZTIN4skip13SkipExceptionE to i8*)) nounwind
  %eq_type_id.28 = icmp eq i32 %caught_type_id.26, %expected_type_id.27
  br i1 %eq_type_id.28, label %catch.29, label %no_catch.30
no_catch.30:
  resume { i8*, i32 } %excpair.25
catch.29:
  %r31 = extractvalue { i8*, i32 } %excpair.25, 0
  %cpp_exc.32 = tail call i8* @__cxa_begin_catch(i8* %r31) nounwind
  %exc_field_addr1.33 = getelementptr inbounds i8, i8* %cpp_exc.32, i64 8
  %exc_field_addr2.34 = bitcast i8* %exc_field_addr1.33 to i8**
  %r8 = load i8*, i8** %exc_field_addr2.34, align 8
  tail call void @__cxa_end_catch()
  br label %b2.record_exc_5
b2.record_exc_5:
  tail call void @SKIP_saveExn(i8* %r8)
  %r35 = getelementptr inbounds i8, i8* %onError.1, i64 -8
  %r36 = bitcast i8* %r35 to i8**
  %r6 = load i8*, i8** %r36, align 8
  %r37 = getelementptr inbounds i8, i8* %r6, i64 0
  %r38 = bitcast i8* %r37 to i8**
  %r9 = load i8*, i8** %r38, align 8
  %methodCode.39 = bitcast i8* %r9 to void(i8*) *
  tail call void %methodCode.39(i8* %onError.1)
  ret void
b6.exit:
  ret void
}
