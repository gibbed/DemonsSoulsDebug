using System.Runtime.InteropServices;
using Gibbed.IO;

namespace PatchElf.Elf
{
    [StructLayout(LayoutKind.Sequential)]
    public struct FileHeader
    {
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 16)]
        public byte[] Ident;
        public FileType Type;
        public FileMachine Machine;
        public uint Version;
        public ulong Entry;
        public long ProgramHeadersOffset;
        public long SectionHeadersOffset;
        public FileFlags Flags;
        public ushort HeaderSize;
        public ushort ProgramHeaderEntrySize;
        public ushort ProgramHeaderCount;
        public ushort SectionHeaderEntrySize;
        public ushort SectionHeaderCount;
        public ushort SectionHeaderStringTableIndex;

        public void Swap()
        {
            this.Type = (FileType)(((ushort)this.Type).Swap());
            this.Machine = (FileMachine)(((ushort)this.Machine).Swap());
            this.Version = this.Version.Swap();
            this.Entry = this.Entry.Swap();
            this.ProgramHeadersOffset = this.ProgramHeadersOffset.Swap();
            this.SectionHeadersOffset = this.SectionHeadersOffset.Swap();
            this.Flags = (FileFlags)(((uint)this.Flags).Swap());
            this.HeaderSize = this.HeaderSize.Swap();
            this.ProgramHeaderEntrySize = this.ProgramHeaderEntrySize.Swap();
            this.ProgramHeaderCount = this.ProgramHeaderCount.Swap();
            this.SectionHeaderEntrySize = this.SectionHeaderEntrySize.Swap();
            this.SectionHeaderCount = this.SectionHeaderCount.Swap();
            this.SectionHeaderStringTableIndex = this.SectionHeaderStringTableIndex.Swap();
        }
    }
}
