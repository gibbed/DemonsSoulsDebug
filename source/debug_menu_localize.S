#include "helpers.inc.S"
#include "options.inc.S"
#include "symbols.S"

.set patch_section_index, 1

#ifdef DEBUG_MENU

# Model Viewer
patch_text_start model_viewer_label
  .short 'M','o','d','e','l',' ','V','i','e','w','e','r',0
patch_text_end model_viewer_label

# Map Select
patch_text_start map_select_label
  .short 'M','a','p',' ','S','e','l','e','c','t',0
patch_text_end map_select_label

# FaceGen Test
patch_text_start facegen_test_label
  .short 'F','a','c','e','G','e','n',' ','T','e','s','t',0
patch_text_end facegen_test_label

# Title List
patch_text_start title_list_label
  .short 'T','i','t','l','e',' ','L','i','s','t',0
patch_text_end title_list_label

# Title (FS debug server)
patch_text_start title_fs_debug_server_label
  .short 'T','i','t','l','e',' ','(','F','S',' ','d','e','b','u','g',' ','s','e','r','v','e','r',')',0
patch_text_end title_fs_debug_server_label

# Title (SCE server)
patch_text_start title_sce_server_label
  .short 'T','i','t','l','e',' ','(','S','C','E',' ','s','e','r','v','e','r',')',0
patch_text_end title_sce_server_label

#endif
