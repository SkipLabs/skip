; ModuleID = 'fallback_malloc.bc'
source_filename = "fallback_malloc.cpp"
target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32"

%"struct.(anonymous namespace)::heap_node" = type { i16, i16 }
%"class.(anonymous namespace)::mutexor" = type { i8 }

@_ZN12_GLOBAL__N_110heap_mutexE = internal global i8* null, align 4
@_ZN12_GLOBAL__N_18freelistE = internal global %"struct.(anonymous namespace)::heap_node"* null, align 4
@_ZN12_GLOBAL__N_18list_endE = internal global %"struct.(anonymous namespace)::heap_node"* bitcast (i8* getelementptr (i8, i8* getelementptr inbounds ([512 x i8], [512 x i8]* @_ZN12_GLOBAL__N_14heapE, i32 0, i32 0), i64 512) to %"struct.(anonymous namespace)::heap_node"*), align 4
@_ZN12_GLOBAL__N_14heapE = internal global [512 x i8] zeroinitializer, align 16

; Function Attrs: noinline optnone
define hidden i8* @_ZN10__cxxabiv130__aligned_malloc_with_fallbackEm(i32) #0 {
  %2 = alloca i8*, align 4
  %3 = alloca i32, align 4
  %4 = alloca i8*, align 4
  store i32 %0, i32* %3, align 4
  %5 = load i32, i32* %3, align 4
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %8

; <label>:7:                                      ; preds = %1
  store i32 1, i32* %3, align 4
  br label %8

; <label>:8:                                      ; preds = %7, %1
  %9 = load i32, i32* %3, align 4
  %10 = call i32 @posix_memalign(i8** %4, i32 16, i32 %9)
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %12, label %14

; <label>:12:                                     ; preds = %8
  %13 = load i8*, i8** %4, align 4
  store i8* %13, i8** %2, align 4
  br label %17

; <label>:14:                                     ; preds = %8
  %15 = load i32, i32* %3, align 4
  %16 = call i8* @_ZN12_GLOBAL__N_115fallback_mallocEm(i32 %15)
  store i8* %16, i8** %2, align 4
  br label %17

; <label>:17:                                     ; preds = %14, %12
  %18 = load i8*, i8** %2, align 4
  ret i8* %18
}

declare i32 @posix_memalign(i8**, i32, i32) #1

; Function Attrs: noinline optnone
define internal i8* @_ZN12_GLOBAL__N_115fallback_mallocEm(i32) #0 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
  %2 = alloca i8*, align 4
  %3 = alloca i32, align 4
  %4 = alloca %"struct.(anonymous namespace)::heap_node"*, align 4
  %5 = alloca %"struct.(anonymous namespace)::heap_node"*, align 4
  %6 = alloca i32, align 4
  %7 = alloca %"class.(anonymous namespace)::mutexor", align 1
  %8 = alloca i8*
  %9 = alloca i32
  %10 = alloca %"struct.(anonymous namespace)::heap_node"*, align 4
  %11 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %12 = load i32, i32* %3, align 4
  %13 = call i32 @_ZN12_GLOBAL__N_110alloc_sizeEm(i32 %12)
  store i32 %13, i32* %6, align 4
  %14 = call %"class.(anonymous namespace)::mutexor"* @_ZN12_GLOBAL__N_17mutexorC2EPv(%"class.(anonymous namespace)::mutexor"* %7, i8* bitcast (i8** @_ZN12_GLOBAL__N_110heap_mutexE to i8*))
  %15 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18freelistE, align 4
  %16 = icmp eq %"struct.(anonymous namespace)::heap_node"* null, %15
  br i1 %16, label %17, label %24

; <label>:17:                                     ; preds = %1
  invoke void @_ZN12_GLOBAL__N_19init_heapEv()
          to label %18 unwind label %19

; <label>:18:                                     ; preds = %17
  br label %24

