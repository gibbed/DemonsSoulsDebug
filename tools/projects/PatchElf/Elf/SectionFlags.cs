using System;

namespace PatchElf.Elf
{
    [Flags]
    public enum SectionFlags : ulong
    {
        // ReSharper disable InconsistentNaming
        None = 0u,
        Writable = 1u << 0,
        Alloc = 1u << 1,
        Executable = 1u << 2,
        Mergable = 1u << 4,
        StringTable = 1u << 5,
        InfoLink = 1u << 6,
        LinkOrder = 1u << 7,
        NonConforming = 1u << 8,
        Grouped = 1u << 9,
        TLS = 1u << 10,
        // ReSharper restore InconsistentNaming
    }
}
