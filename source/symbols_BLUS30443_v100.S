#include "helpers.inc.S"

# .text

target_text get_debug_menu_root,                  0x00015328
target_text create_debug_menu,                    0x00015A58
target_text call_delta_time,                      0x0001B95C
target_text call_render_debug_menu,               0x0001BB38
target_text call_create_debug_menu,               0x00020F44
target_text get_hg_man_instance,                  0x00023878
target_text initialize_flip_mode,                 0x00025ED8
target_text allocate_memory_debug_1,              0x0003A1FC
target_text allocate_memory_debug_2,              0x0003A244
target_text allocate_memory_debug_3,              0x0003A2B0
target_text allocate_memory_coreres,              0x0003B3FC
target_text allocate_memory_coreres_2,            0x0003B444
target_text allocate_memory_coreres_3,            0x0003B4B0
target_text load_use_system_cache_default_value,  0x0004A36C
target_text init_debug_title_menu,                0x0015C878
target_text setup_title_menu,                     0x0016F444
target_text init_title_menu,                      0x0018B7D0
target_text get_pad,                              0x001C4AE0
target_text disable_pad,                          0x001C6760
target_text enable_pad,                           0x001C67A8
target_text update_selected_node_keys,            0x00400190
target_text advance_dbgmenuhgdraw_timer,          0x004008A0
target_text update_dbgmenuhgdraw,                 0x00400F30
target_text draw_dbgmenuhgdraw_box,               0x00401C60
#target_text create_debug_menu_label,              0x00407518
target_text create_debug_menu_label,              0x00406F08
target_text load_uncompressed_files_1,            0x0066AEFC
target_text load_uncompressed_files_2,            0x0066AF08
target_text load_uncompressed_files_3_target,     0x0066AF0C
target_text load_uncompressed_files_3,            0x0066B024
target_text load_uncompressed_files_4,            0x008EEF78
target_text load_uncompressed_files_4_target,     0x008EF168
target_text fs_lua_print,                         0x00C02C78
target_text luaB_print,                           0x00CA5230

# .rdata

target_rdata fsds_path,                           0x016BCBC0
target_rdata model_viewer_label,                  0x016C7C00
target_rdata map_select_label,                    0x016C7C30
target_rdata facegen_test_label,                  0x016C7C68
target_rdata title_list_label,                    0x016C7C90
target_rdata title_fs_debug_server_label,         0x016C7CB8
target_rdata title_sce_server_label,              0x016C7CF0

# .data

target_data my_delta_time_previous,               0x01852608  # padding re-used for delta time patch
target_data game_alias_pointer,                   0x01853164
target_data debug_alias_pointer,                  0x0185316C
target_data capture_alias_pointer,                0x01853174
target_data sfx_test_label_pointer,               0x01857114
target_data bdvd_path_pointer,                    0x019027F0
target_data lua_print_pointer,                    0x0196E568