; <label>:19:                                     ; preds = %96, %77, %17
  %20 = landingpad { i8*, i32 }
          cleanup
  %21 = extractvalue { i8*, i32 } %20, 0
  store i8* %21, i8** %8, align 4
  %22 = extractvalue { i8*, i32 } %20, 1
  store i32 %22, i32* %9, align 4
  %23 = call %"class.(anonymous namespace)::mutexor"* @_ZN12_GLOBAL__N_17mutexorD2Ev(%"class.(anonymous namespace)::mutexor"* %7) #4
  br label %107

; <label>:24:                                     ; preds = %18, %1
  %25 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18freelistE, align 4
  store %"struct.(anonymous namespace)::heap_node"* %25, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  store %"struct.(anonymous namespace)::heap_node"* null, %"struct.(anonymous namespace)::heap_node"** %5, align 4
  br label %26

; <label>:26:                                     ; preds = %102, %24
  %27 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %28 = icmp ne %"struct.(anonymous namespace)::heap_node"* %27, null
  br i1 %28, label %29, label %33

; <label>:29:                                     ; preds = %26
  %30 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %31 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18list_endE, align 4
  %32 = icmp ne %"struct.(anonymous namespace)::heap_node"* %30, %31
  br label %33

; <label>:33:                                     ; preds = %29, %26
  %34 = phi i1 [ false, %26 ], [ %32, %29 ]
  br i1 %34, label %35, label %103

; <label>:35:                                     ; preds = %33
  %36 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %37 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %36, i32 0, i32 1
  %38 = load i16, i16* %37, align 2
  %39 = zext i16 %38 to i32
  %40 = load i32, i32* %6, align 4
  %41 = icmp ugt i32 %39, %40
  br i1 %41, label %42, label %67

; <label>:42:                                     ; preds = %35
  %43 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %44 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %43, i32 0, i32 1
  %45 = load i16, i16* %44, align 2
  %46 = zext i16 %45 to i32
  %47 = load i32, i32* %6, align 4
  %48 = sub i32 %46, %47
  %49 = trunc i32 %48 to i16
  %50 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %51 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %50, i32 0, i32 1
  store i16 %49, i16* %51, align 2
  %52 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %53 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %54 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %53, i32 0, i32 1
  %55 = load i16, i16* %54, align 2
  %56 = zext i16 %55 to i32
  %57 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %52, i32 %56
  store %"struct.(anonymous namespace)::heap_node"* %57, %"struct.(anonymous namespace)::heap_node"** %10, align 4
  %58 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %10, align 4
  %59 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %58, i32 0, i32 0
  store i16 0, i16* %59, align 2
  %60 = load i32, i32* %6, align 4
  %61 = trunc i32 %60 to i16
  %62 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %10, align 4
  %63 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %62, i32 0, i32 1
  store i16 %61, i16* %63, align 2
  %64 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %10, align 4
  %65 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %64, i32 1
  %66 = bitcast %"struct.(anonymous namespace)::heap_node"* %65 to i8*
  store i8* %66, i8** %2, align 4
  store i32 1, i32* %11, align 4
  br label %104

; <label>:67:                                     ; preds = %35
  %68 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %69 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %68, i32 0, i32 1
  %70 = load i16, i16* %69, align 2
  %71 = zext i16 %70 to i32
  %72 = load i32, i32* %6, align 4
  %73 = icmp eq i32 %71, %72
  br i1 %73, label %74, label %95

; <label>:74:                                     ; preds = %67
  %75 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %5, align 4
  %76 = icmp eq %"struct.(anonymous namespace)::heap_node"* %75, null
  br i1 %76, label %77, label %83

; <label>:77:                                     ; preds = %74
  %78 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %79 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %78, i32 0, i32 0
  %80 = load i16, i16* %79, align 2
  %81 = invoke %"struct.(anonymous namespace)::heap_node"* @_ZN12_GLOBAL__N_116node_from_offsetEt(i16 zeroext %80)
          to label %82 unwind label %19

; <label>:82:                                     ; preds = %77
  store %"struct.(anonymous namespace)::heap_node"* %81, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18freelistE, align 4
  br label %89

; <label>:83:                                     ; preds = %74
  %84 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %85 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %84, i32 0, i32 0
  %86 = load i16, i16* %85, align 2
  %87 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %5, align 4
  %88 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %87, i32 0, i32 0
  store i16 %86, i16* %88, align 2
  br label %89

