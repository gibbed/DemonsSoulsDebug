@echo off
if not exist "%LLVM_PATH%\bin\clang.exe" (
  goto no_llvm
)
if not exist "%LLVM_PATH%\bin\ld.lld.exe" (
  goto no_llvm
)
if not exist "tools\bin\PatchElf.exe" (
  goto no_patchelf
)
if not exist "bin\boot.elf" (
  goto no_boot
)
cd "bin" 2>NUL && cd .. || mkdir bin
%LLVM_PATH%\bin\clang.exe -target ppc64-unknown-unknown -m64 -mllvm --x86-asm-syntax=intel -c debug_patch.S -o bin\debug_patch.o
%LLVM_PATH%\bin\ld.lld.exe -v --section-start .text=0x10200 bin\debug_patch.o -o bin\debug_patch.elf
tools\bin\PatchElf.exe bin\boot.elf bin\debug_patch.elf bin\debug.elf -v 83681f6110d33442329073b72b8dc88a2f677172 -a --dca=0x01842d48 --dcs=53944 --ocs=0x1832d48
exit 0

:no_llvm
  echo Could not find LLVM.
  echo Please ensure the %%LLVM_PATH%% environment variable is set.
  pause
  exit 1

:no_patchelf
  echo Could not find tools\bin\PatchElf.exe.
  echo Please open tools\Tools.sln and compile the solution in Debug mode.
  pause
  exit 1

:no_boot
  echo Could not find bin\boot.elf.
  echo Please copy the decrypted EBOOT to bin\boot.elf.
  pause
  exit 1
