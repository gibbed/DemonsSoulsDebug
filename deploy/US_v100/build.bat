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
tools\bin\PatchElf.exe boot.elf debug.patch.elf debug.elf -v 83681f6110d33442329073b72b8dc88a2f677172 -a --dca=0x01842d48 --dcs=53944 --ocs=0x01832d48
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
