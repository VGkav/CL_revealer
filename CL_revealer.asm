.686p
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\masm32.inc
include	\masm32\macros\macros.asm
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc


includelib \masm32\lib\masm32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib


PROCESS_BASIC_INFORMATION STRUCT
    Reserved1             PVOID  ?
    PebBaseAddress       DWORD  ?
    Reserved2          PVOID ?
    UniqueProcessId  ULONGLONG  ? 
    Reserved3             PVOID ? 
PROCESS_BASIC_INFORMATION  ENDS




.data

App_Name db "CL_revealer",0
App_Name_Unicode db 43h,00, 4Ch,00, 5Fh,00, 72h,00, 65h,00, 76h,00, 65h,00, 61h,00, 6Ch,00, 65h,00, 72h,00,00,00

ntdll_string db "ntdll.dll",0
ntqip_string db "NtQueryInformationProcess",0
tempdword dd 0

.data?
hProcess dd ?
rtlupp dd ?
target_pid dd ?
cmd_string_ptr dd ?
NTDLLbase dd ?
ntqip_address dd ?
pbi PROCESS_BASIC_INFORMATION <>
temp_buffer db 512 dup(?)


.code
start:

mov dword ptr [temp_buffer], input("Enter target's pid (hex) : ")
mov dword ptr [target_pid], hval(dword ptr[temp_buffer])
invoke OpenProcess, PROCESS_ALL_ACCESS , FALSE, dword ptr [target_pid]
.IF EAX== NULL
  print "Couldn't find/open process, exiting",13,10
  inkey
  jmp @quickexit
.ELSE
  mov dword ptr [hProcess], eax
  print "Process opened",13,10
.ENDIF

invoke LoadLibrary , offset ntdll_string
mov dword ptr [NTDLLbase] , eax
invoke GetProcAddress , dword ptr [NTDLLbase] , offset ntqip_string
mov dword ptr [ntqip_address] , eax

push offset tempdword
push sizeof pbi
push offset pbi
push 0
push hProcess
call dword ptr [ntqip_address]

.IF EAX != NULL
  print "NtQueryInformationProcess failed ... ",13,10
  inkey
  jmp @quickexit
.ENDIF

mov eax, dword ptr [pbi.PebBaseAddress]
add eax,10h   ;offset of pointer to RTL_USER_PROCESS_PARAMETERS structure
invoke ReadProcessMemory, hProcess, EAX, offset rtlupp, 4, offset tempdword

mov eax, dword ptr [rtlupp]
add eax,44h
invoke ReadProcessMemory, hProcess, EAX, offset cmd_string_ptr, 4 , offset tempdword

invoke ReadProcessMemory, hProcess, dword ptr [cmd_string_ptr], offset temp_buffer, 512 , offset tempdword
;print dword ptr [temp_buffer],13,10,13,10
invoke MessageBoxW, NULL, offset temp_buffer, offset App_Name_Unicode, NULL


@quickexit:
invoke ExitProcess, NULL
end start
























