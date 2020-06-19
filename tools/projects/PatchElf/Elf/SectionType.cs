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

namespace PatchElf.Elf
{
    public enum SectionType : uint
    {
        Null = 0,
        Program = 1,
        SymbolTable = 2,
        StringTable = 3,
        RelocationsWithAddends = 4,
        SymbolHashTable = 5,
        Dynamic = 6,
        Note = 7,
        NoData = 8,
        Relocations = 9,
        DynamicLinkerSymbolTable = 11,
        ArrayOfConstructors = 14,
        ArrayOfDestructors = 15,
        ArrayOfPreConstructors = 16,
        Group = 17,
        ExtendedSectionIndices = 18,
    }
}
