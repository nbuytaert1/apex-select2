create or replace package select2 is

  subtype gt_string is varchar2(32767);

  function render(
             p_item in apex_plugin.t_page_item,
             p_plugin in apex_plugin.t_plugin,
             p_value in gt_string,
             p_is_readonly in boolean,
             p_is_printer_friendly in boolean
           ) return apex_plugin.t_page_item_render_result;

  function ajax(
             p_item in apex_plugin.t_page_item,
             p_plugin in apex_plugin.t_plugin
           ) return apex_plugin.t_page_item_ajax_result;

end select2;