; <label>:89:                                     ; preds = %83, %82
  %90 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %91 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %90, i32 0, i32 0
  store i16 0, i16* %91, align 2
  %92 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %93 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %92, i32 1
  %94 = bitcast %"struct.(anonymous namespace)::heap_node"* %93 to i8*
  store i8* %94, i8** %2, align 4
  store i32 1, i32* %11, align 4
  br label %104

; <label>:95:                                     ; preds = %67
  br label %96

; <label>:96:                                     ; preds = %95
  %97 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  store %"struct.(anonymous namespace)::heap_node"* %97, %"struct.(anonymous namespace)::heap_node"** %5, align 4
  %98 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %99 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %98, i32 0, i32 0
  %100 = load i16, i16* %99, align 2
  %101 = invoke %"struct.(anonymous namespace)::heap_node"* @_ZN12_GLOBAL__N_116node_from_offsetEt(i16 zeroext %100)
          to label %102 unwind label %19

; <label>:102:                                    ; preds = %96
  store %"struct.(anonymous namespace)::heap_node"* %101, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  br label %26

; <label>:103:                                    ; preds = %33
  store i8* null, i8** %2, align 4
  store i32 1, i32* %11, align 4
  br label %104

; <label>:104:                                    ; preds = %103, %89, %42
  %105 = call %"class.(anonymous namespace)::mutexor"* @_ZN12_GLOBAL__N_17mutexorD2Ev(%"class.(anonymous namespace)::mutexor"* %7) #4
  %106 = load i8*, i8** %2, align 4
  ret i8* %106

; <label>:107:                                    ; preds = %19
  %108 = load i8*, i8** %8, align 4
  %109 = load i32, i32* %9, align 4
  %110 = insertvalue { i8*, i32 } undef, i8* %108, 0
  %111 = insertvalue { i8*, i32 } %110, i32 %109, 1
  resume { i8*, i32 } %111
}

; Function Attrs: noinline optnone
define hidden i8* @_ZN10__cxxabiv122__calloc_with_fallbackEmm(i32, i32) #0 {
  %3 = alloca i8*, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i8*, align 4
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  %7 = load i32, i32* %4, align 4
  %8 = load i32, i32* %5, align 4
  %9 = call i8* @calloc(i32 %7, i32 %8)
  store i8* %9, i8** %6, align 4
  %10 = load i8*, i8** %6, align 4
  %11 = icmp ne i8* null, %10
  br i1 %11, label %12, label %14

; <label>:12:                                     ; preds = %2
  %13 = load i8*, i8** %6, align 4
  store i8* %13, i8** %3, align 4
  br label %28

; <label>:14:                                     ; preds = %2
  %15 = load i32, i32* %5, align 4
  %16 = load i32, i32* %4, align 4
  %17 = mul i32 %15, %16
  %18 = call i8* @_ZN12_GLOBAL__N_115fallback_mallocEm(i32 %17)
  store i8* %18, i8** %6, align 4
  %19 = load i8*, i8** %6, align 4
  %20 = icmp ne i8* null, %19
  br i1 %20, label %21, label %26

; <label>:21:                                     ; preds = %14
  %22 = load i8*, i8** %6, align 4
  %23 = load i32, i32* %5, align 4
  %24 = load i32, i32* %4, align 4
  %25 = mul i32 %23, %24
  call void @llvm.memset.p0i8.i32(i8* align 1 %22, i8 0, i32 %25, i1 false)
  br label %26

; <label>:26:                                     ; preds = %21, %14
  %27 = load i8*, i8** %6, align 4
  store i8* %27, i8** %3, align 4
  br label %28

; <label>:28:                                     ; preds = %26, %12
  %29 = load i8*, i8** %3, align 4
  ret i8* %29
}

declare i8* @calloc(i32, i32) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i1) #2

