// RUN: tco %s | FileCheck %s

// expected fail until more upstreaming is completed
// XFAIL: *

// CHECK-LABEL: define void @_QPtest_proc_dummy()
// CHECK:         %[[VAL_0:.*]] = alloca i32, i64 1, align 4
// CHECK:         %[[VAL_1:.*]] = alloca { i32* }, i64 1, align 8
// CHECK:         %[[VAL_2:.*]] = getelementptr { i32* }, { i32* }* %[[VAL_1]], i64 0, i32 0
// CHECK:         store i32* %[[VAL_0]], i32** %[[VAL_2]], align 8
// CHECK:         store i32 1, i32* %[[VAL_0]], align 4
// CHECK:         %[[VAL_3:.*]] = alloca [32 x i8], i64 1, align 1
// CHECK:         %[[VAL_4:.*]] = bitcast { i32* }* %[[VAL_1]] to i8*
// CHECK:         %[[VAL_5:.*]] = bitcast [32 x i8]* %[[VAL_3]] to i8*
// CHECK:         call void @llvm.init.trampoline(i8* %[[VAL_5]], i8* bitcast (void (i32*, { i32* }*)* @_QFtest_proc_dummyPtest_proc_dummy_a to i8*), i8* %[[VAL_4]])
// CHECK:         %[[VAL_6:.*]] = call i8* @llvm.adjust.trampoline(i8* %[[VAL_5]])
// CHECK:         %[[VAL_7:.*]] = bitcast i8* %[[VAL_6]] to void ()*
// CHECK:         call void @_QPtest_proc_dummy_other(void ()* %[[VAL_7]])

// CHECK-LABEL: define void @_QFtest_proc_dummyPtest_proc_dummy_a(i32*
// CHECK-SAME:              %[[VAL_0:.*]], { i32* }* nest %[[VAL_1:.*]])

// CHECK-LABEL: define void @_QPtest_proc_dummy_other(void ()*
// CHECK-SAME:              %[[VAL_0:.*]])
// CHECK:         %[[VAL_1:.*]] = alloca i32, i64 1, align 4
// CHECK:         store i32 4, i32* %[[VAL_1]], align 4
// CHECK:         %[[VAL_2:.*]] = bitcast void ()* %[[VAL_0]] to void (i32*)*
// CHECK:         call void %[[VAL_2]](i32* %[[VAL_1]])

