@echo off
if not exist "tools\bin\PatchElf.exe" (
  goto missing_files
)
if not exist "debug.elf.patch" (
  goto missing_files
)
if not exist "boot.elf" (
  goto no_boot
)
tools\bin\PatchElf.exe boot.elf debug.elf.patch debug.elf -v 68544b29e92609ccb2710f485ae7708e4cb35df1 -a --dca=0x01844248 --dcs=48568 --ocs=0x01834248
exit /B 0

:missing_files
  echo There are missing files.
  echo Please ensure you extracted the ZIP correctly.
  pause
  exit /B 1

:no_boot
  echo Could not find boot.elf.
  echo Please copy the decrypted EBOOT to the directory as boot.elf.
  pause
  exit /B 1
