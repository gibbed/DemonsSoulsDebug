#include "helpers.inc.S"
#include "options.inc.S"
#include "symbols.S"

.set patch_section_index, 5

#ifdef LUA_PRINT_TO_STDOUT

patch_data_start lua_print_pointer
  .long luaB_print
patch_data_end lua_print_pointer

#endif