func @_QPtest_proc_dummy() {
  %c0_i32 = arith.constant 0 : i32
  %c1_i32 = arith.constant 1 : i32
  %c-1_i32 = arith.constant -1 : i32
  %c5_i32 = arith.constant 5 : i32
  %0 = fir.alloca i32 {bindc_name = "i", uniq_name = "_QFtest_proc_dummyEi"}
  %1 = fir.alloca tuple<!fir.ref<i32>>
  %2 = fir.coordinate_of %1, %c0_i32 : (!fir.ref<tuple<!fir.ref<i32>>>, i32) -> !fir.llvm_ptr<!fir.ref<i32>>
  fir.store %0 to %2 : !fir.llvm_ptr<!fir.ref<i32>>
  fir.store %c1_i32 to %0 : !fir.ref<i32>
  %3 = fir.address_of(@_QFtest_proc_dummyPtest_proc_dummy_a) : (!fir.ref<i32>, !fir.ref<tuple<!fir.ref<i32>>>) -> ()
  %4 = fir.emboxproc %3, %1 : ((!fir.ref<i32>, !fir.ref<tuple<!fir.ref<i32>>>) -> (), !fir.ref<tuple<!fir.ref<i32>>>) -> !fir.boxproc<() -> ()>
  fir.call @_QPtest_proc_dummy_other(%4) : (!fir.boxproc<() -> ()>) -> ()
  %5 = fir.address_of(@_QQcl.2E2F682E66393000) : !fir.ref<!fir.char<1,8>>
  %6 = fir.convert %5 : (!fir.ref<!fir.char<1,8>>) -> !fir.ref<i8>
  %7 = fir.call @_FortranAioBeginExternalListOutput(%c-1_i32, %6, %c5_i32) : (i32, !fir.ref<i8>, i32) -> !fir.ref<i8>
  %8 = fir.load %0 : !fir.ref<i32>
  %9 = fir.call @_FortranAioOutputInteger32(%7, %8) : (!fir.ref<i8>, i32) -> i1
  %10 = fir.call @_FortranAioEndIoStatement(%7) : (!fir.ref<i8>) -> i32
  return
}
func @_QFtest_proc_dummyPtest_proc_dummy_a(%arg0: !fir.ref<i32> {fir.bindc_name = "j"}, %arg1: !fir.ref<tuple<!fir.ref<i32>>> {fir.host_assoc}) {
  %c0_i32 = arith.constant 0 : i32
  %0 = fir.coordinate_of %arg1, %c0_i32 : (!fir.ref<tuple<!fir.ref<i32>>>, i32) -> !fir.llvm_ptr<!fir.ref<i32>>
  %1 = fir.load %0 : !fir.llvm_ptr<!fir.ref<i32>>
  %2 = fir.load %1 : !fir.ref<i32>
  %3 = fir.load %arg0 : !fir.ref<i32>
  %4 = arith.addi %2, %3 : i32
  fir.store %4 to %1 : !fir.ref<i32>
  return
}
func @_QPtest_proc_dummy_other(%arg0: !fir.boxproc<() -> ()>) {
  %c4_i32 = arith.constant 4 : i32
  %0 = fir.alloca i32 {adapt.valuebyref}
  fir.store %c4_i32 to %0 : !fir.ref<i32>
  %1 = fir.box_addr %arg0 : (!fir.boxproc<() -> ()>) -> ((!fir.ref<i32>) -> ())
  fir.call %1(%0) : (!fir.ref<i32>) -> ()
  return
}

// CHECK-LABEL: define void @_QPtest_proc_dummy_char()
// CHECK:         %[[VAL_0:.*]] = alloca [40 x i8], i64 1, align 1
// CHECK:         %[[VAL_1:.*]] = alloca [10 x i8], i64 1, align 1
// CHECK:         %[[VAL_2:.*]] = alloca { { i8*, i64 } }, i64 1, align 8
// CHECK:         %[[VAL_3:.*]] = getelementptr { { i8*, i64 } }, { { i8*, i64 } }* %[[VAL_2]], i64 0, i32 0
// CHECK:         %[[VAL_4:.*]] = bitcast [10 x i8]* %[[VAL_1]] to i8*
// CHECK:         %[[VAL_5:.*]] = insertvalue { i8*, i64 } undef, i8* %[[VAL_4]], 0
// CHECK:         %[[VAL_6:.*]] = insertvalue { i8*, i64 } %[[VAL_5]], i64 10, 1
// CHECK:         store { i8*, i64 } %[[VAL_6]], { i8*, i64 }* %[[VAL_3]], align 8
// CHECK:         %[[VAL_7:.*]] = bitcast [10 x i8]* %[[VAL_1]] to i8*
// CHECK:         call void @llvm.memmove.p0i8.p0i8.i64(i8* %[[VAL_7]], i8* getelementptr inbounds ([9 x i8], [9 x i8]*
// CHECK:         br label %[[VAL_8:.*]]
// CHECK:         %[[VAL_11:.*]] = phi 
// CHECK:         %[[VAL_13:.*]] = phi 
// CHECK:         %[[VAL_15:.*]] = icmp sgt i64 %[[VAL_13]], 0
// CHECK:         %[[VAL_17:.*]] = bitcast [10 x i8]* %[[VAL_1]] to [10 x [1 x i8]]*
// CHECK:         %[[VAL_18:.*]] = getelementptr [10 x [1 x i8]], [10 x [1 x i8]]* %[[VAL_17]], i64 0, i64 %[[VAL_11]]
// CHECK:         store [1 x i8] c" ", [1 x i8]* %[[VAL_18]], align 1
// CHECK:         %[[VAL_20:.*]] = alloca [32 x i8], i64 1, align 1
// CHECK:         %[[VAL_21:.*]] = bitcast { { i8*, i64 } }* %[[VAL_2]] to i8*
// CHECK:         %[[VAL_22:.*]] = bitcast [32 x i8]* %[[VAL_20]] to i8*
// CHECK:         call void @llvm.init.trampoline(i8* %[[VAL_22]], i8* bitcast ({ i8*, i64 } ([10 x i8]*, i64, { { i8*, i64 } }*)* @_QFtest_proc_dummy_charPgen_message to i8*), i8* %[[VAL_21]])
// CHECK:         %[[VAL_23:.*]] = call i8* @llvm.adjust.trampoline(i8* %[[VAL_22]])
// CHECK:         %[[VAL_24:.*]] = bitcast i8* %[[VAL_23]] to void ()*
// CHECK:         %[[VAL_25:.*]] = insertvalue { void ()*, i64 } undef, void ()* %[[VAL_24]], 0
// CHECK:         %[[VAL_26:.*]] = insertvalue { void ()*, i64 } %[[VAL_25]], i64 10, 1
// CHECK:         %[[VAL_27:.*]] = call i8* @llvm.stacksave()
// CHECK:         %[[VAL_28:.*]] = extractvalue { void ()*, i64 } %[[VAL_26]], 0
// CHECK:         %[[VAL_29:.*]] = extractvalue { void ()*, i64 } %[[VAL_26]], 1
// CHECK:         %[[VAL_30:.*]] = call { i8*, i64 } @_QPget_message([40 x i8]* %[[VAL_0]], i64 40, void ()* %[[VAL_28]], i64 %[[VAL_29]])
// CHECK:         %[[VAL_31:.*]] = bitcast [40 x i8]* %[[VAL_0]] to i8*
// CHECK:         %[[VAL_32:.*]] = call i1 @_FortranAioOutputAscii(i8* %{{.*}}, i8* %[[VAL_31]], i64 40)
// CHECK:         call void @llvm.stackrestore(i8* %[[VAL_27]])

