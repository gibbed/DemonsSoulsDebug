#include "helpers.inc.S"
#include "options.inc.S"
#include "symbols.S"

.set patch_section_index, 0

#ifdef DEBUG_MENU

patch_text_start call_render_debug_menu
  bl my_render_debug_menu
patch_text_end call_render_debug_menu

patch_text_start call_create_debug_menu
  bl my_create_debug_menu
patch_text_end call_create_debug_menu

#endif

#ifdef TITLE_DEBUG_MENU

patch_text_start call_init_title_menu
  bl init_debug_title_menu
patch_text_end call_init_title_menu

#endif

#ifdef DEBUG_MENU

cave_start my_create_debug_menu
  stdu %r1, -16(%r1)
  mfspr %r0, %lr
  std %r30, 0(%r1)
  std %r0, 8(%r1)

  bl create_debug_menu
  nop
  mr %r30, %r3

  lwz %r3, -0x6B74(%r2)
  lwz %r3, -0x7F6C(%r3) # L"ROOT"
  bl create_debug_menu_label
  nop
  stw %r3, 4(%r30)

  mr %r3, %r30

  ld %r0, 8(%r1)
  ld %r30, 0(%r1)
  mtspr %lr, %r0
  addi %r1, %r1, 16
  blr
cave_end my_create_debug_menu

cave_start my_get_debug_menu
  lwz %r3, -0x7F98(%r2)
  lwz %r3, -0x7FFC(%r3)
  lwz %r3, 0(%r3)
  clrldi %r3, %r3, 32
  blr
cave_end my_get_debug_menu

cave_start my_render_debug_menu
  mfspr %r12, %lr

  stfd %f31, -0x70(%r1)
  std %r20, -0x68(%r1)
  std %r21, -0x60(%r1)
  std %r22, -0x58(%r1)
  std %r23, -0x50(%r1)
  std %r24, -0x48(%r1)
  std %r25, -0x40(%r1)
  std %r26, -0x38(%r1)
  std %r27, -0x30(%r1)
  std %r28, -0x28(%r1)
  std %r29, -0x20(%r1)
  std %r30, -0x18(%r1)
  std %r31, -0x10(%r1)
  stw %r12, -8(%r1)
  stwu %r1, -0x80(%r1)

  bl my_get_debug_menu
  nop

  mr %r28, %r3 # save debug menu
  cmplwi %cr6, %r28, 0
  beq %cr6, _done

  lwz %r29, 12(%r28) # get draw
  cmplwi %cr6, %r29, 0
  beq %cr6, _done

  lwz %r30, 4(%r28) # get root node
  cmplwi %cr6, %r30, 0
  beq %cr6, _done

  lwz %r3, 8(%r28)
  cmplwi %cr6, %r3, 0
  beq %cr6, _no_input

  bl update_selected_node_keys
  nop

  lwz %r11, 8(%r28)
  lhz %r11, 0x0C(%r11)
  clrlwi. %r11, %r11, 31
  beq _skip_toggle

  lwz %r11, 0x10(%r28)
  li %r9, 3
  li %r10, 1
  addi %r8, %r11, 4
  addi %r11, %r11, -1
  divw %r9, %r8, %r9
  addic %r11, %r11, -1
  mulli %r11, %r9, 3
  subf %r11, %r11, %r8
  subfe %r9, %r7, %r7
  addi %r8, %r11, -1
  stw %r11, 0x10(%r28)
  cmplwi %cr6, %r11, 1
  beq %cr6, _set_focused

  li %r11, 0
  stb %r11, 0x60(%r29)
  b _skip_set_focused

_set_focused:
  li %r11, 1
  stb %r11, 0x60(%r29)

_skip_set_focused:
  and %r10, %r9, %r10
  addic %r8, %r8, -1
  li %r11, 1
  subfe %r9, %r8, %r8
  clrlwi %r10, %r10, 24
  and %r11, %r9, %r11
  clrlwi %r11, %r11, 24
  cmplw %cr6, %r10, %r11
  beq %cr6, _skip_toggle

  cmplwi %cr6, %r11, 0
  beq %cr6, _disable_game_input

_enable_game_input:
  li %r4, 0
  li %r3, 0
  bl enable_pad
  li %r4, 1
  li %r3, 0
  bl enable_pad
  li %r4, 3
  li %r3, 0
  bl enable_pad
  b _skip_toggle

_disable_game_input:
  li %r4, 0
  li %r3, 0
  bl disable_pad
  li %r4, 1
  li %r3, 0
  bl disable_pad
  li %r4, 3
  li %r3, 0
  bl disable_pad

_skip_toggle:
  lwz %r3, 0x10(%r28)
  cmplwi %cr6, %r3, 1
  bne %cr6, _no_input

  li %r3, -1
  extsw %r3, %r3
  lwz %r4, 8(%r28)
  stw %r3, 4(%r4)

  mr %r31, %r2

  lwz %r3, 0(%r30) # get vtable
  lwz %r3, 8(%r3) # get sub3
  lwz %r2, 4(%r3) # get rtoc
  lwz %r3, 0(%r3) # get function
  mtspr %ctr, %r3

  li %r5, 1
  lwz %r4, 8(%r28)
  mr %r3, %r30
  bctrl

  mr %r2, %r31

_no_input:
  mr %r3, %r29
  bl update_dbgmenuhgdraw
  nop

  lwz %r3, -0x7AA0(%r2)
  lfs %f1, -0x7D50(%r3)
  mr %r3, %r29
  bl advance_dbgmenuhgdraw_timer
  nop

  lwz %r3, 0x10(%r28)
  cmplwi %cr6, %r3, 0
  beq %cr6, _done

  mr %r3, %r29
  bl draw_dbgmenuhgdraw_box
  nop

  li %r3, -1
  extsw %r3, %r3
  stw %r3, 4(%r29)

  mr %r31, %r2

  lwz %r3, 0(%r30) # get vtable
  lwz %r3, 12(%r3) # get sub3
  lwz %r2, 4(%r3) # get rtoc
  lwz %r3, 0(%r3) # get function
  mtspr %ctr, %r3

  li %r5, 1
  mr %r4, %r29
  mr %r3, %r30
  bctrl

  mr %r2, %r31

_done:
  addi %r1, %r1, 0x80
  lfd %f31, -0x70(%r1)
  ld %r20, -0x68(%r1)
  ld %r21, -0x60(%r1)
  ld %r22, -0x58(%r1)
  ld %r23, -0x50(%r1)
  ld %r24, -0x48(%r1)
  ld %r25, -0x40(%r1)
  ld %r26, -0x38(%r1)
  ld %r27, -0x30(%r1)
  ld %r28, -0x28(%r1)
  ld %r29, -0x20(%r1)
  ld %r30, -0x18(%r1)
  ld %r31, -0x10(%r1)
  lwz %r12, -8(%r1)
  mtspr %lr, %r12
  blr
cave_end my_render_debug_menu

#endif
