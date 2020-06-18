#include "helpers.inc"
#include "options.inc"
#include "symbols.inc"

.set patch_section_index, 3

#ifdef DISABLE_SYSTEM_CACHE

patch_text_start load_use_system_cache_default_value
  clrldi %r4, %r21, 32
patch_text_end load_use_system_cache_default_value

#endif
