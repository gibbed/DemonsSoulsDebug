#include "helpers.S"

# Increase memory zones so Northern Limit files can load without crashing.
#define INCREASE_MEM

# Redirect FS to FSDS0000 for easy modding on real PS3.
#undef REDIRECT_FS

.globl _start
# Just a dummy to shut the linker up. Unused.
_start:
  blr

target get_debug_menu_root, 0x00015328

target create_debug_menu, 0x00015A58

patch call_render_debug_menu, 0x0001BB38
  bl my_render_debug_menu
patchend call_render_debug_menu

patch call_create_debug_menu, 0x00020F44
  bl my_create_debug_menu
patchend call_create_debug_menu

target get_hg_man_instance, 0x00023878

#ifdef INCREASE_MEM

patch allocate_memory_debug_1, 0x0003A1FC
  lis %r3, 0x80
patchend allocate_memory_debug_1

patch allocate_memory_debug_2, 0x0003A244
  lis %r5, 0x80
patchend allocate_memory_debug_2

patch allocate_memory_debug_3, 0x0003A2B0
  lis %r5, 0x80
patchend allocate_memory_debug_3

patch allocate_memory_coreres, 0x0003B3FC
  lis %r3, 0xE4
patchend allocate_memory_coreres

patch allocate_memory_coreres_2, 0x0003B444
  lis %r5, 0xE4
patchend allocate_memory_coreres_2

patch allocate_memory_coreres_3, 0x0003B4B0
  lis %r5, 0xE4
patchend allocate_memory_coreres_3

#endif

target init_debug_title_menu, 0x0015C878

# Start up with the debug title menu instead of the normal title menu.
patch setup_title_menu, 0x0016F444
  bl init_debug_title_menu
patchend setup_title_menu

target init_title_menu, 0x0018B7D0

target get_pad, 0x001C4AE0

target disable_pad, 0x001C6760
target enable_pad, 0x001C67A8

target update_selected_node_keys, 0x00400190

target advance_dbgmenuhgdraw_timer, 0x004008A0

target update_dbgmenuhgdraw, 0x00400F30

target draw_dbgmenuhgdraw_box, 0x401C60

#target create_debug_menu_label, 0x00407518
target create_debug_menu_label, 0x00406F08

target fsds_path, 0x016BCBC0 # /dev_hdd0/game/FSDS00000/

patch model_viewer_label, 0x016C7C00
  # Model Viewer
  .short 'M','o','d','e','l',' ','V','i','e','w','e','r',0
patchend model_viewer_label

patch map_select_label, 0x016C7C30
  # Map Select
  .short 'M','a','p',' ','S','e','l','e','c','t',0
patchend map_select_label

patch facegen_test_label, 0x016C7C68
  # FaceGen Test
  .short 'F','a','c','e','G','e','n',' ','T','e','s','t',0
patchend facegen_test_label

patch title_list_label, 0x016C7C90
  # Title List
  .short 'T','i','t','l','e',' ','L','i','s','t',0
patchend title_list_label

patch title_fs_debug_server_label, 0x016C7CB8
  # Title (FS debug server)
  .short 'T','i','t','l','e',' ','(','F','S',' ','d','e','b','u','g',' ','s','e','r','v','e','r',')',0
patchend title_fs_debug_server_label

patch title_sce_label, 0x016C7CF0
  # Title (SCE server)
  .short 'T','i','t','l','e',' ','(','S','C','E',' ','s','e','r','v','e','r',')',0
patchend title_sce_label

patch my_create_debug_menu, 0x01842D48
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
patchend my_create_debug_menu

patch2 get_debug_menu, my_create_debug_menu
  lwz %r3, -0x7F98(%r2)
  lwz %r3, -0x7FFC(%r3)
  lwz %r3, 0(%r3)
  clrldi %r3, %r3, 32
  blr
patchend get_debug_menu

patch2 my_render_debug_menu, get_debug_menu
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

  bl get_debug_menu
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
patchend my_render_debug_menu

patch2 sfx_test_label, my_render_debug_menu
  .short 'S','F','X',' ','T','e','s','t',0
patchend sfx_test_label

patch2 my_fsds_path, sfx_test_label
  # /dev_hdd0/game/FSDS00000/USRDIR
  .short '/','d','e','v','_','h','d','d','0','/','g','a','m','e','/','F','S','D','S','0','0','0','0','0','/','U','S','R','D','I','R',0,0
patchend my_fsds_path

#ifdef REDIRECT_FS

# Redirect FS requests for game://
patch game_alias, 0x01853164
  .long my_fsds_path
patchend game_alias

# Redirect FS requests for debug://
patch debug_alias, 0x0185316C
  .long my_fsds_path
patchend debug_alias

# Redirect FS requests for capture://
patch capture_alias, 0x01853174
  .long my_fsds_path
patchend capture_alias

#endif

patch sfx_test_label_pointer, 0x01857114
  .long sfx_test_label
patchend sfx_test_label_pointer

#ifdef REDIRECT_FS

# Redirect FS requests for bdvd://
patch bdvd_path, 0x019027F0
  .long my_fsds_path
patchend bdvd_path

#endif
