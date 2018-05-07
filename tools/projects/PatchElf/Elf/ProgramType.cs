namespace PatchElf.Elf
{
    public enum ProgramType : uint
    {
        // ReSharper disable InconsistentNaming
        Null = 0,
        Loadable = 1,
        Dynamic = 2,
        Interpreter = 3,
        Note = 4,
        Header = 6,
        TLS = 7,
        // ReSharper restore InconsistentNaming
    }
}
