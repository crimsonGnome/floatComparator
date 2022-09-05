#!/bin/bash

#Program: Float Comparator
#Author: Joseph Eggers

#Purpose: script file to run the program files together.
#Clear any previously compiled outputs
rm *.o
rm *.lis
rm *.out

echo "compile driver.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o floatComparator.cpp

echo "compile isFloat.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o isFloat.o isfloat.cpp

echo "Assemble floatComparator.asm"
nasm -f elf64 -l floatComparator.lis -o floatComparator.o floatComparator.asm

echo "Link object files using the gcc Linker standard 2017"
g++ -m64 -no-pie -o final.out floatComparator.o driver.o isFloat.o -std=c++17

echo "Run the Float Comparator Program:"
./final.out

rm *.o
rm *.lis
rm *.out