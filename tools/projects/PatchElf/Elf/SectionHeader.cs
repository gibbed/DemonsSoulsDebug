using System.Runtime.InteropServices;
using Gibbed.IO;

namespace PatchElf.Elf
{
    [StructLayout(LayoutKind.Sequential)]
    public struct SectionHeader
    {
        public uint Name;
        public SectionType Type;
        public SectionFlags Flags;
        public ulong VirtualAddress;
        public long FileOffset;
        public long FileSize;
        public uint Link;
        public uint Info;
        public ulong Align;
        public ulong EntrySize;

        public void Swap()
        {
            this.Name = this.Name.Swap();
            this.Type = (SectionType)(((uint)this.Type).Swap());
            this.Flags = (SectionFlags)(((ulong)this.Flags).Swap());
            this.VirtualAddress = this.VirtualAddress.Swap();
            this.FileOffset = this.FileOffset.Swap();
            this.FileSize = this.FileSize.Swap();
            this.Link = this.Link.Swap();
            this.Info = this.Info.Swap();
            this.Align = this.Align.Swap();
            this.EntrySize = this.EntrySize.Swap();
        }
    }

}
