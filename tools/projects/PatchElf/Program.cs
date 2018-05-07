using System;
using System.Linq;
using System.Runtime.InteropServices;
using SHA1 = System.Security.Cryptography.SHA1;
using System.Globalization;
using System.Collections.Generic;
using System.IO;
using Gibbed.IO;
using NDesk.Options;

namespace PatchElf
{
    internal class Program
    {
        private static string GetExecutableName()
        {
            return Path.GetFileName(System.Reflection.Assembly.GetExecutingAssembly().CodeBase);
        }

        private static void Main(string[] args)
        {
            string verifyHash = null;
            bool addCave = false;
            long? desiredCaveAddress = null;
            long? desiredCaveSize = null;
            long? originalCodeSize = null;
            bool showHelp = false;

            var options = new OptionSet()
            {
                { "v|verify-hash=", "verify ELF hash", v => verifyHash = v },
                { "a|add-cave", "add code cave", v => addCave = v != null },
                { "dca|desired-cave-address", "check desired cave address", v => ParseValue(v, out desiredCaveAddress) },
                { "dcs|desired-cave-size", "check desired cave size", v => ParseValue(v, out desiredCaveSize) },
                { "ocs|original-code-size", "check original code size", v => ParseValue(v, out originalCodeSize) },
                { "h|help", "show this message and exit", v => showHelp = v != null },
            };

            List<string> extras;

            try
            {
                extras = options.Parse(args);
            }
            catch (OptionException e)
            {
                Console.Write("{0}: ", GetExecutableName());
                Console.WriteLine(e.Message);
                Console.WriteLine("Try `{0} --help' for more information.", GetExecutableName());
                return;
            }

            if (extras.Count < 2 || extras.Count > 3 || showHelp == true)
            {
                Console.WriteLine("Usage: {0} [OPTIONS]+ input_elf patch_elf [output_elf]", GetExecutableName());
                Console.WriteLine();
                Console.WriteLine("Options:");
                options.WriteOptionDescriptions(Console.Out);
                return;
            }

            var inputPath = extras[0];
            var patchPath = extras[1];
            var outputPath = extras.Count > 2 ? extras[2] : Path.ChangeExtension(inputPath, null) + "_patched.elf";

            Environment.ExitCode = Run(
                inputPath,
                patchPath,
                outputPath,
                verifyHash,
                addCave,
                desiredCaveAddress,
                desiredCaveSize,
                originalCodeSize);
        }

