SECTIONS
{
  . = 0x00010200;
  OVERLAY 0x00010200 : AT(0x100010200)
  {
    .text0 { build/debug_menu.o(.text) } : code_seg
    .text1 { build/debug_menu_localize.o(.text) } : code_seg
    .text2 { build/delta_time.o(.text) } : code_seg
    .text3 { build/disable_system_cache.o(.text) } : code_seg
    .text4 { build/increase_memory_zones.o(.text) } : code_seg
    .text5 { build/lua_print_to_stdout.o(.text) } : code_seg
    .text6 { build/redirect_fs.o(.text) } : code_seg
    .text7 { build/symbols.o(.text) } : code_seg
  }

  . = 0x01842D48;
  .cave : AT(0x01842D48) { *(.cave) } : code_seg

  . = 0x01850000;
  OVERLAY 0x01850000 : AT (0x101850000)
  {
    .data0 { build/debug_menu.o(.data) } : data_seg
    .data1 { build/debug_menu_localize.o(.data) } : data_seg
    .data2 { build/delta_time.o(.data) } : data_seg
    .data3 { build/disable_system_cache.o(.data) } : data_seg
    .data4 { build/increase_memory_zones.o(.data) } : data_seg
    .data5 { build/lua_print_to_stdout.o(.data) } : data_seg
    .data6 { build/redirect_fs.o(.data) } : data_seg
    .data7 { build/symbols.o(.data) } : data_seg
  }

  .patch_list : { *(.patch_list) } : data_seg

  /DISCARD/ : { *(.start) }
}