; Function Attrs: noinline optnone
define hidden void @_ZN10__cxxabiv128__aligned_free_with_fallbackEPv(i8*) #0 {
  %2 = alloca i8*, align 4
  store i8* %0, i8** %2, align 4
  %3 = load i8*, i8** %2, align 4
  %4 = call zeroext i1 @_ZN12_GLOBAL__N_115is_fallback_ptrEPv(i8* %3)
  br i1 %4, label %5, label %7

; <label>:5:                                      ; preds = %1
  %6 = load i8*, i8** %2, align 4
  call void @_ZN12_GLOBAL__N_113fallback_freeEPv(i8* %6)
  br label %9

; <label>:7:                                      ; preds = %1
  %8 = load i8*, i8** %2, align 4
  call void @free(i8* %8)
  br label %9

; <label>:9:                                      ; preds = %7, %5
  ret void
}

; Function Attrs: noinline nounwind optnone
define internal zeroext i1 @_ZN12_GLOBAL__N_115is_fallback_ptrEPv(i8*) #3 {
  %2 = alloca i8*, align 4
  store i8* %0, i8** %2, align 4
  %3 = load i8*, i8** %2, align 4
  %4 = icmp uge i8* %3, getelementptr inbounds ([512 x i8], [512 x i8]* @_ZN12_GLOBAL__N_14heapE, i32 0, i32 0)
  br i1 %4, label %5, label %8

; <label>:5:                                      ; preds = %1
  %6 = load i8*, i8** %2, align 4
  %7 = icmp ult i8* %6, getelementptr inbounds (i8, i8* getelementptr inbounds ([512 x i8], [512 x i8]* @_ZN12_GLOBAL__N_14heapE, i32 0, i32 0), i32 512)
  br label %8

; <label>:8:                                      ; preds = %5, %1
  %9 = phi i1 [ false, %1 ], [ %7, %5 ]
  ret i1 %9
}

; Function Attrs: noinline optnone
define internal void @_ZN12_GLOBAL__N_113fallback_freeEPv(i8*) #0 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
  %2 = alloca i8*, align 4
  %3 = alloca %"struct.(anonymous namespace)::heap_node"*, align 4
  %4 = alloca %"struct.(anonymous namespace)::heap_node"*, align 4
  %5 = alloca %"struct.(anonymous namespace)::heap_node"*, align 4
  %6 = alloca %"class.(anonymous namespace)::mutexor", align 1
  %7 = alloca i8*
  %8 = alloca i32
  %9 = alloca i32, align 4
  store i8* %0, i8** %2, align 4
  %10 = load i8*, i8** %2, align 4
  %11 = bitcast i8* %10 to %"struct.(anonymous namespace)::heap_node"*
  %12 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %11, i32 -1
  store %"struct.(anonymous namespace)::heap_node"* %12, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  %13 = call %"class.(anonymous namespace)::mutexor"* @_ZN12_GLOBAL__N_17mutexorC2EPv(%"class.(anonymous namespace)::mutexor"* %6, i8* bitcast (i8** @_ZN12_GLOBAL__N_110heap_mutexE to i8*))
  %14 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18freelistE, align 4
  store %"struct.(anonymous namespace)::heap_node"* %14, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  store %"struct.(anonymous namespace)::heap_node"* null, %"struct.(anonymous namespace)::heap_node"** %5, align 4
  br label %15

; <label>:15:                                     ; preds = %91, %1
  %16 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %17 = icmp ne %"struct.(anonymous namespace)::heap_node"* %16, null
  br i1 %17, label %18, label %22

; <label>:18:                                     ; preds = %15
  %19 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %20 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18list_endE, align 4
  %21 = icmp ne %"struct.(anonymous namespace)::heap_node"* %19, %20
  br label %22

; <label>:22:                                     ; preds = %18, %15
  %23 = phi i1 [ false, %15 ], [ %21, %18 ]
  br i1 %23, label %24, label %92

; <label>:24:                                     ; preds = %22
  %25 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %26 = invoke %"struct.(anonymous namespace)::heap_node"* @_ZN12_GLOBAL__N_15afterEPNS_9heap_nodeE(%"struct.(anonymous namespace)::heap_node"* %25)
          to label %27 unwind label %43

