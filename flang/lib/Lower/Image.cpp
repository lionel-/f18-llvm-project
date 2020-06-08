//===-- Image.cpp ---------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "flang/Lower/Image.h"
#include "RTBuilder.h"
#include "SymbolMap.h"
#include "flang/Lower/Bridge.h"
#include "flang/Lower/FIRBuilder.h"
#include "flang/Parser/parse-tree.h"
#include "flang/Semantics/expression.h"

#undef TODO
#define TODO(MSG)                                                              \
  {                                                                            \
    mlir::emitError(converter.getCurrentLocation(), "not yet implemented")     \
        << MSG;                                                                \
    exit(1);                                                                   \
  }

// TODO: We don't have runtime library support for various features. When they
// are encountered, we emit an error message and exit immediately.
static void noRuntimeSupport(mlir::Location loc, llvm::StringRef stmt) {
  mlir::emitError(loc, "There is no runtime support for ")
      << stmt << " statement.\n";
  std::exit(1);
}

//===----------------------------------------------------------------------===//
// TEAM statements and constructs
//===----------------------------------------------------------------------===//

void Fortran::lower::genChangeTeamConstruct(
    Fortran::lower::AbstractConverter &converter,
    Fortran::lower::pft::Evaluation &,
    const Fortran::parser::ChangeTeamConstruct &) {
  TODO("CHANGE TEAM construct");
}

void Fortran::lower::genChangeTeamStmt(
    Fortran::lower::AbstractConverter &converter,
    Fortran::lower::pft::Evaluation &,
    const Fortran::parser::ChangeTeamStmt &) {
  TODO("CHANGE TEAM stmt");
}

void Fortran::lower::genEndChangeTeamStmt(
    Fortran::lower::AbstractConverter &converter,
    Fortran::lower::pft::Evaluation &,
    const Fortran::parser::EndChangeTeamStmt &) {
  TODO("END CHANGE TEAM");
}

void Fortran::lower::genFormTeamStatement(
    Fortran::lower::AbstractConverter &converter,
    Fortran::lower::pft::Evaluation &, const Fortran::parser::FormTeamStmt &) {
  // FIXME: There is no runtime call to make for this yet.
  noRuntimeSupport(converter.getCurrentLocation(), "FORM TEAM");
}

//===----------------------------------------------------------------------===//
// COARRAY expressions
//===----------------------------------------------------------------------===//

Fortran::lower::ExValue Fortran::lower::CoarrayExprHelper::genAddr(
    const Fortran::evaluate::CoarrayRef &expr) {
  TODO("co-array address");
}

Fortran::lower::ExValue Fortran::lower::CoarrayExprHelper::genValue(
    const Fortran::evaluate::CoarrayRef &expr) {
  TODO("co-array value");
}
