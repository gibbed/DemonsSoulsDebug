!IF "$(LLVM_PATH)"==""
!ERROR Could not find LLVM. Please ensure the LLVM_PATH environment variable is set.
!ENDIF

!IF "$(TARGET)"==""
TARGET=USv100
!MESSAGE No target specified. Defaulting to USv100.
!ENDIF

!IF "$(TARGET)"=="USv100"
TARGET_ID=0
TARGET_DIR=BLUS30443v100
CODE_HASH=83681f6110d33442329073b72b8dc88a2f677172
CAVE_ADDRESS=0x01842d48
CAVE_SIZE=53944
CODE_SIZE=0x01832d48
!ELSE IF "$(TARGET)" == "JPv104"
TARGET_ID=1
TARGET_DIR=BCJS30022v104
CODE_HASH=68544b29e92609ccb2710f485ae7708e4cb35df1
CODE_SIZE=0x01834248
CAVE_ADDRESS=0x01844248
CAVE_SIZE=48568
!ELSE
!ERROR Unknown target specified!
!ENDIF

BIN_DIR=bin\$(TARGET)
BUILD_DIR=build\$(TARGET_DIR)

AS=$(LLVM_PATH)\bin\clang.exe
LD=$(LLVM_PATH)\bin\ld.lld.exe

AS_FLAGS=-target ppc64-unknown-unknown -m64 -mllvm --x86-asm-syntax=intel -DTARGET=$(TARGET_ID)
LD_FLAGS=-script "source\$(TARGET_DIR)\link.x" --no-check-sections

OBJECTS=\
 $(BUILD_DIR)\debug_menu.o\
 $(BUILD_DIR)\debug_menu_localize.o\
 $(BUILD_DIR)\delta_time.o\
 $(BUILD_DIR)\disable_system_cache.o\
 $(BUILD_DIR)\increase_memory_zones.o\
 $(BUILD_DIR)\load_uncompressed_files.o\
 $(BUILD_DIR)\lua_print_to_stdout.o\
 $(BUILD_DIR)\redirect_fs.o\
 $(BUILD_DIR)\start.o\
 $(BUILD_DIR)\symbols.o

.SUFFIXES : .s .o

all: $(BIN_DIR)\debug.elf

{source}.S{$(BUILD_DIR)}.o:
  @echo Assembling $<
  @"$(AS)" $(AS_FLAGS) -c $< -o $@

$(BIN_DIR) $(BUILD_DIR):
  @MD $@

$(BIN_DIR)\debug.elf.patch: $(BIN_DIR) $(BUILD_DIR) $(OBJECTS)
  @echo Linking $@
  @"$(LD)" $(LD_FLAGS) -o $@ $(OBJECTS:\=/)

$(BIN_DIR)\debug.elf: $(BIN_DIR) $(BIN_DIR)\debug.elf.patch
  @echo Creating $@
  @"tools\bin\PatchElf.exe" $(BIN_DIR)\boot.elf $(BIN_DIR)\debug.elf.patch $(BIN_DIR)\debug.elf -v $(CODE_HASH) -a --dca=$(CAVE_ADDRESS) --dcs=$(CAVE_SIZE) --ocs=$(CODE_SIZE)
