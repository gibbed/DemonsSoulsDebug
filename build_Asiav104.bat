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

if not exist "bin\Asiav104\boot.elf" (
  goto no_boot
)

)

if not defined APPVEYOR (
  nmake /nologo /f Makefile.mak TARGET=Asiav104
) else (
  nmake /nologo /f Makefile.mak TARGET=Asiav104 bin\Asiav104\debug.elf
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
  echo Could not find bin\Asiav104\boot.elf.
  echo Please copy the decrypted EBOOT to bin\Asiav104\boot.elf.
  pause
  exit /B 1
