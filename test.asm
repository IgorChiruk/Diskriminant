      .386
      .model flat, stdcall
      option casemap :none   ; case sensitive
;#########################################################################



      include \masm32\include\windows.inc
      include \masm32\include\user32.inc
      include \masm32\include\kernel32.inc
      include \masm32\include\fpu.inc

      includelib \masm32\lib\user32.lib
      includelib \masm32\lib\kernel32.lib
      includelib \masm32\lib\fpu.lib

;#########################################################################



.data
  A1   dd 11.33d
  B1  dd 17.158d
  C1   dd 3.17d
  minus dd 4.0d
  D   dd ?
  x1  dt ?
  x2  dt ?
  temp1  dd ?
  temp2  dd ?
  
  msgcaption db "Результат",0
  msgtextNO db "Корней нет",0

CrLf equ 0A0Dh

info db "x1="
    _res1 db 14 DUP(32),10,13
    db "x2="
    _res2 db 14 DUP(32),0
    info_sz = $ - info
  
 ;#########################################################################



.code

start:
finit

xor eax,eax   
xor ebx,ebx 
xor ecx,ecx 
xor edx,edx 


call diskr
call   ExitProcess

;##########################################################################

diskr proc

fld B1
fmul B1
fstp temp1

mov minus,000000004h
fild minus
fmul A1
fmul C1
fstp temp2

fld temp1
fsub temp2
fstp D

cmp D,0
jl net_korney

cmp D,0
jz koren1

cmp D,0
ja korena2


ret
diskr endp
;##########################################################################
koren1:

mov temp1,000000000h
fld temp1
fsub B1
fstp B1

mov minus,000000002h
fild minus
fmul A1
fstp temp2

fld B1
fdiv temp2
fstp x1


invoke FpuFLtoA, offset x1, 2, offset _res1, SRC1_REAL or SRC2_DIMM

invoke MessageBox,NULL,offset info,ADDR msgcaption,MB_ICONINFORMATION
call   ExitProcess



;##########################################################################
korena2:

fld D
fsqrt
fstp D

mov temp1,000000000h
fld temp1
fsub B1
fstp B1

mov minus,000000002h
fild minus
fmul A1
fstp temp2

fld D
fadd B1
fdiv temp2
fstp x1

fld B1
fsub D
fdiv temp2
fstp x2

invoke FpuFLtoA, offset x1, 2, offset _res1, SRC1_REAL or SRC2_DIMM
;mov word ptr _res1+7,CrLf
invoke FpuFLtoA, offset x2, 2, offset _res2, SRC1_REAL or SRC2_DIMM

mov ecx, info_sz
    dec ecx     ; последний нолик нам нужен
    mov edi, offset info
    mov esi, edi
@l: lodsb
    test    al,al
    jnz @f
    mov al,20h
@@: stosb
    loop    @l

invoke MessageBox,NULL,offset info,ADDR msgcaption,MB_ICONINFORMATION
call   ExitProcess


;##########################################################################
net_korney:

      push   0
	push   offset msgcaption  ; адрес заголовка
	push   offset msgtextNO     ; адрес текста сообщения
	push   0                    ; нет родительского окна
	call   MessageBox           ; вызов API-функции вывода сообщения на экран

call   ExitProcess

;##########################################################################

end start