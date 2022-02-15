//===-- LowLevelIntrinsics.h ------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Coding style: https://mlir.llvm.org/getting_started/DeveloperGuide/
//
//===----------------------------------------------------------------------===//

#ifndef FLANG_OPTIMIZER_BUILDER_LOWLEVELINTRINSICS_H
#define FLANG_OPTIMIZER_BUILDER_LOWLEVELINTRINSICS_H

namespace mlir {
class FuncOp;
}
namespace fir {
class FirOpBuilder;
}

namespace fir::factory {

/// Get the LLVM intrinsic for `memcpy`. Use the 64 bit version.
mlir::FuncOp getLlvmMemcpy(FirOpBuilder &builder);

/// Get the LLVM intrinsic for `memmove`. Use the 64 bit version.
mlir::FuncOp getLlvmMemmove(FirOpBuilder &builder);

/// Get the LLVM intrinsic for `memset`. Use the 64 bit version.
mlir::FuncOp getLlvmMemset(FirOpBuilder &builder);

/// Get the C standard library `realloc` function.
mlir::FuncOp getRealloc(FirOpBuilder &builder);

/// Get the `llvm.stacksave` intrinsic.
mlir::FuncOp getLlvmStackSave(FirOpBuilder &builder);

/// Get the `llvm.stackrestore` intrinsic.
mlir::FuncOp getLlvmStackRestore(FirOpBuilder &builder);

/// Get the `llvm.init.trampoline` intrinsic.
mlir::FuncOp getLlvmInitTrampoline(FirOpBuilder &builder);

/// Get the `llvm.adjust.trampoline` intrinsic.
mlir::FuncOp getLlvmAdjustTrampoline(FirOpBuilder &builder);

} // namespace fir::factory

#endif // FLANG_OPTIMIZER_BUILDER_LOWLEVELINTRINSICS_H