; <label>:27:                                     ; preds = %24
  %28 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  %29 = icmp eq %"struct.(anonymous namespace)::heap_node"* %26, %28
  br i1 %29, label %30, label %48

; <label>:30:                                     ; preds = %27
  %31 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %32 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %31, i32 0, i32 1
  %33 = load i16, i16* %32, align 2
  %34 = zext i16 %33 to i32
  %35 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  %36 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %35, i32 0, i32 1
  %37 = load i16, i16* %36, align 2
  %38 = zext i16 %37 to i32
  %39 = add nsw i32 %34, %38
  %40 = trunc i32 %39 to i16
  %41 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %42 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %41, i32 0, i32 1
  store i16 %40, i16* %42, align 2
  store i32 1, i32* %9, align 4
  br label %99

; <label>:43:                                     ; preds = %92, %85, %76, %48, %24
  %44 = landingpad { i8*, i32 }
          cleanup
  %45 = extractvalue { i8*, i32 } %44, 0
  store i8* %45, i8** %7, align 4
  %46 = extractvalue { i8*, i32 } %44, 1
  store i32 %46, i32* %8, align 4
  %47 = call %"class.(anonymous namespace)::mutexor"* @_ZN12_GLOBAL__N_17mutexorD2Ev(%"class.(anonymous namespace)::mutexor"* %6) #4
  br label %103

; <label>:48:                                     ; preds = %27
  %49 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  %50 = invoke %"struct.(anonymous namespace)::heap_node"* @_ZN12_GLOBAL__N_15afterEPNS_9heap_nodeE(%"struct.(anonymous namespace)::heap_node"* %49)
          to label %51 unwind label %43

; <label>:51:                                     ; preds = %48
  %52 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %53 = icmp eq %"struct.(anonymous namespace)::heap_node"* %50, %52
  br i1 %53, label %54, label %83

; <label>:54:                                     ; preds = %51
  %55 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  %56 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %55, i32 0, i32 1
  %57 = load i16, i16* %56, align 2
  %58 = zext i16 %57 to i32
  %59 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %60 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %59, i32 0, i32 1
  %61 = load i16, i16* %60, align 2
  %62 = zext i16 %61 to i32
  %63 = add nsw i32 %58, %62
  %64 = trunc i32 %63 to i16
  %65 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  %66 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %65, i32 0, i32 1
  store i16 %64, i16* %66, align 2
  %67 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %5, align 4
  %68 = icmp eq %"struct.(anonymous namespace)::heap_node"* %67, null
  br i1 %68, label %69, label %76

; <label>:69:                                     ; preds = %54
  %70 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  store %"struct.(anonymous namespace)::heap_node"* %70, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18freelistE, align 4
  %71 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %72 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %71, i32 0, i32 0
  %73 = load i16, i16* %72, align 2
  %74 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  %75 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %74, i32 0, i32 0
  store i16 %73, i16* %75, align 2
  br label %82

; <label>:76:                                     ; preds = %54
  %77 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  %78 = invoke zeroext i16 @_ZN12_GLOBAL__N_116offset_from_nodeEPKNS_9heap_nodeE(%"struct.(anonymous namespace)::heap_node"* %77)
          to label %79 unwind label %43

; <label>:79:                                     ; preds = %76
  %80 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %5, align 4
  %81 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %80, i32 0, i32 0
  store i16 %78, i16* %81, align 2
  br label %82

; <label>:82:                                     ; preds = %79, %69
  store i32 1, i32* %9, align 4
  br label %99

; <label>:83:                                     ; preds = %51
  br label %84

; <label>:84:                                     ; preds = %83
  br label %85

; <label>:85:                                     ; preds = %84
  %86 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  store %"struct.(anonymous namespace)::heap_node"* %86, %"struct.(anonymous namespace)::heap_node"** %5, align 4
  %87 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  %88 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %87, i32 0, i32 0
  %89 = load i16, i16* %88, align 2
  %90 = invoke %"struct.(anonymous namespace)::heap_node"* @_ZN12_GLOBAL__N_116node_from_offsetEt(i16 zeroext %89)
          to label %91 unwind label %43

