#ifndef __OPTIONS_S
#define __OPTIONS_S

# Enable debug menu patches.
#define DEBUG_MENU

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

#endif
