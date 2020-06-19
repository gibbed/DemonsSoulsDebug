﻿/* Copyright (c) 2020 Rick (rick 'at' gibbed 'dot' us)
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

using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using Gibbed.IO;
using PatchElf.Elf;

namespace PatchElf
{
    internal class ElfHeader
    {
        private FileHeader _FileHeader;
        private ProgramHeader[] _ProgramHeaders;
        private SectionHeader[] _SectionHeaders;
        private string[] _SectionNames;

        private ElfHeader()
        {
        }

        public FileHeader FileHeader
        {
            get { return this._FileHeader; }
            set { this._FileHeader = value; }
        }

        public ProgramHeader[] ProgramHeaders
        {
            get { return this._ProgramHeaders; }
            set { this._ProgramHeaders = value; }
        }

        public SectionHeader[] SectionHeaders
        {
            get { return this._SectionHeaders; }
            set { this._SectionHeaders = value; }
        }

        public string[] SectionNames
        {
            get { return this._SectionNames; }
            set { this._SectionNames = value; }
        }

        public int GetProgramIndexForVirtulAddress(ulong virtualAddress, uint size)
        {
            return Array.FindIndex(
                this._ProgramHeaders,
                ph => virtualAddress >= ph.VirtualAddress &&
                      virtualAddress + size <= ph.VirtualAddress + (ulong)ph.FileSize);
        }

        public long GetFileOffset(ulong virtualAddress, uint size)
        {
            var index = this.GetProgramIndexForVirtulAddress(virtualAddress, size);
            if (index >= 0)
            {
                var program = this._ProgramHeaders[index];
                var offset = virtualAddress - program.VirtualAddress;
                if (offset + size > (ulong)program.FileSize)
                {
                    throw new InvalidOperationException();
                }
                return program.FileOffset + (long)offset;
            }

            throw new InvalidOperationException();
        }

        public static ElfHeader Read(Stream input)
        {
            var fileHeader = input.ReadStructure<FileHeader>();
            fileHeader.Swap();

            if (fileHeader.HeaderSize != Marshal.SizeOf(fileHeader))
            {
                throw new FormatException("size mismatch for ELF header size");
            }

            input.Seek(fileHeader.ProgramHeadersOffset, SeekOrigin.Begin);
            var programHeaders = new ProgramHeader[fileHeader.ProgramHeaderCount];
            for (int i = 0; i < programHeaders.Length; i++)
            {
                programHeaders[i] = input.ReadStructure<ProgramHeader>();
                if (fileHeader.ProgramHeaderEntrySize != Marshal.SizeOf(programHeaders[i]))
                {
                    throw new FormatException("size mismatch for ELF program header size");
                }
                programHeaders[i].Swap();
            }

            input.Seek(fileHeader.SectionHeadersOffset, SeekOrigin.Begin);
            var sectionHeaders = new SectionHeader[fileHeader.SectionHeaderCount];
            for (int i = 0; i < sectionHeaders.Length; i++)
            {
                sectionHeaders[i] = input.ReadStructure<SectionHeader>();
                if (fileHeader.SectionHeaderEntrySize != Marshal.SizeOf(sectionHeaders[i]))
                {
                    throw new FormatException("size mismatch for ELF section header size");
                }
                sectionHeaders[i].Swap();
            }

            var sectionNames = new string[fileHeader.SectionHeaderCount];
            if (fileHeader.SectionHeaderStringTableIndex < fileHeader.SectionHeaderCount)
            {
                var stringTableHeader = sectionHeaders[fileHeader.SectionHeaderStringTableIndex];
                for (int i = 0; i < sectionHeaders.Length; i++)
                {
                    input.Seek(stringTableHeader.FileOffset + sectionHeaders[i].Name, SeekOrigin.Begin);
                    sectionNames[i] = input.ReadStringZ(Encoding.ASCII);
                }
            }

            return new ElfHeader()
            {
                _FileHeader = fileHeader,
                _ProgramHeaders = programHeaders,
                _SectionHeaders = sectionHeaders,
                _SectionNames = sectionNames,
            };
        }
    }
}
