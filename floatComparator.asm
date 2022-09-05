;****************************************************************************************************************************
; Program name: "Float Comparator". This program takes in two float numbers as inputs to determine whether or not they fit the
; are indea floats. It will then compare the two floats output the largerst float and reutrn then smaller float for the user to
; use Copyright (C) 2022 Joseph Eggers.
;                                                                                                                           *
;This file is part of the software program "Float Comparator".                                                              *
; FloatComparator is free software: you can redistribute it and/or modify it under the terms of the GNU General Public      *
;License version 3 as published by the Free Software Foundation.                                                            *
; FloatComparator is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied     *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************

;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Joseph Eggers
;  Author email: joseph.eggers@csu.fullerton.edu
;  Author CWID: 885939488
;
;Contributors 
;  Consutlation was provided by the programmer sapphireGnome (Destiny Bonillas) for terminology, and Flow Control
;
;Status
;  This software is not an application program, but rather it is a single function licensed for use by other applications.
;  This function can be embedded within both FOSS programs and in proprietary programs as permitted by the LGPL.

;Function information
;  Function name: comparator
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
extern atof
extern isFloat
global comparator

segment .data
; Output messages used for the program. 
initiate db "Please enter two float numbers seperated by white space. Press enter after the second input.",10,0
confirmationNumbers db `These are the numbers were entered \n %1.16f \n %1.16f`,10,0
invalid db "The number you entered is not valid. Please try again", 10, 0
larger db `\n\The larger number is %1.16f \n`, 10, 0
endingMSG db `This assembly modlue will now return execution to the driver \module. \n\The smaller number will be returned to the driver. `, 10, 0
; Inut messages received by the user
userInput db "%s%s", 0

segment .bss

segment .text

comparator:
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
;====== Intiate progam ======
push qword 0
; Display the iniate input messages
mov rax, 0                  ;printf uses no data from xmm registers (expecting strings)
mov rdi, initiate           ;"Please enter two float numbers seperated by white space. Press enter after the second input"
call printf
pop rax

push qword -1
;====== Take 1st float ======

sub rsp, 2048 				; make space for 2 strings
mov rax, 0					;printf uses no data from xmm registers (expecting strings)
mov rdi, userInput			; input by user in two string format 
mov rsi, rsp
mov rdx, rsp
add rdx, 1024
call scanf					; scan two strings in

;====== Check if the input is a valid float ======
mov rax, 0
mov rdi, rsp				; move the top of teh stack to isFloat function and check 
call isFloat
cmp rax, 0

je invalidRoot				; if is function returns a 0 that means it is not a float, jump to invalidRoot 
mov rax, 0
mov rdi, rsp
add rdi, 1024				 ; move the top of teh stack to isFloat function and check 
call isFloat
cmp rax, 0
je invalidRoot				; if is function returns a 0 that means it is not a float, jump to invalidRoot 

; if Both Passed then convert to floats
mov rdi, rsp					; put top of the stack into rdi then call atof to turn into flaot 
call atof
movsd xmm15, xmm0			; sttore result 
mov rdi, rsp
add rdi, 1024
call atof					; repeat turn sting into flaot for the second function
movsd xmm14, xmm0
pop rax

;==== End of input numbers =====
; Print confirmation of numbers 

push qword 0
; Display the iniate input messages
mov rax, 2                  		; printf uses two flloats for the xmm registers
mov rdi, confirmationNumbers		;"These are the numbers were entered \n %1.16f \n %1.16f"
movsd xmm0, xmm15
movsd xmm1, xmm14
call printf
pop rax

;====== Compare the two floats ======

ucomisd xmm14, xmm15				; compare the towo floats 

jb inputOneBigger					; if xmm15 was bigger jump to inputOneBigger 

movsd xmm9, xmm14
movsd xmm8, xmm15
jmp returnBigger					; then skip to return bigger code block 

inputOneBigger:
movsd xmm9, xmm15
movsd xmm8, xmm14

returnBigger:
;====== Return the bigger number ======= 
push qword 0
mov rax, 1
mov rdi, larger						; The larger number is %1.16f
movsd xmm0, xmm9
call printf
pop rax;
;====== Return the smaller number ======= 

jmp end

invalidRoot: 					; Invalid Code block 
	push qword 0
	mov rax, 0
	mov rdi, invalid			; The number you entered is not valid. Please try again
	call printf
	pop rax
	;==== return -1 ======
	push qword 0				
	mov rax, -1					; insert -1 into the return statement
	cvtsi2sd xmm8, rax
	pop rax
	pop rax
	jmp end

end:
push qword 0
mov rax, 0
mov rdi, endingMSG				; "This assembly modlue will now return execution to the driver \module. \n The small number will be returned to the driver"
call printf
pop rax

pop rax
movsd xmm0, xmm8				; put the smallest number back in for the retun statement

add rsp, 2048


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