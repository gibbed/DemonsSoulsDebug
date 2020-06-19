!IF "$(LLVM_PATH)"==""
!ERROR Could not find LLVM. Please ensure the LLVM_PATH environment variable is set.
!ENDIF

!IF "$(TARGET)"==""
TARGET=US_v100
!MESSAGE No target specified. Defaulting to USv100.
!ENDIF

!IF "$(TARGET)"=="US_v100"
TARGET_ID=0
TARGET_DIR=BLUS30443v100
CODE_HASH=83681f6110d33442329073b72b8dc88a2f677172
CAVE_ADDRESS=0x01842d48
CAVE_SIZE=53944
CODE_SIZE=0x01832d48
!ELSE IF "$(TARGET)" == "JP_v104"
TARGET_ID=1
TARGET_DIR=BCJS30022v104
CODE_HASH=68544b29e92609ccb2710f485ae7708e4cb35df1
CODE_SIZE=0x01834248
CAVE_ADDRESS=0x01844248
CAVE_SIZE=48568
!ELSE IF "$(TARGET)" == "Asia_v104"
TARGET_ID=2
TARGET_DIR=BCAS20071v104
CODE_HASH=9403fe1678487def5d7f3c380b4c4fb275035378
CODE_SIZE=0x018342c8
CAVE_ADDRESS=0x018442c8
CAVE_SIZE=48440
!ELSE
!ERROR Unknown target specified!
!ENDIF

BIN_DIR=bin\$(TARGET)
BUILD_DIR=build\$(TARGET_DIR)
STRING_BIN_DIR=source\strings\bin

AS=$(LLVM_PATH)\bin\clang.exe
LD=$(LLVM_PATH)\bin\ld.lld.exe

AS_FLAGS=-target ppc64-unknown-unknown -m64 -mllvm --x86-asm-syntax=intel -DTARGET=$(TARGET_ID)
LD_FLAGS=-script "source\$(TARGET_DIR)\link.x" --no-check-sections

STRINGS=\
 $(STRING_BIN_DIR)\facegen_test_label.u16bin\
 $(STRING_BIN_DIR)\map_select_label.u16bin\
 $(STRING_BIN_DIR)\model_viewer_label.u16bin\
 $(STRING_BIN_DIR)\my_game_path_app_home.u16bin\
 $(STRING_BIN_DIR)\my_game_path_fsds.u16bin\
 $(STRING_BIN_DIR)\sfx_test_label.u16bin\
 $(STRING_BIN_DIR)\title_fs_debug_server_label.u16bin\
 $(STRING_BIN_DIR)\title_list_label.u16bin\
 $(STRING_BIN_DIR)\title_sce_server_label.u16bin

OBJECTS=\
 $(BUILD_DIR)\debug_menu.o\
 $(BUILD_DIR)\debug_menu_localize.o\
 $(BUILD_DIR)\delta_time.o\
 $(BUILD_DIR)\disable_system_cache.o\
 $(BUILD_DIR)\increase_memory_zones.o\
 $(BUILD_DIR)\load_uncompressed_files.o\
 $(BUILD_DIR)\lua_print_to_stdout.o\
 $(BUILD_DIR)\redirect_filesystem.o\
 $(BUILD_DIR)\start.o\
 $(BUILD_DIR)\symbols.o

.SUFFIXES : .s .o .txt .u16bin

all: $(BIN_DIR)\debug.elf

{source}.S{$(BUILD_DIR)}.o:
  @echo Assembling $<
  @"$(AS)" $(AS_FLAGS) -c $< -o $@

{source\strings}.txt{source\strings\bin}.u16bin:
  @echo Converting $<
  @"tools\bin\MakeStringBin.exe" "$<" "$@"

$(BIN_DIR) $(BUILD_DIR) source\strings\bin:
  @MD $@

$(BIN_DIR)\debug.elf.patch: $(BIN_DIR) $(BUILD_DIR) source\strings\bin $(STRINGS) $(OBJECTS)
  @echo Linking $@
  @"$(LD)" $(LD_FLAGS) -o $@ $(OBJECTS:\=/)

$(BIN_DIR)\debug.elf: $(BIN_DIR) $(BIN_DIR)\debug.elf.patch
  @echo Creating $@
  @"tools\bin\PatchElf.exe" $(BIN_DIR)\boot.elf $(BIN_DIR)\debug.elf.patch $(BIN_DIR)\debug.elf -v $(CODE_HASH) -a --dca=$(CAVE_ADDRESS) --dcs=$(CAVE_SIZE) --ocs=$(CODE_SIZE)
