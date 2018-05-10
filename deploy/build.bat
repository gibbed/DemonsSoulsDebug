@echo off
if not exist "tools\bin\PatchElf.exe" (
  goto missing_files
)
if not exist "bin\debug_patch.elf" (
  goto missing_files
)
if not exist "bin\boot.elf" (
  goto no_boot
)
tools\bin\PatchElf.exe bin\boot.elf bin\debug_patch.elf bin\debug.elf -v 83681f6110d33442329073b72b8dc88a2f677172 -a --dca=0x01842d48 --dcs=53944 --ocs=0x1832d48
exit 0

:missing_files
  echo There are missing files.
  echo Please ensure you extracted the ZIP correctly.
  pause
  exit 1

:no_boot
  echo Could not find bin\boot.elf.
  echo Please copy the decrypted EBOOT to bin\boot.elf.
  pause
  exit 1
