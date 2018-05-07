using System.Runtime.InteropServices;
using Gibbed.IO;

namespace PatchElf.Elf
{
    [StructLayout(LayoutKind.Sequential)]
    public struct ProgramHeader
    {
        public ProgramType Type;
        public ProgramFlags Flags;
        public long FileOffset;
        public ulong VirtualAddress;
        public ulong PhysicalAddress;
        public long FileSize;
        public ulong MemorySize;
        public ulong Align;

        public void Swap()
        {
            this.Type = (ProgramType)(((uint)this.Type).Swap());
            this.Flags = (ProgramFlags)(((uint)this.Flags).Swap());
            this.FileOffset = this.FileOffset.Swap();
            this.VirtualAddress = this.VirtualAddress.Swap();
            this.PhysicalAddress = this.PhysicalAddress.Swap();
            this.FileSize = this.FileSize.Swap();
            this.MemorySize = this.MemorySize.Swap();
            this.Align = this.Align.Swap();
        }
    }
}