; <label>:91:                                     ; preds = %85
  store %"struct.(anonymous namespace)::heap_node"* %90, %"struct.(anonymous namespace)::heap_node"** %4, align 4
  br label %15

; <label>:92:                                     ; preds = %22
  %93 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18freelistE, align 4
  %94 = invoke zeroext i16 @_ZN12_GLOBAL__N_116offset_from_nodeEPKNS_9heap_nodeE(%"struct.(anonymous namespace)::heap_node"* %93)
          to label %95 unwind label %43

; <label>:95:                                     ; preds = %92
  %96 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  %97 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %96, i32 0, i32 0
  store i16 %94, i16* %97, align 2
  %98 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %3, align 4
  store %"struct.(anonymous namespace)::heap_node"* %98, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18freelistE, align 4
  store i32 0, i32* %9, align 4
  br label %99

; <label>:99:                                     ; preds = %95, %82, %30
  %100 = call %"class.(anonymous namespace)::mutexor"* @_ZN12_GLOBAL__N_17mutexorD2Ev(%"class.(anonymous namespace)::mutexor"* %6) #4
  %101 = load i32, i32* %9, align 4
  switch i32 %101, label %108 [
    i32 0, label %102
    i32 1, label %102
  ]

; <label>:102:                                    ; preds = %99, %99
  ret void

; <label>:103:                                    ; preds = %43
  %104 = load i8*, i8** %7, align 4
  %105 = load i32, i32* %8, align 4
  %106 = insertvalue { i8*, i32 } undef, i8* %104, 0
  %107 = insertvalue { i8*, i32 } %106, i32 %105, 1
  resume { i8*, i32 } %107

; <label>:108:                                    ; preds = %99
  unreachable
}

declare void @free(i8*) #1

; Function Attrs: noinline optnone
define hidden void @_ZN10__cxxabiv120__free_with_fallbackEPv(i8*) #0 {
  %2 = alloca i8*, align 4
  store i8* %0, i8** %2, align 4
  %3 = load i8*, i8** %2, align 4
  %4 = call zeroext i1 @_ZN12_GLOBAL__N_115is_fallback_ptrEPv(i8* %3)
  br i1 %4, label %5, label %7

; <label>:5:                                      ; preds = %1
  %6 = load i8*, i8** %2, align 4
  call void @_ZN12_GLOBAL__N_113fallback_freeEPv(i8* %6)
  br label %9

; <label>:7:                                      ; preds = %1
  %8 = load i8*, i8** %2, align 4
  call void @free(i8* %8)
  br label %9

; <label>:9:                                      ; preds = %7, %5
  ret void
}

; Function Attrs: noinline nounwind optnone
define internal i32 @_ZN12_GLOBAL__N_110alloc_sizeEm(i32) #3 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = add i32 %3, 4
  %5 = sub i32 %4, 1
  %6 = udiv i32 %5, 4
  %7 = add i32 %6, 1
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone
define internal %"class.(anonymous namespace)::mutexor"* @_ZN12_GLOBAL__N_17mutexorC2EPv(%"class.(anonymous namespace)::mutexor"* returned, i8*) unnamed_addr #3 {
  %3 = alloca %"class.(anonymous namespace)::mutexor"*, align 4
  %4 = alloca i8*, align 4
  store %"class.(anonymous namespace)::mutexor"* %0, %"class.(anonymous namespace)::mutexor"** %3, align 4
  store i8* %1, i8** %4, align 4
  %5 = load %"class.(anonymous namespace)::mutexor"*, %"class.(anonymous namespace)::mutexor"** %3, align 4
  ret %"class.(anonymous namespace)::mutexor"* %5
}

