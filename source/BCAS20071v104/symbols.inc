#include "../helpers.inc"

# .text

target_text get_debug_menu_root,                  0x00013110
target_text create_debug_menu,                    0x00013840
target_text call_delta_time,                      0x0001978C
target_text call_render_debug_menu,               0x00019968
target_text call_create_debug_menu,               0x0001DF94
target_text get_hg_man_instance,                  0x00021AE8
target_text initialize_flip_mode,                 0x00023548
target_text allocate_memory_debug_1,              0x00037DBC
target_text allocate_memory_debug_2,              0x00037E04
target_text allocate_memory_debug_3,              0x00037E70
target_text allocate_memory_coreres_1,            0x00038FBC
target_text allocate_memory_coreres_2,            0x00039004
target_text allocate_memory_coreres_3,            0x00039070
target_text load_use_system_cache_default_value,  0x00047F2C
target_text init_debug_title_menu,                0x0015A950
target_text call_init_title_menu,                 0x0016D51C
target_text init_title_menu,                      0x001898A8
target_text get_pad,                              0x001C2BB8
target_text disable_pad,                          0x001C4838
target_text enable_pad,                           0x001C4880
target_text update_selected_node_keys,            0x003FE4F8
target_text advance_dbgmenuhgdraw_timer,          0x003FEC08
target_text update_dbgmenuhgdraw,                 0x003FF298
target_text draw_dbgmenuhgdraw_box,               0x003FFFC8
target_text create_debug_menu_label,              0x00405270
target_text load_uncompressed_files_1,            0x0066C04C
target_text load_uncompressed_files_2,            0x0066C058
target_text load_uncompressed_files_3_target,     0x0066C05C
target_text load_uncompressed_files_3,            0x0066C184
target_text load_uncompressed_files_4,            0x008EFEE0
target_text load_uncompressed_files_4_target,     0x008F00B0
target_text fs_lua_print,                         0x00C04140
target_text luaB_print,                           0x00CA66F8

# .rdata

target_rdata fsds_path,                           0x016BD9D8
target_rdata model_viewer_label,                  0x016C8AE0
target_rdata map_select_label,                    0x016C8B10
target_rdata facegen_test_label,                  0x016C8B48
target_rdata title_list_label,                    0x016C8B70
target_rdata title_fs_debug_server_label,         0x016C8B98
target_rdata title_sce_server_label,              0x016C8BD0

# .data

target_data my_delta_time_previous,               0x01852608  # padding re-used for delta time patch
target_data game_alias_pointer,                   0x01853164
target_data debug_alias_pointer,                  0x0185316C
target_data capture_alias_pointer,                0x01853174
target_data sfx_test_label_pointer,               0x01857114
target_data bdvd_path_pointer,                    0x019027C0
target_data lua_print_pointer,                    0x0196E588
