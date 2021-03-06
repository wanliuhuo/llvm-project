//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <memory>

// void declare_no_pointers(char* p, size_t n);
// void undeclare_no_pointers(char* p, size_t n);

#include <memory>

int main()
{
    char* p = new char[10];
    std::declare_no_pointers(p, 10);
    std::undeclare_no_pointers(p, 10);
    delete [] p;
}
