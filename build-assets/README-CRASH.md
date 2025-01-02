# README-CRASH

Python 3.12 fails with win64. "3.11.8" is ok.

wine 8

[wine64 /home/ilg/Work/xpack-dev-tools/meson-build-xpack.git/build-assets/build/win32-x64/application/bin/meson-python3.exe -m ensurepip --upgrade]
wine: Call from 000000007B013D0E to unimplemented function propsys.dll.VariantToString, aborting
wine: Unimplemented function propsys.dll.VariantToString called at address 000000007B013D0E (thread 011c), starting debugger...
Unhandled exception: unimplemented function propsys.dll.VariantToString called in 64-bit code (0x0000007b013d0e).
Register dump:
 rip:000000007b013d0e rsp:0000000002a3bc10 rbp:0000000002a3be70 eflags:00000202 (   - --  I   - - - )
 rax:0000000002a3bc50 rbx:000000007b60ed84 rcx:0000000002a3bc30 rdx:0000000000000001
 rsi:0000000002a3bd20 rdi:0000000002a3bc60  r8:0000000000000002  r9:0000000002a3bd10 r10:00000001ed4ab36c
 r11:0000000000000008 r12:0000000000000000 r13:0000000000000000 r14:0000000000340d08 r15:0000000000000000

wine 9.0.0

[wine64 /home/ilg/Work/xpack-dev-tools/meson-build-xpack.git/build-assets/build/win32-x64/application/bin/meson-python3.exe -m pip install --target /home/ilg/Work/xpack-dev-tools/meson-build-xpack.git/build-assets/build/win32-x64/application/Lib/site-packages packaging==24.2]
Collecting packaging==24.2
  Using cached packaging-24.2-py3-none-any.whl.metadata (3.2 kB)
Using cached packaging-24.2-py3-none-any.whl (65 kB)
Installing collected packages: packaging
Successfully installed packaging-24.2
wine: Call from 00006FFFFFF6D5E8 to unimplemented function KERNEL32.dll.CopyFile2, aborting
wine: Unimplemented function KERNEL32.dll.CopyFile2 called at address 00006FFFFFF6D5E8 (thread 01dc), starting debugger...
Unhandled exception: unimplemented function KERNEL32.dll.CopyFile2 called in 64-bit code (0x006ffffff6d5e8).

TODO: try latest wine.
