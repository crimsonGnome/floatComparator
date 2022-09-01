;****************************************************************************************************************************
;Program name: "isfloat".  This a library function contained in a single file.  The function receives a null-terminated     *
;array of char and either verifies that the array can be converted to a 64-bit float or denies that such a conversion is    *
;possible.  Copyright (C) 2022 Joseph Eggers.                                                                              *
;                                                                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public   *
;License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be   *
;useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.*
;See the GNU Lesser General Public License for more details. A copy of the GNU General Public License v3 is available here: *
;<https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Joseph Eggers
;  Author email: joseph.eggers@csu.fullerton.edu
;  Author CWID: 885939488
;
;Status
;  This software is not an application program, but rather it is a single function licensed for use by other applications.
;  This function can be embedded within both FOSS programs and in proprietary programs as permitted by the LGPL.

;Function information
;  Function name: isfloat
;  Programming language: X86 assembly in Intel syntax.
;  Date development began:  2022-Sep-29
;  Date version 1.0 finished: 2022-Mar-03
;  Files of this function: isfloat.asm
;  System requirements: an X86 platform with nasm installed o other compatible assembler.
;  Know issues: <now in testing phase>
;  Assembler used for testing: Nasm version 2.14.02
;  Prototype: bool isfloat(char *);
;
;Purpose
;  This function wil accept two floats and return the largest number
;  float number or not converted to a float number.
;
;Translation information
;  Assemble: nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm
;
;Software design document:
;  An Execution flow chart accompanies this function.  That document will provide a better understanding of the 
;  algorithm used in the isfloat function than a direct reading of the source code of the function.

;========= Begin source code ====================================================================================
extern printf
extern scanf
global perimeter

segment .data
welcome db "Welcome to a friendly assembly program by Johnson Tong",10,0
welcome2 db "This program will compute the perimeter and the average side length of a rectangle.", 10, 0

input1prompt db "Enter the height: ",0
input2prompt db "Enter the width: ", 0

one_float_format db "%lf",0
three_float_format db "%lf %lf %lf", 0

output_perimeter_float db "The perimeter is %.15lf.",10,0
output_average_float db "The length of the average side is %.15lf.", 10, 0

goodbye db "I hope you enjoyed your rectangle.",10,0
goodbye2 db "The assembly program will send the perimeter to the main function.", 10,0
one_string_format db "%s", 0

welcome_output db "Good morning %s", 10,0

four dq 4.0

segment .bss

segment .text

perimeter:
;Prolog ===== Insurance for any caller of this assembly module ========================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp
mov  rbp,rsp
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf                                                       ;Backup rflags

;Registers rax, rip, and rsp are usually not backed up.
push qword 0
; Display the welcome messages
mov rax, 0                  ;printf uses no data from xmm registers
mov rdi, welcome            ;"Welcome to a friendly assembly program by Johnson Tong"
call printf

push qword 0

sub rsp, 1024 ; make space for 1 string
mov rax, 0
mov rdi, one_string_format
mov rsi, rsp
mov rdx, rsp
add rdx, 1024
call scanf

mov rax, 0
mov rdi, welcome_output
mov rsi, rsp
call printf

add rsp, 1024
pop rax

push qword 0
mov rax, 0
mov rdi, welcome2
call printf
pop rax

    ; push qword 0 ; just pretend this isn't here
	
	push qword 0 ; push 8 bytes to top of stack for storage
	push qword 0
	push qword 0
	
	mov rdi, three_float_format ; move float format into first parameter register // rdi = "%lf %lf %lf"
	mov rsi, rsp ; <- second arg register now points to top of stack
	mov rdx, rsp
	add rdx, qword 8 ; rdx points to second qword
	mov rcx, rsp
	add rcx, qword 16 ; rcx points to third qword
	call scanf ; scanf("%lf %lf %lf", rsp, rsp + 8, rsp + 16);
	
	movsd xmm15, [rsp+0] ; dereference the data at the top of stack, store in xmm15 
	movsd xmm14, [rsp+8]
	movsd xmm13, [rsp+16]
	
	; [ ] are equivalent to *dereference in c++
	
	pop rax ; restore stack, i.e. since we're done with the 8 bytes at the top, remove them
	
	; for the actual numbers
	pop rax
	pop rax 
	; pop rax

;=========begin inputs for height and width===================
push qword 0
;Display a prompt message asking for inputs
mov rax, 0
mov rdi, input1prompt         ;"Enter the height: "
call printf
pop rax

;Begin the scanf block
push qword 0
mov rax, 1
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm10, [rsp]
pop rax

push qword 0
;Display a prompt message asking for inputs
mov rax, 0
mov rdi, input2prompt       ; "Enter the width: "
call printf
pop rax

;Begin the scanf block
push qword 0
mov rax, 1
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm11, [rsp]
pop rax



;=================Calculate perimeter=====================
movsd xmm12, xmm10             ; preserve the height
movsd xmm13, xmm11             ; preserve the width
addsd xmm12, xmm11
addsd xmm13, xmm10
addsd xmm12, xmm13

push qword 0
mov rax, 1
movsd xmm0, xmm12
mov rdi, output_perimeter_float    ;"The perimeter is %.3lf."
call printf
pop rax

movsd xmm15, xmm12                  ;save the perimeter before modifying
;=================Calculate average=======================
; two alternative ways to do the average
divsd xmm12, [four]
; mov r8, 4
; cvtsi2sd xmm13, r8
; divsd xmm12, xmm13

push qword 0
mov rax, 1
movsd xmm0, xmm12
mov rdi, output_average_float     ;"The length of the average side is %.3lf"
call printf
pop rax

push qword 0
mov rax, 0
mov rdi, goodbye       ; "I hope you enjoyed your rectangle."
call printf
pop rax

push qword 0
mov rax, 0
mov rdi, goodbye2       ; "The assembly program will send the perimeter to the main function."
call printf
pop rax

pop rax

movsd xmm0, xmm15
;===== Restore original values to integer registers ===================================================================
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

ret