// CHECK-LABEL: define { i8*, i64 } @_QFtest_proc_dummy_charPgen_message([10 x i8]*
// CHECK-SAME:                %[[VAL_0:.*]], i64 %[[VAL_1:.*]], { { i8*, i64 } }* nest %[[VAL_2:.*]])
// CHECK:         %[[VAL_3:.*]] = getelementptr { { i8*, i64 } }, { { i8*, i64 } }* %[[VAL_2]], i64 0, i32 0
// CHECK:         %[[VAL_4:.*]] = load { i8*, i64 }, { i8*, i64 }* %[[VAL_3]], align 8
// CHECK:         %[[VAL_5:.*]] = extractvalue { i8*, i64 } %[[VAL_4]], 0
// CHECK:         %[[VAL_6:.*]] = extractvalue { i8*, i64 } %[[VAL_4]], 1
// CHECK:         %[[VAL_7:.*]] = bitcast [10 x i8]* %[[VAL_0]] to i8*
// CHECK:         %[[VAL_8:.*]] = icmp slt i64 10, %[[VAL_6]]
// CHECK:         %[[VAL_9:.*]] = select i1 %[[VAL_8]], i64 10, i64 %[[VAL_6]]
// CHECK:         call void @llvm.memmove.p0i8.p0i8.i64(i8* %[[VAL_7]], i8* %[[VAL_5]], i64 %[[VAL_9]], i1 false)
// CHECK:         %[[VAL_10:.*]] = sub i64 10, %[[VAL_9]]
// CHECK:         br label %[[VAL_11:.*]]
// CHECK:         %[[VAL_14:.*]] = phi i64
// CHECK:         %[[VAL_16:.*]] = phi i64
// CHECK:         %[[VAL_18:.*]] = icmp sgt i64 %[[VAL_16]], 0
// CHECK:         %[[VAL_20:.*]] = bitcast i8* %[[VAL_7]] to [1 x i8]*
// CHECK:         %[[VAL_21:.*]] = getelementptr [1 x i8], [1 x i8]* %[[VAL_20]], i64 %[[VAL_14]]
// CHECK:         store [1 x i8] c" ", [1 x i8]* %[[VAL_21]], align 1
// CHECK:         %[[VAL_22:.*]] = insertvalue { i8*, i64 } undef, i8* %[[VAL_7]], 0
// CHECK:         %[[VAL_23:.*]] = insertvalue { i8*, i64 } %[[VAL_22]], i64 10, 1
// CHECK:         ret { i8*, i64 } %[[VAL_23]]
// CHECK:       }

