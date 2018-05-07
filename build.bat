@echo off
mkdir bin
%LLVM_PATH%\bin\clang -target ppc64-unknown-unknown -m64 -mllvm --x86-asm-syntax=intel -c debug_patch.S -o bin\debug_patch.o
%LLVM_PATH%\bin\ld.lld -v --section-start .text=0x10200 bin\debug_patch.o -o bin\debug_patch.elf
tools\bin\PatchElf.exe -v 83681f6110d33442329073b72b8dc88a2f677172 bin\boot.elf bin\debug_patch.elf bin\eboot.bin -a --dca=0x01842d48 --dcs=53944 --ocs=0x1832d48
