using System;

namespace PatchElf.Elf
{
    [Flags]
    public enum ProgramFlags : uint
    {
        None = 0,
        Executable = 1 << 0,
        Writable = 1 << 1,
        Readable = 1 << 2,
    }
}
