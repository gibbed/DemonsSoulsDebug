SECTIONS
{
  . = 0x00010200;
  OVERLAY 0x00010200 : AT(0x100010200)
  {
    .text0 { build/BCJS30022v104/debug_menu.o(.text) } : code_seg
    .text1 { build/BCJS30022v104/debug_menu_localize.o(.text) } : code_seg
    .text2 { build/BCJS30022v104/delta_time.o(.text) } : code_seg
    .text3 { build/BCJS30022v104/disable_system_cache.o(.text) } : code_seg
    .text4 { build/BCJS30022v104/increase_memory_zones.o(.text) } : code_seg
    .text5 { build/BCJS30022v104/load_uncompressed_files.o(.text) } : code_seg
    .text6 { build/BCJS30022v104/lua_print_to_stdout.o(.text) } : code_seg
    .text7 { build/BCJS30022v104/redirect_fs.o(.text) } : code_seg
    .text8 { build/BCJS30022v104/symbols.o(.text) } : code_seg
  }

  . = 0x01844248;
  .cave : AT(0x01844248) { *(.cave) } : code_seg

  . = 0x01850000;
  OVERLAY 0x01850000 : AT (0x101850000)
  {
    .data0 { build/BCJS30022v104/debug_menu.o(.data) } : data_seg
    .data1 { build/BCJS30022v104/debug_menu_localize.o(.data) } : data_seg
    .data2 { build/BCJS30022v104/delta_time.o(.data) } : data_seg
    .data3 { build/BCJS30022v104/disable_system_cache.o(.data) } : data_seg
    .data4 { build/BCJS30022v104/increase_memory_zones.o(.data) } : data_seg
    .data5 { build/BCJS30022v104/load_uncompressed_files.o(.data) } : data_seg
    .data6 { build/BCJS30022v104/lua_print_to_stdout.o(.data) } : data_seg
    .data7 { build/BCJS30022v104/redirect_fs.o(.data) } : data_seg
    .data8 { build/BCJS30022v104/symbols.o(.data) } : data_seg
  }

  .patch_list : { *(.patch_list) } : data_seg

  /DISCARD/ : { *(.start) }
}
