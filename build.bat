@echo off

if not exist "%LLVM_PATH%\bin\clang.exe" (
  goto no_llvm
)
if not exist "%LLVM_PATH%\bin\ld.lld.exe" (
  goto no_llvm
)

if not defined APPVEYOR (

if not exist "tools\bin\PatchElf.exe" (
  goto no_patchelf
)

if not exist "bin\boot.elf" (
  goto no_boot
)

)

cd "bin"   2>NUL && cd .. || mkdir "bin"
cd "build" 2>NUL && cd .. || mkdir "build"

set "AS=%LLVM_PATH%\bin\clang.exe"
set "AS_FLAGS=-target ppc64-unknown-unknown -m64 -mllvm --x86-asm-syntax=intel"

"%AS%" %AS_FLAGS%                -c source/debug_menu.S            -o build/debug_menu.o
"%AS%" %AS_FLAGS%                -c source/debug_menu_localize.S   -o build/debug_menu_localize.o
"%AS%" %AS_FLAGS%                -c source/disable_system_cache.S  -o build/disable_system_cache.o
"%AS%" %AS_FLAGS%                -c source/increase_memory_zones.S -o build/increase_memory_zones.o
"%AS%" %AS_FLAGS%                -c source/lua_print_to_stdout.S   -o build/lua_print_to_stdout.o
"%AS%" %AS_FLAGS%                -c source/redirect_fs.S           -o build/redirect_fs.o
"%AS%" %AS_FLAGS%                -c source/start.S                 -o build/start.o
"%AS%" %AS_FLAGS% -DMAKE_SYMBOLS -c source/symbols.S               -o build/symbols.o

"%LLVM_PATH%\bin\ld.lld.exe" --script link.x --no-check-sections build/debug_menu.o build/debug_menu_localize.o build/disable_system_cache.o build/increase_memory_zones.o build/lua_print_to_stdout.o build/redirect_fs.o build/start.o build/symbols.o -o bin/debug_patch.elf

if not defined APPVEYOR (
  tools\bin\PatchElf.exe bin\boot.elf bin\debug_patch.elf bin\debug.elf -v 83681f6110d33442329073b72b8dc88a2f677172 -a --dca=0x01842d48 --dcs=53944 --ocs=0x1832d48
)

exit /B 0

:no_llvm
  echo Could not find LLVM.
  echo Please ensure the %%LLVM_PATH%% environment variable is set.
  pause
  exit /B 1

:no_patchelf
  echo Could not find tools\bin\PatchElf.exe.
  echo Please open tools\Tools.sln and compile the solution in Debug mode.
  pause
  exit /B 1

:no_boot
  echo Could not find bin\boot.elf.
  echo Please copy the decrypted EBOOT to bin\boot.elf.
  pause
  exit /B 1
