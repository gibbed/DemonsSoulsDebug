#include "helpers.inc"
#include "options.inc"

#if TARGET==0
#include "BLUS30443v100/symbols.inc"
#elif TARGET==1
#include "BCJS30022v104/symbols.inc"
#elif TARGET==2
#include "BCAS20071v104/symbols.inc"
#else
#error Unknown target version.
#endif
