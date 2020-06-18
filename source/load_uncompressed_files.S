#include "helpers.inc.S"
#include "options.inc.S"
#include "symbols.S"

.set patch_section_index, 5

#ifdef LOAD_UNCOMPRESSED_FILES

patch_text_start load_uncompressed_files_1
  nop
patch_text_end  load_uncompressed_files_1

patch_text_start load_uncompressed_files_2
  nop
patch_text_end load_uncompressed_files_2

patch_text_start load_uncompressed_files_3
  b load_uncompressed_files_3_target
patch_text_end load_uncompressed_files_3

patch_text_start load_uncompressed_files_4
  beq %cr7, load_uncompressed_files_4_target
patch_text_end load_uncompressed_files_4

#endif
