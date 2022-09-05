//****************************************************************************************************************************
//Program name: "Float Comparator". This program takes in two float numbers as inputs to determine whether or not they fit the
//are indea floats. It will then compare the two floats output the largerst float and reutrn then smaller float for the user to
// use Copyright (C) 2022 Joseph Eggers.
//                                                                                                                           *
//This file is part of the software program "Float Comparator".                                                              *
// FloatComparator is free software: you can redistribute it and/or modify it under the terms of the GNU General Public      *
//License version 3 as published by the Free Software Foundation.                                                            *
// FloatComparator is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied     *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Joseph Eggers
//  Author email: joseph.eggers@csu.fullerton.edu
//
//Program information
//  Program name:  FloatComparator
//  Programming languages: One module in C, one module in X86, two modules in C++
//  Date program began: 2022 September 2
//  Date of last update: 2023 September 2
//  Date of reorganization of comments: 2021 September 2
//  Files in this program: quadratic.asm, second_degree.c, isFloat.cpp, quad.cpp, run.sh
//  Status: Finished.  The program was tested extensively with no errors in Ubuntu 2020 Edition.
//
//Purpose
//  This file contains the function isFloat that will check whether or not a string input is a float. This will help validate input
//  in the assembly file floatComparator.asm.
//
//This file
//   File name: isfloat.cpp
//   Language: C++
//   Max page width: 132 columns
//   Compile: g++ -c -Wall -no-pie -m64 -std=c++17 -o isFloat.o isfloat.cpp
//   Link: g++ -m64 -no-pie -o final FloatComparator.out quadratic.o quad.o isFloat.o second_degree.o -std=c++17
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================

#include <iostream>
#include <iomanip>

extern "C" double comparator();

using std::cin, std::cout, std::endl;

int main()
{
    cout << "\nWelcome to Floating Points Numbers programmed by Joseph Eggers.\n"
         << "Mr. Eggers has been working for the Longstreet Software Company for"
         << " the last two years.\n\n";

    //x86 program
    double lower = comparator();

    cout << "\nThe driver module received this float number " << std::showpoint << lower << " and will keep it.\n"
         << "The driver module will return integer 0 to the operating system.\n"
         << "Have a nice day. Good-bye.";
     return 0;
}