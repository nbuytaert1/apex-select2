set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,2229426507601067));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,100);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/be_ctb_select2
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'BE.CTB.SELECT2'
 ,p_display_name => 'Select2'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'subtype gt_string is varchar2(32767);'||unistr('\000a')||
''||unistr('\000a')||
'gco_min_lov_cols constant number(1) := 2;'||unistr('\000a')||
'gco_max_lov_cols constant number(1) := 3;'||unistr('\000a')||
'gco_lov_display_col constant number(1) := 1;'||unistr('\000a')||
'gco_lov_return_col constant number(1) := 2;'||unistr('\000a')||
'gco_lov_group_col constant number(1) := 3;'||unistr('\000a')||
'gco_contains_ignore_case constant char(3) := ''CIC'';'||unistr('\000a')||
'gco_contains_ignore_case_diac constant char(4) := ''CICD'';'||unistr('\000a')||
'gco_contains_case_sensitive constan'||
't char(3) := ''CCS'';'||unistr('\000a')||
'gco_exact_ignore_case constant char(3) := ''EIC'';'||unistr('\000a')||
'gco_exact_case_sensitive constant char(3) := ''ECS'';'||unistr('\000a')||
'gco_starts_with_ignore_case constant char(3) := ''SIC'';'||unistr('\000a')||
'gco_starts_with_case_sensitive constant char(3) := ''SCS'';'||unistr('\000a')||
'gco_multi_word constant char(2) := ''MW'';'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'procedure print_lov_options('||unistr('\000a')||
'            p_item in apex_plugin.t_page_item,'||unistr('\000a')||
'            p_plugin in apex_plugin.t_plugin,'||unistr('\000a')||
' '||
'           p_value in gt_string default null'||unistr('\000a')||
'          ) is'||unistr('\000a')||
'  l_null_optgroup_label_app gt_string := p_plugin.attribute_05;'||unistr('\000a')||
'  l_select_list_type gt_string := p_item.attribute_01;'||unistr('\000a')||
'  l_null_optgroup_label_cmp gt_string := p_item.attribute_09;'||unistr('\000a')||
'  l_drag_and_drop_sorting gt_string := p_item.attribute_11;'||unistr('\000a')||
'  l_lazy_loading gt_string := p_item.attribute_14;'||unistr('\000a')||
''||unistr('\000a')||
'  lco_null_optgroup_label constant gt_string :='||
' ''Ungrouped'';'||unistr('\000a')||
''||unistr('\000a')||
'  l_lov apex_plugin_util.t_column_value_list;'||unistr('\000a')||
'  l_null_optgroup gt_string;'||unistr('\000a')||
'  l_tmp_optgroup gt_string;'||unistr('\000a')||
'  l_selected_values apex_application_global.vc_arr2;'||unistr('\000a')||
'  l_display_value gt_string;'||unistr('\000a')||
''||unistr('\000a')||
'  type gt_optgroups'||unistr('\000a')||
'    is table of gt_string'||unistr('\000a')||
'    index by pls_integer;'||unistr('\000a')||
'  laa_optgroups gt_optgroups;'||unistr('\000a')||
''||unistr('\000a')||
'  -- local subprograms'||unistr('\000a')||
'  function optgroup_exists('||unistr('\000a')||
'             p_optgroups in gt_optgroups,'||unistr('\000a')||
'   '||
'          p_optgroup in gt_string'||unistr('\000a')||
'           ) return boolean is'||unistr('\000a')||
'    l_index pls_integer := p_optgroups.first;'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    while (l_index is not null) loop'||unistr('\000a')||
'      if p_optgroups(l_index) = p_optgroup then'||unistr('\000a')||
'        return true;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
''||unistr('\000a')||
'      l_index := p_optgroups.next(l_index);'||unistr('\000a')||
'    end loop;'||unistr('\000a')||
''||unistr('\000a')||
'    return false;'||unistr('\000a')||
'  end optgroup_exists;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'  function is_selected_value('||unistr('\000a')||
'             p_value in gt_s'||
'tring,'||unistr('\000a')||
'             p_selected_values in gt_string'||unistr('\000a')||
'           ) return boolean is'||unistr('\000a')||
'    l_selected_values apex_application_global.vc_arr2;'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    l_selected_values := apex_util.string_to_table(p_selected_values);'||unistr('\000a')||
''||unistr('\000a')||
'    for i in 1 .. l_selected_values.count loop'||unistr('\000a')||
'      if apex_plugin_util.is_equal(p_value, l_selected_values(i)) then'||unistr('\000a')||
'        return true;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'    end loop;'||unistr('\000a')||
''||unistr('\000a')||
'    return fals'||
'e;'||unistr('\000a')||
'  end is_selected_value;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  l_lov := apex_plugin_util.get_data('||unistr('\000a')||
'             p_sql_statement  => p_item.lov_definition,'||unistr('\000a')||
'             p_min_columns => gco_min_lov_cols,'||unistr('\000a')||
'             p_max_columns => gco_max_lov_cols,'||unistr('\000a')||
'             p_component_name => p_item.name'||unistr('\000a')||
'           );'||unistr('\000a')||
''||unistr('\000a')||
'  -- print the selected LOV options in case of lazy loading or when drag and drop sorting is enabled'||unistr('\000a')||
'  if (l_lazy_lo'||
'ading is not null or l_drag_and_drop_sorting is not null) then'||unistr('\000a')||
'    if p_value is not null then'||unistr('\000a')||
'      l_selected_values := apex_util.string_to_table(p_value);'||unistr('\000a')||
''||unistr('\000a')||
'      for i in 1 .. l_selected_values.count loop'||unistr('\000a')||
'        begin'||unistr('\000a')||
'          l_display_value := apex_plugin_util.get_display_data('||unistr('\000a')||
'                               p_sql_statement => p_item.lov_definition,'||unistr('\000a')||
'                               p_min_colu'||
'mns => gco_min_lov_cols,'||unistr('\000a')||
'                               p_max_columns => gco_max_lov_cols,'||unistr('\000a')||
'                               p_component_name => p_item.name,'||unistr('\000a')||
'                               p_display_column_no => gco_lov_display_col,'||unistr('\000a')||
'                               p_search_column_no => gco_lov_return_col,'||unistr('\000a')||
'                               p_search_string => l_selected_values(i),'||unistr('\000a')||
'                         '||
'      p_display_extra => false'||unistr('\000a')||
'                             );'||unistr('\000a')||
'        exception'||unistr('\000a')||
'          when no_data_found then'||unistr('\000a')||
'            l_display_value := null;'||unistr('\000a')||
'        end;'||unistr('\000a')||
''||unistr('\000a')||
'        if not (l_display_value is null and not p_item.lov_display_extra) then'||unistr('\000a')||
'          -- print the display value, or return value if no display value was found'||unistr('\000a')||
'          apex_plugin_util.print_option('||unistr('\000a')||
'            p_display_value =>'||
' nvl(l_display_value, l_selected_values(i)),'||unistr('\000a')||
'            p_return_value => l_selected_values(i),'||unistr('\000a')||
'            p_is_selected => true,'||unistr('\000a')||
'            p_attributes => p_item.element_option_attributes,'||unistr('\000a')||
'            p_escape => p_item.escape_output'||unistr('\000a')||
'          );'||unistr('\000a')||
'        end if;'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if l_lazy_loading is null then'||unistr('\000a')||
'    if l_lov.exists(gco_lov_group_col) then'||unistr('\000a')||
'      if l_null_'||
'optgroup_label_cmp is not null then'||unistr('\000a')||
'        l_null_optgroup := l_null_optgroup_label_cmp;'||unistr('\000a')||
'      else'||unistr('\000a')||
'        l_null_optgroup := nvl(l_null_optgroup_label_app, lco_null_optgroup_label);'||unistr('\000a')||
'      end if;'||unistr('\000a')||
''||unistr('\000a')||
'      for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'        l_tmp_optgroup := nvl(l_lov(gco_lov_group_col)(i), l_null_optgroup);'||unistr('\000a')||
''||unistr('\000a')||
'        if not optgroup_exists(laa_optgroups, l_tmp_optgroup) th'||
'en'||unistr('\000a')||
'          htp.p(''<optgroup label="'' || l_tmp_optgroup || ''">'');'||unistr('\000a')||
'          for j in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'            if nvl(l_lov(gco_lov_group_col)(j), l_null_optgroup) = l_tmp_optgroup then'||unistr('\000a')||
'              apex_plugin_util.print_option('||unistr('\000a')||
'                p_display_value => l_lov(gco_lov_display_col)(j),'||unistr('\000a')||
'                p_return_value => l_lov(gco_lov_return_col)(j),'||unistr('\000a')||
'         '||
'       p_is_selected => is_selected_value(l_lov(gco_lov_return_col)(j), p_value),'||unistr('\000a')||
'                p_attributes => p_item.element_option_attributes,'||unistr('\000a')||
'                p_escape => p_item.escape_output'||unistr('\000a')||
'              );'||unistr('\000a')||
'            end if;'||unistr('\000a')||
'          end loop;'||unistr('\000a')||
'          htp.p(''</optgroup>'');'||unistr('\000a')||
''||unistr('\000a')||
'          laa_optgroups(i) := l_tmp_optgroup;'||unistr('\000a')||
'        end if;'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      if (l_drag_and_drop_'||
'sorting is not null and p_value is not null) then'||unistr('\000a')||
'        for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'          if not is_selected_value(l_lov(gco_lov_return_col)(i), p_value) then'||unistr('\000a')||
'            apex_plugin_util.print_option('||unistr('\000a')||
'              p_display_value => l_lov(gco_lov_display_col)(i),'||unistr('\000a')||
'              p_return_value => l_lov(gco_lov_return_col)(i),'||unistr('\000a')||
'              p_is_selected => false,'||unistr('\000a')||
'    '||
'          p_attributes => p_item.element_option_attributes,'||unistr('\000a')||
'              p_escape => p_item.escape_output'||unistr('\000a')||
'            );'||unistr('\000a')||
'          end if;'||unistr('\000a')||
'        end loop;'||unistr('\000a')||
'      else'||unistr('\000a')||
'        for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'          apex_plugin_util.print_option('||unistr('\000a')||
'            p_display_value => l_lov(gco_lov_display_col)(i),'||unistr('\000a')||
'            p_return_value => l_lov(gco_lov_return_col)(i),'||unistr('\000a')||
'        '||
'    p_is_selected => is_selected_value(l_lov(gco_lov_return_col)(i), p_value),'||unistr('\000a')||
'            p_attributes => p_item.element_option_attributes,'||unistr('\000a')||
'            p_escape => p_item.escape_output'||unistr('\000a')||
'          );'||unistr('\000a')||
'        end loop;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_value is not null and (l_select_list_type = ''TAG'' or p_item.lov_display_extra)) then'||unistr('\000a')||
'    if not (l_lazy_loading is not null or l_drag_and_'||
'drop_sorting is not null) then'||unistr('\000a')||
'      l_selected_values := apex_util.string_to_table(p_value);'||unistr('\000a')||
''||unistr('\000a')||
'      for i in 1 .. l_selected_values.count loop'||unistr('\000a')||
'        begin'||unistr('\000a')||
'          l_display_value := apex_plugin_util.get_display_data('||unistr('\000a')||
'                               p_sql_statement => p_item.lov_definition,'||unistr('\000a')||
'                               p_min_columns => gco_min_lov_cols,'||unistr('\000a')||
'                               p_max_co'||
'lumns => gco_max_lov_cols,'||unistr('\000a')||
'                               p_component_name => p_item.name,'||unistr('\000a')||
'                               p_display_column_no => gco_lov_display_col,'||unistr('\000a')||
'                               p_search_column_no => gco_lov_return_col,'||unistr('\000a')||
'                               p_search_string => l_selected_values(i),'||unistr('\000a')||
'                               p_display_extra => false'||unistr('\000a')||
'                             );'||unistr('\000a')||
' '||
'       exception'||unistr('\000a')||
'          when no_data_found then'||unistr('\000a')||
'            l_display_value := null;'||unistr('\000a')||
'        end;'||unistr('\000a')||
''||unistr('\000a')||
'        if l_display_value is null then'||unistr('\000a')||
'          apex_plugin_util.print_option('||unistr('\000a')||
'            p_display_value => l_selected_values(i),'||unistr('\000a')||
'            p_return_value => l_selected_values(i),'||unistr('\000a')||
'            p_is_selected => true,'||unistr('\000a')||
'            p_attributes => p_item.element_option_attributes,'||unistr('\000a')||
'            p_e'||
'scape => p_item.escape_output'||unistr('\000a')||
'          );'||unistr('\000a')||
'        end if;'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
'end print_lov_options;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function render('||unistr('\000a')||
'           p_item in apex_plugin.t_page_item,'||unistr('\000a')||
'           p_plugin in apex_plugin.t_plugin,'||unistr('\000a')||
'           p_value in gt_string,'||unistr('\000a')||
'           p_is_readonly in boolean,'||unistr('\000a')||
'           p_is_printer_friendly in boolean'||unistr('\000a')||
'         ) return apex_plugin.t_page_item_render_result '||
'is'||unistr('\000a')||
'  l_no_matches_msg gt_string := p_plugin.attribute_01;'||unistr('\000a')||
'  l_input_too_short_msg gt_string := p_plugin.attribute_02;'||unistr('\000a')||
'  l_selection_too_big_msg gt_string := p_plugin.attribute_03;'||unistr('\000a')||
'  l_searching_msg gt_string := p_plugin.attribute_04;'||unistr('\000a')||
'  l_null_optgroup_label_app gt_string := p_plugin.attribute_05;'||unistr('\000a')||
'  l_loading_more_results_msg gt_string := p_plugin.attribute_06;'||unistr('\000a')||
'  l_look_and_feel gt_string := p_plug'||
'in.attribute_07;'||unistr('\000a')||
'  l_error_loading_msg gt_string := p_plugin.attribute_08;'||unistr('\000a')||
'  l_input_too_long_msg gt_string := p_plugin.attribute_09;'||unistr('\000a')||
'  l_custom_css_path gt_string := p_plugin.attribute_10;'||unistr('\000a')||
'  l_custom_css_filename gt_string := p_plugin.attribute_11;'||unistr('\000a')||
''||unistr('\000a')||
'  l_select_list_type gt_string := p_item.attribute_01;'||unistr('\000a')||
'  l_min_results_for_search gt_string := p_item.attribute_02;'||unistr('\000a')||
'  l_min_input_length gt_string :='||
' p_item.attribute_03;'||unistr('\000a')||
'  l_max_input_length gt_string := p_item.attribute_04;'||unistr('\000a')||
'  l_max_selection_size gt_string := p_item.attribute_05;'||unistr('\000a')||
'  l_rapid_selection gt_string := p_item.attribute_06;'||unistr('\000a')||
'  l_select_on_blur gt_string := p_item.attribute_07;'||unistr('\000a')||
'  l_search_logic gt_string := p_item.attribute_08;'||unistr('\000a')||
'  l_null_optgroup_label_cmp gt_string := p_item.attribute_09;'||unistr('\000a')||
'  l_width gt_string := p_item.attribute_10;'||unistr('\000a')||
'  '||
'l_drag_and_drop_sorting gt_string := p_item.attribute_11;'||unistr('\000a')||
'  l_token_separators gt_string := p_item.attribute_12;'||unistr('\000a')||
'  l_extra_options gt_string := p_item.attribute_13;'||unistr('\000a')||
'  l_lazy_loading gt_string := p_item.attribute_14;'||unistr('\000a')||
'  l_lazy_append_row_count gt_string := p_item.attribute_15;'||unistr('\000a')||
''||unistr('\000a')||
'  l_display_values apex_application_global.vc_arr2;'||unistr('\000a')||
'  l_multiselect gt_string;'||unistr('\000a')||
''||unistr('\000a')||
'  l_item_jq gt_string := apex_plugin_util.p'||
'age_item_names_to_jquery(p_item.name);'||unistr('\000a')||
'  l_cascade_parent_items_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.lov_cascade_parent_items);'||unistr('\000a')||
'  l_cascade_items_to_submit_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.ajax_items_to_submit);'||unistr('\000a')||
'  l_items_for_session_state_jq gt_string;'||unistr('\000a')||
'  l_cascade_parent_items apex_application_global.vc_arr2;'||unistr('\000a')||
'  l_optimize_refresh_condi'||
'tion gt_string;'||unistr('\000a')||
''||unistr('\000a')||
'  l_apex_version gt_string;'||unistr('\000a')||
'  l_onload_code gt_string;'||unistr('\000a')||
'  l_render_result apex_plugin.t_page_item_render_result;'||unistr('\000a')||
''||unistr('\000a')||
'  -- local subprograms'||unistr('\000a')||
'  function get_select2_constructor'||unistr('\000a')||
'  return gt_string is'||unistr('\000a')||
'    l_selected_values apex_application_global.vc_arr2;'||unistr('\000a')||
'    l_display_values apex_application_global.vc_arr2;'||unistr('\000a')||
'    l_json gt_string;'||unistr('\000a')||
'    l_code gt_string;'||unistr('\000a')||
''||unistr('\000a')||
'    l_allow_clear_bool boolean;'||unistr('\000a')||
'    '||
'l_rapid_selection_bool boolean;'||unistr('\000a')||
'    l_select_on_blur_bool boolean;'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    if p_item.lov_display_null then'||unistr('\000a')||
'      l_allow_clear_bool := true;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_allow_clear_bool := false;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_rapid_selection is null then'||unistr('\000a')||
'      l_rapid_selection_bool := true;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_rapid_selection_bool := false;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_select_on_blur is null then'||unistr('\000a')||
'      l_select_on_blur_b'||
'ool := false;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_select_on_blur_bool := true;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    -- make sure the last character of l_extra_options is a comma'||unistr('\000a')||
'    if trim(l_extra_options) is not null then'||unistr('\000a')||
'      if substr(trim(l_extra_options), -1, 1) != '','' then'||unistr('\000a')||
'        l_extra_options := l_extra_options || '','';'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_code := '''||unistr('\000a')||
'      $("'' || l_item_jq || ''").select2({'' ||'||unistr('\000a')||
'        apex_javas'||
'cript.add_attribute(''placeholder'', p_item.lov_null_text, false) ||'||unistr('\000a')||
'        apex_javascript.add_attribute(''allowClear'', l_allow_clear_bool) ||'||unistr('\000a')||
'        apex_javascript.add_attribute(''minimumInputLength'', to_number(l_min_input_length)) ||'||unistr('\000a')||
'        apex_javascript.add_attribute(''maximumInputLength'', to_number(l_max_input_length)) ||'||unistr('\000a')||
'        apex_javascript.add_attribute(''minimumResultsForSearch'', to_nu'||
'mber(l_min_results_for_search)) ||'||unistr('\000a')||
'        apex_javascript.add_attribute(''maximumSelectionLength'', to_number(l_max_selection_size)) ||'||unistr('\000a')||
'        apex_javascript.add_attribute(''closeOnSelect'', l_rapid_selection_bool) ||'||unistr('\000a')||
'        apex_javascript.add_attribute(''selectOnClose'', l_select_on_blur_bool) ||'||unistr('\000a')||
'        apex_javascript.add_attribute(''tokenSeparators'', l_token_separators) ||'||unistr('\000a')||
'        l_extra_option'||
's;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_look_and_feel = ''SELECT2_CLASSIC'' then'||unistr('\000a')||
'      l_code := l_code || apex_javascript.add_attribute(''theme'', ''classic'');'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_code := l_code || ''"language": {'';'||unistr('\000a')||
''||unistr('\000a')||
'    if l_error_loading_msg is not null then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        "errorLoading": function() {'||unistr('\000a')||
'                          return "'' || l_error_loading_msg || ''";'||unistr('\000a')||
'                        },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||
'    if l_input_too_long_msg is not null then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        "inputTooLong": function(args) {'||unistr('\000a')||
'                          var msg = "'' || l_input_too_long_msg || ''";'||unistr('\000a')||
'                          msg = msg.replace("#TERM#", args.input);'||unistr('\000a')||
'                          msg = msg.replace("#MAXLENGTH#", args.maximum);'||unistr('\000a')||
'                          msg = msg.replace("#OVERCHARS#", args.input.lengt'||
'h - args.maximum);'||unistr('\000a')||
'                          return msg;'||unistr('\000a')||
'                        },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'    if l_input_too_short_msg is not null then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        "inputTooShort": function(args) {'||unistr('\000a')||
'                           var msg = "'' || l_input_too_short_msg || ''";'||unistr('\000a')||
'                           msg = msg.replace("#TERM#", args.input);'||unistr('\000a')||
'                           msg = msg.replace("'||
'#MINLENGTH#", args.minimum);'||unistr('\000a')||
'                           msg = msg.replace("#REMAININGCHARS#", args.minimum - args.input.length);'||unistr('\000a')||
'                           return msg;'||unistr('\000a')||
'                         },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'    if l_loading_more_results_msg is not null then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        "loadingMore": function() {'||unistr('\000a')||
'                         return "'' || l_loading_more_results_msg || ''";'||unistr('\000a')||
'   '||
'                    },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'    if l_selection_too_big_msg is not null then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        "maximumSelected": function(args) {'||unistr('\000a')||
'                             var msg = "'' || l_selection_too_big_msg || ''";'||unistr('\000a')||
'                             msg = msg.replace("#MAXSIZE#", args.maximum);'||unistr('\000a')||
'                             return msg;'||unistr('\000a')||
'                           },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'    if '||
'l_no_matches_msg is not null then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        "noResults": function() {'||unistr('\000a')||
'                       return "'' || l_no_matches_msg || ''";'||unistr('\000a')||
'                     },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'    if l_searching_msg is not null then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        "searching": function() {'||unistr('\000a')||
'                       return "'' || l_searching_msg || ''";'||unistr('\000a')||
'                     },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_'||
'code := rtrim(l_code, '','') || ''},'';'||unistr('\000a')||
''||unistr('\000a')||
'    if l_search_logic != gco_contains_ignore_case then'||unistr('\000a')||
'      case l_search_logic'||unistr('\000a')||
'        when gco_contains_ignore_case_diac then l_search_logic := ''return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;'';'||unistr('\000a')||
'        when gco_contains_case_sensitive then l_search_logic := ''return text.indexOf(term) >= 0;'';'||unistr('\000a')||
'        when gco_exact_ignore_case then l_search_logic'||
' := ''return text.toUpperCase() === term.toUpperCase() || term.length === 0;'';'||unistr('\000a')||
'        when gco_exact_case_sensitive then l_search_logic := ''return text === term || term.length === 0;'';'||unistr('\000a')||
'        when gco_starts_with_ignore_case then l_search_logic := ''return text.toUpperCase().indexOf(term.toUpperCase()) === 0;'';'||unistr('\000a')||
'        when gco_starts_with_case_sensitive then l_search_logic := ''return text.indexOf'||
'(term) === 0;'';'||unistr('\000a')||
'        when gco_multi_word then l_search_logic := '''||unistr('\000a')||
'          var escpTerm = term.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");'||unistr('\000a')||
'          return new RegExp(escpTerm.replace(/ /g, ".*"), "i").test(text);'';'||unistr('\000a')||
'        else l_search_logic := ''return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;'';'||unistr('\000a')||
'      end case;'||unistr('\000a')||
''||unistr('\000a')||
'      l_code := ''$.fn.select2.amd.require([''''select2/comp'||
'at/matcher''''], function(oldMatcher) {'' ||'||unistr('\000a')||
'        l_code || '''||unistr('\000a')||
'        matcher: oldMatcher('||unistr('\000a')||
'                   function(term, text) {'||unistr('\000a')||
'                     '' || l_search_logic || '''||unistr('\000a')||
'                   }'||unistr('\000a')||
'                 ),'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_lazy_loading is not null then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        ajax: {'||unistr('\000a')||
'          url: "wwv_flow.show",'||unistr('\000a')||
'          type: "POST",'||unistr('\000a')||
'          dataType: "json"'||
','||unistr('\000a')||
'          delay: 400,'||unistr('\000a')||
'          data: function(params) {'||unistr('\000a')||
'                  return {'||unistr('\000a')||
'                    p_flow_id: $("#pFlowId").val(),'||unistr('\000a')||
'                    p_flow_step_id: $("#pFlowStepId").val(),'||unistr('\000a')||
'                    p_instance: $("#pInstance").val(),'||unistr('\000a')||
'                    x01: params.term,'||unistr('\000a')||
'                    x02: params.page,'||unistr('\000a')||
'                    x03: "LAZY_LOAD",'||unistr('\000a')||
'                    p_request: "'||
'PLUGIN='' || apex_plugin.get_ajax_identifier || ''"'||unistr('\000a')||
'                  };'||unistr('\000a')||
'                },'||unistr('\000a')||
'          processResults: function(data, params) {'||unistr('\000a')||
'                            var select2Data = $.map(data.row, function(obj) {'||unistr('\000a')||
'                              obj.id = obj.R;'||unistr('\000a')||
'                              obj.text = obj.D;'||unistr('\000a')||
'                              return obj;'||unistr('\000a')||
'                            });'||unistr('\000a')||
''||unistr('\000a')||
'            '||
'                return {'||unistr('\000a')||
'                              results: select2Data,'||unistr('\000a')||
'                              pagination: { more: data.more }'||unistr('\000a')||
'                            };'||unistr('\000a')||
'                          },'||unistr('\000a')||
'          cache: true'||unistr('\000a')||
'        },'||unistr('\000a')||
'        escapeMarkup: function(markup) { return markup; },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_select_list_type = ''TAG'' then'||unistr('\000a')||
'      l_code := l_code || apex_javascript.add_attribute'||
'(''tags'', true);'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_code := l_code || apex_javascript.add_attribute(''width'', nvl(l_width, ''element''), true, false);'||unistr('\000a')||
'    l_code := l_code || ''})'';'||unistr('\000a')||
''||unistr('\000a')||
'    if l_search_logic != gco_contains_ignore_case then'||unistr('\000a')||
'      l_code := l_code || ''});'';'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_code := l_code || '';'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    -- issue #71: fix focus after selection for single-value items'||unistr('\000a')||
'    if l_select_list_type = ''S'||
'INGLE'' then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        $("'' || l_item_jq || ''").on('||unistr('\000a')||
'          "select2:select",'||unistr('\000a')||
'          function(){ $(this).focus(); }'||unistr('\000a')||
'        );'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    return l_code;'||unistr('\000a')||
'  end get_select2_constructor;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'  function get_sortable_constructor'||unistr('\000a')||
'  return gt_string is'||unistr('\000a')||
'    l_code gt_string;'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    l_code := '''||unistr('\000a')||
'      var s2item = $("'' || l_item_jq || ''");'||unistr('\000a')||
'      var s2ul = s2item.nex'||
't(".select2-container").find("ul.select2-selection__rendered");'||unistr('\000a')||
'      s2ul.sortable({'||unistr('\000a')||
'        containment: "parent",'||unistr('\000a')||
'        items: "li:not(.select2-search)",'||unistr('\000a')||
'        tolerance: "pointer",'||unistr('\000a')||
'        stop: function() {'||unistr('\000a')||
'          $(s2ul.find(".select2-selection__choice").get().reverse()).each(function() {'||unistr('\000a')||
'            s2item.prepend(s2item.find(''''option[value="'''' + $(this).data("data").id + ''''"]'''')[0])'||
';'||unistr('\000a')||
'          });'||unistr('\000a')||
'        }'||unistr('\000a')||
'      });'';'||unistr('\000a')||
''||unistr('\000a')||
'      /* prevent automatic tags sorting'||unistr('\000a')||
'         http://stackoverflow.com/questions/31431197/select2-how-to-prevent-tags-sorting'||unistr('\000a')||
'      s2item.on("select2:select", function(e) {'||unistr('\000a')||
'        var $element = $(e.params.data.element);'||unistr('\000a')||
''||unistr('\000a')||
'        $element.detach();'||unistr('\000a')||
'        $(this).append($element);'||unistr('\000a')||
'        $(this).trigger("change");'||unistr('\000a')||
'      });'';'||unistr('\000a')||
'      */'||unistr('\000a')||
''||unistr('\000a')||
'    return l_cod'||
'e;'||unistr('\000a')||
'  end get_sortable_constructor;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  if apex_application.g_debug then'||unistr('\000a')||
'    apex_plugin_util.debug_page_item(p_plugin, p_item, p_value, p_is_readonly, p_is_printer_friendly);'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_is_readonly or p_is_printer_friendly) then'||unistr('\000a')||
'    apex_plugin_util.print_hidden_if_readonly(p_item.name, p_value, p_is_readonly, p_is_printer_friendly);'||unistr('\000a')||
''||unistr('\000a')||
'    begin'||unistr('\000a')||
'      l_display_values := apex_plugin_uti'||
'l.get_display_data('||unistr('\000a')||
'                            p_sql_statement => p_item.lov_definition,'||unistr('\000a')||
'                            p_min_columns => gco_min_lov_cols,'||unistr('\000a')||
'                            p_max_columns => gco_max_lov_cols,'||unistr('\000a')||
'                            p_component_name => p_item.name,'||unistr('\000a')||
'                            p_search_value_list => apex_util.string_to_table(p_value),'||unistr('\000a')||
'                            p_displa'||
'y_extra => p_item.lov_display_extra'||unistr('\000a')||
'                          );'||unistr('\000a')||
'    exception'||unistr('\000a')||
'      when no_data_found then'||unistr('\000a')||
'        null; -- https://github.com/nbuytaert1/apex-select2/issues/51'||unistr('\000a')||
'    end;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_display_values.count = 1 then'||unistr('\000a')||
'      apex_plugin_util.print_display_only('||unistr('\000a')||
'        p_item_name => p_item.name,'||unistr('\000a')||
'        p_display_value => l_display_values(1),'||unistr('\000a')||
'        p_show_line_breaks => false,'||unistr('\000a')||
'        '||
'p_escape => p_item.escape_output,'||unistr('\000a')||
'        p_attributes => p_item.element_attributes'||unistr('\000a')||
'      );'||unistr('\000a')||
'    elsif l_display_values.count > 1 then'||unistr('\000a')||
'      htp.p('''||unistr('\000a')||
'        <ul id="'' || p_item.name || ''_DISPLAY"'||unistr('\000a')||
'          class="display_only '' || p_item.element_css_classes || ''"'' ||'||unistr('\000a')||
'          p_item.element_attributes || ''>'');'||unistr('\000a')||
''||unistr('\000a')||
'      for i in 1 .. l_display_values.count loop'||unistr('\000a')||
'        if p_item.escape_output then'||unistr('\000a')||
' '||
'         htp.p(''<li>'' || htf.escape_sc(l_display_values(i)) || ''</li>'');'||unistr('\000a')||
'        else'||unistr('\000a')||
'          htp.p(''<li>'' || l_display_values(i) || ''</li>'');'||unistr('\000a')||
'        end if;'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
''||unistr('\000a')||
'      htp.p(''</ul>'');'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    return l_render_result;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  apex_javascript.add_library('||unistr('\000a')||
'    p_name => ''select2.full.min'','||unistr('\000a')||
'    p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'    p_version => null'||unistr('\000a')||
'  );'||unistr('\000a')||
'  apex_javascri'||
'pt.add_library('||unistr('\000a')||
'    p_name => ''select2-apex'','||unistr('\000a')||
'    p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'    p_version => null'||unistr('\000a')||
'  );'||unistr('\000a')||
'  apex_css.add_file('||unistr('\000a')||
'    p_name => ''select2.min'','||unistr('\000a')||
'    p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'    p_version => null'||unistr('\000a')||
'  );'||unistr('\000a')||
'  if l_look_and_feel = ''SELECT2_CLASSIC'' then'||unistr('\000a')||
'    apex_css.add_file('||unistr('\000a')||
'      p_name => ''select2-classic'','||unistr('\000a')||
'      p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'      p_version => nu'||
'll'||unistr('\000a')||
'    );'||unistr('\000a')||
'  elsif l_look_and_feel = ''CUSTOM'' then'||unistr('\000a')||
'    apex_css.add_file('||unistr('\000a')||
'      p_name => apex_plugin_util.replace_substitutions(l_custom_css_filename),'||unistr('\000a')||
'      p_directory => apex_plugin_util.replace_substitutions(l_custom_css_path),'||unistr('\000a')||
'      p_version => null'||unistr('\000a')||
'    );'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if l_select_list_type in (''MULTI'', ''TAG'') then'||unistr('\000a')||
'    l_multiselect := ''multiple="multiple"'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  htp.p('''||unistr('\000a')||
'    <select '||
''' || l_multiselect || '''||unistr('\000a')||
'      id="'' || p_item.name || ''"'||unistr('\000a')||
'      name="'' || apex_plugin.get_input_name_for_page_item(true) || ''"'||unistr('\000a')||
'      class="selectlist '' || p_item.element_css_classes || ''"'' ||'||unistr('\000a')||
'      p_item.element_attributes || ''>'');'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_select_list_type = ''SINGLE'' and p_item.lov_display_null) then'||unistr('\000a')||
'    apex_plugin_util.print_option('||unistr('\000a')||
'      p_display_value => p_item.lov_null_text,'||unistr('\000a')||
'      p_retur'||
'n_value => p_item.lov_null_value,'||unistr('\000a')||
'      p_is_selected => false,'||unistr('\000a')||
'      p_attributes => p_item.element_option_attributes,'||unistr('\000a')||
'      p_escape => p_item.escape_output'||unistr('\000a')||
'    );'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  print_lov_options(p_item, p_plugin, p_value);'||unistr('\000a')||
''||unistr('\000a')||
'  htp.p(''</select>'');'||unistr('\000a')||
''||unistr('\000a')||
'  l_onload_code := get_select2_constructor;'||unistr('\000a')||
''||unistr('\000a')||
'  if l_drag_and_drop_sorting is not null then'||unistr('\000a')||
'    select substr(version_no, 1, 3)'||unistr('\000a')||
'    into l_apex_version'||unistr('\000a')||
''||
'    from apex_release;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_apex_version = ''4.2'' then'||unistr('\000a')||
'      apex_javascript.add_library('||unistr('\000a')||
'        p_name => ''jquery.ui.sortable.min'','||unistr('\000a')||
'        p_directory => ''#IMAGE_PREFIX#libraries/jquery-ui/1.8.22/ui/minified/'','||unistr('\000a')||
'        p_version => null'||unistr('\000a')||
'      );'||unistr('\000a')||
'    else'||unistr('\000a')||
'      apex_javascript.add_library('||unistr('\000a')||
'        p_name => ''jquery.ui.sortable.min'','||unistr('\000a')||
'        p_directory => ''#IMAGE_PREFIX#libraries/jquery-ui/1'||
'.10.4/ui/minified/'','||unistr('\000a')||
'        p_version => null'||unistr('\000a')||
'      );'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_onload_code := l_onload_code || get_sortable_constructor();'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if p_item.lov_cascade_parent_items is not null then'||unistr('\000a')||
'    l_items_for_session_state_jq := l_cascade_parent_items_jq;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_cascade_items_to_submit_jq is not null then'||unistr('\000a')||
'      l_items_for_session_state_jq := l_items_for_session_state_jq || '','' || l_casc'||
'ade_items_to_submit_jq;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_onload_code := l_onload_code || '''||unistr('\000a')||
'      $("'' || l_cascade_parent_items_jq || ''").on("change", function(e) {'';'||unistr('\000a')||
''||unistr('\000a')||
'    if p_item.ajax_optimize_refresh then'||unistr('\000a')||
'      l_cascade_parent_items := apex_util.string_to_table(l_cascade_parent_items_jq, '','');'||unistr('\000a')||
''||unistr('\000a')||
'      l_optimize_refresh_condition := ''$("'' || l_cascade_parent_items(1) || ''").val() === ""'';'||unistr('\000a')||
''||unistr('\000a')||
'      for i in 2 '||
'.. l_cascade_parent_items.count loop'||unistr('\000a')||
'        l_optimize_refresh_condition := l_optimize_refresh_condition || '' || $("'' || l_cascade_parent_items(i) || ''").val() === ""'';'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
''||unistr('\000a')||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'        var item = $("'' || l_item_jq || ''");'||unistr('\000a')||
'        if ('' || l_optimize_refresh_condition || '') {'||unistr('\000a')||
'          item.val("").trigger("change");'||unistr('\000a')||
'        } else {'';'||unistr('\000a')||
'    end if;'||
''||unistr('\000a')||
''||unistr('\000a')||
'    l_onload_code := l_onload_code || '''||unistr('\000a')||
'          apex.server.plugin('||unistr('\000a')||
'            "'' || apex_plugin.get_ajax_identifier || ''",'||unistr('\000a')||
'            { pageItems: "'' || l_items_for_session_state_jq || ''" },'||unistr('\000a')||
'            { refreshObject: "'' || l_item_jq || ''",'||unistr('\000a')||
'              loadingIndicator: "'' || l_item_jq || ''",'||unistr('\000a')||
'              loadingIndicatorPosition: "after",'||unistr('\000a')||
'              dataType: "text",'||unistr('\000a')||
'              '||
'success: function(pData) {'||unistr('\000a')||
'                         var item = $("'' || l_item_jq || ''");'||unistr('\000a')||
'                         item.html(pData);'||unistr('\000a')||
'                         item.val("").trigger("change");'||unistr('\000a')||
'                       }'||unistr('\000a')||
'            });'';'||unistr('\000a')||
''||unistr('\000a')||
'    if p_item.ajax_optimize_refresh then'||unistr('\000a')||
'      l_onload_code := l_onload_code || ''}'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_onload_code := l_onload_code || ''});'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  l_onload_c'||
'ode := l_onload_code || '''||unistr('\000a')||
'      beCtbSelect2.events.bind("'' || l_item_jq || ''");'';'||unistr('\000a')||
''||unistr('\000a')||
'  apex_javascript.add_onload_code(l_onload_code);'||unistr('\000a')||
'  l_render_result.is_navigable := true;'||unistr('\000a')||
'  return l_render_result;'||unistr('\000a')||
'end render;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function ajax('||unistr('\000a')||
'           p_item in apex_plugin.t_page_item,'||unistr('\000a')||
'           p_plugin in apex_plugin.t_plugin'||unistr('\000a')||
'         ) return apex_plugin.t_page_item_ajax_result is'||unistr('\000a')||
'  l_select_list_type gt_'||
'string := p_item.attribute_01;'||unistr('\000a')||
'  l_search_logic gt_string := p_item.attribute_08;'||unistr('\000a')||
'  l_lazy_append_row_count gt_string := p_item.attribute_15;'||unistr('\000a')||
''||unistr('\000a')||
'  l_lov apex_plugin_util.t_column_value_list;'||unistr('\000a')||
'  l_json gt_string;'||unistr('\000a')||
'  l_apex_plugin_search_logic gt_string;'||unistr('\000a')||
'  l_search_string gt_string;'||unistr('\000a')||
'  l_search_page number;'||unistr('\000a')||
'  l_first_row number;'||unistr('\000a')||
'  l_loop_count number;'||unistr('\000a')||
'  l_more_rows_boolean boolean;'||unistr('\000a')||
''||unistr('\000a')||
'  l_result apex_plugi'||
'n.t_page_item_ajax_result;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  if apex_application.g_x03 = ''LAZY_LOAD'' then'||unistr('\000a')||
'    l_search_string := nvl(apex_application.g_x01, ''%'');'||unistr('\000a')||
'    l_search_page := nvl(apex_application.g_x02, 1);'||unistr('\000a')||
'    l_first_row := ((l_search_page - 1) * nvl(l_lazy_append_row_count, 0)) + 1;'||unistr('\000a')||
''||unistr('\000a')||
'    -- translate Select2 search logic into APEX_PLUGIN_UTIL search logic'||unistr('\000a')||
'    -- the percentage wildcard returns all rows whenever'||
' the search string is null'||unistr('\000a')||
'    case l_search_logic'||unistr('\000a')||
'      when gco_contains_case_sensitive then'||unistr('\000a')||
'        l_apex_plugin_search_logic := apex_plugin_util.c_search_like_case; -- uses LIKE %value%'||unistr('\000a')||
'      when gco_exact_ignore_case then'||unistr('\000a')||
'        l_apex_plugin_search_logic := apex_plugin_util.c_search_exact_ignore; -- uses LIKE VALUE% with UPPER (not completely correct)'||unistr('\000a')||
'      when gco_exact_case_sensitive t'||
'hen'||unistr('\000a')||
'        l_apex_plugin_search_logic := apex_plugin_util.c_search_lookup; -- uses = value'||unistr('\000a')||
'      when gco_starts_with_ignore_case then'||unistr('\000a')||
'        l_apex_plugin_search_logic := apex_plugin_util.c_search_exact_ignore; -- uses LIKE VALUE% with UPPER'||unistr('\000a')||
'      when gco_starts_with_case_sensitive then'||unistr('\000a')||
'        l_apex_plugin_search_logic := apex_plugin_util.c_search_exact_case; -- uses LIKE value%'||unistr('\000a')||
'      else'||unistr('\000a')||
' '||
'       l_apex_plugin_search_logic := apex_plugin_util.c_search_like_ignore; -- uses LIKE %VALUE% with UPPER'||unistr('\000a')||
'    end case;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_search_logic = gco_multi_word then'||unistr('\000a')||
'      l_search_string := replace(l_search_string, '' '', ''%'');'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_lov := apex_plugin_util.get_data('||unistr('\000a')||
'               p_sql_statement => p_item.lov_definition,'||unistr('\000a')||
'               p_min_columns => gco_min_lov_cols,'||unistr('\000a')||
'            '||
'   p_max_columns => gco_max_lov_cols,'||unistr('\000a')||
'               p_component_name => p_item.name,'||unistr('\000a')||
'               p_search_type => l_apex_plugin_search_logic,'||unistr('\000a')||
'               p_search_column_no => gco_lov_display_col,'||unistr('\000a')||
'               p_search_string => apex_plugin_util.get_search_string('||unistr('\000a')||
'                                    p_search_type => l_apex_plugin_search_logic,'||unistr('\000a')||
'                                    p_search_'||
'string => l_search_string'||unistr('\000a')||
'                                  ),'||unistr('\000a')||
'               p_first_row => l_first_row,'||unistr('\000a')||
'               p_max_rows => l_lazy_append_row_count + 1'||unistr('\000a')||
'             );'||unistr('\000a')||
''||unistr('\000a')||
'    if l_lov(gco_lov_return_col).count = l_lazy_append_row_count + 1 then'||unistr('\000a')||
'      l_loop_count := l_lov(gco_lov_return_col).count - 1;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_loop_count := l_lov(gco_lov_return_col).count;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_json'||
' := ''{"row":['';'||unistr('\000a')||
''||unistr('\000a')||
'    if p_item.escape_output then'||unistr('\000a')||
'      for i in 1 .. l_loop_count loop'||unistr('\000a')||
'        l_json := l_json || ''{'' ||'||unistr('\000a')||
'          apex_javascript.add_attribute(''R'', htf.escape_sc(l_lov(gco_lov_return_col)(i)), false, true) ||'||unistr('\000a')||
'          apex_javascript.add_attribute(''D'', htf.escape_sc(l_lov(gco_lov_display_col)(i)), false, false) ||'||unistr('\000a')||
'        ''},'';'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      for i in 1 .. l_lo'||
'op_count loop'||unistr('\000a')||
'        l_json := l_json || ''{'' ||'||unistr('\000a')||
'          apex_javascript.add_attribute(''R'', l_lov(gco_lov_return_col)(i), false, true) ||'||unistr('\000a')||
'          apex_javascript.add_attribute(''D'', l_lov(gco_lov_display_col)(i), false, false) ||'||unistr('\000a')||
'        ''},'';'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_json := rtrim(l_json, '','');'||unistr('\000a')||
''||unistr('\000a')||
'    if l_lov(gco_lov_return_col).exists(l_lazy_append_row_count + 1) then'||unistr('\000a')||
'      l_more_ro'||
'ws_boolean := true;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_more_rows_boolean := false;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_json := l_json || ''],'' || apex_javascript.add_attribute(''more'', l_more_rows_boolean, true, false) || ''}'';'||unistr('\000a')||
''||unistr('\000a')||
'    htp.p(l_json);'||unistr('\000a')||
'  else'||unistr('\000a')||
'    print_lov_options(p_item, p_plugin);'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_result;'||unistr('\000a')||
'end ajax;'
 ,p_render_function => 'render'
 ,p_ajax_function => 'ajax'
 ,p_standard_attributes => 'VISIBLE:SESSION_STATE:READONLY:ESCAPE_OUTPUT:QUICKPICK:SOURCE:ELEMENT:ELEMENT_OPTION:ENCRYPT:LOV:LOV_REQUIRED:LOV_DISPLAY_NULL:CASCADING_LOV'
 ,p_sql_min_column_count => 2
 ,p_sql_max_column_count => 3
 ,p_sql_examples => '1. Dynamic LOV'||unistr('\000a')||
'<pre>'||unistr('\000a')||
'SELECT ename,'||unistr('\000a')||
'       empno'||unistr('\000a')||
'FROM emp'||unistr('\000a')||
'ORDER by ename'||unistr('\000a')||
'</pre>'||unistr('\000a')||
''||unistr('\000a')||
'2. Dynamic LOV with Option Grouping'||unistr('\000a')||
'<pre>'||unistr('\000a')||
'SELECT e.ename d,'||unistr('\000a')||
'       e.empno r,'||unistr('\000a')||
'       d.dname grp'||unistr('\000a')||
'FROM emp e'||unistr('\000a')||
'LEFT JOIN dept d ON d.deptno = e.deptno'||unistr('\000a')||
'ORDER BY grp, d'||unistr('\000a')||
'</pre>'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_help_text => '<div>'||unistr('\000a')||
'	The Select2 plugin is a jQuery based replacement for select lists in Oracle Application Express. It supports searching, multiselection, tagging, lazy loading and infinite scrolling of results.</div>'||unistr('\000a')||
''
 ,p_version_identifier => '3.0.3'
 ,p_about_url => 'http://apex.oracle.com/pls/apex/f?p=64237:20'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9999660288542165 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'No Results Found Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The default message is "No results found".'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21241202791394268 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Input Too Short Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The default message is "Please enter x or more characters". It is possible to reference the substitution variables #TERM#, #MINLENGTH# and #REMAININGCHARS#.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21245578334396620 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Selection Too Big Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The default message is "You can only select x item(s)". It is possible to reference the substitution variable #MAXSIZE#.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21249990455400078 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Searching Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The default message is "Searching...".'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21254404653404195 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Label for Null Option Group'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The name of the option group for records whose grouping column value is null.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 20713747741210727 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 45
 ,p_prompt => 'Loading More Results Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The default message is "Loading more results...".'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 7404848257821882 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 5
 ,p_prompt => 'Look and Feel'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'SELECT2'
 ,p_is_translatable => false
 ,p_help_text => 'Choose how Select2 items should look like.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 7406043944823878 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 7404848257821882 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Select2'
 ,p_return_value => 'SELECT2'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 7406441140825182 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 7404848257821882 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Select2 Classic'
 ,p_return_value => 'SELECT2_CLASSIC'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 7406839415825998 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 7404848257821882 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Custom'
 ,p_return_value => 'CUSTOM'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9676754426547066 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 60
 ,p_prompt => 'Error Loading Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The default message is "The results could not be loaded".'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9771759741889085 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 9
 ,p_display_sequence => 25
 ,p_prompt => 'Input Too Long Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The default message is "Please delete x characters". It is possible to reference the substitution variables #TERM#, #MAXLENGTH# and #OVERCHARS#.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9776841373943214 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 10
 ,p_display_sequence => 6
 ,p_prompt => 'Path to Custom CSS File'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 7404848257821882 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'CUSTOM'
 ,p_help_text => 'The path to the custom CSS file to style the Select2 items. You are allowed to use substitution strings here.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9779254947952019 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 11
 ,p_display_sequence => 7
 ,p_prompt => 'Custom CSS Filename (no extension)'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 7404848257821882 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'CUSTOM'
 ,p_help_text => 'The name of the custom CSS file to style the Select2 items. Do not add the .css extension in this field. You are allowed to use substitution strings here.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21290384829417406 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Select List Type'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'SINGLE'
 ,p_is_translatable => false
 ,p_help_text => 'A single-value select list allows the user to select one option, while the multi-value select list makes it possible to select multiple items. When tagging support is enabled, the user can select from pre-existing options or create new options on the fly.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21294790024418935 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21290384829417406 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Single-value Select List'
 ,p_return_value => 'SINGLE'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21299096257420699 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21290384829417406 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Multi-value Select List'
 ,p_return_value => 'MULTI'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21303403530422841 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21290384829417406 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Tagging Support'
 ,p_return_value => 'TAG'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21315880121501209 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Minimum Results for Search Field'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 21290384829417406 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'SINGLE'
 ,p_help_text => 'The minimum number of results that must be populated in order to display the search field. A negative value will always hide the search field.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21320293627505113 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Minimum Input Length'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_help_text => 'The minimum length for a search term or a new option entered by the user.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21324684754512044 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Maximum Input Length'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_help_text => 'Maximum number of characters that can be entered for a search term or new option while tagging.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21329101377516858 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Maximum Selection Size'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 21290384829417406 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'MULTI,TAG'
 ,p_help_text => 'The maximum number of items that can be selected.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21333507611518655 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Rapid Selection'
 ,p_attribute_type => 'CHECKBOXES'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 21290384829417406 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'MULTI,TAG'
 ,p_help_text => 'Prevent the dropdown from closing when an item is selected, allowing for rapid selection of multiple items.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21337880730520334 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21333507611518655 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => ' '
 ,p_return_value => 'Y'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21350400123525925 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Select on Blur'
 ,p_attribute_type => 'CHECKBOXES'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_help_text => 'Determines whether the currently highlighted option is selected when the select list loses focus.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21354803586526915 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21350400123525925 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => ' '
 ,p_return_value => 'Y'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21367292289533163 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'Search Logic'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'CIC'
 ,p_is_translatable => false
 ,p_help_text => 'Defines how the search with the entered value should be performed.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21371698522534880 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21367292289533163 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Contains & Ignore Case'
 ,p_return_value => 'CIC'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 9767648009204352 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21367292289533163 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 15
 ,p_display_value => 'Contains & Ignore Case, with Diacritics'
 ,p_return_value => 'CICD'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21376003024536203 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21367292289533163 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Contains & Case Sensitive'
 ,p_return_value => 'CCS'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21380277182538172 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21367292289533163 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Exact & Ignore Case'
 ,p_return_value => 'EIC'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21384586186540861 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21367292289533163 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Exact & Case Sensitive'
 ,p_return_value => 'ECS'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21237069996243023 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21367292289533163 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 50
 ,p_display_value => 'Starts With & Ignore Case'
 ,p_return_value => 'SIC'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21241343808244950 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21367292289533163 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 60
 ,p_display_value => 'Starts With & Case Sensitive'
 ,p_return_value => 'SCS'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 7398854087545761 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21367292289533163 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 70
 ,p_display_value => 'Multi-word Search'
 ,p_return_value => 'MW'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21397082854549303 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 9
 ,p_display_sequence => 90
 ,p_prompt => 'Label for Null Option Group'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_display_length => 40
 ,p_is_translatable => true
 ,p_help_text => 'The name of the option group for records whose grouping column value is null. Overwrites the "Label for Null Option Group" attribute in component settings if filled in.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21401500170554286 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 10
 ,p_display_sequence => 15
 ,p_prompt => 'Width'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_display_length => 10
 ,p_is_translatable => false
 ,p_help_text => 'Controls the width style attribute of the Select2 item. The following values are supported:'||unistr('\000a')||
''||unistr('\000a')||
'<ul>'||unistr('\000a')||
'  <li><b>element</b> (default): Uses JavaScript to calculate the width of the source element.</li>'||unistr('\000a')||
'  <li><b>off</b>: No width attribute will be set. Keep in mind that the Select2 item copies classes from the source element so setting the width attribute may not always be necessary.</li>'||unistr('\000a')||
'  <li><b>copy</b>: Copies the value of the width style attribute set on the source element.</li>'||unistr('\000a')||
'  <li><b>resolve</b>: First attempts to copy than falls back on element.</li>'||unistr('\000a')||
'  <li><b>other values</b>: Any valid CSS style width value (e.g. 400px or 100%).</li>'||unistr('\000a')||
'</ul>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 21405906749556251 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 11
 ,p_display_sequence => 65
 ,p_prompt => 'Drag and Drop Sorting'
 ,p_attribute_type => 'CHECKBOXES'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 21290384829417406 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'MULTI,TAG'
 ,p_help_text => 'Allow drag and drop sorting of selected choices.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 21410308827556785 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 21405906749556251 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => ' '
 ,p_return_value => 'Y'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9745854633745513 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 12
 ,p_display_sequence => 100
 ,p_prompt => 'Token Separators'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_display_length => 20
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 21290384829417406 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'TAG'
 ,p_help_text => 'Select2 supports the ability to add choices automatically as the user is typing into the search field. Use the JavaScript array notation to specify one or more token separators.'||unistr('\000a')||
''||unistr('\000a')||
'The following example defines the comma and space characters as token separators: ['','', '' '']'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 2619132408422639 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 13
 ,p_display_sequence => 130
 ,p_prompt => 'Extra Options'
 ,p_attribute_type => 'TEXTAREA'
 ,p_is_required => false
 ,p_display_length => 60
 ,p_is_translatable => false
 ,p_help_text => 'Enter any extra Select2 jQuery plugin options. For example:<br><br>'||unistr('\000a')||
''||unistr('\000a')||
'dir: "rtl",<br>'||unistr('\000a')||
'dropdownParent: $(''.ui-dialog''),'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 20917661677541966 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 14
 ,p_display_sequence => 110
 ,p_prompt => 'Lazy Loading'
 ,p_attribute_type => 'CHECKBOXES'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_help_text => 'Decide whether you want to enable lazy loading. Lazy loading is an AJAX-driven technique that improves page performance by not executing the LOV query until the point at which it is actually needed.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 20926864794542794 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 20917661677541966 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => ' '
 ,p_return_value => 'Y'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 20956842733668919 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 15
 ,p_display_sequence => 120
 ,p_prompt => 'Lazy-append Row Count'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 20917661677541966 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'Select2 supports lazy-appending of results when the result list is scrolled to the end. This setting allows you to determine the amount of rows that get appended to the item''s result list. Leave empty to disable lazy-appending, which means that all rows will get populated immediately.'
  );
wwv_flow_api.create_plugin_event (
  p_id => 9710535605953680 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_name => 'slctchange'
 ,p_display_name => 'Change'
  );
wwv_flow_api.create_plugin_event (
  p_id => 9710847621953682 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_name => 'slctclose'
 ,p_display_name => 'Close'
  );
wwv_flow_api.create_plugin_event (
  p_id => 9711252246953682 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_name => 'slctclosing'
 ,p_display_name => 'Closing'
  );
wwv_flow_api.create_plugin_event (
  p_id => 9711650708953683 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_name => 'slctopen'
 ,p_display_name => 'Open'
  );
wwv_flow_api.create_plugin_event (
  p_id => 9712034907953683 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_name => 'slctopening'
 ,p_display_name => 'Opening'
  );
wwv_flow_api.create_plugin_event (
  p_id => 9712443341953684 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_name => 'slctselect'
 ,p_display_name => 'Select'
  );
wwv_flow_api.create_plugin_event (
  p_id => 9712857193953684 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_name => 'slctselecting'
 ,p_display_name => 'Selecting'
  );
wwv_flow_api.create_plugin_event (
  p_id => 9713239083953685 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_name => 'slctunselect'
 ,p_display_name => 'Unselect'
  );
wwv_flow_api.create_plugin_event (
  p_id => 9713647907953685 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_name => 'slctunselecting'
 ,p_display_name => 'Unselecting'
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D7365617263682D2D696E6C696E65202E73656C656374322D7365617263685F5F6669656C64207B0D0A202077696474683A206175746F2021696D706F7274';
wwv_flow_api.g_varchar2_table(2) := '616E743B0D0A7D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 7409251806855171 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2-classic.css'
 ,p_mime_type => 'text/css'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E73656C656374322D636F6E7461696E65727B626F782D73697A696E673A626F726465722D626F783B646973706C61793A696E6C696E652D626C6F636B3B6D617267696E3A303B706F736974696F6E3A72656C61746976653B766572746963616C2D616C';
wwv_flow_api.g_varchar2_table(2) := '69676E3A6D6964646C657D2E73656C656374322D636F6E7461696E6572202E73656C656374322D73656C656374696F6E2D2D73696E676C657B626F782D73697A696E673A626F726465722D626F783B637572736F723A706F696E7465723B646973706C61';
wwv_flow_api.g_varchar2_table(3) := '793A626C6F636B3B6865696768743A323870783B757365722D73656C6563743A6E6F6E653B2D7765626B69742D757365722D73656C6563743A6E6F6E657D2E73656C656374322D636F6E7461696E6572202E73656C656374322D73656C656374696F6E2D';
wwv_flow_api.g_varchar2_table(4) := '2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F72656E64657265647B646973706C61793A626C6F636B3B70616464696E672D6C6566743A3870783B70616464696E672D72696768743A323070783B6F766572666C6F773A68696464';
wwv_flow_api.g_varchar2_table(5) := '656E3B746578742D6F766572666C6F773A656C6C69707369733B77686974652D73706163653A6E6F777261707D2E73656C656374322D636F6E7461696E6572202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D';
wwv_flow_api.g_varchar2_table(6) := '73656C656374696F6E5F5F636C6561727B706F736974696F6E3A72656C61746976657D2E73656C656374322D636F6E7461696E65725B6469723D2272746C225D202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C65637432';
wwv_flow_api.g_varchar2_table(7) := '2D73656C656374696F6E5F5F72656E64657265647B70616464696E672D72696768743A3870783B70616464696E672D6C6566743A323070787D2E73656C656374322D636F6E7461696E6572202E73656C656374322D73656C656374696F6E2D2D6D756C74';
wwv_flow_api.g_varchar2_table(8) := '69706C657B626F782D73697A696E673A626F726465722D626F783B637572736F723A706F696E7465723B646973706C61793A626C6F636B3B6D696E2D6865696768743A333270783B757365722D73656C6563743A6E6F6E653B2D7765626B69742D757365';
wwv_flow_api.g_varchar2_table(9) := '722D73656C6563743A6E6F6E657D2E73656C656374322D636F6E7461696E6572202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E5F5F72656E64657265647B646973706C61793A69';
wwv_flow_api.g_varchar2_table(10) := '6E6C696E652D626C6F636B3B6F766572666C6F773A68696464656E3B70616464696E672D6C6566743A3870783B746578742D6F766572666C6F773A656C6C69707369733B77686974652D73706163653A6E6F777261707D2E73656C656374322D636F6E74';
wwv_flow_api.g_varchar2_table(11) := '61696E6572202E73656C656374322D7365617263682D2D696E6C696E657B666C6F61743A6C6566747D2E73656C656374322D636F6E7461696E6572202E73656C656374322D7365617263682D2D696E6C696E65202E73656C656374322D7365617263685F';
wwv_flow_api.g_varchar2_table(12) := '5F6669656C647B626F782D73697A696E673A626F726465722D626F783B626F726465723A6E6F6E653B666F6E742D73697A653A313030253B6D617267696E2D746F703A3570783B70616464696E673A307D2E73656C656374322D636F6E7461696E657220';
wwv_flow_api.g_varchar2_table(13) := '2E73656C656374322D7365617263682D2D696E6C696E65202E73656C656374322D7365617263685F5F6669656C643A3A2D7765626B69742D7365617263682D63616E63656C2D627574746F6E7B2D7765626B69742D617070656172616E63653A6E6F6E65';
wwv_flow_api.g_varchar2_table(14) := '7D2E73656C656374322D64726F70646F776E7B6261636B67726F756E642D636F6C6F723A77686974653B626F726465723A31707820736F6C696420236161613B626F726465722D7261646975733A3470783B626F782D73697A696E673A626F726465722D';
wwv_flow_api.g_varchar2_table(15) := '626F783B646973706C61793A626C6F636B3B706F736974696F6E3A6162736F6C7574653B6C6566743A2D31303030303070783B77696474683A313030253B7A2D696E6465783A313035317D2E73656C656374322D726573756C74737B646973706C61793A';
wwv_flow_api.g_varchar2_table(16) := '626C6F636B7D2E73656C656374322D726573756C74735F5F6F7074696F6E737B6C6973742D7374796C653A6E6F6E653B6D617267696E3A303B70616464696E673A307D2E73656C656374322D726573756C74735F5F6F7074696F6E7B70616464696E673A';
wwv_flow_api.g_varchar2_table(17) := '3670783B757365722D73656C6563743A6E6F6E653B2D7765626B69742D757365722D73656C6563743A6E6F6E657D2E73656C656374322D726573756C74735F5F6F7074696F6E5B617269612D73656C65637465645D7B637572736F723A706F696E746572';
wwv_flow_api.g_varchar2_table(18) := '7D2E73656C656374322D636F6E7461696E65722D2D6F70656E202E73656C656374322D64726F70646F776E7B6C6566743A307D2E73656C656374322D636F6E7461696E65722D2D6F70656E202E73656C656374322D64726F70646F776E2D2D61626F7665';
wwv_flow_api.g_varchar2_table(19) := '7B626F726465722D626F74746F6D3A6E6F6E653B626F726465722D626F74746F6D2D6C6566742D7261646975733A303B626F726465722D626F74746F6D2D72696768742D7261646975733A307D2E73656C656374322D636F6E7461696E65722D2D6F7065';
wwv_flow_api.g_varchar2_table(20) := '6E202E73656C656374322D64726F70646F776E2D2D62656C6F777B626F726465722D746F703A6E6F6E653B626F726465722D746F702D6C6566742D7261646975733A303B626F726465722D746F702D72696768742D7261646975733A307D2E73656C6563';
wwv_flow_api.g_varchar2_table(21) := '74322D7365617263682D2D64726F70646F776E7B646973706C61793A626C6F636B3B70616464696E673A3470787D2E73656C656374322D7365617263682D2D64726F70646F776E202E73656C656374322D7365617263685F5F6669656C647B7061646469';
wwv_flow_api.g_varchar2_table(22) := '6E673A3470783B77696474683A313030253B626F782D73697A696E673A626F726465722D626F787D2E73656C656374322D7365617263682D2D64726F70646F776E202E73656C656374322D7365617263685F5F6669656C643A3A2D7765626B69742D7365';
wwv_flow_api.g_varchar2_table(23) := '617263682D63616E63656C2D627574746F6E7B2D7765626B69742D617070656172616E63653A6E6F6E657D2E73656C656374322D7365617263682D2D64726F70646F776E2E73656C656374322D7365617263682D2D686964657B646973706C61793A6E6F';
wwv_flow_api.g_varchar2_table(24) := '6E657D2E73656C656374322D636C6F73652D6D61736B7B626F726465723A303B6D617267696E3A303B70616464696E673A303B646973706C61793A626C6F636B3B706F736974696F6E3A66697865643B6C6566743A303B746F703A303B6D696E2D686569';
wwv_flow_api.g_varchar2_table(25) := '6768743A313030253B6D696E2D77696474683A313030253B6865696768743A6175746F3B77696474683A6175746F3B6F7061636974793A303B7A2D696E6465783A39393B6261636B67726F756E642D636F6C6F723A236666663B66696C7465723A616C70';
wwv_flow_api.g_varchar2_table(26) := '6861286F7061636974793D30297D2E73656C656374322D68696464656E2D61636365737369626C657B626F726465723A302021696D706F7274616E743B636C69703A726563742830203020302030292021696D706F7274616E743B6865696768743A3170';
wwv_flow_api.g_varchar2_table(27) := '782021696D706F7274616E743B6D617267696E3A2D3170782021696D706F7274616E743B6F766572666C6F773A68696464656E2021696D706F7274616E743B70616464696E673A302021696D706F7274616E743B706F736974696F6E3A6162736F6C7574';
wwv_flow_api.g_varchar2_table(28) := '652021696D706F7274616E743B77696474683A3170782021696D706F7274616E747D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D73696E676C657B6261636B67726F756E642D';
wwv_flow_api.g_varchar2_table(29) := '636F6C6F723A236666663B626F726465723A31707820736F6C696420236161613B626F726465722D7261646975733A3470787D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D73';
wwv_flow_api.g_varchar2_table(30) := '696E676C65202E73656C656374322D73656C656374696F6E5F5F72656E64657265647B636F6C6F723A233434343B6C696E652D6865696768743A323870787D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D';
wwv_flow_api.g_varchar2_table(31) := '73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F636C6561727B637572736F723A706F696E7465723B666C6F61743A72696768743B666F6E742D7765696768743A626F6C647D2E73656C656374322D636F6E';
wwv_flow_api.g_varchar2_table(32) := '7461696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F706C616365686F6C6465727B636F6C6F723A233939397D2E73656C656374322D636F6E7461';
wwv_flow_api.g_varchar2_table(33) := '696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F6172726F777B6865696768743A323670783B706F736974696F6E3A6162736F6C7574653B746F70';
wwv_flow_api.g_varchar2_table(34) := '3A3170783B72696768743A3170783B77696474683A323070787D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F';
wwv_flow_api.g_varchar2_table(35) := '5F6172726F7720627B626F726465722D636F6C6F723A23383838207472616E73706172656E74207472616E73706172656E74207472616E73706172656E743B626F726465722D7374796C653A736F6C69643B626F726465722D77696474683A3570782034';
wwv_flow_api.g_varchar2_table(36) := '70782030203470783B6865696768743A303B6C6566743A3530253B6D617267696E2D6C6566743A2D3470783B6D617267696E2D746F703A2D3270783B706F736974696F6E3A6162736F6C7574653B746F703A3530253B77696474683A307D2E73656C6563';
wwv_flow_api.g_varchar2_table(37) := '74322D636F6E7461696E65722D2D64656661756C745B6469723D2272746C225D202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F636C6561727B666C6F61743A6C6566747D2E7365';
wwv_flow_api.g_varchar2_table(38) := '6C656374322D636F6E7461696E65722D2D64656661756C745B6469723D2272746C225D202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F6172726F777B6C6566743A3170783B7269';
wwv_flow_api.g_varchar2_table(39) := '6768743A6175746F7D2E73656C656374322D636F6E7461696E65722D2D64656661756C742E73656C656374322D636F6E7461696E65722D2D64697361626C6564202E73656C656374322D73656C656374696F6E2D2D73696E676C657B6261636B67726F75';
wwv_flow_api.g_varchar2_table(40) := '6E642D636F6C6F723A236565653B637572736F723A64656661756C747D2E73656C656374322D636F6E7461696E65722D2D64656661756C742E73656C656374322D636F6E7461696E65722D2D64697361626C6564202E73656C656374322D73656C656374';
wwv_flow_api.g_varchar2_table(41) := '696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F636C6561727B646973706C61793A6E6F6E657D2E73656C656374322D636F6E7461696E65722D2D64656661756C742E73656C656374322D636F6E7461696E65722D2D6F70';
wwv_flow_api.g_varchar2_table(42) := '656E202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F6172726F7720627B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E74202338383820';
wwv_flow_api.g_varchar2_table(43) := '7472616E73706172656E743B626F726465722D77696474683A302034707820357078203470787D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C657B6261636B';
wwv_flow_api.g_varchar2_table(44) := '67726F756E642D636F6C6F723A77686974653B626F726465723A31707820736F6C696420236161613B626F726465722D7261646975733A3470783B637572736F723A746578747D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E';
wwv_flow_api.g_varchar2_table(45) := '73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E5F5F72656E64657265647B626F782D73697A696E673A626F726465722D626F783B6C6973742D7374796C653A6E6F6E653B6D61726769';
wwv_flow_api.g_varchar2_table(46) := '6E3A303B70616464696E673A30203570783B77696474683A313030257D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C6563';
wwv_flow_api.g_varchar2_table(47) := '74696F6E5F5F72656E6465726564206C697B6C6973742D7374796C653A6E6F6E657D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D';
wwv_flow_api.g_varchar2_table(48) := '73656C656374696F6E5F5F706C616365686F6C6465727B636F6C6F723A233939393B6D617267696E2D746F703A3570783B666C6F61743A6C6566747D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D73656C';
wwv_flow_api.g_varchar2_table(49) := '656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E5F5F636C6561727B637572736F723A706F696E7465723B666C6F61743A72696768743B666F6E742D7765696768743A626F6C643B6D617267696E2D746F703A3570';
wwv_flow_api.g_varchar2_table(50) := '783B6D617267696E2D72696768743A313070787D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E5F5F63686F';
wwv_flow_api.g_varchar2_table(51) := '6963657B6261636B67726F756E642D636F6C6F723A236534653465343B626F726465723A31707820736F6C696420236161613B626F726465722D7261646975733A3470783B637572736F723A64656661756C743B666C6F61743A6C6566743B6D61726769';
wwv_flow_api.g_varchar2_table(52) := '6E2D72696768743A3570783B6D617267696E2D746F703A3570783B70616464696E673A30203570787D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73';
wwv_flow_api.g_varchar2_table(53) := '656C656374322D73656C656374696F6E5F5F63686F6963655F5F72656D6F76657B636F6C6F723A233939393B637572736F723A706F696E7465723B646973706C61793A696E6C696E652D626C6F636B3B666F6E742D7765696768743A626F6C643B6D6172';
wwv_flow_api.g_varchar2_table(54) := '67696E2D72696768743A3270787D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E5F5F63686F6963655F5F72';
wwv_flow_api.g_varchar2_table(55) := '656D6F76653A686F7665727B636F6C6F723A233333337D2E73656C656374322D636F6E7461696E65722D2D64656661756C745B6469723D2272746C225D202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D';
wwv_flow_api.g_varchar2_table(56) := '73656C656374696F6E5F5F63686F6963652C2E73656C656374322D636F6E7461696E65722D2D64656661756C745B6469723D2272746C225D202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C6563';
wwv_flow_api.g_varchar2_table(57) := '74696F6E5F5F706C616365686F6C6465722C2E73656C656374322D636F6E7461696E65722D2D64656661756C745B6469723D2272746C225D202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D7365617263';
wwv_flow_api.g_varchar2_table(58) := '682D2D696E6C696E657B666C6F61743A72696768747D2E73656C656374322D636F6E7461696E65722D2D64656661756C745B6469723D2272746C225D202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73';
wwv_flow_api.g_varchar2_table(59) := '656C656374696F6E5F5F63686F6963657B6D617267696E2D6C6566743A3570783B6D617267696E2D72696768743A6175746F7D2E73656C656374322D636F6E7461696E65722D2D64656661756C745B6469723D2272746C225D202E73656C656374322D73';
wwv_flow_api.g_varchar2_table(60) := '656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E5F5F63686F6963655F5F72656D6F76657B6D617267696E2D6C6566743A3270783B6D617267696E2D72696768743A6175746F7D2E73656C656374322D636F6E';
wwv_flow_api.g_varchar2_table(61) := '7461696E65722D2D64656661756C742E73656C656374322D636F6E7461696E65722D2D666F637573202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C657B626F726465723A736F6C696420626C61636B203170783B6F75746C696E65';
wwv_flow_api.g_varchar2_table(62) := '3A307D2E73656C656374322D636F6E7461696E65722D2D64656661756C742E73656C656374322D636F6E7461696E65722D2D64697361626C6564202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C657B6261636B67726F756E642D63';
wwv_flow_api.g_varchar2_table(63) := '6F6C6F723A236565653B637572736F723A64656661756C747D2E73656C656374322D636F6E7461696E65722D2D64656661756C742E73656C656374322D636F6E7461696E65722D2D64697361626C6564202E73656C656374322D73656C656374696F6E5F';
wwv_flow_api.g_varchar2_table(64) := '5F63686F6963655F5F72656D6F76657B646973706C61793A6E6F6E657D2E73656C656374322D636F6E7461696E65722D2D64656661756C742E73656C656374322D636F6E7461696E65722D2D6F70656E2E73656C656374322D636F6E7461696E65722D2D';
wwv_flow_api.g_varchar2_table(65) := '61626F7665202E73656C656374322D73656C656374696F6E2D2D73696E676C652C2E73656C656374322D636F6E7461696E65722D2D64656661756C742E73656C656374322D636F6E7461696E65722D2D6F70656E2E73656C656374322D636F6E7461696E';
wwv_flow_api.g_varchar2_table(66) := '65722D2D61626F7665202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C657B626F726465722D746F702D6C6566742D7261646975733A303B626F726465722D746F702D72696768742D7261646975733A307D2E73656C656374322D63';
wwv_flow_api.g_varchar2_table(67) := '6F6E7461696E65722D2D64656661756C742E73656C656374322D636F6E7461696E65722D2D6F70656E2E73656C656374322D636F6E7461696E65722D2D62656C6F77202E73656C656374322D73656C656374696F6E2D2D73696E676C652C2E73656C6563';
wwv_flow_api.g_varchar2_table(68) := '74322D636F6E7461696E65722D2D64656661756C742E73656C656374322D636F6E7461696E65722D2D6F70656E2E73656C656374322D636F6E7461696E65722D2D62656C6F77202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C657B';
wwv_flow_api.g_varchar2_table(69) := '626F726465722D626F74746F6D2D6C6566742D7261646975733A303B626F726465722D626F74746F6D2D72696768742D7261646975733A307D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D736561726368';
wwv_flow_api.g_varchar2_table(70) := '2D2D64726F70646F776E202E73656C656374322D7365617263685F5F6669656C647B626F726465723A31707820736F6C696420236161617D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D7365617263682D';
wwv_flow_api.g_varchar2_table(71) := '2D696E6C696E65202E73656C656374322D7365617263685F5F6669656C647B6261636B67726F756E643A7472616E73706172656E743B626F726465723A6E6F6E653B6F75746C696E653A303B626F782D736861646F773A6E6F6E653B2D7765626B69742D';
wwv_flow_api.g_varchar2_table(72) := '617070656172616E63653A746578746669656C647D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D726573756C74733E2E73656C656374322D726573756C74735F5F6F7074696F6E737B6D61782D68656967';
wwv_flow_api.g_varchar2_table(73) := '68743A32303070783B6F766572666C6F772D793A6175746F7D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D726573756C74735F5F6F7074696F6E5B726F6C653D67726F75705D7B70616464696E673A307D';
wwv_flow_api.g_varchar2_table(74) := '2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D726573756C74735F5F6F7074696F6E5B617269612D64697361626C65643D747275655D7B636F6C6F723A233939397D2E73656C656374322D636F6E7461696E';
wwv_flow_api.g_varchar2_table(75) := '65722D2D64656661756C74202E73656C656374322D726573756C74735F5F6F7074696F6E5B617269612D73656C65637465643D747275655D7B6261636B67726F756E642D636F6C6F723A236464647D2E73656C656374322D636F6E7461696E65722D2D64';
wwv_flow_api.g_varchar2_table(76) := '656661756C74202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E7B70616464696E672D6C6566743A31656D7D2E73656C656374322D636F6E7461696E65722D2D64656661756C';
wwv_flow_api.g_varchar2_table(77) := '74202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F67726F75707B70616464696E672D6C6566743A307D2E73656C656374322D';
wwv_flow_api.g_varchar2_table(78) := '636F6E7461696E65722D2D64656661756C74202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E7B6D617267696E';
wwv_flow_api.g_varchar2_table(79) := '2D6C6566743A2D31656D3B70616464696E672D6C6566743A32656D7D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F';
wwv_flow_api.g_varchar2_table(80) := '7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E7B6D617267696E2D6C6566743A2D32656D3B70616464696E672D6C6566743A33656D7D2E73656C656374322D63';
wwv_flow_api.g_varchar2_table(81) := '6F6E7461696E65722D2D64656661756C74202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374';
wwv_flow_api.g_varchar2_table(82) := '322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E7B6D617267696E2D6C6566743A2D33656D3B70616464696E672D6C6566743A34656D7D2E73656C656374322D636F6E7461696E65722D2D646566';
wwv_flow_api.g_varchar2_table(83) := '61756C74202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F70';
wwv_flow_api.g_varchar2_table(84) := '74696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E7B6D617267696E2D6C6566743A2D34656D3B70616464696E672D6C6566743A35656D7D2E73656C656374322D636F';
wwv_flow_api.g_varchar2_table(85) := '6E7461696E65722D2D64656661756C74202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C65637432';
wwv_flow_api.g_varchar2_table(86) := '2D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E202E73656C656374322D726573756C74735F5F6F7074696F6E7B6D617267696E2D6C';
wwv_flow_api.g_varchar2_table(87) := '6566743A2D35656D3B70616464696E672D6C6566743A36656D7D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D726573756C74735F5F6F7074696F6E2D2D686967686C6967687465645B617269612D73656C';
wwv_flow_api.g_varchar2_table(88) := '65637465645D7B6261636B67726F756E642D636F6C6F723A233538393766623B636F6C6F723A77686974657D2E73656C656374322D636F6E7461696E65722D2D64656661756C74202E73656C656374322D726573756C74735F5F67726F75707B63757273';
wwv_flow_api.g_varchar2_table(89) := '6F723A64656661756C743B646973706C61793A626C6F636B3B70616464696E673A3670787D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D73696E676C657B6261636B67726F75';
wwv_flow_api.g_varchar2_table(90) := '6E642D636F6C6F723A236637663766373B626F726465723A31707820736F6C696420236161613B626F726465722D7261646975733A3470783B6F75746C696E653A303B6261636B67726F756E642D696D6167653A2D7765626B69742D6C696E6561722D67';
wwv_flow_api.g_varchar2_table(91) := '72616469656E7428746F702C2023666666203530252C20236565652031303025293B6261636B67726F756E642D696D6167653A2D6F2D6C696E6561722D6772616469656E7428746F702C2023666666203530252C20236565652031303025293B6261636B';
wwv_flow_api.g_varchar2_table(92) := '67726F756E642D696D6167653A6C696E6561722D6772616469656E7428746F20626F74746F6D2C2023666666203530252C20236565652031303025293B6261636B67726F756E642D7265706561743A7265706561742D783B66696C7465723A70726F6769';
wwv_flow_api.g_varchar2_table(93) := '643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F727374723D27234646464646464646272C20656E64436F6C6F727374723D27234646454545454545272C204772616469656E745479';
wwv_flow_api.g_varchar2_table(94) := '70653D30297D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D73696E676C653A666F6375737B626F726465723A31707820736F6C696420233538393766627D2E73656C65637432';
wwv_flow_api.g_varchar2_table(95) := '2D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F72656E64657265647B636F6C6F723A233434343B6C696E652D6865696768743A32';
wwv_flow_api.g_varchar2_table(96) := '3870787D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F636C6561727B637572736F723A706F696E7465723B';
wwv_flow_api.g_varchar2_table(97) := '666C6F61743A72696768743B666F6E742D7765696768743A626F6C643B6D617267696E2D72696768743A313070787D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D73696E676C';
wwv_flow_api.g_varchar2_table(98) := '65202E73656C656374322D73656C656374696F6E5F5F706C616365686F6C6465727B636F6C6F723A233939397D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D73696E676C6520';
wwv_flow_api.g_varchar2_table(99) := '2E73656C656374322D73656C656374696F6E5F5F6172726F777B6261636B67726F756E642D636F6C6F723A236464643B626F726465723A6E6F6E653B626F726465722D6C6566743A31707820736F6C696420236161613B626F726465722D746F702D7269';
wwv_flow_api.g_varchar2_table(100) := '6768742D7261646975733A3470783B626F726465722D626F74746F6D2D72696768742D7261646975733A3470783B6865696768743A323670783B706F736974696F6E3A6162736F6C7574653B746F703A3170783B72696768743A3170783B77696474683A';
wwv_flow_api.g_varchar2_table(101) := '323070783B6261636B67726F756E642D696D6167653A2D7765626B69742D6C696E6561722D6772616469656E7428746F702C2023656565203530252C20236363632031303025293B6261636B67726F756E642D696D6167653A2D6F2D6C696E6561722D67';
wwv_flow_api.g_varchar2_table(102) := '72616469656E7428746F702C2023656565203530252C20236363632031303025293B6261636B67726F756E642D696D6167653A6C696E6561722D6772616469656E7428746F20626F74746F6D2C2023656565203530252C20236363632031303025293B62';
wwv_flow_api.g_varchar2_table(103) := '61636B67726F756E642D7265706561743A7265706561742D783B66696C7465723A70726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F727374723D27234646454545454545';
wwv_flow_api.g_varchar2_table(104) := '272C20656E64436F6C6F727374723D27234646434343434343272C204772616469656E74547970653D30297D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E';
wwv_flow_api.g_varchar2_table(105) := '73656C656374322D73656C656374696F6E5F5F6172726F7720627B626F726465722D636F6C6F723A23383838207472616E73706172656E74207472616E73706172656E74207472616E73706172656E743B626F726465722D7374796C653A736F6C69643B';
wwv_flow_api.g_varchar2_table(106) := '626F726465722D77696474683A357078203470782030203470783B6865696768743A303B6C6566743A3530253B6D617267696E2D6C6566743A2D3470783B6D617267696E2D746F703A2D3270783B706F736974696F6E3A6162736F6C7574653B746F703A';
wwv_flow_api.g_varchar2_table(107) := '3530253B77696474683A307D2E73656C656374322D636F6E7461696E65722D2D636C61737369635B6469723D2272746C225D202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F636C';
wwv_flow_api.g_varchar2_table(108) := '6561727B666C6F61743A6C6566747D2E73656C656374322D636F6E7461696E65722D2D636C61737369635B6469723D2272746C225D202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F';
wwv_flow_api.g_varchar2_table(109) := '5F6172726F777B626F726465723A6E6F6E653B626F726465722D72696768743A31707820736F6C696420236161613B626F726465722D7261646975733A303B626F726465722D746F702D6C6566742D7261646975733A3470783B626F726465722D626F74';
wwv_flow_api.g_varchar2_table(110) := '746F6D2D6C6566742D7261646975733A3470783B6C6566743A3170783B72696768743A6175746F7D2E73656C656374322D636F6E7461696E65722D2D636C61737369632E73656C656374322D636F6E7461696E65722D2D6F70656E202E73656C65637432';
wwv_flow_api.g_varchar2_table(111) := '2D73656C656374696F6E2D2D73696E676C657B626F726465723A31707820736F6C696420233538393766627D2E73656C656374322D636F6E7461696E65722D2D636C61737369632E73656C656374322D636F6E7461696E65722D2D6F70656E202E73656C';
wwv_flow_api.g_varchar2_table(112) := '656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F6172726F777B6261636B67726F756E643A7472616E73706172656E743B626F726465723A6E6F6E657D2E73656C656374322D636F6E7461696E';
wwv_flow_api.g_varchar2_table(113) := '65722D2D636C61737369632E73656C656374322D636F6E7461696E65722D2D6F70656E202E73656C656374322D73656C656374696F6E2D2D73696E676C65202E73656C656374322D73656C656374696F6E5F5F6172726F7720627B626F726465722D636F';
wwv_flow_api.g_varchar2_table(114) := '6C6F723A7472616E73706172656E74207472616E73706172656E742023383838207472616E73706172656E743B626F726465722D77696474683A302034707820357078203470787D2E73656C656374322D636F6E7461696E65722D2D636C61737369632E';
wwv_flow_api.g_varchar2_table(115) := '73656C656374322D636F6E7461696E65722D2D6F70656E2E73656C656374322D636F6E7461696E65722D2D61626F7665202E73656C656374322D73656C656374696F6E2D2D73696E676C657B626F726465722D746F703A6E6F6E653B626F726465722D74';
wwv_flow_api.g_varchar2_table(116) := '6F702D6C6566742D7261646975733A303B626F726465722D746F702D72696768742D7261646975733A303B6261636B67726F756E642D696D6167653A2D7765626B69742D6C696E6561722D6772616469656E7428746F702C20236666662030252C202365';
wwv_flow_api.g_varchar2_table(117) := '656520353025293B6261636B67726F756E642D696D6167653A2D6F2D6C696E6561722D6772616469656E7428746F702C20236666662030252C202365656520353025293B6261636B67726F756E642D696D6167653A6C696E6561722D6772616469656E74';
wwv_flow_api.g_varchar2_table(118) := '28746F20626F74746F6D2C20236666662030252C202365656520353025293B6261636B67726F756E642D7265706561743A7265706561742D783B66696C7465723A70726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E67';
wwv_flow_api.g_varchar2_table(119) := '72616469656E74287374617274436F6C6F727374723D27234646464646464646272C20656E64436F6C6F727374723D27234646454545454545272C204772616469656E74547970653D30297D2E73656C656374322D636F6E7461696E65722D2D636C6173';
wwv_flow_api.g_varchar2_table(120) := '7369632E73656C656374322D636F6E7461696E65722D2D6F70656E2E73656C656374322D636F6E7461696E65722D2D62656C6F77202E73656C656374322D73656C656374696F6E2D2D73696E676C657B626F726465722D626F74746F6D3A6E6F6E653B62';
wwv_flow_api.g_varchar2_table(121) := '6F726465722D626F74746F6D2D6C6566742D7261646975733A303B626F726465722D626F74746F6D2D72696768742D7261646975733A303B6261636B67726F756E642D696D6167653A2D7765626B69742D6C696E6561722D6772616469656E7428746F70';
wwv_flow_api.g_varchar2_table(122) := '2C2023656565203530252C20236666662031303025293B6261636B67726F756E642D696D6167653A2D6F2D6C696E6561722D6772616469656E7428746F702C2023656565203530252C20236666662031303025293B6261636B67726F756E642D696D6167';
wwv_flow_api.g_varchar2_table(123) := '653A6C696E6561722D6772616469656E7428746F20626F74746F6D2C2023656565203530252C20236666662031303025293B6261636B67726F756E642D7265706561743A7265706561742D783B66696C7465723A70726F6769643A4458496D6167655472';
wwv_flow_api.g_varchar2_table(124) := '616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F727374723D27234646454545454545272C20656E64436F6C6F727374723D27234646464646464646272C204772616469656E74547970653D30297D2E73656C65';
wwv_flow_api.g_varchar2_table(125) := '6374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C657B6261636B67726F756E642D636F6C6F723A77686974653B626F726465723A31707820736F6C696420236161613B626F72';
wwv_flow_api.g_varchar2_table(126) := '6465722D7261646975733A3470783B637572736F723A746578743B6F75746C696E653A307D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C653A666F6375737B';
wwv_flow_api.g_varchar2_table(127) := '626F726465723A31707820736F6C696420233538393766627D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E';
wwv_flow_api.g_varchar2_table(128) := '5F5F72656E64657265647B6C6973742D7374796C653A6E6F6E653B6D617267696E3A303B70616464696E673A30203570787D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D6D75';
wwv_flow_api.g_varchar2_table(129) := '6C7469706C65202E73656C656374322D73656C656374696F6E5F5F636C6561727B646973706C61793A6E6F6E657D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D6D756C746970';
wwv_flow_api.g_varchar2_table(130) := '6C65202E73656C656374322D73656C656374696F6E5F5F63686F6963657B6261636B67726F756E642D636F6C6F723A236534653465343B626F726465723A31707820736F6C696420236161613B626F726465722D7261646975733A3470783B637572736F';
wwv_flow_api.g_varchar2_table(131) := '723A64656661756C743B666C6F61743A6C6566743B6D617267696E2D72696768743A3570783B6D617267696E2D746F703A3570783B70616464696E673A30203570787D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C65';
wwv_flow_api.g_varchar2_table(132) := '6374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E5F5F63686F6963655F5F72656D6F76657B636F6C6F723A233838383B637572736F723A706F696E7465723B646973706C61793A696E6C696E652D';
wwv_flow_api.g_varchar2_table(133) := '626C6F636B3B666F6E742D7765696768743A626F6C643B6D617267696E2D72696768743A3270787D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E7365';
wwv_flow_api.g_varchar2_table(134) := '6C656374322D73656C656374696F6E5F5F63686F6963655F5F72656D6F76653A686F7665727B636F6C6F723A233535357D2E73656C656374322D636F6E7461696E65722D2D636C61737369635B6469723D2272746C225D202E73656C656374322D73656C';
wwv_flow_api.g_varchar2_table(135) := '656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E5F5F63686F6963657B666C6F61743A72696768747D2E73656C656374322D636F6E7461696E65722D2D636C61737369635B6469723D2272746C225D202E73656C65';
wwv_flow_api.g_varchar2_table(136) := '6374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E5F5F63686F6963657B6D617267696E2D6C6566743A3570783B6D617267696E2D72696768743A6175746F7D2E73656C656374322D636F6E746169';
wwv_flow_api.g_varchar2_table(137) := '6E65722D2D636C61737369635B6469723D2272746C225D202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C65202E73656C656374322D73656C656374696F6E5F5F63686F6963655F5F72656D6F76657B6D617267696E2D6C6566743A';
wwv_flow_api.g_varchar2_table(138) := '3270783B6D617267696E2D72696768743A6175746F7D2E73656C656374322D636F6E7461696E65722D2D636C61737369632E73656C656374322D636F6E7461696E65722D2D6F70656E202E73656C656374322D73656C656374696F6E2D2D6D756C746970';
wwv_flow_api.g_varchar2_table(139) := '6C657B626F726465723A31707820736F6C696420233538393766627D2E73656C656374322D636F6E7461696E65722D2D636C61737369632E73656C656374322D636F6E7461696E65722D2D6F70656E2E73656C656374322D636F6E7461696E65722D2D61';
wwv_flow_api.g_varchar2_table(140) := '626F7665202E73656C656374322D73656C656374696F6E2D2D6D756C7469706C657B626F726465722D746F703A6E6F6E653B626F726465722D746F702D6C6566742D7261646975733A303B626F726465722D746F702D72696768742D7261646975733A30';
wwv_flow_api.g_varchar2_table(141) := '7D2E73656C656374322D636F6E7461696E65722D2D636C61737369632E73656C656374322D636F6E7461696E65722D2D6F70656E2E73656C656374322D636F6E7461696E65722D2D62656C6F77202E73656C656374322D73656C656374696F6E2D2D6D75';
wwv_flow_api.g_varchar2_table(142) := '6C7469706C657B626F726465722D626F74746F6D3A6E6F6E653B626F726465722D626F74746F6D2D6C6566742D7261646975733A303B626F726465722D626F74746F6D2D72696768742D7261646975733A307D2E73656C656374322D636F6E7461696E65';
wwv_flow_api.g_varchar2_table(143) := '722D2D636C6173736963202E73656C656374322D7365617263682D2D64726F70646F776E202E73656C656374322D7365617263685F5F6669656C647B626F726465723A31707820736F6C696420236161613B6F75746C696E653A307D2E73656C65637432';
wwv_flow_api.g_varchar2_table(144) := '2D636F6E7461696E65722D2D636C6173736963202E73656C656374322D7365617263682D2D696E6C696E65202E73656C656374322D7365617263685F5F6669656C647B6F75746C696E653A303B626F782D736861646F773A6E6F6E657D2E73656C656374';
wwv_flow_api.g_varchar2_table(145) := '322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D64726F70646F776E7B6261636B67726F756E642D636F6C6F723A236666663B626F726465723A31707820736F6C6964207472616E73706172656E747D2E73656C656374322D63';
wwv_flow_api.g_varchar2_table(146) := '6F6E7461696E65722D2D636C6173736963202E73656C656374322D64726F70646F776E2D2D61626F76657B626F726465722D626F74746F6D3A6E6F6E657D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D64';
wwv_flow_api.g_varchar2_table(147) := '726F70646F776E2D2D62656C6F777B626F726465722D746F703A6E6F6E657D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D726573756C74733E2E73656C656374322D726573756C74735F5F6F7074696F6E';
wwv_flow_api.g_varchar2_table(148) := '737B6D61782D6865696768743A32303070783B6F766572666C6F772D793A6175746F7D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D726573756C74735F5F6F7074696F6E5B726F6C653D67726F75705D7B';
wwv_flow_api.g_varchar2_table(149) := '70616464696E673A307D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D726573756C74735F5F6F7074696F6E5B617269612D64697361626C65643D747275655D7B636F6C6F723A677265797D2E73656C6563';
wwv_flow_api.g_varchar2_table(150) := '74322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D726573756C74735F5F6F7074696F6E2D2D686967686C6967687465645B617269612D73656C65637465645D7B6261636B67726F756E642D636F6C6F723A233338373564373B';
wwv_flow_api.g_varchar2_table(151) := '636F6C6F723A236666667D2E73656C656374322D636F6E7461696E65722D2D636C6173736963202E73656C656374322D726573756C74735F5F67726F75707B637572736F723A64656661756C743B646973706C61793A626C6F636B3B70616464696E673A';
wwv_flow_api.g_varchar2_table(152) := '3670787D2E73656C656374322D636F6E7461696E65722D2D636C61737369632E73656C656374322D636F6E7461696E65722D2D6F70656E202E73656C656374322D64726F70646F776E7B626F726465722D636F6C6F723A233538393766627D0A';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 9652750450182059 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2.min.css'
 ,p_mime_type => 'text/css'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A212053656C6563743220342E302E33207C2068747470733A2F2F6769746875622E636F6D2F73656C656374322F73656C656374322F626C6F622F6D61737465722F4C4943454E53452E6D64202A2F2166756E6374696F6E2861297B2266756E637469';
wwv_flow_api.g_varchar2_table(2) := '6F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279225D2C61293A6128226F626A656374223D3D747970656F66206578706F7274733F7265717569726528226A717565727922293A6A5175';
wwv_flow_api.g_varchar2_table(3) := '657279297D2866756E6374696F6E2861297B76617220623D66756E6374696F6E28297B696628612626612E666E2626612E666E2E73656C656374322626612E666E2E73656C656374322E616D642976617220623D612E666E2E73656C656374322E616D64';
wwv_flow_api.g_varchar2_table(4) := '3B76617220623B72657475726E2066756E6374696F6E28297B69662821627C7C21622E726571756972656A73297B623F633D623A623D7B7D3B76617220612C632C643B2166756E6374696F6E2862297B66756E6374696F6E206528612C62297B72657475';
wwv_flow_api.g_varchar2_table(5) := '726E20752E63616C6C28612C62297D66756E6374696F6E206628612C62297B76617220632C642C652C662C672C682C692C6A2C6B2C6C2C6D2C6E3D622626622E73706C697428222F22292C6F3D732E6D61702C703D6F26266F5B222A225D7C7C7B7D3B69';
wwv_flow_api.g_varchar2_table(6) := '6628612626222E223D3D3D612E6368617241742830292969662862297B666F7228613D612E73706C697428222F22292C673D612E6C656E6774682D312C732E6E6F64654964436F6D7061742626772E7465737428615B675D29262628615B675D3D615B67';
wwv_flow_api.g_varchar2_table(7) := '5D2E7265706C61636528772C222229292C613D6E2E736C69636528302C6E2E6C656E6774682D31292E636F6E6361742861292C6B3D303B6B3C612E6C656E6774683B6B2B3D31296966286D3D615B6B5D2C222E223D3D3D6D29612E73706C696365286B2C';
wwv_flow_api.g_varchar2_table(8) := '31292C6B2D3D313B656C736520696628222E2E223D3D3D6D297B696628313D3D3D6B262628222E2E223D3D3D615B325D7C7C222E2E223D3D3D615B305D2929627265616B3B6B3E30262628612E73706C696365286B2D312C32292C6B2D3D32297D613D61';
wwv_flow_api.g_varchar2_table(9) := '2E6A6F696E28222F22297D656C736520303D3D3D612E696E6465784F6628222E2F2229262628613D612E737562737472696E67283229293B696628286E7C7C702926266F297B666F7228633D612E73706C697428222F22292C6B3D632E6C656E6774683B';
wwv_flow_api.g_varchar2_table(10) := '6B3E303B6B2D3D31297B696628643D632E736C69636528302C6B292E6A6F696E28222F22292C6E29666F72286C3D6E2E6C656E6774683B6C3E303B6C2D3D3129696628653D6F5B6E2E736C69636528302C6C292E6A6F696E28222F22295D2C6526262865';
wwv_flow_api.g_varchar2_table(11) := '3D655B645D29297B663D652C683D6B3B627265616B7D6966286629627265616B3B21692626702626705B645D262628693D705B645D2C6A3D6B297D2166262669262628663D692C683D6A292C66262628632E73706C69636528302C682C66292C613D632E';
wwv_flow_api.g_varchar2_table(12) := '6A6F696E28222F2229297D72657475726E20617D66756E6374696F6E206728612C63297B72657475726E2066756E6374696F6E28297B76617220643D762E63616C6C28617267756D656E74732C30293B72657475726E22737472696E6722213D74797065';
wwv_flow_api.g_varchar2_table(13) := '6F6620645B305D2626313D3D3D642E6C656E6774682626642E70757368286E756C6C292C6E2E6170706C7928622C642E636F6E636174285B612C635D29297D7D66756E6374696F6E20682861297B72657475726E2066756E6374696F6E2862297B726574';
wwv_flow_api.g_varchar2_table(14) := '75726E206628622C61297D7D66756E6374696F6E20692861297B72657475726E2066756E6374696F6E2862297B715B615D3D627D7D66756E6374696F6E206A2861297B6966286528722C6129297B76617220633D725B615D3B64656C65746520725B615D';
wwv_flow_api.g_varchar2_table(15) := '2C745B615D3D21302C6D2E6170706C7928622C63297D696628216528712C61292626216528742C6129297468726F77206E6577204572726F7228224E6F20222B61293B72657475726E20715B615D7D66756E6374696F6E206B2861297B76617220622C63';
wwv_flow_api.g_varchar2_table(16) := '3D613F612E696E6465784F6628222122293A2D313B72657475726E20633E2D31262628623D612E737562737472696E6728302C63292C613D612E737562737472696E6728632B312C612E6C656E67746829292C5B622C615D7D66756E6374696F6E206C28';
wwv_flow_api.g_varchar2_table(17) := '61297B72657475726E2066756E6374696F6E28297B72657475726E20732626732E636F6E6669672626732E636F6E6669675B615D7C7C7B7D7D7D766172206D2C6E2C6F2C702C713D7B7D2C723D7B7D2C733D7B7D2C743D7B7D2C753D4F626A6563742E70';
wwv_flow_api.g_varchar2_table(18) := '726F746F747970652E6861734F776E50726F70657274792C763D5B5D2E736C6963652C773D2F5C2E6A73242F3B6F3D66756E6374696F6E28612C62297B76617220632C643D6B2861292C653D645B305D3B72657475726E20613D645B315D2C6526262865';
wwv_flow_api.g_varchar2_table(19) := '3D6628652C62292C633D6A286529292C653F613D632626632E6E6F726D616C697A653F632E6E6F726D616C697A6528612C68286229293A6628612C62293A28613D6628612C62292C643D6B2861292C653D645B305D2C613D645B315D2C65262628633D6A';
wwv_flow_api.g_varchar2_table(20) := '28652929292C7B663A653F652B2221222B613A612C6E3A612C70723A652C703A637D7D2C703D7B726571756972653A66756E6374696F6E2861297B72657475726E20672861297D2C6578706F7274733A66756E6374696F6E2861297B76617220623D715B';
wwv_flow_api.g_varchar2_table(21) := '615D3B72657475726E22756E646566696E656422213D747970656F6620623F623A715B615D3D7B7D7D2C6D6F64756C653A66756E6374696F6E2861297B72657475726E7B69643A612C7572693A22222C6578706F7274733A715B615D2C636F6E6669673A';
wwv_flow_api.g_varchar2_table(22) := '6C2861297D7D7D2C6D3D66756E6374696F6E28612C632C642C66297B76617220682C6B2C6C2C6D2C6E2C732C753D5B5D2C763D747970656F6620643B696628663D667C7C612C22756E646566696E6564223D3D3D767C7C2266756E6374696F6E223D3D3D';
wwv_flow_api.g_varchar2_table(23) := '76297B666F7228633D21632E6C656E6774682626642E6C656E6774683F5B2272657175697265222C226578706F727473222C226D6F64756C65225D3A632C6E3D303B6E3C632E6C656E6774683B6E2B3D31296966286D3D6F28635B6E5D2C66292C6B3D6D';
wwv_flow_api.g_varchar2_table(24) := '2E662C2272657175697265223D3D3D6B29755B6E5D3D702E726571756972652861293B656C736520696628226578706F727473223D3D3D6B29755B6E5D3D702E6578706F7274732861292C733D21303B656C736520696628226D6F64756C65223D3D3D6B';
wwv_flow_api.g_varchar2_table(25) := '29683D755B6E5D3D702E6D6F64756C652861293B656C7365206966286528712C6B297C7C6528722C6B297C7C6528742C6B2929755B6E5D3D6A286B293B656C73657B696628216D2E70297468726F77206E6577204572726F7228612B22206D697373696E';
wwv_flow_api.g_varchar2_table(26) := '6720222B6B293B6D2E702E6C6F6164286D2E6E2C6728662C2130292C69286B292C7B7D292C755B6E5D3D715B6B5D7D6C3D643F642E6170706C7928715B615D2C75293A766F696420302C61262628682626682E6578706F727473213D3D622626682E6578';
wwv_flow_api.g_varchar2_table(27) := '706F727473213D3D715B615D3F715B615D3D682E6578706F7274733A6C3D3D3D622626737C7C28715B615D3D6C29297D656C73652061262628715B615D3D64297D2C613D633D6E3D66756E6374696F6E28612C632C642C652C66297B6966282273747269';
wwv_flow_api.g_varchar2_table(28) := '6E67223D3D747970656F6620612972657475726E20705B615D3F705B615D2863293A6A286F28612C63292E66293B69662821612E73706C696365297B696628733D612C732E6465707326266E28732E646570732C732E63616C6C6261636B292C21632972';
wwv_flow_api.g_varchar2_table(29) := '657475726E3B632E73706C6963653F28613D632C633D642C643D6E756C6C293A613D627D72657475726E20633D637C7C66756E6374696F6E28297B7D2C2266756E6374696F6E223D3D747970656F662064262628643D652C653D66292C653F6D28622C61';
wwv_flow_api.g_varchar2_table(30) := '2C632C64293A73657454696D656F75742866756E6374696F6E28297B6D28622C612C632C64297D2C34292C6E7D2C6E2E636F6E6669673D66756E6374696F6E2861297B72657475726E206E2861297D2C612E5F646566696E65643D712C643D66756E6374';
wwv_flow_api.g_varchar2_table(31) := '696F6E28612C622C63297B69662822737472696E6722213D747970656F662061297468726F77206E6577204572726F72282253656520616C6D6F6E6420524541444D453A20696E636F7272656374206D6F64756C65206275696C642C206E6F206D6F6475';
wwv_flow_api.g_varchar2_table(32) := '6C65206E616D6522293B622E73706C6963657C7C28633D622C623D5B5D292C6528712C61297C7C6528722C61297C7C28725B615D3D5B612C622C635D297D2C642E616D643D7B6A51756572793A21307D7D28292C622E726571756972656A733D612C622E';
wwv_flow_api.g_varchar2_table(33) := '726571756972653D632C622E646566696E653D647D7D28292C622E646566696E652822616C6D6F6E64222C66756E6374696F6E28297B7D292C622E646566696E6528226A7175657279222C5B5D2C66756E6374696F6E28297B76617220623D617C7C243B';
wwv_flow_api.g_varchar2_table(34) := '72657475726E206E756C6C3D3D622626636F6E736F6C652626636F6E736F6C652E6572726F722626636F6E736F6C652E6572726F72282253656C656374323A20416E20696E7374616E6365206F66206A5175657279206F722061206A51756572792D636F';
wwv_flow_api.g_varchar2_table(35) := '6D70617469626C65206C69627261727920776173206E6F7420666F756E642E204D616B652073757265207468617420796F752061726520696E636C7564696E67206A5175657279206265666F72652053656C65637432206F6E20796F7572207765622070';
wwv_flow_api.g_varchar2_table(36) := '6167652E22292C627D292C622E646566696E65282273656C656374322F7574696C73222C5B226A7175657279225D2C66756E6374696F6E2861297B66756E6374696F6E20622861297B76617220623D612E70726F746F747970652C633D5B5D3B666F7228';
wwv_flow_api.g_varchar2_table(37) := '766172206420696E2062297B76617220653D625B645D3B2266756E6374696F6E223D3D747970656F662065262622636F6E7374727563746F7222213D3D642626632E707573682864297D72657475726E20637D76617220633D7B7D3B632E457874656E64';
wwv_flow_api.g_varchar2_table(38) := '3D66756E6374696F6E28612C62297B66756E6374696F6E206328297B746869732E636F6E7374727563746F723D617D76617220643D7B7D2E6861734F776E50726F70657274793B666F7228766172206520696E206229642E63616C6C28622C6529262628';
wwv_flow_api.g_varchar2_table(39) := '615B655D3D625B655D293B72657475726E20632E70726F746F747970653D622E70726F746F747970652C612E70726F746F747970653D6E657720632C612E5F5F73757065725F5F3D622E70726F746F747970652C617D2C632E4465636F726174653D6675';
wwv_flow_api.g_varchar2_table(40) := '6E6374696F6E28612C63297B66756E6374696F6E206428297B76617220623D41727261792E70726F746F747970652E756E73686966742C643D632E70726F746F747970652E636F6E7374727563746F722E6C656E6774682C653D612E70726F746F747970';
wwv_flow_api.g_varchar2_table(41) := '652E636F6E7374727563746F723B643E30262628622E63616C6C28617267756D656E74732C612E70726F746F747970652E636F6E7374727563746F72292C653D632E70726F746F747970652E636F6E7374727563746F72292C652E6170706C7928746869';
wwv_flow_api.g_varchar2_table(42) := '732C617267756D656E7473297D66756E6374696F6E206528297B746869732E636F6E7374727563746F723D647D76617220663D622863292C673D622861293B632E646973706C61794E616D653D612E646973706C61794E616D652C642E70726F746F7479';
wwv_flow_api.g_varchar2_table(43) := '70653D6E657720653B666F722876617220683D303B683C672E6C656E6774683B682B2B297B76617220693D675B685D3B642E70726F746F747970655B695D3D612E70726F746F747970655B695D7D666F7228766172206A3D2866756E6374696F6E286129';
wwv_flow_api.g_varchar2_table(44) := '7B76617220623D66756E6374696F6E28297B7D3B6120696E20642E70726F746F74797065262628623D642E70726F746F747970655B615D293B76617220653D632E70726F746F747970655B615D3B72657475726E2066756E6374696F6E28297B76617220';
wwv_flow_api.g_varchar2_table(45) := '613D41727261792E70726F746F747970652E756E73686966743B72657475726E20612E63616C6C28617267756D656E74732C62292C652E6170706C7928746869732C617267756D656E7473297D7D292C6B3D303B6B3C662E6C656E6774683B6B2B2B297B';
wwv_flow_api.g_varchar2_table(46) := '766172206C3D665B6B5D3B642E70726F746F747970655B6C5D3D6A286C297D72657475726E20647D3B76617220643D66756E6374696F6E28297B746869732E6C697374656E6572733D7B7D7D3B72657475726E20642E70726F746F747970652E6F6E3D66';
wwv_flow_api.g_varchar2_table(47) := '756E6374696F6E28612C62297B746869732E6C697374656E6572733D746869732E6C697374656E6572737C7C7B7D2C6120696E20746869732E6C697374656E6572733F746869732E6C697374656E6572735B615D2E707573682862293A746869732E6C69';
wwv_flow_api.g_varchar2_table(48) := '7374656E6572735B615D3D5B625D7D2C642E70726F746F747970652E747269676765723D66756E6374696F6E2861297B76617220623D41727261792E70726F746F747970652E736C6963652C633D622E63616C6C28617267756D656E74732C31293B7468';
wwv_flow_api.g_varchar2_table(49) := '69732E6C697374656E6572733D746869732E6C697374656E6572737C7C7B7D2C6E756C6C3D3D63262628633D5B5D292C303D3D3D632E6C656E6774682626632E70757368287B7D292C635B305D2E5F747970653D612C6120696E20746869732E6C697374';
wwv_flow_api.g_varchar2_table(50) := '656E6572732626746869732E696E766F6B6528746869732E6C697374656E6572735B615D2C622E63616C6C28617267756D656E74732C3129292C222A22696E20746869732E6C697374656E6572732626746869732E696E766F6B6528746869732E6C6973';
wwv_flow_api.g_varchar2_table(51) := '74656E6572735B222A225D2C617267756D656E7473297D2C642E70726F746F747970652E696E766F6B653D66756E6374696F6E28612C62297B666F722876617220633D302C643D612E6C656E6774683B643E633B632B2B29615B635D2E6170706C792874';
wwv_flow_api.g_varchar2_table(52) := '6869732C62297D2C632E4F627365727661626C653D642C632E67656E657261746543686172733D66756E6374696F6E2861297B666F722876617220623D22222C633D303B613E633B632B2B297B76617220643D4D6174682E666C6F6F722833362A4D6174';
wwv_flow_api.g_varchar2_table(53) := '682E72616E646F6D2829293B622B3D642E746F537472696E67283336297D72657475726E20627D2C632E62696E643D66756E6374696F6E28612C62297B72657475726E2066756E6374696F6E28297B612E6170706C7928622C617267756D656E7473297D';
wwv_flow_api.g_varchar2_table(54) := '7D2C632E5F636F6E76657274446174613D66756E6374696F6E2861297B666F7228766172206220696E2061297B76617220633D622E73706C697428222D22292C643D613B69662831213D3D632E6C656E677468297B666F722876617220653D303B653C63';
wwv_flow_api.g_varchar2_table(55) := '2E6C656E6774683B652B2B297B76617220663D635B655D3B663D662E737562737472696E6728302C31292E746F4C6F7765724361736528292B662E737562737472696E672831292C6620696E20647C7C28645B665D3D7B7D292C653D3D632E6C656E6774';
wwv_flow_api.g_varchar2_table(56) := '682D31262628645B665D3D615B625D292C643D645B665D7D64656C65746520615B625D7D7D72657475726E20617D2C632E6861735363726F6C6C3D66756E6374696F6E28622C63297B76617220643D612863292C653D632E7374796C652E6F766572666C';
wwv_flow_api.g_varchar2_table(57) := '6F77582C663D632E7374796C652E6F766572666C6F77593B72657475726E2065213D3D667C7C2268696464656E22213D3D6626262276697369626C6522213D3D663F227363726F6C6C223D3D3D657C7C227363726F6C6C223D3D3D663F21303A642E696E';
wwv_flow_api.g_varchar2_table(58) := '6E657248656967687428293C632E7363726F6C6C4865696768747C7C642E696E6E6572576964746828293C632E7363726F6C6C57696474683A21317D2C632E6573636170654D61726B75703D66756E6374696F6E2861297B76617220623D7B225C5C223A';
wwv_flow_api.g_varchar2_table(59) := '22262339323B222C2226223A2226616D703B222C223C223A22266C743B222C223E223A222667743B222C2722273A222671756F743B222C2227223A22262333393B222C222F223A22262334373B227D3B72657475726E22737472696E6722213D74797065';
wwv_flow_api.g_varchar2_table(60) := '6F6620613F613A537472696E672861292E7265706C616365282F5B263C3E22275C2F5C5C5D2F672C66756E6374696F6E2861297B72657475726E20625B615D7D297D2C632E617070656E644D616E793D66756E6374696F6E28622C63297B69662822312E';
wwv_flow_api.g_varchar2_table(61) := '37223D3D3D612E666E2E6A71756572792E73756273747228302C3329297B76617220643D6128293B612E6D617028632C66756E6374696F6E2861297B643D642E6164642861297D292C633D647D622E617070656E642863297D2C637D292C622E64656669';
wwv_flow_api.g_varchar2_table(62) := '6E65282273656C656374322F726573756C7473222C5B226A7175657279222C222E2F7574696C73225D2C66756E6374696F6E28612C62297B66756E6374696F6E206328612C622C64297B746869732E24656C656D656E743D612C746869732E646174613D';
wwv_flow_api.g_varchar2_table(63) := '642C746869732E6F7074696F6E733D622C632E5F5F73757065725F5F2E636F6E7374727563746F722E63616C6C2874686973297D72657475726E20622E457874656E6428632C622E4F627365727661626C65292C632E70726F746F747970652E72656E64';
wwv_flow_api.g_varchar2_table(64) := '65723D66756E6374696F6E28297B76617220623D6128273C756C20636C6173733D2273656C656374322D726573756C74735F5F6F7074696F6E732220726F6C653D2274726565223E3C2F756C3E27293B72657475726E20746869732E6F7074696F6E732E';
wwv_flow_api.g_varchar2_table(65) := '67657428226D756C7469706C6522292626622E617474722822617269612D6D756C746973656C65637461626C65222C227472756522292C746869732E24726573756C74733D622C627D2C632E70726F746F747970652E636C6561723D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(66) := '28297B746869732E24726573756C74732E656D70747928297D2C632E70726F746F747970652E646973706C61794D6573736167653D66756E6374696F6E2862297B76617220633D746869732E6F7074696F6E732E67657428226573636170654D61726B75';
wwv_flow_api.g_varchar2_table(67) := '7022293B746869732E636C65617228292C746869732E686964654C6F6164696E6728293B76617220643D6128273C6C6920726F6C653D22747265656974656D2220617269612D6C6976653D226173736572746976652220636C6173733D2273656C656374';
wwv_flow_api.g_varchar2_table(68) := '322D726573756C74735F5F6F7074696F6E223E3C2F6C693E27292C653D746869732E6F7074696F6E732E67657428227472616E736C6174696F6E7322292E67657428622E6D657373616765293B642E617070656E642863286528622E617267732929292C';
wwv_flow_api.g_varchar2_table(69) := '645B305D2E636C6173734E616D652B3D222073656C656374322D726573756C74735F5F6D657373616765222C746869732E24726573756C74732E617070656E642864297D2C632E70726F746F747970652E686964654D657373616765733D66756E637469';
wwv_flow_api.g_varchar2_table(70) := '6F6E28297B746869732E24726573756C74732E66696E6428222E73656C656374322D726573756C74735F5F6D65737361676522292E72656D6F766528297D2C632E70726F746F747970652E617070656E643D66756E6374696F6E2861297B746869732E68';
wwv_flow_api.g_varchar2_table(71) := '6964654C6F6164696E6728293B76617220623D5B5D3B6966286E756C6C3D3D612E726573756C74737C7C303D3D3D612E726573756C74732E6C656E6774682972657475726E20766F696428303D3D3D746869732E24726573756C74732E6368696C647265';
wwv_flow_api.g_varchar2_table(72) := '6E28292E6C656E6774682626746869732E747269676765722822726573756C74733A6D657373616765222C7B6D6573736167653A226E6F526573756C7473227D29293B612E726573756C74733D746869732E736F727428612E726573756C7473293B666F';
wwv_flow_api.g_varchar2_table(73) := '722876617220633D303B633C612E726573756C74732E6C656E6774683B632B2B297B76617220643D612E726573756C74735B635D2C653D746869732E6F7074696F6E2864293B622E707573682865297D746869732E24726573756C74732E617070656E64';
wwv_flow_api.g_varchar2_table(74) := '2862297D2C632E70726F746F747970652E706F736974696F6E3D66756E6374696F6E28612C62297B76617220633D622E66696E6428222E73656C656374322D726573756C747322293B632E617070656E642861297D2C632E70726F746F747970652E736F';
wwv_flow_api.g_varchar2_table(75) := '72743D66756E6374696F6E2861297B76617220623D746869732E6F7074696F6E732E6765742822736F7274657222293B72657475726E20622861297D2C632E70726F746F747970652E686967686C6967687446697273744974656D3D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(76) := '28297B76617220613D746869732E24726573756C74732E66696E6428222E73656C656374322D726573756C74735F5F6F7074696F6E5B617269612D73656C65637465645D22292C623D612E66696C74657228225B617269612D73656C65637465643D7472';
wwv_flow_api.g_varchar2_table(77) := '75655D22293B622E6C656E6774683E303F622E666972737428292E7472696767657228226D6F757365656E74657222293A612E666972737428292E7472696767657228226D6F757365656E74657222292C746869732E656E73757265486967686C696768';
wwv_flow_api.g_varchar2_table(78) := '7456697369626C6528297D2C632E70726F746F747970652E736574436C61737365733D66756E6374696F6E28297B76617220623D746869733B746869732E646174612E63757272656E742866756E6374696F6E2863297B76617220643D612E6D61702863';
wwv_flow_api.g_varchar2_table(79) := '2C66756E6374696F6E2861297B72657475726E20612E69642E746F537472696E6728297D292C653D622E24726573756C74732E66696E6428222E73656C656374322D726573756C74735F5F6F7074696F6E5B617269612D73656C65637465645D22293B65';
wwv_flow_api.g_varchar2_table(80) := '2E656163682866756E6374696F6E28297B76617220623D612874686973292C633D612E6461746128746869732C226461746122292C653D22222B632E69643B6E756C6C213D632E656C656D656E742626632E656C656D656E742E73656C65637465647C7C';
wwv_flow_api.g_varchar2_table(81) := '6E756C6C3D3D632E656C656D656E742626612E696E417272617928652C64293E2D313F622E617474722822617269612D73656C6563746564222C227472756522293A622E617474722822617269612D73656C6563746564222C2266616C736522297D297D';
wwv_flow_api.g_varchar2_table(82) := '297D2C632E70726F746F747970652E73686F774C6F6164696E673D66756E6374696F6E2861297B746869732E686964654C6F6164696E6728293B76617220623D746869732E6F7074696F6E732E67657428227472616E736C6174696F6E7322292E676574';
wwv_flow_api.g_varchar2_table(83) := '2822736561726368696E6722292C633D7B64697361626C65643A21302C6C6F6164696E673A21302C746578743A622861297D2C643D746869732E6F7074696F6E2863293B642E636C6173734E616D652B3D22206C6F6164696E672D726573756C7473222C';
wwv_flow_api.g_varchar2_table(84) := '746869732E24726573756C74732E70726570656E642864297D2C632E70726F746F747970652E686964654C6F6164696E673D66756E6374696F6E28297B746869732E24726573756C74732E66696E6428222E6C6F6164696E672D726573756C747322292E';
wwv_flow_api.g_varchar2_table(85) := '72656D6F766528297D2C632E70726F746F747970652E6F7074696F6E3D66756E6374696F6E2862297B76617220633D646F63756D656E742E637265617465456C656D656E7428226C6922293B632E636C6173734E616D653D2273656C656374322D726573';
wwv_flow_api.g_varchar2_table(86) := '756C74735F5F6F7074696F6E223B76617220643D7B726F6C653A22747265656974656D222C22617269612D73656C6563746564223A2266616C7365227D3B622E64697361626C656426262864656C65746520645B22617269612D73656C6563746564225D';
wwv_flow_api.g_varchar2_table(87) := '2C645B22617269612D64697361626C6564225D3D227472756522292C6E756C6C3D3D622E6964262664656C65746520645B22617269612D73656C6563746564225D2C6E756C6C213D622E5F726573756C744964262628632E69643D622E5F726573756C74';
wwv_flow_api.g_varchar2_table(88) := '4964292C622E7469746C65262628632E7469746C653D622E7469746C65292C622E6368696C6472656E262628642E726F6C653D2267726F7570222C645B22617269612D6C6162656C225D3D622E746578742C64656C65746520645B22617269612D73656C';
wwv_flow_api.g_varchar2_table(89) := '6563746564225D293B666F7228766172206520696E2064297B76617220663D645B655D3B632E73657441747472696275746528652C66297D696628622E6368696C6472656E297B76617220673D612863292C683D646F63756D656E742E63726561746545';
wwv_flow_api.g_varchar2_table(90) := '6C656D656E7428227374726F6E6722293B682E636C6173734E616D653D2273656C656374322D726573756C74735F5F67726F7570223B612868293B746869732E74656D706C61746528622C68293B666F722876617220693D5B5D2C6A3D303B6A3C622E63';
wwv_flow_api.g_varchar2_table(91) := '68696C6472656E2E6C656E6774683B6A2B2B297B766172206B3D622E6368696C6472656E5B6A5D2C6C3D746869732E6F7074696F6E286B293B692E70757368286C297D766172206D3D6128223C756C3E3C2F756C3E222C7B22636C617373223A2273656C';
wwv_flow_api.g_varchar2_table(92) := '656374322D726573756C74735F5F6F7074696F6E732073656C656374322D726573756C74735F5F6F7074696F6E732D2D6E6573746564227D293B6D2E617070656E642869292C672E617070656E642868292C672E617070656E64286D297D656C73652074';
wwv_flow_api.g_varchar2_table(93) := '6869732E74656D706C61746528622C63293B72657475726E20612E6461746128632C2264617461222C62292C637D2C632E70726F746F747970652E62696E643D66756E6374696F6E28622C63297B76617220643D746869732C653D622E69642B222D7265';
wwv_flow_api.g_varchar2_table(94) := '73756C7473223B746869732E24726573756C74732E6174747228226964222C65292C622E6F6E2822726573756C74733A616C6C222C66756E6374696F6E2861297B642E636C65617228292C642E617070656E6428612E64617461292C622E69734F70656E';
wwv_flow_api.g_varchar2_table(95) := '2829262628642E736574436C617373657328292C642E686967686C6967687446697273744974656D2829297D292C622E6F6E2822726573756C74733A617070656E64222C66756E6374696F6E2861297B642E617070656E6428612E64617461292C622E69';
wwv_flow_api.g_varchar2_table(96) := '734F70656E28292626642E736574436C617373657328297D292C622E6F6E28227175657279222C66756E6374696F6E2861297B642E686964654D6573736167657328292C642E73686F774C6F6164696E672861297D292C622E6F6E282273656C65637422';
wwv_flow_api.g_varchar2_table(97) := '2C66756E6374696F6E28297B622E69734F70656E2829262628642E736574436C617373657328292C642E686967686C6967687446697273744974656D2829297D292C622E6F6E2822756E73656C656374222C66756E6374696F6E28297B622E69734F7065';
wwv_flow_api.g_varchar2_table(98) := '6E2829262628642E736574436C617373657328292C642E686967686C6967687446697273744974656D2829297D292C622E6F6E28226F70656E222C66756E6374696F6E28297B642E24726573756C74732E617474722822617269612D657870616E646564';
wwv_flow_api.g_varchar2_table(99) := '222C227472756522292C642E24726573756C74732E617474722822617269612D68696464656E222C2266616C736522292C642E736574436C617373657328292C642E656E73757265486967686C6967687456697369626C6528297D292C622E6F6E282263';
wwv_flow_api.g_varchar2_table(100) := '6C6F7365222C66756E6374696F6E28297B642E24726573756C74732E617474722822617269612D657870616E646564222C2266616C736522292C642E24726573756C74732E617474722822617269612D68696464656E222C227472756522292C642E2472';
wwv_flow_api.g_varchar2_table(101) := '6573756C74732E72656D6F7665417474722822617269612D61637469766564657363656E64616E7422297D292C622E6F6E2822726573756C74733A746F67676C65222C66756E6374696F6E28297B76617220613D642E676574486967686C696768746564';
wwv_flow_api.g_varchar2_table(102) := '526573756C747328293B30213D3D612E6C656E6774682626612E7472696767657228226D6F757365757022297D292C622E6F6E2822726573756C74733A73656C656374222C66756E6374696F6E28297B76617220613D642E676574486967686C69676874';
wwv_flow_api.g_varchar2_table(103) := '6564526573756C747328293B69662830213D3D612E6C656E677468297B76617220623D612E6461746128226461746122293B2274727565223D3D612E617474722822617269612D73656C656374656422293F642E747269676765722822636C6F7365222C';
wwv_flow_api.g_varchar2_table(104) := '7B7D293A642E74726967676572282273656C656374222C7B646174613A627D297D7D292C622E6F6E2822726573756C74733A70726576696F7573222C66756E6374696F6E28297B76617220613D642E676574486967686C696768746564526573756C7473';
wwv_flow_api.g_varchar2_table(105) := '28292C623D642E24726573756C74732E66696E6428225B617269612D73656C65637465645D22292C633D622E696E6465782861293B69662830213D3D63297B76617220653D632D313B303D3D3D612E6C656E677468262628653D30293B76617220663D62';
wwv_flow_api.g_varchar2_table(106) := '2E65712865293B662E7472696767657228226D6F757365656E74657222293B76617220673D642E24726573756C74732E6F666673657428292E746F702C683D662E6F666673657428292E746F702C693D642E24726573756C74732E7363726F6C6C546F70';
wwv_flow_api.g_varchar2_table(107) := '28292B28682D67293B303D3D3D653F642E24726573756C74732E7363726F6C6C546F702830293A303E682D672626642E24726573756C74732E7363726F6C6C546F702869297D7D292C622E6F6E2822726573756C74733A6E657874222C66756E6374696F';
wwv_flow_api.g_varchar2_table(108) := '6E28297B76617220613D642E676574486967686C696768746564526573756C747328292C623D642E24726573756C74732E66696E6428225B617269612D73656C65637465645D22292C633D622E696E6465782861292C653D632B313B6966282128653E3D';
wwv_flow_api.g_varchar2_table(109) := '622E6C656E67746829297B76617220663D622E65712865293B662E7472696767657228226D6F757365656E74657222293B76617220673D642E24726573756C74732E6F666673657428292E746F702B642E24726573756C74732E6F757465724865696768';
wwv_flow_api.g_varchar2_table(110) := '74282131292C683D662E6F666673657428292E746F702B662E6F75746572486569676874282131292C693D642E24726573756C74732E7363726F6C6C546F7028292B682D673B303D3D3D653F642E24726573756C74732E7363726F6C6C546F702830293A';
wwv_flow_api.g_varchar2_table(111) := '683E672626642E24726573756C74732E7363726F6C6C546F702869297D7D292C622E6F6E2822726573756C74733A666F637573222C66756E6374696F6E2861297B612E656C656D656E742E616464436C617373282273656C656374322D726573756C7473';
wwv_flow_api.g_varchar2_table(112) := '5F5F6F7074696F6E2D2D686967686C69676874656422297D292C622E6F6E2822726573756C74733A6D657373616765222C66756E6374696F6E2861297B642E646973706C61794D6573736167652861297D292C612E666E2E6D6F757365776865656C2626';
wwv_flow_api.g_varchar2_table(113) := '746869732E24726573756C74732E6F6E28226D6F757365776865656C222C66756E6374696F6E2861297B76617220623D642E24726573756C74732E7363726F6C6C546F7028292C633D642E24726573756C74732E6765742830292E7363726F6C6C486569';
wwv_flow_api.g_varchar2_table(114) := '6768742D622B612E64656C7461592C653D612E64656C7461593E302626622D612E64656C7461593C3D302C663D612E64656C7461593C302626633C3D642E24726573756C74732E68656967687428293B653F28642E24726573756C74732E7363726F6C6C';
wwv_flow_api.g_varchar2_table(115) := '546F702830292C612E70726576656E7444656661756C7428292C612E73746F7050726F7061676174696F6E2829293A66262628642E24726573756C74732E7363726F6C6C546F7028642E24726573756C74732E6765742830292E7363726F6C6C48656967';
wwv_flow_api.g_varchar2_table(116) := '68742D642E24726573756C74732E6865696768742829292C612E70726576656E7444656661756C7428292C612E73746F7050726F7061676174696F6E2829297D292C746869732E24726573756C74732E6F6E28226D6F7573657570222C222E73656C6563';
wwv_flow_api.g_varchar2_table(117) := '74322D726573756C74735F5F6F7074696F6E5B617269612D73656C65637465645D222C66756E6374696F6E2862297B76617220633D612874686973292C653D632E6461746128226461746122293B72657475726E2274727565223D3D3D632E6174747228';
wwv_flow_api.g_varchar2_table(118) := '22617269612D73656C656374656422293F766F696428642E6F7074696F6E732E67657428226D756C7469706C6522293F642E747269676765722822756E73656C656374222C7B6F726967696E616C4576656E743A622C646174613A657D293A642E747269';
wwv_flow_api.g_varchar2_table(119) := '676765722822636C6F7365222C7B7D29293A766F696420642E74726967676572282273656C656374222C7B6F726967696E616C4576656E743A622C646174613A657D297D292C746869732E24726573756C74732E6F6E28226D6F757365656E746572222C';
wwv_flow_api.g_varchar2_table(120) := '222E73656C656374322D726573756C74735F5F6F7074696F6E5B617269612D73656C65637465645D222C66756E6374696F6E2862297B76617220633D612874686973292E6461746128226461746122293B642E676574486967686C696768746564526573';
wwv_flow_api.g_varchar2_table(121) := '756C747328292E72656D6F7665436C617373282273656C656374322D726573756C74735F5F6F7074696F6E2D2D686967686C69676874656422292C642E747269676765722822726573756C74733A666F637573222C7B646174613A632C656C656D656E74';
wwv_flow_api.g_varchar2_table(122) := '3A612874686973297D297D297D2C632E70726F746F747970652E676574486967686C696768746564526573756C74733D66756E6374696F6E28297B76617220613D746869732E24726573756C74732E66696E6428222E73656C656374322D726573756C74';
wwv_flow_api.g_varchar2_table(123) := '735F5F6F7074696F6E2D2D686967686C69676874656422293B72657475726E20617D2C632E70726F746F747970652E64657374726F793D66756E6374696F6E28297B746869732E24726573756C74732E72656D6F766528297D2C632E70726F746F747970';
wwv_flow_api.g_varchar2_table(124) := '652E656E73757265486967686C6967687456697369626C653D66756E6374696F6E28297B76617220613D746869732E676574486967686C696768746564526573756C747328293B69662830213D3D612E6C656E677468297B76617220623D746869732E24';
wwv_flow_api.g_varchar2_table(125) := '726573756C74732E66696E6428225B617269612D73656C65637465645D22292C633D622E696E6465782861292C643D746869732E24726573756C74732E6F666673657428292E746F702C653D612E6F666673657428292E746F702C663D746869732E2472';
wwv_flow_api.g_varchar2_table(126) := '6573756C74732E7363726F6C6C546F7028292B28652D64292C673D652D643B662D3D322A612E6F75746572486569676874282131292C323E3D633F746869732E24726573756C74732E7363726F6C6C546F702830293A28673E746869732E24726573756C';
wwv_flow_api.g_varchar2_table(127) := '74732E6F7574657248656967687428297C7C303E67292626746869732E24726573756C74732E7363726F6C6C546F702866297D7D2C632E70726F746F747970652E74656D706C6174653D66756E6374696F6E28622C63297B76617220643D746869732E6F';
wwv_flow_api.g_varchar2_table(128) := '7074696F6E732E676574282274656D706C617465526573756C7422292C653D746869732E6F7074696F6E732E67657428226573636170654D61726B757022292C663D6428622C63293B6E756C6C3D3D663F632E7374796C652E646973706C61793D226E6F';
wwv_flow_api.g_varchar2_table(129) := '6E65223A22737472696E67223D3D747970656F6620663F632E696E6E657248544D4C3D652866293A612863292E617070656E642866297D2C637D292C622E646566696E65282273656C656374322F6B657973222C5B5D2C66756E6374696F6E28297B7661';
wwv_flow_api.g_varchar2_table(130) := '7220613D7B4241434B53504143453A382C5441423A392C454E5445523A31332C53484946543A31362C4354524C3A31372C414C543A31382C4553433A32372C53504143453A33322C504147455F55503A33332C504147455F444F574E3A33342C454E443A';
wwv_flow_api.g_varchar2_table(131) := '33352C484F4D453A33362C4C4546543A33372C55503A33382C52494748543A33392C444F574E3A34302C44454C4554453A34367D3B72657475726E20617D292C622E646566696E65282273656C656374322F73656C656374696F6E2F62617365222C5B22';
wwv_flow_api.g_varchar2_table(132) := '6A7175657279222C222E2E2F7574696C73222C222E2E2F6B657973225D2C66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C62297B746869732E24656C656D656E743D612C746869732E6F7074696F6E733D622C642E5F5F737570';
wwv_flow_api.g_varchar2_table(133) := '65725F5F2E636F6E7374727563746F722E63616C6C2874686973297D72657475726E20622E457874656E6428642C622E4F627365727661626C65292C642E70726F746F747970652E72656E6465723D66756E6374696F6E28297B76617220623D6128273C';
wwv_flow_api.g_varchar2_table(134) := '7370616E20636C6173733D2273656C656374322D73656C656374696F6E2220726F6C653D22636F6D626F626F78222020617269612D686173706F7075703D22747275652220617269612D657870616E6465643D2266616C7365223E3C2F7370616E3E2729';
wwv_flow_api.g_varchar2_table(135) := '3B72657475726E20746869732E5F746162696E6465783D302C6E756C6C213D746869732E24656C656D656E742E6461746128226F6C642D746162696E64657822293F746869732E5F746162696E6465783D746869732E24656C656D656E742E6461746128';
wwv_flow_api.g_varchar2_table(136) := '226F6C642D746162696E64657822293A6E756C6C213D746869732E24656C656D656E742E617474722822746162696E6465782229262628746869732E5F746162696E6465783D746869732E24656C656D656E742E617474722822746162696E6465782229';
wwv_flow_api.g_varchar2_table(137) := '292C622E6174747228227469746C65222C746869732E24656C656D656E742E6174747228227469746C652229292C622E617474722822746162696E646578222C746869732E5F746162696E646578292C746869732E2473656C656374696F6E3D622C627D';
wwv_flow_api.g_varchar2_table(138) := '2C642E70726F746F747970652E62696E643D66756E6374696F6E28612C62297B76617220643D746869732C653D28612E69642B222D636F6E7461696E6572222C612E69642B222D726573756C747322293B746869732E636F6E7461696E65723D612C7468';
wwv_flow_api.g_varchar2_table(139) := '69732E2473656C656374696F6E2E6F6E2822666F637573222C66756E6374696F6E2861297B642E747269676765722822666F637573222C61297D292C746869732E2473656C656374696F6E2E6F6E2822626C7572222C66756E6374696F6E2861297B642E';
wwv_flow_api.g_varchar2_table(140) := '5F68616E646C65426C75722861297D292C746869732E2473656C656374696F6E2E6F6E28226B6579646F776E222C66756E6374696F6E2861297B642E7472696767657228226B65797072657373222C61292C612E77686963683D3D3D632E535041434526';
wwv_flow_api.g_varchar2_table(141) := '26612E70726576656E7444656661756C7428297D292C612E6F6E2822726573756C74733A666F637573222C66756E6374696F6E2861297B642E2473656C656374696F6E2E617474722822617269612D61637469766564657363656E64616E74222C612E64';
wwv_flow_api.g_varchar2_table(142) := '6174612E5F726573756C744964297D292C612E6F6E282273656C656374696F6E3A757064617465222C66756E6374696F6E2861297B642E75706461746528612E64617461297D292C612E6F6E28226F70656E222C66756E6374696F6E28297B642E247365';
wwv_flow_api.g_varchar2_table(143) := '6C656374696F6E2E617474722822617269612D657870616E646564222C227472756522292C642E2473656C656374696F6E2E617474722822617269612D6F776E73222C65292C642E5F617474616368436C6F736548616E646C65722861297D292C612E6F';
wwv_flow_api.g_varchar2_table(144) := '6E2822636C6F7365222C66756E6374696F6E28297B642E2473656C656374696F6E2E617474722822617269612D657870616E646564222C2266616C736522292C642E2473656C656374696F6E2E72656D6F7665417474722822617269612D616374697665';
wwv_flow_api.g_varchar2_table(145) := '64657363656E64616E7422292C642E2473656C656374696F6E2E72656D6F7665417474722822617269612D6F776E7322292C642E2473656C656374696F6E2E666F63757328292C642E5F646574616368436C6F736548616E646C65722861297D292C612E';
wwv_flow_api.g_varchar2_table(146) := '6F6E2822656E61626C65222C66756E6374696F6E28297B642E2473656C656374696F6E2E617474722822746162696E646578222C642E5F746162696E646578297D292C612E6F6E282264697361626C65222C66756E6374696F6E28297B642E2473656C65';
wwv_flow_api.g_varchar2_table(147) := '6374696F6E2E617474722822746162696E646578222C222D3122297D297D2C642E70726F746F747970652E5F68616E646C65426C75723D66756E6374696F6E2862297B76617220633D746869733B77696E646F772E73657454696D656F75742866756E63';
wwv_flow_api.g_varchar2_table(148) := '74696F6E28297B646F63756D656E742E616374697665456C656D656E743D3D632E2473656C656374696F6E5B305D7C7C612E636F6E7461696E7328632E2473656C656374696F6E5B305D2C646F63756D656E742E616374697665456C656D656E74297C7C';
wwv_flow_api.g_varchar2_table(149) := '632E747269676765722822626C7572222C62297D2C31297D2C642E70726F746F747970652E5F617474616368436C6F736548616E646C65723D66756E6374696F6E2862297B6128646F63756D656E742E626F6479292E6F6E28226D6F757365646F776E2E';
wwv_flow_api.g_varchar2_table(150) := '73656C656374322E222B622E69642C66756E6374696F6E2862297B76617220633D6128622E746172676574292C643D632E636C6F7365737428222E73656C6563743222292C653D6128222E73656C656374322E73656C656374322D636F6E7461696E6572';
wwv_flow_api.g_varchar2_table(151) := '2D2D6F70656E22293B652E656163682866756E6374696F6E28297B76617220623D612874686973293B69662874686973213D645B305D297B76617220633D622E646174612822656C656D656E7422293B632E73656C656374322822636C6F736522297D7D';
wwv_flow_api.g_varchar2_table(152) := '297D297D2C642E70726F746F747970652E5F646574616368436C6F736548616E646C65723D66756E6374696F6E2862297B6128646F63756D656E742E626F6479292E6F666628226D6F757365646F776E2E73656C656374322E222B622E6964297D2C642E';
wwv_flow_api.g_varchar2_table(153) := '70726F746F747970652E706F736974696F6E3D66756E6374696F6E28612C62297B76617220633D622E66696E6428222E73656C656374696F6E22293B632E617070656E642861297D2C642E70726F746F747970652E64657374726F793D66756E6374696F';
wwv_flow_api.g_varchar2_table(154) := '6E28297B746869732E5F646574616368436C6F736548616E646C657228746869732E636F6E7461696E6572297D2C642E70726F746F747970652E7570646174653D66756E6374696F6E2861297B7468726F77206E6577204572726F722822546865206075';
wwv_flow_api.g_varchar2_table(155) := '706461746560206D6574686F64206D75737420626520646566696E656420696E206368696C6420636C61737365732E22297D2C647D292C622E646566696E65282273656C656374322F73656C656374696F6E2F73696E676C65222C5B226A717565727922';
wwv_flow_api.g_varchar2_table(156) := '2C222E2F62617365222C222E2E2F7574696C73222C222E2E2F6B657973225D2C66756E6374696F6E28612C622C632C64297B66756E6374696F6E206528297B652E5F5F73757065725F5F2E636F6E7374727563746F722E6170706C7928746869732C6172';
wwv_flow_api.g_varchar2_table(157) := '67756D656E7473297D72657475726E20632E457874656E6428652C62292C652E70726F746F747970652E72656E6465723D66756E6374696F6E28297B76617220613D652E5F5F73757065725F5F2E72656E6465722E63616C6C2874686973293B72657475';
wwv_flow_api.g_varchar2_table(158) := '726E20612E616464436C617373282273656C656374322D73656C656374696F6E2D2D73696E676C6522292C612E68746D6C28273C7370616E20636C6173733D2273656C656374322D73656C656374696F6E5F5F72656E6465726564223E3C2F7370616E3E';
wwv_flow_api.g_varchar2_table(159) := '3C7370616E20636C6173733D2273656C656374322D73656C656374696F6E5F5F6172726F772220726F6C653D2270726573656E746174696F6E223E3C6220726F6C653D2270726573656E746174696F6E223E3C2F623E3C2F7370616E3E27292C617D2C65';
wwv_flow_api.g_varchar2_table(160) := '2E70726F746F747970652E62696E643D66756E6374696F6E28612C62297B76617220633D746869733B652E5F5F73757065725F5F2E62696E642E6170706C7928746869732C617267756D656E7473293B76617220643D612E69642B222D636F6E7461696E';
wwv_flow_api.g_varchar2_table(161) := '6572223B746869732E2473656C656374696F6E2E66696E6428222E73656C656374322D73656C656374696F6E5F5F72656E646572656422292E6174747228226964222C64292C746869732E2473656C656374696F6E2E617474722822617269612D6C6162';
wwv_flow_api.g_varchar2_table(162) := '656C6C65646279222C64292C746869732E2473656C656374696F6E2E6F6E28226D6F757365646F776E222C66756E6374696F6E2861297B313D3D3D612E77686963682626632E747269676765722822746F67676C65222C7B6F726967696E616C4576656E';
wwv_flow_api.g_varchar2_table(163) := '743A617D297D292C746869732E2473656C656374696F6E2E6F6E2822666F637573222C66756E6374696F6E2861297B7D292C746869732E2473656C656374696F6E2E6F6E2822626C7572222C66756E6374696F6E2861297B7D292C612E6F6E2822666F63';
wwv_flow_api.g_varchar2_table(164) := '7573222C66756E6374696F6E2862297B612E69734F70656E28297C7C632E2473656C656374696F6E2E666F63757328297D292C612E6F6E282273656C656374696F6E3A757064617465222C66756E6374696F6E2861297B632E75706461746528612E6461';
wwv_flow_api.g_varchar2_table(165) := '7461297D297D2C652E70726F746F747970652E636C6561723D66756E6374696F6E28297B746869732E2473656C656374696F6E2E66696E6428222E73656C656374322D73656C656374696F6E5F5F72656E646572656422292E656D70747928297D2C652E';
wwv_flow_api.g_varchar2_table(166) := '70726F746F747970652E646973706C61793D66756E6374696F6E28612C62297B76617220633D746869732E6F7074696F6E732E676574282274656D706C61746553656C656374696F6E22292C643D746869732E6F7074696F6E732E676574282265736361';
wwv_flow_api.g_varchar2_table(167) := '70654D61726B757022293B72657475726E2064286328612C6229297D2C652E70726F746F747970652E73656C656374696F6E436F6E7461696E65723D66756E6374696F6E28297B72657475726E206128223C7370616E3E3C2F7370616E3E22297D2C652E';
wwv_flow_api.g_varchar2_table(168) := '70726F746F747970652E7570646174653D66756E6374696F6E2861297B696628303D3D3D612E6C656E6774682972657475726E20766F696420746869732E636C65617228293B76617220623D615B305D2C633D746869732E2473656C656374696F6E2E66';
wwv_flow_api.g_varchar2_table(169) := '696E6428222E73656C656374322D73656C656374696F6E5F5F72656E646572656422292C643D746869732E646973706C617928622C63293B632E656D70747928292E617070656E642864292C632E70726F7028227469746C65222C622E7469746C657C7C';
wwv_flow_api.g_varchar2_table(170) := '622E74657874297D2C657D292C622E646566696E65282273656C656374322F73656C656374696F6E2F6D756C7469706C65222C5B226A7175657279222C222E2F62617365222C222E2E2F7574696C73225D2C66756E6374696F6E28612C622C63297B6675';
wwv_flow_api.g_varchar2_table(171) := '6E6374696F6E206428612C62297B642E5F5F73757065725F5F2E636F6E7374727563746F722E6170706C7928746869732C617267756D656E7473297D72657475726E20632E457874656E6428642C62292C642E70726F746F747970652E72656E6465723D';
wwv_flow_api.g_varchar2_table(172) := '66756E6374696F6E28297B76617220613D642E5F5F73757065725F5F2E72656E6465722E63616C6C2874686973293B72657475726E20612E616464436C617373282273656C656374322D73656C656374696F6E2D2D6D756C7469706C6522292C612E6874';
wwv_flow_api.g_varchar2_table(173) := '6D6C28273C756C20636C6173733D2273656C656374322D73656C656374696F6E5F5F72656E6465726564223E3C2F756C3E27292C617D2C642E70726F746F747970652E62696E643D66756E6374696F6E28622C63297B76617220653D746869733B642E5F';
wwv_flow_api.g_varchar2_table(174) := '5F73757065725F5F2E62696E642E6170706C7928746869732C617267756D656E7473292C746869732E2473656C656374696F6E2E6F6E2822636C69636B222C66756E6374696F6E2861297B652E747269676765722822746F67676C65222C7B6F72696769';
wwv_flow_api.g_varchar2_table(175) := '6E616C4576656E743A617D297D292C746869732E2473656C656374696F6E2E6F6E2822636C69636B222C222E73656C656374322D73656C656374696F6E5F5F63686F6963655F5F72656D6F7665222C66756E6374696F6E2862297B69662821652E6F7074';
wwv_flow_api.g_varchar2_table(176) := '696F6E732E676574282264697361626C65642229297B76617220633D612874686973292C643D632E706172656E7428292C663D642E6461746128226461746122293B652E747269676765722822756E73656C656374222C7B6F726967696E616C4576656E';
wwv_flow_api.g_varchar2_table(177) := '743A622C646174613A667D297D7D297D2C642E70726F746F747970652E636C6561723D66756E6374696F6E28297B746869732E2473656C656374696F6E2E66696E6428222E73656C656374322D73656C656374696F6E5F5F72656E646572656422292E65';
wwv_flow_api.g_varchar2_table(178) := '6D70747928297D2C642E70726F746F747970652E646973706C61793D66756E6374696F6E28612C62297B76617220633D746869732E6F7074696F6E732E676574282274656D706C61746553656C656374696F6E22292C643D746869732E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(179) := '2E67657428226573636170654D61726B757022293B72657475726E2064286328612C6229297D2C642E70726F746F747970652E73656C656374696F6E436F6E7461696E65723D66756E6374696F6E28297B76617220623D6128273C6C6920636C6173733D';
wwv_flow_api.g_varchar2_table(180) := '2273656C656374322D73656C656374696F6E5F5F63686F696365223E3C7370616E20636C6173733D2273656C656374322D73656C656374696F6E5F5F63686F6963655F5F72656D6F76652220726F6C653D2270726573656E746174696F6E223E2674696D';
wwv_flow_api.g_varchar2_table(181) := '65733B3C2F7370616E3E3C2F6C693E27293B72657475726E20627D2C642E70726F746F747970652E7570646174653D66756E6374696F6E2861297B696628746869732E636C65617228292C30213D3D612E6C656E677468297B666F722876617220623D5B';
wwv_flow_api.g_varchar2_table(182) := '5D2C643D303B643C612E6C656E6774683B642B2B297B76617220653D615B645D2C663D746869732E73656C656374696F6E436F6E7461696E657228292C673D746869732E646973706C617928652C66293B662E617070656E642867292C662E70726F7028';
wwv_flow_api.g_varchar2_table(183) := '227469746C65222C652E7469746C657C7C652E74657874292C662E64617461282264617461222C65292C622E707573682866297D76617220683D746869732E2473656C656374696F6E2E66696E6428222E73656C656374322D73656C656374696F6E5F5F';
wwv_flow_api.g_varchar2_table(184) := '72656E646572656422293B632E617070656E644D616E7928682C62297D7D2C647D292C622E646566696E65282273656C656374322F73656C656374696F6E2F706C616365686F6C646572222C5B222E2E2F7574696C73225D2C66756E6374696F6E286129';
wwv_flow_api.g_varchar2_table(185) := '7B66756E6374696F6E206228612C622C63297B746869732E706C616365686F6C6465723D746869732E6E6F726D616C697A65506C616365686F6C64657228632E6765742822706C616365686F6C6465722229292C612E63616C6C28746869732C622C6329';
wwv_flow_api.g_varchar2_table(186) := '7D72657475726E20622E70726F746F747970652E6E6F726D616C697A65506C616365686F6C6465723D66756E6374696F6E28612C62297B72657475726E22737472696E67223D3D747970656F662062262628623D7B69643A22222C746578743A627D292C';
wwv_flow_api.g_varchar2_table(187) := '627D2C622E70726F746F747970652E637265617465506C616365686F6C6465723D66756E6374696F6E28612C62297B76617220633D746869732E73656C656374696F6E436F6E7461696E657228293B72657475726E20632E68746D6C28746869732E6469';
wwv_flow_api.g_varchar2_table(188) := '73706C6179286229292C632E616464436C617373282273656C656374322D73656C656374696F6E5F5F706C616365686F6C64657222292E72656D6F7665436C617373282273656C656374322D73656C656374696F6E5F5F63686F69636522292C637D2C62';
wwv_flow_api.g_varchar2_table(189) := '2E70726F746F747970652E7570646174653D66756E6374696F6E28612C62297B76617220633D313D3D622E6C656E6774682626625B305D2E6964213D746869732E706C616365686F6C6465722E69642C643D622E6C656E6774683E313B696628647C7C63';
wwv_flow_api.g_varchar2_table(190) := '2972657475726E20612E63616C6C28746869732C62293B746869732E636C65617228293B76617220653D746869732E637265617465506C616365686F6C64657228746869732E706C616365686F6C646572293B746869732E2473656C656374696F6E2E66';
wwv_flow_api.g_varchar2_table(191) := '696E6428222E73656C656374322D73656C656374696F6E5F5F72656E646572656422292E617070656E642865297D2C627D292C622E646566696E65282273656C656374322F73656C656374696F6E2F616C6C6F77436C656172222C5B226A717565727922';
wwv_flow_api.g_varchar2_table(192) := '2C222E2E2F6B657973225D2C66756E6374696F6E28612C62297B66756E6374696F6E206328297B7D72657475726E20632E70726F746F747970652E62696E643D66756E6374696F6E28612C622C63297B76617220643D746869733B612E63616C6C287468';
wwv_flow_api.g_varchar2_table(193) := '69732C622C63292C6E756C6C3D3D746869732E706C616365686F6C6465722626746869732E6F7074696F6E732E676574282264656275672229262677696E646F772E636F6E736F6C652626636F6E736F6C652E6572726F722626636F6E736F6C652E6572';
wwv_flow_api.g_varchar2_table(194) := '726F72282253656C656374323A205468652060616C6C6F77436C65617260206F7074696F6E2073686F756C64206265207573656420696E20636F6D62696E6174696F6E2077697468207468652060706C616365686F6C64657260206F7074696F6E2E2229';
wwv_flow_api.g_varchar2_table(195) := '2C746869732E2473656C656374696F6E2E6F6E28226D6F757365646F776E222C222E73656C656374322D73656C656374696F6E5F5F636C656172222C66756E6374696F6E2861297B642E5F68616E646C65436C6561722861297D292C622E6F6E28226B65';
wwv_flow_api.g_varchar2_table(196) := '797072657373222C66756E6374696F6E2861297B642E5F68616E646C654B6579626F617264436C65617228612C62297D297D2C632E70726F746F747970652E5F68616E646C65436C6561723D66756E6374696F6E28612C62297B69662821746869732E6F';
wwv_flow_api.g_varchar2_table(197) := '7074696F6E732E676574282264697361626C65642229297B76617220633D746869732E2473656C656374696F6E2E66696E6428222E73656C656374322D73656C656374696F6E5F5F636C65617222293B69662830213D3D632E6C656E677468297B622E73';
wwv_flow_api.g_varchar2_table(198) := '746F7050726F7061676174696F6E28293B666F722876617220643D632E6461746128226461746122292C653D303B653C642E6C656E6774683B652B2B297B76617220663D7B646174613A645B655D7D3B696628746869732E747269676765722822756E73';
wwv_flow_api.g_varchar2_table(199) := '656C656374222C66292C662E70726576656E7465642972657475726E7D746869732E24656C656D656E742E76616C28746869732E706C616365686F6C6465722E6964292E7472696767657228226368616E676522292C746869732E747269676765722822';
wwv_flow_api.g_varchar2_table(200) := '746F67676C65222C7B7D297D7D7D2C632E70726F746F747970652E5F68616E646C654B6579626F617264436C6561723D66756E6374696F6E28612C632C64297B642E69734F70656E28297C7C28632E77686963683D3D622E44454C4554457C7C632E7768';
wwv_flow_api.g_varchar2_table(201) := '6963683D3D622E4241434B5350414345292626746869732E5F68616E646C65436C6561722863297D2C632E70726F746F747970652E7570646174653D66756E6374696F6E28622C63297B696628622E63616C6C28746869732C63292C2128746869732E24';
wwv_flow_api.g_varchar2_table(202) := '73656C656374696F6E2E66696E6428222E73656C656374322D73656C656374696F6E5F5F706C616365686F6C64657222292E6C656E6774683E307C7C303D3D3D632E6C656E67746829297B76617220643D6128273C7370616E20636C6173733D2273656C';
wwv_flow_api.g_varchar2_table(203) := '656374322D73656C656374696F6E5F5F636C656172223E2674696D65733B3C2F7370616E3E27293B642E64617461282264617461222C63292C746869732E2473656C656374696F6E2E66696E6428222E73656C656374322D73656C656374696F6E5F5F72';
wwv_flow_api.g_varchar2_table(204) := '656E646572656422292E70726570656E642864297D7D2C637D292C622E646566696E65282273656C656374322F73656C656374696F6E2F736561726368222C5B226A7175657279222C222E2E2F7574696C73222C222E2E2F6B657973225D2C66756E6374';
wwv_flow_api.g_varchar2_table(205) := '696F6E28612C622C63297B66756E6374696F6E206428612C622C63297B612E63616C6C28746869732C622C63297D72657475726E20642E70726F746F747970652E72656E6465723D66756E6374696F6E2862297B76617220633D6128273C6C6920636C61';
wwv_flow_api.g_varchar2_table(206) := '73733D2273656C656374322D7365617263682073656C656374322D7365617263682D2D696E6C696E65223E3C696E70757420636C6173733D2273656C656374322D7365617263685F5F6669656C642220747970653D227365617263682220746162696E64';
wwv_flow_api.g_varchar2_table(207) := '65783D222D3122206175746F636F6D706C6574653D226F666622206175746F636F72726563743D226F666622206175746F6361706974616C697A653D226F666622207370656C6C636865636B3D2266616C73652220726F6C653D2274657874626F782220';
wwv_flow_api.g_varchar2_table(208) := '617269612D6175746F636F6D706C6574653D226C69737422202F3E3C2F6C693E27293B746869732E24736561726368436F6E7461696E65723D632C746869732E247365617263683D632E66696E642822696E70757422293B76617220643D622E63616C6C';
wwv_flow_api.g_varchar2_table(209) := '2874686973293B72657475726E20746869732E5F7472616E73666572546162496E64657828292C647D2C642E70726F746F747970652E62696E643D66756E6374696F6E28612C622C64297B76617220653D746869733B612E63616C6C28746869732C622C';
wwv_flow_api.g_varchar2_table(210) := '64292C622E6F6E28226F70656E222C66756E6374696F6E28297B652E247365617263682E747269676765722822666F63757322297D292C622E6F6E2822636C6F7365222C66756E6374696F6E28297B652E247365617263682E76616C282222292C652E24';
wwv_flow_api.g_varchar2_table(211) := '7365617263682E72656D6F7665417474722822617269612D61637469766564657363656E64616E7422292C652E247365617263682E747269676765722822666F63757322297D292C622E6F6E2822656E61626C65222C66756E6374696F6E28297B652E24';
wwv_flow_api.g_varchar2_table(212) := '7365617263682E70726F70282264697361626C6564222C2131292C652E5F7472616E73666572546162496E64657828297D292C622E6F6E282264697361626C65222C66756E6374696F6E28297B652E247365617263682E70726F70282264697361626C65';
wwv_flow_api.g_varchar2_table(213) := '64222C2130297D292C622E6F6E2822666F637573222C66756E6374696F6E2861297B652E247365617263682E747269676765722822666F63757322297D292C622E6F6E2822726573756C74733A666F637573222C66756E6374696F6E2861297B652E2473';
wwv_flow_api.g_varchar2_table(214) := '65617263682E617474722822617269612D61637469766564657363656E64616E74222C612E6964297D292C746869732E2473656C656374696F6E2E6F6E2822666F637573696E222C222E73656C656374322D7365617263682D2D696E6C696E65222C6675';
wwv_flow_api.g_varchar2_table(215) := '6E6374696F6E2861297B652E747269676765722822666F637573222C61297D292C746869732E2473656C656374696F6E2E6F6E2822666F6375736F7574222C222E73656C656374322D7365617263682D2D696E6C696E65222C66756E6374696F6E286129';
wwv_flow_api.g_varchar2_table(216) := '7B652E5F68616E646C65426C75722861297D292C746869732E2473656C656374696F6E2E6F6E28226B6579646F776E222C222E73656C656374322D7365617263682D2D696E6C696E65222C66756E6374696F6E2861297B612E73746F7050726F70616761';
wwv_flow_api.g_varchar2_table(217) := '74696F6E28292C652E7472696767657228226B65797072657373222C61292C652E5F6B6579557050726576656E7465643D612E697344656661756C7450726576656E74656428293B76617220623D612E77686963683B696628623D3D3D632E4241434B53';
wwv_flow_api.g_varchar2_table(218) := '50414345262622223D3D3D652E247365617263682E76616C2829297B76617220643D652E24736561726368436F6E7461696E65722E7072657628222E73656C656374322D73656C656374696F6E5F5F63686F69636522293B696628642E6C656E6774683E';
wwv_flow_api.g_varchar2_table(219) := '30297B76617220663D642E6461746128226461746122293B652E73656172636852656D6F766543686F6963652866292C612E70726576656E7444656661756C7428297D7D7D293B76617220663D646F63756D656E742E646F63756D656E744D6F64652C67';
wwv_flow_api.g_varchar2_table(220) := '3D66262631313E3D663B746869732E2473656C656374696F6E2E6F6E2822696E7075742E736561726368636865636B222C222E73656C656374322D7365617263682D2D696E6C696E65222C66756E6374696F6E2861297B72657475726E20673F766F6964';
wwv_flow_api.g_varchar2_table(221) := '20652E2473656C656374696F6E2E6F66662822696E7075742E73656172636820696E7075742E736561726368636865636B22293A766F696420652E2473656C656374696F6E2E6F666628226B657975702E73656172636822297D292C746869732E247365';
wwv_flow_api.g_varchar2_table(222) := '6C656374696F6E2E6F6E28226B657975702E73656172636820696E7075742E736561726368222C222E73656C656374322D7365617263682D2D696E6C696E65222C66756E6374696F6E2861297B69662867262622696E707574223D3D3D612E7479706529';
wwv_flow_api.g_varchar2_table(223) := '72657475726E20766F696420652E2473656C656374696F6E2E6F66662822696E7075742E73656172636820696E7075742E736561726368636865636B22293B76617220623D612E77686963683B62213D632E5348494654262662213D632E4354524C2626';
wwv_flow_api.g_varchar2_table(224) := '62213D632E414C54262662213D632E5441422626652E68616E646C655365617263682861297D297D2C642E70726F746F747970652E5F7472616E73666572546162496E6465783D66756E6374696F6E2861297B746869732E247365617263682E61747472';
wwv_flow_api.g_varchar2_table(225) := '2822746162696E646578222C746869732E2473656C656374696F6E2E617474722822746162696E6465782229292C746869732E2473656C656374696F6E2E617474722822746162696E646578222C222D3122297D2C642E70726F746F747970652E637265';
wwv_flow_api.g_varchar2_table(226) := '617465506C616365686F6C6465723D66756E6374696F6E28612C62297B746869732E247365617263682E617474722822706C616365686F6C646572222C622E74657874297D2C642E70726F746F747970652E7570646174653D66756E6374696F6E28612C';
wwv_flow_api.g_varchar2_table(227) := '62297B76617220633D746869732E247365617263685B305D3D3D646F63756D656E742E616374697665456C656D656E743B746869732E247365617263682E617474722822706C616365686F6C646572222C2222292C612E63616C6C28746869732C62292C';
wwv_flow_api.g_varchar2_table(228) := '746869732E2473656C656374696F6E2E66696E6428222E73656C656374322D73656C656374696F6E5F5F72656E646572656422292E617070656E6428746869732E24736561726368436F6E7461696E6572292C746869732E726573697A65536561726368';
wwv_flow_api.g_varchar2_table(229) := '28292C632626746869732E247365617263682E666F63757328297D2C642E70726F746F747970652E68616E646C655365617263683D66756E6374696F6E28297B696628746869732E726573697A6553656172636828292C21746869732E5F6B6579557050';
wwv_flow_api.g_varchar2_table(230) := '726576656E746564297B76617220613D746869732E247365617263682E76616C28293B746869732E7472696767657228227175657279222C7B7465726D3A617D297D746869732E5F6B6579557050726576656E7465643D21317D2C642E70726F746F7479';
wwv_flow_api.g_varchar2_table(231) := '70652E73656172636852656D6F766543686F6963653D66756E6374696F6E28612C62297B746869732E747269676765722822756E73656C656374222C7B646174613A627D292C746869732E247365617263682E76616C28622E74657874292C746869732E';
wwv_flow_api.g_varchar2_table(232) := '68616E646C6553656172636828297D2C642E70726F746F747970652E726573697A655365617263683D66756E6374696F6E28297B746869732E247365617263682E63737328227769647468222C223235707822293B76617220613D22223B696628222221';
wwv_flow_api.g_varchar2_table(233) := '3D3D746869732E247365617263682E617474722822706C616365686F6C646572222929613D746869732E2473656C656374696F6E2E66696E6428222E73656C656374322D73656C656374696F6E5F5F72656E646572656422292E696E6E65725769647468';
wwv_flow_api.g_varchar2_table(234) := '28293B656C73657B76617220623D746869732E247365617263682E76616C28292E6C656E6774682B313B613D2E37352A622B22656D227D746869732E247365617263682E63737328227769647468222C61297D2C647D292C622E646566696E6528227365';
wwv_flow_api.g_varchar2_table(235) := '6C656374322F73656C656374696F6E2F6576656E7452656C6179222C5B226A7175657279225D2C66756E6374696F6E2861297B66756E6374696F6E206228297B7D72657475726E20622E70726F746F747970652E62696E643D66756E6374696F6E28622C';
wwv_flow_api.g_varchar2_table(236) := '632C64297B76617220653D746869732C663D5B226F70656E222C226F70656E696E67222C22636C6F7365222C22636C6F73696E67222C2273656C656374222C2273656C656374696E67222C22756E73656C656374222C22756E73656C656374696E67225D';
wwv_flow_api.g_varchar2_table(237) := '2C673D5B226F70656E696E67222C22636C6F73696E67222C2273656C656374696E67222C22756E73656C656374696E67225D3B622E63616C6C28746869732C632C64292C632E6F6E28222A222C66756E6374696F6E28622C63297B6966282D31213D3D61';
wwv_flow_api.g_varchar2_table(238) := '2E696E417272617928622C6629297B633D637C7C7B7D3B76617220643D612E4576656E74282273656C656374323A222B622C7B706172616D733A637D293B652E24656C656D656E742E747269676765722864292C2D31213D3D612E696E41727261792862';
wwv_flow_api.g_varchar2_table(239) := '2C6729262628632E70726576656E7465643D642E697344656661756C7450726576656E7465642829297D7D297D2C627D292C622E646566696E65282273656C656374322F7472616E736C6174696F6E222C5B226A7175657279222C227265717569726522';
wwv_flow_api.g_varchar2_table(240) := '5D2C66756E6374696F6E28612C62297B66756E6374696F6E20632861297B746869732E646963743D617C7C7B7D7D72657475726E20632E70726F746F747970652E616C6C3D66756E6374696F6E28297B72657475726E20746869732E646963747D2C632E';
wwv_flow_api.g_varchar2_table(241) := '70726F746F747970652E6765743D66756E6374696F6E2861297B72657475726E20746869732E646963745B615D7D2C632E70726F746F747970652E657874656E643D66756E6374696F6E2862297B746869732E646963743D612E657874656E64287B7D2C';
wwv_flow_api.g_varchar2_table(242) := '622E616C6C28292C746869732E64696374297D2C632E5F63616368653D7B7D2C632E6C6F6164506174683D66756E6374696F6E2861297B69662821286120696E20632E5F636163686529297B76617220643D622861293B632E5F63616368655B615D3D64';
wwv_flow_api.g_varchar2_table(243) := '7D72657475726E206E6577206328632E5F63616368655B615D297D2C637D292C622E646566696E65282273656C656374322F64696163726974696373222C5B5D2C66756E6374696F6E28297B76617220613D7B22E292B6223A2241222C22EFBCA1223A22';
wwv_flow_api.g_varchar2_table(244) := '41222C22C380223A2241222C22C381223A2241222C22C382223A2241222C22E1BAA6223A2241222C22E1BAA4223A2241222C22E1BAAA223A2241222C22E1BAA8223A2241222C22C383223A2241222C22C480223A2241222C22C482223A2241222C22E1BA';
wwv_flow_api.g_varchar2_table(245) := 'B0223A2241222C22E1BAAE223A2241222C22E1BAB4223A2241222C22E1BAB2223A2241222C22C8A6223A2241222C22C7A0223A2241222C22C384223A2241222C22C79E223A2241222C22E1BAA2223A2241222C22C385223A2241222C22C7BA223A224122';
wwv_flow_api.g_varchar2_table(246) := '2C22C78D223A2241222C22C880223A2241222C22C882223A2241222C22E1BAA0223A2241222C22E1BAAC223A2241222C22E1BAB6223A2241222C22E1B880223A2241222C22C484223A2241222C22C8BA223A2241222C22E2B1AF223A2241222C22EA9CB2';
wwv_flow_api.g_varchar2_table(247) := '223A224141222C22C386223A224145222C22C7BC223A224145222C22C7A2223A224145222C22EA9CB4223A22414F222C22EA9CB6223A224155222C22EA9CB8223A224156222C22EA9CBA223A224156222C22EA9CBC223A224159222C22E292B7223A2242';
wwv_flow_api.g_varchar2_table(248) := '222C22EFBCA2223A2242222C22E1B882223A2242222C22E1B884223A2242222C22E1B886223A2242222C22C983223A2242222C22C682223A2242222C22C681223A2242222C22E292B8223A2243222C22EFBCA3223A2243222C22C486223A2243222C22C4';
wwv_flow_api.g_varchar2_table(249) := '88223A2243222C22C48A223A2243222C22C48C223A2243222C22C387223A2243222C22E1B888223A2243222C22C687223A2243222C22C8BB223A2243222C22EA9CBE223A2243222C22E292B9223A2244222C22EFBCA4223A2244222C22E1B88A223A2244';
wwv_flow_api.g_varchar2_table(250) := '222C22C48E223A2244222C22E1B88C223A2244222C22E1B890223A2244222C22E1B892223A2244222C22E1B88E223A2244222C22C490223A2244222C22C68B223A2244222C22C68A223A2244222C22C689223A2244222C22EA9DB9223A2244222C22C7B1';
wwv_flow_api.g_varchar2_table(251) := '223A22445A222C22C784223A22445A222C22C7B2223A22447A222C22C785223A22447A222C22E292BA223A2245222C22EFBCA5223A2245222C22C388223A2245222C22C389223A2245222C22C38A223A2245222C22E1BB80223A2245222C22E1BABE223A';
wwv_flow_api.g_varchar2_table(252) := '2245222C22E1BB84223A2245222C22E1BB82223A2245222C22E1BABC223A2245222C22C492223A2245222C22E1B894223A2245222C22E1B896223A2245222C22C494223A2245222C22C496223A2245222C22C38B223A2245222C22E1BABA223A2245222C';
wwv_flow_api.g_varchar2_table(253) := '22C49A223A2245222C22C884223A2245222C22C886223A2245222C22E1BAB8223A2245222C22E1BB86223A2245222C22C8A8223A2245222C22E1B89C223A2245222C22C498223A2245222C22E1B898223A2245222C22E1B89A223A2245222C22C690223A';
wwv_flow_api.g_varchar2_table(254) := '2245222C22C68E223A2245222C22E292BB223A2246222C22EFBCA6223A2246222C22E1B89E223A2246222C22C691223A2246222C22EA9DBB223A2246222C22E292BC223A2247222C22EFBCA7223A2247222C22C7B4223A2247222C22C49C223A2247222C';
wwv_flow_api.g_varchar2_table(255) := '22E1B8A0223A2247222C22C49E223A2247222C22C4A0223A2247222C22C7A6223A2247222C22C4A2223A2247222C22C7A4223A2247222C22C693223A2247222C22EA9EA0223A2247222C22EA9DBD223A2247222C22EA9DBE223A2247222C22E292BD223A';
wwv_flow_api.g_varchar2_table(256) := '2248222C22EFBCA8223A2248222C22C4A4223A2248222C22E1B8A2223A2248222C22E1B8A6223A2248222C22C89E223A2248222C22E1B8A4223A2248222C22E1B8A8223A2248222C22E1B8AA223A2248222C22C4A6223A2248222C22E2B1A7223A224822';
wwv_flow_api.g_varchar2_table(257) := '2C22E2B1B5223A2248222C22EA9E8D223A2248222C22E292BE223A2249222C22EFBCA9223A2249222C22C38C223A2249222C22C38D223A2249222C22C38E223A2249222C22C4A8223A2249222C22C4AA223A2249222C22C4AC223A2249222C22C4B0223A';
wwv_flow_api.g_varchar2_table(258) := '2249222C22C38F223A2249222C22E1B8AE223A2249222C22E1BB88223A2249222C22C78F223A2249222C22C888223A2249222C22C88A223A2249222C22E1BB8A223A2249222C22C4AE223A2249222C22E1B8AC223A2249222C22C697223A2249222C22E2';
wwv_flow_api.g_varchar2_table(259) := '92BF223A224A222C22EFBCAA223A224A222C22C4B4223A224A222C22C988223A224A222C22E29380223A224B222C22EFBCAB223A224B222C22E1B8B0223A224B222C22C7A8223A224B222C22E1B8B2223A224B222C22C4B6223A224B222C22E1B8B4223A';
wwv_flow_api.g_varchar2_table(260) := '224B222C22C698223A224B222C22E2B1A9223A224B222C22EA9D80223A224B222C22EA9D82223A224B222C22EA9D84223A224B222C22EA9EA2223A224B222C22E29381223A224C222C22EFBCAC223A224C222C22C4BF223A224C222C22C4B9223A224C22';
wwv_flow_api.g_varchar2_table(261) := '2C22C4BD223A224C222C22E1B8B6223A224C222C22E1B8B8223A224C222C22C4BB223A224C222C22E1B8BC223A224C222C22E1B8BA223A224C222C22C581223A224C222C22C8BD223A224C222C22E2B1A2223A224C222C22E2B1A0223A224C222C22EA9D';
wwv_flow_api.g_varchar2_table(262) := '88223A224C222C22EA9D86223A224C222C22EA9E80223A224C222C22C787223A224C4A222C22C788223A224C6A222C22E29382223A224D222C22EFBCAD223A224D222C22E1B8BE223A224D222C22E1B980223A224D222C22E1B982223A224D222C22E2B1';
wwv_flow_api.g_varchar2_table(263) := 'AE223A224D222C22C69C223A224D222C22E29383223A224E222C22EFBCAE223A224E222C22C7B8223A224E222C22C583223A224E222C22C391223A224E222C22E1B984223A224E222C22C587223A224E222C22E1B986223A224E222C22C585223A224E22';
wwv_flow_api.g_varchar2_table(264) := '2C22E1B98A223A224E222C22E1B988223A224E222C22C8A0223A224E222C22C69D223A224E222C22EA9E90223A224E222C22EA9EA4223A224E222C22C78A223A224E4A222C22C78B223A224E6A222C22E29384223A224F222C22EFBCAF223A224F222C22';
wwv_flow_api.g_varchar2_table(265) := 'C392223A224F222C22C393223A224F222C22C394223A224F222C22E1BB92223A224F222C22E1BB90223A224F222C22E1BB96223A224F222C22E1BB94223A224F222C22C395223A224F222C22E1B98C223A224F222C22C8AC223A224F222C22E1B98E223A';
wwv_flow_api.g_varchar2_table(266) := '224F222C22C58C223A224F222C22E1B990223A224F222C22E1B992223A224F222C22C58E223A224F222C22C8AE223A224F222C22C8B0223A224F222C22C396223A224F222C22C8AA223A224F222C22E1BB8E223A224F222C22C590223A224F222C22C791';
wwv_flow_api.g_varchar2_table(267) := '223A224F222C22C88C223A224F222C22C88E223A224F222C22C6A0223A224F222C22E1BB9C223A224F222C22E1BB9A223A224F222C22E1BBA0223A224F222C22E1BB9E223A224F222C22E1BBA2223A224F222C22E1BB8C223A224F222C22E1BB98223A22';
wwv_flow_api.g_varchar2_table(268) := '4F222C22C7AA223A224F222C22C7AC223A224F222C22C398223A224F222C22C7BE223A224F222C22C686223A224F222C22C69F223A224F222C22EA9D8A223A224F222C22EA9D8C223A224F222C22C6A2223A224F49222C22EA9D8E223A224F4F222C22C8';
wwv_flow_api.g_varchar2_table(269) := 'A2223A224F55222C22E29385223A2250222C22EFBCB0223A2250222C22E1B994223A2250222C22E1B996223A2250222C22C6A4223A2250222C22E2B1A3223A2250222C22EA9D90223A2250222C22EA9D92223A2250222C22EA9D94223A2250222C22E293';
wwv_flow_api.g_varchar2_table(270) := '86223A2251222C22EFBCB1223A2251222C22EA9D96223A2251222C22EA9D98223A2251222C22C98A223A2251222C22E29387223A2252222C22EFBCB2223A2252222C22C594223A2252222C22E1B998223A2252222C22C598223A2252222C22C890223A22';
wwv_flow_api.g_varchar2_table(271) := '52222C22C892223A2252222C22E1B99A223A2252222C22E1B99C223A2252222C22C596223A2252222C22E1B99E223A2252222C22C98C223A2252222C22E2B1A4223A2252222C22EA9D9A223A2252222C22EA9EA6223A2252222C22EA9E82223A2252222C';
wwv_flow_api.g_varchar2_table(272) := '22E29388223A2253222C22EFBCB3223A2253222C22E1BA9E223A2253222C22C59A223A2253222C22E1B9A4223A2253222C22C59C223A2253222C22E1B9A0223A2253222C22C5A0223A2253222C22E1B9A6223A2253222C22E1B9A2223A2253222C22E1B9';
wwv_flow_api.g_varchar2_table(273) := 'A8223A2253222C22C898223A2253222C22C59E223A2253222C22E2B1BE223A2253222C22EA9EA8223A2253222C22EA9E84223A2253222C22E29389223A2254222C22EFBCB4223A2254222C22E1B9AA223A2254222C22C5A4223A2254222C22E1B9AC223A';
wwv_flow_api.g_varchar2_table(274) := '2254222C22C89A223A2254222C22C5A2223A2254222C22E1B9B0223A2254222C22E1B9AE223A2254222C22C5A6223A2254222C22C6AC223A2254222C22C6AE223A2254222C22C8BE223A2254222C22EA9E86223A2254222C22EA9CA8223A22545A222C22';
wwv_flow_api.g_varchar2_table(275) := 'E2938A223A2255222C22EFBCB5223A2255222C22C399223A2255222C22C39A223A2255222C22C39B223A2255222C22C5A8223A2255222C22E1B9B8223A2255222C22C5AA223A2255222C22E1B9BA223A2255222C22C5AC223A2255222C22C39C223A2255';
wwv_flow_api.g_varchar2_table(276) := '222C22C79B223A2255222C22C797223A2255222C22C795223A2255222C22C799223A2255222C22E1BBA6223A2255222C22C5AE223A2255222C22C5B0223A2255222C22C793223A2255222C22C894223A2255222C22C896223A2255222C22C6AF223A2255';
wwv_flow_api.g_varchar2_table(277) := '222C22E1BBAA223A2255222C22E1BBA8223A2255222C22E1BBAE223A2255222C22E1BBAC223A2255222C22E1BBB0223A2255222C22E1BBA4223A2255222C22E1B9B2223A2255222C22C5B2223A2255222C22E1B9B6223A2255222C22E1B9B4223A225522';
wwv_flow_api.g_varchar2_table(278) := '2C22C984223A2255222C22E2938B223A2256222C22EFBCB6223A2256222C22E1B9BC223A2256222C22E1B9BE223A2256222C22C6B2223A2256222C22EA9D9E223A2256222C22C985223A2256222C22EA9DA0223A225659222C22E2938C223A2257222C22';
wwv_flow_api.g_varchar2_table(279) := 'EFBCB7223A2257222C22E1BA80223A2257222C22E1BA82223A2257222C22C5B4223A2257222C22E1BA86223A2257222C22E1BA84223A2257222C22E1BA88223A2257222C22E2B1B2223A2257222C22E2938D223A2258222C22EFBCB8223A2258222C22E1';
wwv_flow_api.g_varchar2_table(280) := 'BA8A223A2258222C22E1BA8C223A2258222C22E2938E223A2259222C22EFBCB9223A2259222C22E1BBB2223A2259222C22C39D223A2259222C22C5B6223A2259222C22E1BBB8223A2259222C22C8B2223A2259222C22E1BA8E223A2259222C22C5B8223A';
wwv_flow_api.g_varchar2_table(281) := '2259222C22E1BBB6223A2259222C22E1BBB4223A2259222C22C6B3223A2259222C22C98E223A2259222C22E1BBBE223A2259222C22E2938F223A225A222C22EFBCBA223A225A222C22C5B9223A225A222C22E1BA90223A225A222C22C5BB223A225A222C';
wwv_flow_api.g_varchar2_table(282) := '22C5BD223A225A222C22E1BA92223A225A222C22E1BA94223A225A222C22C6B5223A225A222C22C8A4223A225A222C22E2B1BF223A225A222C22E2B1AB223A225A222C22EA9DA2223A225A222C22E29390223A2261222C22EFBD81223A2261222C22E1BA';
wwv_flow_api.g_varchar2_table(283) := '9A223A2261222C22C3A0223A2261222C22C3A1223A2261222C22C3A2223A2261222C22E1BAA7223A2261222C22E1BAA5223A2261222C22E1BAAB223A2261222C22E1BAA9223A2261222C22C3A3223A2261222C22C481223A2261222C22C483223A226122';
wwv_flow_api.g_varchar2_table(284) := '2C22E1BAB1223A2261222C22E1BAAF223A2261222C22E1BAB5223A2261222C22E1BAB3223A2261222C22C8A7223A2261222C22C7A1223A2261222C22C3A4223A2261222C22C79F223A2261222C22E1BAA3223A2261222C22C3A5223A2261222C22C7BB22';
wwv_flow_api.g_varchar2_table(285) := '3A2261222C22C78E223A2261222C22C881223A2261222C22C883223A2261222C22E1BAA1223A2261222C22E1BAAD223A2261222C22E1BAB7223A2261222C22E1B881223A2261222C22C485223A2261222C22E2B1A5223A2261222C22C990223A2261222C';
wwv_flow_api.g_varchar2_table(286) := '22EA9CB3223A226161222C22C3A6223A226165222C22C7BD223A226165222C22C7A3223A226165222C22EA9CB5223A22616F222C22EA9CB7223A226175222C22EA9CB9223A226176222C22EA9CBB223A226176222C22EA9CBD223A226179222C22E29391';
wwv_flow_api.g_varchar2_table(287) := '223A2262222C22EFBD82223A2262222C22E1B883223A2262222C22E1B885223A2262222C22E1B887223A2262222C22C680223A2262222C22C683223A2262222C22C993223A2262222C22E29392223A2263222C22EFBD83223A2263222C22C487223A2263';
wwv_flow_api.g_varchar2_table(288) := '222C22C489223A2263222C22C48B223A2263222C22C48D223A2263222C22C3A7223A2263222C22E1B889223A2263222C22C688223A2263222C22C8BC223A2263222C22EA9CBF223A2263222C22E28684223A2263222C22E29393223A2264222C22EFBD84';
wwv_flow_api.g_varchar2_table(289) := '223A2264222C22E1B88B223A2264222C22C48F223A2264222C22E1B88D223A2264222C22E1B891223A2264222C22E1B893223A2264222C22E1B88F223A2264222C22C491223A2264222C22C68C223A2264222C22C996223A2264222C22C997223A226422';
wwv_flow_api.g_varchar2_table(290) := '2C22EA9DBA223A2264222C22C7B3223A22647A222C22C786223A22647A222C22E29394223A2265222C22EFBD85223A2265222C22C3A8223A2265222C22C3A9223A2265222C22C3AA223A2265222C22E1BB81223A2265222C22E1BABF223A2265222C22E1';
wwv_flow_api.g_varchar2_table(291) := 'BB85223A2265222C22E1BB83223A2265222C22E1BABD223A2265222C22C493223A2265222C22E1B895223A2265222C22E1B897223A2265222C22C495223A2265222C22C497223A2265222C22C3AB223A2265222C22E1BABB223A2265222C22C49B223A22';
wwv_flow_api.g_varchar2_table(292) := '65222C22C885223A2265222C22C887223A2265222C22E1BAB9223A2265222C22E1BB87223A2265222C22C8A9223A2265222C22E1B89D223A2265222C22C499223A2265222C22E1B899223A2265222C22E1B89B223A2265222C22C987223A2265222C22C9';
wwv_flow_api.g_varchar2_table(293) := '9B223A2265222C22C79D223A2265222C22E29395223A2266222C22EFBD86223A2266222C22E1B89F223A2266222C22C692223A2266222C22EA9DBC223A2266222C22E29396223A2267222C22EFBD87223A2267222C22C7B5223A2267222C22C49D223A22';
wwv_flow_api.g_varchar2_table(294) := '67222C22E1B8A1223A2267222C22C49F223A2267222C22C4A1223A2267222C22C7A7223A2267222C22C4A3223A2267222C22C7A5223A2267222C22C9A0223A2267222C22EA9EA1223A2267222C22E1B5B9223A2267222C22EA9DBF223A2267222C22E293';
wwv_flow_api.g_varchar2_table(295) := '97223A2268222C22EFBD88223A2268222C22C4A5223A2268222C22E1B8A3223A2268222C22E1B8A7223A2268222C22C89F223A2268222C22E1B8A5223A2268222C22E1B8A9223A2268222C22E1B8AB223A2268222C22E1BA96223A2268222C22C4A7223A';
wwv_flow_api.g_varchar2_table(296) := '2268222C22E2B1A8223A2268222C22E2B1B6223A2268222C22C9A5223A2268222C22C695223A226876222C22E29398223A2269222C22EFBD89223A2269222C22C3AC223A2269222C22C3AD223A2269222C22C3AE223A2269222C22C4A9223A2269222C22';
wwv_flow_api.g_varchar2_table(297) := 'C4AB223A2269222C22C4AD223A2269222C22C3AF223A2269222C22E1B8AF223A2269222C22E1BB89223A2269222C22C790223A2269222C22C889223A2269222C22C88B223A2269222C22E1BB8B223A2269222C22C4AF223A2269222C22E1B8AD223A2269';
wwv_flow_api.g_varchar2_table(298) := '222C22C9A8223A2269222C22C4B1223A2269222C22E29399223A226A222C22EFBD8A223A226A222C22C4B5223A226A222C22C7B0223A226A222C22C989223A226A222C22E2939A223A226B222C22EFBD8B223A226B222C22E1B8B1223A226B222C22C7A9';
wwv_flow_api.g_varchar2_table(299) := '223A226B222C22E1B8B3223A226B222C22C4B7223A226B222C22E1B8B5223A226B222C22C699223A226B222C22E2B1AA223A226B222C22EA9D81223A226B222C22EA9D83223A226B222C22EA9D85223A226B222C22EA9EA3223A226B222C22E2939B223A';
wwv_flow_api.g_varchar2_table(300) := '226C222C22EFBD8C223A226C222C22C580223A226C222C22C4BA223A226C222C22C4BE223A226C222C22E1B8B7223A226C222C22E1B8B9223A226C222C22C4BC223A226C222C22E1B8BD223A226C222C22E1B8BB223A226C222C22C5BF223A226C222C22';
wwv_flow_api.g_varchar2_table(301) := 'C582223A226C222C22C69A223A226C222C22C9AB223A226C222C22E2B1A1223A226C222C22EA9D89223A226C222C22EA9E81223A226C222C22EA9D87223A226C222C22C789223A226C6A222C22E2939C223A226D222C22EFBD8D223A226D222C22E1B8BF';
wwv_flow_api.g_varchar2_table(302) := '223A226D222C22E1B981223A226D222C22E1B983223A226D222C22C9B1223A226D222C22C9AF223A226D222C22E2939D223A226E222C22EFBD8E223A226E222C22C7B9223A226E222C22C584223A226E222C22C3B1223A226E222C22E1B985223A226E22';
wwv_flow_api.g_varchar2_table(303) := '2C22C588223A226E222C22E1B987223A226E222C22C586223A226E222C22E1B98B223A226E222C22E1B989223A226E222C22C69E223A226E222C22C9B2223A226E222C22C589223A226E222C22EA9E91223A226E222C22EA9EA5223A226E222C22C78C22';
wwv_flow_api.g_varchar2_table(304) := '3A226E6A222C22E2939E223A226F222C22EFBD8F223A226F222C22C3B2223A226F222C22C3B3223A226F222C22C3B4223A226F222C22E1BB93223A226F222C22E1BB91223A226F222C22E1BB97223A226F222C22E1BB95223A226F222C22C3B5223A226F';
wwv_flow_api.g_varchar2_table(305) := '222C22E1B98D223A226F222C22C8AD223A226F222C22E1B98F223A226F222C22C58D223A226F222C22E1B991223A226F222C22E1B993223A226F222C22C58F223A226F222C22C8AF223A226F222C22C8B1223A226F222C22C3B6223A226F222C22C8AB22';
wwv_flow_api.g_varchar2_table(306) := '3A226F222C22E1BB8F223A226F222C22C591223A226F222C22C792223A226F222C22C88D223A226F222C22C88F223A226F222C22C6A1223A226F222C22E1BB9D223A226F222C22E1BB9B223A226F222C22E1BBA1223A226F222C22E1BB9F223A226F222C';
wwv_flow_api.g_varchar2_table(307) := '22E1BBA3223A226F222C22E1BB8D223A226F222C22E1BB99223A226F222C22C7AB223A226F222C22C7AD223A226F222C22C3B8223A226F222C22C7BF223A226F222C22C994223A226F222C22EA9D8B223A226F222C22EA9D8D223A226F222C22C9B5223A';
wwv_flow_api.g_varchar2_table(308) := '226F222C22C6A3223A226F69222C22C8A3223A226F75222C22EA9D8F223A226F6F222C22E2939F223A2270222C22EFBD90223A2270222C22E1B995223A2270222C22E1B997223A2270222C22C6A5223A2270222C22E1B5BD223A2270222C22EA9D91223A';
wwv_flow_api.g_varchar2_table(309) := '2270222C22EA9D93223A2270222C22EA9D95223A2270222C22E293A0223A2271222C22EFBD91223A2271222C22C98B223A2271222C22EA9D97223A2271222C22EA9D99223A2271222C22E293A1223A2272222C22EFBD92223A2272222C22C595223A2272';
wwv_flow_api.g_varchar2_table(310) := '222C22E1B999223A2272222C22C599223A2272222C22C891223A2272222C22C893223A2272222C22E1B99B223A2272222C22E1B99D223A2272222C22C597223A2272222C22E1B99F223A2272222C22C98D223A2272222C22C9BD223A2272222C22EA9D9B';
wwv_flow_api.g_varchar2_table(311) := '223A2272222C22EA9EA7223A2272222C22EA9E83223A2272222C22E293A2223A2273222C22EFBD93223A2273222C22C39F223A2273222C22C59B223A2273222C22E1B9A5223A2273222C22C59D223A2273222C22E1B9A1223A2273222C22C5A1223A2273';
wwv_flow_api.g_varchar2_table(312) := '222C22E1B9A7223A2273222C22E1B9A3223A2273222C22E1B9A9223A2273222C22C899223A2273222C22C59F223A2273222C22C8BF223A2273222C22EA9EA9223A2273222C22EA9E85223A2273222C22E1BA9B223A2273222C22E293A3223A2274222C22';
wwv_flow_api.g_varchar2_table(313) := 'EFBD94223A2274222C22E1B9AB223A2274222C22E1BA97223A2274222C22C5A5223A2274222C22E1B9AD223A2274222C22C89B223A2274222C22C5A3223A2274222C22E1B9B1223A2274222C22E1B9AF223A2274222C22C5A7223A2274222C22C6AD223A';
wwv_flow_api.g_varchar2_table(314) := '2274222C22CA88223A2274222C22E2B1A6223A2274222C22EA9E87223A2274222C22EA9CA9223A22747A222C22E293A4223A2275222C22EFBD95223A2275222C22C3B9223A2275222C22C3BA223A2275222C22C3BB223A2275222C22C5A9223A2275222C';
wwv_flow_api.g_varchar2_table(315) := '22E1B9B9223A2275222C22C5AB223A2275222C22E1B9BB223A2275222C22C5AD223A2275222C22C3BC223A2275222C22C79C223A2275222C22C798223A2275222C22C796223A2275222C22C79A223A2275222C22E1BBA7223A2275222C22C5AF223A2275';
wwv_flow_api.g_varchar2_table(316) := '222C22C5B1223A2275222C22C794223A2275222C22C895223A2275222C22C897223A2275222C22C6B0223A2275222C22E1BBAB223A2275222C22E1BBA9223A2275222C22E1BBAF223A2275222C22E1BBAD223A2275222C22E1BBB1223A2275222C22E1BB';
wwv_flow_api.g_varchar2_table(317) := 'A5223A2275222C22E1B9B3223A2275222C22C5B3223A2275222C22E1B9B7223A2275222C22E1B9B5223A2275222C22CA89223A2275222C22E293A5223A2276222C22EFBD96223A2276222C22E1B9BD223A2276222C22E1B9BF223A2276222C22CA8B223A';
wwv_flow_api.g_varchar2_table(318) := '2276222C22EA9D9F223A2276222C22CA8C223A2276222C22EA9DA1223A227679222C22E293A6223A2277222C22EFBD97223A2277222C22E1BA81223A2277222C22E1BA83223A2277222C22C5B5223A2277222C22E1BA87223A2277222C22E1BA85223A22';
wwv_flow_api.g_varchar2_table(319) := '77222C22E1BA98223A2277222C22E1BA89223A2277222C22E2B1B3223A2277222C22E293A7223A2278222C22EFBD98223A2278222C22E1BA8B223A2278222C22E1BA8D223A2278222C22E293A8223A2279222C22EFBD99223A2279222C22E1BBB3223A22';
wwv_flow_api.g_varchar2_table(320) := '79222C22C3BD223A2279222C22C5B7223A2279222C22E1BBB9223A2279222C22C8B3223A2279222C22E1BA8F223A2279222C22C3BF223A2279222C22E1BBB7223A2279222C22E1BA99223A2279222C22E1BBB5223A2279222C22C6B4223A2279222C22C9';
wwv_flow_api.g_varchar2_table(321) := '8F223A2279222C22E1BBBF223A2279222C22E293A9223A227A222C22EFBD9A223A227A222C22C5BA223A227A222C22E1BA91223A227A222C22C5BC223A227A222C22C5BE223A227A222C22E1BA93223A227A222C22E1BA95223A227A222C22C6B6223A22';
wwv_flow_api.g_varchar2_table(322) := '7A222C22C8A5223A227A222C22C980223A227A222C22E2B1AC223A227A222C22EA9DA3223A227A222C22CE86223A22CE91222C22CE88223A22CE95222C22CE89223A22CE97222C22CE8A223A22CE99222C22CEAA223A22CE99222C22CE8C223A22CE9F22';
wwv_flow_api.g_varchar2_table(323) := '2C22CE8E223A22CEA5222C22CEAB223A22CEA5222C22CE8F223A22CEA9222C22CEAC223A22CEB1222C22CEAD223A22CEB5222C22CEAE223A22CEB7222C22CEAF223A22CEB9222C22CF8A223A22CEB9222C22CE90223A22CEB9222C22CF8C223A22CEBF22';
wwv_flow_api.g_varchar2_table(324) := '2C22CF8D223A22CF85222C22CF8B223A22CF85222C22CEB0223A22CF85222C22CF89223A22CF89222C22CF82223A22CF83227D3B72657475726E20617D292C622E646566696E65282273656C656374322F646174612F62617365222C5B222E2E2F757469';
wwv_flow_api.g_varchar2_table(325) := '6C73225D2C66756E6374696F6E2861297B66756E6374696F6E206228612C63297B622E5F5F73757065725F5F2E636F6E7374727563746F722E63616C6C2874686973297D72657475726E20612E457874656E6428622C612E4F627365727661626C65292C';
wwv_flow_api.g_varchar2_table(326) := '622E70726F746F747970652E63757272656E743D66756E6374696F6E2861297B7468726F77206E6577204572726F722822546865206063757272656E7460206D6574686F64206D75737420626520646566696E656420696E206368696C6420636C617373';
wwv_flow_api.g_varchar2_table(327) := '65732E22297D2C622E70726F746F747970652E71756572793D66756E6374696F6E28612C62297B7468726F77206E6577204572726F7228225468652060717565727960206D6574686F64206D75737420626520646566696E656420696E206368696C6420';
wwv_flow_api.g_varchar2_table(328) := '636C61737365732E22297D2C622E70726F746F747970652E62696E643D66756E6374696F6E28612C62297B7D2C622E70726F746F747970652E64657374726F793D66756E6374696F6E28297B7D2C622E70726F746F747970652E67656E65726174655265';
wwv_flow_api.g_varchar2_table(329) := '73756C7449643D66756E6374696F6E28622C63297B76617220643D622E69642B222D726573756C742D223B72657475726E20642B3D612E67656E657261746543686172732834292C642B3D6E756C6C213D632E69643F222D222B632E69642E746F537472';
wwv_flow_api.g_varchar2_table(330) := '696E6728293A222D222B612E67656E657261746543686172732834297D2C627D292C622E646566696E65282273656C656374322F646174612F73656C656374222C5B222E2F62617365222C222E2E2F7574696C73222C226A7175657279225D2C66756E63';
wwv_flow_api.g_varchar2_table(331) := '74696F6E28612C622C63297B66756E6374696F6E206428612C62297B746869732E24656C656D656E743D612C746869732E6F7074696F6E733D622C642E5F5F73757065725F5F2E636F6E7374727563746F722E63616C6C2874686973297D72657475726E';
wwv_flow_api.g_varchar2_table(332) := '20622E457874656E6428642C61292C642E70726F746F747970652E63757272656E743D66756E6374696F6E2861297B76617220623D5B5D2C643D746869733B746869732E24656C656D656E742E66696E6428223A73656C656374656422292E6561636828';
wwv_flow_api.g_varchar2_table(333) := '66756E6374696F6E28297B76617220613D632874686973292C653D642E6974656D2861293B622E707573682865297D292C612862297D2C642E70726F746F747970652E73656C6563743D66756E6374696F6E2861297B76617220623D746869733B696628';
wwv_flow_api.g_varchar2_table(334) := '612E73656C65637465643D21302C6328612E656C656D656E74292E697328226F7074696F6E22292972657475726E20612E656C656D656E742E73656C65637465643D21302C766F696420746869732E24656C656D656E742E747269676765722822636861';
wwv_flow_api.g_varchar2_table(335) := '6E676522293B0A696628746869732E24656C656D656E742E70726F7028226D756C7469706C65222929746869732E63757272656E742866756E6374696F6E2864297B76617220653D5B5D3B613D5B615D2C612E707573682E6170706C7928612C64293B66';
wwv_flow_api.g_varchar2_table(336) := '6F722876617220663D303B663C612E6C656E6774683B662B2B297B76617220673D615B665D2E69643B2D313D3D3D632E696E417272617928672C65292626652E707573682867297D622E24656C656D656E742E76616C2865292C622E24656C656D656E74';
wwv_flow_api.g_varchar2_table(337) := '2E7472696767657228226368616E676522297D293B656C73657B76617220643D612E69643B746869732E24656C656D656E742E76616C2864292C746869732E24656C656D656E742E7472696767657228226368616E676522297D7D2C642E70726F746F74';
wwv_flow_api.g_varchar2_table(338) := '7970652E756E73656C6563743D66756E6374696F6E2861297B76617220623D746869733B696628746869732E24656C656D656E742E70726F7028226D756C7469706C6522292972657475726E20612E73656C65637465643D21312C6328612E656C656D65';
wwv_flow_api.g_varchar2_table(339) := '6E74292E697328226F7074696F6E22293F28612E656C656D656E742E73656C65637465643D21312C766F696420746869732E24656C656D656E742E7472696767657228226368616E67652229293A766F696420746869732E63757272656E742866756E63';
wwv_flow_api.g_varchar2_table(340) := '74696F6E2864297B666F722876617220653D5B5D2C663D303B663C642E6C656E6774683B662B2B297B76617220673D645B665D2E69643B67213D3D612E696426262D313D3D3D632E696E417272617928672C65292626652E707573682867297D622E2465';
wwv_flow_api.g_varchar2_table(341) := '6C656D656E742E76616C2865292C622E24656C656D656E742E7472696767657228226368616E676522297D297D2C642E70726F746F747970652E62696E643D66756E6374696F6E28612C62297B76617220633D746869733B746869732E636F6E7461696E';
wwv_flow_api.g_varchar2_table(342) := '65723D612C612E6F6E282273656C656374222C66756E6374696F6E2861297B632E73656C65637428612E64617461297D292C612E6F6E2822756E73656C656374222C66756E6374696F6E2861297B632E756E73656C65637428612E64617461297D297D2C';
wwv_flow_api.g_varchar2_table(343) := '642E70726F746F747970652E64657374726F793D66756E6374696F6E28297B746869732E24656C656D656E742E66696E6428222A22292E656163682866756E6374696F6E28297B632E72656D6F76654461746128746869732C226461746122297D297D2C';
wwv_flow_api.g_varchar2_table(344) := '642E70726F746F747970652E71756572793D66756E6374696F6E28612C62297B76617220643D5B5D2C653D746869732C663D746869732E24656C656D656E742E6368696C6472656E28293B662E656163682866756E6374696F6E28297B76617220623D63';
wwv_flow_api.g_varchar2_table(345) := '2874686973293B696628622E697328226F7074696F6E22297C7C622E697328226F707467726F75702229297B76617220663D652E6974656D2862292C673D652E6D61746368657328612C66293B6E756C6C213D3D672626642E707573682867297D7D292C';
wwv_flow_api.g_varchar2_table(346) := '62287B726573756C74733A647D297D2C642E70726F746F747970652E6164644F7074696F6E733D66756E6374696F6E2861297B622E617070656E644D616E7928746869732E24656C656D656E742C61297D2C642E70726F746F747970652E6F7074696F6E';
wwv_flow_api.g_varchar2_table(347) := '3D66756E6374696F6E2861297B76617220623B612E6368696C6472656E3F28623D646F63756D656E742E637265617465456C656D656E7428226F707467726F757022292C622E6C6162656C3D612E74657874293A28623D646F63756D656E742E63726561';
wwv_flow_api.g_varchar2_table(348) := '7465456C656D656E7428226F7074696F6E22292C766F69642030213D3D622E74657874436F6E74656E743F622E74657874436F6E74656E743D612E746578743A622E696E6E6572546578743D612E74657874292C612E6964262628622E76616C75653D61';
wwv_flow_api.g_varchar2_table(349) := '2E6964292C612E64697361626C6564262628622E64697361626C65643D2130292C612E73656C6563746564262628622E73656C65637465643D2130292C612E7469746C65262628622E7469746C653D612E7469746C65293B76617220643D632862292C65';
wwv_flow_api.g_varchar2_table(350) := '3D746869732E5F6E6F726D616C697A654974656D2861293B72657475726E20652E656C656D656E743D622C632E6461746128622C2264617461222C65292C647D2C642E70726F746F747970652E6974656D3D66756E6374696F6E2861297B76617220623D';
wwv_flow_api.g_varchar2_table(351) := '7B7D3B696628623D632E6461746128615B305D2C226461746122292C6E756C6C213D622972657475726E20623B696628612E697328226F7074696F6E222929623D7B69643A612E76616C28292C746578743A612E7465787428292C64697361626C65643A';
wwv_flow_api.g_varchar2_table(352) := '612E70726F70282264697361626C656422292C73656C65637465643A612E70726F70282273656C656374656422292C7469746C653A612E70726F7028227469746C6522297D3B656C736520696628612E697328226F707467726F75702229297B623D7B74';
wwv_flow_api.g_varchar2_table(353) := '6578743A612E70726F7028226C6162656C22292C6368696C6472656E3A5B5D2C7469746C653A612E70726F7028227469746C6522297D3B666F722876617220643D612E6368696C6472656E28226F7074696F6E22292C653D5B5D2C663D303B663C642E6C';
wwv_flow_api.g_varchar2_table(354) := '656E6774683B662B2B297B76617220673D6328645B665D292C683D746869732E6974656D2867293B652E707573682868297D622E6368696C6472656E3D657D72657475726E20623D746869732E5F6E6F726D616C697A654974656D2862292C622E656C65';
wwv_flow_api.g_varchar2_table(355) := '6D656E743D615B305D2C632E6461746128615B305D2C2264617461222C62292C627D2C642E70726F746F747970652E5F6E6F726D616C697A654974656D3D66756E6374696F6E2861297B632E6973506C61696E4F626A6563742861297C7C28613D7B6964';
wwv_flow_api.g_varchar2_table(356) := '3A612C746578743A617D292C613D632E657874656E64287B7D2C7B746578743A22227D2C61293B76617220623D7B73656C65637465643A21312C64697361626C65643A21317D3B72657475726E206E756C6C213D612E6964262628612E69643D612E6964';
wwv_flow_api.g_varchar2_table(357) := '2E746F537472696E672829292C6E756C6C213D612E74657874262628612E746578743D612E746578742E746F537472696E672829292C6E756C6C3D3D612E5F726573756C7449642626612E696426266E756C6C213D746869732E636F6E7461696E657226';
wwv_flow_api.g_varchar2_table(358) := '2628612E5F726573756C7449643D746869732E67656E6572617465526573756C74496428746869732E636F6E7461696E65722C6129292C632E657874656E64287B7D2C622C61297D2C642E70726F746F747970652E6D6174636865733D66756E6374696F';
wwv_flow_api.g_varchar2_table(359) := '6E28612C62297B76617220633D746869732E6F7074696F6E732E67657428226D61746368657222293B72657475726E206328612C62297D2C647D292C622E646566696E65282273656C656374322F646174612F6172726179222C5B222E2F73656C656374';
wwv_flow_api.g_varchar2_table(360) := '222C222E2E2F7574696C73222C226A7175657279225D2C66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C62297B76617220633D622E67657428226461746122297C7C5B5D3B642E5F5F73757065725F5F2E636F6E737472756374';
wwv_flow_api.g_varchar2_table(361) := '6F722E63616C6C28746869732C612C62292C746869732E6164644F7074696F6E7328746869732E636F6E76657274546F4F7074696F6E73286329297D72657475726E20622E457874656E6428642C61292C642E70726F746F747970652E73656C6563743D';
wwv_flow_api.g_varchar2_table(362) := '66756E6374696F6E2861297B76617220623D746869732E24656C656D656E742E66696E6428226F7074696F6E22292E66696C7465722866756E6374696F6E28622C63297B72657475726E20632E76616C75653D3D612E69642E746F537472696E6728297D';
wwv_flow_api.g_varchar2_table(363) := '293B303D3D3D622E6C656E677468262628623D746869732E6F7074696F6E2861292C746869732E6164644F7074696F6E73286229292C642E5F5F73757065725F5F2E73656C6563742E63616C6C28746869732C61297D2C642E70726F746F747970652E63';
wwv_flow_api.g_varchar2_table(364) := '6F6E76657274546F4F7074696F6E733D66756E6374696F6E2861297B66756E6374696F6E20642861297B72657475726E2066756E6374696F6E28297B72657475726E20632874686973292E76616C28293D3D612E69647D7D666F722876617220653D7468';
wwv_flow_api.g_varchar2_table(365) := '69732C663D746869732E24656C656D656E742E66696E6428226F7074696F6E22292C673D662E6D61702866756E6374696F6E28297B72657475726E20652E6974656D2863287468697329292E69647D292E67657428292C683D5B5D2C693D303B693C612E';
wwv_flow_api.g_varchar2_table(366) := '6C656E6774683B692B2B297B766172206A3D746869732E5F6E6F726D616C697A654974656D28615B695D293B696628632E696E4172726179286A2E69642C67293E3D30297B766172206B3D662E66696C7465722864286A29292C6C3D746869732E697465';
wwv_flow_api.g_varchar2_table(367) := '6D286B292C6D3D632E657874656E642821302C7B7D2C6A2C6C292C6E3D746869732E6F7074696F6E286D293B6B2E7265706C61636557697468286E297D656C73657B766172206F3D746869732E6F7074696F6E286A293B6966286A2E6368696C6472656E';
wwv_flow_api.g_varchar2_table(368) := '297B76617220703D746869732E636F6E76657274546F4F7074696F6E73286A2E6368696C6472656E293B622E617070656E644D616E79286F2C70297D682E70757368286F297D7D72657475726E20687D2C647D292C622E646566696E65282273656C6563';
wwv_flow_api.g_varchar2_table(369) := '74322F646174612F616A6178222C5B222E2F6172726179222C222E2E2F7574696C73222C226A7175657279225D2C66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C62297B746869732E616A61784F7074696F6E733D746869732E';
wwv_flow_api.g_varchar2_table(370) := '5F6170706C7944656661756C747328622E6765742822616A61782229292C6E756C6C213D746869732E616A61784F7074696F6E732E70726F63657373526573756C7473262628746869732E70726F63657373526573756C74733D746869732E616A61784F';
wwv_flow_api.g_varchar2_table(371) := '7074696F6E732E70726F63657373526573756C7473292C642E5F5F73757065725F5F2E636F6E7374727563746F722E63616C6C28746869732C612C62297D72657475726E20622E457874656E6428642C61292C642E70726F746F747970652E5F6170706C';
wwv_flow_api.g_varchar2_table(372) := '7944656661756C74733D66756E6374696F6E2861297B76617220623D7B646174613A66756E6374696F6E2861297B72657475726E20632E657874656E64287B7D2C612C7B713A612E7465726D7D297D2C7472616E73706F72743A66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(373) := '2C622C64297B76617220653D632E616A61782861293B72657475726E20652E7468656E2862292C652E6661696C2864292C657D7D3B72657475726E20632E657874656E64287B7D2C622C612C2130297D2C642E70726F746F747970652E70726F63657373';
wwv_flow_api.g_varchar2_table(374) := '526573756C74733D66756E6374696F6E2861297B72657475726E20617D2C642E70726F746F747970652E71756572793D66756E6374696F6E28612C62297B66756E6374696F6E206428297B76617220643D662E7472616E73706F727428662C66756E6374';
wwv_flow_api.g_varchar2_table(375) := '696F6E2864297B76617220663D652E70726F63657373526573756C747328642C61293B652E6F7074696F6E732E676574282264656275672229262677696E646F772E636F6E736F6C652626636F6E736F6C652E6572726F72262628662626662E72657375';
wwv_flow_api.g_varchar2_table(376) := '6C74732626632E6973417272617928662E726573756C7473297C7C636F6E736F6C652E6572726F72282253656C656374323A2054686520414A415820726573756C747320646964206E6F742072657475726E20616E20617272617920696E207468652060';
wwv_flow_api.g_varchar2_table(377) := '726573756C747360206B6579206F662074686520726573706F6E73652E2229292C622866297D2C66756E6374696F6E28297B642E73746174757326262230223D3D3D642E7374617475737C7C652E747269676765722822726573756C74733A6D65737361';
wwv_flow_api.g_varchar2_table(378) := '6765222C7B6D6573736167653A226572726F724C6F6164696E67227D297D293B652E5F726571756573743D647D76617220653D746869733B6E756C6C213D746869732E5F72657175657374262628632E697346756E6374696F6E28746869732E5F726571';
wwv_flow_api.g_varchar2_table(379) := '756573742E61626F7274292626746869732E5F726571756573742E61626F727428292C746869732E5F726571756573743D6E756C6C293B76617220663D632E657874656E64287B747970653A22474554227D2C746869732E616A61784F7074696F6E7329';
wwv_flow_api.g_varchar2_table(380) := '3B2266756E6374696F6E223D3D747970656F6620662E75726C262628662E75726C3D662E75726C2E63616C6C28746869732E24656C656D656E742C6129292C2266756E6374696F6E223D3D747970656F6620662E64617461262628662E646174613D662E';
wwv_flow_api.g_varchar2_table(381) := '646174612E63616C6C28746869732E24656C656D656E742C6129292C746869732E616A61784F7074696F6E732E64656C617926266E756C6C213D612E7465726D3F28746869732E5F717565727954696D656F7574262677696E646F772E636C6561725469';
wwv_flow_api.g_varchar2_table(382) := '6D656F757428746869732E5F717565727954696D656F7574292C746869732E5F717565727954696D656F75743D77696E646F772E73657454696D656F757428642C746869732E616A61784F7074696F6E732E64656C617929293A6428297D2C647D292C62';
wwv_flow_api.g_varchar2_table(383) := '2E646566696E65282273656C656374322F646174612F74616773222C5B226A7175657279225D2C66756E6374696F6E2861297B66756E6374696F6E206228622C632C64297B76617220653D642E67657428227461677322292C663D642E67657428226372';
wwv_flow_api.g_varchar2_table(384) := '6561746554616722293B766F69642030213D3D66262628746869732E6372656174655461673D66293B76617220673D642E6765742822696E7365727454616722293B696628766F69642030213D3D67262628746869732E696E736572745461673D67292C';
wwv_flow_api.g_varchar2_table(385) := '622E63616C6C28746869732C632C64292C612E6973417272617928652929666F722876617220683D303B683C652E6C656E6774683B682B2B297B76617220693D655B685D2C6A3D746869732E5F6E6F726D616C697A654974656D2869292C6B3D74686973';
wwv_flow_api.g_varchar2_table(386) := '2E6F7074696F6E286A293B746869732E24656C656D656E742E617070656E64286B297D7D72657475726E20622E70726F746F747970652E71756572793D66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C66297B666F7228766172';
wwv_flow_api.g_varchar2_table(387) := '20673D612E726573756C74732C683D303B683C672E6C656E6774683B682B2B297B76617220693D675B685D2C6A3D6E756C6C213D692E6368696C6472656E26262164287B726573756C74733A692E6368696C6472656E7D2C2130292C6B3D692E74657874';
wwv_flow_api.g_varchar2_table(388) := '3D3D3D622E7465726D3B6966286B7C7C6A2972657475726E20663F21313A28612E646174613D672C766F69642063286129297D696628662972657475726E21303B766172206C3D652E6372656174655461672862293B6966286E756C6C213D6C297B7661';
wwv_flow_api.g_varchar2_table(389) := '72206D3D652E6F7074696F6E286C293B6D2E617474722822646174612D73656C656374322D746167222C2130292C652E6164644F7074696F6E73285B6D5D292C652E696E7365727454616728672C6C297D612E726573756C74733D672C632861297D7661';
wwv_flow_api.g_varchar2_table(390) := '7220653D746869733B72657475726E20746869732E5F72656D6F76654F6C645461677328292C6E756C6C3D3D622E7465726D7C7C6E756C6C213D622E706167653F766F696420612E63616C6C28746869732C622C63293A766F696420612E63616C6C2874';
wwv_flow_api.g_varchar2_table(391) := '6869732C622C64297D2C622E70726F746F747970652E6372656174655461673D66756E6374696F6E28622C63297B76617220643D612E7472696D28632E7465726D293B72657475726E22223D3D3D643F6E756C6C3A7B69643A642C746578743A647D7D2C';
wwv_flow_api.g_varchar2_table(392) := '622E70726F746F747970652E696E736572745461673D66756E6374696F6E28612C622C63297B622E756E73686966742863297D2C622E70726F746F747970652E5F72656D6F76654F6C64546167733D66756E6374696F6E2862297B76617220633D287468';
wwv_flow_api.g_varchar2_table(393) := '69732E5F6C6173745461672C746869732E24656C656D656E742E66696E6428226F7074696F6E5B646174612D73656C656374322D7461675D2229293B632E656163682866756E6374696F6E28297B746869732E73656C65637465647C7C61287468697329';
wwv_flow_api.g_varchar2_table(394) := '2E72656D6F766528297D297D2C627D292C622E646566696E65282273656C656374322F646174612F746F6B656E697A6572222C5B226A7175657279225D2C66756E6374696F6E2861297B66756E6374696F6E206228612C622C63297B76617220643D632E';
wwv_flow_api.g_varchar2_table(395) := '6765742822746F6B656E697A657222293B766F69642030213D3D64262628746869732E746F6B656E697A65723D64292C612E63616C6C28746869732C622C63297D72657475726E20622E70726F746F747970652E62696E643D66756E6374696F6E28612C';
wwv_flow_api.g_varchar2_table(396) := '622C63297B612E63616C6C28746869732C622C63292C746869732E247365617263683D622E64726F70646F776E2E247365617263687C7C622E73656C656374696F6E2E247365617263687C7C632E66696E6428222E73656C656374322D7365617263685F';
wwv_flow_api.g_varchar2_table(397) := '5F6669656C6422297D2C622E70726F746F747970652E71756572793D66756E6374696F6E28622C632C64297B66756E6374696F6E20652862297B76617220633D672E5F6E6F726D616C697A654974656D2862292C643D672E24656C656D656E742E66696E';
wwv_flow_api.g_varchar2_table(398) := '6428226F7074696F6E22292E66696C7465722866756E6374696F6E28297B72657475726E20612874686973292E76616C28293D3D3D632E69647D293B69662821642E6C656E677468297B76617220653D672E6F7074696F6E2863293B652E617474722822';
wwv_flow_api.g_varchar2_table(399) := '646174612D73656C656374322D746167222C2130292C672E5F72656D6F76654F6C645461677328292C672E6164644F7074696F6E73285B655D297D662863297D66756E6374696F6E20662861297B672E74726967676572282273656C656374222C7B6461';
wwv_flow_api.g_varchar2_table(400) := '74613A617D297D76617220673D746869733B632E7465726D3D632E7465726D7C7C22223B76617220683D746869732E746F6B656E697A657228632C746869732E6F7074696F6E732C65293B682E7465726D213D3D632E7465726D262628746869732E2473';
wwv_flow_api.g_varchar2_table(401) := '65617263682E6C656E677468262628746869732E247365617263682E76616C28682E7465726D292C746869732E247365617263682E666F6375732829292C632E7465726D3D682E7465726D292C622E63616C6C28746869732C632C64297D2C622E70726F';
wwv_flow_api.g_varchar2_table(402) := '746F747970652E746F6B656E697A65723D66756E6374696F6E28622C632C642C65297B666F722876617220663D642E6765742822746F6B656E536570617261746F727322297C7C5B5D2C673D632E7465726D2C683D302C693D746869732E637265617465';
wwv_flow_api.g_varchar2_table(403) := '5461677C7C66756E6374696F6E2861297B72657475726E7B69643A612E7465726D2C746578743A612E7465726D7D7D3B683C672E6C656E6774683B297B766172206A3D675B685D3B6966282D31213D3D612E696E4172726179286A2C6629297B76617220';
wwv_flow_api.g_varchar2_table(404) := '6B3D672E73756273747228302C68292C6C3D612E657874656E64287B7D2C632C7B7465726D3A6B7D292C6D3D69286C293B6E756C6C213D6D3F2865286D292C673D672E73756273747228682B31297C7C22222C683D30293A682B2B7D656C736520682B2B';
wwv_flow_api.g_varchar2_table(405) := '7D72657475726E7B7465726D3A677D7D2C627D292C622E646566696E65282273656C656374322F646174612F6D696E696D756D496E7075744C656E677468222C5B5D2C66756E6374696F6E28297B66756E6374696F6E206128612C622C63297B74686973';
wwv_flow_api.g_varchar2_table(406) := '2E6D696E696D756D496E7075744C656E6774683D632E67657428226D696E696D756D496E7075744C656E67746822292C612E63616C6C28746869732C622C63297D72657475726E20612E70726F746F747970652E71756572793D66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(407) := '2C622C63297B72657475726E20622E7465726D3D622E7465726D7C7C22222C622E7465726D2E6C656E6774683C746869732E6D696E696D756D496E7075744C656E6774683F766F696420746869732E747269676765722822726573756C74733A6D657373';
wwv_flow_api.g_varchar2_table(408) := '616765222C7B6D6573736167653A22696E707574546F6F53686F7274222C617267733A7B6D696E696D756D3A746869732E6D696E696D756D496E7075744C656E6774682C696E7075743A622E7465726D2C706172616D733A627D7D293A766F696420612E';
wwv_flow_api.g_varchar2_table(409) := '63616C6C28746869732C622C63297D2C617D292C622E646566696E65282273656C656374322F646174612F6D6178696D756D496E7075744C656E677468222C5B5D2C66756E6374696F6E28297B66756E6374696F6E206128612C622C63297B746869732E';
wwv_flow_api.g_varchar2_table(410) := '6D6178696D756D496E7075744C656E6774683D632E67657428226D6178696D756D496E7075744C656E67746822292C612E63616C6C28746869732C622C63297D72657475726E20612E70726F746F747970652E71756572793D66756E6374696F6E28612C';
wwv_flow_api.g_varchar2_table(411) := '622C63297B72657475726E20622E7465726D3D622E7465726D7C7C22222C746869732E6D6178696D756D496E7075744C656E6774683E302626622E7465726D2E6C656E6774683E746869732E6D6178696D756D496E7075744C656E6774683F766F696420';
wwv_flow_api.g_varchar2_table(412) := '746869732E747269676765722822726573756C74733A6D657373616765222C7B6D6573736167653A22696E707574546F6F4C6F6E67222C617267733A7B6D6178696D756D3A746869732E6D6178696D756D496E7075744C656E6774682C696E7075743A62';
wwv_flow_api.g_varchar2_table(413) := '2E7465726D2C706172616D733A627D7D293A766F696420612E63616C6C28746869732C622C63297D2C617D292C622E646566696E65282273656C656374322F646174612F6D6178696D756D53656C656374696F6E4C656E677468222C5B5D2C66756E6374';
wwv_flow_api.g_varchar2_table(414) := '696F6E28297B66756E6374696F6E206128612C622C63297B746869732E6D6178696D756D53656C656374696F6E4C656E6774683D632E67657428226D6178696D756D53656C656374696F6E4C656E67746822292C612E63616C6C28746869732C622C6329';
wwv_flow_api.g_varchar2_table(415) := '7D72657475726E20612E70726F746F747970652E71756572793D66756E6374696F6E28612C622C63297B76617220643D746869733B746869732E63757272656E742866756E6374696F6E2865297B76617220663D6E756C6C213D653F652E6C656E677468';
wwv_flow_api.g_varchar2_table(416) := '3A303B72657475726E20642E6D6178696D756D53656C656374696F6E4C656E6774683E302626663E3D642E6D6178696D756D53656C656374696F6E4C656E6774683F766F696420642E747269676765722822726573756C74733A6D657373616765222C7B';
wwv_flow_api.g_varchar2_table(417) := '6D6573736167653A226D6178696D756D53656C6563746564222C617267733A7B6D6178696D756D3A642E6D6178696D756D53656C656374696F6E4C656E6774687D7D293A766F696420612E63616C6C28642C622C63297D297D2C617D292C622E64656669';
wwv_flow_api.g_varchar2_table(418) := '6E65282273656C656374322F64726F70646F776E222C5B226A7175657279222C222E2F7574696C73225D2C66756E6374696F6E28612C62297B66756E6374696F6E206328612C62297B746869732E24656C656D656E743D612C746869732E6F7074696F6E';
wwv_flow_api.g_varchar2_table(419) := '733D622C632E5F5F73757065725F5F2E636F6E7374727563746F722E63616C6C2874686973297D72657475726E20622E457874656E6428632C622E4F627365727661626C65292C632E70726F746F747970652E72656E6465723D66756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(420) := '7B76617220623D6128273C7370616E20636C6173733D2273656C656374322D64726F70646F776E223E3C7370616E20636C6173733D2273656C656374322D726573756C7473223E3C2F7370616E3E3C2F7370616E3E27293B72657475726E20622E617474';
wwv_flow_api.g_varchar2_table(421) := '722822646972222C746869732E6F7074696F6E732E67657428226469722229292C746869732E2464726F70646F776E3D622C627D2C632E70726F746F747970652E62696E643D66756E6374696F6E28297B7D2C632E70726F746F747970652E706F736974';
wwv_flow_api.g_varchar2_table(422) := '696F6E3D66756E6374696F6E28612C62297B7D2C632E70726F746F747970652E64657374726F793D66756E6374696F6E28297B746869732E2464726F70646F776E2E72656D6F766528297D2C637D292C622E646566696E65282273656C656374322F6472';
wwv_flow_api.g_varchar2_table(423) := '6F70646F776E2F736561726368222C5B226A7175657279222C222E2E2F7574696C73225D2C66756E6374696F6E28612C62297B66756E6374696F6E206328297B7D72657475726E20632E70726F746F747970652E72656E6465723D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(424) := '62297B76617220633D622E63616C6C2874686973292C643D6128273C7370616E20636C6173733D2273656C656374322D7365617263682073656C656374322D7365617263682D2D64726F70646F776E223E3C696E70757420636C6173733D2273656C6563';
wwv_flow_api.g_varchar2_table(425) := '74322D7365617263685F5F6669656C642220747970653D227365617263682220746162696E6465783D222D3122206175746F636F6D706C6574653D226F666622206175746F636F72726563743D226F666622206175746F6361706974616C697A653D226F';
wwv_flow_api.g_varchar2_table(426) := '666622207370656C6C636865636B3D2266616C73652220726F6C653D2274657874626F7822202F3E3C2F7370616E3E27293B72657475726E20746869732E24736561726368436F6E7461696E65723D642C746869732E247365617263683D642E66696E64';
wwv_flow_api.g_varchar2_table(427) := '2822696E70757422292C632E70726570656E642864292C637D2C632E70726F746F747970652E62696E643D66756E6374696F6E28622C632C64297B76617220653D746869733B622E63616C6C28746869732C632C64292C746869732E247365617263682E';
wwv_flow_api.g_varchar2_table(428) := '6F6E28226B6579646F776E222C66756E6374696F6E2861297B652E7472696767657228226B65797072657373222C61292C652E5F6B6579557050726576656E7465643D612E697344656661756C7450726576656E74656428297D292C746869732E247365';
wwv_flow_api.g_varchar2_table(429) := '617263682E6F6E2822696E707574222C66756E6374696F6E2862297B612874686973292E6F666628226B6579757022297D292C746869732E247365617263682E6F6E28226B6579757020696E707574222C66756E6374696F6E2861297B652E68616E646C';
wwv_flow_api.g_varchar2_table(430) := '655365617263682861297D292C632E6F6E28226F70656E222C66756E6374696F6E28297B652E247365617263682E617474722822746162696E646578222C30292C652E247365617263682E666F63757328292C77696E646F772E73657454696D656F7574';
wwv_flow_api.g_varchar2_table(431) := '2866756E6374696F6E28297B652E247365617263682E666F63757328297D2C30297D292C632E6F6E2822636C6F7365222C66756E6374696F6E28297B652E247365617263682E617474722822746162696E646578222C2D31292C652E247365617263682E';
wwv_flow_api.g_varchar2_table(432) := '76616C282222297D292C632E6F6E2822666F637573222C66756E6374696F6E28297B632E69734F70656E28292626652E247365617263682E666F63757328297D292C632E6F6E2822726573756C74733A616C6C222C66756E6374696F6E2861297B696628';
wwv_flow_api.g_varchar2_table(433) := '6E756C6C3D3D612E71756572792E7465726D7C7C22223D3D3D612E71756572792E7465726D297B76617220623D652E73686F775365617263682861293B623F652E24736561726368436F6E7461696E65722E72656D6F7665436C617373282273656C6563';
wwv_flow_api.g_varchar2_table(434) := '74322D7365617263682D2D6869646522293A652E24736561726368436F6E7461696E65722E616464436C617373282273656C656374322D7365617263682D2D6869646522297D7D297D2C632E70726F746F747970652E68616E646C655365617263683D66';
wwv_flow_api.g_varchar2_table(435) := '756E6374696F6E2861297B69662821746869732E5F6B6579557050726576656E746564297B76617220623D746869732E247365617263682E76616C28293B746869732E7472696767657228227175657279222C7B7465726D3A627D297D746869732E5F6B';
wwv_flow_api.g_varchar2_table(436) := '6579557050726576656E7465643D21317D2C632E70726F746F747970652E73686F775365617263683D66756E6374696F6E28612C62297B72657475726E21307D2C637D292C622E646566696E65282273656C656374322F64726F70646F776E2F68696465';
wwv_flow_api.g_varchar2_table(437) := '506C616365686F6C646572222C5B5D2C66756E6374696F6E28297B66756E6374696F6E206128612C622C632C64297B746869732E706C616365686F6C6465723D746869732E6E6F726D616C697A65506C616365686F6C64657228632E6765742822706C61';
wwv_flow_api.g_varchar2_table(438) := '6365686F6C6465722229292C612E63616C6C28746869732C622C632C64297D72657475726E20612E70726F746F747970652E617070656E643D66756E6374696F6E28612C62297B622E726573756C74733D746869732E72656D6F7665506C616365686F6C';
wwv_flow_api.g_varchar2_table(439) := '64657228622E726573756C7473292C612E63616C6C28746869732C62297D2C612E70726F746F747970652E6E6F726D616C697A65506C616365686F6C6465723D66756E6374696F6E28612C62297B72657475726E22737472696E67223D3D747970656F66';
wwv_flow_api.g_varchar2_table(440) := '2062262628623D7B69643A22222C746578743A627D292C627D2C612E70726F746F747970652E72656D6F7665506C616365686F6C6465723D66756E6374696F6E28612C62297B666F722876617220633D622E736C6963652830292C643D622E6C656E6774';
wwv_flow_api.g_varchar2_table(441) := '682D313B643E3D303B642D2D297B76617220653D625B645D3B746869732E706C616365686F6C6465722E69643D3D3D652E69642626632E73706C69636528642C31297D72657475726E20637D2C617D292C622E646566696E65282273656C656374322F64';
wwv_flow_api.g_varchar2_table(442) := '726F70646F776E2F696E66696E6974655363726F6C6C222C5B226A7175657279225D2C66756E6374696F6E2861297B66756E6374696F6E206228612C622C632C64297B746869732E6C617374506172616D733D7B7D2C612E63616C6C28746869732C622C';
wwv_flow_api.g_varchar2_table(443) := '632C64292C746869732E246C6F6164696E674D6F72653D746869732E6372656174654C6F6164696E674D6F726528292C746869732E6C6F6164696E673D21317D72657475726E20622E70726F746F747970652E617070656E643D66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(444) := '2C62297B746869732E246C6F6164696E674D6F72652E72656D6F766528292C746869732E6C6F6164696E673D21312C612E63616C6C28746869732C62292C746869732E73686F774C6F6164696E674D6F72652862292626746869732E24726573756C7473';
wwv_flow_api.g_varchar2_table(445) := '2E617070656E6428746869732E246C6F6164696E674D6F7265297D2C622E70726F746F747970652E62696E643D66756E6374696F6E28622C632C64297B76617220653D746869733B622E63616C6C28746869732C632C64292C632E6F6E28227175657279';
wwv_flow_api.g_varchar2_table(446) := '222C66756E6374696F6E2861297B652E6C617374506172616D733D612C652E6C6F6164696E673D21307D292C632E6F6E282271756572793A617070656E64222C66756E6374696F6E2861297B652E6C617374506172616D733D612C652E6C6F6164696E67';
wwv_flow_api.g_varchar2_table(447) := '3D21307D292C746869732E24726573756C74732E6F6E28227363726F6C6C222C66756E6374696F6E28297B76617220623D612E636F6E7461696E7328646F63756D656E742E646F63756D656E74456C656D656E742C652E246C6F6164696E674D6F72655B';
wwv_flow_api.g_varchar2_table(448) := '305D293B69662821652E6C6F6164696E67262662297B76617220633D652E24726573756C74732E6F666673657428292E746F702B652E24726573756C74732E6F75746572486569676874282131292C643D652E246C6F6164696E674D6F72652E6F666673';
wwv_flow_api.g_varchar2_table(449) := '657428292E746F702B652E246C6F6164696E674D6F72652E6F75746572486569676874282131293B632B35303E3D642626652E6C6F61644D6F726528297D7D297D2C622E70726F746F747970652E6C6F61644D6F72653D66756E6374696F6E28297B7468';
wwv_flow_api.g_varchar2_table(450) := '69732E6C6F6164696E673D21303B76617220623D612E657874656E64287B7D2C7B706167653A317D2C746869732E6C617374506172616D73293B622E706167652B2B2C746869732E74726967676572282271756572793A617070656E64222C62297D2C62';
wwv_flow_api.g_varchar2_table(451) := '2E70726F746F747970652E73686F774C6F6164696E674D6F72653D66756E6374696F6E28612C62297B72657475726E20622E706167696E6174696F6E2626622E706167696E6174696F6E2E6D6F72657D2C622E70726F746F747970652E6372656174654C';
wwv_flow_api.g_varchar2_table(452) := '6F6164696E674D6F72653D66756E6374696F6E28297B76617220623D6128273C6C6920636C6173733D2273656C656374322D726573756C74735F5F6F7074696F6E2073656C656374322D726573756C74735F5F6F7074696F6E2D2D6C6F61642D6D6F7265';
wwv_flow_api.g_varchar2_table(453) := '22726F6C653D22747265656974656D2220617269612D64697361626C65643D2274727565223E3C2F6C693E27292C633D746869732E6F7074696F6E732E67657428227472616E736C6174696F6E7322292E67657428226C6F6164696E674D6F726522293B';
wwv_flow_api.g_varchar2_table(454) := '72657475726E20622E68746D6C286328746869732E6C617374506172616D7329292C627D2C627D292C622E646566696E65282273656C656374322F64726F70646F776E2F617474616368426F6479222C5B226A7175657279222C222E2E2F7574696C7322';
wwv_flow_api.g_varchar2_table(455) := '5D2C66756E6374696F6E28612C62297B66756E6374696F6E206328622C632C64297B746869732E2464726F70646F776E506172656E743D642E676574282264726F70646F776E506172656E7422297C7C6128646F63756D656E742E626F6479292C622E63';
wwv_flow_api.g_varchar2_table(456) := '616C6C28746869732C632C64297D72657475726E20632E70726F746F747970652E62696E643D66756E6374696F6E28612C622C63297B76617220643D746869732C653D21313B612E63616C6C28746869732C622C63292C622E6F6E28226F70656E222C66';
wwv_flow_api.g_varchar2_table(457) := '756E6374696F6E28297B642E5F73686F7744726F70646F776E28292C642E5F617474616368506F736974696F6E696E6748616E646C65722862292C657C7C28653D21302C622E6F6E2822726573756C74733A616C6C222C66756E6374696F6E28297B642E';
wwv_flow_api.g_varchar2_table(458) := '5F706F736974696F6E44726F70646F776E28292C642E5F726573697A6544726F70646F776E28297D292C622E6F6E2822726573756C74733A617070656E64222C66756E6374696F6E28297B642E5F706F736974696F6E44726F70646F776E28292C642E5F';
wwv_flow_api.g_varchar2_table(459) := '726573697A6544726F70646F776E28297D29297D292C622E6F6E2822636C6F7365222C66756E6374696F6E28297B642E5F6869646544726F70646F776E28292C642E5F646574616368506F736974696F6E696E6748616E646C65722862297D292C746869';
wwv_flow_api.g_varchar2_table(460) := '732E2464726F70646F776E436F6E7461696E65722E6F6E28226D6F757365646F776E222C66756E6374696F6E2861297B612E73746F7050726F7061676174696F6E28297D297D2C632E70726F746F747970652E64657374726F793D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(461) := '61297B612E63616C6C2874686973292C746869732E2464726F70646F776E436F6E7461696E65722E72656D6F766528297D2C632E70726F746F747970652E706F736974696F6E3D66756E6374696F6E28612C622C63297B622E617474722822636C617373';
wwv_flow_api.g_varchar2_table(462) := '222C632E617474722822636C6173732229292C622E72656D6F7665436C617373282273656C6563743222292C622E616464436C617373282273656C656374322D636F6E7461696E65722D2D6F70656E22292C622E637373287B706F736974696F6E3A2261';
wwv_flow_api.g_varchar2_table(463) := '62736F6C757465222C746F703A2D3939393939397D292C746869732E24636F6E7461696E65723D637D2C632E70726F746F747970652E72656E6465723D66756E6374696F6E2862297B76617220633D6128223C7370616E3E3C2F7370616E3E22292C643D';
wwv_flow_api.g_varchar2_table(464) := '622E63616C6C2874686973293B72657475726E20632E617070656E642864292C746869732E2464726F70646F776E436F6E7461696E65723D632C637D2C632E70726F746F747970652E5F6869646544726F70646F776E3D66756E6374696F6E2861297B74';
wwv_flow_api.g_varchar2_table(465) := '6869732E2464726F70646F776E436F6E7461696E65722E64657461636828297D2C632E70726F746F747970652E5F617474616368506F736974696F6E696E6748616E646C65723D66756E6374696F6E28632C64297B76617220653D746869732C663D2273';
wwv_flow_api.g_varchar2_table(466) := '63726F6C6C2E73656C656374322E222B642E69642C673D22726573697A652E73656C656374322E222B642E69642C683D226F7269656E746174696F6E6368616E67652E73656C656374322E222B642E69642C693D746869732E24636F6E7461696E65722E';
wwv_flow_api.g_varchar2_table(467) := '706172656E747328292E66696C74657228622E6861735363726F6C6C293B692E656163682866756E6374696F6E28297B612874686973292E64617461282273656C656374322D7363726F6C6C2D706F736974696F6E222C7B783A612874686973292E7363';
wwv_flow_api.g_varchar2_table(468) := '726F6C6C4C65667428292C793A612874686973292E7363726F6C6C546F7028297D297D292C692E6F6E28662C66756E6374696F6E2862297B76617220633D612874686973292E64617461282273656C656374322D7363726F6C6C2D706F736974696F6E22';
wwv_flow_api.g_varchar2_table(469) := '293B612874686973292E7363726F6C6C546F7028632E79297D292C612877696E646F77292E6F6E28662B2220222B672B2220222B682C66756E6374696F6E2861297B652E5F706F736974696F6E44726F70646F776E28292C652E5F726573697A6544726F';
wwv_flow_api.g_varchar2_table(470) := '70646F776E28297D297D2C632E70726F746F747970652E5F646574616368506F736974696F6E696E6748616E646C65723D66756E6374696F6E28632C64297B76617220653D227363726F6C6C2E73656C656374322E222B642E69642C663D22726573697A';
wwv_flow_api.g_varchar2_table(471) := '652E73656C656374322E222B642E69642C673D226F7269656E746174696F6E6368616E67652E73656C656374322E222B642E69642C683D746869732E24636F6E7461696E65722E706172656E747328292E66696C74657228622E6861735363726F6C6C29';
wwv_flow_api.g_varchar2_table(472) := '3B682E6F66662865292C612877696E646F77292E6F666628652B2220222B662B2220222B67297D2C632E70726F746F747970652E5F706F736974696F6E44726F70646F776E3D66756E6374696F6E28297B76617220623D612877696E646F77292C633D74';
wwv_flow_api.g_varchar2_table(473) := '6869732E2464726F70646F776E2E686173436C617373282273656C656374322D64726F70646F776E2D2D61626F766522292C643D746869732E2464726F70646F776E2E686173436C617373282273656C656374322D64726F70646F776E2D2D62656C6F77';
wwv_flow_api.g_varchar2_table(474) := '22292C653D6E756C6C2C663D746869732E24636F6E7461696E65722E6F666673657428293B662E626F74746F6D3D662E746F702B746869732E24636F6E7461696E65722E6F75746572486569676874282131293B76617220673D7B6865696768743A7468';
wwv_flow_api.g_varchar2_table(475) := '69732E24636F6E7461696E65722E6F75746572486569676874282131297D3B672E746F703D662E746F702C672E626F74746F6D3D662E746F702B672E6865696768743B76617220683D7B6865696768743A746869732E2464726F70646F776E2E6F757465';
wwv_flow_api.g_varchar2_table(476) := '72486569676874282131297D2C693D7B746F703A622E7363726F6C6C546F7028292C626F74746F6D3A622E7363726F6C6C546F7028292B622E68656967687428297D2C6A3D692E746F703C662E746F702D682E6865696768742C6B3D692E626F74746F6D';
wwv_flow_api.g_varchar2_table(477) := '3E662E626F74746F6D2B682E6865696768742C6C3D7B6C6566743A662E6C6566742C746F703A672E626F74746F6D7D2C6D3D746869732E2464726F70646F776E506172656E743B22737461746963223D3D3D6D2E6373732822706F736974696F6E222926';
wwv_flow_api.g_varchar2_table(478) := '26286D3D6D2E6F6666736574506172656E742829293B766172206E3D6D2E6F666673657428293B6C2E746F702D3D6E2E746F702C6C2E6C6566742D3D6E2E6C6566742C637C7C647C7C28653D2262656C6F7722292C6B7C7C216A7C7C633F216A26266B26';
wwv_flow_api.g_varchar2_table(479) := '2663262628653D2262656C6F7722293A653D2261626F7665222C282261626F7665223D3D657C7C6326262262656C6F7722213D3D65292626286C2E746F703D672E746F702D6E2E746F702D682E686569676874292C6E756C6C213D65262628746869732E';
wwv_flow_api.g_varchar2_table(480) := '2464726F70646F776E2E72656D6F7665436C617373282273656C656374322D64726F70646F776E2D2D62656C6F772073656C656374322D64726F70646F776E2D2D61626F766522292E616464436C617373282273656C656374322D64726F70646F776E2D';
wwv_flow_api.g_varchar2_table(481) := '2D222B65292C746869732E24636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D636F6E7461696E65722D2D62656C6F772073656C656374322D636F6E7461696E65722D2D61626F766522292E616464436C617373282273656C';
wwv_flow_api.g_varchar2_table(482) := '656374322D636F6E7461696E65722D2D222B6529292C746869732E2464726F70646F776E436F6E7461696E65722E637373286C297D2C632E70726F746F747970652E5F726573697A6544726F70646F776E3D66756E6374696F6E28297B76617220613D7B';
wwv_flow_api.g_varchar2_table(483) := '77696474683A746869732E24636F6E7461696E65722E6F757465725769647468282131292B227078227D3B746869732E6F7074696F6E732E676574282264726F70646F776E4175746F57696474682229262628612E6D696E57696474683D612E77696474';
wwv_flow_api.g_varchar2_table(484) := '682C612E706F736974696F6E3D2272656C6174697665222C612E77696474683D226175746F22292C746869732E2464726F70646F776E2E6373732861297D2C632E70726F746F747970652E5F73686F7744726F70646F776E3D66756E6374696F6E286129';
wwv_flow_api.g_varchar2_table(485) := '7B746869732E2464726F70646F776E436F6E7461696E65722E617070656E64546F28746869732E2464726F70646F776E506172656E74292C746869732E5F706F736974696F6E44726F70646F776E28292C746869732E5F726573697A6544726F70646F77';
wwv_flow_api.g_varchar2_table(486) := '6E28297D2C637D292C622E646566696E65282273656C656374322F64726F70646F776E2F6D696E696D756D526573756C7473466F72536561726368222C5B5D2C66756E6374696F6E28297B66756E6374696F6E20612862297B666F722876617220633D30';
wwv_flow_api.g_varchar2_table(487) := '2C643D303B643C622E6C656E6774683B642B2B297B76617220653D625B645D3B652E6368696C6472656E3F632B3D6128652E6368696C6472656E293A632B2B7D72657475726E20637D66756E6374696F6E206228612C622C632C64297B746869732E6D69';
wwv_flow_api.g_varchar2_table(488) := '6E696D756D526573756C7473466F725365617263683D632E67657428226D696E696D756D526573756C7473466F7253656172636822292C746869732E6D696E696D756D526573756C7473466F725365617263683C30262628746869732E6D696E696D756D';
wwv_flow_api.g_varchar2_table(489) := '526573756C7473466F725365617263683D312F30292C612E63616C6C28746869732C622C632C64297D72657475726E20622E70726F746F747970652E73686F775365617263683D66756E6374696F6E28622C63297B72657475726E206128632E64617461';
wwv_flow_api.g_varchar2_table(490) := '2E726573756C7473293C746869732E6D696E696D756D526573756C7473466F725365617263683F21313A622E63616C6C28746869732C63297D2C627D292C622E646566696E65282273656C656374322F64726F70646F776E2F73656C6563744F6E436C6F';
wwv_flow_api.g_varchar2_table(491) := '7365222C5B5D2C66756E6374696F6E28297B66756E6374696F6E206128297B7D72657475726E20612E70726F746F747970652E62696E643D66756E6374696F6E28612C622C63297B76617220643D746869733B612E63616C6C28746869732C622C63292C';
wwv_flow_api.g_varchar2_table(492) := '622E6F6E2822636C6F7365222C66756E6374696F6E2861297B642E5F68616E646C6553656C6563744F6E436C6F73652861297D297D2C612E70726F746F747970652E5F68616E646C6553656C6563744F6E436C6F73653D66756E6374696F6E28612C6229';
wwv_flow_api.g_varchar2_table(493) := '7B6966286226266E756C6C213D622E6F726967696E616C53656C656374324576656E74297B76617220633D622E6F726967696E616C53656C656374324576656E743B6966282273656C656374223D3D3D632E5F747970657C7C22756E73656C656374223D';
wwv_flow_api.g_varchar2_table(494) := '3D3D632E5F747970652972657475726E7D76617220643D746869732E676574486967686C696768746564526573756C747328293B6966282128642E6C656E6774683C3129297B76617220653D642E6461746128226461746122293B6E756C6C213D652E65';
wwv_flow_api.g_varchar2_table(495) := '6C656D656E742626652E656C656D656E742E73656C65637465647C7C6E756C6C3D3D652E656C656D656E742626652E73656C65637465647C7C746869732E74726967676572282273656C656374222C7B646174613A657D297D7D2C617D292C622E646566';
wwv_flow_api.g_varchar2_table(496) := '696E65282273656C656374322F64726F70646F776E2F636C6F73654F6E53656C656374222C5B5D2C66756E6374696F6E28297B66756E6374696F6E206128297B7D72657475726E20612E70726F746F747970652E62696E643D66756E6374696F6E28612C';
wwv_flow_api.g_varchar2_table(497) := '622C63297B76617220643D746869733B612E63616C6C28746869732C622C63292C622E6F6E282273656C656374222C66756E6374696F6E2861297B642E5F73656C6563745472696767657265642861297D292C622E6F6E2822756E73656C656374222C66';
wwv_flow_api.g_varchar2_table(498) := '756E6374696F6E2861297B642E5F73656C6563745472696767657265642861297D297D2C612E70726F746F747970652E5F73656C6563745472696767657265643D66756E6374696F6E28612C62297B76617220633D622E6F726967696E616C4576656E74';
wwv_flow_api.g_varchar2_table(499) := '3B632626632E6374726C4B65797C7C746869732E747269676765722822636C6F7365222C7B6F726967696E616C4576656E743A632C6F726967696E616C53656C656374324576656E743A627D297D2C617D292C622E646566696E65282273656C65637432';
wwv_flow_api.g_varchar2_table(500) := '2F6931386E2F656E222C5B5D2C66756E6374696F6E28297B72657475726E7B6572726F724C6F6164696E673A66756E6374696F6E28297B72657475726E2254686520726573756C747320636F756C64206E6F74206265206C6F616465642E227D2C696E70';
wwv_flow_api.g_varchar2_table(501) := '7574546F6F4C6F6E673A66756E6374696F6E2861297B76617220623D612E696E7075742E6C656E6774682D612E6D6178696D756D2C633D22506C656173652064656C65746520222B622B2220636861726163746572223B72657475726E2031213D622626';
wwv_flow_api.g_varchar2_table(502) := '28632B3D227322292C637D2C696E707574546F6F53686F72743A66756E6374696F6E2861297B76617220623D612E6D696E696D756D2D612E696E7075742E6C656E6774682C633D22506C6561736520656E74657220222B622B22206F72206D6F72652063';
wwv_flow_api.g_varchar2_table(503) := '686172616374657273223B72657475726E20637D2C6C6F6164696E674D6F72653A66756E6374696F6E28297B72657475726E224C6F6164696E67206D6F726520726573756C7473E280A6227D2C6D6178696D756D53656C65637465643A66756E6374696F';
wwv_flow_api.g_varchar2_table(504) := '6E2861297B76617220623D22596F752063616E206F6E6C792073656C65637420222B612E6D6178696D756D2B22206974656D223B72657475726E2031213D612E6D6178696D756D262628622B3D227322292C627D2C6E6F526573756C74733A66756E6374';
wwv_flow_api.g_varchar2_table(505) := '696F6E28297B72657475726E224E6F20726573756C747320666F756E64227D2C736561726368696E673A66756E6374696F6E28297B72657475726E22536561726368696E67E280A6227D7D7D292C622E646566696E65282273656C656374322F64656661';
wwv_flow_api.g_varchar2_table(506) := '756C7473222C5B226A7175657279222C2272657175697265222C222E2F726573756C7473222C222E2F73656C656374696F6E2F73696E676C65222C222E2F73656C656374696F6E2F6D756C7469706C65222C222E2F73656C656374696F6E2F706C616365';
wwv_flow_api.g_varchar2_table(507) := '686F6C646572222C222E2F73656C656374696F6E2F616C6C6F77436C656172222C222E2F73656C656374696F6E2F736561726368222C222E2F73656C656374696F6E2F6576656E7452656C6179222C222E2F7574696C73222C222E2F7472616E736C6174';
wwv_flow_api.g_varchar2_table(508) := '696F6E222C222E2F64696163726974696373222C222E2F646174612F73656C656374222C222E2F646174612F6172726179222C222E2F646174612F616A6178222C222E2F646174612F74616773222C222E2F646174612F746F6B656E697A6572222C222E';
wwv_flow_api.g_varchar2_table(509) := '2F646174612F6D696E696D756D496E7075744C656E677468222C222E2F646174612F6D6178696D756D496E7075744C656E677468222C222E2F646174612F6D6178696D756D53656C656374696F6E4C656E677468222C222E2F64726F70646F776E222C22';
wwv_flow_api.g_varchar2_table(510) := '2E2F64726F70646F776E2F736561726368222C222E2F64726F70646F776E2F68696465506C616365686F6C646572222C222E2F64726F70646F776E2F696E66696E6974655363726F6C6C222C222E2F64726F70646F776E2F617474616368426F6479222C';
wwv_flow_api.g_varchar2_table(511) := '222E2F64726F70646F776E2F6D696E696D756D526573756C7473466F72536561726368222C222E2F64726F70646F776E2F73656C6563744F6E436C6F7365222C222E2F64726F70646F776E2F636C6F73654F6E53656C656374222C222E2F6931386E2F65';
wwv_flow_api.g_varchar2_table(512) := '6E225D2C66756E6374696F6E28612C622C632C642C652C662C672C682C692C6A2C6B2C6C2C6D2C6E2C6F2C702C712C722C732C742C752C762C772C782C792C7A2C412C422C43297B66756E6374696F6E204428297B746869732E726573657428297D442E';
wwv_flow_api.g_varchar2_table(513) := '70726F746F747970652E6170706C793D66756E6374696F6E286C297B6966286C3D612E657874656E642821302C7B7D2C746869732E64656661756C74732C6C292C6E756C6C3D3D6C2E6461746141646170746572297B6966286E756C6C213D6C2E616A61';
wwv_flow_api.g_varchar2_table(514) := '783F6C2E64617461416461707465723D6F3A6E756C6C213D6C2E646174613F6C2E64617461416461707465723D6E3A6C2E64617461416461707465723D6D2C6C2E6D696E696D756D496E7075744C656E6774683E302626286C2E64617461416461707465';
wwv_flow_api.g_varchar2_table(515) := '723D6A2E4465636F72617465286C2E64617461416461707465722C7229292C6C2E6D6178696D756D496E7075744C656E6774683E302626286C2E64617461416461707465723D6A2E4465636F72617465286C2E64617461416461707465722C7329292C6C';
wwv_flow_api.g_varchar2_table(516) := '2E6D6178696D756D53656C656374696F6E4C656E6774683E302626286C2E64617461416461707465723D6A2E4465636F72617465286C2E64617461416461707465722C7429292C6C2E746167732626286C2E64617461416461707465723D6A2E4465636F';
wwv_flow_api.g_varchar2_table(517) := '72617465286C2E64617461416461707465722C7029292C286E756C6C213D6C2E746F6B656E536570617261746F72737C7C6E756C6C213D6C2E746F6B656E697A6572292626286C2E64617461416461707465723D6A2E4465636F72617465286C2E646174';
wwv_flow_api.g_varchar2_table(518) := '61416461707465722C7129292C6E756C6C213D6C2E7175657279297B76617220433D62286C2E616D64426173652B22636F6D7061742F717565727922293B6C2E64617461416461707465723D6A2E4465636F72617465286C2E6461746141646170746572';
wwv_flow_api.g_varchar2_table(519) := '2C43297D6966286E756C6C213D6C2E696E697453656C656374696F6E297B76617220443D62286C2E616D64426173652B22636F6D7061742F696E697453656C656374696F6E22293B6C2E64617461416461707465723D6A2E4465636F72617465286C2E64';
wwv_flow_api.g_varchar2_table(520) := '617461416461707465722C44297D7D6966286E756C6C3D3D6C2E726573756C7473416461707465722626286C2E726573756C7473416461707465723D632C6E756C6C213D6C2E616A61782626286C2E726573756C7473416461707465723D6A2E4465636F';
wwv_flow_api.g_varchar2_table(521) := '72617465286C2E726573756C7473416461707465722C7829292C6E756C6C213D6C2E706C616365686F6C6465722626286C2E726573756C7473416461707465723D6A2E4465636F72617465286C2E726573756C7473416461707465722C7729292C6C2E73';
wwv_flow_api.g_varchar2_table(522) := '656C6563744F6E436C6F73652626286C2E726573756C7473416461707465723D6A2E4465636F72617465286C2E726573756C7473416461707465722C412929292C6E756C6C3D3D6C2E64726F70646F776E41646170746572297B6966286C2E6D756C7469';
wwv_flow_api.g_varchar2_table(523) := '706C65296C2E64726F70646F776E416461707465723D753B656C73657B76617220453D6A2E4465636F7261746528752C76293B6C2E64726F70646F776E416461707465723D457D69662830213D3D6C2E6D696E696D756D526573756C7473466F72536561';
wwv_flow_api.g_varchar2_table(524) := '7263682626286C2E64726F70646F776E416461707465723D6A2E4465636F72617465286C2E64726F70646F776E416461707465722C7A29292C6C2E636C6F73654F6E53656C6563742626286C2E64726F70646F776E416461707465723D6A2E4465636F72';
wwv_flow_api.g_varchar2_table(525) := '617465286C2E64726F70646F776E416461707465722C4229292C6E756C6C213D6C2E64726F70646F776E437373436C6173737C7C6E756C6C213D6C2E64726F70646F776E4373737C7C6E756C6C213D6C2E616461707444726F70646F776E437373436C61';
wwv_flow_api.g_varchar2_table(526) := '7373297B76617220463D62286C2E616D64426173652B22636F6D7061742F64726F70646F776E43737322293B6C2E64726F70646F776E416461707465723D6A2E4465636F72617465286C2E64726F70646F776E416461707465722C46297D6C2E64726F70';
wwv_flow_api.g_varchar2_table(527) := '646F776E416461707465723D6A2E4465636F72617465286C2E64726F70646F776E416461707465722C79297D6966286E756C6C3D3D6C2E73656C656374696F6E41646170746572297B6966286C2E6D756C7469706C653F6C2E73656C656374696F6E4164';
wwv_flow_api.g_varchar2_table(528) := '61707465723D653A6C2E73656C656374696F6E416461707465723D642C6E756C6C213D6C2E706C616365686F6C6465722626286C2E73656C656374696F6E416461707465723D6A2E4465636F72617465286C2E73656C656374696F6E416461707465722C';
wwv_flow_api.g_varchar2_table(529) := '6629292C6C2E616C6C6F77436C6561722626286C2E73656C656374696F6E416461707465723D6A2E4465636F72617465286C2E73656C656374696F6E416461707465722C6729292C6C2E6D756C7469706C652626286C2E73656C656374696F6E41646170';
wwv_flow_api.g_varchar2_table(530) := '7465723D6A2E4465636F72617465286C2E73656C656374696F6E416461707465722C6829292C6E756C6C213D6C2E636F6E7461696E6572437373436C6173737C7C6E756C6C213D6C2E636F6E7461696E65724373737C7C6E756C6C213D6C2E6164617074';
wwv_flow_api.g_varchar2_table(531) := '436F6E7461696E6572437373436C617373297B76617220473D62286C2E616D64426173652B22636F6D7061742F636F6E7461696E657243737322293B6C2E73656C656374696F6E416461707465723D6A2E4465636F72617465286C2E73656C656374696F';
wwv_flow_api.g_varchar2_table(532) := '6E416461707465722C47297D6C2E73656C656374696F6E416461707465723D6A2E4465636F72617465286C2E73656C656374696F6E416461707465722C69297D69662822737472696E67223D3D747970656F66206C2E6C616E6775616765296966286C2E';
wwv_flow_api.g_varchar2_table(533) := '6C616E67756167652E696E6465784F6628222D22293E30297B76617220483D6C2E6C616E67756167652E73706C697428222D22292C493D485B305D3B6C2E6C616E67756167653D5B6C2E6C616E67756167652C495D7D656C7365206C2E6C616E67756167';
wwv_flow_api.g_varchar2_table(534) := '653D5B6C2E6C616E67756167655D3B696628612E69734172726179286C2E6C616E677561676529297B766172204A3D6E6577206B3B6C2E6C616E67756167652E707573682822656E22293B666F7228766172204B3D6C2E6C616E67756167652C4C3D303B';
wwv_flow_api.g_varchar2_table(535) := '4C3C4B2E6C656E6774683B4C2B2B297B766172204D3D4B5B4C5D2C4E3D7B7D3B7472797B4E3D6B2E6C6F616450617468284D297D6361746368284F297B7472797B4D3D746869732E64656661756C74732E616D644C616E6775616765426173652B4D2C4E';
wwv_flow_api.g_varchar2_table(536) := '3D6B2E6C6F616450617468284D297D63617463682850297B6C2E6465627567262677696E646F772E636F6E736F6C652626636F6E736F6C652E7761726E2626636F6E736F6C652E7761726E282753656C656374323A20546865206C616E67756167652066';
wwv_flow_api.g_varchar2_table(537) := '696C6520666F722022272B4D2B272220636F756C64206E6F74206265206175746F6D61746963616C6C79206C6F616465642E20412066616C6C6261636B2077696C6C206265207573656420696E73746561642E27293B636F6E74696E75657D7D4A2E6578';
wwv_flow_api.g_varchar2_table(538) := '74656E64284E297D6C2E7472616E736C6174696F6E733D4A7D656C73657B76617220513D6B2E6C6F61645061746828746869732E64656661756C74732E616D644C616E6775616765426173652B22656E22292C523D6E6577206B286C2E6C616E67756167';
wwv_flow_api.g_varchar2_table(539) := '65293B522E657874656E642851292C6C2E7472616E736C6174696F6E733D527D72657475726E206C7D2C442E70726F746F747970652E72657365743D66756E6374696F6E28297B66756E6374696F6E20622861297B66756E6374696F6E20622861297B72';
wwv_flow_api.g_varchar2_table(540) := '657475726E206C5B615D7C7C617D72657475726E20612E7265706C616365282F5B5E5C75303030302D5C75303037455D2F672C62297D66756E6374696F6E206328642C65297B69662822223D3D3D612E7472696D28642E7465726D292972657475726E20';
wwv_flow_api.g_varchar2_table(541) := '653B696628652E6368696C6472656E2626652E6368696C6472656E2E6C656E6774683E30297B666F722876617220663D612E657874656E642821302C7B7D2C65292C673D652E6368696C6472656E2E6C656E6774682D313B673E3D303B672D2D297B7661';
wwv_flow_api.g_varchar2_table(542) := '7220683D652E6368696C6472656E5B675D2C693D6328642C68293B6E756C6C3D3D692626662E6368696C6472656E2E73706C69636528672C31297D72657475726E20662E6368696C6472656E2E6C656E6774683E303F663A6328642C66297D766172206A';
wwv_flow_api.g_varchar2_table(543) := '3D6228652E74657874292E746F55707065724361736528292C6B3D6228642E7465726D292E746F55707065724361736528293B72657475726E206A2E696E6465784F66286B293E2D313F653A6E756C6C7D746869732E64656661756C74733D7B616D6442';
wwv_flow_api.g_varchar2_table(544) := '6173653A222E2F222C616D644C616E6775616765426173653A222E2F6931386E2F222C636C6F73654F6E53656C6563743A21302C64656275673A21312C64726F70646F776E4175746F57696474683A21312C6573636170654D61726B75703A6A2E657363';
wwv_flow_api.g_varchar2_table(545) := '6170654D61726B75702C6C616E67756167653A432C6D6174636865723A632C6D696E696D756D496E7075744C656E6774683A302C6D6178696D756D496E7075744C656E6774683A302C6D6178696D756D53656C656374696F6E4C656E6774683A302C6D69';
wwv_flow_api.g_varchar2_table(546) := '6E696D756D526573756C7473466F725365617263683A302C73656C6563744F6E436C6F73653A21312C736F727465723A66756E6374696F6E2861297B72657475726E20617D2C74656D706C617465526573756C743A66756E6374696F6E2861297B726574';
wwv_flow_api.g_varchar2_table(547) := '75726E20612E746578747D2C74656D706C61746553656C656374696F6E3A66756E6374696F6E2861297B72657475726E20612E746578747D2C7468656D653A2264656661756C74222C77696474683A227265736F6C7665227D7D2C442E70726F746F7479';
wwv_flow_api.g_varchar2_table(548) := '70652E7365743D66756E6374696F6E28622C63297B76617220643D612E63616D656C436173652862292C653D7B7D3B655B645D3D633B76617220663D6A2E5F636F6E76657274446174612865293B612E657874656E6428746869732E64656661756C7473';
wwv_flow_api.g_varchar2_table(549) := '2C66297D3B76617220453D6E657720443B72657475726E20457D292C622E646566696E65282273656C656374322F6F7074696F6E73222C5B2272657175697265222C226A7175657279222C222E2F64656661756C7473222C222E2F7574696C73225D2C66';
wwv_flow_api.g_varchar2_table(550) := '756E6374696F6E28612C622C632C64297B66756E6374696F6E206528622C65297B696628746869732E6F7074696F6E733D622C6E756C6C213D652626746869732E66726F6D456C656D656E742865292C746869732E6F7074696F6E733D632E6170706C79';
wwv_flow_api.g_varchar2_table(551) := '28746869732E6F7074696F6E73292C652626652E69732822696E7075742229297B76617220663D6128746869732E6765742822616D644261736522292B22636F6D7061742F696E7075744461746122293B746869732E6F7074696F6E732E646174614164';
wwv_flow_api.g_varchar2_table(552) := '61707465723D642E4465636F7261746528746869732E6F7074696F6E732E64617461416461707465722C66297D7D72657475726E20652E70726F746F747970652E66726F6D456C656D656E743D66756E6374696F6E2861297B76617220633D5B2273656C';
wwv_flow_api.g_varchar2_table(553) := '65637432225D3B6E756C6C3D3D746869732E6F7074696F6E732E6D756C7469706C65262628746869732E6F7074696F6E732E6D756C7469706C653D612E70726F7028226D756C7469706C652229292C6E756C6C3D3D746869732E6F7074696F6E732E6469';
wwv_flow_api.g_varchar2_table(554) := '7361626C6564262628746869732E6F7074696F6E732E64697361626C65643D612E70726F70282264697361626C65642229292C6E756C6C3D3D746869732E6F7074696F6E732E6C616E6775616765262628612E70726F7028226C616E6722293F74686973';
wwv_flow_api.g_varchar2_table(555) := '2E6F7074696F6E732E6C616E67756167653D612E70726F7028226C616E6722292E746F4C6F7765724361736528293A612E636C6F7365737428225B6C616E675D22292E70726F7028226C616E672229262628746869732E6F7074696F6E732E6C616E6775';
wwv_flow_api.g_varchar2_table(556) := '6167653D612E636C6F7365737428225B6C616E675D22292E70726F7028226C616E67222929292C6E756C6C3D3D746869732E6F7074696F6E732E646972262628612E70726F70282264697222293F746869732E6F7074696F6E732E6469723D612E70726F';
wwv_flow_api.g_varchar2_table(557) := '70282264697222293A612E636C6F7365737428225B6469725D22292E70726F70282264697222293F746869732E6F7074696F6E732E6469723D612E636C6F7365737428225B6469725D22292E70726F70282264697222293A746869732E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(558) := '2E6469723D226C747222292C612E70726F70282264697361626C6564222C746869732E6F7074696F6E732E64697361626C6564292C612E70726F7028226D756C7469706C65222C746869732E6F7074696F6E732E6D756C7469706C65292C612E64617461';
wwv_flow_api.g_varchar2_table(559) := '282273656C65637432546167732229262628746869732E6F7074696F6E732E6465627567262677696E646F772E636F6E736F6C652626636F6E736F6C652E7761726E2626636F6E736F6C652E7761726E282753656C656374323A20546865206064617461';
wwv_flow_api.g_varchar2_table(560) := '2D73656C656374322D74616773602061747472696275746520686173206265656E206368616E67656420746F20757365207468652060646174612D646174616020616E642060646174612D746167733D2274727565226020617474726962757465732061';
wwv_flow_api.g_varchar2_table(561) := '6E642077696C6C2062652072656D6F76656420696E206675747572652076657273696F6E73206F662053656C656374322E27292C612E64617461282264617461222C612E64617461282273656C65637432546167732229292C612E646174612822746167';
wwv_flow_api.g_varchar2_table(562) := '73222C213029292C612E646174612822616A617855726C2229262628746869732E6F7074696F6E732E6465627567262677696E646F772E636F6E736F6C652626636F6E736F6C652E7761726E2626636F6E736F6C652E7761726E282253656C656374323A';
wwv_flow_api.g_varchar2_table(563) := '205468652060646174612D616A61782D75726C602061747472696275746520686173206265656E206368616E67656420746F2060646174612D616A61782D2D75726C6020616E6420737570706F727420666F7220746865206F6C64206174747269627574';
wwv_flow_api.g_varchar2_table(564) := '652077696C6C2062652072656D6F76656420696E206675747572652076657273696F6E73206F662053656C656374322E22292C612E617474722822616A61782D2D75726C222C612E646174612822616A617855726C2229292C612E646174612822616A61';
wwv_flow_api.g_varchar2_table(565) := '782D2D75726C222C612E646174612822616A617855726C222929293B76617220653D7B7D3B653D622E666E2E6A7175657279262622312E223D3D622E666E2E6A71756572792E73756273747228302C32292626615B305D2E646174617365743F622E6578';
wwv_flow_api.g_varchar2_table(566) := '74656E642821302C7B7D2C615B305D2E646174617365742C612E646174612829293A612E6461746128293B76617220663D622E657874656E642821302C7B7D2C65293B663D642E5F636F6E76657274446174612866293B666F7228766172206720696E20';
wwv_flow_api.g_varchar2_table(567) := '6629622E696E417272617928672C63293E2D317C7C28622E6973506C61696E4F626A65637428746869732E6F7074696F6E735B675D293F622E657874656E6428746869732E6F7074696F6E735B675D2C665B675D293A746869732E6F7074696F6E735B67';
wwv_flow_api.g_varchar2_table(568) := '5D3D665B675D293B72657475726E20746869737D2C652E70726F746F747970652E6765743D66756E6374696F6E2861297B72657475726E20746869732E6F7074696F6E735B615D7D2C652E70726F746F747970652E7365743D66756E6374696F6E28612C';
wwv_flow_api.g_varchar2_table(569) := '62297B746869732E6F7074696F6E735B615D3D627D2C657D292C622E646566696E65282273656C656374322F636F7265222C5B226A7175657279222C222E2F6F7074696F6E73222C222E2F7574696C73222C222E2F6B657973225D2C66756E6374696F6E';
wwv_flow_api.g_varchar2_table(570) := '28612C622C632C64297B76617220653D66756E6374696F6E28612C63297B6E756C6C213D612E64617461282273656C6563743222292626612E64617461282273656C6563743222292E64657374726F7928292C746869732E24656C656D656E743D612C74';
wwv_flow_api.g_varchar2_table(571) := '6869732E69643D746869732E5F67656E657261746549642861292C633D637C7C7B7D2C746869732E6F7074696F6E733D6E6577206228632C61292C652E5F5F73757065725F5F2E636F6E7374727563746F722E63616C6C2874686973293B76617220643D';
wwv_flow_api.g_varchar2_table(572) := '612E617474722822746162696E64657822297C7C303B612E6461746128226F6C642D746162696E646578222C64292C612E617474722822746162696E646578222C222D3122293B76617220663D746869732E6F7074696F6E732E67657428226461746141';
wwv_flow_api.g_varchar2_table(573) := '64617074657222293B746869732E64617461416461707465723D6E6577206628612C746869732E6F7074696F6E73293B76617220673D746869732E72656E64657228293B746869732E5F706C616365436F6E7461696E65722867293B76617220683D7468';
wwv_flow_api.g_varchar2_table(574) := '69732E6F7074696F6E732E676574282273656C656374696F6E4164617074657222293B746869732E73656C656374696F6E3D6E6577206828612C746869732E6F7074696F6E73292C746869732E2473656C656374696F6E3D746869732E73656C65637469';
wwv_flow_api.g_varchar2_table(575) := '6F6E2E72656E64657228292C746869732E73656C656374696F6E2E706F736974696F6E28746869732E2473656C656374696F6E2C67293B76617220693D746869732E6F7074696F6E732E676574282264726F70646F776E4164617074657222293B746869';
wwv_flow_api.g_varchar2_table(576) := '732E64726F70646F776E3D6E6577206928612C746869732E6F7074696F6E73292C746869732E2464726F70646F776E3D746869732E64726F70646F776E2E72656E64657228292C746869732E64726F70646F776E2E706F736974696F6E28746869732E24';
wwv_flow_api.g_varchar2_table(577) := '64726F70646F776E2C67293B766172206A3D746869732E6F7074696F6E732E6765742822726573756C74734164617074657222293B746869732E726573756C74733D6E6577206A28612C746869732E6F7074696F6E732C746869732E6461746141646170';
wwv_flow_api.g_varchar2_table(578) := '746572292C746869732E24726573756C74733D746869732E726573756C74732E72656E64657228292C746869732E726573756C74732E706F736974696F6E28746869732E24726573756C74732C746869732E2464726F70646F776E293B766172206B3D74';
wwv_flow_api.g_varchar2_table(579) := '6869733B746869732E5F62696E64416461707465727328292C746869732E5F7265676973746572446F6D4576656E747328292C746869732E5F7265676973746572446174614576656E747328292C746869732E5F726567697374657253656C656374696F';
wwv_flow_api.g_varchar2_table(580) := '6E4576656E747328292C746869732E5F726567697374657244726F70646F776E4576656E747328292C746869732E5F7265676973746572526573756C74734576656E747328292C746869732E5F72656769737465724576656E747328292C746869732E64';
wwv_flow_api.g_varchar2_table(581) := '617461416461707465722E63757272656E742866756E6374696F6E2861297B6B2E74726967676572282273656C656374696F6E3A757064617465222C7B646174613A617D297D292C612E616464436C617373282273656C656374322D68696464656E2D61';
wwv_flow_api.g_varchar2_table(582) := '636365737369626C6522292C612E617474722822617269612D68696464656E222C227472756522292C746869732E5F73796E634174747269627574657328292C612E64617461282273656C65637432222C74686973297D3B72657475726E20632E457874';
wwv_flow_api.g_varchar2_table(583) := '656E6428652C632E4F627365727661626C65292C652E70726F746F747970652E5F67656E657261746549643D66756E6374696F6E2861297B76617220623D22223B72657475726E20623D6E756C6C213D612E617474722822696422293F612E6174747228';
wwv_flow_api.g_varchar2_table(584) := '22696422293A6E756C6C213D612E6174747228226E616D6522293F612E6174747228226E616D6522292B222D222B632E67656E657261746543686172732832293A632E67656E657261746543686172732834292C623D622E7265706C616365282F283A7C';
wwv_flow_api.g_varchar2_table(585) := '5C2E7C5C5B7C5C5D7C2C292F672C2222292C623D2273656C656374322D222B627D2C652E70726F746F747970652E5F706C616365436F6E7461696E65723D66756E6374696F6E2861297B612E696E73657274416674657228746869732E24656C656D656E';
wwv_flow_api.g_varchar2_table(586) := '74293B76617220623D746869732E5F7265736F6C7665576964746828746869732E24656C656D656E742C746869732E6F7074696F6E732E676574282277696474682229293B6E756C6C213D622626612E63737328227769647468222C62297D2C652E7072';
wwv_flow_api.g_varchar2_table(587) := '6F746F747970652E5F7265736F6C766557696474683D66756E6374696F6E28612C62297B76617220633D2F5E77696474683A28285B2D2B5D3F285B302D395D2A5C2E293F5B302D395D2B292870787C656D7C65787C257C696E7C636D7C6D6D7C70747C70';
wwv_flow_api.g_varchar2_table(588) := '6329292F693B696628227265736F6C7665223D3D62297B76617220643D746869732E5F7265736F6C7665576964746828612C227374796C6522293B72657475726E206E756C6C213D643F643A746869732E5F7265736F6C7665576964746828612C22656C';
wwv_flow_api.g_varchar2_table(589) := '656D656E7422297D69662822656C656D656E74223D3D62297B76617220653D612E6F757465725769647468282131293B72657475726E20303E3D653F226175746F223A652B227078227D696628227374796C65223D3D62297B76617220663D612E617474';
wwv_flow_api.g_varchar2_table(590) := '7228227374796C6522293B69662822737472696E6722213D747970656F6620662972657475726E206E756C6C3B666F722876617220673D662E73706C697428223B22292C683D302C693D672E6C656E6774683B693E683B682B3D31297B766172206A3D67';
wwv_flow_api.g_varchar2_table(591) := '5B685D2E7265706C616365282F5C732F672C2222292C6B3D6A2E6D617463682863293B6966286E756C6C213D3D6B26266B2E6C656E6774683E3D312972657475726E206B5B315D7D72657475726E206E756C6C7D72657475726E20627D2C652E70726F74';
wwv_flow_api.g_varchar2_table(592) := '6F747970652E5F62696E6441646170746572733D66756E6374696F6E28297B746869732E64617461416461707465722E62696E6428746869732C746869732E24636F6E7461696E6572292C746869732E73656C656374696F6E2E62696E6428746869732C';
wwv_flow_api.g_varchar2_table(593) := '746869732E24636F6E7461696E6572292C746869732E64726F70646F776E2E62696E6428746869732C746869732E24636F6E7461696E6572292C746869732E726573756C74732E62696E6428746869732C746869732E24636F6E7461696E6572297D2C65';
wwv_flow_api.g_varchar2_table(594) := '2E70726F746F747970652E5F7265676973746572446F6D4576656E74733D66756E6374696F6E28297B76617220623D746869733B746869732E24656C656D656E742E6F6E28226368616E67652E73656C65637432222C66756E6374696F6E28297B622E64';
wwv_flow_api.g_varchar2_table(595) := '617461416461707465722E63757272656E742866756E6374696F6E2861297B622E74726967676572282273656C656374696F6E3A757064617465222C7B646174613A617D297D297D292C746869732E24656C656D656E742E6F6E2822666F6375732E7365';
wwv_flow_api.g_varchar2_table(596) := '6C65637432222C66756E6374696F6E2861297B622E747269676765722822666F637573222C61297D292C746869732E5F73796E63413D632E62696E6428746869732E5F73796E63417474726962757465732C74686973292C746869732E5F73796E63533D';
wwv_flow_api.g_varchar2_table(597) := '632E62696E6428746869732E5F73796E63537562747265652C74686973292C746869732E24656C656D656E745B305D2E6174746163684576656E742626746869732E24656C656D656E745B305D2E6174746163684576656E7428226F6E70726F70657274';
wwv_flow_api.g_varchar2_table(598) := '796368616E6765222C746869732E5F73796E6341293B76617220643D77696E646F772E4D75746174696F6E4F627365727665727C7C77696E646F772E5765624B69744D75746174696F6E4F627365727665727C7C77696E646F772E4D6F7A4D7574617469';
wwv_flow_api.g_varchar2_table(599) := '6F6E4F627365727665723B6E756C6C213D643F28746869732E5F6F627365727665723D6E657720642866756E6374696F6E2863297B612E6561636828632C622E5F73796E6341292C612E6561636828632C622E5F73796E6353297D292C746869732E5F6F';
wwv_flow_api.g_varchar2_table(600) := '627365727665722E6F62736572766528746869732E24656C656D656E745B305D2C7B617474726962757465733A21302C6368696C644C6973743A21302C737562747265653A21317D29293A746869732E24656C656D656E745B305D2E6164644576656E74';
wwv_flow_api.g_varchar2_table(601) := '4C697374656E6572262628746869732E24656C656D656E745B305D2E6164644576656E744C697374656E65722822444F4D417474724D6F646966696564222C622E5F73796E63412C2131292C746869732E24656C656D656E745B305D2E6164644576656E';
wwv_flow_api.g_varchar2_table(602) := '744C697374656E65722822444F4D4E6F6465496E736572746564222C622E5F73796E63532C2131292C746869732E24656C656D656E745B305D2E6164644576656E744C697374656E65722822444F4D4E6F646552656D6F766564222C622E5F73796E6353';
wwv_flow_api.g_varchar2_table(603) := '2C213129297D2C652E70726F746F747970652E5F7265676973746572446174614576656E74733D66756E6374696F6E28297B76617220613D746869733B746869732E64617461416461707465722E6F6E28222A222C66756E6374696F6E28622C63297B61';
wwv_flow_api.g_varchar2_table(604) := '2E7472696767657228622C63297D297D2C652E70726F746F747970652E5F726567697374657253656C656374696F6E4576656E74733D66756E6374696F6E28297B76617220623D746869732C633D5B22746F67676C65222C22666F637573225D3B746869';
wwv_flow_api.g_varchar2_table(605) := '732E73656C656374696F6E2E6F6E2822746F67676C65222C66756E6374696F6E28297B622E746F67676C6544726F70646F776E28297D292C746869732E73656C656374696F6E2E6F6E2822666F637573222C66756E6374696F6E2861297B622E666F6375';
wwv_flow_api.g_varchar2_table(606) := '732861297D292C746869732E73656C656374696F6E2E6F6E28222A222C66756E6374696F6E28642C65297B2D313D3D3D612E696E417272617928642C63292626622E7472696767657228642C65297D297D2C652E70726F746F747970652E5F7265676973';
wwv_flow_api.g_varchar2_table(607) := '74657244726F70646F776E4576656E74733D66756E6374696F6E28297B76617220613D746869733B746869732E64726F70646F776E2E6F6E28222A222C66756E6374696F6E28622C63297B612E7472696767657228622C63297D297D2C652E70726F746F';
wwv_flow_api.g_varchar2_table(608) := '747970652E5F7265676973746572526573756C74734576656E74733D66756E6374696F6E28297B76617220613D746869733B746869732E726573756C74732E6F6E28222A222C66756E6374696F6E28622C63297B612E7472696767657228622C63297D29';
wwv_flow_api.g_varchar2_table(609) := '7D2C652E70726F746F747970652E5F72656769737465724576656E74733D66756E6374696F6E28297B76617220613D746869733B746869732E6F6E28226F70656E222C66756E6374696F6E28297B612E24636F6E7461696E65722E616464436C61737328';
wwv_flow_api.g_varchar2_table(610) := '2273656C656374322D636F6E7461696E65722D2D6F70656E22297D292C746869732E6F6E2822636C6F7365222C66756E6374696F6E28297B612E24636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D636F6E7461696E65722D';
wwv_flow_api.g_varchar2_table(611) := '2D6F70656E22297D292C746869732E6F6E2822656E61626C65222C66756E6374696F6E28297B612E24636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D636F6E7461696E65722D2D64697361626C656422297D292C74686973';
wwv_flow_api.g_varchar2_table(612) := '2E6F6E282264697361626C65222C66756E6374696F6E28297B612E24636F6E7461696E65722E616464436C617373282273656C656374322D636F6E7461696E65722D2D64697361626C656422297D292C746869732E6F6E2822626C7572222C66756E6374';
wwv_flow_api.g_varchar2_table(613) := '696F6E28297B612E24636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D636F6E7461696E65722D2D666F63757322297D292C746869732E6F6E28227175657279222C66756E6374696F6E2862297B612E69734F70656E28297C';
wwv_flow_api.g_varchar2_table(614) := '7C612E7472696767657228226F70656E222C7B7D292C746869732E64617461416461707465722E717565727928622C66756E6374696F6E2863297B612E747269676765722822726573756C74733A616C6C222C7B646174613A632C71756572793A627D29';
wwv_flow_api.g_varchar2_table(615) := '7D297D292C746869732E6F6E282271756572793A617070656E64222C66756E6374696F6E2862297B746869732E64617461416461707465722E717565727928622C66756E6374696F6E2863297B612E747269676765722822726573756C74733A61707065';
wwv_flow_api.g_varchar2_table(616) := '6E64222C7B646174613A632C71756572793A627D297D297D292C746869732E6F6E28226B65797072657373222C66756E6374696F6E2862297B76617220633D622E77686963683B612E69734F70656E28293F633D3D3D642E4553437C7C633D3D3D642E54';
wwv_flow_api.g_varchar2_table(617) := '41427C7C633D3D3D642E55502626622E616C744B65793F28612E636C6F736528292C622E70726576656E7444656661756C742829293A633D3D3D642E454E5445523F28612E747269676765722822726573756C74733A73656C656374222C7B7D292C622E';
wwv_flow_api.g_varchar2_table(618) := '70726576656E7444656661756C742829293A633D3D3D642E53504143452626622E6374726C4B65793F28612E747269676765722822726573756C74733A746F67676C65222C7B7D292C622E70726576656E7444656661756C742829293A633D3D3D642E55';
wwv_flow_api.g_varchar2_table(619) := '503F28612E747269676765722822726573756C74733A70726576696F7573222C7B7D292C622E70726576656E7444656661756C742829293A633D3D3D642E444F574E262628612E747269676765722822726573756C74733A6E657874222C7B7D292C622E';
wwv_flow_api.g_varchar2_table(620) := '70726576656E7444656661756C742829293A28633D3D3D642E454E5445527C7C633D3D3D642E53504143457C7C633D3D3D642E444F574E2626622E616C744B657929262628612E6F70656E28292C622E70726576656E7444656661756C742829297D297D';
wwv_flow_api.g_varchar2_table(621) := '2C652E70726F746F747970652E5F73796E63417474726962757465733D66756E6374696F6E28297B746869732E6F7074696F6E732E736574282264697361626C6564222C746869732E24656C656D656E742E70726F70282264697361626C65642229292C';
wwv_flow_api.g_varchar2_table(622) := '746869732E6F7074696F6E732E676574282264697361626C656422293F28746869732E69734F70656E28292626746869732E636C6F736528292C746869732E74726967676572282264697361626C65222C7B7D29293A746869732E747269676765722822';
wwv_flow_api.g_varchar2_table(623) := '656E61626C65222C7B7D297D2C652E70726F746F747970652E5F73796E63537562747265653D66756E6374696F6E28612C62297B76617220633D21312C643D746869733B69662821617C7C21612E7461726765747C7C224F5054494F4E223D3D3D612E74';
wwv_flow_api.g_varchar2_table(624) := '61726765742E6E6F64654E616D657C7C224F505447524F5550223D3D3D612E7461726765742E6E6F64654E616D65297B6966286229696628622E61646465644E6F6465732626622E61646465644E6F6465732E6C656E6774683E3029666F722876617220';
wwv_flow_api.g_varchar2_table(625) := '653D303B653C622E61646465644E6F6465732E6C656E6774683B652B2B297B76617220663D622E61646465644E6F6465735B655D3B662E73656C6563746564262628633D2130297D656C736520622E72656D6F7665644E6F6465732626622E72656D6F76';
wwv_flow_api.g_varchar2_table(626) := '65644E6F6465732E6C656E6774683E30262628633D2130293B656C736520633D21303B632626746869732E64617461416461707465722E63757272656E742866756E6374696F6E2861297B642E74726967676572282273656C656374696F6E3A75706461';
wwv_flow_api.g_varchar2_table(627) := '7465222C7B646174613A617D297D297D7D2C652E70726F746F747970652E747269676765723D66756E6374696F6E28612C62297B76617220633D652E5F5F73757065725F5F2E747269676765722C643D7B6F70656E3A226F70656E696E67222C636C6F73';
wwv_flow_api.g_varchar2_table(628) := '653A22636C6F73696E67222C73656C6563743A2273656C656374696E67222C756E73656C6563743A22756E73656C656374696E67227D3B696628766F696420303D3D3D62262628623D7B7D292C6120696E2064297B76617220663D645B615D2C673D7B70';
wwv_flow_api.g_varchar2_table(629) := '726576656E7465643A21312C6E616D653A612C617267733A627D3B696628632E63616C6C28746869732C662C67292C672E70726576656E7465642972657475726E20766F696428622E70726576656E7465643D2130297D632E63616C6C28746869732C61';
wwv_flow_api.g_varchar2_table(630) := '2C62297D2C652E70726F746F747970652E746F67676C6544726F70646F776E3D66756E6374696F6E28297B746869732E6F7074696F6E732E676574282264697361626C656422297C7C28746869732E69734F70656E28293F746869732E636C6F73652829';
wwv_flow_api.g_varchar2_table(631) := '3A746869732E6F70656E2829297D2C652E70726F746F747970652E6F70656E3D66756E6374696F6E28297B746869732E69734F70656E28297C7C746869732E7472696767657228227175657279222C7B7D297D2C652E70726F746F747970652E636C6F73';
wwv_flow_api.g_varchar2_table(632) := '653D66756E6374696F6E28297B746869732E69734F70656E28292626746869732E747269676765722822636C6F7365222C7B7D297D2C652E70726F746F747970652E69734F70656E3D66756E6374696F6E28297B72657475726E20746869732E24636F6E';
wwv_flow_api.g_varchar2_table(633) := '7461696E65722E686173436C617373282273656C656374322D636F6E7461696E65722D2D6F70656E22297D2C652E70726F746F747970652E686173466F6375733D66756E6374696F6E28297B72657475726E20746869732E24636F6E7461696E65722E68';
wwv_flow_api.g_varchar2_table(634) := '6173436C617373282273656C656374322D636F6E7461696E65722D2D666F63757322297D2C652E70726F746F747970652E666F6375733D66756E6374696F6E2861297B746869732E686173466F63757328297C7C28746869732E24636F6E7461696E6572';
wwv_flow_api.g_varchar2_table(635) := '2E616464436C617373282273656C656374322D636F6E7461696E65722D2D666F63757322292C746869732E747269676765722822666F637573222C7B7D29297D2C652E70726F746F747970652E656E61626C653D66756E6374696F6E2861297B74686973';
wwv_flow_api.g_varchar2_table(636) := '2E6F7074696F6E732E676574282264656275672229262677696E646F772E636F6E736F6C652626636F6E736F6C652E7761726E2626636F6E736F6C652E7761726E282753656C656374323A20546865206073656C656374322822656E61626C6522296020';
wwv_flow_api.g_varchar2_table(637) := '6D6574686F6420686173206265656E206465707265636174656420616E642077696C6C2062652072656D6F76656420696E206C617465722053656C656374322076657273696F6E732E205573652024656C656D656E742E70726F70282264697361626C65';
wwv_flow_api.g_varchar2_table(638) := '64222920696E73746561642E27292C286E756C6C3D3D617C7C303D3D3D612E6C656E67746829262628613D5B21305D293B76617220623D21615B305D3B746869732E24656C656D656E742E70726F70282264697361626C6564222C62297D2C652E70726F';
wwv_flow_api.g_varchar2_table(639) := '746F747970652E646174613D66756E6374696F6E28297B746869732E6F7074696F6E732E6765742822646562756722292626617267756D656E74732E6C656E6774683E30262677696E646F772E636F6E736F6C652626636F6E736F6C652E7761726E2626';
wwv_flow_api.g_varchar2_table(640) := '636F6E736F6C652E7761726E282753656C656374323A20446174612063616E206E6F206C6F6E67657220626520736574207573696E67206073656C656374322822646174612229602E20596F752073686F756C6420636F6E73696465722073657474696E';
wwv_flow_api.g_varchar2_table(641) := '67207468652076616C756520696E7374656164207573696E67206024656C656D656E742E76616C2829602E27293B76617220613D5B5D3B72657475726E20746869732E64617461416461707465722E63757272656E742866756E6374696F6E2862297B61';
wwv_flow_api.g_varchar2_table(642) := '3D627D292C617D2C652E70726F746F747970652E76616C3D66756E6374696F6E2862297B696628746869732E6F7074696F6E732E676574282264656275672229262677696E646F772E636F6E736F6C652626636F6E736F6C652E7761726E2626636F6E73';
wwv_flow_api.g_varchar2_table(643) := '6F6C652E7761726E282753656C656374323A20546865206073656C65637432282276616C222960206D6574686F6420686173206265656E206465707265636174656420616E642077696C6C2062652072656D6F76656420696E206C617465722053656C65';
wwv_flow_api.g_varchar2_table(644) := '6374322076657273696F6E732E205573652024656C656D656E742E76616C282920696E73746561642E27292C6E756C6C3D3D627C7C303D3D3D622E6C656E6774682972657475726E20746869732E24656C656D656E742E76616C28293B76617220633D62';
wwv_flow_api.g_varchar2_table(645) := '5B305D3B612E69734172726179286329262628633D612E6D617028632C66756E6374696F6E2861297B72657475726E20612E746F537472696E6728297D29292C746869732E24656C656D656E742E76616C2863292E7472696767657228226368616E6765';
wwv_flow_api.g_varchar2_table(646) := '22297D2C652E70726F746F747970652E64657374726F793D66756E6374696F6E28297B746869732E24636F6E7461696E65722E72656D6F766528292C746869732E24656C656D656E745B305D2E6465746163684576656E742626746869732E24656C656D';
wwv_flow_api.g_varchar2_table(647) := '656E745B305D2E6465746163684576656E7428226F6E70726F70657274796368616E6765222C746869732E5F73796E6341292C6E756C6C213D746869732E5F6F627365727665723F28746869732E5F6F627365727665722E646973636F6E6E6563742829';
wwv_flow_api.g_varchar2_table(648) := '2C746869732E5F6F627365727665723D6E756C6C293A746869732E24656C656D656E745B305D2E72656D6F76654576656E744C697374656E6572262628746869732E24656C656D656E745B305D2E72656D6F76654576656E744C697374656E6572282244';
wwv_flow_api.g_varchar2_table(649) := '4F4D417474724D6F646966696564222C746869732E5F73796E63412C2131292C746869732E24656C656D656E745B305D2E72656D6F76654576656E744C697374656E65722822444F4D4E6F6465496E736572746564222C746869732E5F73796E63532C21';
wwv_flow_api.g_varchar2_table(650) := '31292C746869732E24656C656D656E745B305D2E72656D6F76654576656E744C697374656E65722822444F4D4E6F646552656D6F766564222C746869732E5F73796E63532C213129292C746869732E5F73796E63413D6E756C6C2C746869732E5F73796E';
wwv_flow_api.g_varchar2_table(651) := '63533D6E756C6C2C746869732E24656C656D656E742E6F666628222E73656C6563743222292C746869732E24656C656D656E742E617474722822746162696E646578222C746869732E24656C656D656E742E6461746128226F6C642D746162696E646578';
wwv_flow_api.g_varchar2_table(652) := '2229292C746869732E24656C656D656E742E72656D6F7665436C617373282273656C656374322D68696464656E2D61636365737369626C6522292C746869732E24656C656D656E742E617474722822617269612D68696464656E222C2266616C73652229';
wwv_flow_api.g_varchar2_table(653) := '2C746869732E24656C656D656E742E72656D6F766544617461282273656C6563743222292C746869732E64617461416461707465722E64657374726F7928292C746869732E73656C656374696F6E2E64657374726F7928292C746869732E64726F70646F';
wwv_flow_api.g_varchar2_table(654) := '776E2E64657374726F7928292C746869732E726573756C74732E64657374726F7928292C746869732E64617461416461707465723D6E756C6C2C746869732E73656C656374696F6E3D6E756C6C2C746869732E64726F70646F776E3D6E756C6C2C746869';
wwv_flow_api.g_varchar2_table(655) := '732E726573756C74733D6E756C6C3B0A7D2C652E70726F746F747970652E72656E6465723D66756E6374696F6E28297B76617220623D6128273C7370616E20636C6173733D2273656C656374322073656C656374322D636F6E7461696E6572223E3C7370';
wwv_flow_api.g_varchar2_table(656) := '616E20636C6173733D2273656C656374696F6E223E3C2F7370616E3E3C7370616E20636C6173733D2264726F70646F776E2D777261707065722220617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F7370616E3E27293B7265747572';
wwv_flow_api.g_varchar2_table(657) := '6E20622E617474722822646972222C746869732E6F7074696F6E732E67657428226469722229292C746869732E24636F6E7461696E65723D622C746869732E24636F6E7461696E65722E616464436C617373282273656C656374322D636F6E7461696E65';
wwv_flow_api.g_varchar2_table(658) := '722D2D222B746869732E6F7074696F6E732E67657428227468656D652229292C622E646174612822656C656D656E74222C746869732E24656C656D656E74292C627D2C657D292C622E646566696E65282273656C656374322F636F6D7061742F7574696C';
wwv_flow_api.g_varchar2_table(659) := '73222C5B226A7175657279225D2C66756E6374696F6E2861297B66756E6374696F6E206228622C632C64297B76617220652C662C673D5B5D3B653D612E7472696D28622E617474722822636C6173732229292C65262628653D22222B652C6128652E7370';
wwv_flow_api.g_varchar2_table(660) := '6C6974282F5C732B2F29292E656163682866756E6374696F6E28297B303D3D3D746869732E696E6465784F66282273656C656374322D22292626672E707573682874686973297D29292C653D612E7472696D28632E617474722822636C6173732229292C';
wwv_flow_api.g_varchar2_table(661) := '65262628653D22222B652C6128652E73706C6974282F5C732B2F29292E656163682866756E6374696F6E28297B30213D3D746869732E696E6465784F66282273656C656374322D2229262628663D642874686973292C6E756C6C213D662626672E707573';
wwv_flow_api.g_varchar2_table(662) := '68286629297D29292C622E617474722822636C617373222C672E6A6F696E2822202229297D72657475726E7B73796E63437373436C61737365733A627D7D292C622E646566696E65282273656C656374322F636F6D7061742F636F6E7461696E65724373';
wwv_flow_api.g_varchar2_table(663) := '73222C5B226A7175657279222C222E2F7574696C73225D2C66756E6374696F6E28612C62297B66756E6374696F6E20632861297B72657475726E206E756C6C7D66756E6374696F6E206428297B7D72657475726E20642E70726F746F747970652E72656E';
wwv_flow_api.g_varchar2_table(664) := '6465723D66756E6374696F6E2864297B76617220653D642E63616C6C2874686973292C663D746869732E6F7074696F6E732E6765742822636F6E7461696E6572437373436C61737322297C7C22223B612E697346756E6374696F6E286629262628663D66';
wwv_flow_api.g_varchar2_table(665) := '28746869732E24656C656D656E7429293B76617220673D746869732E6F7074696F6E732E67657428226164617074436F6E7461696E6572437373436C61737322293B696628673D677C7C632C2D31213D3D662E696E6465784F6628223A616C6C3A222929';
wwv_flow_api.g_varchar2_table(666) := '7B663D662E7265706C61636528223A616C6C3A222C2222293B76617220683D673B673D66756E6374696F6E2861297B76617220623D682861293B72657475726E206E756C6C213D623F622B2220222B613A617D7D76617220693D746869732E6F7074696F';
wwv_flow_api.g_varchar2_table(667) := '6E732E6765742822636F6E7461696E657243737322297C7C7B7D3B72657475726E20612E697346756E6374696F6E286929262628693D6928746869732E24656C656D656E7429292C622E73796E63437373436C617373657328652C746869732E24656C65';
wwv_flow_api.g_varchar2_table(668) := '6D656E742C67292C652E6373732869292C652E616464436C6173732866292C657D2C647D292C622E646566696E65282273656C656374322F636F6D7061742F64726F70646F776E437373222C5B226A7175657279222C222E2F7574696C73225D2C66756E';
wwv_flow_api.g_varchar2_table(669) := '6374696F6E28612C62297B66756E6374696F6E20632861297B72657475726E206E756C6C7D66756E6374696F6E206428297B7D72657475726E20642E70726F746F747970652E72656E6465723D66756E6374696F6E2864297B76617220653D642E63616C';
wwv_flow_api.g_varchar2_table(670) := '6C2874686973292C663D746869732E6F7074696F6E732E676574282264726F70646F776E437373436C61737322297C7C22223B612E697346756E6374696F6E286629262628663D6628746869732E24656C656D656E7429293B76617220673D746869732E';
wwv_flow_api.g_varchar2_table(671) := '6F7074696F6E732E6765742822616461707444726F70646F776E437373436C61737322293B696628673D677C7C632C2D31213D3D662E696E6465784F6628223A616C6C3A2229297B663D662E7265706C61636528223A616C6C3A222C2222293B76617220';
wwv_flow_api.g_varchar2_table(672) := '683D673B673D66756E6374696F6E2861297B76617220623D682861293B72657475726E206E756C6C213D623F622B2220222B613A617D7D76617220693D746869732E6F7074696F6E732E676574282264726F70646F776E43737322297C7C7B7D3B726574';
wwv_flow_api.g_varchar2_table(673) := '75726E20612E697346756E6374696F6E286929262628693D6928746869732E24656C656D656E7429292C622E73796E63437373436C617373657328652C746869732E24656C656D656E742C67292C652E6373732869292C652E616464436C617373286629';
wwv_flow_api.g_varchar2_table(674) := '2C657D2C647D292C622E646566696E65282273656C656374322F636F6D7061742F696E697453656C656374696F6E222C5B226A7175657279225D2C66756E6374696F6E2861297B66756E6374696F6E206228612C622C63297B632E676574282264656275';
wwv_flow_api.g_varchar2_table(675) := '672229262677696E646F772E636F6E736F6C652626636F6E736F6C652E7761726E2626636F6E736F6C652E7761726E282253656C656374323A205468652060696E697453656C656374696F6E60206F7074696F6E20686173206265656E20646570726563';
wwv_flow_api.g_varchar2_table(676) := '6174656420696E206661766F72206F66206120637573746F6D206461746120616461707465722074686174206F766572726964657320746865206063757272656E7460206D6574686F642E2054686973206D6574686F64206973206E6F772063616C6C65';
wwv_flow_api.g_varchar2_table(677) := '64206D756C7469706C652074696D657320696E7374656164206F6620612073696E676C652074696D65207768656E2074686520696E7374616E636520697320696E697469616C697A65642E20537570706F72742077696C6C2062652072656D6F76656420';
wwv_flow_api.g_varchar2_table(678) := '666F72207468652060696E697453656C656374696F6E60206F7074696F6E20696E206675747572652076657273696F6E73206F662053656C6563743222292C746869732E696E697453656C656374696F6E3D632E6765742822696E697453656C65637469';
wwv_flow_api.g_varchar2_table(679) := '6F6E22292C746869732E5F6973496E697469616C697A65643D21312C612E63616C6C28746869732C622C63297D72657475726E20622E70726F746F747970652E63757272656E743D66756E6374696F6E28622C63297B76617220643D746869733B726574';
wwv_flow_api.g_varchar2_table(680) := '75726E20746869732E5F6973496E697469616C697A65643F766F696420622E63616C6C28746869732C63293A766F696420746869732E696E697453656C656374696F6E2E63616C6C286E756C6C2C746869732E24656C656D656E742C66756E6374696F6E';
wwv_flow_api.g_varchar2_table(681) := '2862297B642E5F6973496E697469616C697A65643D21302C612E697341727261792862297C7C28623D5B625D292C632862297D297D2C627D292C622E646566696E65282273656C656374322F636F6D7061742F696E70757444617461222C5B226A717565';
wwv_flow_api.g_varchar2_table(682) := '7279225D2C66756E6374696F6E2861297B66756E6374696F6E206228612C622C63297B746869732E5F63757272656E74446174613D5B5D2C746869732E5F76616C7565536570617261746F723D632E676574282276616C7565536570617261746F722229';
wwv_flow_api.g_varchar2_table(683) := '7C7C222C222C2268696464656E223D3D3D622E70726F7028227479706522292626632E6765742822646562756722292626636F6E736F6C652626636F6E736F6C652E7761726E2626636F6E736F6C652E7761726E282253656C656374323A205573696E67';
wwv_flow_api.g_varchar2_table(684) := '20612068696464656E20696E70757420776974682053656C65637432206973206E6F206C6F6E67657220737570706F7274656420616E64206D61792073746F7020776F726B696E6720696E20746865206675747572652E204974206973207265636F6D6D';
wwv_flow_api.g_varchar2_table(685) := '656E64656420746F20757365206120603C73656C6563743E6020656C656D656E7420696E73746561642E22292C612E63616C6C28746869732C622C63297D72657475726E20622E70726F746F747970652E63757272656E743D66756E6374696F6E28622C';
wwv_flow_api.g_varchar2_table(686) := '63297B66756E6374696F6E206428622C63297B76617220653D5B5D3B72657475726E20622E73656C65637465647C7C2D31213D3D612E696E417272617928622E69642C63293F28622E73656C65637465643D21302C652E70757368286229293A622E7365';
wwv_flow_api.g_varchar2_table(687) := '6C65637465643D21312C622E6368696C6472656E2626652E707573682E6170706C7928652C6428622E6368696C6472656E2C6329292C657D666F722876617220653D5B5D2C663D303B663C746869732E5F63757272656E74446174612E6C656E6774683B';
wwv_flow_api.g_varchar2_table(688) := '662B2B297B76617220673D746869732E5F63757272656E74446174615B665D3B652E707573682E6170706C7928652C6428672C746869732E24656C656D656E742E76616C28292E73706C697428746869732E5F76616C7565536570617261746F72292929';
wwv_flow_api.g_varchar2_table(689) := '7D632865297D2C622E70726F746F747970652E73656C6563743D66756E6374696F6E28622C63297B696628746869732E6F7074696F6E732E67657428226D756C7469706C652229297B76617220643D746869732E24656C656D656E742E76616C28293B64';
wwv_flow_api.g_varchar2_table(690) := '2B3D746869732E5F76616C7565536570617261746F722B632E69642C746869732E24656C656D656E742E76616C2864292C746869732E24656C656D656E742E7472696767657228226368616E676522297D656C736520746869732E63757272656E742866';
wwv_flow_api.g_varchar2_table(691) := '756E6374696F6E2862297B612E6D617028622C66756E6374696F6E2861297B612E73656C65637465643D21317D297D292C746869732E24656C656D656E742E76616C28632E6964292C746869732E24656C656D656E742E7472696767657228226368616E';
wwv_flow_api.g_varchar2_table(692) := '676522297D2C622E70726F746F747970652E756E73656C6563743D66756E6374696F6E28612C62297B76617220633D746869733B622E73656C65637465643D21312C746869732E63757272656E742866756E6374696F6E2861297B666F72287661722064';
wwv_flow_api.g_varchar2_table(693) := '3D5B5D2C653D303B653C612E6C656E6774683B652B2B297B76617220663D615B655D3B622E6964213D662E69642626642E7075736828662E6964297D632E24656C656D656E742E76616C28642E6A6F696E28632E5F76616C7565536570617261746F7229';
wwv_flow_api.g_varchar2_table(694) := '292C632E24656C656D656E742E7472696767657228226368616E676522297D297D2C622E70726F746F747970652E71756572793D66756E6374696F6E28612C622C63297B666F722876617220643D5B5D2C653D303B653C746869732E5F63757272656E74';
wwv_flow_api.g_varchar2_table(695) := '446174612E6C656E6774683B652B2B297B76617220663D746869732E5F63757272656E74446174615B655D2C673D746869732E6D61746368657328622C66293B6E756C6C213D3D672626642E707573682867297D63287B726573756C74733A647D297D2C';
wwv_flow_api.g_varchar2_table(696) := '622E70726F746F747970652E6164644F7074696F6E733D66756E6374696F6E28622C63297B76617220643D612E6D617028632C66756E6374696F6E2862297B72657475726E20612E6461746128625B305D2C226461746122297D293B746869732E5F6375';
wwv_flow_api.g_varchar2_table(697) := '7272656E74446174612E707573682E6170706C7928746869732E5F63757272656E74446174612C64297D2C627D292C622E646566696E65282273656C656374322F636F6D7061742F6D617463686572222C5B226A7175657279225D2C66756E6374696F6E';
wwv_flow_api.g_varchar2_table(698) := '2861297B66756E6374696F6E20622862297B66756E6374696F6E206328632C64297B76617220653D612E657874656E642821302C7B7D2C64293B6966286E756C6C3D3D632E7465726D7C7C22223D3D3D612E7472696D28632E7465726D29297265747572';
wwv_flow_api.g_varchar2_table(699) := '6E20653B696628642E6368696C6472656E297B666F722876617220663D642E6368696C6472656E2E6C656E6774682D313B663E3D303B662D2D297B76617220673D642E6368696C6472656E5B665D2C683D6228632E7465726D2C672E746578742C67293B';
wwv_flow_api.g_varchar2_table(700) := '687C7C652E6368696C6472656E2E73706C69636528662C31297D696628652E6368696C6472656E2E6C656E6774683E302972657475726E20657D72657475726E206228632E7465726D2C642E746578742C64293F653A6E756C6C7D72657475726E20637D';
wwv_flow_api.g_varchar2_table(701) := '72657475726E20627D292C622E646566696E65282273656C656374322F636F6D7061742F7175657279222C5B5D2C66756E6374696F6E28297B66756E6374696F6E206128612C622C63297B632E676574282264656275672229262677696E646F772E636F';
wwv_flow_api.g_varchar2_table(702) := '6E736F6C652626636F6E736F6C652E7761726E2626636F6E736F6C652E7761726E282253656C656374323A205468652060717565727960206F7074696F6E20686173206265656E206465707265636174656420696E206661766F72206F66206120637573';
wwv_flow_api.g_varchar2_table(703) := '746F6D206461746120616461707465722074686174206F7665727269646573207468652060717565727960206D6574686F642E20537570706F72742077696C6C2062652072656D6F76656420666F72207468652060717565727960206F7074696F6E2069';
wwv_flow_api.g_varchar2_table(704) := '6E206675747572652076657273696F6E73206F662053656C656374322E22292C612E63616C6C28746869732C622C63297D72657475726E20612E70726F746F747970652E71756572793D66756E6374696F6E28612C622C63297B622E63616C6C6261636B';
wwv_flow_api.g_varchar2_table(705) := '3D633B76617220643D746869732E6F7074696F6E732E6765742822717565727922293B642E63616C6C286E756C6C2C62297D2C617D292C622E646566696E65282273656C656374322F64726F70646F776E2F617474616368436F6E7461696E6572222C5B';
wwv_flow_api.g_varchar2_table(706) := '5D2C66756E6374696F6E28297B66756E6374696F6E206128612C622C63297B612E63616C6C28746869732C622C63297D72657475726E20612E70726F746F747970652E706F736974696F6E3D66756E6374696F6E28612C622C63297B76617220643D632E';
wwv_flow_api.g_varchar2_table(707) := '66696E6428222E64726F70646F776E2D7772617070657222293B642E617070656E642862292C622E616464436C617373282273656C656374322D64726F70646F776E2D2D62656C6F7722292C632E616464436C617373282273656C656374322D636F6E74';
wwv_flow_api.g_varchar2_table(708) := '61696E65722D2D62656C6F7722297D2C617D292C622E646566696E65282273656C656374322F64726F70646F776E2F73746F7050726F7061676174696F6E222C5B5D2C66756E6374696F6E28297B66756E6374696F6E206128297B7D72657475726E2061';
wwv_flow_api.g_varchar2_table(709) := '2E70726F746F747970652E62696E643D66756E6374696F6E28612C622C63297B612E63616C6C28746869732C622C63293B76617220643D5B22626C7572222C226368616E6765222C22636C69636B222C2264626C636C69636B222C22666F637573222C22';
wwv_flow_api.g_varchar2_table(710) := '666F637573696E222C22666F6375736F7574222C22696E707574222C226B6579646F776E222C226B65797570222C226B65797072657373222C226D6F757365646F776E222C226D6F757365656E746572222C226D6F7573656C65617665222C226D6F7573';
wwv_flow_api.g_varchar2_table(711) := '656D6F7665222C226D6F7573656F766572222C226D6F7573657570222C22736561726368222C22746F756368656E64222C22746F7563687374617274225D3B746869732E2464726F70646F776E2E6F6E28642E6A6F696E28222022292C66756E6374696F';
wwv_flow_api.g_varchar2_table(712) := '6E2861297B612E73746F7050726F7061676174696F6E28297D297D2C617D292C622E646566696E65282273656C656374322F73656C656374696F6E2F73746F7050726F7061676174696F6E222C5B5D2C66756E6374696F6E28297B66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(713) := '6128297B7D72657475726E20612E70726F746F747970652E62696E643D66756E6374696F6E28612C622C63297B612E63616C6C28746869732C622C63293B76617220643D5B22626C7572222C226368616E6765222C22636C69636B222C2264626C636C69';
wwv_flow_api.g_varchar2_table(714) := '636B222C22666F637573222C22666F637573696E222C22666F6375736F7574222C22696E707574222C226B6579646F776E222C226B65797570222C226B65797072657373222C226D6F757365646F776E222C226D6F757365656E746572222C226D6F7573';
wwv_flow_api.g_varchar2_table(715) := '656C65617665222C226D6F7573656D6F7665222C226D6F7573656F766572222C226D6F7573657570222C22736561726368222C22746F756368656E64222C22746F7563687374617274225D3B746869732E2473656C656374696F6E2E6F6E28642E6A6F69';
wwv_flow_api.g_varchar2_table(716) := '6E28222022292C66756E6374696F6E2861297B612E73746F7050726F7061676174696F6E28297D297D2C617D292C66756E6374696F6E2863297B2266756E6374696F6E223D3D747970656F6620622E646566696E652626622E646566696E652E616D643F';
wwv_flow_api.g_varchar2_table(717) := '622E646566696E6528226A71756572792D6D6F757365776865656C222C5B226A7175657279225D2C63293A226F626A656374223D3D747970656F66206578706F7274733F6D6F64756C652E6578706F7274733D633A632861297D2866756E6374696F6E28';
wwv_flow_api.g_varchar2_table(718) := '61297B66756E6374696F6E20622862297B76617220673D627C7C77696E646F772E6576656E742C683D692E63616C6C28617267756D656E74732C31292C6A3D302C6C3D302C6D3D302C6E3D302C6F3D302C703D303B696628623D612E6576656E742E6669';
wwv_flow_api.g_varchar2_table(719) := '782867292C622E747970653D226D6F757365776865656C222C2264657461696C22696E20672626286D3D2D312A672E64657461696C292C22776865656C44656C746122696E20672626286D3D672E776865656C44656C7461292C22776865656C44656C74';
wwv_flow_api.g_varchar2_table(720) := '615922696E20672626286D3D672E776865656C44656C746159292C22776865656C44656C74615822696E20672626286C3D2D312A672E776865656C44656C746158292C226178697322696E20672626672E617869733D3D3D672E484F52495A4F4E54414C';
wwv_flow_api.g_varchar2_table(721) := '5F415849532626286C3D2D312A6D2C6D3D30292C6A3D303D3D3D6D3F6C3A6D2C2264656C74615922696E20672626286D3D2D312A672E64656C7461592C6A3D6D292C2264656C74615822696E20672626286C3D672E64656C7461582C303D3D3D6D262628';
wwv_flow_api.g_varchar2_table(722) := '6A3D2D312A6C29292C30213D3D6D7C7C30213D3D6C297B696628313D3D3D672E64656C74614D6F6465297B76617220713D612E6461746128746869732C226D6F757365776865656C2D6C696E652D68656967687422293B6A2A3D712C6D2A3D712C6C2A3D';
wwv_flow_api.g_varchar2_table(723) := '717D656C736520696628323D3D3D672E64656C74614D6F6465297B76617220723D612E6461746128746869732C226D6F757365776865656C2D706167652D68656967687422293B6A2A3D722C6D2A3D722C6C2A3D727D6966286E3D4D6174682E6D617828';
wwv_flow_api.g_varchar2_table(724) := '4D6174682E616273286D292C4D6174682E616273286C29292C2821667C7C663E6E29262628663D6E2C6428672C6E29262628662F3D343029292C6428672C6E292626286A2F3D34302C6C2F3D34302C6D2F3D3430292C6A3D4D6174685B6A3E3D313F2266';
wwv_flow_api.g_varchar2_table(725) := '6C6F6F72223A226365696C225D286A2F66292C6C3D4D6174685B6C3E3D313F22666C6F6F72223A226365696C225D286C2F66292C6D3D4D6174685B6D3E3D313F22666C6F6F72223A226365696C225D286D2F66292C6B2E73657474696E67732E6E6F726D';
wwv_flow_api.g_varchar2_table(726) := '616C697A654F66667365742626746869732E676574426F756E64696E67436C69656E7452656374297B76617220733D746869732E676574426F756E64696E67436C69656E745265637428293B6F3D622E636C69656E74582D732E6C6566742C703D622E63';
wwv_flow_api.g_varchar2_table(727) := '6C69656E74592D732E746F707D72657475726E20622E64656C7461583D6C2C622E64656C7461593D6D2C622E64656C7461466163746F723D662C622E6F6666736574583D6F2C622E6F6666736574593D702C622E64656C74614D6F64653D302C682E756E';
wwv_flow_api.g_varchar2_table(728) := '736869667428622C6A2C6C2C6D292C652626636C65617254696D656F75742865292C653D73657454696D656F757428632C323030292C28612E6576656E742E64697370617463687C7C612E6576656E742E68616E646C65292E6170706C7928746869732C';
wwv_flow_api.g_varchar2_table(729) := '68297D7D66756E6374696F6E206328297B663D6E756C6C7D66756E6374696F6E206428612C62297B72657475726E206B2E73657474696E67732E61646A7573744F6C6444656C7461732626226D6F757365776865656C223D3D3D612E7479706526266225';
wwv_flow_api.g_varchar2_table(730) := '3132303D3D3D307D76617220652C662C673D5B22776865656C222C226D6F757365776865656C222C22444F4D4D6F7573655363726F6C6C222C224D6F7A4D6F757365506978656C5363726F6C6C225D2C683D226F6E776865656C22696E20646F63756D65';
wwv_flow_api.g_varchar2_table(731) := '6E747C7C646F63756D656E742E646F63756D656E744D6F64653E3D393F5B22776865656C225D3A5B226D6F757365776865656C222C22446F6D4D6F7573655363726F6C6C222C224D6F7A4D6F757365506978656C5363726F6C6C225D2C693D4172726179';
wwv_flow_api.g_varchar2_table(732) := '2E70726F746F747970652E736C6963653B696628612E6576656E742E666978486F6F6B7329666F7228766172206A3D672E6C656E6774683B6A3B29612E6576656E742E666978486F6F6B735B675B2D2D6A5D5D3D612E6576656E742E6D6F757365486F6F';
wwv_flow_api.g_varchar2_table(733) := '6B733B766172206B3D612E6576656E742E7370656369616C2E6D6F757365776865656C3D7B76657273696F6E3A22332E312E3132222C73657475703A66756E6374696F6E28297B696628746869732E6164644576656E744C697374656E657229666F7228';
wwv_flow_api.g_varchar2_table(734) := '76617220633D682E6C656E6774683B633B29746869732E6164644576656E744C697374656E657228685B2D2D635D2C622C2131293B656C736520746869732E6F6E6D6F757365776865656C3D623B612E6461746128746869732C226D6F75736577686565';
wwv_flow_api.g_varchar2_table(735) := '6C2D6C696E652D686569676874222C6B2E6765744C696E65486569676874287468697329292C612E6461746128746869732C226D6F757365776865656C2D706167652D686569676874222C6B2E67657450616765486569676874287468697329297D2C74';
wwv_flow_api.g_varchar2_table(736) := '656172646F776E3A66756E6374696F6E28297B696628746869732E72656D6F76654576656E744C697374656E657229666F722876617220633D682E6C656E6774683B633B29746869732E72656D6F76654576656E744C697374656E657228685B2D2D635D';
wwv_flow_api.g_varchar2_table(737) := '2C622C2131293B656C736520746869732E6F6E6D6F757365776865656C3D6E756C6C3B612E72656D6F76654461746128746869732C226D6F757365776865656C2D6C696E652D68656967687422292C612E72656D6F76654461746128746869732C226D6F';
wwv_flow_api.g_varchar2_table(738) := '757365776865656C2D706167652D68656967687422297D2C6765744C696E654865696768743A66756E6374696F6E2862297B76617220633D612862292C643D635B226F6666736574506172656E7422696E20612E666E3F226F6666736574506172656E74';
wwv_flow_api.g_varchar2_table(739) := '223A22706172656E74225D28293B72657475726E20642E6C656E6774687C7C28643D612822626F64792229292C7061727365496E7428642E6373732822666F6E7453697A6522292C3130297C7C7061727365496E7428632E6373732822666F6E7453697A';
wwv_flow_api.g_varchar2_table(740) := '6522292C3130297C7C31367D2C676574506167654865696768743A66756E6374696F6E2862297B72657475726E20612862292E68656967687428297D2C73657474696E67733A7B61646A7573744F6C6444656C7461733A21302C6E6F726D616C697A654F';
wwv_flow_api.g_varchar2_table(741) := '66667365743A21307D7D3B612E666E2E657874656E64287B6D6F757365776865656C3A66756E6374696F6E2861297B72657475726E20613F746869732E62696E6428226D6F757365776865656C222C61293A746869732E7472696767657228226D6F7573';
wwv_flow_api.g_varchar2_table(742) := '65776865656C22297D2C756E6D6F757365776865656C3A66756E6374696F6E2861297B72657475726E20746869732E756E62696E6428226D6F757365776865656C222C61297D7D297D292C622E646566696E6528226A71756572792E73656C6563743222';
wwv_flow_api.g_varchar2_table(743) := '2C5B226A7175657279222C226A71756572792D6D6F757365776865656C222C222E2F73656C656374322F636F7265222C222E2F73656C656374322F64656661756C7473225D2C66756E6374696F6E28612C622C632C64297B6966286E756C6C3D3D612E66';
wwv_flow_api.g_varchar2_table(744) := '6E2E73656C65637432297B76617220653D5B226F70656E222C22636C6F7365222C2264657374726F79225D3B612E666E2E73656C656374323D66756E6374696F6E2862297B696628623D627C7C7B7D2C226F626A656374223D3D747970656F6620622972';
wwv_flow_api.g_varchar2_table(745) := '657475726E20746869732E656163682866756E6374696F6E28297B76617220643D612E657874656E642821302C7B7D2C62293B6E6577206328612874686973292C64297D292C746869733B69662822737472696E67223D3D747970656F662062297B7661';
wwv_flow_api.g_varchar2_table(746) := '7220642C663D41727261792E70726F746F747970652E736C6963652E63616C6C28617267756D656E74732C31293B72657475726E20746869732E656163682866756E6374696F6E28297B76617220633D612874686973292E64617461282273656C656374';
wwv_flow_api.g_varchar2_table(747) := '3222293B6E756C6C3D3D63262677696E646F772E636F6E736F6C652626636F6E736F6C652E6572726F722626636F6E736F6C652E6572726F7228225468652073656C656374322827222B622B222729206D6574686F64207761732063616C6C6564206F6E';
wwv_flow_api.g_varchar2_table(748) := '20616E20656C656D656E742074686174206973206E6F74207573696E672053656C656374322E22292C643D635B625D2E6170706C7928632C66297D292C612E696E417272617928622C65293E2D313F746869733A647D7468726F77206E6577204572726F';
wwv_flow_api.g_varchar2_table(749) := '722822496E76616C696420617267756D656E747320666F722053656C656374323A20222B62297D7D72657475726E206E756C6C3D3D612E666E2E73656C656374322E64656661756C7473262628612E666E2E73656C656374322E64656661756C74733D64';
wwv_flow_api.g_varchar2_table(750) := '292C637D292C7B646566696E653A622E646566696E652C726571756972653A622E726571756972657D7D28292C633D622E7265717569726528226A71756572792E73656C6563743222293B72657475726E20612E666E2E73656C656374322E616D643D62';
wwv_flow_api.g_varchar2_table(751) := '2C637D293B';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 9653457479187528 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2.full.min.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220626543746253656C65637432203D207B7D3B0D0A0D0A626543746253656C656374322E6576656E7473203D207B0D0A202062696E643A2066756E6374696F6E2028704974656D29207B0D0A2020202076617220706167654974656D203D202428';
wwv_flow_api.g_varchar2_table(2) := '2222202B20704974656D202B202222293B0D0A0D0A20202020706167654974656D2E6F6E28226368616E6765222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C637463';
wwv_flow_api.g_varchar2_table(3) := '68616E6765222C207B73656C656374323A20657D293B0D0A20202020202069662028242E666E2E6A717565727920213D3D20617065782E6A51756572792E666E2E6A717565727929207B0D0A2020202020202020617065782E6A51756572792874686973';
wwv_flow_api.g_varchar2_table(4) := '292E7472696767657228226368616E676522293B0D0A2020202020207D0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374323A636C6F7365222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A';
wwv_flow_api.g_varchar2_table(5) := '51756572792874686973292E747269676765722822736C6374636C6F7365222C207B73656C656374323A20657D293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374323A636C6F73696E67222C2066756E6374696F';
wwv_flow_api.g_varchar2_table(6) := '6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C6374636C6F73696E67222C207B73656C656374323A20657D293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C';
wwv_flow_api.g_varchar2_table(7) := '656374323A6F70656E222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C63746F70656E222C207B73656C656374323A20657D293B0D0A202020207D293B0D0A20202020';
wwv_flow_api.g_varchar2_table(8) := '706167654974656D2E6F6E282273656C656374323A6F70656E696E67222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C63746F70656E696E67222C207B73656C656374';
wwv_flow_api.g_varchar2_table(9) := '323A20657D293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374323A73656C656374222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822';
wwv_flow_api.g_varchar2_table(10) := '736C637473656C656374222C207B73656C656374323A20657D293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374323A73656C656374696E67222C2066756E6374696F6E286529207B0D0A20202020202061706578';
wwv_flow_api.g_varchar2_table(11) := '2E6A51756572792874686973292E747269676765722822736C637473656C656374696E67222C207B73656C656374323A20657D293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374323A756E73656C656374222C20';
wwv_flow_api.g_varchar2_table(12) := '66756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C6374756E73656C656374222C207B73656C656374323A20657D293B0D0A202020207D293B0D0A20202020706167654974656D';
wwv_flow_api.g_varchar2_table(13) := '2E6F6E282273656C656374323A756E73656C656374696E67222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C6374756E73656C656374696E67222C207B73656C656374';
wwv_flow_api.g_varchar2_table(14) := '323A20657D293B0D0A202020207D293B0D0A20207D0D0A7D3B';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 9728334612273019 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 21182581058369062 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2-apex.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
