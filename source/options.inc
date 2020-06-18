#ifndef __OPTIONS_S
#define __OPTIONS_S

# Enable runtime debug menu.
#define DEBUG_MENU

# Enable title debug menu.
#define TITLE_DEBUG_MENU

# Increase memory zones so Northern Limit files can load without crashing.
#define INCREASE_MEMORY_ZONES

# Redirect FS to FSDS0000 for easy modding on real PS3.
#undef REDIRECT_FS

# Disable system cache.
# This is probably good for emulators (RPCS3).
# This is probably BAD(!) on a real PS3 when loading from BDVD.
#define DISABLE_SYSTEM_CACHE

# Make lua's print() output to stdout
#define LUA_PRINT_TO_STDOUT

# Enable Whatcookie's delta time patch.
# This is probably BAD(!) on a real PS3.
#define DELTA_TIME

# Load uncompressed files instead of the compressed (and encrypted) ones.
# Based on Wulf2k's work.
#define LOAD_UNCOMPRESSED_FILES

#endif