// CHECK-LABEL: define { i8*, i64 } @_QPget_message([40 x i8]*
// CHECK-SAME:                  %[[VAL_0:.*]], i64 %[[VAL_1:.*]], void ()* %[[VAL_2:.*]], i64
// CHECK-SAME:                                                 %[[VAL_3:.*]])
// CHECK:         %[[VAL_4:.*]] = insertvalue { void ()*, i64 } undef, void ()* %[[VAL_2]], 0
// CHECK:         %[[VAL_5:.*]] = insertvalue { void ()*, i64 } %[[VAL_4]], i64 %[[VAL_3]], 1
// CHECK:         %[[VAL_6:.*]] = bitcast [40 x i8]* %[[VAL_0]] to i8*
// CHECK:         %[[VAL_7:.*]] = extractvalue { void ()*, i64 } %[[VAL_5]], 0
// CHECK:         %[[VAL_8:.*]] = extractvalue { void ()*, i64 } %[[VAL_5]], 1
// CHECK:         %[[VAL_9:.*]] = call i8* @llvm.stacksave()
// CHECK:         %[[VAL_10:.*]] = alloca i8, i64 %[[VAL_8]], align 1
// CHECK:         %[[VAL_11:.*]] = bitcast void ()* %[[VAL_7]] to { i8*, i64 } (i8*, i64)*
// CHECK:         %[[VAL_12:.*]] = call { i8*, i64 } %[[VAL_11]](i8* %[[VAL_10]], i64 %[[VAL_8]])
// CHECK:         %[[VAL_13:.*]] = add i64 %[[VAL_8]], 12
// CHECK:         %[[VAL_14:.*]] = alloca i8, i64 %[[VAL_13]], align 1
// CHECK:         call void @llvm.memmove.p0i8.p0i8.i64(i8* %[[VAL_14]], i8* getelementptr inbounds ([12 x i8], [12 x i8]* @_QQcl.6D6573736167652069733A20, i32 0, i32 0), i64 12, i1 false)
// CHECK:         %[[VAL_18:.*]] = phi i64
// CHECK:         %[[VAL_20:.*]] = phi i64
// CHECK:         %[[VAL_22:.*]] = icmp sgt i64 %[[VAL_20]], 0
// CHECK:         %[[VAL_24:.*]] = sub i64 %[[VAL_18]], 12
// CHECK:         %[[VAL_25:.*]] = bitcast i8* %[[VAL_10]] to [1 x i8]*
// CHECK:         %[[VAL_26:.*]] = getelementptr [1 x i8], [1 x i8]* %[[VAL_25]], i64 %[[VAL_24]]
// CHECK:         %[[VAL_27:.*]] = load [1 x i8], [1 x i8]* %[[VAL_26]], align 1
// CHECK:         %[[VAL_28:.*]] = bitcast i8* %[[VAL_14]] to [1 x i8]*
// CHECK:         %[[VAL_29:.*]] = getelementptr [1 x i8], [1 x i8]* %[[VAL_28]], i64 %[[VAL_18]]
// CHECK:         store [1 x i8] %[[VAL_27]], [1 x i8]* %[[VAL_29]], align 1
// CHECK:         %[[VAL_30:.*]] = icmp slt i64 40, %[[VAL_13]]
// CHECK:         %[[VAL_31:.*]] = select i1 %[[VAL_30]], i64 40, i64 %[[VAL_13]]
// CHECK:         call void @llvm.memmove.p0i8.p0i8.i64(i8* %[[VAL_6]], i8* %[[VAL_14]], i64 %[[VAL_31]], i1 false)
// CHECK:         %[[VAL_32:.*]] = sub i64 40, %[[VAL_31]]
// CHECK:         %[[VAL_35:.*]] = phi i64
// CHECK:         %[[VAL_37:.*]] = phi i64
// CHECK:         %[[VAL_39:.*]] = icmp sgt i64 %[[VAL_37]], 0
// CHECK:         %[[VAL_41:.*]] = bitcast i8* %[[VAL_6]] to [1 x i8]*
// CHECK:         %[[VAL_42:.*]] = getelementptr [1 x i8], [1 x i8]* %[[VAL_41]], i64 %[[VAL_35]]
// CHECK:         store [1 x i8] c" ", [1 x i8]* %[[VAL_42]], align 1
// CHECK:         call void @llvm.stackrestore(i8* %[[VAL_9]])
// CHECK:         %[[VAL_43:.*]] = insertvalue { i8*, i64 } undef, i8* %[[VAL_6]], 0
// CHECK:         %[[VAL_44:.*]] = insertvalue { i8*, i64 } %[[VAL_43]], i64 40, 1
// CHECK:         ret { i8*, i64 } %[[VAL_44]]
// CHECK:       }

