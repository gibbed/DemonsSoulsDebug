# Demon's Souls Debug Patch

This is some code to patch Demon's Souls `eboot.bin` with debug functionality.

Like what I've done? **[Consider supporting me on Patreon](http://patreon.com.gibbed).**

## What it achieves
* Enables the title debug menu.
* Enables the runtime debug menu (press start+select to toggle).
* Increases memory allocations so the Northern Limit area files can be loaded.

## Requires
* LLVM.
* US retail copy of Demon's Souls.

## Instructions
1. Open `Tools.bin` and build the entire solution with the Debug configuration.
1. Place a decrypted copy of Demon's Souls eboot.bin at `bin\boot.elf`.
  * You can get this easily by running Demon's Souls in RPCS3, it will then be found in `data\BLUS30443\773096f8cf108a0a19334182-EBOOT.BIN\boot.elf`.
1. Run `build.bat`, if all goes well `bin\eboot.bin` will be created.
1. Replace the original `eboot.bin` in the game directory and run it on a real PS3 or otherwise.

## TODO
* Build scripts for *nix.
* Porting the patches to EU/JP retail copies.
