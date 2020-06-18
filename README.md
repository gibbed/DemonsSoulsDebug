# Demon's Souls Debug Patch

This is some code to patch Demon's Souls `eboot.bin` with additional functionality, such as debug menus.

Like what I've done? **[Consider supporting me on Patreon](http://patreon.com/gibbed).**

[![Build status](https://ci.appveyor.com/api/projects/status/gluli70k4d083ur6/branch/master?svg=true)](https://ci.appveyor.com/project/gibbed/demonssoulsdebug/branch/master)

## What it achieves
* Enables the title debug menu.
* Enables the runtime debug menu (press Select to toggle).
* Increases memory arena sizes so the Northern Limit area files can be loaded.

## Requires
* LLVM, if building from source.
* A retail copy of Demon's Souls. The following releases are supported:
    * US 1.00 (`BLUS30443`)
    * JP 1.04 (`BCJS30022`)
    * Support for additional regional releases to come!

## Instructions

### Obtain Decrypted Executable

#### Obtain Decrypted Exectuable via RPCS3
1. Run rpcs3.
1. Click the `Utilities` menu, then the `Decrypt PS3 Binaries` menu item.
1. Select `eboot.bin` from Demon's Souls directory and click open.
1. rpcs3 will create an `eboot.elf` file next to `eboot.bin`, this is the decrypted file.

### Building From Release
1. Download the [latest release](https://github.com/gibbed/DemonsSoulsDebug/releases/latest) for your release (not the source ZIP!).
1. Place a decrypted copy of Demon's Souls `eboot.bin` at `boot.elf`.
1. Run `build.bat`, if all goes well `debug.elf` will be created.
1. Run it on a real PS3 or otherwise.
    * Replace the original `EBOOT.BIN` with `debug.elf` in the game directory.
        * *Will probably require turning it into a SELF for running it on a real PS3.*
    * Or just place it alongside `EBOOT.BIN`.

### Building From Source
1. Open `tools\Tools.bin` and build the entire solution with the Debug configuration.
1. Place a decrypted copy of Demon's Souls `eboot.bin` in the appropriate `bin` directory.
    * For example, US 1.00 you would put it at `bin\USv100\boot.elf`.
1. Run the build `.bat` for your release. If all goes well `debug.elf` will be created in the appropriate `bin` directory.
    * For example, US 1.00 would be `build_USv100.bat`.
1. Run it on a real PS3 or otherwise.
    * Replace the original `EBOOT.BIN` with `debug.elf` in the game directory.
        * *Will probably require turning it into a SELF for running it on a real PS3.*
    * Or just place it alongside `EBOOT.BIN`.

## TODO
* Build scripts for \*nix.
* Porting patches to additional regional releases.
    * Asia v1.04 (`BCAS20071`)
    * EU v1.00 (`BLES00932`)