; Function Attrs: noinline optnone
define internal void @_ZN12_GLOBAL__N_19init_heapEv() #0 {
  store %"struct.(anonymous namespace)::heap_node"* bitcast ([512 x i8]* @_ZN12_GLOBAL__N_14heapE to %"struct.(anonymous namespace)::heap_node"*), %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18freelistE, align 4
  %1 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18list_endE, align 4
  %2 = call zeroext i16 @_ZN12_GLOBAL__N_116offset_from_nodeEPKNS_9heap_nodeE(%"struct.(anonymous namespace)::heap_node"* %1)
  %3 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18freelistE, align 4
  %4 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %3, i32 0, i32 0
  store i16 %2, i16* %4, align 2
  %5 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** @_ZN12_GLOBAL__N_18freelistE, align 4
  %6 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %5, i32 0, i32 1
  store i16 128, i16* %6, align 2
  ret void
}

declare i32 @__gxx_personality_v0(...)

; Function Attrs: noinline nounwind optnone
define internal %"struct.(anonymous namespace)::heap_node"* @_ZN12_GLOBAL__N_116node_from_offsetEt(i16 zeroext) #3 {
  %2 = alloca i16, align 2
  store i16 %0, i16* %2, align 2
  %3 = load i16, i16* %2, align 2
  %4 = zext i16 %3 to i32
  %5 = mul i32 %4, 4
  %6 = getelementptr inbounds i8, i8* getelementptr inbounds ([512 x i8], [512 x i8]* @_ZN12_GLOBAL__N_14heapE, i32 0, i32 0), i32 %5
  %7 = bitcast i8* %6 to %"struct.(anonymous namespace)::heap_node"*
  ret %"struct.(anonymous namespace)::heap_node"* %7
}

; Function Attrs: noinline nounwind optnone
define internal %"class.(anonymous namespace)::mutexor"* @_ZN12_GLOBAL__N_17mutexorD2Ev(%"class.(anonymous namespace)::mutexor"* returned) unnamed_addr #3 {
  %2 = alloca %"class.(anonymous namespace)::mutexor"*, align 4
  store %"class.(anonymous namespace)::mutexor"* %0, %"class.(anonymous namespace)::mutexor"** %2, align 4
  %3 = load %"class.(anonymous namespace)::mutexor"*, %"class.(anonymous namespace)::mutexor"** %2, align 4
  ret %"class.(anonymous namespace)::mutexor"* %3
}

; Function Attrs: noinline nounwind optnone
define internal zeroext i16 @_ZN12_GLOBAL__N_116offset_from_nodeEPKNS_9heap_nodeE(%"struct.(anonymous namespace)::heap_node"*) #3 {
  %2 = alloca %"struct.(anonymous namespace)::heap_node"*, align 4
  store %"struct.(anonymous namespace)::heap_node"* %0, %"struct.(anonymous namespace)::heap_node"** %2, align 4
  %3 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %2, align 4
  %4 = bitcast %"struct.(anonymous namespace)::heap_node"* %3 to i8*
  %5 = ptrtoint i8* %4 to i32
  %6 = sub i32 %5, ptrtoint ([512 x i8]* @_ZN12_GLOBAL__N_14heapE to i32)
  %7 = udiv i32 %6, 4
  %8 = trunc i32 %7 to i16
  ret i16 %8
}

; Function Attrs: noinline nounwind optnone
define internal %"struct.(anonymous namespace)::heap_node"* @_ZN12_GLOBAL__N_15afterEPNS_9heap_nodeE(%"struct.(anonymous namespace)::heap_node"*) #3 {
  %2 = alloca %"struct.(anonymous namespace)::heap_node"*, align 4
  store %"struct.(anonymous namespace)::heap_node"* %0, %"struct.(anonymous namespace)::heap_node"** %2, align 4
  %3 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %2, align 4
  %4 = load %"struct.(anonymous namespace)::heap_node"*, %"struct.(anonymous namespace)::heap_node"** %2, align 4
  %5 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %4, i32 0, i32 1
  %6 = load i16, i16* %5, align 2
  %7 = zext i16 %6 to i32
  %8 = getelementptr inbounds %"struct.(anonymous namespace)::heap_node", %"struct.(anonymous namespace)::heap_node"* %3, i32 %7
  ret %"struct.(anonymous namespace)::heap_node"* %8
}

attributes #0 = { noinline optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { argmemonly nounwind }
attributes #3 = { noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 8.0.0-3~ubuntu18.04.2 (tags/RELEASE_800/final)"}
