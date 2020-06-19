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