func @_QPtest_proc_dummy_char() {
  %c10 = arith.constant 10 : index
  %c0_i32 = arith.constant 0 : i32
  %c9 = arith.constant 9 : index
  %false = arith.constant false
  %c1 = arith.constant 1 : index
  %c32_i8 = arith.constant 32 : i8
  %c-1_i32 = arith.constant -1 : i32
  %c6_i32 = arith.constant 6 : i32
  %c10_i64 = arith.constant 10 : i64
  %c40 = arith.constant 40 : index
  %c0 = arith.constant 0 : index
  %0 = fir.alloca !fir.char<1,40> {bindc_name = ".result"}
  %1 = fir.alloca !fir.char<1,10> {bindc_name = "message", uniq_name = "_QFtest_proc_dummy_charEmessage"}
  %2 = fir.alloca tuple<!fir.boxchar<1>>
  %3 = fir.coordinate_of %2, %c0_i32 : (!fir.ref<tuple<!fir.boxchar<1>>>, i32) -> !fir.ref<!fir.boxchar<1>>
  %4 = fir.convert %1 : (!fir.ref<!fir.char<1,10>>) -> !fir.ref<!fir.char<1,?>>
  %5 = fir.emboxchar %4, %c10 : (!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>
  fir.store %5 to %3 : !fir.ref<!fir.boxchar<1>>
  %6 = fir.address_of(@_QQcl.486920746865726521) : !fir.ref<!fir.char<1,9>>
  %7 = fir.convert %c9 : (index) -> i64
  %8 = fir.convert %1 : (!fir.ref<!fir.char<1,10>>) -> !fir.ref<i8>
  %9 = fir.convert %6 : (!fir.ref<!fir.char<1,9>>) -> !fir.ref<i8>
  fir.call @llvm.memmove.p0i8.p0i8.i64(%8, %9, %7, %false) : (!fir.ref<i8>, !fir.ref<i8>, i64, i1) -> ()
  %10 = fir.undefined !fir.char<1>
  %11 = fir.insert_value %10, %c32_i8, [0 : index] : (!fir.char<1>, i8) -> !fir.char<1>
  br ^bb1(%c9, %c1 : index, index)
^bb1(%12: index, %13: index):  // 2 preds: ^bb0, ^bb2
  %14 = arith.cmpi sgt, %13, %c0 : index
  cond_br %14, ^bb2, ^bb3
^bb2:  // pred: ^bb1
  %15 = fir.convert %1 : (!fir.ref<!fir.char<1,10>>) -> !fir.ref<!fir.array<10x!fir.char<1>>>
  %16 = fir.coordinate_of %15, %12 : (!fir.ref<!fir.array<10x!fir.char<1>>>, index) -> !fir.ref<!fir.char<1>>
  fir.store %11 to %16 : !fir.ref<!fir.char<1>>
  %17 = arith.addi %12, %c1 : index
  %18 = arith.subi %13, %c1 : index
  br ^bb1(%17, %18 : index, index)
^bb3:  // pred: ^bb1
  %19 = fir.address_of(@_QQcl.2E2F682E66393000) : !fir.ref<!fir.char<1,8>>
  %20 = fir.convert %19 : (!fir.ref<!fir.char<1,8>>) -> !fir.ref<i8>
  %21 = fir.call @_FortranAioBeginExternalListOutput(%c-1_i32, %20, %c6_i32) : (i32, !fir.ref<i8>, i32) -> !fir.ref<i8>
  %22 = fir.address_of(@_QFtest_proc_dummy_charPgen_message) : (!fir.ref<!fir.char<1,10>>, index, !fir.ref<tuple<!fir.boxchar<1>>>) -> !fir.boxchar<1>
  %23 = fir.emboxproc %22, %2 : ((!fir.ref<!fir.char<1,10>>, index, !fir.ref<tuple<!fir.boxchar<1>>>) -> !fir.boxchar<1>, !fir.ref<tuple<!fir.boxchar<1>>>) -> !fir.boxproc<() -> ()>
  %24 = fir.undefined tuple<!fir.boxproc<() -> ()>, i64>
  %25 = fir.insert_value %24, %23, [0 : index] : (tuple<!fir.boxproc<() -> ()>, i64>, !fir.boxproc<() -> ()>) -> tuple<!fir.boxproc<() -> ()>, i64>
  %26 = fir.insert_value %25, %c10_i64, [1 : index] : (tuple<!fir.boxproc<() -> ()>, i64>, i64) -> tuple<!fir.boxproc<() -> ()>, i64>
  %27 = fir.call @llvm.stacksave() : () -> !fir.ref<i8>
  %28 = fir.call @_QPget_message(%0, %c40, %26) : (!fir.ref<!fir.char<1,40>>, index, tuple<!fir.boxproc<() -> ()>, i64>) -> !fir.boxchar<1>
  %29 = fir.convert %0 : (!fir.ref<!fir.char<1,40>>) -> !fir.ref<i8>
  %30 = fir.convert %c40 : (index) -> i64
  %31 = fir.call @_FortranAioOutputAscii(%21, %29, %30) : (!fir.ref<i8>, !fir.ref<i8>, i64) -> i1
  fir.call @llvm.stackrestore(%27) : (!fir.ref<i8>) -> ()
  %32 = fir.call @_FortranAioEndIoStatement(%21) : (!fir.ref<i8>) -> i32
  return
}
func @_QFtest_proc_dummy_charPgen_message(%arg0: !fir.ref<!fir.char<1,10>>, %arg1: index, %arg2: !fir.ref<tuple<!fir.boxchar<1>>> {fir.host_assoc}) -> !fir.boxchar<1> {
  %c0_i32 = arith.constant 0 : i32
  %c10 = arith.constant 10 : index
  %false = arith.constant false
  %c1 = arith.constant 1 : index
  %c32_i8 = arith.constant 32 : i8
  %c0 = arith.constant 0 : index
  %0 = fir.coordinate_of %arg2, %c0_i32 : (!fir.ref<tuple<!fir.boxchar<1>>>, i32) -> !fir.ref<!fir.boxchar<1>>
  %1 = fir.load %0 : !fir.ref<!fir.boxchar<1>>
  %2:2 = fir.unboxchar %1 : (!fir.boxchar<1>) -> (!fir.ref<!fir.char<1,?>>, index)
  %3 = fir.convert %arg0 : (!fir.ref<!fir.char<1,10>>) -> !fir.ref<!fir.char<1,?>>
  %4 = arith.cmpi slt, %c10, %2#1 : index
  %5 = select %4, %c10, %2#1 : index
  %6 = fir.convert %5 : (index) -> i64
  %7 = fir.convert %3 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<i8>
  %8 = fir.convert %2#0 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<i8>
  fir.call @llvm.memmove.p0i8.p0i8.i64(%7, %8, %6, %false) : (!fir.ref<i8>, !fir.ref<i8>, i64, i1) -> ()
  %9 = fir.undefined !fir.char<1>
  %10 = fir.insert_value %9, %c32_i8, [0 : index] : (!fir.char<1>, i8) -> !fir.char<1>
  %11 = arith.subi %c10, %5 : index
  br ^bb1(%5, %11 : index, index)
^bb1(%12: index, %13: index):  // 2 preds: ^bb0, ^bb2
  %14 = arith.cmpi sgt, %13, %c0 : index
  cond_br %14, ^bb2, ^bb3
^bb2:  // pred: ^bb1
  %15 = fir.convert %3 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<!fir.array<?x!fir.char<1>>>
  %16 = fir.coordinate_of %15, %12 : (!fir.ref<!fir.array<?x!fir.char<1>>>, index) -> !fir.ref<!fir.char<1>>
  fir.store %10 to %16 : !fir.ref<!fir.char<1>>
  %17 = arith.addi %12, %c1 : index
  %18 = arith.subi %13, %c1 : index
  br ^bb1(%17, %18 : index, index)
^bb3:  // pred: ^bb1
  %19 = fir.emboxchar %3, %c10 : (!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>
  return %19 : !fir.boxchar<1>
}
func @_QPget_message(%arg0: !fir.ref<!fir.char<1,40>>, %arg1: index, %arg2: tuple<!fir.boxproc<() -> ()>, i64> {fir.char_proc}) -> !fir.boxchar<1> {
  %c40 = arith.constant 40 : index
  %c12 = arith.constant 12 : index
  %false = arith.constant false
  %c1 = arith.constant 1 : index
  %c32_i8 = arith.constant 32 : i8
  %c0 = arith.constant 0 : index
  %0 = fir.convert %arg0 : (!fir.ref<!fir.char<1,40>>) -> !fir.ref<!fir.char<1,?>>
  %1 = fir.address_of(@_QQcl.6D6573736167652069733A20) : !fir.ref<!fir.char<1,12>>
  %2 = fir.extract_value %arg2, [0 : index] : (tuple<!fir.boxproc<() -> ()>, i64>) -> !fir.boxproc<() -> ()>
  %3 = fir.box_addr %2 : (!fir.boxproc<() -> ()>) -> (() -> ())
  %4 = fir.extract_value %arg2, [1 : index] : (tuple<!fir.boxproc<() -> ()>, i64>) -> i64
  %5 = fir.call @llvm.stacksave() : () -> !fir.ref<i8>
  %6 = fir.alloca !fir.char<1,?>(%4 : i64) {bindc_name = ".result"}
  %7 = fir.convert %3 : (() -> ()) -> ((!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>)
  %8 = fir.convert %4 : (i64) -> index
  %9 = fir.call %7(%6, %8) : (!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>
  %10 = arith.addi %8, %c12 : index
  %11 = fir.alloca !fir.char<1,?>(%10 : index) {bindc_name = ".chrtmp"}
  %12 = fir.convert %c12 : (index) -> i64
  %13 = fir.convert %11 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<i8>
  %14 = fir.convert %1 : (!fir.ref<!fir.char<1,12>>) -> !fir.ref<i8>
  fir.call @llvm.memmove.p0i8.p0i8.i64(%13, %14, %12, %false) : (!fir.ref<i8>, !fir.ref<i8>, i64, i1) -> ()
  br ^bb1(%c12, %8 : index, index)
^bb1(%15: index, %16: index):  // 2 preds: ^bb0, ^bb2
  %17 = arith.cmpi sgt, %16, %c0 : index
  cond_br %17, ^bb2, ^bb3
^bb2:  // pred: ^bb1
  %18 = arith.subi %15, %c12 : index
  %19 = fir.convert %6 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<!fir.array<?x!fir.char<1>>>
  %20 = fir.coordinate_of %19, %18 : (!fir.ref<!fir.array<?x!fir.char<1>>>, index) -> !fir.ref<!fir.char<1>>
  %21 = fir.load %20 : !fir.ref<!fir.char<1>>
  %22 = fir.convert %11 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<!fir.array<?x!fir.char<1>>>
  %23 = fir.coordinate_of %22, %15 : (!fir.ref<!fir.array<?x!fir.char<1>>>, index) -> !fir.ref<!fir.char<1>>
  fir.store %21 to %23 : !fir.ref<!fir.char<1>>
  %24 = arith.addi %15, %c1 : index
  %25 = arith.subi %16, %c1 : index
  br ^bb1(%24, %25 : index, index)
^bb3:  // pred: ^bb1
  %26 = arith.cmpi slt, %c40, %10 : index
  %27 = select %26, %c40, %10 : index
  %28 = fir.convert %27 : (index) -> i64
  %29 = fir.convert %0 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<i8>
  fir.call @llvm.memmove.p0i8.p0i8.i64(%29, %13, %28, %false) : (!fir.ref<i8>, !fir.ref<i8>, i64, i1) -> ()
  %30 = fir.undefined !fir.char<1>
  %31 = fir.insert_value %30, %c32_i8, [0 : index] : (!fir.char<1>, i8) -> !fir.char<1>
  %32 = arith.subi %c40, %27 : index
  br ^bb4(%27, %32 : index, index)
^bb4(%33: index, %34: index):  // 2 preds: ^bb3, ^bb5
  %35 = arith.cmpi sgt, %34, %c0 : index
  cond_br %35, ^bb5, ^bb6
^bb5:  // pred: ^bb4
  %36 = fir.convert %0 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<!fir.array<?x!fir.char<1>>>
  %37 = fir.coordinate_of %36, %33 : (!fir.ref<!fir.array<?x!fir.char<1>>>, index) -> !fir.ref<!fir.char<1>>
  fir.store %31 to %37 : !fir.ref<!fir.char<1>>
  %38 = arith.addi %33, %c1 : index
  %39 = arith.subi %34, %c1 : index
  br ^bb4(%38, %39 : index, index)
^bb6:  // pred: ^bb4
  fir.call @llvm.stackrestore(%5) : (!fir.ref<i8>) -> ()
  %40 = fir.emboxchar %0, %c40 : (!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>
  return %40 : !fir.boxchar<1>
}
fir.global linkonce @_QQcl.486920746865726521 constant : !fir.char<1,9> {
  %0 = fir.string_lit "Hi there!"(9) : !fir.char<1,9>
  fir.has_value %0 : !fir.char<1,9>
}
func private @llvm.memmove.p0i8.p0i8.i64(!fir.ref<i8>, !fir.ref<i8>, i64, i1)
fir.global linkonce @_QQcl.2E2F682E66393000 constant : !fir.char<1,8> {
  %0 = fir.string_lit "./h.f90\00"(8) : !fir.char<1,8>
  fir.has_value %0 : !fir.char<1,8>
}
func private @llvm.stacksave() -> !fir.ref<i8>
func private @llvm.stackrestore(!fir.ref<i8>)
fir.global linkonce @_QQcl.6D6573736167652069733A20 constant : !fir.char<1,12> {
  %0 = fir.string_lit "message is: "(12) : !fir.char<1,12>
  fir.has_value %0 : !fir.char<1,12>
}

func private @_FortranAioOutputAscii(!fir.ref<i8>, !fir.ref<i8>, i64) -> i1 attributes {fir.io, fir.runtime}
func private @_FortranAioBeginExternalListOutput(i32, !fir.ref<i8>, i32) -> !fir.ref<i8> attributes {fir.io, fir.runtime}
func private @_FortranAioOutputInteger32(!fir.ref<i8>, i32) -> i1 attributes {fir.io, fir.runtime}
func private @_FortranAioEndIoStatement(!fir.ref<i8>) -> i32 attributes {fir.io, fir.runtime}

