#include "helpers.inc.S"
#include "options.inc.S"
#include "symbols.S"

.set patch_section_index, 7

#ifdef REDIRECT_FS

cave_start my_fsds_path
  # /dev_hdd0/game/FSDS00000/USRDIR
  .short '/','d','e','v','_','h','d','d','0','/','g','a','m','e','/','F','S','D','S','0','0','0','0','0','/','U','S','R','D','I','R',0
cave_end my_fsds_path

# Redirect FS requests for game:/
patch_data_start game_alias_pointer
  .long my_fsds_path
patch_data_end game_alias_pointer

# Redirect FS requests for debug:/
patch_data_start debug_alias_pointer
  .long my_fsds_path
patch_data_end debug_alias_pointer

# Redirect FS requests for capture:/
patch_data_start capture_alias_pointer
  .long my_fsds_path
patch_data_end capture_alias_pointer

# Redirect FS requests for bdvd:/
patch_data_start bdvd_path_pointer
  .long my_fsds_path
patch_data_end bdvd_path_pointer

#endif
