#ifndef __HELPERS_S
#define __HELPERS_S

.macro cave_start name
  .section ".cave","ax"
  .align 4
  cave_\name:
  .global \name
  \name:
.endm

.macro cave_end name, index
  cave_end_\name:
  .section ".patch_list","a"
  .global patch_entry_\name
  patch_entry_\name:
  .quad cave_\name, cave_end_\name-cave_\name, patch_section_index, 2
.endm

.macro patch_text_start name
  .text
  .org patch_target_\name-0x10200
  patch_text_\name:
.endm

.macro patch_text_end name
  patch_text_end_\name:
  .section ".patch_list","a"
  .global patch_entry_\name
  patch_entry_\name:
  .quad patch_text_\name, patch_text_end_\name-patch_text_\name, patch_section_index, 0
.endm

.macro patch_data_start name
  .data
  .org patch_target_\name-0x1850000
  patch_data_\name:
.endm

.macro patch_data_end name
  patch_data_end_\name:
  .section ".patch_list","aw"
  .global patch_entry_\name
  patch_entry_\name:
  .quad patch_data_\name, patch_data_end_\name-patch_data_\name, patch_section_index, 1
.endm

#ifdef MAKE_SYMBOLS

.macro target_text name, offset
  .section ".text"
  .org \offset-0x10200
  .global \name
  \name:
  blr
.endm

.macro target_rdata name, offset
  .section ".text"
  .org \offset-0x10200
  .global \name
  \name:
  .byte 0
.endm

.macro target_data name, offset
  .section ".data"
  .org \offset-0x1850000
  .global \name
  \name:
  .long 0
.endm

#else

.macro target_text name, offset
  .equiv patch_target_\name, \offset
.endm

.macro target_rdata name, offset
  .equiv patch_target_\name, \offset
.endm

.macro target_data name, offset
  .equiv patch_target_\name, \offset
.endm

#endif

.set patch_section_index, -1

#endif
