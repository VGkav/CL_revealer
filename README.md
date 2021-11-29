# CL_revealer

(Command Line Revealer)

Simple tool that shows the full commandline of any running 32bit process. This normally means the full executable path and all arguments passed. You provide the PID (Process ID) in hexadecimal.

It uses LoadLibrary to load ntdll.dll, then it uses GetProcAddress to locate the address of the NtQueryInformationProcess API, then it calls it to find the target's PEB structure, more info at: https://docs.microsoft.com/en-us/windows/win32/api/winternl/ns-winternl-peb

Then it accesses RTL_USER_PROCESS_PARAMETERS and reads the field CommandLine: https://docs.microsoft.com/en-us/windows/win32/api/winternl/ns-winternl-rtl_user_process_parameters
