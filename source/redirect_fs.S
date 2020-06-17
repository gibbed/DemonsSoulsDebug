#include "helpers.inc.S"
#include "options.inc.S"

.set patch_section_index, 5

#ifdef REDIRECT_FS

# Redirect FS requests for game:/
patch_text_start game_alias
  .long my_fsds_path
patch_text_end game_alias

# Redirect FS requests for debug:/
patch_text_start debug_alias
  .long my_fsds_path
patch_text_end debug_alias

# Redirect FS requests for capture:/
patch_text_start capture_alias
  .long my_fsds_path
patch_text_end capture_alias

# Redirect FS requests for bdvd:/
patch_text_start bdvd_path
  .long my_fsds_path
patch_text_end bdvd_path

#endif
