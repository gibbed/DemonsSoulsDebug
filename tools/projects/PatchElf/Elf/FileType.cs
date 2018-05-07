namespace PatchElf.Elf
{
    public enum FileType : ushort
    {
        None = 0,
        Relocatable = 1,
        Executable = 2,
        SharedObject = 3,
        Core = 4,
    }
}