        private static int Run(string inputPath,
                               string patchPath,
                               string outputPath,
                               string verifyHash,
                               bool addCave,
                               long? desiredCaveAddress,
                               long? desiredCaveSize,
                               long? originalCodeSize)
        {
            using (var inputData = File.OpenRead(inputPath))
            using (var patchData = File.OpenRead(patchPath))
            {
                var inputElf = ElfHeader.Read(inputData);

                if (string.IsNullOrWhiteSpace(verifyHash) == false)
                {
                    var inputHash = HashElf(inputElf, 0, inputData);
                    if (inputHash != verifyHash)
                    {
                        Console.WriteLine("Hash of input ELF does not match:");
                        Console.WriteLine("  desired: {0}", verifyHash);
                        Console.WriteLine("   actual: {0}", inputHash);
                        return 1;
                    }
                }

                int codeIndex = -1;
                long newCodeSize = 0;
                ulong caveVirtualAddress = 0;
                long caveFileOffset = 0;
                long caveFileSize = 0;

                if (addCave == true)
                {
                    codeIndex = Array.FindIndex(
                        inputElf.ProgramHeaders,
                        ph => ph.Type == Elf.ProgramType.Loadable &&
                              (ph.Flags & Elf.ProgramFlags.Executable) != 0);

                    if (codeIndex + 1 >= inputElf.ProgramHeaders.Length)
                    {
                        Console.WriteLine("No program following code program.");
                        return 2;
                    }

                    var codeHeader = inputElf.ProgramHeaders[codeIndex + 0];
                    var nextHeader = inputElf.ProgramHeaders[codeIndex + 1];

                    if ((ulong)codeHeader.FileSize != codeHeader.MemorySize)
                    {
                        Console.WriteLine("Code file size does not match memory size!");
                        return 3;
                    }

                    if (originalCodeSize.HasValue == true &&
                        originalCodeSize.Value != codeHeader.FileSize)
                    {
                        Console.WriteLine("Original code size does not match:");
                        Console.WriteLine("  desired: {0}", originalCodeSize.Value);
                        Console.WriteLine("   actual: {0}", codeHeader.FileSize);
                        return 4;
                    }

                    caveFileSize = nextHeader.FileOffset - (codeHeader.FileOffset + codeHeader.FileSize);
                    caveVirtualAddress = codeHeader.VirtualAddress + (ulong)codeHeader.FileSize;
                    caveFileOffset = codeHeader.FileOffset + codeHeader.FileSize;

                    if (desiredCaveAddress.HasValue == true &&
                        (ulong)desiredCaveAddress.Value != caveVirtualAddress)
                    {
                        Console.WriteLine("Desired cave virtual address does not match:");
                        Console.WriteLine("  desired: {0}", desiredCaveAddress.Value);
                        Console.WriteLine("   actual: {0}", caveVirtualAddress);
                        return 5;
                    }

                    if (desiredCaveSize.HasValue == true &&
                        desiredCaveSize.Value != caveFileSize)
                    {
                        Console.WriteLine("Desired cave size does not match:");
                        Console.WriteLine("  desired: {0}", desiredCaveSize.Value);
                        Console.WriteLine("   actual: {0}", caveFileSize);
                        return 6;
                    }

                    newCodeSize = nextHeader.FileOffset - codeHeader.FileOffset;

                    codeHeader.FileSize = newCodeSize;
                    codeHeader.MemorySize = (ulong)newCodeSize;
                    inputElf.ProgramHeaders[codeIndex] = codeHeader;
                }

                var patchElf = ElfHeader.Read(patchData);

                var patchSectionIndex = Array.IndexOf(patchElf.SectionNames, ".patches");
                if (patchSectionIndex < 0)
                {
                    Console.WriteLine("No .patches section.");
                    return 7;
                }
                var patchSection = patchElf.SectionHeaders[patchSectionIndex];
                var patchCount = patchSection.FileSize / 32;
                var patchAddresses = new long[patchCount];
                var patchSizes = new long[patchCount];

                patchData.Position = patchSection.FileOffset;
                for (int i = 0; i < patchSection.FileSize / 32; i++)
                {
                    var patchAddressSource = patchData.ReadValueS64(Endian.Big);
                    var patchAddressStart = patchData.ReadValueS64(Endian.Big);
                    var patchAddressEnd = patchData.ReadValueS64(Endian.Big);
                    //var patchReserved = patchData.ReadValueS64(Endian.Big);
                    patchData.Position += 8;

                    if (patchAddressSource != patchAddressStart)
                    {
                        Console.WriteLine(
                            "Patch #{0} has mismatching source and start ({1:X} vs {2:X})",
                            i + 1,
                            patchAddressSource,
                            patchAddressStart);
                        return 8;
                    }

                    patchAddresses[i] = patchAddressStart;
                    patchSizes[i] = patchAddressEnd - patchAddressStart;
                }

                File.Copy(inputPath, outputPath, true);

                var attributes = File.GetAttributes(outputPath);
                if ((attributes & FileAttributes.ReadOnly) != 0)
                {
                    attributes &= ~FileAttributes.ReadOnly;
                    File.SetAttributes(outputPath, attributes);
                }

                using (var outputData = File.Open(outputPath, FileMode.Open, FileAccess.ReadWrite))
                {
                    if (addCave == true)
                    {
                        outputData.Position = outputData.Length;
                        var sectionHeadersPosition = outputData.Position;

                        var newSectionHeaders = new List<Elf.SectionHeader>(inputElf.SectionHeaders);
                        newSectionHeaders.Add(new Elf.SectionHeader()
                        {
                            Name = 0x1C,
                            Type = Elf.SectionType.Program,
                            Flags = Elf.SectionFlags.Alloc | Elf.SectionFlags.Executable,
                            VirtualAddress = caveVirtualAddress,
                            FileOffset = caveFileOffset,
                            FileSize = caveFileSize,
                            Link = 0,
                            Info = 0,
                            Align = 4,
                            EntrySize = 0,
                        });
                        foreach (var newSectionHeader in newSectionHeaders)
                        {
                            newSectionHeader.Swap();
                            outputData.WriteStructure(newSectionHeader);
                        }

                        // Update section headers info
                        outputData.Position = Marshal.OffsetOf(typeof(Elf.FileHeader), "SectionHeadersOffset").ToInt64();
                        outputData.WriteValueS64(sectionHeadersPosition, Endian.Big);
                        outputData.Position = Marshal.OffsetOf(typeof(Elf.FileHeader), "SectionHeaderCount").ToInt64();
                        outputData.WriteValueU16((ushort)newSectionHeaders.Count, Endian.Big);

                        // Update code program info
                        var programHeaderPosition =
                            inputElf.FileHeader.ProgramHeadersOffset +
                            (codeIndex * Marshal.SizeOf(typeof(Elf.ProgramHeader)));
                        outputData.Position = programHeaderPosition +
                                              Marshal.OffsetOf(typeof(Elf.ProgramHeader), "FileSize").ToInt64();
                        outputData.WriteValueS64(newCodeSize, Endian.Big);
                        outputData.Position = programHeaderPosition +
                                              Marshal.OffsetOf(typeof(Elf.ProgramHeader), "MemorySize").ToInt64();
                        outputData.WriteValueS64(newCodeSize, Endian.Big);
                    }

                    for (int i = 0; i < patchCount; i++)
                    {
                        var inputOffset = patchElf.GetFileOffset((ulong)patchAddresses[i], (uint)patchSizes[i]);
                        patchData.Position = inputOffset;

                        var outputOffset = inputElf.GetFileOffset((ulong)patchAddresses[i], (uint)patchSizes[i]);
                        outputData.Position = outputOffset;

                        outputData.WriteFromStream(patchData, patchSizes[i]);
                    }
                }
            }

            return 0;
        }

