; ModuleID = 'cxa_exception.bc'
source_filename = "cxa_exception.cpp"
target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32"

%"struct.__cxxabiv1::__cxa_exception" = type { %"class.std::type_info"*, void (i8*)*, void ()*, void ()*, %"struct.__cxxabiv1::__cxa_exception"*, i32, i32, i8*, i8*, i8*, i8*, i32, %struct._Unwind_Exception }
%"class.std::type_info" = type { i32 (...)**, i8* }
%struct._Unwind_Exception = type { i64, void (i32, %struct._Unwind_Exception*)*, i32, i32, [3 x i32] }

$__clang_call_terminate = comdat any

; Function Attrs: noinline nounwind optnone
define i8* @__cxa_allocate_exception(i32) #0 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 4
  %6 = alloca %"struct.__cxxabiv1::__cxa_exception"*, align 4
  store i32 %0, i32* %2, align 4
  %7 = load i32, i32* %2, align 4
  %8 = invoke i32 @_ZN10__cxxabiv1L45cxa_exception_size_from_exception_thrown_sizeEm(i32 %7)
          to label %9 unwind label %31

; <label>:9:                                      ; preds = %1
  store i32 %8, i32* %3, align 4
  %10 = invoke i32 @_ZN10__cxxabiv1L24get_cxa_exception_offsetEv()
          to label %11 unwind label %31

; <label>:11:                                     ; preds = %9
  store i32 %10, i32* %4, align 4
  %12 = load i32, i32* %4, align 4
  %13 = load i32, i32* %3, align 4
  %14 = add i32 %12, %13
  %15 = invoke i8* @_ZN10__cxxabiv130__aligned_malloc_with_fallbackEm(i32 %14)
          to label %16 unwind label %31

; <label>:16:                                     ; preds = %11
  store i8* %15, i8** %5, align 4
  %17 = load i8*, i8** %5, align 4
  %18 = icmp eq i8* null, %17
  br i1 %18, label %19, label %20

; <label>:19:                                     ; preds = %16
  call void @_ZSt9terminatev() #5
  unreachable

; <label>:20:                                     ; preds = %16
  %21 = load i8*, i8** %5, align 4
  %22 = load i32, i32* %4, align 4
  %23 = getelementptr inbounds i8, i8* %21, i32 %22
  %24 = bitcast i8* %23 to %"struct.__cxxabiv1::__cxa_exception"*
  store %"struct.__cxxabiv1::__cxa_exception"* %24, %"struct.__cxxabiv1::__cxa_exception"** %6, align 4
  %25 = load %"struct.__cxxabiv1::__cxa_exception"*, %"struct.__cxxabiv1::__cxa_exception"** %6, align 4
  %26 = bitcast %"struct.__cxxabiv1::__cxa_exception"* %25 to i8*
  %27 = load i32, i32* %3, align 4
  call void @llvm.memset.p0i8.i32(i8* align 16 %26, i8 0, i32 %27, i1 false)
  %28 = load %"struct.__cxxabiv1::__cxa_exception"*, %"struct.__cxxabiv1::__cxa_exception"** %6, align 4
  %29 = invoke i8* @_ZN10__cxxabiv1L32thrown_object_from_cxa_exceptionEPNS_15__cxa_exceptionE(%"struct.__cxxabiv1::__cxa_exception"* %28)
          to label %30 unwind label %31

; <label>:30:                                     ; preds = %20
  ret i8* %29

; <label>:31:                                     ; preds = %20, %11, %9, %1
  %32 = landingpad { i8*, i32 }
          catch i8* null
  %33 = extractvalue { i8*, i32 } %32, 0
  call void @__clang_call_terminate(i8* %33) #5
  unreachable
}

; Function Attrs: noinline optnone
define internal i32 @_ZN10__cxxabiv1L45cxa_exception_size_from_exception_thrown_sizeEm(i32) #1 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = add i32 %3, 80
  %5 = call i32 @_ZN10__cxxabiv1L23aligned_allocation_sizeEmm(i32 %4, i32 16)
  ret i32 %5
}

