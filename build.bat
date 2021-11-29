@SET MASM32=\masm32

@"%MASM32%\bin\ml" /c /coff /Cp /nologo CL_revealer.asm
@"%MASM32%\bin\link" /SUBSYSTEM:CONSOLE  /LIBPATH:"%MASM32%\lib" CL_revealer.obj
@pause
