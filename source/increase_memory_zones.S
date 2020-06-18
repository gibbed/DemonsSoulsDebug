#include "helpers.inc.S"
#include "options.inc.S"
#include "symbols.S"

.set patch_section_index, 4

#ifdef INCREASE_MEMORY_ZONES

patch_text_start allocate_memory_debug_1
  lis %r3, 0x80
patch_text_end allocate_memory_debug_1

patch_text_start allocate_memory_debug_2
  lis %r5, 0x80
patch_text_end allocate_memory_debug_2

patch_text_start allocate_memory_debug_3
  lis %r5, 0x80
patch_text_end allocate_memory_debug_3

patch_text_start allocate_memory_coreres_1
  lis %r3, 0xE4
patch_text_end allocate_memory_coreres_1

patch_text_start allocate_memory_coreres_2
  lis %r5, 0xE4
patch_text_end allocate_memory_coreres_2

patch_text_start allocate_memory_coreres_3
  lis %r5, 0xE4
patch_text_end allocate_memory_coreres_3

#endif
