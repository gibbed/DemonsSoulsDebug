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
tools\bin\PatchElf.exe boot.elf debug.patch.elf debug.elf -v 9403fe1678487def5d7f3c380b4c4fb275035378 -a --dca=0x018442c8 --dcs=48440 --ocs=0x018342c8
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
