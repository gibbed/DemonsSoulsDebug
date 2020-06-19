/* Copyright (c) 2020 Rick (rick 'at' gibbed 'dot' us)
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would
 *    be appreciated but is not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not
 *    be misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source
 *    distribution.
 */

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
