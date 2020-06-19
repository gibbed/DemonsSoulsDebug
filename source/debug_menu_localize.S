#include "helpers.inc"
#include "options.inc"
#include "symbols.inc"

.set patch_section_index, 1

#ifdef TITLE_DEBUG_MENU

PATCH_TEXT_STRING(model_viewer_label)          # Model Viewer
PATCH_TEXT_STRING(map_select_label)            # Map Select
PATCH_TEXT_STRING(facegen_test_label)          # FaceGen Test
PATCH_TEXT_STRING(title_list_label)            # Title List
PATCH_TEXT_STRING(title_fs_debug_server_label) # Title (FS debug server)
PATCH_TEXT_STRING(title_sce_server_label)      # Title (SCE server)

CAVE_STRING(sfx_test_label)                    # SFX Test

patch_data_start sfx_test_label_pointer
  .long sfx_test_label
patch_data_end sfx_test_label_pointer

#endif
