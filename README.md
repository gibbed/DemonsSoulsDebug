# Demon's Souls Debug Patch

This is some code to patch Demon's Souls `eboot.bin` with debug functionality.

Like what I've done? **[Consider supporting me on Patreon](http://patreon.com/gibbed).**

[![Build status](https://ci.appveyor.com/api/projects/status/gluli70k4d083ur6/branch/master?svg=true)](https://ci.appveyor.com/project/gibbed/demonssoulsdebug/branch/master)

## What it achieves
* Enables the title debug menu.
* Enables the runtime debug menu (press start+select to toggle).
* Increases memory arena sizes so the Northern Limit area files can be loaded.

## Requires
* LLVM (if building from source).
* US retail copy of Demon's Souls.

## Instructions

### Building From Release
1. Download the [latest release](https://github.com/gibbed/DemonsSoulsDebug/releases/latest) (not the source ZIP!).
1. Place a decrypted copy of Demon's Souls eboot.bin at `bin\boot.elf`.
    * You can get this easily by running Demon's Souls in RPCS3, it will then be found in `data\BLUS30443\(some ID)-EBOOT.BIN\boot.elf`.
1. Run `build.bat`, if all goes well `bin\debug.elf` will be created.
1. Run it on a real PS3 or otherwise.
    * Replace the original `EBOOT.BIN` with `debug.elf` in the game directory.
        * *Will probably require turning it into a SELF for running it on a real PS3.*
    * Or just place it alongside `EBOOT.BIN`.

### Building From Source
1. Open `tools\Tools.bin` and build the entire solution with the Debug configuration.
1. Place a decrypted copy of Demon's Souls eboot.bin at `bin\boot.elf`.
    * You can get this easily by running Demon's Souls in RPCS3, it will then be found in `data\BLUS30443\(some ID)-EBOOT.BIN\boot.elf`.
1. Run `build.bat`, if all goes well `bin\debug.elf` will be created.
1. Run it on a real PS3 or otherwise.
    * Replace the original `EBOOT.BIN` with `debug.elf` in the game directory.
        * *Will probably require turning it into a SELF for running it on a real PS3.*
    * Or just place it alongside `EBOOT.BIN`.

## TODO
* Build scripts for *nix.
* Porting the patches to EU/JP retail copies.
