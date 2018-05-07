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
