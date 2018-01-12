CREATE OR REPLACE PACKAGE select2
AUTHID CURRENT_USER
as
  subtype gt_string is varchar2(32767);

  procedure render (
    p_item   in apex_plugin.t_page_item,
    p_plugin in apex_plugin.t_plugin,
    p_param  in apex_plugin.t_item_render_param,
    p_result in out nocopy apex_plugin.t_item_render_result);

  procedure ajax (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_ajax_param,
    p_result in out nocopy apex_plugin.t_item_ajax_result );

  procedure metadata (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_meta_data_param,
    p_result in out nocopy apex_plugin.t_item_meta_data_result );    
   
END select2;
/