        private static void ParseValue(string v, out long? value)
        {
            if (string.IsNullOrWhiteSpace(v) == true)
            {
                value = null;
                return;
            }

            long dummy;
            if (v.StartsWith("0x") == true && long.TryParse(
                v.Substring(2),
                NumberStyles.AllowHexSpecifier,
                CultureInfo.InvariantCulture,
                out dummy) == true)
            {
                value = dummy;
                return;
            }

            if (long.TryParse(
                v,
                NumberStyles.None,
                CultureInfo.InvariantCulture,
                out dummy) == true)
            {
                value = dummy;
                return;
            }

            value = null;
        }

        private static string HashElf(ElfHeader elf, long basePosition, Stream input)
        {
            using (var sha1 = SHA1.Create())
            {
                foreach (var program in elf.ProgramHeaders)
                {
                    var type = (uint)program.Type;
                    var flags = (uint)program.Flags;

                    sha1.TransformBlock(BitConverter.GetBytes(type.Swap()), 0, 4, null, 0);
                    sha1.TransformBlock(BitConverter.GetBytes(flags.Swap()), 0, 4, null, 0);

                    if (program.Type == Elf.ProgramType.Loadable && program.MemorySize > 0)
                    {
                        sha1.TransformBlock(BitConverter.GetBytes(program.VirtualAddress.Swap()), 0, 8, null, 0);
                        sha1.TransformBlock(BitConverter.GetBytes(program.MemorySize.Swap()), 0, 8, null, 0);

                        if (program.FileSize > 0)
                        {
                            if (basePosition + program.FileOffset + program.FileSize > input.Length)
                            {
                                return null;
                            }

                            input.Position = basePosition + program.FileOffset;
                            var programBytes = input.ReadBytes((int)program.FileSize);
                            sha1.TransformBlock(programBytes, 0, programBytes.Length, null, 0);
                        }
                    }
                }
                sha1.TransformFinalBlock(new byte[0], 0, 0);
                return BitConverter.ToString(sha1.Hash).Replace("-", "").ToLowerInvariant();
            }
        }
    }
}
