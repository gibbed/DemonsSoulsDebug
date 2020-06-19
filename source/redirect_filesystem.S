#include "helpers.inc"
#include "options.inc"
#include "symbols.inc"

.set patch_section_index, 7

#if defined(REDIRECT_FILESYSTEM_FSDS) || defined(REDIRECT_FILESYSTEM_APP_HOME)

cave_start my_game_path
#ifndef REDIRECT_FILESYSTEM_APP_HOME
  # /dev_hdd0/game/FSDS00000/USRDIR
  .short '/','d','e','v','_','h','d','d','0','/','g','a','m','e','/','F','S','D','S','0','0','0','0','0','/','U','S','R','D','I','R',0
#else
  # /app_home/PS3_GAME/USRDIR
  .short '/','a','p','p','_','h','o','m','e','/','P','S','3','_','G','A','M','E','/','U','S','R','D','I','R',0
#endif
cave_end my_game_path

# Redirect FS requests for game:/
patch_data_start game_alias_pointer
  .long my_game_path
patch_data_end game_alias_pointer

# Redirect FS requests for debug:/
patch_data_start debug_alias_pointer
  .long my_game_path
patch_data_end debug_alias_pointer

# Redirect FS requests for capture:/
patch_data_start capture_alias_pointer
  .long my_game_path
patch_data_end capture_alias_pointer

# Redirect FS requests for bdvd:/
patch_data_start bdvd_path_pointer
  .long my_game_path
patch_data_end bdvd_path_pointer

#endif