declare i32 @__gxx_personality_v0(...)

; Function Attrs: noinline noreturn nounwind
define linkonce_odr hidden void @__clang_call_terminate(i8*) #2 comdat {
  %2 = call i8* @__cxa_begin_catch(i8* %0) #6
  call void @_ZSt9terminatev() #5
  unreachable
}

declare i8* @__cxa_begin_catch(i8*)

declare void @_ZSt9terminatev()

; Function Attrs: noinline nounwind optnone
define internal i32 @_ZN10__cxxabiv1L24get_cxa_exception_offsetEv() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 16, i32* %1, align 4
  store i32 80, i32* %2, align 4
  store i32 80, i32* %3, align 4
  store i32 0, i32* %4, align 4
  ret i32 0
}

declare hidden i8* @_ZN10__cxxabiv130__aligned_malloc_with_fallbackEm(i32) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i1) #4

; Function Attrs: noinline nounwind optnone
define internal i8* @_ZN10__cxxabiv1L32thrown_object_from_cxa_exceptionEPNS_15__cxa_exceptionE(%"struct.__cxxabiv1::__cxa_exception"*) #0 {
  %2 = alloca %"struct.__cxxabiv1::__cxa_exception"*, align 4
  store %"struct.__cxxabiv1::__cxa_exception"* %0, %"struct.__cxxabiv1::__cxa_exception"** %2, align 4
  %3 = load %"struct.__cxxabiv1::__cxa_exception"*, %"struct.__cxxabiv1::__cxa_exception"** %2, align 4
  %4 = getelementptr inbounds %"struct.__cxxabiv1::__cxa_exception", %"struct.__cxxabiv1::__cxa_exception"* %3, i32 1
  %5 = bitcast %"struct.__cxxabiv1::__cxa_exception"* %4 to i8*
  ret i8* %5
}

; Function Attrs: noinline nounwind optnone
define hidden i8* @memset(i8*, i32, i32) #0 {
  %4 = alloca i8*, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8*, align 4
  store i8* %0, i8** %4, align 4
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %8 = load i8*, i8** %4, align 4
  store i8* %8, i8** %7, align 4
  br label %9

; <label>:9:                                      ; preds = %13, %3
  %10 = load i32, i32* %6, align 4
  %11 = add i32 %10, -1
  store i32 %11, i32* %6, align 4
  %12 = icmp ne i32 %10, 0
  br i1 %12, label %13, label %18

; <label>:13:                                     ; preds = %9
  %14 = load i32, i32* %5, align 4
  %15 = trunc i32 %14 to i8
  %16 = load i8*, i8** %7, align 4
  %17 = getelementptr inbounds i8, i8* %16, i32 1
  store i8* %17, i8** %7, align 4
  store i8 %15, i8* %16, align 1
  br label %9

; <label>:18:                                     ; preds = %9
  %19 = load i8*, i8** %4, align 4
  ret i8* %19
}

; Function Attrs: noinline optnone
define hidden i32 @posix_memalign(i8**, i32, i32) #1 {
  %4 = alloca i8**, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8** %0, i8*** %4, align 4
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %7 = load i32, i32* %6, align 4
  %8 = call i8* @malloc(i32 %7)
  %9 = load i8**, i8*** %4, align 4
  store i8* %8, i8** %9, align 4
  ret i32 0
}

declare i8* @malloc(i32) #3

; Function Attrs: noinline nounwind optnone
define internal i32 @_ZN10__cxxabiv1L23aligned_allocation_sizeEmm(i32, i32) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %3, align 4
  %6 = load i32, i32* %4, align 4
  %7 = add i32 %5, %6
  %8 = sub i32 %7, 1
  %9 = load i32, i32* %4, align 4
  %10 = sub i32 %9, 1
  %11 = xor i32 %10, -1
  %12 = and i32 %8, %11
  ret i32 %12
}

attributes #0 = { noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { noinline optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noinline noreturn nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { argmemonly nounwind }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 8.0.0-3~ubuntu18.04.2 (tags/RELEASE_800/final)"}
