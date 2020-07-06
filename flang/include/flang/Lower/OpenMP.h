//===-- Lower/OpenMP.h -- lower Open MP directives --------------*- C++ -*-===//
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

#ifndef FORTRAN_LOWER_OPENMP_H
#define FORTRAN_LOWER_OPENMP_H

namespace Fortran {
namespace parser {
struct OpenMPConstruct;
struct OpenMPStandaloneConstruct;
struct OpenMPSimpleStandaloneConstruct;
struct OmpEndLoopDirective;
} // namespace parser

namespace lower {

class AbstractConverter;

namespace pft {
struct Evaluation;
} // namespace pft

void genOpenMPConstruct(AbstractConverter &, pft::Evaluation &,
                        const parser::OpenMPConstruct &);

void genOMP(AbstractConverter &, pft::Evaluation &,
            const parser::OpenMPStandaloneConstruct &);

void genOMP(AbstractConverter &, pft::Evaluation &,
            const parser::OpenMPSimpleStandaloneConstruct &);

void genOpenMPEndLoop(AbstractConverter &, pft::Evaluation &,
                      const parser::OmpEndLoopDirective &);

} // namespace lower
} // namespace Fortran

#endif // FORTRAN_LOWER_OPENMP_H
