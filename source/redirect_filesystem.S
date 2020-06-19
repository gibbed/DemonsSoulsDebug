#include "helpers.inc"
#include "options.inc"
#include "symbols.inc"

.set patch_section_index, 7

#if defined(REDIRECT_FILESYSTEM_FSDS) || defined(REDIRECT_FILESYSTEM_APP_HOME)

#ifndef REDIRECT_FILESYSTEM_APP_HOME
  # /dev_hdd0/game/FSDS00000/USRDIR
  #define MY_GAME_PATH my_game_path_fsds
#else
  # /app_home/PS3_GAME/USRDIR
  #define MY_GAME_PATH my_game_path_app_home
#endif

CAVE_STRING(MY_GAME_PATH)

# Redirect FS requests for game:/
patch_data_start game_alias_pointer
  .long MY_GAME_PATH
patch_data_end game_alias_pointer

# Redirect FS requests for debug:/
patch_data_start debug_alias_pointer
  .long MY_GAME_PATH
patch_data_end debug_alias_pointer

# Redirect FS requests for capture:/
patch_data_start capture_alias_pointer
  .long MY_GAME_PATH
patch_data_end capture_alias_pointer

# Redirect FS requests for bdvd:/
patch_data_start bdvd_path_pointer
  .long MY_GAME_PATH
patch_data_end bdvd_path_pointer

#endif
