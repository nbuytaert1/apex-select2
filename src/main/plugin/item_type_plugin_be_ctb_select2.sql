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
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040100 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,14991625548452126));
 
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
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2011.02.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,163);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/be_ctb_select2
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'BE.CTB.SELECT2'
 ,p_display_name => 'Select2'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'-- GLOBAL'||unistr('\000a')||
'subtype gt_string is varchar2(32767);'||unistr('\000a')||
''||unistr('\000a')||
'gco_min_lov_cols constant number := 2;'||unistr('\000a')||
'gco_max_lov_cols constant number := 3;'||unistr('\000a')||
''||unistr('\000a')||
'gco_lov_display_col constant number := 1;'||unistr('\000a')||
'gco_lov_return_col  constant number := 2;'||unistr('\000a')||
'gco_lov_group_col   constant number := 3;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'-- UTIL'||unistr('\000a')||
'function add_js_attr('||unistr('\000a')||
'           p_param_name     in gt_string,'||unistr('\000a')||
'           p_param_value    in gt_string,'||unistr('\000a')||
'           p_include_quotes in'||
' boolean default false,'||unistr('\000a')||
'           p_include_comma  in boolean default true'||unistr('\000a')||
'         )'||unistr('\000a')||
'return gt_string is'||unistr('\000a')||
'  l_param_value gt_string;'||unistr('\000a')||
'  l_attr        gt_string;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  if (p_param_value is not null) then'||unistr('\000a')||
'    if (p_include_quotes) then'||unistr('\000a')||
'      l_param_value := ''"'' || p_param_value || ''"'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'    l_attr := p_param_name || '': '' || nvl(l_param_value, p_param_value);'||unistr('\000a')||
'    if (p_include_comma) th'||
'en'||unistr('\000a')||
'      l_attr := '''||unistr('\000a')||
'        '' || l_attr || '','';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  else'||unistr('\000a')||
'    l_attr := '''';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_attr;'||unistr('\000a')||
'end add_js_attr;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function get_lov('||unistr('\000a')||
'           p_item in apex_plugin.t_page_item'||unistr('\000a')||
'         )'||unistr('\000a')||
'return apex_plugin_util.t_column_value_list is'||unistr('\000a')||
'begin'||unistr('\000a')||
'  return apex_plugin_util.get_data('||unistr('\000a')||
'           p_sql_statement  => p_item.lov_definition,'||unistr('\000a')||
'           p_min_columns    => gco_min_lov_cols,'||unistr('\000a')||
' '||
'          p_max_columns    => gco_max_lov_cols,'||unistr('\000a')||
'           p_component_name => p_item.name'||unistr('\000a')||
'         );'||unistr('\000a')||
'end get_lov;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'-- PRINT LIST OF VALUES'||unistr('\000a')||
'function get_options_html('||unistr('\000a')||
'           p_item   in apex_plugin.t_page_item,'||unistr('\000a')||
'           p_plugin in apex_plugin.t_plugin,'||unistr('\000a')||
'           p_value  in gt_string'||unistr('\000a')||
'         )'||unistr('\000a')||
'return gt_string is'||unistr('\000a')||
'  l_null_optgroup_label_app gt_string := p_plugin.attribute_05;'||unistr('\000a')||
'  l_null_o'||
'ptgroup_label_cmp gt_string := p_item.attribute_09;'||unistr('\000a')||
''||unistr('\000a')||
'  lco_null_optgroup_label constant gt_string := ''Ungrouped'';'||unistr('\000a')||
''||unistr('\000a')||
'  l_lov           apex_plugin_util.t_column_value_list;'||unistr('\000a')||
'  l_null_optgroup gt_string;'||unistr('\000a')||
'  l_tmp_optgroup  gt_string;'||unistr('\000a')||
''||unistr('\000a')||
'  type gt_optgroups'||unistr('\000a')||
'    is table of gt_string'||unistr('\000a')||
'    index by pls_integer;'||unistr('\000a')||
'  laa_optgroups gt_optgroups;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'  -- local subprograms'||unistr('\000a')||
'  function get_null_optgroup_label('||unistr('\000a')||
'       '||
'      p_default_null_optgroup_label in gt_string,'||unistr('\000a')||
'             p_null_optgroup_label_app     in gt_string,'||unistr('\000a')||
'             p_null_optgroup_label_cmp     in gt_string'||unistr('\000a')||
'           )'||unistr('\000a')||
'  return gt_string is'||unistr('\000a')||
'    l_null_optgroup_label gt_string;'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    if (p_null_optgroup_label_cmp is not null) then'||unistr('\000a')||
'      l_null_optgroup_label := p_null_optgroup_label_cmp;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_null_optgroup_label := nvl(p_n'||
'ull_optgroup_label_app, p_default_null_optgroup_label);'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    return l_null_optgroup_label;'||unistr('\000a')||
'  end get_null_optgroup_label;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'  function optgroup_exists('||unistr('\000a')||
'             p_optgroups in gt_optgroups,'||unistr('\000a')||
'             p_optgroup  in gt_string'||unistr('\000a')||
'           )'||unistr('\000a')||
'  return boolean is'||unistr('\000a')||
'    l_index pls_integer := p_optgroups.first;'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    while (l_index is not null) loop'||unistr('\000a')||
'      if (p_optgroups(l_index) ='||
' p_optgroup) then'||unistr('\000a')||
'        return true;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'      l_index := p_optgroups.next(l_index);'||unistr('\000a')||
'    end loop;'||unistr('\000a')||
''||unistr('\000a')||
'    return false;'||unistr('\000a')||
'  end optgroup_exists;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'  function is_selected_value('||unistr('\000a')||
'             p_value           in gt_string,'||unistr('\000a')||
'             p_selected_values in gt_string'||unistr('\000a')||
'           )'||unistr('\000a')||
'  return boolean is'||unistr('\000a')||
'    l_selected_values apex_application_global.vc_arr2;'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    l_selected_values := apex_'||
'util.string_to_table(p_selected_values);'||unistr('\000a')||
''||unistr('\000a')||
'    for i in 1 .. l_selected_values.count loop'||unistr('\000a')||
'      if (p_value = l_selected_values(i)) then'||unistr('\000a')||
'        return true;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'    end loop;'||unistr('\000a')||
''||unistr('\000a')||
'    return false;'||unistr('\000a')||
'  end is_selected_value;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  l_lov := get_lov(p_item);'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_item.lov_display_null) then'||unistr('\000a')||
'    if p_value is null then'||unistr('\000a')||
'      sys.htp.p(''<option value="" selected="selected"></option>'');'||unistr('\000a')||
'    e'||
'lse'||unistr('\000a')||
'      sys.htp.p(''<option></option>'');'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_lov.exists(gco_lov_group_col)) then'||unistr('\000a')||
'    l_null_optgroup := get_null_optgroup_label('||unistr('\000a')||
'                         p_default_null_optgroup_label => lco_null_optgroup_label,'||unistr('\000a')||
'                         p_null_optgroup_label_app     => l_null_optgroup_label_app,'||unistr('\000a')||
'                         p_null_optgroup_label_cmp     => l_null_optgroup_l'||
'abel_cmp'||unistr('\000a')||
'                       );'||unistr('\000a')||
''||unistr('\000a')||
'    for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'      l_tmp_optgroup := nvl(l_lov(gco_lov_group_col)(i), l_null_optgroup);'||unistr('\000a')||
''||unistr('\000a')||
'      if (not optgroup_exists(laa_optgroups, l_tmp_optgroup)) then'||unistr('\000a')||
'        sys.htp.p(''<optgroup label="'' || l_tmp_optgroup || ''">'');'||unistr('\000a')||
'        for j in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'          if (nvl(l_lov(gco_lov_group_c'||
'ol)(j), l_null_optgroup) = l_tmp_optgroup) then'||unistr('\000a')||
'            apex_plugin_util.print_option('||unistr('\000a')||
'              p_display_value => l_lov(gco_lov_display_col)(j),'||unistr('\000a')||
'              p_return_value  => l_lov(gco_lov_return_col)(j),'||unistr('\000a')||
'              p_is_selected   => is_selected_value(l_lov(gco_lov_return_col)(j), p_value),'||unistr('\000a')||
'              p_attributes    => p_item.element_option_attributes,'||unistr('\000a')||
'              p_escape  '||
'      => p_item.escape_output'||unistr('\000a')||
'            );'||unistr('\000a')||
'          end if;'||unistr('\000a')||
'        end loop;'||unistr('\000a')||
'        sys.htp.p(''</optgroup>'');'||unistr('\000a')||
''||unistr('\000a')||
'        laa_optgroups(i) := l_tmp_optgroup;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'    end loop;'||unistr('\000a')||
'  else'||unistr('\000a')||
'    for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'      apex_plugin_util.print_option('||unistr('\000a')||
'        p_display_value => l_lov(gco_lov_display_col)(i),'||unistr('\000a')||
'        p_return_value  => l_lov(gco_lov_return_col)(i'||
'),'||unistr('\000a')||
'        p_is_selected   => is_selected_value(l_lov(gco_lov_return_col)(i), p_value),'||unistr('\000a')||
'        p_attributes    => p_item.element_option_attributes,'||unistr('\000a')||
'        p_escape        => p_item.escape_output'||unistr('\000a')||
'      );'||unistr('\000a')||
'    end loop;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  return '''';'||unistr('\000a')||
'end get_options_html;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function get_tags_option('||unistr('\000a')||
'           p_item        in apex_plugin.t_page_item,'||unistr('\000a')||
'           p_include_key in boolean'||unistr('\000a')||
'         )'||unistr('\000a')||
'return'||
' gt_string is'||unistr('\000a')||
'  l_lov                   apex_plugin_util.t_column_value_list;'||unistr('\000a')||
'  l_select_list_type      gt_string := p_item.attribute_01;'||unistr('\000a')||
'  l_return_value_based_on gt_string := p_item.attribute_12;'||unistr('\000a')||
'  l_tags_option           gt_string;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  l_lov := get_lov(p_item);'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_select_list_type != ''TAG'' or'||unistr('\000a')||
'     (l_select_list_type = ''TAG'' and l_return_value_based_on = ''DISPLAY'')) then'||unistr('\000a')||
'    if (p_inc'||
'lude_key) then'||unistr('\000a')||
'      for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'        l_tags_option := l_tags_option || ''"'' || l_lov(gco_lov_display_col)(i) || ''",'';'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
'    elsif (not p_include_key) then'||unistr('\000a')||
'      for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'        l_tags_option := l_tags_option || l_lov(gco_lov_display_col)(i) || '','';'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  else'||unistr('\000a')||
'    for i in 1 '||
'.. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'      l_tags_option := l_tags_option || ''{'' ||'||unistr('\000a')||
'                                           add_js_attr(''"id"'', l_lov(gco_lov_return_col)(i)) ||'||unistr('\000a')||
'                                           add_js_attr(''"text"'', l_lov(gco_lov_display_col)(i), true, false) ||'||unistr('\000a')||
'                                        ''},'';'||unistr('\000a')||
'    end loop;'||unistr('\000a')||
''||unistr('\000a')||
'    if (not p_include_key) then'||unistr('\000a')||
'      if (l'||
'_lov(gco_lov_display_col).count > 0) then'||unistr('\000a')||
'        l_tags_option := substr(l_tags_option, 0, length(l_tags_option) - 1);'||unistr('\000a')||
'      end if;'||unistr('\000a')||
''||unistr('\000a')||
'      return ''['' || l_tags_option || '']'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_lov(gco_lov_display_col).count > 0) then'||unistr('\000a')||
'    l_tags_option := substr(l_tags_option, 0, length(l_tags_option) - 1);'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_include_key) then'||unistr('\000a')||
'    l_tags_option := '''||unistr('\000a')||
'        tags: ['' '||
'|| l_tags_option || '']'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_tags_option;'||unistr('\000a')||
'end get_tags_option;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'-- PLUGIN INTERFACE FUNCTIONS'||unistr('\000a')||
'function render('||unistr('\000a')||
'           p_item                in apex_plugin.t_page_item,'||unistr('\000a')||
'           p_plugin              in apex_plugin.t_plugin,'||unistr('\000a')||
'           p_value               in gt_string,'||unistr('\000a')||
'           p_is_readonly         in boolean,'||unistr('\000a')||
'           p_is_printer_friendly in boolean'||unistr('\000a')||
'         )'||unistr('\000a')||
'retu'||
'rn apex_plugin.t_page_item_render_result is'||unistr('\000a')||
'  l_no_matches_msg          gt_string := p_plugin.attribute_01;'||unistr('\000a')||
'  l_input_too_short_msg     gt_string := p_plugin.attribute_02;'||unistr('\000a')||
'  l_selection_too_big_msg   gt_string := p_plugin.attribute_03;'||unistr('\000a')||
'  l_searching_msg           gt_string := p_plugin.attribute_04;'||unistr('\000a')||
'  l_null_optgroup_label_app gt_string := p_plugin.attribute_05;'||unistr('\000a')||
''||unistr('\000a')||
'  l_select_list_type        gt_stri'||
'ng := p_item.attribute_01;'||unistr('\000a')||
'  l_min_results_for_search  gt_string := p_item.attribute_02;'||unistr('\000a')||
'  l_min_input_length        gt_string := p_item.attribute_03;'||unistr('\000a')||
'  l_max_input_length        gt_string := p_item.attribute_04;'||unistr('\000a')||
'  l_max_selection_size      gt_string := p_item.attribute_05;'||unistr('\000a')||
'  l_rapid_selection         gt_string := p_item.attribute_06;'||unistr('\000a')||
'  l_select_on_blur          gt_string := p_item.attribute_07;'||unistr('\000a')||
' '||
' l_search_logic            gt_string := p_item.attribute_08;'||unistr('\000a')||
'  l_null_optgroup_label_cmp gt_string := p_item.attribute_09;'||unistr('\000a')||
'  l_width                   gt_string := p_item.attribute_10;'||unistr('\000a')||
'  l_drag_and_drop_sorting   gt_string := p_item.attribute_11;'||unistr('\000a')||
'  l_return_value_based_on   gt_string := p_item.attribute_12;'||unistr('\000a')||
''||unistr('\000a')||
'  l_display_values apex_application_global.vc_arr2;'||unistr('\000a')||
'  l_multiselect    gt_string;'||unistr('\000a')||
''||unistr('\000a')||
'  l_ite'||
'm_jq                    gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.name);'||unistr('\000a')||
'  l_cascade_parent_items_jq    gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.lov_cascade_parent_items);'||unistr('\000a')||
'  l_cascade_items_to_submit_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.ajax_items_to_submit);'||unistr('\000a')||
'  l_items_for_session_state_jq gt_string;'||unistr('\000a')||
'  l_cascade_parent_items  '||
'     apex_application_global.vc_arr2;'||unistr('\000a')||
'  l_optimize_refresh_condition gt_string;'||unistr('\000a')||
''||unistr('\000a')||
'  l_apex_version  gt_string;'||unistr('\000a')||
'  l_onload_code   gt_string;'||unistr('\000a')||
'  l_render_result apex_plugin.t_page_item_render_result;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'  -- local subprograms'||unistr('\000a')||
'  function get_select2_constructor('||unistr('\000a')||
'             p_include_tags    in boolean,'||unistr('\000a')||
'             p_end_constructor in boolean'||unistr('\000a')||
'           )'||unistr('\000a')||
'  return gt_string is'||unistr('\000a')||
'    lco_contains_ignore'||
'_case    constant gt_string := ''CIC'';'||unistr('\000a')||
'    lco_contains_case_sensitive constant gt_string := ''CCS'';'||unistr('\000a')||
'    lco_exact_ignore_case       constant gt_string := ''EIC'';'||unistr('\000a')||
'    lco_exact_case_sensitive    constant gt_string := ''ECS'';'||unistr('\000a')||
''||unistr('\000a')||
'    l_placeholder gt_string;'||unistr('\000a')||
'    l_code        gt_string;'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    if (p_item.lov_display_null) then'||unistr('\000a')||
'      l_placeholder := p_item.lov_null_text;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_placeholder '||
':= '''';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_width is null) then'||unistr('\000a')||
'      l_width := ''element'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_rapid_selection is null) then'||unistr('\000a')||
'      l_rapid_selection := '''';'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_rapid_selection := ''false'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_select_on_blur is null) then'||unistr('\000a')||
'      l_select_on_blur := '''';'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_select_on_blur := ''true'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_code := '''||unistr('\000a')||
'      $("'' || l_item_jq || ''").select2('||
'{'' ||'||unistr('\000a')||
'        add_js_attr(''width'', l_width, true) ||'||unistr('\000a')||
'        add_js_attr(''placeholder'', l_placeholder, true) ||'||unistr('\000a')||
'        add_js_attr(''allowClear'', ''true'') ||'||unistr('\000a')||
'        add_js_attr(''minimumInputLength'', l_min_input_length) ||'||unistr('\000a')||
'        add_js_attr(''maximumInputLength'', l_max_input_length) ||'||unistr('\000a')||
'        add_js_attr(''minimumResultsForSearch'', l_min_results_for_search) ||'||unistr('\000a')||
'        add_js_attr(''maximumSelection'||
'Size'', l_max_selection_size) ||'||unistr('\000a')||
'        add_js_attr(''closeOnSelect'', l_rapid_selection) ||'||unistr('\000a')||
'        add_js_attr(''selectOnBlur'', l_select_on_blur);'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_no_matches_msg is not null) then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        formatNoMatches: function(term) {'||unistr('\000a')||
'                           var msg = "'' || l_no_matches_msg || ''";'||unistr('\000a')||
'                           msg = msg.replace("#TERM#", term);'||unistr('\000a')||
'           '||
'                return msg;'||unistr('\000a')||
'                         },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_input_too_short_msg is not null) then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        formatInputTooShort: function(term, minLength) {'||unistr('\000a')||
'                               var msg = "'' || l_input_too_short_msg || ''";'||unistr('\000a')||
'                               msg = msg.replace("#TERM#", term);'||unistr('\000a')||
'                               msg = msg.replace("#MIN'||
'LENGTH#", minLength);'||unistr('\000a')||
'                               return msg;'||unistr('\000a')||
'                             },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_selection_too_big_msg is not null) then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        formatSelectionTooBig: function(maxSize) {'||unistr('\000a')||
'                                 var msg = "'' || l_selection_too_big_msg || ''";'||unistr('\000a')||
'                                 msg = msg.replace("#MAXSIZE#", maxSize);'||unistr('\000a')||
'     '||
'                            return msg;'||unistr('\000a')||
'                               },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_searching_msg is not null) then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        formatSearching: function() {'||unistr('\000a')||
'                           var msg = "'' || l_searching_msg || ''";'||unistr('\000a')||
'                           return msg;'||unistr('\000a')||
'                         },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_search_logic != lco_contains_ignore_case) the'||
'n'||unistr('\000a')||
'      case l_search_logic'||unistr('\000a')||
'        when lco_contains_case_sensitive then l_search_logic := ''return text.indexOf(term) >= 0;'';'||unistr('\000a')||
'        when lco_exact_ignore_case then l_search_logic := ''return text.toUpperCase() === term.toUpperCase() || term.length === 0;'';'||unistr('\000a')||
'        when lco_exact_case_sensitive then l_search_logic := ''return text === term || term.length === 0;'';'||unistr('\000a')||
'        else l_search_logic := ''re'||
'turn text.toUpperCase().indexOf(term.toUpperCase()) >= 0;'';'||unistr('\000a')||
'      end case;'||unistr('\000a')||
''||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        matcher: function(term, text) {'||unistr('\000a')||
'                   '' || l_search_logic || '''||unistr('\000a')||
'                 },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_code := l_code || '''||unistr('\000a')||
'        separator: ":"'';'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_select_list_type = ''TAG'' and p_include_tags) then'||unistr('\000a')||
'      l_code := l_code || '','' || get_tags_option(p_item, true);'||unistr('\000a')||
''||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if (p_end_constructor) then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'      });'';'||unistr('\000a')||
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
'      $("'' || l_item_jq || ''").select2("container").find("ul.select2-choices").sortable({'||unistr('\000a')||
'        containment: "parent",'||unistr('\000a')||
'        start: function()'||
' { $("'' || l_item_jq || ''").select2("onSortStart"); },'||unistr('\000a')||
'        update: function() { $("'' || l_item_jq || ''").select2("onSortEnd"); }'||unistr('\000a')||
'      });'';'||unistr('\000a')||
''||unistr('\000a')||
'    return l_code;'||unistr('\000a')||
'  end get_sortable_constructor;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  if (apex_application.g_debug) then'||unistr('\000a')||
'    apex_plugin_util.debug_page_item(p_plugin, p_item, p_value, p_is_readonly, p_is_printer_friendly);'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_is_readonly or p_is_printer_friendly) '||
'then'||unistr('\000a')||
'    apex_plugin_util.print_hidden_if_readonly(p_item.name, p_value, p_is_readonly, p_is_printer_friendly);'||unistr('\000a')||
''||unistr('\000a')||
'    l_display_values := apex_plugin_util.get_display_data('||unistr('\000a')||
'                          p_sql_statement     => p_item.lov_definition,'||unistr('\000a')||
'                          p_min_columns       => gco_min_lov_cols,'||unistr('\000a')||
'                          p_max_columns       => gco_max_lov_cols,'||unistr('\000a')||
'                      '||
'    p_component_name    => p_item.name,'||unistr('\000a')||
'                          p_search_value_list => apex_util.string_to_table(p_value),'||unistr('\000a')||
'                          p_display_extra     => p_item.lov_display_extra'||unistr('\000a')||
'                        );'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_display_values.count = 1) then'||unistr('\000a')||
'      apex_plugin_util.print_display_only('||unistr('\000a')||
'        p_item_name        => p_item.name,'||unistr('\000a')||
'        p_display_value    => l_display_values'||
'(1),'||unistr('\000a')||
'        p_show_line_breaks => false,'||unistr('\000a')||
'        p_escape           => p_item.escape_output,'||unistr('\000a')||
'        p_attributes       => p_item.element_attributes'||unistr('\000a')||
'      );'||unistr('\000a')||
'    elsif (l_display_values.count > 1) then'||unistr('\000a')||
'      sys.htp.p('''||unistr('\000a')||
'        <ul id="'' || p_item.name || ''_DISPLAY"'||unistr('\000a')||
'            class="display_only">'');'||unistr('\000a')||
''||unistr('\000a')||
'      for i in 1 .. l_display_values.count loop'||unistr('\000a')||
'        sys.htp.p(''<li>'' || l_display_values(i'||
') || ''</li>'');'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
''||unistr('\000a')||
'      sys.htp.p(''</ul>'');'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    return l_render_result;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  apex_javascript.add_library('||unistr('\000a')||
'    p_name      => ''select2.min'','||unistr('\000a')||
'    p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'    p_version   => null'||unistr('\000a')||
'  );'||unistr('\000a')||
'  apex_javascript.add_library('||unistr('\000a')||
'    p_name      => ''select2-apex'','||unistr('\000a')||
'    p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'    p_version   => null'||unistr('\000a')||
'  );'||unistr('\000a')||
'  apex_css.add_file'||
'('||unistr('\000a')||
'    p_name      => ''select2'','||unistr('\000a')||
'    p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'    p_version   => null'||unistr('\000a')||
'  );'||unistr('\000a')||
'  apex_css.add_file('||unistr('\000a')||
'    p_name      => ''select2-bootstrap'','||unistr('\000a')||
'    p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'    p_version   => null'||unistr('\000a')||
'  );'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_select_list_type = ''MULTI'') then'||unistr('\000a')||
'    l_multiselect := ''multiple'';'||unistr('\000a')||
'  else'||unistr('\000a')||
'    l_multiselect := '''';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_select_list_type = ''TAG'') then'||unistr('\000a')||
'    sys.ht'||
'p.p('''||unistr('\000a')||
'      <input type="hidden"'||unistr('\000a')||
'             id="'' || p_item.name || ''"'||unistr('\000a')||
'             name="'' || apex_plugin.get_input_name_for_page_item(true) || ''"'||unistr('\000a')||
'             value="'' || p_value || ''"'' ||'||unistr('\000a')||
'             p_item.element_attributes || ''>'');'||unistr('\000a')||
'  else'||unistr('\000a')||
'    sys.htp.p('''||unistr('\000a')||
'      <select '' || l_multiselect || '''||unistr('\000a')||
'              id="'' || p_item.name || ''"'||unistr('\000a')||
'              name="'' || apex_plugin.get_input_name_for_p'||
'age_item(true) || ''"'||unistr('\000a')||
'              class="selectlist"'' ||'||unistr('\000a')||
'              p_item.element_attributes || ''>'');'||unistr('\000a')||
''||unistr('\000a')||
'    sys.htp.p(get_options_html(p_item, p_plugin, p_value));'||unistr('\000a')||
''||unistr('\000a')||
'    sys.htp.p(''</select>'');'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  l_onload_code := get_select2_constructor('||unistr('\000a')||
'                     p_include_tags    => true,'||unistr('\000a')||
'                     p_end_constructor => true'||unistr('\000a')||
'                   );'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_drag_and_drop_sorting '||
'is not null) then'||unistr('\000a')||
'    select substr(version_no, 1, 3)'||unistr('\000a')||
'    into l_apex_version'||unistr('\000a')||
'    from apex_release;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_apex_version = ''4.1'') then'||unistr('\000a')||
'      apex_javascript.add_library('||unistr('\000a')||
'        p_name      => ''jquery-ui.custom.min'','||unistr('\000a')||
'        p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'        p_version   => null'||unistr('\000a')||
'      );'||unistr('\000a')||
'    else'||unistr('\000a')||
'      apex_javascript.add_library('||unistr('\000a')||
'        p_name      => ''jquery.ui.sortable.min'','||unistr('\000a')||
'    '||
'    p_directory => ''#IMAGE_PREFIX#libraries/jquery-ui/1.8.22/ui/minified/'','||unistr('\000a')||
'        p_version   => null'||unistr('\000a')||
'      );'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_onload_code := l_onload_code || get_sortable_constructor();'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_item.lov_cascade_parent_items is not null) then'||unistr('\000a')||
'    l_items_for_session_state_jq := l_cascade_parent_items_jq;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_cascade_items_to_submit_jq is not null) then'||unistr('\000a')||
'      l_items_for_sess'||
'ion_state_jq := l_items_for_session_state_jq || '','' || l_cascade_items_to_submit_jq;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_onload_code := l_onload_code || '''||unistr('\000a')||
'      $("'' || l_cascade_parent_items_jq || ''").on("change", function(e) {'';'||unistr('\000a')||
''||unistr('\000a')||
'    if (p_item.ajax_optimize_refresh) then'||unistr('\000a')||
'      l_cascade_parent_items := apex_util.string_to_table(l_cascade_parent_items_jq, '','');'||unistr('\000a')||
''||unistr('\000a')||
'      l_optimize_refresh_condition := ''$("'' || l_c'||
'ascade_parent_items(1) || ''").val() === ""'';'||unistr('\000a')||
''||unistr('\000a')||
'      for i in 2 .. l_cascade_parent_items.count loop'||unistr('\000a')||
'        l_optimize_refresh_condition := l_optimize_refresh_condition || '' || $("'' || l_cascade_parent_items(i) || ''").val() === ""'';'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
''||unistr('\000a')||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'        var item = $("'' || l_item_jq || ''");'||unistr('\000a')||
'        if ('' || l_optimize_refresh_condition || '') {'';'||unistr('\000a')||
''||unistr('\000a')||
'      '||
'if (l_select_list_type = ''TAG'') then'||unistr('\000a')||
'        l_onload_code := l_onload_code ||'||unistr('\000a')||
'          get_select2_constructor('||unistr('\000a')||
'            p_include_tags    => false,'||unistr('\000a')||
'            p_end_constructor => false'||unistr('\000a')||
'          ) || '','||unistr('\000a')||
'        tags: []'||unistr('\000a')||
'      });'';'||unistr('\000a')||
'      else'||unistr('\000a')||
'        if (p_item.lov_display_null) then'||unistr('\000a')||
'          l_onload_code := l_onload_code || '''||unistr('\000a')||
'          item.html("<option></option>");'';'||unistr('\000a')||
'        else'||unistr('\000a')||
'    '||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'          item.html("");'';'||unistr('\000a')||
'        end if;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
''||unistr('\000a')||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'          item.select2("data", null);'||unistr('\000a')||
'        } else {'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'          apex.server.plugin('||unistr('\000a')||
'            "'' || apex_plugin.get_ajax_identifier || ''",'||unistr('\000a')||
'            { pageItems: "'' || l_items_for_session_state_jq '||
'|| ''" },'||unistr('\000a')||
'            { refreshObject: "'' || l_item_jq || ''",'||unistr('\000a')||
'              loadingIndicator: "'' || l_item_jq || ''",'||unistr('\000a')||
'              loadingIndicatorPosition: "after",'';'||unistr('\000a')||
'    if (l_select_list_type = ''TAG'' and l_return_value_based_on = ''RETURN'') then'||unistr('\000a')||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'              dataType: "json",'';'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'              dataType: "t'||
'ext",'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'              success: function(pData) {'||unistr('\000a')||
'                         var item = $("'' || l_item_jq || ''");'';'||unistr('\000a')||
'    if (l_select_list_type = ''TAG'') then'||unistr('\000a')||
'      if (l_return_value_based_on = ''DISPLAY'') then'||unistr('\000a')||
'        l_onload_code := l_onload_code || '''||unistr('\000a')||
'                         var tagsArray;'||unistr('\000a')||
'                         tagsArray = pData.slice(0, -1).'||
'split(",");'||unistr('\000a')||
'                         if (tagsArray.length === 1 && tagsArray[0] === "") {'||unistr('\000a')||
'                           tagsArray = [];'||unistr('\000a')||
'                         }'';'||unistr('\000a')||
'      else'||unistr('\000a')||
'        l_onload_code := l_onload_code || '''||unistr('\000a')||
'                         var tagsArray = pData;'';'||unistr('\000a')||
'      end if;'||unistr('\000a')||
''||unistr('\000a')||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'      '' || get_select2_constructor('||unistr('\000a')||
'             p_include_tags    => false,'||
''||unistr('\000a')||
'             p_end_constructor => false'||unistr('\000a')||
'           ) || '','||unistr('\000a')||
'        tags: tagsArray'||unistr('\000a')||
'      });'';'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'      item.html(pData);'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_onload_code := l_onload_code || '''||unistr('\000a')||
'      item.select2("data", null);}});'';'||unistr('\000a')||
''||unistr('\000a')||
'    if (p_item.ajax_optimize_refresh) then'||unistr('\000a')||
'      l_onload_code := l_onload_code || ''}'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_onload_code := l_onload_co'||
'de || ''});'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  l_onload_code := l_onload_code || '''||unistr('\000a')||
'      beCtbSelect2.events.bind("'' || l_item_jq || ''");'';'||unistr('\000a')||
''||unistr('\000a')||
'  apex_javascript.add_onload_code(l_onload_code);'||unistr('\000a')||
'  l_render_result.is_navigable := true;'||unistr('\000a')||
'  return l_render_result;'||unistr('\000a')||
'end render;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function ajax('||unistr('\000a')||
'           p_item   in apex_plugin.t_page_item,'||unistr('\000a')||
'           p_plugin in apex_plugin.t_plugin'||unistr('\000a')||
'         )'||unistr('\000a')||
'return apex_plugin.t_page_item_a'||
'jax_result is'||unistr('\000a')||
'  l_select_list_type gt_string := p_item.attribute_01;'||unistr('\000a')||
'  l_result apex_plugin.t_page_item_ajax_result;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  if (l_select_list_type = ''TAG'') then'||unistr('\000a')||
'    sys.htp.p(get_tags_option(p_item, false));'||unistr('\000a')||
'  else'||unistr('\000a')||
'    sys.htp.p(get_options_html(p_item, p_plugin, ''''));'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_result;'||unistr('\000a')||
'end ajax;'
 ,p_render_function => 'render'
 ,p_ajax_function => 'ajax'
 ,p_standard_attributes => 'VISIBLE:SESSION_STATE:READONLY:QUICKPICK:SOURCE:ELEMENT:ELEMENT_OPTION:ENCRYPT:LOV:LOV_REQUIRED:LOV_DISPLAY_NULL:CASCADING_LOV'
 ,p_sql_min_column_count => 2
 ,p_sql_max_column_count => 3
 ,p_sql_examples => '<span style="font-weight:bold;">1. Dynamic LOV</span>'||unistr('\000a')||
'<pre>SELECT ename, empno FROM emp ORDER by ename</pre>'||unistr('\000a')||
''||unistr('\000a')||
'<span style="font-weight:bold;">2. Dynamic LOV with option grouping</span>'||unistr('\000a')||
'<pre>'||unistr('\000a')||
'SELECT e.ename d'||unistr('\000a')||
'     , e.empno r'||unistr('\000a')||
'     , d.dname grp'||unistr('\000a')||
'  FROM emp e'||unistr('\000a')||
'  LEFT JOIN dept d ON d.deptno = e.deptno'||unistr('\000a')||
' ORDER BY grp, d'||unistr('\000a')||
'</pre>'
 ,p_substitute_attributes => true
 ,p_version_identifier => '2.3.1'
 ,p_about_url => 'http://apex.oracle.com/pls/apex/f?p=64237:20'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 72019632803876877 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'No Matches Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The default message is "No matches found". It is possible to reference the substitution variable #TERM#.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77239996024159836 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Input Too Short Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The default message is "Please enter x more characters". It is possible to reference the substitution variables #TERM# and #MINLENGTH#.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77244371567162188 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Selection Too Big Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The default message is "You can only select x items". It is possible to reference the substitution variable #MAXSIZE#.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77248783688165646 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
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
  p_id => 77253197886169763 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
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
  p_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
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
  p_id => 77293583257184503 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Single-value Select List'
 ,p_return_value => 'SINGLE'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 77297889490186267 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Multi-value Select List'
 ,p_return_value => 'MULTI'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 77302196763188409 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Tagging Support'
 ,p_return_value => 'TAG'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77314673354266777 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Minimum Results for Search Field'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'SINGLE'
 ,p_help_text => 'The minimum number of results that must be populated in order to display the search field. A negative value always hides the search field.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77319086860270681 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
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
  p_id => 77323477987277612 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Maximum Input Length'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'TAG'
 ,p_help_text => 'Maximum number of characters that can be entered for a new option.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77327894610282426 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Maximum Selection Size'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'MULTI,TAG'
 ,p_help_text => 'The maximum number of items that can be selected.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77332300844284223 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Rapid Selection'
 ,p_attribute_type => 'CHECKBOXES'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'MULTI,TAG'
 ,p_help_text => 'Keep open the options dropdown after a selection is made, allowing for rapid selection of multiple items.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 77336673963285902 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 77332300844284223 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => ' '
 ,p_return_value => 'Y'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77349193356291493 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
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
  p_id => 77353596819292483 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 77349193356291493 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => ' '
 ,p_return_value => 'Y'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77366085522298731 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
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
  p_id => 77370491755300448 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 77366085522298731 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Contains & Ignore Case'
 ,p_return_value => 'CIC'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 77374796257301771 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 77366085522298731 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Contains & Case Sensitive'
 ,p_return_value => 'CCS'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 77379070415303740 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 77366085522298731 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Exact & Ignore Case'
 ,p_return_value => 'EIC'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 77383379419306429 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 77366085522298731 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Exact & Case Sensitive'
 ,p_return_value => 'ECS'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77395876087314871 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 9
 ,p_display_sequence => 90
 ,p_prompt => 'Label for Null Option Group'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_depending_on_attribute_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'SINGLE,MULTI'
 ,p_help_text => 'The name of the option group for records whose grouping column value is null. Overwrites the "Label for Null Option Group" attribute in component settings if filled in.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 77400293403319854 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
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
'<br><br>'||unistr('\000a')||
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
  p_id => 77404699982321819 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 11
 ,p_display_sequence => 65
 ,p_prompt => 'Drag and Drop Sorting'
 ,p_attribute_type => 'CHECKBOXES'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'TAG'
 ,p_help_text => 'Allow drag and drop sorting of selected choices.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 77409102060322353 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 77404699982321819 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => ' '
 ,p_return_value => 'Y'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 73896942242350881 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 12
 ,p_display_sequence => 55
 ,p_prompt => 'Return Value Based on'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'DISPLAY'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 77289178062182974 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'TAG'
 ,p_help_text => 'Determine whether you want the display or return column as return value. Newly added values will always return the display value. This setting is only applicable in tagging mode.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 73901849514352922 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 73896942242350881 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Display Column'
 ,p_return_value => 'DISPLAY'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 73906155401354642 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 73896942242350881 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Return Column'
 ,p_return_value => 'RETURN'
  );
wwv_flow_api.create_plugin_event (
  p_id => 72469440935891999 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_name => 'slctblur'
 ,p_display_name => 'Blur'
  );
wwv_flow_api.create_plugin_event (
  p_id => 71066959486792964 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_name => 'slctchange'
 ,p_display_name => 'Change'
  );
wwv_flow_api.create_plugin_event (
  p_id => 72436950023875666 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_name => 'slctclearing'
 ,p_display_name => 'Clearing'
  );
wwv_flow_api.create_plugin_event (
  p_id => 72465235048890304 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_name => 'slctfocus'
 ,p_display_name => 'Focus'
  );
wwv_flow_api.create_plugin_event (
  p_id => 72428546775865249 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_name => 'slcthighlight'
 ,p_display_name => 'Highlight'
  );
wwv_flow_api.create_plugin_event (
  p_id => 72424337425862556 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_name => 'slctopen'
 ,p_display_name => 'Open'
  );
wwv_flow_api.create_plugin_event (
  p_id => 72420162228860292 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_name => 'slctopening'
 ,p_display_name => 'Opening'
  );
wwv_flow_api.create_plugin_event (
  p_id => 72461032492880142 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_name => 'slctremoved'
 ,p_display_name => 'Removed'
  );
wwv_flow_api.create_plugin_event (
  p_id => 72432758896868757 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_name => 'slctselecting'
 ,p_display_name => 'Selecting'
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220626543746253656C65637432203D207B7D3B0D0A0D0A626543746253656C656374322E6576656E7473203D207B0D0A202062696E643A2066756E6374696F6E2028704974656D29207B0D0A2020202076617220706167654974656D203D202428';
wwv_flow_api.g_varchar2_table(2) := '2222202B20704974656D202B202222293B0D0A0D0A20202020706167654974656D2E6F6E28226368616E6765222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C637463';
wwv_flow_api.g_varchar2_table(3) := '68616E6765222C207B76616C3A652E76616C2C2061646465643A652E61646465642C2072656D6F7665643A652E72656D6F7665647D293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374322D6F70656E696E67222C';
wwv_flow_api.g_varchar2_table(4) := '2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C63746F70656E696E6722293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374322D6F';
wwv_flow_api.g_varchar2_table(5) := '70656E222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C63746F70656E22293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C65637432';
wwv_flow_api.g_varchar2_table(6) := '2D686967686C69676874222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C6374686967686C69676874222C207B76616C3A652E76616C2C2063686F6963653A652E6368';
wwv_flow_api.g_varchar2_table(7) := '6F6963657D293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374322D73656C656374696E67222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765';
wwv_flow_api.g_varchar2_table(8) := '722822736C637473656C656374696E67222C207B76616C3A652E76616C2C2063686F6963653A652E63686F6963657D293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374322D636C656172696E67222C2066756E63';
wwv_flow_api.g_varchar2_table(9) := '74696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C6374636C656172696E6722293B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374322D72656D6F76';
wwv_flow_api.g_varchar2_table(10) := '6564222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C637472656D6F766564222C207B76616C3A652E76616C2C2063686F6963653A652E63686F6963657D293B0D0A20';
wwv_flow_api.g_varchar2_table(11) := '2020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374322D666F637573222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C6374666F6375732229';
wwv_flow_api.g_varchar2_table(12) := '3B0D0A202020207D293B0D0A20202020706167654974656D2E6F6E282273656C656374322D626C7572222C2066756E6374696F6E286529207B0D0A202020202020617065782E6A51756572792874686973292E747269676765722822736C6374626C7572';
wwv_flow_api.g_varchar2_table(13) := '22293B0D0A202020207D293B0D0A20207D0D0A7D3B';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 74069352321933218 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2-apex.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A56657273696F6E3A20332E342E352054696D657374616D703A204D6F6E204E6F762020342030383A32323A34322050535420323031330A2A2F0A2E73656C656374322D636F6E7461696E6572207B0A202020206D617267696E3A20303B0A202020';
wwv_flow_api.g_varchar2_table(2) := '20706F736974696F6E3A2072656C61746976653B0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0A202020202F2A20696E6C696E652D626C6F636B20666F7220696537202A2F0A202020207A6F6F6D3A20313B0A202020202A646973';
wwv_flow_api.g_varchar2_table(3) := '706C61793A20696E6C696E653B0A20202020766572746963616C2D616C69676E3A206D6964646C653B0A7D0A0A2E73656C656374322D636F6E7461696E65722C0A2E73656C656374322D64726F702C0A2E73656C656374322D7365617263682C0A2E7365';
wwv_flow_api.g_varchar2_table(4) := '6C656374322D73656172636820696E707574207B0A20202F2A0A20202020466F72636520626F726465722D626F7820736F2074686174202520776964746873206669742074686520706172656E740A20202020636F6E7461696E657220776974686F7574';
wwv_flow_api.g_varchar2_table(5) := '206F7665726C61702062656361757365206F66206D617267696E2F70616464696E672E0A0A202020204D6F726520496E666F203A20687474703A2F2F7777772E717569726B736D6F64652E6F72672F6373732F626F782E68746D6C0A20202A2F0A20202D';
wwv_flow_api.g_varchar2_table(6) := '7765626B69742D626F782D73697A696E673A20626F726465722D626F783B202F2A207765626B6974202A2F0A20202020202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B202F2A2066697265666F78202A2F0A2020202020202020';
wwv_flow_api.g_varchar2_table(7) := '2020626F782D73697A696E673A20626F726465722D626F783B202F2A2063737333202A2F0A7D0A0A2E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365207B0A20202020646973706C61793A20626C6F636B3B0A202020';
wwv_flow_api.g_varchar2_table(8) := '206865696768743A20323670783B0A2020202070616464696E673A203020302030203870783B0A202020206F766572666C6F773A2068696464656E3B0A20202020706F736974696F6E3A2072656C61746976653B0A0A20202020626F726465723A203170';
wwv_flow_api.g_varchar2_table(9) := '7820736F6C696420236161613B0A2020202077686974652D73706163653A206E6F777261703B0A202020206C696E652D6865696768743A20323670783B0A20202020636F6C6F723A20233434343B0A20202020746578742D6465636F726174696F6E3A20';
wwv_flow_api.g_varchar2_table(10) := '6E6F6E653B0A0A20202020626F726465722D7261646975733A203470783B0A0A202020206261636B67726F756E642D636C69703A2070616464696E672D626F783B0A0A202020202D7765626B69742D746F7563682D63616C6C6F75743A206E6F6E653B0A';
wwv_flow_api.g_varchar2_table(11) := '2020202020202D7765626B69742D757365722D73656C6563743A206E6F6E653B0A2020202020202020202D6D6F7A2D757365722D73656C6563743A206E6F6E653B0A202020202020202020202D6D732D757365722D73656C6563743A206E6F6E653B0A20';
wwv_flow_api.g_varchar2_table(12) := '20202020202020202020202020757365722D73656C6563743A206E6F6E653B0A0A202020206261636B67726F756E642D636F6C6F723A20236666663B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E7428';
wwv_flow_api.g_varchar2_table(13) := '6C696E6561722C206C65667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302C2023656565292C20636F6C6F722D73746F7028302E352C202366666629293B0A202020206261636B67726F756E642D696D6167653A202D77';
wwv_flow_api.g_varchar2_table(14) := '65626B69742D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C20236565652030252C202366666620353025293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E7428';
wwv_flow_api.g_varchar2_table(15) := '63656E74657220626F74746F6D2C20236565652030252C202366666620353025293B0A2020202066696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F72';
wwv_flow_api.g_varchar2_table(16) := '737472203D202723666666666666272C20656E64436F6C6F72737472203D202723656565656565272C204772616469656E7454797065203D2030293B0A202020206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E742874';
wwv_flow_api.g_varchar2_table(17) := '6F702C20236666662030252C202365656520353025293B0A7D0A0A2E73656C656374322D636F6E7461696E65722E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F696365207B0A20202020626F726465722D626F74746F6D';
wwv_flow_api.g_varchar2_table(18) := '2D636F6C6F723A20236161613B0A0A20202020626F726465722D7261646975733A2030203020347078203470783B0A0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E74286C696E6561722C206C65667420';
wwv_flow_api.g_varchar2_table(19) := '626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302C2023656565292C20636F6C6F722D73746F7028302E392C202366666629293B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6C696E6561722D';
wwv_flow_api.g_varchar2_table(20) := '6772616469656E742863656E74657220626F74746F6D2C20236565652030252C202366666620393025293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E742863656E74657220626F74746F6D';
wwv_flow_api.g_varchar2_table(21) := '2C20236565652030252C202366666620393025293B0A2020202066696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F727374723D272366666666666627';
wwv_flow_api.g_varchar2_table(22) := '2C20656E64436F6C6F727374723D2723656565656565272C204772616469656E74547970653D30293B0A202020206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E7428746F702C20236565652030252C20236666662039';
wwv_flow_api.g_varchar2_table(23) := '3025293B0A7D0A0A2E73656C656374322D636F6E7461696E65722E73656C656374322D616C6C6F77636C656172202E73656C656374322D63686F696365202E73656C656374322D63686F73656E207B0A202020206D617267696E2D72696768743A203432';
wwv_flow_api.g_varchar2_table(24) := '70783B0A7D0A0A2E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365203E202E73656C656374322D63686F73656E207B0A202020206D617267696E2D72696768743A20323670783B0A20202020646973706C61793A2062';
wwv_flow_api.g_varchar2_table(25) := '6C6F636B3B0A202020206F766572666C6F773A2068696464656E3B0A0A2020202077686974652D73706163653A206E6F777261703B0A0A20202020746578742D6F766572666C6F773A20656C6C69707369733B0A7D0A0A2E73656C656374322D636F6E74';
wwv_flow_api.g_varchar2_table(26) := '61696E6572202E73656C656374322D63686F6963652061626272207B0A20202020646973706C61793A206E6F6E653B0A2020202077696474683A20313270783B0A202020206865696768743A20313270783B0A20202020706F736974696F6E3A20616273';
wwv_flow_api.g_varchar2_table(27) := '6F6C7574653B0A2020202072696768743A20323470783B0A20202020746F703A203870783B0A0A20202020666F6E742D73697A653A203170783B0A20202020746578742D6465636F726174696F6E3A206E6F6E653B0A0A20202020626F726465723A2030';
wwv_flow_api.g_varchar2_table(28) := '3B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322E706E67272920726967687420746F70206E6F2D7265706561743B0A20202020637572736F723A20706F696E7465723B0A202020206F75';
wwv_flow_api.g_varchar2_table(29) := '746C696E653A20303B0A7D0A0A2E73656C656374322D636F6E7461696E65722E73656C656374322D616C6C6F77636C656172202E73656C656374322D63686F6963652061626272207B0A20202020646973706C61793A20696E6C696E652D626C6F636B3B';
wwv_flow_api.g_varchar2_table(30) := '0A7D0A0A2E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F69636520616262723A686F766572207B0A202020206261636B67726F756E642D706F736974696F6E3A207269676874202D313170783B0A20202020637572736F72';
wwv_flow_api.g_varchar2_table(31) := '3A20706F696E7465723B0A7D0A0A2E73656C656374322D64726F702D6D61736B207B0A20202020626F726465723A20303B0A202020206D617267696E3A20303B0A2020202070616464696E673A20303B0A20202020706F736974696F6E3A206669786564';
wwv_flow_api.g_varchar2_table(32) := '3B0A202020206C6566743A20303B0A20202020746F703A20303B0A202020206D696E2D6865696768743A20313030253B0A202020206D696E2D77696474683A20313030253B0A202020206865696768743A206175746F3B0A2020202077696474683A2061';
wwv_flow_api.g_varchar2_table(33) := '75746F3B0A202020206F7061636974793A20303B0A202020207A2D696E6465783A20393939383B0A202020202F2A207374796C657320726571756972656420666F7220494520746F20776F726B202A2F0A202020206261636B67726F756E642D636F6C6F';
wwv_flow_api.g_varchar2_table(34) := '723A20236666663B0A2020202066696C7465723A20616C706861286F7061636974793D30293B0A7D0A0A2E73656C656374322D64726F70207B0A2020202077696474683A20313030253B0A202020206D617267696E2D746F703A202D3170783B0A202020';
wwv_flow_api.g_varchar2_table(35) := '20706F736974696F6E3A206162736F6C7574653B0A202020207A2D696E6465783A20393939393B0A20202020746F703A20313030253B0A0A202020206261636B67726F756E643A20236666663B0A20202020636F6C6F723A20233030303B0A2020202062';
wwv_flow_api.g_varchar2_table(36) := '6F726465723A2031707820736F6C696420236161613B0A20202020626F726465722D746F703A20303B0A0A20202020626F726465722D7261646975733A2030203020347078203470783B0A0A202020202D7765626B69742D626F782D736861646F773A20';
wwv_flow_api.g_varchar2_table(37) := '302034707820357078207267626128302C20302C20302C202E3135293B0A202020202020202020202020626F782D736861646F773A20302034707820357078207267626128302C20302C20302C202E3135293B0A7D0A0A2E73656C656374322D64726F70';
wwv_flow_api.g_varchar2_table(38) := '2D6175746F2D7769647468207B0A20202020626F726465722D746F703A2031707820736F6C696420236161613B0A2020202077696474683A206175746F3B0A7D0A0A2E73656C656374322D64726F702D6175746F2D7769647468202E73656C656374322D';
wwv_flow_api.g_varchar2_table(39) := '736561726368207B0A2020202070616464696E672D746F703A203470783B0A7D0A0A2E73656C656374322D64726F702E73656C656374322D64726F702D61626F7665207B0A202020206D617267696E2D746F703A203170783B0A20202020626F72646572';
wwv_flow_api.g_varchar2_table(40) := '2D746F703A2031707820736F6C696420236161613B0A20202020626F726465722D626F74746F6D3A20303B0A0A20202020626F726465722D7261646975733A2034707820347078203020303B0A0A202020202D7765626B69742D626F782D736861646F77';
wwv_flow_api.g_varchar2_table(41) := '3A2030202D34707820357078207267626128302C20302C20302C202E3135293B0A202020202020202020202020626F782D736861646F773A2030202D34707820357078207267626128302C20302C20302C202E3135293B0A7D0A0A2E73656C656374322D';
wwv_flow_api.g_varchar2_table(42) := '64726F702D616374697665207B0A20202020626F726465723A2031707820736F6C696420233538393766623B0A20202020626F726465722D746F703A206E6F6E653B0A7D0A0A2E73656C656374322D64726F702E73656C656374322D64726F702D61626F';
wwv_flow_api.g_varchar2_table(43) := '76652E73656C656374322D64726F702D616374697665207B0A20202020626F726465722D746F703A2031707820736F6C696420233538393766623B0A7D0A0A2E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365202E73';
wwv_flow_api.g_varchar2_table(44) := '656C656374322D6172726F77207B0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0A2020202077696474683A20313870783B0A202020206865696768743A20313030253B0A20202020706F736974696F6E3A206162736F6C7574653B';
wwv_flow_api.g_varchar2_table(45) := '0A2020202072696768743A20303B0A20202020746F703A20303B0A0A20202020626F726465722D6C6566743A2031707820736F6C696420236161613B0A20202020626F726465722D7261646975733A2030203470782034707820303B0A0A202020206261';
wwv_flow_api.g_varchar2_table(46) := '636B67726F756E642D636C69703A2070616464696E672D626F783B0A0A202020206261636B67726F756E643A20236363633B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E74286C696E6561722C206C65';
wwv_flow_api.g_varchar2_table(47) := '667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302C2023636363292C20636F6C6F722D73746F7028302E362C202365656529293B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6C696E65';
wwv_flow_api.g_varchar2_table(48) := '61722D6772616469656E742863656E74657220626F74746F6D2C20236363632030252C202365656520363025293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E742863656E74657220626F74';
wwv_flow_api.g_varchar2_table(49) := '746F6D2C20236363632030252C202365656520363025293B0A2020202066696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F72737472203D2027236565';
wwv_flow_api.g_varchar2_table(50) := '65656565272C20656E64436F6C6F72737472203D202723636363636363272C204772616469656E7454797065203D2030293B0A202020206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E7428746F702C20236363632030';
wwv_flow_api.g_varchar2_table(51) := '252C202365656520363025293B0A7D0A0A2E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365202E73656C656374322D6172726F772062207B0A20202020646973706C61793A20626C6F636B3B0A202020207769647468';
wwv_flow_api.g_varchar2_table(52) := '3A20313030253B0A202020206865696768743A20313030253B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D7265706561742030203170783B0A7D0A0A2E73656C';
wwv_flow_api.g_varchar2_table(53) := '656374322D736561726368207B0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0A2020202077696474683A20313030253B0A202020206D696E2D6865696768743A20323670783B0A202020206D617267696E3A20303B0A2020202070';
wwv_flow_api.g_varchar2_table(54) := '616464696E672D6C6566743A203470783B0A2020202070616464696E672D72696768743A203470783B0A0A20202020706F736974696F6E3A2072656C61746976653B0A202020207A2D696E6465783A2031303030303B0A0A2020202077686974652D7370';
wwv_flow_api.g_varchar2_table(55) := '6163653A206E6F777261703B0A7D0A0A2E73656C656374322D73656172636820696E707574207B0A2020202077696474683A20313030253B0A202020206865696768743A206175746F2021696D706F7274616E743B0A202020206D696E2D686569676874';
wwv_flow_api.g_varchar2_table(56) := '3A20323670783B0A2020202070616464696E673A20347078203230707820347078203570783B0A202020206D617267696E3A20303B0A0A202020206F75746C696E653A20303B0A20202020666F6E742D66616D696C793A2073616E732D73657269663B0A';
wwv_flow_api.g_varchar2_table(57) := '20202020666F6E742D73697A653A2031656D3B0A0A20202020626F726465723A2031707820736F6C696420236161613B0A20202020626F726465722D7261646975733A20303B0A0A202020202D7765626B69742D626F782D736861646F773A206E6F6E65';
wwv_flow_api.g_varchar2_table(58) := '3B0A202020202020202020202020626F782D736861646F773A206E6F6E653B0A0A202020206261636B67726F756E643A20236666662075726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D726570656174203130';
wwv_flow_api.g_varchar2_table(59) := '3025202D323270783B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D7265706561742031303025202D323270782C202D7765626B69742D6772616469656E74286C';
wwv_flow_api.g_varchar2_table(60) := '696E6561722C206C65667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302E38352C2023666666292C20636F6C6F722D73746F7028302E39392C202365656529293B0A202020206261636B67726F756E643A2075726C2827';
wwv_flow_api.g_varchar2_table(61) := '23504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D7265706561742031303025202D323270782C202D7765626B69742D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C2023666666203835252C20';
wwv_flow_api.g_varchar2_table(62) := '2365656520393925293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D7265706561742031303025202D323270782C202D6D6F7A2D6C696E6561722D6772616469';
wwv_flow_api.g_varchar2_table(63) := '656E742863656E74657220626F74746F6D2C2023666666203835252C202365656520393925293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D72657065617420';
wwv_flow_api.g_varchar2_table(64) := '31303025202D323270782C206C696E6561722D6772616469656E7428746F702C2023666666203835252C202365656520393925293B0A7D0A0A2E73656C656374322D64726F702E73656C656374322D64726F702D61626F7665202E73656C656374322D73';
wwv_flow_api.g_varchar2_table(65) := '656172636820696E707574207B0A202020206D617267696E2D746F703A203470783B0A7D0A0A2E73656C656374322D73656172636820696E7075742E73656C656374322D616374697665207B0A202020206261636B67726F756E643A2023666666207572';
wwv_flow_api.g_varchar2_table(66) := '6C282723504C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030253B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322D';
wwv_flow_api.g_varchar2_table(67) := '7370696E6E65722E6769662729206E6F2D72657065617420313030252C202D7765626B69742D6772616469656E74286C696E6561722C206C65667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302E38352C202366666629';
wwv_flow_api.g_varchar2_table(68) := '2C20636F6C6F722D73746F7028302E39392C202365656529293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030252C';
wwv_flow_api.g_varchar2_table(69) := '202D7765626B69742D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C2023666666203835252C202365656520393925293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C';
wwv_flow_api.g_varchar2_table(70) := '656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030252C202D6D6F7A2D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C2023666666203835252C202365656520393925293B0A202020206261636B';
wwv_flow_api.g_varchar2_table(71) := '67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030252C206C696E6561722D6772616469656E7428746F702C2023666666203835252C20236565';
wwv_flow_api.g_varchar2_table(72) := '6520393925293B0A7D0A0A2E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F6963652C0A2E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F69636573207B0A20';
wwv_flow_api.g_varchar2_table(73) := '202020626F726465723A2031707820736F6C696420233538393766623B0A202020206F75746C696E653A206E6F6E653B0A0A202020202D7765626B69742D626F782D736861646F773A2030203020357078207267626128302C20302C20302C202E33293B';
wwv_flow_api.g_varchar2_table(74) := '0A202020202020202020202020626F782D736861646F773A2030203020357078207267626128302C20302C20302C202E33293B0A7D0A0A2E73656C656374322D64726F70646F776E2D6F70656E202E73656C656374322D63686F696365207B0A20202020';
wwv_flow_api.g_varchar2_table(75) := '626F726465722D626F74746F6D2D636F6C6F723A207472616E73706172656E743B0A202020202D7765626B69742D626F782D736861646F773A2030203170782030202366666620696E7365743B0A202020202020202020202020626F782D736861646F77';
wwv_flow_api.g_varchar2_table(76) := '3A2030203170782030202366666620696E7365743B0A0A20202020626F726465722D626F74746F6D2D6C6566742D7261646975733A20303B0A20202020626F726465722D626F74746F6D2D72696768742D7261646975733A20303B0A0A20202020626163';
wwv_flow_api.g_varchar2_table(77) := '6B67726F756E642D636F6C6F723A20236565653B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E74286C696E6561722C206C65667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F';
wwv_flow_api.g_varchar2_table(78) := '7028302C2023666666292C20636F6C6F722D73746F7028302E352C202365656529293B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C20236666';
wwv_flow_api.g_varchar2_table(79) := '662030252C202365656520353025293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C20236666662030252C202365656520353025293B0A2020202066';
wwv_flow_api.g_varchar2_table(80) := '696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F727374723D2723656565656565272C20656E64436F6C6F727374723D2723666666666666272C204772';
wwv_flow_api.g_varchar2_table(81) := '616469656E74547970653D30293B0A202020206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E7428746F702C20236666662030252C202365656520353025293B0A7D0A0A2E73656C656374322D64726F70646F776E2D6F';
wwv_flow_api.g_varchar2_table(82) := '70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F6963652C0A2E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F69636573207B';
wwv_flow_api.g_varchar2_table(83) := '0A20202020626F726465723A2031707820736F6C696420233538393766623B0A20202020626F726465722D746F702D636F6C6F723A207472616E73706172656E743B0A0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772';
wwv_flow_api.g_varchar2_table(84) := '616469656E74286C696E6561722C206C65667420746F702C206C65667420626F74746F6D2C20636F6C6F722D73746F7028302C2023666666292C20636F6C6F722D73746F7028302E352C202365656529293B0A202020206261636B67726F756E642D696D';
wwv_flow_api.g_varchar2_table(85) := '6167653A202D7765626B69742D6C696E6561722D6772616469656E742863656E74657220746F702C20236666662030252C202365656520353025293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469';
wwv_flow_api.g_varchar2_table(86) := '656E742863656E74657220746F702C20236666662030252C202365656520353025293B0A2020202066696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F';
wwv_flow_api.g_varchar2_table(87) := '727374723D2723656565656565272C20656E64436F6C6F727374723D2723666666666666272C204772616469656E74547970653D30293B0A202020206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E7428626F74746F6D';
wwv_flow_api.g_varchar2_table(88) := '2C20236666662030252C202365656520353025293B0A7D0A0A2E73656C656374322D64726F70646F776E2D6F70656E202E73656C656374322D63686F696365202E73656C656374322D6172726F77207B0A202020206261636B67726F756E643A20747261';
wwv_flow_api.g_varchar2_table(89) := '6E73706172656E743B0A20202020626F726465722D6C6566743A206E6F6E653B0A2020202066696C7465723A206E6F6E653B0A7D0A2E73656C656374322D64726F70646F776E2D6F70656E202E73656C656374322D63686F696365202E73656C65637432';
wwv_flow_api.g_varchar2_table(90) := '2D6172726F772062207B0A202020206261636B67726F756E642D706F736974696F6E3A202D31387078203170783B0A7D0A0A2F2A20726573756C7473202A2F0A2E73656C656374322D726573756C7473207B0A202020206D61782D6865696768743A2032';
wwv_flow_api.g_varchar2_table(91) := '303070783B0A2020202070616464696E673A203020302030203470783B0A202020206D617267696E3A20347078203470782034707820303B0A20202020706F736974696F6E3A2072656C61746976653B0A202020206F766572666C6F772D783A20686964';
wwv_flow_api.g_varchar2_table(92) := '64656E3B0A202020206F766572666C6F772D793A206175746F3B0A202020202D7765626B69742D7461702D686967686C696768742D636F6C6F723A207267626128302C20302C20302C2030293B0A7D0A0A2E73656C656374322D726573756C747320756C';
wwv_flow_api.g_varchar2_table(93) := '2E73656C656374322D726573756C742D737562207B0A202020206D617267696E3A20303B0A2020202070616464696E672D6C6566743A20303B0A7D0A0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220';
wwv_flow_api.g_varchar2_table(94) := '3E206C69202E73656C656374322D726573756C742D6C6162656C207B2070616464696E672D6C6566743A2032307078207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D';
wwv_flow_api.g_varchar2_table(95) := '726573756C742D737562203E206C69202E73656C656374322D726573756C742D6C6162656C207B2070616464696E672D6C6566743A2034307078207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220';
wwv_flow_api.g_varchar2_table(96) := '756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D737562203E206C69202E73656C656374322D726573756C742D6C6162656C207B2070616464696E672D6C6566743A2036307078207D0A2E73656C6563';
wwv_flow_api.g_varchar2_table(97) := '74322D726573756C747320756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D737562203E';
wwv_flow_api.g_varchar2_table(98) := '206C69202E73656C656374322D726573756C742D6C6162656C207B2070616464696E672D6C6566743A2038307078207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D72';
wwv_flow_api.g_varchar2_table(99) := '6573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D737562203E206C69202E73656C656374322D726573756C742D6C6162';
wwv_flow_api.g_varchar2_table(100) := '656C207B2070616464696E672D6C6566743A203130307078207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D72';
wwv_flow_api.g_varchar2_table(101) := '6573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D737562203E206C69202E73656C656374322D726573756C742D6C6162';
wwv_flow_api.g_varchar2_table(102) := '656C207B2070616464696E672D6C6566743A203131307078207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D72';
wwv_flow_api.g_varchar2_table(103) := '6573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D737562203E20';
wwv_flow_api.g_varchar2_table(104) := '6C69202E73656C656374322D726573756C742D6C6162656C207B2070616464696E672D6C6566743A203132307078207D0A0A2E73656C656374322D726573756C7473206C69207B0A202020206C6973742D7374796C653A206E6F6E653B0A202020206469';
wwv_flow_api.g_varchar2_table(105) := '73706C61793A206C6973742D6974656D3B0A202020206261636B67726F756E642D696D6167653A206E6F6E653B0A7D0A0A2E73656C656374322D726573756C7473206C692E73656C656374322D726573756C742D776974682D6368696C6472656E203E20';
wwv_flow_api.g_varchar2_table(106) := '2E73656C656374322D726573756C742D6C6162656C207B0A20202020666F6E742D7765696768743A20626F6C643B0A7D0A0A2E73656C656374322D726573756C7473202E73656C656374322D726573756C742D6C6162656C207B0A202020207061646469';
wwv_flow_api.g_varchar2_table(107) := '6E673A2033707820377078203470783B0A202020206D617267696E3A20303B0A20202020637572736F723A20706F696E7465723B0A0A202020206D696E2D6865696768743A2031656D3B0A0A202020202D7765626B69742D746F7563682D63616C6C6F75';
wwv_flow_api.g_varchar2_table(108) := '743A206E6F6E653B0A2020202020202D7765626B69742D757365722D73656C6563743A206E6F6E653B0A2020202020202020202D6D6F7A2D757365722D73656C6563743A206E6F6E653B0A202020202020202020202D6D732D757365722D73656C656374';
wwv_flow_api.g_varchar2_table(109) := '3A206E6F6E653B0A2020202020202020202020202020757365722D73656C6563743A206E6F6E653B0A7D0A0A2E73656C656374322D726573756C7473202E73656C656374322D686967686C696768746564207B0A202020206261636B67726F756E643A20';
wwv_flow_api.g_varchar2_table(110) := '233338373564373B0A20202020636F6C6F723A20236666663B0A7D0A0A2E73656C656374322D726573756C7473206C6920656D207B0A202020206261636B67726F756E643A20236665666664653B0A20202020666F6E742D7374796C653A206E6F726D61';
wwv_flow_api.g_varchar2_table(111) := '6C3B0A7D0A0A2E73656C656374322D726573756C7473202E73656C656374322D686967686C69676874656420656D207B0A202020206261636B67726F756E643A207472616E73706172656E743B0A7D0A0A2E73656C656374322D726573756C7473202E73';
wwv_flow_api.g_varchar2_table(112) := '656C656374322D686967686C69676874656420756C207B0A202020206261636B67726F756E643A20236666663B0A20202020636F6C6F723A20233030303B0A7D0A0A0A2E73656C656374322D726573756C7473202E73656C656374322D6E6F2D72657375';
wwv_flow_api.g_varchar2_table(113) := '6C74732C0A2E73656C656374322D726573756C7473202E73656C656374322D736561726368696E672C0A2E73656C656374322D726573756C7473202E73656C656374322D73656C656374696F6E2D6C696D6974207B0A202020206261636B67726F756E64';
wwv_flow_api.g_varchar2_table(114) := '3A20236634663466343B0A20202020646973706C61793A206C6973742D6974656D3B0A7D0A0A2F2A0A64697361626C6564206C6F6F6B20666F722064697361626C65642063686F6963657320696E2074686520726573756C74732064726F70646F776E0A';
wwv_flow_api.g_varchar2_table(115) := '2A2F0A2E73656C656374322D726573756C7473202E73656C656374322D64697361626C65642E73656C656374322D686967686C696768746564207B0A20202020636F6C6F723A20233636363B0A202020206261636B67726F756E643A2023663466346634';
wwv_flow_api.g_varchar2_table(116) := '3B0A20202020646973706C61793A206C6973742D6974656D3B0A20202020637572736F723A2064656661756C743B0A7D0A2E73656C656374322D726573756C7473202E73656C656374322D64697361626C6564207B0A20206261636B67726F756E643A20';
wwv_flow_api.g_varchar2_table(117) := '236634663466343B0A2020646973706C61793A206C6973742D6974656D3B0A2020637572736F723A2064656661756C743B0A7D0A0A2E73656C656374322D726573756C7473202E73656C656374322D73656C6563746564207B0A20202020646973706C61';
wwv_flow_api.g_varchar2_table(118) := '793A206E6F6E653B0A7D0A0A2E73656C656374322D6D6F72652D726573756C74732E73656C656374322D616374697665207B0A202020206261636B67726F756E643A20236634663466342075726C282723504C5547494E5F5052454649582373656C6563';
wwv_flow_api.g_varchar2_table(119) := '74322D7370696E6E65722E6769662729206E6F2D72657065617420313030253B0A7D0A0A2E73656C656374322D6D6F72652D726573756C7473207B0A202020206261636B67726F756E643A20236634663466343B0A20202020646973706C61793A206C69';
wwv_flow_api.g_varchar2_table(120) := '73742D6974656D3B0A7D0A0A2F2A2064697361626C6564207374796C6573202A2F0A0A2E73656C656374322D636F6E7461696E65722E73656C656374322D636F6E7461696E65722D64697361626C6564202E73656C656374322D63686F696365207B0A20';
wwv_flow_api.g_varchar2_table(121) := '2020206261636B67726F756E642D636F6C6F723A20236634663466343B0A202020206261636B67726F756E642D696D6167653A206E6F6E653B0A20202020626F726465723A2031707820736F6C696420236464643B0A20202020637572736F723A206465';
wwv_flow_api.g_varchar2_table(122) := '6661756C743B0A7D0A0A2E73656C656374322D636F6E7461696E65722E73656C656374322D636F6E7461696E65722D64697361626C6564202E73656C656374322D63686F696365202E73656C656374322D6172726F77207B0A202020206261636B67726F';
wwv_flow_api.g_varchar2_table(123) := '756E642D636F6C6F723A20236634663466343B0A202020206261636B67726F756E642D696D6167653A206E6F6E653B0A20202020626F726465722D6C6566743A20303B0A7D0A0A2E73656C656374322D636F6E7461696E65722E73656C656374322D636F';
wwv_flow_api.g_varchar2_table(124) := '6E7461696E65722D64697361626C6564202E73656C656374322D63686F6963652061626272207B0A20202020646973706C61793A206E6F6E653B0A7D0A0A0A2F2A206D756C746973656C656374202A2F0A0A2E73656C656374322D636F6E7461696E6572';
wwv_flow_api.g_varchar2_table(125) := '2D6D756C7469202E73656C656374322D63686F69636573207B0A202020206865696768743A206175746F2021696D706F7274616E743B0A202020206865696768743A2031253B0A202020206D617267696E3A20303B0A2020202070616464696E673A2030';
wwv_flow_api.g_varchar2_table(126) := '3B0A20202020706F736974696F6E3A2072656C61746976653B0A0A20202020626F726465723A2031707820736F6C696420236161613B0A20202020637572736F723A20746578743B0A202020206F766572666C6F773A2068696464656E3B0A0A20202020';
wwv_flow_api.g_varchar2_table(127) := '6261636B67726F756E642D636F6C6F723A20236666663B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E74286C696E6561722C2030252030252C20302520313030252C20636F6C6F722D73746F70283125';
wwv_flow_api.g_varchar2_table(128) := '2C2023656565292C20636F6C6F722D73746F70283135252C202366666629293B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6C696E6561722D6772616469656E7428746F702C20236565652031252C2023666666203135';
wwv_flow_api.g_varchar2_table(129) := '25293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E7428746F702C20236565652031252C202366666620313525293B0A202020206261636B67726F756E642D696D6167653A206C696E656172';
wwv_flow_api.g_varchar2_table(130) := '2D6772616469656E7428746F702C20236565652031252C202366666620313525293B0A7D0A0A2E73656C656374322D6C6F636B6564207B0A202070616464696E673A203370782035707820337078203570782021696D706F7274616E743B0A7D0A0A2E73';
wwv_flow_api.g_varchar2_table(131) := '656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573207B0A202020206D696E2D6865696768743A20323670783B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C74692E73656C656374322D';
wwv_flow_api.g_varchar2_table(132) := '636F6E7461696E65722D616374697665202E73656C656374322D63686F69636573207B0A20202020626F726465723A2031707820736F6C696420233538393766623B0A202020206F75746C696E653A206E6F6E653B0A0A202020202D7765626B69742D62';
wwv_flow_api.g_varchar2_table(133) := '6F782D736861646F773A2030203020357078207267626128302C20302C20302C202E33293B0A202020202020202020202020626F782D736861646F773A2030203020357078207267626128302C20302C20302C202E33293B0A7D0A2E73656C656374322D';
wwv_flow_api.g_varchar2_table(134) := '636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573206C69207B0A20202020666C6F61743A206C6566743B0A202020206C6973742D7374796C653A206E6F6E653B0A7D0A2E73656C656374322D636F6E7461696E65722D6D75';
wwv_flow_api.g_varchar2_table(135) := '6C7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D6669656C64207B0A202020206D617267696E3A20303B0A2020202070616464696E673A20303B0A2020202077686974652D73706163653A206E6F777261703B';
wwv_flow_api.g_varchar2_table(136) := '0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D6669656C6420696E707574207B0A2020202070616464696E673A203570783B0A202020206D61';
wwv_flow_api.g_varchar2_table(137) := '7267696E3A2031707820303B0A0A20202020666F6E742D66616D696C793A2073616E732D73657269663B0A20202020666F6E742D73697A653A20313030253B0A20202020636F6C6F723A20233636363B0A202020206F75746C696E653A20303B0A202020';
wwv_flow_api.g_varchar2_table(138) := '20626F726465723A20303B0A202020202D7765626B69742D626F782D736861646F773A206E6F6E653B0A202020202020202020202020626F782D736861646F773A206E6F6E653B0A202020206261636B67726F756E643A207472616E73706172656E7420';
wwv_flow_api.g_varchar2_table(139) := '21696D706F7274616E743B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D6669656C6420696E7075742E73656C656374322D61637469766520';
wwv_flow_api.g_varchar2_table(140) := '7B0A202020206261636B67726F756E643A20236666662075726C282723504C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030252021696D706F7274616E743B0A7D0A0A2E73656C65';
wwv_flow_api.g_varchar2_table(141) := '6374322D64656661756C74207B0A20202020636F6C6F723A20233939392021696D706F7274616E743B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573202E73656C656374322D73656172';
wwv_flow_api.g_varchar2_table(142) := '63682D63686F696365207B0A2020202070616464696E673A20337078203570782033707820313870783B0A202020206D617267696E3A20337078203020337078203570783B0A20202020706F736974696F6E3A2072656C61746976653B0A0A202020206C';
wwv_flow_api.g_varchar2_table(143) := '696E652D6865696768743A20313370783B0A20202020636F6C6F723A20233333333B0A20202020637572736F723A2064656661756C743B0A20202020626F726465723A2031707820736F6C696420236161616161613B0A0A20202020626F726465722D72';
wwv_flow_api.g_varchar2_table(144) := '61646975733A203370783B0A0A202020202D7765626B69742D626F782D736861646F773A2030203020327078202366666620696E7365742C2030203170782030207267626128302C20302C20302C20302E3035293B0A202020202020202020202020626F';
wwv_flow_api.g_varchar2_table(145) := '782D736861646F773A2030203020327078202366666620696E7365742C2030203170782030207267626128302C20302C20302C20302E3035293B0A0A202020206261636B67726F756E642D636C69703A2070616464696E672D626F783B0A0A202020202D';
wwv_flow_api.g_varchar2_table(146) := '7765626B69742D746F7563682D63616C6C6F75743A206E6F6E653B0A2020202020202D7765626B69742D757365722D73656C6563743A206E6F6E653B0A2020202020202020202D6D6F7A2D757365722D73656C6563743A206E6F6E653B0A202020202020';
wwv_flow_api.g_varchar2_table(147) := '202020202D6D732D757365722D73656C6563743A206E6F6E653B0A2020202020202020202020202020757365722D73656C6563743A206E6F6E653B0A0A202020206261636B67726F756E642D636F6C6F723A20236534653465343B0A2020202066696C74';
wwv_flow_api.g_varchar2_table(148) := '65723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F727374723D2723656565656565272C20656E64436F6C6F727374723D2723663466346634272C204772616469';
wwv_flow_api.g_varchar2_table(149) := '656E74547970653D30293B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E74286C696E6561722C2030252030252C20302520313030252C20636F6C6F722D73746F70283230252C2023663466346634292C';
wwv_flow_api.g_varchar2_table(150) := '20636F6C6F722D73746F70283530252C2023663066306630292C20636F6C6F722D73746F70283532252C2023653865386538292C20636F6C6F722D73746F7028313030252C202365656529293B0A202020206261636B67726F756E642D696D6167653A20';
wwv_flow_api.g_varchar2_table(151) := '2D7765626B69742D6C696E6561722D6772616469656E7428746F702C2023663466346634203230252C2023663066306630203530252C2023653865386538203532252C20236565652031303025293B0A202020206261636B67726F756E642D696D616765';
wwv_flow_api.g_varchar2_table(152) := '3A202D6D6F7A2D6C696E6561722D6772616469656E7428746F702C2023663466346634203230252C2023663066306630203530252C2023653865386538203532252C20236565652031303025293B0A202020206261636B67726F756E642D696D6167653A';
wwv_flow_api.g_varchar2_table(153) := '206C696E6561722D6772616469656E7428746F702C2023663466346634203230252C2023663066306630203530252C2023653865386538203532252C20236565652031303025293B0A7D0A2E73656C656374322D636F6E7461696E65722D6D756C746920';
wwv_flow_api.g_varchar2_table(154) := '2E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63686F696365202E73656C656374322D63686F73656E207B0A20202020637572736F723A2064656661756C743B0A7D0A2E73656C656374322D636F6E7461696E65722D';
wwv_flow_api.g_varchar2_table(155) := '6D756C7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63686F6963652D666F637573207B0A202020206261636B67726F756E643A20236434643464343B0A7D0A0A2E73656C656374322D7365617263682D6368';
wwv_flow_api.g_varchar2_table(156) := '6F6963652D636C6F7365207B0A20202020646973706C61793A20626C6F636B3B0A2020202077696474683A20313270783B0A202020206865696768743A20313370783B0A20202020706F736974696F6E3A206162736F6C7574653B0A2020202072696768';
wwv_flow_api.g_varchar2_table(157) := '743A203370783B0A20202020746F703A203470783B0A0A20202020666F6E742D73697A653A203170783B0A202020206F75746C696E653A206E6F6E653B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F505245464958237365';
wwv_flow_api.g_varchar2_table(158) := '6C656374322E706E67272920726967687420746F70206E6F2D7265706561743B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D7365617263682D63686F6963652D636C6F7365207B0A202020206C656674';
wwv_flow_api.g_varchar2_table(159) := '3A203370783B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63686F696365202E73656C656374322D7365617263682D63686F6963652D636C';
wwv_flow_api.g_varchar2_table(160) := '6F73653A686F766572207B0A20206261636B67726F756E642D706F736974696F6E3A207269676874202D313170783B0A7D0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573202E73656C65637432';
wwv_flow_api.g_varchar2_table(161) := '2D7365617263682D63686F6963652D666F637573202E73656C656374322D7365617263682D63686F6963652D636C6F7365207B0A202020206261636B67726F756E642D706F736974696F6E3A207269676874202D313170783B0A7D0A0A2F2A2064697361';
wwv_flow_api.g_varchar2_table(162) := '626C6564207374796C6573202A2F0A2E73656C656374322D636F6E7461696E65722D6D756C74692E73656C656374322D636F6E7461696E65722D64697361626C6564202E73656C656374322D63686F69636573207B0A202020206261636B67726F756E64';
wwv_flow_api.g_varchar2_table(163) := '2D636F6C6F723A20236634663466343B0A202020206261636B67726F756E642D696D6167653A206E6F6E653B0A20202020626F726465723A2031707820736F6C696420236464643B0A20202020637572736F723A2064656661756C743B0A7D0A0A2E7365';
wwv_flow_api.g_varchar2_table(164) := '6C656374322D636F6E7461696E65722D6D756C74692E73656C656374322D636F6E7461696E65722D64697361626C6564202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63686F696365207B0A202020207061646469';
wwv_flow_api.g_varchar2_table(165) := '6E673A203370782035707820337078203570783B0A20202020626F726465723A2031707820736F6C696420236464643B0A202020206261636B67726F756E642D696D6167653A206E6F6E653B0A202020206261636B67726F756E642D636F6C6F723A2023';
wwv_flow_api.g_varchar2_table(166) := '6634663466343B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C74692E73656C656374322D636F6E7461696E65722D64697361626C6564202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63686F69';
wwv_flow_api.g_varchar2_table(167) := '6365202E73656C656374322D7365617263682D63686F6963652D636C6F7365207B20202020646973706C61793A206E6F6E653B0A202020206261636B67726F756E643A206E6F6E653B0A7D0A2F2A20656E64206D756C746973656C656374202A2F0A0A0A';
wwv_flow_api.g_varchar2_table(168) := '2E73656C656374322D726573756C742D73656C65637461626C65202E73656C656374322D6D617463682C0A2E73656C656374322D726573756C742D756E73656C65637461626C65202E73656C656374322D6D61746368207B0A20202020746578742D6465';
wwv_flow_api.g_varchar2_table(169) := '636F726174696F6E3A20756E6465726C696E653B0A7D0A0A2E73656C656374322D6F666673637265656E2C202E73656C656374322D6F666673637265656E3A666F637573207B0A20202020636C69703A20726563742830203020302030292021696D706F';
wwv_flow_api.g_varchar2_table(170) := '7274616E743B0A2020202077696474683A203170782021696D706F7274616E743B0A202020206865696768743A203170782021696D706F7274616E743B0A20202020626F726465723A20302021696D706F7274616E743B0A202020206D617267696E3A20';
wwv_flow_api.g_varchar2_table(171) := '302021696D706F7274616E743B0A2020202070616464696E673A20302021696D706F7274616E743B0A202020206F766572666C6F773A2068696464656E2021696D706F7274616E743B0A20202020706F736974696F6E3A206162736F6C7574652021696D';
wwv_flow_api.g_varchar2_table(172) := '706F7274616E743B0A202020206F75746C696E653A20302021696D706F7274616E743B0A202020206C6566743A203070782021696D706F7274616E743B0A20202020746F703A203070782021696D706F7274616E743B0A7D0A0A2E73656C656374322D64';
wwv_flow_api.g_varchar2_table(173) := '6973706C61792D6E6F6E65207B0A20202020646973706C61793A206E6F6E653B0A7D0A0A2E73656C656374322D6D6561737572652D7363726F6C6C626172207B0A20202020706F736974696F6E3A206162736F6C7574653B0A20202020746F703A202D31';
wwv_flow_api.g_varchar2_table(174) := '3030303070783B0A202020206C6566743A202D313030303070783B0A2020202077696474683A2031303070783B0A202020206865696768743A2031303070783B0A202020206F766572666C6F773A207363726F6C6C3B0A7D0A2F2A20526574696E612D69';
wwv_flow_api.g_varchar2_table(175) := '7A652069636F6E73202A2F0A0A406D65646961206F6E6C792073637265656E20616E6420282D7765626B69742D6D696E2D6465766963652D706978656C2D726174696F3A20312E35292C206F6E6C792073637265656E20616E6420286D696E2D7265736F';
wwv_flow_api.g_varchar2_table(176) := '6C7574696F6E3A203134346470692920207B0A20202E73656C656374322D73656172636820696E7075742C202E73656C656374322D7365617263682D63686F6963652D636C6F73652C202E73656C656374322D636F6E7461696E6572202E73656C656374';
wwv_flow_api.g_varchar2_table(177) := '322D63686F69636520616262722C202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365202E73656C656374322D6172726F772062207B0A2020202020206261636B67726F756E642D696D6167653A2075726C28272350';
wwv_flow_api.g_varchar2_table(178) := '4C5547494E5F5052454649582373656C6563743278322E706E6727292021696D706F7274616E743B0A2020202020206261636B67726F756E642D7265706561743A206E6F2D7265706561742021696D706F7274616E743B0A2020202020206261636B6772';
wwv_flow_api.g_varchar2_table(179) := '6F756E642D73697A653A203630707820343070782021696D706F7274616E743B0A20207D0A20202E73656C656374322D73656172636820696E707574207B0A2020202020206261636B67726F756E642D706F736974696F6E3A2031303025202D32317078';
wwv_flow_api.g_varchar2_table(180) := '2021696D706F7274616E743B0A20207D0A7D0A';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 74247231575112229 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2.css'
 ,p_mime_type => 'text/css'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A436F7079726967687420323031322049676F72205661796E626572670A0A56657273696F6E3A20332E342E352054696D657374616D703A204D6F6E204E6F762020342030383A32323A34322050535420323031330A0A5468697320736F66747761';
wwv_flow_api.g_varchar2_table(2) := '7265206973206C6963656E73656420756E6465722074686520417061636865204C6963656E73652C2056657273696F6E20322E3020287468652022417061636865204C6963656E73652229206F722074686520474E550A47656E6572616C205075626C69';
wwv_flow_api.g_varchar2_table(3) := '63204C6963656E73652076657273696F6E20322028746865202247504C204C6963656E736522292E20596F75206D61792063686F6F736520656974686572206C6963656E736520746F20676F7665726E20796F75720A757365206F66207468697320736F';
wwv_flow_api.g_varchar2_table(4) := '667477617265206F6E6C792075706F6E2074686520636F6E646974696F6E207468617420796F752061636365707420616C6C206F6620746865207465726D73206F662065697468657220746865204170616368650A4C6963656E7365206F722074686520';
wwv_flow_api.g_varchar2_table(5) := '47504C204C6963656E73652E0A0A596F75206D6179206F627461696E206120636F7079206F662074686520417061636865204C6963656E736520616E64207468652047504C204C6963656E73652061743A0A0A687474703A2F2F7777772E617061636865';
wwv_flow_api.g_varchar2_table(6) := '2E6F72672F6C6963656E7365732F4C4943454E53452D322E300A687474703A2F2F7777772E676E752E6F72672F6C6963656E7365732F67706C2D322E302E68746D6C0A0A556E6C657373207265717569726564206279206170706C696361626C65206C61';
wwv_flow_api.g_varchar2_table(7) := '77206F722061677265656420746F20696E2077726974696E672C20736F66747761726520646973747269627574656420756E6465722074686520417061636865204C6963656E73650A6F72207468652047504C204C696365736E73652069732064697374';
wwv_flow_api.g_varchar2_table(8) := '72696275746564206F6E20616E20224153204953222042415349532C20574954484F55542057415252414E54494553204F5220434F4E444954494F4E53204F4620414E59204B494E442C0A6569746865722065787072657373206F7220696D706C696564';
wwv_flow_api.g_varchar2_table(9) := '2E205365652074686520417061636865204C6963656E736520616E64207468652047504C204C6963656E736520666F7220746865207370656369666963206C616E677561676520676F7665726E696E670A7065726D697373696F6E7320616E64206C696D';
wwv_flow_api.g_varchar2_table(10) := '69746174696F6E7320756E6465722074686520417061636865204C6963656E736520616E64207468652047504C204C6963656E73652E0A2A2F0A2166756E6374696F6E2861297B22756E646566696E6564223D3D747970656F6620612E666E2E65616368';
wwv_flow_api.g_varchar2_table(11) := '322626612E657874656E6428612E666E2C7B65616368323A66756E6374696F6E2862297B666F722876617220633D61285B305D292C643D2D312C653D746869732E6C656E6774683B2B2B643C65262628632E636F6E746578743D635B305D3D746869735B';
wwv_flow_api.g_varchar2_table(12) := '645D292626622E63616C6C28635B305D2C642C6329213D3D21313B293B72657475726E20746869737D7D297D286A5175657279292C66756E6374696F6E28612C62297B2275736520737472696374223B66756E6374696F6E206E2861297B76617220622C';
wwv_flow_api.g_varchar2_table(13) := '632C642C653B69662821617C7C612E6C656E6774683C312972657475726E20613B666F7228623D22222C633D302C643D612E6C656E6774683B643E633B632B2B29653D612E6368617241742863292C622B3D6D5B655D7C7C653B72657475726E20627D66';
wwv_flow_api.g_varchar2_table(14) := '756E6374696F6E206F28612C62297B666F722876617220633D302C643D622E6C656E6774683B643E633B632B3D31296966287128612C625B635D292972657475726E20633B72657475726E2D317D66756E6374696F6E207028297B76617220623D61286C';
wwv_flow_api.g_varchar2_table(15) := '293B622E617070656E64546F2822626F647922293B76617220633D7B77696474683A622E776964746828292D625B305D2E636C69656E7457696474682C6865696768743A622E68656967687428292D625B305D2E636C69656E744865696768747D3B7265';
wwv_flow_api.g_varchar2_table(16) := '7475726E20622E72656D6F766528292C637D66756E6374696F6E207128612C63297B72657475726E20613D3D3D633F21303A613D3D3D627C7C633D3D3D623F21313A6E756C6C3D3D3D617C7C6E756C6C3D3D3D633F21313A612E636F6E7374727563746F';
wwv_flow_api.g_varchar2_table(17) := '723D3D3D537472696E673F612B22223D3D632B22223A632E636F6E7374727563746F723D3D3D537472696E673F632B22223D3D612B22223A21317D66756E6374696F6E207228622C63297B76617220642C652C663B6966286E756C6C3D3D3D627C7C622E';
wwv_flow_api.g_varchar2_table(18) := '6C656E6774683C312972657475726E5B5D3B666F7228643D622E73706C69742863292C653D302C663D642E6C656E6774683B663E653B652B3D3129645B655D3D612E7472696D28645B655D293B72657475726E20647D66756E6374696F6E20732861297B';
wwv_flow_api.g_varchar2_table(19) := '72657475726E20612E6F757465725769647468282131292D612E776964746828297D66756E6374696F6E20742863297B76617220643D226B657975702D6368616E67652D76616C7565223B632E6F6E28226B6579646F776E222C66756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(20) := '7B612E6461746128632C64293D3D3D622626612E6461746128632C642C632E76616C2829297D292C632E6F6E28226B65797570222C66756E6374696F6E28297B76617220653D612E6461746128632C64293B65213D3D622626632E76616C2829213D3D65';
wwv_flow_api.g_varchar2_table(21) := '262628612E72656D6F76654461746128632C64292C632E7472696767657228226B657975702D6368616E67652229297D297D66756E6374696F6E20752863297B632E6F6E28226D6F7573656D6F7665222C66756E6374696F6E2863297B76617220643D69';
wwv_flow_api.g_varchar2_table(22) := '3B28643D3D3D627C7C642E78213D3D632E70616765587C7C642E79213D3D632E70616765592926266128632E746172676574292E7472696767657228226D6F7573656D6F76652D66696C7465726564222C63297D297D66756E6374696F6E207628612C63';
wwv_flow_api.g_varchar2_table(23) := '2C64297B643D647C7C623B76617220653B72657475726E2066756E6374696F6E28297B76617220623D617267756D656E74733B77696E646F772E636C65617254696D656F75742865292C653D77696E646F772E73657454696D656F75742866756E637469';
wwv_flow_api.g_varchar2_table(24) := '6F6E28297B632E6170706C7928642C62297D2C61297D7D66756E6374696F6E20772861297B76617220632C623D21313B72657475726E2066756E6374696F6E28297B72657475726E20623D3D3D2131262628633D6128292C623D2130292C637D7D66756E';
wwv_flow_api.g_varchar2_table(25) := '6374696F6E207828612C62297B76617220633D7628612C66756E6374696F6E2861297B622E7472696767657228227363726F6C6C2D6465626F756E636564222C61297D293B622E6F6E28227363726F6C6C222C66756E6374696F6E2861297B6F28612E74';
wwv_flow_api.g_varchar2_table(26) := '61726765742C622E6765742829293E3D302626632861297D297D66756E6374696F6E20792861297B615B305D213D3D646F63756D656E742E616374697665456C656D656E74262677696E646F772E73657454696D656F75742866756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(27) := '76617220642C623D615B305D2C633D612E76616C28292E6C656E6774683B612E666F63757328292C612E697328223A76697369626C6522292626623D3D3D646F63756D656E742E616374697665456C656D656E74262628622E73657453656C656374696F';
wwv_flow_api.g_varchar2_table(28) := '6E52616E67653F622E73657453656C656374696F6E52616E676528632C63293A622E6372656174655465787452616E6765262628643D622E6372656174655465787452616E676528292C642E636F6C6C61707365282131292C642E73656C656374282929';
wwv_flow_api.g_varchar2_table(29) := '297D2C30297D66756E6374696F6E207A2862297B623D612862295B305D3B76617220633D302C643D303B6966282273656C656374696F6E537461727422696E206229633D622E73656C656374696F6E53746172742C643D622E73656C656374696F6E456E';
wwv_flow_api.g_varchar2_table(30) := '642D633B656C7365206966282273656C656374696F6E22696E20646F63756D656E74297B622E666F63757328293B76617220653D646F63756D656E742E73656C656374696F6E2E63726561746552616E676528293B643D646F63756D656E742E73656C65';
wwv_flow_api.g_varchar2_table(31) := '6374696F6E2E63726561746552616E676528292E746578742E6C656E6774682C652E6D6F766553746172742822636861726163746572222C2D622E76616C75652E6C656E677468292C633D652E746578742E6C656E6774682D647D72657475726E7B6F66';
wwv_flow_api.g_varchar2_table(32) := '667365743A632C6C656E6774683A647D7D66756E6374696F6E20412861297B612E70726576656E7444656661756C7428292C612E73746F7050726F7061676174696F6E28297D66756E6374696F6E20422861297B612E70726576656E7444656661756C74';
wwv_flow_api.g_varchar2_table(33) := '28292C612E73746F70496D6D65646961746550726F7061676174696F6E28297D66756E6374696F6E20432862297B6966282168297B76617220633D625B305D2E63757272656E745374796C657C7C77696E646F772E676574436F6D70757465645374796C';
wwv_flow_api.g_varchar2_table(34) := '6528625B305D2C6E756C6C293B683D6128646F63756D656E742E637265617465456C656D656E7428226469762229292E637373287B706F736974696F6E3A226162736F6C757465222C6C6566743A222D31303030307078222C746F703A222D3130303030';
wwv_flow_api.g_varchar2_table(35) := '7078222C646973706C61793A226E6F6E65222C666F6E7453697A653A632E666F6E7453697A652C666F6E7446616D696C793A632E666F6E7446616D696C792C666F6E745374796C653A632E666F6E745374796C652C666F6E745765696768743A632E666F';
wwv_flow_api.g_varchar2_table(36) := '6E745765696768742C6C657474657253706163696E673A632E6C657474657253706163696E672C746578745472616E73666F726D3A632E746578745472616E73666F726D2C776869746553706163653A226E6F77726170227D292C682E61747472282263';
wwv_flow_api.g_varchar2_table(37) := '6C617373222C2273656C656374322D73697A657222292C612822626F647922292E617070656E642868297D72657475726E20682E7465787428622E76616C2829292C682E776964746828297D66756E6374696F6E204428622C632C64297B76617220652C';
wwv_flow_api.g_varchar2_table(38) := '672C663D5B5D3B653D622E617474722822636C61737322292C65262628653D22222B652C6128652E73706C69742822202229292E65616368322866756E6374696F6E28297B303D3D3D746869732E696E6465784F66282273656C656374322D2229262666';
wwv_flow_api.g_varchar2_table(39) := '2E707573682874686973297D29292C653D632E617474722822636C61737322292C65262628653D22222B652C6128652E73706C69742822202229292E65616368322866756E6374696F6E28297B30213D3D746869732E696E6465784F66282273656C6563';
wwv_flow_api.g_varchar2_table(40) := '74322D2229262628673D642874686973292C672626662E70757368286729297D29292C622E617474722822636C617373222C662E6A6F696E2822202229297D66756E6374696F6E204528612C622C632C64297B76617220653D6E28612E746F5570706572';
wwv_flow_api.g_varchar2_table(41) := '436173652829292E696E6465784F66286E28622E746F557070657243617365282929292C663D622E6C656E6774683B72657475726E20303E653F28632E707573682864286129292C766F69642030293A28632E70757368286428612E737562737472696E';
wwv_flow_api.g_varchar2_table(42) := '6728302C652929292C632E7075736828223C7370616E20636C6173733D2773656C656374322D6D61746368273E22292C632E70757368286428612E737562737472696E6728652C652B662929292C632E7075736828223C2F7370616E3E22292C632E7075';
wwv_flow_api.g_varchar2_table(43) := '7368286428612E737562737472696E6728652B662C612E6C656E6774682929292C766F69642030297D66756E6374696F6E20462861297B76617220623D7B225C5C223A22262339323B222C2226223A2226616D703B222C223C223A22266C743B222C223E';
wwv_flow_api.g_varchar2_table(44) := '223A222667743B222C2722273A222671756F743B222C2227223A22262333393B222C222F223A22262334373B227D3B72657475726E20537472696E672861292E7265706C616365282F5B263C3E22275C2F5C5C5D2F672C66756E6374696F6E2861297B72';
wwv_flow_api.g_varchar2_table(45) := '657475726E20625B615D7D297D66756E6374696F6E20472863297B76617220642C653D6E756C6C2C663D632E71756965744D696C6C69737C7C3130302C673D632E75726C2C683D746869733B72657475726E2066756E6374696F6E2869297B77696E646F';
wwv_flow_api.g_varchar2_table(46) := '772E636C65617254696D656F75742864292C643D77696E646F772E73657454696D656F75742866756E6374696F6E28297B76617220643D632E646174612C663D672C6A3D632E7472616E73706F72747C7C612E666E2E73656C656374322E616A61784465';
wwv_flow_api.g_varchar2_table(47) := '6661756C74732E7472616E73706F72742C6B3D7B747970653A632E747970657C7C22474554222C63616368653A632E63616368657C7C21312C6A736F6E7043616C6C6261636B3A632E6A736F6E7043616C6C6261636B7C7C622C64617461547970653A63';
wwv_flow_api.g_varchar2_table(48) := '2E64617461547970657C7C226A736F6E227D2C6C3D612E657874656E64287B7D2C612E666E2E73656C656374322E616A617844656661756C74732E706172616D732C6B293B643D643F642E63616C6C28682C692E7465726D2C692E706167652C692E636F';
wwv_flow_api.g_varchar2_table(49) := '6E74657874293A6E756C6C2C663D2266756E6374696F6E223D3D747970656F6620663F662E63616C6C28682C692E7465726D2C692E706167652C692E636F6E74657874293A662C652626652E61626F727428292C632E706172616D73262628612E697346';
wwv_flow_api.g_varchar2_table(50) := '756E6374696F6E28632E706172616D73293F612E657874656E64286C2C632E706172616D732E63616C6C286829293A612E657874656E64286C2C632E706172616D7329292C612E657874656E64286C2C7B75726C3A662C64617461547970653A632E6461';
wwv_flow_api.g_varchar2_table(51) := '7461547970652C646174613A642C737563636573733A66756E6374696F6E2861297B76617220623D632E726573756C747328612C692E70616765293B692E63616C6C6261636B2862297D7D292C653D6A2E63616C6C28682C6C297D2C66297D7D66756E63';
wwv_flow_api.g_varchar2_table(52) := '74696F6E20482862297B76617220642C652C633D622C663D66756E6374696F6E2861297B72657475726E22222B612E746578747D3B612E69734172726179286329262628653D632C633D7B726573756C74733A657D292C612E697346756E6374696F6E28';
wwv_flow_api.g_varchar2_table(53) := '63293D3D3D2131262628653D632C633D66756E6374696F6E28297B72657475726E20657D293B76617220673D6328293B72657475726E20672E74657874262628663D672E746578742C612E697346756E6374696F6E2866297C7C28643D672E746578742C';
wwv_flow_api.g_varchar2_table(54) := '663D66756E6374696F6E2861297B72657475726E20615B645D7D29292C66756E6374696F6E2862297B76617220672C643D622E7465726D2C653D7B726573756C74733A5B5D7D3B72657475726E22223D3D3D643F28622E63616C6C6261636B2863282929';
wwv_flow_api.g_varchar2_table(55) := '2C766F69642030293A28673D66756E6374696F6E28632C65297B76617220682C693B696628633D635B305D2C632E6368696C6472656E297B683D7B7D3B666F72286920696E206329632E6861734F776E50726F7065727479286929262628685B695D3D63';
wwv_flow_api.g_varchar2_table(56) := '5B695D293B682E6368696C6472656E3D5B5D2C6128632E6368696C6472656E292E65616368322866756E6374696F6E28612C62297B6728622C682E6368696C6472656E297D292C28682E6368696C6472656E2E6C656E6774687C7C622E6D617463686572';
wwv_flow_api.g_varchar2_table(57) := '28642C662868292C6329292626652E707573682868297D656C736520622E6D61746368657228642C662863292C63292626652E707573682863297D2C61286328292E726573756C7473292E65616368322866756E6374696F6E28612C62297B6728622C65';
wwv_flow_api.g_varchar2_table(58) := '2E726573756C7473297D292C622E63616C6C6261636B2865292C766F69642030297D7D66756E6374696F6E20492863297B76617220643D612E697346756E6374696F6E2863293B72657475726E2066756E6374696F6E2865297B76617220663D652E7465';
wwv_flow_api.g_varchar2_table(59) := '726D2C673D7B726573756C74733A5B5D7D3B6128643F6328293A63292E656163682866756E6374696F6E28297B76617220613D746869732E74657874213D3D622C633D613F746869732E746578743A746869733B2822223D3D3D667C7C652E6D61746368';
wwv_flow_api.g_varchar2_table(60) := '657228662C6329292626672E726573756C74732E7075736828613F746869733A7B69643A746869732C746578743A746869737D297D292C652E63616C6C6261636B2867297D7D66756E6374696F6E204A28622C63297B696628612E697346756E6374696F';
wwv_flow_api.g_varchar2_table(61) := '6E2862292972657475726E21303B69662821622972657475726E21313B7468726F77206E6577204572726F7228632B22206D75737420626520612066756E6374696F6E206F7220612066616C73792076616C756522297D66756E6374696F6E204B286229';
wwv_flow_api.g_varchar2_table(62) := '7B72657475726E20612E697346756E6374696F6E2862293F6228293A627D66756E6374696F6E204C2862297B76617220633D303B72657475726E20612E6561636828622C66756E6374696F6E28612C62297B622E6368696C6472656E3F632B3D4C28622E';
wwv_flow_api.g_varchar2_table(63) := '6368696C6472656E293A632B2B7D292C637D66756E6374696F6E204D28612C632C642C65297B76617220682C692C6A2C6B2C6C2C663D612C673D21313B69662821652E63726561746553656172636843686F6963657C7C21652E746F6B656E5365706172';
wwv_flow_api.g_varchar2_table(64) := '61746F72737C7C652E746F6B656E536570617261746F72732E6C656E6774683C312972657475726E20623B666F72283B3B297B666F7228693D2D312C6A3D302C6B3D652E746F6B656E536570617261746F72732E6C656E6774683B6B3E6A2626286C3D65';
wwv_flow_api.g_varchar2_table(65) := '2E746F6B656E536570617261746F72735B6A5D2C693D612E696E6465784F66286C292C2128693E3D3029293B6A2B2B293B696628303E6929627265616B3B696628683D612E737562737472696E6728302C69292C613D612E737562737472696E6728692B';
wwv_flow_api.g_varchar2_table(66) := '6C2E6C656E677468292C682E6C656E6774683E30262628683D652E63726561746553656172636843686F6963652E63616C6C28746869732C682C63292C68213D3D6226266E756C6C213D3D682626652E6964286829213D3D6226266E756C6C213D3D652E';
wwv_flow_api.g_varchar2_table(67) := '696428682929297B666F7228673D21312C6A3D302C6B3D632E6C656E6774683B6B3E6A3B6A2B2B296966287128652E69642868292C652E696428635B6A5D2929297B673D21303B627265616B7D677C7C642868297D7D72657475726E2066213D3D613F61';
wwv_flow_api.g_varchar2_table(68) := '3A766F696420307D66756E6374696F6E204E28622C63297B76617220643D66756E6374696F6E28297B7D3B72657475726E20642E70726F746F747970653D6E657720622C642E70726F746F747970652E636F6E7374727563746F723D642C642E70726F74';
wwv_flow_api.g_varchar2_table(69) := '6F747970652E706172656E743D622E70726F746F747970652C642E70726F746F747970653D612E657874656E6428642E70726F746F747970652C63292C647D69662877696E646F772E53656C656374323D3D3D62297B76617220632C642C652C662C672C';
wwv_flow_api.g_varchar2_table(70) := '682C6A2C6B2C693D7B783A302C793A307D2C633D7B5441423A392C454E5445523A31332C4553433A32372C53504143453A33322C4C4546543A33372C55503A33382C52494748543A33392C444F574E3A34302C53484946543A31362C4354524C3A31372C';
wwv_flow_api.g_varchar2_table(71) := '414C543A31382C504147455F55503A33332C504147455F444F574E3A33342C484F4D453A33362C454E443A33352C4241434B53504143453A382C44454C4554453A34362C69734172726F773A66756E6374696F6E2861297B73776974636828613D612E77';
wwv_flow_api.g_varchar2_table(72) := '686963683F612E77686963683A61297B6361736520632E4C4546543A6361736520632E52494748543A6361736520632E55503A6361736520632E444F574E3A72657475726E21307D72657475726E21317D2C6973436F6E74726F6C3A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(73) := '2861297B76617220623D612E77686963683B7377697463682862297B6361736520632E53484946543A6361736520632E4354524C3A6361736520632E414C543A72657475726E21307D72657475726E20612E6D6574614B65793F21303A21317D2C697346';
wwv_flow_api.g_varchar2_table(74) := '756E6374696F6E4B65793A66756E6374696F6E2861297B72657475726E20613D612E77686963683F612E77686963683A612C613E3D31313226263132333E3D617D7D2C6C3D223C64697620636C6173733D2773656C656374322D6D6561737572652D7363';
wwv_flow_api.g_varchar2_table(75) := '726F6C6C626172273E3C2F6469763E222C6D3D7B225C7532346236223A2241222C225C7566663231223A2241222C225C786330223A2241222C225C786331223A2241222C225C786332223A2241222C225C7531656136223A2241222C225C753165613422';
wwv_flow_api.g_varchar2_table(76) := '3A2241222C225C7531656161223A2241222C225C7531656138223A2241222C225C786333223A2241222C225C7530313030223A2241222C225C7530313032223A2241222C225C7531656230223A2241222C225C7531656165223A2241222C225C75316562';
wwv_flow_api.g_varchar2_table(77) := '34223A2241222C225C7531656232223A2241222C225C7530323236223A2241222C225C7530316530223A2241222C225C786334223A2241222C225C7530316465223A2241222C225C7531656132223A2241222C225C786335223A2241222C225C75303166';
wwv_flow_api.g_varchar2_table(78) := '61223A2241222C225C7530316364223A2241222C225C7530323030223A2241222C225C7530323032223A2241222C225C7531656130223A2241222C225C7531656163223A2241222C225C7531656236223A2241222C225C7531653030223A2241222C225C';
wwv_flow_api.g_varchar2_table(79) := '7530313034223A2241222C225C7530323361223A2241222C225C7532633666223A2241222C225C7561373332223A224141222C225C786336223A224145222C225C7530316663223A224145222C225C7530316532223A224145222C225C7561373334223A';
wwv_flow_api.g_varchar2_table(80) := '22414F222C225C7561373336223A224155222C225C7561373338223A224156222C225C7561373361223A224156222C225C7561373363223A224159222C225C7532346237223A2242222C225C7566663232223A2242222C225C7531653032223A2242222C';
wwv_flow_api.g_varchar2_table(81) := '225C7531653034223A2242222C225C7531653036223A2242222C225C7530323433223A2242222C225C7530313832223A2242222C225C7530313831223A2242222C225C7532346238223A2243222C225C7566663233223A2243222C225C7530313036223A';
wwv_flow_api.g_varchar2_table(82) := '2243222C225C7530313038223A2243222C225C7530313061223A2243222C225C7530313063223A2243222C225C786337223A2243222C225C7531653038223A2243222C225C7530313837223A2243222C225C7530323362223A2243222C225C7561373365';
wwv_flow_api.g_varchar2_table(83) := '223A2243222C225C7532346239223A2244222C225C7566663234223A2244222C225C7531653061223A2244222C225C7530313065223A2244222C225C7531653063223A2244222C225C7531653130223A2244222C225C7531653132223A2244222C225C75';
wwv_flow_api.g_varchar2_table(84) := '31653065223A2244222C225C7530313130223A2244222C225C7530313862223A2244222C225C7530313861223A2244222C225C7530313839223A2244222C225C7561373739223A2244222C225C7530316631223A22445A222C225C7530316334223A2244';
wwv_flow_api.g_varchar2_table(85) := '5A222C225C7530316632223A22447A222C225C7530316335223A22447A222C225C7532346261223A2245222C225C7566663235223A2245222C225C786338223A2245222C225C786339223A2245222C225C786361223A2245222C225C7531656330223A22';
wwv_flow_api.g_varchar2_table(86) := '45222C225C7531656265223A2245222C225C7531656334223A2245222C225C7531656332223A2245222C225C7531656263223A2245222C225C7530313132223A2245222C225C7531653134223A2245222C225C7531653136223A2245222C225C75303131';
wwv_flow_api.g_varchar2_table(87) := '34223A2245222C225C7530313136223A2245222C225C786362223A2245222C225C7531656261223A2245222C225C7530313161223A2245222C225C7530323034223A2245222C225C7530323036223A2245222C225C7531656238223A2245222C225C7531';
wwv_flow_api.g_varchar2_table(88) := '656336223A2245222C225C7530323238223A2245222C225C7531653163223A2245222C225C7530313138223A2245222C225C7531653138223A2245222C225C7531653161223A2245222C225C7530313930223A2245222C225C7530313865223A2245222C';
wwv_flow_api.g_varchar2_table(89) := '225C7532346262223A2246222C225C7566663236223A2246222C225C7531653165223A2246222C225C7530313931223A2246222C225C7561373762223A2246222C225C7532346263223A2247222C225C7566663237223A2247222C225C7530316634223A';
wwv_flow_api.g_varchar2_table(90) := '2247222C225C7530313163223A2247222C225C7531653230223A2247222C225C7530313165223A2247222C225C7530313230223A2247222C225C7530316536223A2247222C225C7530313232223A2247222C225C7530316534223A2247222C225C753031';
wwv_flow_api.g_varchar2_table(91) := '3933223A2247222C225C7561376130223A2247222C225C7561373764223A2247222C225C7561373765223A2247222C225C7532346264223A2248222C225C7566663238223A2248222C225C7530313234223A2248222C225C7531653232223A2248222C22';
wwv_flow_api.g_varchar2_table(92) := '5C7531653236223A2248222C225C7530323165223A2248222C225C7531653234223A2248222C225C7531653238223A2248222C225C7531653261223A2248222C225C7530313236223A2248222C225C7532633637223A2248222C225C7532633735223A22';
wwv_flow_api.g_varchar2_table(93) := '48222C225C7561373864223A2248222C225C7532346265223A2249222C225C7566663239223A2249222C225C786363223A2249222C225C786364223A2249222C225C786365223A2249222C225C7530313238223A2249222C225C7530313261223A224922';
wwv_flow_api.g_varchar2_table(94) := '2C225C7530313263223A2249222C225C7530313330223A2249222C225C786366223A2249222C225C7531653265223A2249222C225C7531656338223A2249222C225C7530316366223A2249222C225C7530323038223A2249222C225C7530323061223A22';
wwv_flow_api.g_varchar2_table(95) := '49222C225C7531656361223A2249222C225C7530313265223A2249222C225C7531653263223A2249222C225C7530313937223A2249222C225C7532346266223A224A222C225C7566663261223A224A222C225C7530313334223A224A222C225C75303234';
wwv_flow_api.g_varchar2_table(96) := '38223A224A222C225C7532346330223A224B222C225C7566663262223A224B222C225C7531653330223A224B222C225C7530316538223A224B222C225C7531653332223A224B222C225C7530313336223A224B222C225C7531653334223A224B222C225C';
wwv_flow_api.g_varchar2_table(97) := '7530313938223A224B222C225C7532633639223A224B222C225C7561373430223A224B222C225C7561373432223A224B222C225C7561373434223A224B222C225C7561376132223A224B222C225C7532346331223A224C222C225C7566663263223A224C';
wwv_flow_api.g_varchar2_table(98) := '222C225C7530313366223A224C222C225C7530313339223A224C222C225C7530313364223A224C222C225C7531653336223A224C222C225C7531653338223A224C222C225C7530313362223A224C222C225C7531653363223A224C222C225C7531653361';
wwv_flow_api.g_varchar2_table(99) := '223A224C222C225C7530313431223A224C222C225C7530323364223A224C222C225C7532633632223A224C222C225C7532633630223A224C222C225C7561373438223A224C222C225C7561373436223A224C222C225C7561373830223A224C222C225C75';
wwv_flow_api.g_varchar2_table(100) := '30316337223A224C4A222C225C7530316338223A224C6A222C225C7532346332223A224D222C225C7566663264223A224D222C225C7531653365223A224D222C225C7531653430223A224D222C225C7531653432223A224D222C225C7532633665223A22';
wwv_flow_api.g_varchar2_table(101) := '4D222C225C7530313963223A224D222C225C7532346333223A224E222C225C7566663265223A224E222C225C7530316638223A224E222C225C7530313433223A224E222C225C786431223A224E222C225C7531653434223A224E222C225C753031343722';
wwv_flow_api.g_varchar2_table(102) := '3A224E222C225C7531653436223A224E222C225C7530313435223A224E222C225C7531653461223A224E222C225C7531653438223A224E222C225C7530323230223A224E222C225C7530313964223A224E222C225C7561373930223A224E222C225C7561';
wwv_flow_api.g_varchar2_table(103) := '376134223A224E222C225C7530316361223A224E4A222C225C7530316362223A224E6A222C225C7532346334223A224F222C225C7566663266223A224F222C225C786432223A224F222C225C786433223A224F222C225C786434223A224F222C225C7531';
wwv_flow_api.g_varchar2_table(104) := '656432223A224F222C225C7531656430223A224F222C225C7531656436223A224F222C225C7531656434223A224F222C225C786435223A224F222C225C7531653463223A224F222C225C7530323263223A224F222C225C7531653465223A224F222C225C';
wwv_flow_api.g_varchar2_table(105) := '7530313463223A224F222C225C7531653530223A224F222C225C7531653532223A224F222C225C7530313465223A224F222C225C7530323265223A224F222C225C7530323330223A224F222C225C786436223A224F222C225C7530323261223A224F222C';
wwv_flow_api.g_varchar2_table(106) := '225C7531656365223A224F222C225C7530313530223A224F222C225C7530316431223A224F222C225C7530323063223A224F222C225C7530323065223A224F222C225C7530316130223A224F222C225C7531656463223A224F222C225C7531656461223A';
wwv_flow_api.g_varchar2_table(107) := '224F222C225C7531656530223A224F222C225C7531656465223A224F222C225C7531656532223A224F222C225C7531656363223A224F222C225C7531656438223A224F222C225C7530316561223A224F222C225C7530316563223A224F222C225C786438';
wwv_flow_api.g_varchar2_table(108) := '223A224F222C225C7530316665223A224F222C225C7530313836223A224F222C225C7530313966223A224F222C225C7561373461223A224F222C225C7561373463223A224F222C225C7530316132223A224F49222C225C7561373465223A224F4F222C22';
wwv_flow_api.g_varchar2_table(109) := '5C7530323232223A224F55222C225C7532346335223A2250222C225C7566663330223A2250222C225C7531653534223A2250222C225C7531653536223A2250222C225C7530316134223A2250222C225C7532633633223A2250222C225C7561373530223A';
wwv_flow_api.g_varchar2_table(110) := '2250222C225C7561373532223A2250222C225C7561373534223A2250222C225C7532346336223A2251222C225C7566663331223A2251222C225C7561373536223A2251222C225C7561373538223A2251222C225C7530323461223A2251222C225C753234';
wwv_flow_api.g_varchar2_table(111) := '6337223A2252222C225C7566663332223A2252222C225C7530313534223A2252222C225C7531653538223A2252222C225C7530313538223A2252222C225C7530323130223A2252222C225C7530323132223A2252222C225C7531653561223A2252222C22';
wwv_flow_api.g_varchar2_table(112) := '5C7531653563223A2252222C225C7530313536223A2252222C225C7531653565223A2252222C225C7530323463223A2252222C225C7532633634223A2252222C225C7561373561223A2252222C225C7561376136223A2252222C225C7561373832223A22';
wwv_flow_api.g_varchar2_table(113) := '52222C225C7532346338223A2253222C225C7566663333223A2253222C225C7531653965223A2253222C225C7530313561223A2253222C225C7531653634223A2253222C225C7530313563223A2253222C225C7531653630223A2253222C225C75303136';
wwv_flow_api.g_varchar2_table(114) := '30223A2253222C225C7531653636223A2253222C225C7531653632223A2253222C225C7531653638223A2253222C225C7530323138223A2253222C225C7530313565223A2253222C225C7532633765223A2253222C225C7561376138223A2253222C225C';
wwv_flow_api.g_varchar2_table(115) := '7561373834223A2253222C225C7532346339223A2254222C225C7566663334223A2254222C225C7531653661223A2254222C225C7530313634223A2254222C225C7531653663223A2254222C225C7530323161223A2254222C225C7530313632223A2254';
wwv_flow_api.g_varchar2_table(116) := '222C225C7531653730223A2254222C225C7531653665223A2254222C225C7530313636223A2254222C225C7530316163223A2254222C225C7530316165223A2254222C225C7530323365223A2254222C225C7561373836223A2254222C225C7561373238';
wwv_flow_api.g_varchar2_table(117) := '223A22545A222C225C7532346361223A2255222C225C7566663335223A2255222C225C786439223A2255222C225C786461223A2255222C225C786462223A2255222C225C7530313638223A2255222C225C7531653738223A2255222C225C753031366122';
wwv_flow_api.g_varchar2_table(118) := '3A2255222C225C7531653761223A2255222C225C7530313663223A2255222C225C786463223A2255222C225C7530316462223A2255222C225C7530316437223A2255222C225C7530316435223A2255222C225C7530316439223A2255222C225C75316565';
wwv_flow_api.g_varchar2_table(119) := '36223A2255222C225C7530313665223A2255222C225C7530313730223A2255222C225C7530316433223A2255222C225C7530323134223A2255222C225C7530323136223A2255222C225C7530316166223A2255222C225C7531656561223A2255222C225C';
wwv_flow_api.g_varchar2_table(120) := '7531656538223A2255222C225C7531656565223A2255222C225C7531656563223A2255222C225C7531656630223A2255222C225C7531656534223A2255222C225C7531653732223A2255222C225C7530313732223A2255222C225C7531653736223A2255';
wwv_flow_api.g_varchar2_table(121) := '222C225C7531653734223A2255222C225C7530323434223A2255222C225C7532346362223A2256222C225C7566663336223A2256222C225C7531653763223A2256222C225C7531653765223A2256222C225C7530316232223A2256222C225C7561373565';
wwv_flow_api.g_varchar2_table(122) := '223A2256222C225C7530323435223A2256222C225C7561373630223A225659222C225C7532346363223A2257222C225C7566663337223A2257222C225C7531653830223A2257222C225C7531653832223A2257222C225C7530313734223A2257222C225C';
wwv_flow_api.g_varchar2_table(123) := '7531653836223A2257222C225C7531653834223A2257222C225C7531653838223A2257222C225C7532633732223A2257222C225C7532346364223A2258222C225C7566663338223A2258222C225C7531653861223A2258222C225C7531653863223A2258';
wwv_flow_api.g_varchar2_table(124) := '222C225C7532346365223A2259222C225C7566663339223A2259222C225C7531656632223A2259222C225C786464223A2259222C225C7530313736223A2259222C225C7531656638223A2259222C225C7530323332223A2259222C225C7531653865223A';
wwv_flow_api.g_varchar2_table(125) := '2259222C225C7530313738223A2259222C225C7531656636223A2259222C225C7531656634223A2259222C225C7530316233223A2259222C225C7530323465223A2259222C225C7531656665223A2259222C225C7532346366223A225A222C225C756666';
wwv_flow_api.g_varchar2_table(126) := '3361223A225A222C225C7530313739223A225A222C225C7531653930223A225A222C225C7530313762223A225A222C225C7530313764223A225A222C225C7531653932223A225A222C225C7531653934223A225A222C225C7530316235223A225A222C22';
wwv_flow_api.g_varchar2_table(127) := '5C7530323234223A225A222C225C7532633766223A225A222C225C7532633662223A225A222C225C7561373632223A225A222C225C7532346430223A2261222C225C7566663431223A2261222C225C7531653961223A2261222C225C786530223A226122';
wwv_flow_api.g_varchar2_table(128) := '2C225C786531223A2261222C225C786532223A2261222C225C7531656137223A2261222C225C7531656135223A2261222C225C7531656162223A2261222C225C7531656139223A2261222C225C786533223A2261222C225C7530313031223A2261222C22';
wwv_flow_api.g_varchar2_table(129) := '5C7530313033223A2261222C225C7531656231223A2261222C225C7531656166223A2261222C225C7531656235223A2261222C225C7531656233223A2261222C225C7530323237223A2261222C225C7530316531223A2261222C225C786534223A226122';
wwv_flow_api.g_varchar2_table(130) := '2C225C7530316466223A2261222C225C7531656133223A2261222C225C786535223A2261222C225C7530316662223A2261222C225C7530316365223A2261222C225C7530323031223A2261222C225C7530323033223A2261222C225C7531656131223A22';
wwv_flow_api.g_varchar2_table(131) := '61222C225C7531656164223A2261222C225C7531656237223A2261222C225C7531653031223A2261222C225C7530313035223A2261222C225C7532633635223A2261222C225C7530323530223A2261222C225C7561373333223A226161222C225C786536';
wwv_flow_api.g_varchar2_table(132) := '223A226165222C225C7530316664223A226165222C225C7530316533223A226165222C225C7561373335223A22616F222C225C7561373337223A226175222C225C7561373339223A226176222C225C7561373362223A226176222C225C7561373364223A';
wwv_flow_api.g_varchar2_table(133) := '226179222C225C7532346431223A2262222C225C7566663432223A2262222C225C7531653033223A2262222C225C7531653035223A2262222C225C7531653037223A2262222C225C7530313830223A2262222C225C7530313833223A2262222C225C7530';
wwv_flow_api.g_varchar2_table(134) := '323533223A2262222C225C7532346432223A2263222C225C7566663433223A2263222C225C7530313037223A2263222C225C7530313039223A2263222C225C7530313062223A2263222C225C7530313064223A2263222C225C786537223A2263222C225C';
wwv_flow_api.g_varchar2_table(135) := '7531653039223A2263222C225C7530313838223A2263222C225C7530323363223A2263222C225C7561373366223A2263222C225C7532313834223A2263222C225C7532346433223A2264222C225C7566663434223A2264222C225C7531653062223A2264';
wwv_flow_api.g_varchar2_table(136) := '222C225C7530313066223A2264222C225C7531653064223A2264222C225C7531653131223A2264222C225C7531653133223A2264222C225C7531653066223A2264222C225C7530313131223A2264222C225C7530313863223A2264222C225C7530323536';
wwv_flow_api.g_varchar2_table(137) := '223A2264222C225C7530323537223A2264222C225C7561373761223A2264222C225C7530316633223A22647A222C225C7530316336223A22647A222C225C7532346434223A2265222C225C7566663435223A2265222C225C786538223A2265222C225C78';
wwv_flow_api.g_varchar2_table(138) := '6539223A2265222C225C786561223A2265222C225C7531656331223A2265222C225C7531656266223A2265222C225C7531656335223A2265222C225C7531656333223A2265222C225C7531656264223A2265222C225C7530313133223A2265222C225C75';
wwv_flow_api.g_varchar2_table(139) := '31653135223A2265222C225C7531653137223A2265222C225C7530313135223A2265222C225C7530313137223A2265222C225C786562223A2265222C225C7531656262223A2265222C225C7530313162223A2265222C225C7530323035223A2265222C22';
wwv_flow_api.g_varchar2_table(140) := '5C7530323037223A2265222C225C7531656239223A2265222C225C7531656337223A2265222C225C7530323239223A2265222C225C7531653164223A2265222C225C7530313139223A2265222C225C7531653139223A2265222C225C7531653162223A22';
wwv_flow_api.g_varchar2_table(141) := '65222C225C7530323437223A2265222C225C7530323562223A2265222C225C7530316464223A2265222C225C7532346435223A2266222C225C7566663436223A2266222C225C7531653166223A2266222C225C7530313932223A2266222C225C75613737';
wwv_flow_api.g_varchar2_table(142) := '63223A2266222C225C7532346436223A2267222C225C7566663437223A2267222C225C7530316635223A2267222C225C7530313164223A2267222C225C7531653231223A2267222C225C7530313166223A2267222C225C7530313231223A2267222C225C';
wwv_flow_api.g_varchar2_table(143) := '7530316537223A2267222C225C7530313233223A2267222C225C7530316535223A2267222C225C7530323630223A2267222C225C7561376131223A2267222C225C7531643739223A2267222C225C7561373766223A2267222C225C7532346437223A2268';
wwv_flow_api.g_varchar2_table(144) := '222C225C7566663438223A2268222C225C7530313235223A2268222C225C7531653233223A2268222C225C7531653237223A2268222C225C7530323166223A2268222C225C7531653235223A2268222C225C7531653239223A2268222C225C7531653262';
wwv_flow_api.g_varchar2_table(145) := '223A2268222C225C7531653936223A2268222C225C7530313237223A2268222C225C7532633638223A2268222C225C7532633736223A2268222C225C7530323635223A2268222C225C7530313935223A226876222C225C7532346438223A2269222C225C';
wwv_flow_api.g_varchar2_table(146) := '7566663439223A2269222C225C786563223A2269222C225C786564223A2269222C225C786565223A2269222C225C7530313239223A2269222C225C7530313262223A2269222C225C7530313264223A2269222C225C786566223A2269222C225C75316532';
wwv_flow_api.g_varchar2_table(147) := '66223A2269222C225C7531656339223A2269222C225C7530316430223A2269222C225C7530323039223A2269222C225C7530323062223A2269222C225C7531656362223A2269222C225C7530313266223A2269222C225C7531653264223A2269222C225C';
wwv_flow_api.g_varchar2_table(148) := '7530323638223A2269222C225C7530313331223A2269222C225C7532346439223A226A222C225C7566663461223A226A222C225C7530313335223A226A222C225C7530316630223A226A222C225C7530323439223A226A222C225C7532346461223A226B';
wwv_flow_api.g_varchar2_table(149) := '222C225C7566663462223A226B222C225C7531653331223A226B222C225C7530316539223A226B222C225C7531653333223A226B222C225C7530313337223A226B222C225C7531653335223A226B222C225C7530313939223A226B222C225C7532633661';
wwv_flow_api.g_varchar2_table(150) := '223A226B222C225C7561373431223A226B222C225C7561373433223A226B222C225C7561373435223A226B222C225C7561376133223A226B222C225C7532346462223A226C222C225C7566663463223A226C222C225C7530313430223A226C222C225C75';
wwv_flow_api.g_varchar2_table(151) := '30313361223A226C222C225C7530313365223A226C222C225C7531653337223A226C222C225C7531653339223A226C222C225C7530313363223A226C222C225C7531653364223A226C222C225C7531653362223A226C222C225C7530313766223A226C22';
wwv_flow_api.g_varchar2_table(152) := '2C225C7530313432223A226C222C225C7530313961223A226C222C225C7530323662223A226C222C225C7532633631223A226C222C225C7561373439223A226C222C225C7561373831223A226C222C225C7561373437223A226C222C225C753031633922';
wwv_flow_api.g_varchar2_table(153) := '3A226C6A222C225C7532346463223A226D222C225C7566663464223A226D222C225C7531653366223A226D222C225C7531653431223A226D222C225C7531653433223A226D222C225C7530323731223A226D222C225C7530323666223A226D222C225C75';
wwv_flow_api.g_varchar2_table(154) := '32346464223A226E222C225C7566663465223A226E222C225C7530316639223A226E222C225C7530313434223A226E222C225C786631223A226E222C225C7531653435223A226E222C225C7530313438223A226E222C225C7531653437223A226E222C22';
wwv_flow_api.g_varchar2_table(155) := '5C7530313436223A226E222C225C7531653462223A226E222C225C7531653439223A226E222C225C7530313965223A226E222C225C7530323732223A226E222C225C7530313439223A226E222C225C7561373931223A226E222C225C7561376135223A22';
wwv_flow_api.g_varchar2_table(156) := '6E222C225C7530316363223A226E6A222C225C7532346465223A226F222C225C7566663466223A226F222C225C786632223A226F222C225C786633223A226F222C225C786634223A226F222C225C7531656433223A226F222C225C7531656431223A226F';
wwv_flow_api.g_varchar2_table(157) := '222C225C7531656437223A226F222C225C7531656435223A226F222C225C786635223A226F222C225C7531653464223A226F222C225C7530323264223A226F222C225C7531653466223A226F222C225C7530313464223A226F222C225C7531653531223A';
wwv_flow_api.g_varchar2_table(158) := '226F222C225C7531653533223A226F222C225C7530313466223A226F222C225C7530323266223A226F222C225C7530323331223A226F222C225C786636223A226F222C225C7530323262223A226F222C225C7531656366223A226F222C225C7530313531';
wwv_flow_api.g_varchar2_table(159) := '223A226F222C225C7530316432223A226F222C225C7530323064223A226F222C225C7530323066223A226F222C225C7530316131223A226F222C225C7531656464223A226F222C225C7531656462223A226F222C225C7531656531223A226F222C225C75';
wwv_flow_api.g_varchar2_table(160) := '31656466223A226F222C225C7531656533223A226F222C225C7531656364223A226F222C225C7531656439223A226F222C225C7530316562223A226F222C225C7530316564223A226F222C225C786638223A226F222C225C7530316666223A226F222C22';
wwv_flow_api.g_varchar2_table(161) := '5C7530323534223A226F222C225C7561373462223A226F222C225C7561373464223A226F222C225C7530323735223A226F222C225C7530316133223A226F69222C225C7530323233223A226F75222C225C7561373466223A226F6F222C225C7532346466';
wwv_flow_api.g_varchar2_table(162) := '223A2270222C225C7566663530223A2270222C225C7531653535223A2270222C225C7531653537223A2270222C225C7530316135223A2270222C225C7531643764223A2270222C225C7561373531223A2270222C225C7561373533223A2270222C225C75';
wwv_flow_api.g_varchar2_table(163) := '61373535223A2270222C225C7532346530223A2271222C225C7566663531223A2271222C225C7530323462223A2271222C225C7561373537223A2271222C225C7561373539223A2271222C225C7532346531223A2272222C225C7566663532223A227222';
wwv_flow_api.g_varchar2_table(164) := '2C225C7530313535223A2272222C225C7531653539223A2272222C225C7530313539223A2272222C225C7530323131223A2272222C225C7530323133223A2272222C225C7531653562223A2272222C225C7531653564223A2272222C225C753031353722';
wwv_flow_api.g_varchar2_table(165) := '3A2272222C225C7531653566223A2272222C225C7530323464223A2272222C225C7530323764223A2272222C225C7561373562223A2272222C225C7561376137223A2272222C225C7561373833223A2272222C225C7532346532223A2273222C225C7566';
wwv_flow_api.g_varchar2_table(166) := '663533223A2273222C225C786466223A2273222C225C7530313562223A2273222C225C7531653635223A2273222C225C7530313564223A2273222C225C7531653631223A2273222C225C7530313631223A2273222C225C7531653637223A2273222C225C';
wwv_flow_api.g_varchar2_table(167) := '7531653633223A2273222C225C7531653639223A2273222C225C7530323139223A2273222C225C7530313566223A2273222C225C7530323366223A2273222C225C7561376139223A2273222C225C7561373835223A2273222C225C7531653962223A2273';
wwv_flow_api.g_varchar2_table(168) := '222C225C7532346533223A2274222C225C7566663534223A2274222C225C7531653662223A2274222C225C7531653937223A2274222C225C7530313635223A2274222C225C7531653664223A2274222C225C7530323162223A2274222C225C7530313633';
wwv_flow_api.g_varchar2_table(169) := '223A2274222C225C7531653731223A2274222C225C7531653666223A2274222C225C7530313637223A2274222C225C7530316164223A2274222C225C7530323838223A2274222C225C7532633636223A2274222C225C7561373837223A2274222C225C75';
wwv_flow_api.g_varchar2_table(170) := '61373239223A22747A222C225C7532346534223A2275222C225C7566663535223A2275222C225C786639223A2275222C225C786661223A2275222C225C786662223A2275222C225C7530313639223A2275222C225C7531653739223A2275222C225C7530';
wwv_flow_api.g_varchar2_table(171) := '313662223A2275222C225C7531653762223A2275222C225C7530313664223A2275222C225C786663223A2275222C225C7530316463223A2275222C225C7530316438223A2275222C225C7530316436223A2275222C225C7530316461223A2275222C225C';
wwv_flow_api.g_varchar2_table(172) := '7531656537223A2275222C225C7530313666223A2275222C225C7530313731223A2275222C225C7530316434223A2275222C225C7530323135223A2275222C225C7530323137223A2275222C225C7530316230223A2275222C225C7531656562223A2275';
wwv_flow_api.g_varchar2_table(173) := '222C225C7531656539223A2275222C225C7531656566223A2275222C225C7531656564223A2275222C225C7531656631223A2275222C225C7531656535223A2275222C225C7531653733223A2275222C225C7530313733223A2275222C225C7531653737';
wwv_flow_api.g_varchar2_table(174) := '223A2275222C225C7531653735223A2275222C225C7530323839223A2275222C225C7532346535223A2276222C225C7566663536223A2276222C225C7531653764223A2276222C225C7531653766223A2276222C225C7530323862223A2276222C225C75';
wwv_flow_api.g_varchar2_table(175) := '61373566223A2276222C225C7530323863223A2276222C225C7561373631223A227679222C225C7532346536223A2277222C225C7566663537223A2277222C225C7531653831223A2277222C225C7531653833223A2277222C225C7530313735223A2277';
wwv_flow_api.g_varchar2_table(176) := '222C225C7531653837223A2277222C225C7531653835223A2277222C225C7531653938223A2277222C225C7531653839223A2277222C225C7532633733223A2277222C225C7532346537223A2278222C225C7566663538223A2278222C225C7531653862';
wwv_flow_api.g_varchar2_table(177) := '223A2278222C225C7531653864223A2278222C225C7532346538223A2279222C225C7566663539223A2279222C225C7531656633223A2279222C225C786664223A2279222C225C7530313737223A2279222C225C7531656639223A2279222C225C753032';
wwv_flow_api.g_varchar2_table(178) := '3333223A2279222C225C7531653866223A2279222C225C786666223A2279222C225C7531656637223A2279222C225C7531653939223A2279222C225C7531656635223A2279222C225C7530316234223A2279222C225C7530323466223A2279222C225C75';
wwv_flow_api.g_varchar2_table(179) := '31656666223A2279222C225C7532346539223A227A222C225C7566663561223A227A222C225C7530313761223A227A222C225C7531653931223A227A222C225C7530313763223A227A222C225C7530313765223A227A222C225C7531653933223A227A22';
wwv_flow_api.g_varchar2_table(180) := '2C225C7531653935223A227A222C225C7530316236223A227A222C225C7530323235223A227A222C225C7530323430223A227A222C225C7532633663223A227A222C225C7561373633223A227A227D3B6A3D6128646F63756D656E74292C673D66756E63';
wwv_flow_api.g_varchar2_table(181) := '74696F6E28297B76617220613D313B72657475726E2066756E6374696F6E28297B72657475726E20612B2B7D7D28292C6A2E6F6E28226D6F7573656D6F7665222C66756E6374696F6E2861297B692E783D612E70616765582C692E793D612E7061676559';
wwv_flow_api.g_varchar2_table(182) := '7D292C643D4E284F626A6563742C7B62696E643A66756E6374696F6E2861297B76617220623D746869733B72657475726E2066756E6374696F6E28297B612E6170706C7928622C617267756D656E7473297D7D2C696E69743A66756E6374696F6E286329';
wwv_flow_api.g_varchar2_table(183) := '7B76617220642C652C663D222E73656C656374322D726573756C7473223B746869732E6F7074733D633D746869732E707265706172654F7074732863292C746869732E69643D632E69642C632E656C656D656E742E64617461282273656C656374322229';
wwv_flow_api.g_varchar2_table(184) := '213D3D6226266E756C6C213D3D632E656C656D656E742E64617461282273656C6563743222292626632E656C656D656E742E64617461282273656C6563743222292E64657374726F7928292C746869732E636F6E7461696E65723D746869732E63726561';
wwv_flow_api.g_varchar2_table(185) := '7465436F6E7461696E657228292C746869732E636F6E7461696E657249643D22733269645F222B28632E656C656D656E742E617474722822696422297C7C226175746F67656E222B672829292C746869732E636F6E7461696E657253656C6563746F723D';
wwv_flow_api.g_varchar2_table(186) := '2223222B746869732E636F6E7461696E657249642E7265706C616365282F285B3B262C5C2E5C2B5C2A5C7E273A225C215C5E232425405C5B5C5D5C285C293D3E5C7C5D292F672C225C5C243122292C746869732E636F6E7461696E65722E617474722822';
wwv_flow_api.g_varchar2_table(187) := '6964222C746869732E636F6E7461696E65724964292C746869732E626F64793D772866756E6374696F6E28297B72657475726E20632E656C656D656E742E636C6F736573742822626F647922297D292C4428746869732E636F6E7461696E65722C746869';
wwv_flow_api.g_varchar2_table(188) := '732E6F7074732E656C656D656E742C746869732E6F7074732E6164617074436F6E7461696E6572437373436C617373292C746869732E636F6E7461696E65722E6174747228227374796C65222C632E656C656D656E742E6174747228227374796C652229';
wwv_flow_api.g_varchar2_table(189) := '292C746869732E636F6E7461696E65722E637373284B28632E636F6E7461696E657243737329292C746869732E636F6E7461696E65722E616464436C617373284B28632E636F6E7461696E6572437373436C61737329292C746869732E656C656D656E74';
wwv_flow_api.g_varchar2_table(190) := '546162496E6465783D746869732E6F7074732E656C656D656E742E617474722822746162696E64657822292C746869732E6F7074732E656C656D656E742E64617461282273656C65637432222C74686973292E617474722822746162696E646578222C22';
wwv_flow_api.g_varchar2_table(191) := '2D3122292E6265666F726528746869732E636F6E7461696E6572292E6F6E2822636C69636B2E73656C65637432222C41292C746869732E636F6E7461696E65722E64617461282273656C65637432222C74686973292C746869732E64726F70646F776E3D';
wwv_flow_api.g_varchar2_table(192) := '746869732E636F6E7461696E65722E66696E6428222E73656C656374322D64726F7022292C4428746869732E64726F70646F776E2C746869732E6F7074732E656C656D656E742C746869732E6F7074732E616461707444726F70646F776E437373436C61';
wwv_flow_api.g_varchar2_table(193) := '7373292C746869732E64726F70646F776E2E616464436C617373284B28632E64726F70646F776E437373436C61737329292C746869732E64726F70646F776E2E64617461282273656C65637432222C74686973292C746869732E64726F70646F776E2E6F';
wwv_flow_api.g_varchar2_table(194) := '6E2822636C69636B222C41292C746869732E726573756C74733D643D746869732E636F6E7461696E65722E66696E642866292C746869732E7365617263683D653D746869732E636F6E7461696E65722E66696E642822696E7075742E73656C656374322D';
wwv_flow_api.g_varchar2_table(195) := '696E70757422292C746869732E7175657279436F756E743D302C746869732E726573756C7473506167653D302C746869732E636F6E746578743D6E756C6C2C746869732E696E6974436F6E7461696E657228292C746869732E636F6E7461696E65722E6F';
wwv_flow_api.g_varchar2_table(196) := '6E2822636C69636B222C41292C7528746869732E726573756C7473292C746869732E64726F70646F776E2E6F6E28226D6F7573656D6F76652D66696C746572656420746F756368737461727420746F7563686D6F766520746F756368656E64222C662C74';
wwv_flow_api.g_varchar2_table(197) := '6869732E62696E6428746869732E686967686C69676874556E6465724576656E7429292C782838302C746869732E726573756C7473292C746869732E64726F70646F776E2E6F6E28227363726F6C6C2D6465626F756E636564222C662C746869732E6269';
wwv_flow_api.g_varchar2_table(198) := '6E6428746869732E6C6F61644D6F726549664E656564656429292C6128746869732E636F6E7461696E6572292E6F6E28226368616E6765222C222E73656C656374322D696E707574222C66756E6374696F6E2861297B612E73746F7050726F7061676174';
wwv_flow_api.g_varchar2_table(199) := '696F6E28297D292C6128746869732E64726F70646F776E292E6F6E28226368616E6765222C222E73656C656374322D696E707574222C66756E6374696F6E2861297B612E73746F7050726F7061676174696F6E28297D292C612E666E2E6D6F7573657768';
wwv_flow_api.g_varchar2_table(200) := '65656C2626642E6D6F757365776865656C2866756E6374696F6E28612C622C632C65297B76617220663D642E7363726F6C6C546F7028293B653E302626303E3D662D653F28642E7363726F6C6C546F702830292C41286129293A303E652626642E676574';
wwv_flow_api.g_varchar2_table(201) := '2830292E7363726F6C6C4865696768742D642E7363726F6C6C546F7028292B653C3D642E6865696768742829262628642E7363726F6C6C546F7028642E6765742830292E7363726F6C6C4865696768742D642E6865696768742829292C41286129297D29';
wwv_flow_api.g_varchar2_table(202) := '2C742865292C652E6F6E28226B657975702D6368616E676520696E707574207061737465222C746869732E62696E6428746869732E757064617465526573756C747329292C652E6F6E2822666F637573222C66756E6374696F6E28297B652E616464436C';
wwv_flow_api.g_varchar2_table(203) := '617373282273656C656374322D666F637573656422297D292C652E6F6E2822626C7572222C66756E6374696F6E28297B652E72656D6F7665436C617373282273656C656374322D666F637573656422297D292C746869732E64726F70646F776E2E6F6E28';
wwv_flow_api.g_varchar2_table(204) := '226D6F7573657570222C662C746869732E62696E642866756E6374696F6E2862297B6128622E746172676574292E636C6F7365737428222E73656C656374322D726573756C742D73656C65637461626C6522292E6C656E6774683E30262628746869732E';
wwv_flow_api.g_varchar2_table(205) := '686967686C69676874556E6465724576656E742862292C746869732E73656C656374486967686C696768746564286229297D29292C746869732E64726F70646F776E2E6F6E2822636C69636B206D6F7573657570206D6F757365646F776E222C66756E63';
wwv_flow_api.g_varchar2_table(206) := '74696F6E2861297B612E73746F7050726F7061676174696F6E28297D292C612E697346756E6374696F6E28746869732E6F7074732E696E697453656C656374696F6E29262628746869732E696E697453656C656374696F6E28292C746869732E6D6F6E69';
wwv_flow_api.g_varchar2_table(207) := '746F72536F757263652829292C6E756C6C213D3D632E6D6178696D756D496E7075744C656E6774682626746869732E7365617263682E6174747228226D61786C656E677468222C632E6D6178696D756D496E7075744C656E677468293B76617220683D63';
wwv_flow_api.g_varchar2_table(208) := '2E656C656D656E742E70726F70282264697361626C656422293B683D3D3D62262628683D2131292C746869732E656E61626C65282168293B76617220693D632E656C656D656E742E70726F702822726561646F6E6C7922293B693D3D3D62262628693D21';
wwv_flow_api.g_varchar2_table(209) := '31292C746869732E726561646F6E6C792869292C6B3D6B7C7C7028292C746869732E6175746F666F6375733D632E656C656D656E742E70726F7028226175746F666F63757322292C632E656C656D656E742E70726F7028226175746F666F637573222C21';
wwv_flow_api.g_varchar2_table(210) := '31292C746869732E6175746F666F6375732626746869732E666F63757328292C746869732E6E6578745365617263685465726D3D627D2C64657374726F793A66756E6374696F6E28297B76617220613D746869732E6F7074732E656C656D656E742C633D';
wwv_flow_api.g_varchar2_table(211) := '612E64617461282273656C6563743222293B746869732E636C6F736528292C746869732E70726F70657274794F6273657276657226262864656C65746520746869732E70726F70657274794F627365727665722C746869732E70726F70657274794F6273';
wwv_flow_api.g_varchar2_table(212) := '65727665723D6E756C6C292C63213D3D62262628632E636F6E7461696E65722E72656D6F766528292C632E64726F70646F776E2E72656D6F766528292C612E72656D6F7665436C617373282273656C656374322D6F666673637265656E22292E72656D6F';
wwv_flow_api.g_varchar2_table(213) := '766544617461282273656C6563743222292E6F666628222E73656C6563743222292E70726F7028226175746F666F637573222C746869732E6175746F666F6375737C7C2131292C746869732E656C656D656E74546162496E6465783F612E61747472287B';
wwv_flow_api.g_varchar2_table(214) := '746162696E6465783A746869732E656C656D656E74546162496E6465787D293A612E72656D6F7665417474722822746162696E64657822292C612E73686F772829297D2C6F7074696F6E546F446174613A66756E6374696F6E2861297B72657475726E20';
wwv_flow_api.g_varchar2_table(215) := '612E697328226F7074696F6E22293F7B69643A612E70726F70282276616C756522292C746578743A612E7465787428292C656C656D656E743A612E67657428292C6373733A612E617474722822636C61737322292C64697361626C65643A612E70726F70';
wwv_flow_api.g_varchar2_table(216) := '282264697361626C656422292C6C6F636B65643A7128612E6174747228226C6F636B656422292C226C6F636B656422297C7C7128612E6461746128226C6F636B656422292C2130297D3A612E697328226F707467726F757022293F7B746578743A612E61';
wwv_flow_api.g_varchar2_table(217) := '74747228226C6162656C22292C6368696C6472656E3A5B5D2C656C656D656E743A612E67657428292C6373733A612E617474722822636C61737322297D3A766F696420307D2C707265706172654F7074733A66756E6374696F6E2863297B76617220642C';
wwv_flow_api.g_varchar2_table(218) := '652C662C672C683D746869733B696628643D632E656C656D656E742C2273656C656374223D3D3D642E6765742830292E7461674E616D652E746F4C6F776572436173652829262628746869732E73656C6563743D653D632E656C656D656E74292C652626';
wwv_flow_api.g_varchar2_table(219) := '612E65616368285B226964222C226D756C7469706C65222C22616A6178222C227175657279222C2263726561746553656172636843686F696365222C22696E697453656C656374696F6E222C2264617461222C2274616773225D2C66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(220) := '297B6966287468697320696E2063297468726F77206E6577204572726F7228224F7074696F6E2027222B746869732B2227206973206E6F7420616C6C6F77656420666F722053656C65637432207768656E20617474616368656420746F2061203C73656C';
wwv_flow_api.g_varchar2_table(221) := '6563743E20656C656D656E742E22297D292C633D612E657874656E64287B7D2C7B706F70756C617465526573756C74733A66756E6374696F6E28642C652C66297B76617220672C693D746869732E6F7074732E69643B673D66756E6374696F6E28642C65';
wwv_flow_api.g_varchar2_table(222) := '2C6A297B766172206B2C6C2C6D2C6E2C6F2C702C712C722C732C743B666F7228643D632E736F7274526573756C747328642C652C66292C6B3D302C6C3D642E6C656E6774683B6C3E6B3B6B2B3D31296D3D645B6B5D2C6F3D6D2E64697361626C65643D3D';
wwv_flow_api.g_varchar2_table(223) := '3D21302C6E3D216F262669286D29213D3D622C703D6D2E6368696C6472656E26266D2E6368696C6472656E2E6C656E6774683E302C713D6128223C6C693E3C2F6C693E22292C712E616464436C617373282273656C656374322D726573756C74732D6465';
wwv_flow_api.g_varchar2_table(224) := '70742D222B6A292C712E616464436C617373282273656C656374322D726573756C7422292C712E616464436C617373286E3F2273656C656374322D726573756C742D73656C65637461626C65223A2273656C656374322D726573756C742D756E73656C65';
wwv_flow_api.g_varchar2_table(225) := '637461626C6522292C6F2626712E616464436C617373282273656C656374322D64697361626C656422292C702626712E616464436C617373282273656C656374322D726573756C742D776974682D6368696C6472656E22292C712E616464436C61737328';
wwv_flow_api.g_varchar2_table(226) := '682E6F7074732E666F726D6174526573756C74437373436C617373286D29292C723D6128646F63756D656E742E637265617465456C656D656E7428226469762229292C722E616464436C617373282273656C656374322D726573756C742D6C6162656C22';
wwv_flow_api.g_varchar2_table(227) := '292C743D632E666F726D6174526573756C74286D2C722C662C682E6F7074732E6573636170654D61726B7570292C74213D3D622626722E68746D6C2874292C712E617070656E642872292C70262628733D6128223C756C3E3C2F756C3E22292C732E6164';
wwv_flow_api.g_varchar2_table(228) := '64436C617373282273656C656374322D726573756C742D73756222292C67286D2E6368696C6472656E2C732C6A2B31292C712E617070656E64287329292C712E64617461282273656C656374322D64617461222C6D292C652E617070656E642871297D2C';
wwv_flow_api.g_varchar2_table(229) := '6728652C642C30297D7D2C612E666E2E73656C656374322E64656661756C74732C63292C2266756E6374696F6E22213D747970656F6620632E6964262628663D632E69642C632E69643D66756E6374696F6E2861297B72657475726E20615B665D7D292C';
wwv_flow_api.g_varchar2_table(230) := '612E6973417272617928632E656C656D656E742E64617461282273656C6563743254616773222929297B696628227461677322696E2063297468726F7722746167732073706563696669656420617320626F746820616E20617474726962757465202764';
wwv_flow_api.g_varchar2_table(231) := '6174612D73656C656374322D746167732720616E6420696E206F7074696F6E73206F662053656C6563743220222B632E656C656D656E742E617474722822696422293B632E746167733D632E656C656D656E742E64617461282273656C65637432546167';
wwv_flow_api.g_varchar2_table(232) := '7322297D696628653F28632E71756572793D746869732E62696E642866756E6374696F6E2861297B76617220662C672C692C633D7B726573756C74733A5B5D2C6D6F72653A21317D2C653D612E7465726D3B693D66756E6374696F6E28622C63297B7661';
wwv_flow_api.g_varchar2_table(233) := '7220643B622E697328226F7074696F6E22293F612E6D61746368657228652C622E7465787428292C62292626632E7075736828682E6F7074696F6E546F44617461286229293A622E697328226F707467726F75702229262628643D682E6F7074696F6E54';
wwv_flow_api.g_varchar2_table(234) := '6F446174612862292C622E6368696C6472656E28292E65616368322866756E6374696F6E28612C62297B6928622C642E6368696C6472656E297D292C642E6368696C6472656E2E6C656E6774683E302626632E70757368286429297D2C663D642E636869';
wwv_flow_api.g_varchar2_table(235) := '6C6472656E28292C746869732E676574506C616365686F6C6465722829213D3D622626662E6C656E6774683E30262628673D746869732E676574506C616365686F6C6465724F7074696F6E28292C67262628663D662E6E6F7428672929292C662E656163';
wwv_flow_api.g_varchar2_table(236) := '68322866756E6374696F6E28612C62297B6928622C632E726573756C7473297D292C612E63616C6C6261636B2863297D292C632E69643D66756E6374696F6E2861297B72657475726E20612E69647D2C632E666F726D6174526573756C74437373436C61';
wwv_flow_api.g_varchar2_table(237) := '73733D66756E6374696F6E2861297B72657475726E20612E6373737D293A22717565727922696E20637C7C2822616A617822696E20633F28673D632E656C656D656E742E646174612822616A61782D75726C22292C672626672E6C656E6774683E302626';
wwv_flow_api.g_varchar2_table(238) := '28632E616A61782E75726C3D67292C632E71756572793D472E63616C6C28632E656C656D656E742C632E616A617829293A226461746122696E20633F632E71756572793D4828632E64617461293A227461677322696E2063262628632E71756572793D49';
wwv_flow_api.g_varchar2_table(239) := '28632E74616773292C632E63726561746553656172636843686F6963653D3D3D62262628632E63726561746553656172636843686F6963653D66756E6374696F6E2862297B72657475726E7B69643A612E7472696D2862292C746578743A612E7472696D';
wwv_flow_api.g_varchar2_table(240) := '2862297D7D292C632E696E697453656C656374696F6E3D3D3D62262628632E696E697453656C656374696F6E3D66756E6374696F6E28622C64297B76617220653D5B5D3B61287228622E76616C28292C632E736570617261746F7229292E656163682866';
wwv_flow_api.g_varchar2_table(241) := '756E6374696F6E28297B76617220623D7B69643A746869732C746578743A746869737D2C643D632E746167733B612E697346756E6374696F6E286429262628643D642829292C612864292E656163682866756E6374696F6E28297B72657475726E207128';
wwv_flow_api.g_varchar2_table(242) := '746869732E69642C622E6964293F28623D746869732C2131293A766F696420307D292C652E707573682862297D292C642865297D2929292C2266756E6374696F6E22213D747970656F6620632E7175657279297468726F772271756572792066756E6374';
wwv_flow_api.g_varchar2_table(243) := '696F6E206E6F7420646566696E656420666F722053656C6563743220222B632E656C656D656E742E617474722822696422293B72657475726E20637D2C6D6F6E69746F72536F757263653A66756E6374696F6E28297B76617220632C642C613D74686973';
wwv_flow_api.g_varchar2_table(244) := '2E6F7074732E656C656D656E743B612E6F6E28226368616E67652E73656C65637432222C746869732E62696E642866756E6374696F6E28297B746869732E6F7074732E656C656D656E742E64617461282273656C656374322D6368616E67652D74726967';
wwv_flow_api.g_varchar2_table(245) := '67657265642229213D3D21302626746869732E696E697453656C656374696F6E28297D29292C633D746869732E62696E642866756E6374696F6E28297B76617220633D612E70726F70282264697361626C656422293B633D3D3D62262628633D2131292C';
wwv_flow_api.g_varchar2_table(246) := '746869732E656E61626C65282163293B76617220643D612E70726F702822726561646F6E6C7922293B643D3D3D62262628643D2131292C746869732E726561646F6E6C792864292C4428746869732E636F6E7461696E65722C746869732E6F7074732E65';
wwv_flow_api.g_varchar2_table(247) := '6C656D656E742C746869732E6F7074732E6164617074436F6E7461696E6572437373436C617373292C746869732E636F6E7461696E65722E616464436C617373284B28746869732E6F7074732E636F6E7461696E6572437373436C61737329292C442874';
wwv_flow_api.g_varchar2_table(248) := '6869732E64726F70646F776E2C746869732E6F7074732E656C656D656E742C746869732E6F7074732E616461707444726F70646F776E437373436C617373292C746869732E64726F70646F776E2E616464436C617373284B28746869732E6F7074732E64';
wwv_flow_api.g_varchar2_table(249) := '726F70646F776E437373436C61737329297D292C612E6F6E282270726F70657274796368616E67652E73656C65637432222C63292C746869732E6D75746174696F6E43616C6C6261636B3D3D3D62262628746869732E6D75746174696F6E43616C6C6261';
wwv_flow_api.g_varchar2_table(250) := '636B3D66756E6374696F6E2861297B612E666F72456163682863297D292C643D77696E646F772E4D75746174696F6E4F627365727665727C7C77696E646F772E5765624B69744D75746174696F6E4F627365727665727C7C77696E646F772E4D6F7A4D75';
wwv_flow_api.g_varchar2_table(251) := '746174696F6E4F627365727665722C64213D3D62262628746869732E70726F70657274794F6273657276657226262864656C65746520746869732E70726F70657274794F627365727665722C746869732E70726F70657274794F627365727665723D6E75';
wwv_flow_api.g_varchar2_table(252) := '6C6C292C746869732E70726F70657274794F627365727665723D6E6577206428746869732E6D75746174696F6E43616C6C6261636B292C746869732E70726F70657274794F627365727665722E6F62736572766528612E6765742830292C7B6174747269';
wwv_flow_api.g_varchar2_table(253) := '62757465733A21302C737562747265653A21317D29297D2C7472696767657253656C6563743A66756E6374696F6E2862297B76617220633D612E4576656E74282273656C656374322D73656C656374696E67222C7B76616C3A746869732E69642862292C';
wwv_flow_api.g_varchar2_table(254) := '6F626A6563743A627D293B72657475726E20746869732E6F7074732E656C656D656E742E747269676765722863292C21632E697344656661756C7450726576656E74656428297D2C747269676765724368616E67653A66756E6374696F6E2862297B623D';
wwv_flow_api.g_varchar2_table(255) := '627C7C7B7D2C623D612E657874656E64287B7D2C622C7B747970653A226368616E6765222C76616C3A746869732E76616C28297D292C746869732E6F7074732E656C656D656E742E64617461282273656C656374322D6368616E67652D74726967676572';
wwv_flow_api.g_varchar2_table(256) := '6564222C2130292C746869732E6F7074732E656C656D656E742E747269676765722862292C746869732E6F7074732E656C656D656E742E64617461282273656C656374322D6368616E67652D747269676765726564222C2131292C746869732E6F707473';
wwv_flow_api.g_varchar2_table(257) := '2E656C656D656E742E636C69636B28292C746869732E6F7074732E626C75724F6E4368616E67652626746869732E6F7074732E656C656D656E742E626C757228297D2C6973496E74657266616365456E61626C65643A66756E6374696F6E28297B726574';
wwv_flow_api.g_varchar2_table(258) := '75726E20746869732E656E61626C6564496E746572666163653D3D3D21307D2C656E61626C65496E746572666163653A66756E6374696F6E28297B76617220613D746869732E5F656E61626C6564262621746869732E5F726561646F6E6C792C623D2161';
wwv_flow_api.g_varchar2_table(259) := '3B72657475726E20613D3D3D746869732E656E61626C6564496E746572666163653F21313A28746869732E636F6E7461696E65722E746F67676C65436C617373282273656C656374322D636F6E7461696E65722D64697361626C6564222C62292C746869';
wwv_flow_api.g_varchar2_table(260) := '732E636C6F736528292C746869732E656E61626C6564496E746572666163653D612C2130297D2C656E61626C653A66756E6374696F6E2861297B613D3D3D62262628613D2130292C746869732E5F656E61626C6564213D3D61262628746869732E5F656E';
wwv_flow_api.g_varchar2_table(261) := '61626C65643D612C746869732E6F7074732E656C656D656E742E70726F70282264697361626C6564222C2161292C746869732E656E61626C65496E746572666163652829297D2C64697361626C653A66756E6374696F6E28297B746869732E656E61626C';
wwv_flow_api.g_varchar2_table(262) := '65282131297D2C726561646F6E6C793A66756E6374696F6E2861297B72657475726E20613D3D3D62262628613D2131292C746869732E5F726561646F6E6C793D3D3D613F21313A28746869732E5F726561646F6E6C793D612C746869732E6F7074732E65';
wwv_flow_api.g_varchar2_table(263) := '6C656D656E742E70726F702822726561646F6E6C79222C61292C746869732E656E61626C65496E7465726661636528292C2130297D2C6F70656E65643A66756E6374696F6E28297B72657475726E20746869732E636F6E7461696E65722E686173436C61';
wwv_flow_api.g_varchar2_table(264) := '7373282273656C656374322D64726F70646F776E2D6F70656E22297D2C706F736974696F6E44726F70646F776E3A66756E6374696F6E28297B76617220742C752C762C772C782C623D746869732E64726F70646F776E2C633D746869732E636F6E746169';
wwv_flow_api.g_varchar2_table(265) := '6E65722E6F666673657428292C643D746869732E636F6E7461696E65722E6F75746572486569676874282131292C653D746869732E636F6E7461696E65722E6F757465725769647468282131292C663D622E6F75746572486569676874282131292C673D';
wwv_flow_api.g_varchar2_table(266) := '612877696E646F77292C683D672E776964746828292C693D672E68656967687428292C6A3D672E7363726F6C6C4C65667428292B682C6C3D672E7363726F6C6C546F7028292B692C6D3D632E746F702B642C6E3D632E6C6566742C6F3D6C3E3D6D2B662C';
wwv_flow_api.g_varchar2_table(267) := '703D632E746F702D663E3D746869732E626F647928292E7363726F6C6C546F7028292C713D622E6F757465725769647468282131292C723D6A3E3D6E2B712C733D622E686173436C617373282273656C656374322D64726F702D61626F766522293B733F';
wwv_flow_api.g_varchar2_table(268) := '28753D21302C217026266F262628763D21302C753D213129293A28753D21312C216F262670262628763D21302C753D213029292C76262628622E6869646528292C633D746869732E636F6E7461696E65722E6F666673657428292C643D746869732E636F';
wwv_flow_api.g_varchar2_table(269) := '6E7461696E65722E6F75746572486569676874282131292C653D746869732E636F6E7461696E65722E6F757465725769647468282131292C663D622E6F75746572486569676874282131292C6A3D672E7363726F6C6C4C65667428292B682C6C3D672E73';
wwv_flow_api.g_varchar2_table(270) := '63726F6C6C546F7028292B692C6D3D632E746F702B642C6E3D632E6C6566742C713D622E6F757465725769647468282131292C723D6A3E3D6E2B712C622E73686F772829292C746869732E6F7074732E64726F70646F776E4175746F57696474683F2878';
wwv_flow_api.g_varchar2_table(271) := '3D6128222E73656C656374322D726573756C7473222C62295B305D2C622E616464436C617373282273656C656374322D64726F702D6175746F2D776964746822292C622E63737328227769647468222C2222292C713D622E6F7574657257696474682821';
wwv_flow_api.g_varchar2_table(272) := '31292B28782E7363726F6C6C4865696768743D3D3D782E636C69656E744865696768743F303A6B2E7769647468292C713E653F653D713A713D652C723D6A3E3D6E2B71293A746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C';
wwv_flow_api.g_varchar2_table(273) := '656374322D64726F702D6175746F2D776964746822292C2273746174696322213D3D746869732E626F647928292E6373732822706F736974696F6E2229262628743D746869732E626F647928292E6F666673657428292C6D2D3D742E746F702C6E2D3D74';
wwv_flow_api.g_varchar2_table(274) := '2E6C656674292C727C7C286E3D632E6C6566742B652D71292C773D7B6C6566743A6E2C77696474683A657D2C753F28772E626F74746F6D3D692D632E746F702C772E746F703D226175746F222C746869732E636F6E7461696E65722E616464436C617373';
wwv_flow_api.g_varchar2_table(275) := '282273656C656374322D64726F702D61626F766522292C622E616464436C617373282273656C656374322D64726F702D61626F76652229293A28772E746F703D6D2C772E626F74746F6D3D226175746F222C746869732E636F6E7461696E65722E72656D';
wwv_flow_api.g_varchar2_table(276) := '6F7665436C617373282273656C656374322D64726F702D61626F766522292C622E72656D6F7665436C617373282273656C656374322D64726F702D61626F76652229292C773D612E657874656E6428772C4B28746869732E6F7074732E64726F70646F77';
wwv_flow_api.g_varchar2_table(277) := '6E43737329292C622E6373732877297D2C73686F756C644F70656E3A66756E6374696F6E28297B76617220623B72657475726E20746869732E6F70656E656428293F21313A746869732E5F656E61626C65643D3D3D21317C7C746869732E5F726561646F';
wwv_flow_api.g_varchar2_table(278) := '6E6C793D3D3D21303F21313A28623D612E4576656E74282273656C656374322D6F70656E696E6722292C746869732E6F7074732E656C656D656E742E747269676765722862292C21622E697344656661756C7450726576656E7465642829297D2C636C65';
wwv_flow_api.g_varchar2_table(279) := '617244726F70646F776E416C69676E6D656E74507265666572656E63653A66756E6374696F6E28297B746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D64726F702D61626F766522292C746869732E64726F7064';
wwv_flow_api.g_varchar2_table(280) := '6F776E2E72656D6F7665436C617373282273656C656374322D64726F702D61626F766522297D2C6F70656E3A66756E6374696F6E28297B72657475726E20746869732E73686F756C644F70656E28293F28746869732E6F70656E696E6728292C2130293A';
wwv_flow_api.g_varchar2_table(281) := '21317D2C6F70656E696E673A66756E6374696F6E28297B76617220662C623D746869732E636F6E7461696E657249642C633D227363726F6C6C2E222B622C643D22726573697A652E222B622C653D226F7269656E746174696F6E6368616E67652E222B62';
wwv_flow_api.g_varchar2_table(282) := '3B746869732E636F6E7461696E65722E616464436C617373282273656C656374322D64726F70646F776E2D6F70656E22292E616464436C617373282273656C656374322D636F6E7461696E65722D61637469766522292C746869732E636C65617244726F';
wwv_flow_api.g_varchar2_table(283) := '70646F776E416C69676E6D656E74507265666572656E636528292C746869732E64726F70646F776E5B305D213D3D746869732E626F647928292E6368696C6472656E28292E6C61737428295B305D2626746869732E64726F70646F776E2E646574616368';
wwv_flow_api.g_varchar2_table(284) := '28292E617070656E64546F28746869732E626F64792829292C663D6128222373656C656374322D64726F702D6D61736B22292C303D3D662E6C656E677468262628663D6128646F63756D656E742E637265617465456C656D656E7428226469762229292C';
wwv_flow_api.g_varchar2_table(285) := '662E6174747228226964222C2273656C656374322D64726F702D6D61736B22292E617474722822636C617373222C2273656C656374322D64726F702D6D61736B22292C662E6869646528292C662E617070656E64546F28746869732E626F64792829292C';
wwv_flow_api.g_varchar2_table(286) := '662E6F6E28226D6F757365646F776E20746F756368737461727420636C69636B222C66756E6374696F6E2862297B76617220642C633D6128222373656C656374322D64726F7022293B632E6C656E6774683E30262628643D632E64617461282273656C65';
wwv_flow_api.g_varchar2_table(287) := '63743222292C642E6F7074732E73656C6563744F6E426C75722626642E73656C656374486967686C696768746564287B6E6F466F6375733A21307D292C642E636C6F7365287B666F6375733A21307D292C622E70726576656E7444656661756C7428292C';
wwv_flow_api.g_varchar2_table(288) := '622E73746F7050726F7061676174696F6E2829297D29292C746869732E64726F70646F776E2E7072657628295B305D213D3D665B305D2626746869732E64726F70646F776E2E6265666F72652866292C6128222373656C656374322D64726F7022292E72';
wwv_flow_api.g_varchar2_table(289) := '656D6F7665417474722822696422292C746869732E64726F70646F776E2E6174747228226964222C2273656C656374322D64726F7022292C662E73686F7728292C746869732E706F736974696F6E44726F70646F776E28292C746869732E64726F70646F';
wwv_flow_api.g_varchar2_table(290) := '776E2E73686F7728292C746869732E706F736974696F6E44726F70646F776E28292C746869732E64726F70646F776E2E616464436C617373282273656C656374322D64726F702D61637469766522293B76617220673D746869733B746869732E636F6E74';
wwv_flow_api.g_varchar2_table(291) := '61696E65722E706172656E747328292E6164642877696E646F77292E656163682866756E6374696F6E28297B612874686973292E6F6E28642B2220222B632B2220222B652C66756E6374696F6E28297B672E706F736974696F6E44726F70646F776E2829';
wwv_flow_api.g_varchar2_table(292) := '7D297D297D2C636C6F73653A66756E6374696F6E28297B696628746869732E6F70656E65642829297B76617220623D746869732E636F6E7461696E657249642C633D227363726F6C6C2E222B622C643D22726573697A652E222B622C653D226F7269656E';
wwv_flow_api.g_varchar2_table(293) := '746174696F6E6368616E67652E222B623B746869732E636F6E7461696E65722E706172656E747328292E6164642877696E646F77292E656163682866756E6374696F6E28297B612874686973292E6F66662863292E6F66662864292E6F66662865297D29';
wwv_flow_api.g_varchar2_table(294) := '2C746869732E636C65617244726F70646F776E416C69676E6D656E74507265666572656E636528292C6128222373656C656374322D64726F702D6D61736B22292E6869646528292C746869732E64726F70646F776E2E72656D6F76654174747228226964';
wwv_flow_api.g_varchar2_table(295) := '22292C746869732E64726F70646F776E2E6869646528292C746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D64726F70646F776E2D6F70656E22292E72656D6F7665436C617373282273656C656374322D636F6E';
wwv_flow_api.g_varchar2_table(296) := '7461696E65722D61637469766522292C746869732E726573756C74732E656D70747928292C746869732E636C65617253656172636828292C746869732E7365617263682E72656D6F7665436C617373282273656C656374322D61637469766522292C7468';
wwv_flow_api.g_varchar2_table(297) := '69732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D636C6F73652229297D7D2C65787465726E616C5365617263683A66756E6374696F6E2861297B746869732E6F70656E28292C746869732E73656172';
wwv_flow_api.g_varchar2_table(298) := '63682E76616C2861292C746869732E757064617465526573756C7473282131297D2C636C6561725365617263683A66756E6374696F6E28297B7D2C6765744D6178696D756D53656C656374696F6E53697A653A66756E6374696F6E28297B72657475726E';
wwv_flow_api.g_varchar2_table(299) := '204B28746869732E6F7074732E6D6178696D756D53656C656374696F6E53697A65297D2C656E73757265486967686C6967687456697369626C653A66756E6374696F6E28297B76617220632C642C652C662C672C682C692C623D746869732E726573756C';
wwv_flow_api.g_varchar2_table(300) := '74733B696628643D746869732E686967686C6967687428292C2128303E6429297B696628303D3D642972657475726E20622E7363726F6C6C546F702830292C766F696420303B633D746869732E66696E64486967686C6967687461626C6543686F696365';
wwv_flow_api.g_varchar2_table(301) := '7328292E66696E6428222E73656C656374322D726573756C742D6C6162656C22292C653D6128635B645D292C663D652E6F666673657428292E746F702B652E6F75746572486569676874282130292C643D3D3D632E6C656E6774682D31262628693D622E';
wwv_flow_api.g_varchar2_table(302) := '66696E6428226C692E73656C656374322D6D6F72652D726573756C747322292C692E6C656E6774683E30262628663D692E6F666673657428292E746F702B692E6F757465724865696768742821302929292C673D622E6F666673657428292E746F702B62';
wwv_flow_api.g_varchar2_table(303) := '2E6F75746572486569676874282130292C663E672626622E7363726F6C6C546F7028622E7363726F6C6C546F7028292B28662D6729292C683D652E6F666673657428292E746F702D622E6F666673657428292E746F702C303E682626226E6F6E6522213D';
wwv_flow_api.g_varchar2_table(304) := '652E6373732822646973706C617922292626622E7363726F6C6C546F7028622E7363726F6C6C546F7028292B68297D7D2C66696E64486967686C6967687461626C6543686F696365733A66756E6374696F6E28297B72657475726E20746869732E726573';
wwv_flow_api.g_varchar2_table(305) := '756C74732E66696E6428222E73656C656374322D726573756C742D73656C65637461626C653A6E6F74282E73656C656374322D64697361626C65642C202E73656C656374322D73656C65637465642922297D2C6D6F7665486967686C696768743A66756E';
wwv_flow_api.g_varchar2_table(306) := '6374696F6E2862297B666F722876617220633D746869732E66696E64486967686C6967687461626C6543686F6963657328292C643D746869732E686967686C6967687428293B643E2D312626643C632E6C656E6774683B297B642B3D623B76617220653D';
wwv_flow_api.g_varchar2_table(307) := '6128635B645D293B696628652E686173436C617373282273656C656374322D726573756C742D73656C65637461626C652229262621652E686173436C617373282273656C656374322D64697361626C65642229262621652E686173436C61737328227365';
wwv_flow_api.g_varchar2_table(308) := '6C656374322D73656C65637465642229297B746869732E686967686C696768742864293B627265616B7D7D7D2C686967686C696768743A66756E6374696F6E2862297B76617220642C652C633D746869732E66696E64486967686C6967687461626C6543';
wwv_flow_api.g_varchar2_table(309) := '686F6963657328293B72657475726E20303D3D3D617267756D656E74732E6C656E6774683F6F28632E66696C74657228222E73656C656374322D686967686C69676874656422295B305D2C632E6765742829293A28623E3D632E6C656E67746826262862';
wwv_flow_api.g_varchar2_table(310) := '3D632E6C656E6774682D31292C303E62262628623D30292C746869732E72656D6F7665486967686C6967687428292C643D6128635B625D292C642E616464436C617373282273656C656374322D686967686C69676874656422292C746869732E656E7375';
wwv_flow_api.g_varchar2_table(311) := '7265486967686C6967687456697369626C6528292C653D642E64617461282273656C656374322D6461746122292C652626746869732E6F7074732E656C656D656E742E74726967676572287B747970653A2273656C656374322D686967686C6967687422';
wwv_flow_api.g_varchar2_table(312) := '2C76616C3A746869732E69642865292C63686F6963653A657D292C766F69642030297D2C72656D6F7665486967686C696768743A66756E6374696F6E28297B746869732E726573756C74732E66696E6428222E73656C656374322D686967686C69676874';
wwv_flow_api.g_varchar2_table(313) := '656422292E72656D6F7665436C617373282273656C656374322D686967686C69676874656422297D2C636F756E7453656C65637461626C65526573756C74733A66756E6374696F6E28297B72657475726E20746869732E66696E64486967686C69676874';
wwv_flow_api.g_varchar2_table(314) := '61626C6543686F6963657328292E6C656E6774687D2C686967686C69676874556E6465724576656E743A66756E6374696F6E2862297B76617220633D6128622E746172676574292E636C6F7365737428222E73656C656374322D726573756C742D73656C';
wwv_flow_api.g_varchar2_table(315) := '65637461626C6522293B696628632E6C656E6774683E30262621632E697328222E73656C656374322D686967686C6967687465642229297B76617220643D746869732E66696E64486967686C6967687461626C6543686F6963657328293B746869732E68';
wwv_flow_api.g_varchar2_table(316) := '6967686C6967687428642E696E646578286329297D656C736520303D3D632E6C656E6774682626746869732E72656D6F7665486967686C6967687428297D2C6C6F61644D6F726549664E65656465643A66756E6374696F6E28297B76617220632C613D74';
wwv_flow_api.g_varchar2_table(317) := '6869732E726573756C74732C623D612E66696E6428226C692E73656C656374322D6D6F72652D726573756C747322292C643D746869732E726573756C7473506167652B312C653D746869732C663D746869732E7365617263682E76616C28292C673D7468';
wwv_flow_api.g_varchar2_table(318) := '69732E636F6E746578743B30213D3D622E6C656E677468262628633D622E6F666673657428292E746F702D612E6F666673657428292E746F702D612E68656967687428292C633C3D746869732E6F7074732E6C6F61644D6F726550616464696E67262628';
wwv_flow_api.g_varchar2_table(319) := '622E616464436C617373282273656C656374322D61637469766522292C746869732E6F7074732E7175657279287B656C656D656E743A746869732E6F7074732E656C656D656E742C7465726D3A662C706167653A642C636F6E746578743A672C6D617463';
wwv_flow_api.g_varchar2_table(320) := '6865723A746869732E6F7074732E6D6174636865722C63616C6C6261636B3A746869732E62696E642866756E6374696F6E2863297B652E6F70656E65642829262628652E6F7074732E706F70756C617465526573756C74732E63616C6C28746869732C61';
wwv_flow_api.g_varchar2_table(321) := '2C632E726573756C74732C7B7465726D3A662C706167653A642C636F6E746578743A677D292C652E706F737470726F63657373526573756C747328632C21312C2131292C632E6D6F72653D3D3D21303F28622E64657461636828292E617070656E64546F';
wwv_flow_api.g_varchar2_table(322) := '2861292E7465787428652E6F7074732E666F726D61744C6F61644D6F726528642B3129292C77696E646F772E73657454696D656F75742866756E6374696F6E28297B652E6C6F61644D6F726549664E656564656428297D2C313029293A622E72656D6F76';
wwv_flow_api.g_varchar2_table(323) := '6528292C652E706F736974696F6E44726F70646F776E28292C652E726573756C7473506167653D642C652E636F6E746578743D632E636F6E746578742C746869732E6F7074732E656C656D656E742E74726967676572287B747970653A2273656C656374';
wwv_flow_api.g_varchar2_table(324) := '322D6C6F61646564222C6974656D733A637D29297D297D2929297D2C746F6B656E697A653A66756E6374696F6E28297B7D2C757064617465526573756C74733A66756E6374696F6E2863297B66756E6374696F6E206D28297B642E72656D6F7665436C61';
wwv_flow_api.g_varchar2_table(325) := '7373282273656C656374322D61637469766522292C682E706F736974696F6E44726F70646F776E28297D66756E6374696F6E206E2861297B652E68746D6C2861292C6D28297D76617220672C692C6C2C643D746869732E7365617263682C653D74686973';
wwv_flow_api.g_varchar2_table(326) := '2E726573756C74732C663D746869732E6F7074732C683D746869732C6A3D642E76616C28292C6B3D612E6461746128746869732E636F6E7461696E65722C2273656C656374322D6C6173742D7465726D22293B69662828633D3D3D21307C7C216B7C7C21';
wwv_flow_api.g_varchar2_table(327) := '71286A2C6B2929262628612E6461746128746869732E636F6E7461696E65722C2273656C656374322D6C6173742D7465726D222C6A292C633D3D3D21307C7C746869732E73686F77536561726368496E707574213D3D21312626746869732E6F70656E65';
wwv_flow_api.g_varchar2_table(328) := '64282929297B6C3D2B2B746869732E7175657279436F756E743B766172206F3D746869732E6765744D6178696D756D53656C656374696F6E53697A6528293B6966286F3E3D31262628673D746869732E6461746128292C612E6973417272617928672926';
wwv_flow_api.g_varchar2_table(329) := '26672E6C656E6774683E3D6F26264A28662E666F726D617453656C656374696F6E546F6F4269672C22666F726D617453656C656374696F6E546F6F4269672229292972657475726E206E28223C6C6920636C6173733D2773656C656374322D73656C6563';
wwv_flow_api.g_varchar2_table(330) := '74696F6E2D6C696D6974273E222B662E666F726D617453656C656374696F6E546F6F426967286F292B223C2F6C693E22292C766F696420303B696628642E76616C28292E6C656E6774683C662E6D696E696D756D496E7075744C656E6774682972657475';
wwv_flow_api.g_varchar2_table(331) := '726E204A28662E666F726D6174496E707574546F6F53686F72742C22666F726D6174496E707574546F6F53686F727422293F6E28223C6C6920636C6173733D2773656C656374322D6E6F2D726573756C7473273E222B662E666F726D6174496E70757454';
wwv_flow_api.g_varchar2_table(332) := '6F6F53686F727428642E76616C28292C662E6D696E696D756D496E7075744C656E677468292B223C2F6C693E22293A6E282222292C632626746869732E73686F775365617263682626746869732E73686F77536561726368282130292C766F696420303B';
wwv_flow_api.g_varchar2_table(333) := '0A696628662E6D6178696D756D496E7075744C656E6774682626642E76616C28292E6C656E6774683E662E6D6178696D756D496E7075744C656E6774682972657475726E204A28662E666F726D6174496E707574546F6F4C6F6E672C22666F726D617449';
wwv_flow_api.g_varchar2_table(334) := '6E707574546F6F4C6F6E6722293F6E28223C6C6920636C6173733D2773656C656374322D6E6F2D726573756C7473273E222B662E666F726D6174496E707574546F6F4C6F6E6728642E76616C28292C662E6D6178696D756D496E7075744C656E67746829';
wwv_flow_api.g_varchar2_table(335) := '2B223C2F6C693E22293A6E282222292C766F696420303B662E666F726D6174536561726368696E672626303D3D3D746869732E66696E64486967686C6967687461626C6543686F6963657328292E6C656E67746826266E28223C6C6920636C6173733D27';
wwv_flow_api.g_varchar2_table(336) := '73656C656374322D736561726368696E67273E222B662E666F726D6174536561726368696E6728292B223C2F6C693E22292C642E616464436C617373282273656C656374322D61637469766522292C746869732E72656D6F7665486967686C6967687428';
wwv_flow_api.g_varchar2_table(337) := '292C693D746869732E746F6B656E697A6528292C69213D6226266E756C6C213D692626642E76616C2869292C746869732E726573756C7473506167653D312C662E7175657279287B656C656D656E743A662E656C656D656E742C7465726D3A642E76616C';
wwv_flow_api.g_varchar2_table(338) := '28292C706167653A746869732E726573756C7473506167652C636F6E746578743A6E756C6C2C6D6174636865723A662E6D6174636865722C63616C6C6261636B3A746869732E62696E642866756E6374696F6E2867297B76617220693B6966286C3D3D74';
wwv_flow_api.g_varchar2_table(339) := '6869732E7175657279436F756E74297B69662821746869732E6F70656E656428292972657475726E20746869732E7365617263682E72656D6F7665436C617373282273656C656374322D61637469766522292C766F696420303B696628746869732E636F';
wwv_flow_api.g_varchar2_table(340) := '6E746578743D672E636F6E746578743D3D3D623F6E756C6C3A672E636F6E746578742C746869732E6F7074732E63726561746553656172636843686F69636526262222213D3D642E76616C2829262628693D746869732E6F7074732E6372656174655365';
wwv_flow_api.g_varchar2_table(341) := '6172636843686F6963652E63616C6C28682C642E76616C28292C672E726573756C7473292C69213D3D6226266E756C6C213D3D692626682E6964286929213D3D6226266E756C6C213D3D682E69642869292626303D3D3D6128672E726573756C7473292E';
wwv_flow_api.g_varchar2_table(342) := '66696C7465722866756E6374696F6E28297B72657475726E207128682E69642874686973292C682E6964286929297D292E6C656E6774682626672E726573756C74732E756E7368696674286929292C303D3D3D672E726573756C74732E6C656E67746826';
wwv_flow_api.g_varchar2_table(343) := '264A28662E666F726D61744E6F4D6174636865732C22666F726D61744E6F4D61746368657322292972657475726E206E28223C6C6920636C6173733D2773656C656374322D6E6F2D726573756C7473273E222B662E666F726D61744E6F4D617463686573';
wwv_flow_api.g_varchar2_table(344) := '28642E76616C2829292B223C2F6C693E22292C766F696420303B652E656D70747928292C682E6F7074732E706F70756C617465526573756C74732E63616C6C28746869732C652C672E726573756C74732C7B7465726D3A642E76616C28292C706167653A';
wwv_flow_api.g_varchar2_table(345) := '746869732E726573756C7473506167652C636F6E746578743A6E756C6C7D292C672E6D6F72653D3D3D213026264A28662E666F726D61744C6F61644D6F72652C22666F726D61744C6F61644D6F72652229262628652E617070656E6428223C6C6920636C';
wwv_flow_api.g_varchar2_table(346) := '6173733D2773656C656374322D6D6F72652D726573756C7473273E222B682E6F7074732E6573636170654D61726B757028662E666F726D61744C6F61644D6F726528746869732E726573756C74735061676529292B223C2F6C693E22292C77696E646F77';
wwv_flow_api.g_varchar2_table(347) := '2E73657454696D656F75742866756E6374696F6E28297B682E6C6F61644D6F726549664E656564656428297D2C313029292C746869732E706F737470726F63657373526573756C747328672C63292C6D28292C746869732E6F7074732E656C656D656E74';
wwv_flow_api.g_varchar2_table(348) := '2E74726967676572287B747970653A2273656C656374322D6C6F61646564222C6974656D733A677D297D7D297D297D7D2C63616E63656C3A66756E6374696F6E28297B746869732E636C6F736528297D2C626C75723A66756E6374696F6E28297B746869';
wwv_flow_api.g_varchar2_table(349) := '732E6F7074732E73656C6563744F6E426C75722626746869732E73656C656374486967686C696768746564287B6E6F466F6375733A21307D292C746869732E636C6F736528292C746869732E636F6E7461696E65722E72656D6F7665436C617373282273';
wwv_flow_api.g_varchar2_table(350) := '656C656374322D636F6E7461696E65722D61637469766522292C746869732E7365617263685B305D3D3D3D646F63756D656E742E616374697665456C656D656E742626746869732E7365617263682E626C757228292C746869732E636C65617253656172';
wwv_flow_api.g_varchar2_table(351) := '636828292C746869732E73656C656374696F6E2E66696E6428222E73656C656374322D7365617263682D63686F6963652D666F63757322292E72656D6F7665436C617373282273656C656374322D7365617263682D63686F6963652D666F63757322297D';
wwv_flow_api.g_varchar2_table(352) := '2C666F6375735365617263683A66756E6374696F6E28297B7928746869732E736561726368297D2C73656C656374486967686C6967687465643A66756E6374696F6E2861297B76617220623D746869732E686967686C6967687428292C633D746869732E';
wwv_flow_api.g_varchar2_table(353) := '726573756C74732E66696E6428222E73656C656374322D686967686C69676874656422292C643D632E636C6F7365737428222E73656C656374322D726573756C7422292E64617461282273656C656374322D6461746122293B643F28746869732E686967';
wwv_flow_api.g_varchar2_table(354) := '686C696768742862292C746869732E6F6E53656C65637428642C6129293A612626612E6E6F466F6375732626746869732E636C6F736528297D2C676574506C616365686F6C6465723A66756E6374696F6E28297B76617220613B72657475726E20746869';
wwv_flow_api.g_varchar2_table(355) := '732E6F7074732E656C656D656E742E617474722822706C616365686F6C64657222297C7C746869732E6F7074732E656C656D656E742E617474722822646174612D706C616365686F6C64657222297C7C746869732E6F7074732E656C656D656E742E6461';
wwv_flow_api.g_varchar2_table(356) := '74612822706C616365686F6C64657222297C7C746869732E6F7074732E706C616365686F6C6465727C7C2828613D746869732E676574506C616365686F6C6465724F7074696F6E282929213D3D623F612E7465787428293A62297D2C676574506C616365';
wwv_flow_api.g_varchar2_table(357) := '686F6C6465724F7074696F6E3A66756E6374696F6E28297B696628746869732E73656C656374297B76617220613D746869732E73656C6563742E6368696C6472656E28226F7074696F6E22292E666972737428293B696628746869732E6F7074732E706C';
wwv_flow_api.g_varchar2_table(358) := '616365686F6C6465724F7074696F6E213D3D622972657475726E226669727374223D3D3D746869732E6F7074732E706C616365686F6C6465724F7074696F6E2626617C7C2266756E6374696F6E223D3D747970656F6620746869732E6F7074732E706C61';
wwv_flow_api.g_varchar2_table(359) := '6365686F6C6465724F7074696F6E2626746869732E6F7074732E706C616365686F6C6465724F7074696F6E28746869732E73656C656374293B69662822223D3D3D612E746578742829262622223D3D3D612E76616C28292972657475726E20617D7D2C69';
wwv_flow_api.g_varchar2_table(360) := '6E6974436F6E7461696E657257696474683A66756E6374696F6E28297B66756E6374696F6E206328297B76617220632C642C652C662C672C683B696628226F6666223D3D3D746869732E6F7074732E77696474682972657475726E206E756C6C3B696628';
wwv_flow_api.g_varchar2_table(361) := '22656C656D656E74223D3D3D746869732E6F7074732E77696474682972657475726E20303D3D3D746869732E6F7074732E656C656D656E742E6F757465725769647468282131293F226175746F223A746869732E6F7074732E656C656D656E742E6F7574';
wwv_flow_api.g_varchar2_table(362) := '65725769647468282131292B227078223B69662822636F7079223D3D3D746869732E6F7074732E77696474687C7C227265736F6C7665223D3D3D746869732E6F7074732E7769647468297B696628633D746869732E6F7074732E656C656D656E742E6174';
wwv_flow_api.g_varchar2_table(363) := '747228227374796C6522292C63213D3D6229666F7228643D632E73706C697428223B22292C663D302C673D642E6C656E6774683B673E663B662B3D3129696628683D645B665D2E7265706C616365282F5C732F672C2222292C653D682E6D61746368282F';
wwv_flow_api.g_varchar2_table(364) := '5E77696474683A28285B2D2B5D3F285B302D395D2A5C2E293F5B302D395D2B292870787C656D7C65787C257C696E7C636D7C6D6D7C70747C706329292F69292C6E756C6C213D3D652626652E6C656E6774683E3D312972657475726E20655B315D3B7265';
wwv_flow_api.g_varchar2_table(365) := '7475726E227265736F6C7665223D3D3D746869732E6F7074732E77696474683F28633D746869732E6F7074732E656C656D656E742E6373732822776964746822292C632E696E6465784F6628222522293E303F633A303D3D3D746869732E6F7074732E65';
wwv_flow_api.g_varchar2_table(366) := '6C656D656E742E6F757465725769647468282131293F226175746F223A746869732E6F7074732E656C656D656E742E6F757465725769647468282131292B22707822293A6E756C6C7D72657475726E20612E697346756E6374696F6E28746869732E6F70';
wwv_flow_api.g_varchar2_table(367) := '74732E7769647468293F746869732E6F7074732E776964746828293A746869732E6F7074732E77696474687D76617220643D632E63616C6C2874686973293B6E756C6C213D3D642626746869732E636F6E7461696E65722E63737328227769647468222C';
wwv_flow_api.g_varchar2_table(368) := '64297D7D292C653D4E28642C7B637265617465436F6E7461696E65723A66756E6374696F6E28297B76617220623D6128646F63756D656E742E637265617465456C656D656E7428226469762229292E61747472287B22636C617373223A2273656C656374';
wwv_flow_api.g_varchar2_table(369) := '322D636F6E7461696E6572227D292E68746D6C285B223C6120687265663D276A6176617363726970743A766F696428302927206F6E636C69636B3D2772657475726E2066616C73653B2720636C6173733D2773656C656374322D63686F69636527207461';
wwv_flow_api.g_varchar2_table(370) := '62696E6465783D272D31273E222C222020203C7370616E20636C6173733D2773656C656374322D63686F73656E273E266E6273703B3C2F7370616E3E3C6162627220636C6173733D2773656C656374322D7365617263682D63686F6963652D636C6F7365';
wwv_flow_api.g_varchar2_table(371) := '273E3C2F616262723E222C222020203C7370616E20636C6173733D2773656C656374322D6172726F77273E3C623E3C2F623E3C2F7370616E3E222C223C2F613E222C223C696E70757420636C6173733D2773656C656374322D666F637573736572207365';
wwv_flow_api.g_varchar2_table(372) := '6C656374322D6F666673637265656E2720747970653D2774657874272F3E222C223C64697620636C6173733D2773656C656374322D64726F702073656C656374322D646973706C61792D6E6F6E65273E222C222020203C64697620636C6173733D277365';
wwv_flow_api.g_varchar2_table(373) := '6C656374322D736561726368273E222C22202020202020203C696E70757420747970653D277465787427206175746F636F6D706C6574653D276F666627206175746F636F72726563743D276F666627206175746F6361706974616C697A653D276F666627';
wwv_flow_api.g_varchar2_table(374) := '207370656C6C636865636B3D2766616C73652720636C6173733D2773656C656374322D696E707574272F3E222C222020203C2F6469763E222C222020203C756C20636C6173733D2773656C656374322D726573756C7473273E222C222020203C2F756C3E';
wwv_flow_api.g_varchar2_table(375) := '222C223C2F6469763E225D2E6A6F696E28222229293B72657475726E20627D2C656E61626C65496E746572666163653A66756E6374696F6E28297B746869732E706172656E742E656E61626C65496E746572666163652E6170706C7928746869732C6172';
wwv_flow_api.g_varchar2_table(376) := '67756D656E7473292626746869732E666F6375737365722E70726F70282264697361626C6564222C21746869732E6973496E74657266616365456E61626C65642829297D2C6F70656E696E673A66756E6374696F6E28297B76617220632C642C653B7468';
wwv_flow_api.g_varchar2_table(377) := '69732E6F7074732E6D696E696D756D526573756C7473466F725365617263683E3D302626746869732E73686F77536561726368282130292C746869732E706172656E742E6F70656E696E672E6170706C7928746869732C617267756D656E7473292C7468';
wwv_flow_api.g_varchar2_table(378) := '69732E73686F77536561726368496E707574213D3D21312626746869732E7365617263682E76616C28746869732E666F6375737365722E76616C2829292C746869732E7365617263682E666F63757328292C633D746869732E7365617263682E67657428';
wwv_flow_api.g_varchar2_table(379) := '30292C632E6372656174655465787452616E67653F28643D632E6372656174655465787452616E676528292C642E636F6C6C61707365282131292C642E73656C6563742829293A632E73657453656C656374696F6E52616E6765262628653D746869732E';
wwv_flow_api.g_varchar2_table(380) := '7365617263682E76616C28292E6C656E6774682C632E73657453656C656374696F6E52616E676528652C6529292C22223D3D3D746869732E7365617263682E76616C28292626746869732E6E6578745365617263685465726D213D62262628746869732E';
wwv_flow_api.g_varchar2_table(381) := '7365617263682E76616C28746869732E6E6578745365617263685465726D292C746869732E7365617263682E73656C6563742829292C746869732E666F6375737365722E70726F70282264697361626C6564222C2130292E76616C282222292C74686973';
wwv_flow_api.g_varchar2_table(382) := '2E757064617465526573756C7473282130292C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D6F70656E2229297D2C636C6F73653A66756E6374696F6E2861297B746869732E6F70656E6564';
wwv_flow_api.g_varchar2_table(383) := '2829262628746869732E706172656E742E636C6F73652E6170706C7928746869732C617267756D656E7473292C613D617C7C7B666F6375733A21307D2C746869732E666F6375737365722E72656D6F766541747472282264697361626C656422292C612E';
wwv_flow_api.g_varchar2_table(384) := '666F6375732626746869732E666F6375737365722E666F6375732829297D2C666F6375733A66756E6374696F6E28297B746869732E6F70656E656428293F746869732E636C6F736528293A28746869732E666F6375737365722E72656D6F766541747472';
wwv_flow_api.g_varchar2_table(385) := '282264697361626C656422292C746869732E666F6375737365722E666F6375732829297D2C6973466F63757365643A66756E6374696F6E28297B72657475726E20746869732E636F6E7461696E65722E686173436C617373282273656C656374322D636F';
wwv_flow_api.g_varchar2_table(386) := '6E7461696E65722D61637469766522297D2C63616E63656C3A66756E6374696F6E28297B746869732E706172656E742E63616E63656C2E6170706C7928746869732C617267756D656E7473292C746869732E666F6375737365722E72656D6F7665417474';
wwv_flow_api.g_varchar2_table(387) := '72282264697361626C656422292C746869732E666F6375737365722E666F63757328297D2C64657374726F793A66756E6374696F6E28297B6128226C6162656C5B666F723D27222B746869732E666F6375737365722E617474722822696422292B22275D';
wwv_flow_api.g_varchar2_table(388) := '22292E617474722822666F72222C746869732E6F7074732E656C656D656E742E61747472282269642229292C746869732E706172656E742E64657374726F792E6170706C7928746869732C617267756D656E7473297D2C696E6974436F6E7461696E6572';
wwv_flow_api.g_varchar2_table(389) := '3A66756E6374696F6E28297B76617220622C643D746869732E636F6E7461696E65722C653D746869732E64726F70646F776E3B746869732E6F7074732E6D696E696D756D526573756C7473466F725365617263683C303F746869732E73686F7753656172';
wwv_flow_api.g_varchar2_table(390) := '6368282131293A746869732E73686F77536561726368282130292C746869732E73656C656374696F6E3D623D642E66696E6428222E73656C656374322D63686F69636522292C746869732E666F6375737365723D642E66696E6428222E73656C65637432';
wwv_flow_api.g_varchar2_table(391) := '2D666F63757373657222292C746869732E666F6375737365722E6174747228226964222C22733269645F6175746F67656E222B672829292C6128226C6162656C5B666F723D27222B746869732E6F7074732E656C656D656E742E61747472282269642229';
wwv_flow_api.g_varchar2_table(392) := '2B22275D22292E617474722822666F72222C746869732E666F6375737365722E61747472282269642229292C746869732E666F6375737365722E617474722822746162696E646578222C746869732E656C656D656E74546162496E646578292C74686973';
wwv_flow_api.g_varchar2_table(393) := '2E7365617263682E6F6E28226B6579646F776E222C746869732E62696E642866756E6374696F6E2861297B696628746869732E6973496E74657266616365456E61626C65642829297B696628612E77686963683D3D3D632E504147455F55507C7C612E77';
wwv_flow_api.g_varchar2_table(394) := '686963683D3D3D632E504147455F444F574E2972657475726E20412861292C766F696420303B73776974636828612E7768696368297B6361736520632E55503A6361736520632E444F574E3A72657475726E20746869732E6D6F7665486967686C696768';
wwv_flow_api.g_varchar2_table(395) := '7428612E77686963683D3D3D632E55503F2D313A31292C412861292C766F696420303B6361736520632E454E5445523A72657475726E20746869732E73656C656374486967686C69676874656428292C412861292C766F696420303B6361736520632E54';
wwv_flow_api.g_varchar2_table(396) := '41423A72657475726E20746869732E73656C656374486967686C696768746564287B6E6F466F6375733A21307D292C766F696420303B6361736520632E4553433A72657475726E20746869732E63616E63656C2861292C412861292C766F696420307D7D';
wwv_flow_api.g_varchar2_table(397) := '7D29292C746869732E7365617263682E6F6E2822626C7572222C746869732E62696E642866756E6374696F6E28297B646F63756D656E742E616374697665456C656D656E743D3D3D746869732E626F647928292E676574283029262677696E646F772E73';
wwv_flow_api.g_varchar2_table(398) := '657454696D656F757428746869732E62696E642866756E6374696F6E28297B746869732E7365617263682E666F63757328297D292C30297D29292C746869732E666F6375737365722E6F6E28226B6579646F776E222C746869732E62696E642866756E63';
wwv_flow_api.g_varchar2_table(399) := '74696F6E2861297B696628746869732E6973496E74657266616365456E61626C656428292626612E7768696368213D3D632E544142262621632E6973436F6E74726F6C286129262621632E697346756E6374696F6E4B65792861292626612E7768696368';
wwv_flow_api.g_varchar2_table(400) := '213D3D632E455343297B696628746869732E6F7074732E6F70656E4F6E456E7465723D3D3D21312626612E77686963683D3D3D632E454E5445522972657475726E20412861292C766F696420303B696628612E77686963683D3D632E444F574E7C7C612E';
wwv_flow_api.g_varchar2_table(401) := '77686963683D3D632E55507C7C612E77686963683D3D632E454E5445522626746869732E6F7074732E6F70656E4F6E456E746572297B696628612E616C744B65797C7C612E6374726C4B65797C7C612E73686966744B65797C7C612E6D6574614B657929';
wwv_flow_api.g_varchar2_table(402) := '72657475726E3B72657475726E20746869732E6F70656E28292C412861292C766F696420307D72657475726E20612E77686963683D3D632E44454C4554457C7C612E77686963683D3D632E4241434B53504143453F28746869732E6F7074732E616C6C6F';
wwv_flow_api.g_varchar2_table(403) := '77436C6561722626746869732E636C65617228292C412861292C766F69642030293A766F696420307D7D29292C7428746869732E666F637573736572292C746869732E666F6375737365722E6F6E28226B657975702D6368616E676520696E707574222C';
wwv_flow_api.g_varchar2_table(404) := '746869732E62696E642866756E6374696F6E2861297B696628746869732E6F7074732E6D696E696D756D526573756C7473466F725365617263683E3D30297B696628612E73746F7050726F7061676174696F6E28292C746869732E6F70656E6564282929';
wwv_flow_api.g_varchar2_table(405) := '72657475726E3B746869732E6F70656E28297D7D29292C622E6F6E28226D6F757365646F776E222C2261626272222C746869732E62696E642866756E6374696F6E2861297B746869732E6973496E74657266616365456E61626C65642829262628746869';
wwv_flow_api.g_varchar2_table(406) := '732E636C65617228292C422861292C746869732E636C6F736528292C746869732E73656C656374696F6E2E666F6375732829297D29292C622E6F6E28226D6F757365646F776E222C746869732E62696E642866756E6374696F6E2862297B746869732E63';
wwv_flow_api.g_varchar2_table(407) := '6F6E7461696E65722E686173436C617373282273656C656374322D636F6E7461696E65722D61637469766522297C7C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D666F6375732229292C74';
wwv_flow_api.g_varchar2_table(408) := '6869732E6F70656E656428293F746869732E636C6F736528293A746869732E6973496E74657266616365456E61626C656428292626746869732E6F70656E28292C412862297D29292C652E6F6E28226D6F757365646F776E222C746869732E62696E6428';
wwv_flow_api.g_varchar2_table(409) := '66756E6374696F6E28297B746869732E7365617263682E666F63757328297D29292C622E6F6E2822666F637573222C746869732E62696E642866756E6374696F6E2861297B412861297D29292C746869732E666F6375737365722E6F6E2822666F637573';
wwv_flow_api.g_varchar2_table(410) := '222C746869732E62696E642866756E6374696F6E28297B746869732E636F6E7461696E65722E686173436C617373282273656C656374322D636F6E7461696E65722D61637469766522297C7C746869732E6F7074732E656C656D656E742E747269676765';
wwv_flow_api.g_varchar2_table(411) := '7228612E4576656E74282273656C656374322D666F6375732229292C746869732E636F6E7461696E65722E616464436C617373282273656C656374322D636F6E7461696E65722D61637469766522297D29292E6F6E2822626C7572222C746869732E6269';
wwv_flow_api.g_varchar2_table(412) := '6E642866756E6374696F6E28297B746869732E6F70656E656428297C7C28746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D636F6E7461696E65722D61637469766522292C746869732E6F7074732E656C656D65';
wwv_flow_api.g_varchar2_table(413) := '6E742E7472696767657228612E4576656E74282273656C656374322D626C7572222929297D29292C746869732E7365617263682E6F6E2822666F637573222C746869732E62696E642866756E6374696F6E28297B746869732E636F6E7461696E65722E68';
wwv_flow_api.g_varchar2_table(414) := '6173436C617373282273656C656374322D636F6E7461696E65722D61637469766522297C7C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D666F6375732229292C746869732E636F6E746169';
wwv_flow_api.g_varchar2_table(415) := '6E65722E616464436C617373282273656C656374322D636F6E7461696E65722D61637469766522297D29292C746869732E696E6974436F6E7461696E6572576964746828292C746869732E6F7074732E656C656D656E742E616464436C61737328227365';
wwv_flow_api.g_varchar2_table(416) := '6C656374322D6F666673637265656E22292C746869732E736574506C616365686F6C64657228297D2C636C6561723A66756E6374696F6E2862297B76617220633D746869732E73656C656374696F6E2E64617461282273656C656374322D646174612229';
wwv_flow_api.g_varchar2_table(417) := '3B69662863297B76617220643D612E4576656E74282273656C656374322D636C656172696E6722293B696628746869732E6F7074732E656C656D656E742E747269676765722864292C642E697344656661756C7450726576656E74656428292972657475';
wwv_flow_api.g_varchar2_table(418) := '726E3B76617220653D746869732E676574506C616365686F6C6465724F7074696F6E28293B746869732E6F7074732E656C656D656E742E76616C28653F652E76616C28293A2222292C746869732E73656C656374696F6E2E66696E6428222E73656C6563';
wwv_flow_api.g_varchar2_table(419) := '74322D63686F73656E22292E656D70747928292C746869732E73656C656374696F6E2E72656D6F766544617461282273656C656374322D6461746122292C746869732E736574506C616365686F6C64657228292C62213D3D2131262628746869732E6F70';
wwv_flow_api.g_varchar2_table(420) := '74732E656C656D656E742E74726967676572287B747970653A2273656C656374322D72656D6F766564222C76616C3A746869732E69642863292C63686F6963653A637D292C746869732E747269676765724368616E6765287B72656D6F7665643A637D29';
wwv_flow_api.g_varchar2_table(421) := '297D7D2C696E697453656C656374696F6E3A66756E6374696F6E28297B696628746869732E6973506C616365686F6C6465724F7074696F6E53656C6563746564282929746869732E75706461746553656C656374696F6E286E756C6C292C746869732E63';
wwv_flow_api.g_varchar2_table(422) := '6C6F736528292C746869732E736574506C616365686F6C64657228293B656C73657B76617220633D746869733B746869732E6F7074732E696E697453656C656374696F6E2E63616C6C286E756C6C2C746869732E6F7074732E656C656D656E742C66756E';
wwv_flow_api.g_varchar2_table(423) := '6374696F6E2861297B61213D3D6226266E756C6C213D3D61262628632E75706461746553656C656374696F6E2861292C632E636C6F736528292C632E736574506C616365686F6C6465722829297D297D7D2C6973506C616365686F6C6465724F7074696F';
wwv_flow_api.g_varchar2_table(424) := '6E53656C65637465643A66756E6374696F6E28297B76617220613B72657475726E20746869732E676574506C616365686F6C64657228293F28613D746869732E676574506C616365686F6C6465724F7074696F6E282929213D3D622626612E70726F7028';
wwv_flow_api.g_varchar2_table(425) := '2273656C656374656422297C7C22223D3D3D746869732E6F7074732E656C656D656E742E76616C28297C7C746869732E6F7074732E656C656D656E742E76616C28293D3D3D627C7C6E756C6C3D3D3D746869732E6F7074732E656C656D656E742E76616C';
wwv_flow_api.g_varchar2_table(426) := '28293A21317D2C707265706172654F7074733A66756E6374696F6E28297B76617220623D746869732E706172656E742E707265706172654F7074732E6170706C7928746869732C617267756D656E7473292C633D746869733B72657475726E2273656C65';
wwv_flow_api.g_varchar2_table(427) := '6374223D3D3D622E656C656D656E742E6765742830292E7461674E616D652E746F4C6F7765724361736528293F622E696E697453656C656374696F6E3D66756E6374696F6E28612C62297B76617220643D612E66696E6428226F7074696F6E22292E6669';
wwv_flow_api.g_varchar2_table(428) := '6C7465722866756E6374696F6E28297B72657475726E20746869732E73656C65637465647D293B6228632E6F7074696F6E546F44617461286429297D3A226461746122696E2062262628622E696E697453656C656374696F6E3D622E696E697453656C65';
wwv_flow_api.g_varchar2_table(429) := '6374696F6E7C7C66756E6374696F6E28632C64297B76617220653D632E76616C28292C663D6E756C6C3B622E7175657279287B6D6174636865723A66756E6374696F6E28612C632C64297B76617220673D7128652C622E6964286429293B72657475726E';
wwv_flow_api.g_varchar2_table(430) := '2067262628663D64292C677D2C63616C6C6261636B3A612E697346756E6374696F6E2864293F66756E6374696F6E28297B642866297D3A612E6E6F6F707D297D292C627D2C676574506C616365686F6C6465723A66756E6374696F6E28297B7265747572';
wwv_flow_api.g_varchar2_table(431) := '6E20746869732E73656C6563742626746869732E676574506C616365686F6C6465724F7074696F6E28293D3D3D623F623A746869732E706172656E742E676574506C616365686F6C6465722E6170706C7928746869732C617267756D656E7473297D2C73';
wwv_flow_api.g_varchar2_table(432) := '6574506C616365686F6C6465723A66756E6374696F6E28297B76617220613D746869732E676574506C616365686F6C64657228293B696628746869732E6973506C616365686F6C6465724F7074696F6E53656C65637465642829262661213D3D62297B69';
wwv_flow_api.g_varchar2_table(433) := '6628746869732E73656C6563742626746869732E676574506C616365686F6C6465724F7074696F6E28293D3D3D622972657475726E3B746869732E73656C656374696F6E2E66696E6428222E73656C656374322D63686F73656E22292E68746D6C287468';
wwv_flow_api.g_varchar2_table(434) := '69732E6F7074732E6573636170654D61726B7570286129292C746869732E73656C656374696F6E2E616464436C617373282273656C656374322D64656661756C7422292C746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C65';
wwv_flow_api.g_varchar2_table(435) := '6374322D616C6C6F77636C65617222297D7D2C706F737470726F63657373526573756C74733A66756E6374696F6E28612C622C63297B76617220643D302C653D746869733B696628746869732E66696E64486967686C6967687461626C6543686F696365';
wwv_flow_api.g_varchar2_table(436) := '7328292E65616368322866756E6374696F6E28612C62297B72657475726E207128652E696428622E64617461282273656C656374322D646174612229292C652E6F7074732E656C656D656E742E76616C2829293F28643D612C2131293A766F696420307D';
wwv_flow_api.g_varchar2_table(437) := '292C63213D3D2131262628623D3D3D21302626643E3D303F746869732E686967686C696768742864293A746869732E686967686C69676874283029292C623D3D3D2130297B76617220673D746869732E6F7074732E6D696E696D756D526573756C747346';
wwv_flow_api.g_varchar2_table(438) := '6F725365617263683B673E3D302626746869732E73686F77536561726368284C28612E726573756C7473293E3D67297D7D2C73686F775365617263683A66756E6374696F6E2862297B746869732E73686F77536561726368496E707574213D3D62262628';
wwv_flow_api.g_varchar2_table(439) := '746869732E73686F77536561726368496E7075743D622C746869732E64726F70646F776E2E66696E6428222E73656C656374322D73656172636822292E746F67676C65436C617373282273656C656374322D7365617263682D68696464656E222C216229';
wwv_flow_api.g_varchar2_table(440) := '2C746869732E64726F70646F776E2E66696E6428222E73656C656374322D73656172636822292E746F67676C65436C617373282273656C656374322D6F666673637265656E222C2162292C6128746869732E64726F70646F776E2C746869732E636F6E74';
wwv_flow_api.g_varchar2_table(441) := '61696E6572292E746F67676C65436C617373282273656C656374322D776974682D736561726368626F78222C6229297D2C6F6E53656C6563743A66756E6374696F6E28612C62297B696628746869732E7472696767657253656C656374286129297B7661';
wwv_flow_api.g_varchar2_table(442) := '7220633D746869732E6F7074732E656C656D656E742E76616C28292C643D746869732E6461746128293B746869732E6F7074732E656C656D656E742E76616C28746869732E6964286129292C746869732E75706461746553656C656374696F6E2861292C';
wwv_flow_api.g_varchar2_table(443) := '746869732E6F7074732E656C656D656E742E74726967676572287B747970653A2273656C656374322D73656C6563746564222C76616C3A746869732E69642861292C63686F6963653A617D292C746869732E6E6578745365617263685465726D3D746869';
wwv_flow_api.g_varchar2_table(444) := '732E6F7074732E6E6578745365617263685465726D28612C746869732E7365617263682E76616C2829292C746869732E636C6F736528292C622626622E6E6F466F6375737C7C746869732E666F6375737365722E666F63757328292C7128632C74686973';
wwv_flow_api.g_varchar2_table(445) := '2E6964286129297C7C746869732E747269676765724368616E6765287B61646465643A612C72656D6F7665643A647D297D7D2C75706461746553656C656374696F6E3A66756E6374696F6E2861297B76617220642C652C633D746869732E73656C656374';
wwv_flow_api.g_varchar2_table(446) := '696F6E2E66696E6428222E73656C656374322D63686F73656E22293B746869732E73656C656374696F6E2E64617461282273656C656374322D64617461222C61292C632E656D70747928292C6E756C6C213D3D61262628643D746869732E6F7074732E66';
wwv_flow_api.g_varchar2_table(447) := '6F726D617453656C656374696F6E28612C632C746869732E6F7074732E6573636170654D61726B757029292C64213D3D622626632E617070656E642864292C653D746869732E6F7074732E666F726D617453656C656374696F6E437373436C6173732861';
wwv_flow_api.g_varchar2_table(448) := '2C63292C65213D3D622626632E616464436C6173732865292C746869732E73656C656374696F6E2E72656D6F7665436C617373282273656C656374322D64656661756C7422292C746869732E6F7074732E616C6C6F77436C6561722626746869732E6765';
wwv_flow_api.g_varchar2_table(449) := '74506C616365686F6C6465722829213D3D622626746869732E636F6E7461696E65722E616464436C617373282273656C656374322D616C6C6F77636C65617222297D2C76616C3A66756E6374696F6E28297B76617220612C633D21312C643D6E756C6C2C';
wwv_flow_api.g_varchar2_table(450) := '653D746869732C663D746869732E6461746128293B696628303D3D3D617267756D656E74732E6C656E6774682972657475726E20746869732E6F7074732E656C656D656E742E76616C28293B696628613D617267756D656E74735B305D2C617267756D65';
wwv_flow_api.g_varchar2_table(451) := '6E74732E6C656E6774683E31262628633D617267756D656E74735B315D292C746869732E73656C65637429746869732E73656C6563742E76616C2861292E66696E6428226F7074696F6E22292E66696C7465722866756E6374696F6E28297B7265747572';
wwv_flow_api.g_varchar2_table(452) := '6E20746869732E73656C65637465647D292E65616368322866756E6374696F6E28612C62297B72657475726E20643D652E6F7074696F6E546F446174612862292C21317D292C746869732E75706461746553656C656374696F6E2864292C746869732E73';
wwv_flow_api.g_varchar2_table(453) := '6574506C616365686F6C64657228292C632626746869732E747269676765724368616E6765287B61646465643A642C72656D6F7665643A667D293B656C73657B6966282161262630213D3D612972657475726E20746869732E636C6561722863292C766F';
wwv_flow_api.g_varchar2_table(454) := '696420303B696628746869732E6F7074732E696E697453656C656374696F6E3D3D3D62297468726F77206E6577204572726F72282263616E6E6F742063616C6C2076616C282920696620696E697453656C656374696F6E2829206973206E6F7420646566';
wwv_flow_api.g_varchar2_table(455) := '696E656422293B746869732E6F7074732E656C656D656E742E76616C2861292C746869732E6F7074732E696E697453656C656374696F6E28746869732E6F7074732E656C656D656E742C66756E6374696F6E2861297B652E6F7074732E656C656D656E74';
wwv_flow_api.g_varchar2_table(456) := '2E76616C28613F652E69642861293A2222292C652E75706461746553656C656374696F6E2861292C652E736574506C616365686F6C64657228292C632626652E747269676765724368616E6765287B61646465643A612C72656D6F7665643A667D297D29';
wwv_flow_api.g_varchar2_table(457) := '7D7D2C636C6561725365617263683A66756E6374696F6E28297B746869732E7365617263682E76616C282222292C746869732E666F6375737365722E76616C282222297D2C646174613A66756E6374696F6E2861297B76617220632C643D21313B726574';
wwv_flow_api.g_varchar2_table(458) := '75726E20303D3D3D617267756D656E74732E6C656E6774683F28633D746869732E73656C656374696F6E2E64617461282273656C656374322D6461746122292C633D3D62262628633D6E756C6C292C63293A28617267756D656E74732E6C656E6774683E';
wwv_flow_api.g_varchar2_table(459) := '31262628643D617267756D656E74735B315D292C613F28633D746869732E6461746128292C746869732E6F7074732E656C656D656E742E76616C28613F746869732E69642861293A2222292C746869732E75706461746553656C656374696F6E2861292C';
wwv_flow_api.g_varchar2_table(460) := '642626746869732E747269676765724368616E6765287B61646465643A612C72656D6F7665643A637D29293A746869732E636C6561722864292C766F69642030297D7D292C663D4E28642C7B637265617465436F6E7461696E65723A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(461) := '28297B76617220623D6128646F63756D656E742E637265617465456C656D656E7428226469762229292E61747472287B22636C617373223A2273656C656374322D636F6E7461696E65722073656C656374322D636F6E7461696E65722D6D756C7469227D';
wwv_flow_api.g_varchar2_table(462) := '292E68746D6C285B223C756C20636C6173733D2773656C656374322D63686F69636573273E222C2220203C6C6920636C6173733D2773656C656374322D7365617263682D6669656C64273E222C22202020203C696E70757420747970653D277465787427';
wwv_flow_api.g_varchar2_table(463) := '206175746F636F6D706C6574653D276F666627206175746F636F72726563743D276F666627206175746F6361706974616C697A653D276F666627207370656C6C636865636B3D2766616C73652720636C6173733D2773656C656374322D696E707574273E';
wwv_flow_api.g_varchar2_table(464) := '222C2220203C2F6C693E222C223C2F756C3E222C223C64697620636C6173733D2773656C656374322D64726F702073656C656374322D64726F702D6D756C74692073656C656374322D646973706C61792D6E6F6E65273E222C222020203C756C20636C61';
wwv_flow_api.g_varchar2_table(465) := '73733D2773656C656374322D726573756C7473273E222C222020203C2F756C3E222C223C2F6469763E225D2E6A6F696E28222229293B72657475726E20627D2C707265706172654F7074733A66756E6374696F6E28297B76617220623D746869732E7061';
wwv_flow_api.g_varchar2_table(466) := '72656E742E707265706172654F7074732E6170706C7928746869732C617267756D656E7473292C633D746869733B72657475726E2273656C656374223D3D3D622E656C656D656E742E6765742830292E7461674E616D652E746F4C6F7765724361736528';
wwv_flow_api.g_varchar2_table(467) := '293F622E696E697453656C656374696F6E3D66756E6374696F6E28612C62297B76617220643D5B5D3B612E66696E6428226F7074696F6E22292E66696C7465722866756E6374696F6E28297B72657475726E20746869732E73656C65637465647D292E65';
wwv_flow_api.g_varchar2_table(468) := '616368322866756E6374696F6E28612C62297B642E7075736828632E6F7074696F6E546F44617461286229297D292C622864297D3A226461746122696E2062262628622E696E697453656C656374696F6E3D622E696E697453656C656374696F6E7C7C66';
wwv_flow_api.g_varchar2_table(469) := '756E6374696F6E28632C64297B76617220653D7228632E76616C28292C622E736570617261746F72292C663D5B5D3B622E7175657279287B6D6174636865723A66756E6374696F6E28632C642C67297B76617220683D612E6772657028652C66756E6374';
wwv_flow_api.g_varchar2_table(470) := '696F6E2861297B72657475726E207128612C622E6964286729297D292E6C656E6774683B72657475726E20682626662E707573682867292C687D2C63616C6C6261636B3A612E697346756E6374696F6E2864293F66756E6374696F6E28297B666F722876';
wwv_flow_api.g_varchar2_table(471) := '617220613D5B5D2C633D303B633C652E6C656E6774683B632B2B29666F722876617220673D655B635D2C683D303B683C662E6C656E6774683B682B2B297B76617220693D665B685D3B6966287128672C622E696428692929297B612E707573682869292C';
wwv_flow_api.g_varchar2_table(472) := '662E73706C69636528682C31293B627265616B7D7D642861297D3A612E6E6F6F707D297D292C627D2C73656C65637443686F6963653A66756E6374696F6E2861297B76617220623D746869732E636F6E7461696E65722E66696E6428222E73656C656374';
wwv_flow_api.g_varchar2_table(473) := '322D7365617263682D63686F6963652D666F63757322293B622E6C656E6774682626612626615B305D3D3D625B305D7C7C28622E6C656E6774682626746869732E6F7074732E656C656D656E742E74726967676572282263686F6963652D646573656C65';
wwv_flow_api.g_varchar2_table(474) := '63746564222C62292C622E72656D6F7665436C617373282273656C656374322D7365617263682D63686F6963652D666F63757322292C612626612E6C656E677468262628746869732E636C6F736528292C612E616464436C617373282273656C65637432';
wwv_flow_api.g_varchar2_table(475) := '2D7365617263682D63686F6963652D666F63757322292C746869732E6F7074732E656C656D656E742E74726967676572282263686F6963652D73656C6563746564222C612929297D2C64657374726F793A66756E6374696F6E28297B6128226C6162656C';
wwv_flow_api.g_varchar2_table(476) := '5B666F723D27222B746869732E7365617263682E617474722822696422292B22275D22292E617474722822666F72222C746869732E6F7074732E656C656D656E742E61747472282269642229292C746869732E706172656E742E64657374726F792E6170';
wwv_flow_api.g_varchar2_table(477) := '706C7928746869732C617267756D656E7473297D2C696E6974436F6E7461696E65723A66756E6374696F6E28297B76617220642C623D222E73656C656374322D63686F69636573223B746869732E736561726368436F6E7461696E65723D746869732E63';
wwv_flow_api.g_varchar2_table(478) := '6F6E7461696E65722E66696E6428222E73656C656374322D7365617263682D6669656C6422292C746869732E73656C656374696F6E3D643D746869732E636F6E7461696E65722E66696E642862293B76617220653D746869733B746869732E73656C6563';
wwv_flow_api.g_varchar2_table(479) := '74696F6E2E6F6E2822636C69636B222C222E73656C656374322D7365617263682D63686F6963653A6E6F74282E73656C656374322D6C6F636B656429222C66756E6374696F6E28297B652E7365617263685B305D2E666F63757328292C652E73656C6563';
wwv_flow_api.g_varchar2_table(480) := '7443686F6963652861287468697329297D292C746869732E7365617263682E6174747228226964222C22733269645F6175746F67656E222B672829292C6128226C6162656C5B666F723D27222B746869732E6F7074732E656C656D656E742E6174747228';
wwv_flow_api.g_varchar2_table(481) := '22696422292B22275D22292E617474722822666F72222C746869732E7365617263682E61747472282269642229292C746869732E7365617263682E6F6E2822696E707574207061737465222C746869732E62696E642866756E6374696F6E28297B746869';
wwv_flow_api.g_varchar2_table(482) := '732E6973496E74657266616365456E61626C65642829262628746869732E6F70656E656428297C7C746869732E6F70656E2829297D29292C746869732E7365617263682E617474722822746162696E646578222C746869732E656C656D656E7454616249';
wwv_flow_api.g_varchar2_table(483) := '6E646578292C746869732E6B6579646F776E733D302C746869732E7365617263682E6F6E28226B6579646F776E222C746869732E62696E642866756E6374696F6E2861297B696628746869732E6973496E74657266616365456E61626C65642829297B2B';
wwv_flow_api.g_varchar2_table(484) := '2B746869732E6B6579646F776E733B76617220623D642E66696E6428222E73656C656374322D7365617263682D63686F6963652D666F63757322292C653D622E7072657628222E73656C656374322D7365617263682D63686F6963653A6E6F74282E7365';
wwv_flow_api.g_varchar2_table(485) := '6C656374322D6C6F636B65642922292C663D622E6E65787428222E73656C656374322D7365617263682D63686F6963653A6E6F74282E73656C656374322D6C6F636B65642922292C673D7A28746869732E736561726368293B696628622E6C656E677468';
wwv_flow_api.g_varchar2_table(486) := '262628612E77686963683D3D632E4C4546547C7C612E77686963683D3D632E52494748547C7C612E77686963683D3D632E4241434B53504143457C7C612E77686963683D3D632E44454C4554457C7C612E77686963683D3D632E454E54455229297B7661';
wwv_flow_api.g_varchar2_table(487) := '7220683D623B72657475726E20612E77686963683D3D632E4C4546542626652E6C656E6774683F683D653A612E77686963683D3D632E52494748543F683D662E6C656E6774683F663A6E756C6C3A612E77686963683D3D3D632E4241434B53504143453F';
wwv_flow_api.g_varchar2_table(488) := '28746869732E756E73656C65637428622E66697273742829292C746869732E7365617263682E7769647468283130292C683D652E6C656E6774683F653A66293A612E77686963683D3D632E44454C4554453F28746869732E756E73656C65637428622E66';
wwv_flow_api.g_varchar2_table(489) := '697273742829292C746869732E7365617263682E7769647468283130292C683D662E6C656E6774683F663A6E756C6C293A612E77686963683D3D632E454E544552262628683D6E756C6C292C746869732E73656C65637443686F6963652868292C412861';
wwv_flow_api.g_varchar2_table(490) := '292C682626682E6C656E6774687C7C746869732E6F70656E28292C766F696420307D69662828612E77686963683D3D3D632E4241434B53504143452626313D3D746869732E6B6579646F776E737C7C612E77686963683D3D632E4C454654292626303D3D';
wwv_flow_api.g_varchar2_table(491) := '672E6F6666736574262621672E6C656E6774682972657475726E20746869732E73656C65637443686F69636528642E66696E6428222E73656C656374322D7365617263682D63686F6963653A6E6F74282E73656C656374322D6C6F636B65642922292E6C';
wwv_flow_api.g_varchar2_table(492) := '6173742829292C412861292C766F696420303B696628746869732E73656C65637443686F696365286E756C6C292C746869732E6F70656E656428292973776974636828612E7768696368297B6361736520632E55503A6361736520632E444F574E3A7265';
wwv_flow_api.g_varchar2_table(493) := '7475726E20746869732E6D6F7665486967686C6967687428612E77686963683D3D3D632E55503F2D313A31292C412861292C766F696420303B6361736520632E454E5445523A72657475726E20746869732E73656C656374486967686C69676874656428';
wwv_flow_api.g_varchar2_table(494) := '292C412861292C766F696420303B6361736520632E5441423A72657475726E20746869732E73656C656374486967686C696768746564287B6E6F466F6375733A21307D292C746869732E636C6F736528292C766F696420303B6361736520632E4553433A';
wwv_flow_api.g_varchar2_table(495) := '72657475726E20746869732E63616E63656C2861292C412861292C766F696420307D696628612E7768696368213D3D632E544142262621632E6973436F6E74726F6C286129262621632E697346756E6374696F6E4B65792861292626612E776869636821';
wwv_flow_api.g_varchar2_table(496) := '3D3D632E4241434B53504143452626612E7768696368213D3D632E455343297B696628612E77686963683D3D3D632E454E544552297B696628746869732E6F7074732E6F70656E4F6E456E7465723D3D3D21312972657475726E3B696628612E616C744B';
wwv_flow_api.g_varchar2_table(497) := '65797C7C612E6374726C4B65797C7C612E73686966744B65797C7C612E6D6574614B65792972657475726E7D746869732E6F70656E28292C28612E77686963683D3D3D632E504147455F55507C7C612E77686963683D3D3D632E504147455F444F574E29';
wwv_flow_api.g_varchar2_table(498) := '2626412861292C612E77686963683D3D3D632E454E5445522626412861297D7D7D29292C746869732E7365617263682E6F6E28226B65797570222C746869732E62696E642866756E6374696F6E28297B746869732E6B6579646F776E733D302C74686973';
wwv_flow_api.g_varchar2_table(499) := '2E726573697A6553656172636828297D29292C746869732E7365617263682E6F6E2822626C7572222C746869732E62696E642866756E6374696F6E2862297B746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D63';
wwv_flow_api.g_varchar2_table(500) := '6F6E7461696E65722D61637469766522292C746869732E7365617263682E72656D6F7665436C617373282273656C656374322D666F637573656422292C746869732E73656C65637443686F696365286E756C6C292C746869732E6F70656E656428297C7C';
wwv_flow_api.g_varchar2_table(501) := '746869732E636C65617253656172636828292C622E73746F70496D6D65646961746550726F7061676174696F6E28292C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D626C75722229297D29';
wwv_flow_api.g_varchar2_table(502) := '292C746869732E636F6E7461696E65722E6F6E2822636C69636B222C622C746869732E62696E642866756E6374696F6E2862297B746869732E6973496E74657266616365456E61626C656428292626286128622E746172676574292E636C6F7365737428';
wwv_flow_api.g_varchar2_table(503) := '222E73656C656374322D7365617263682D63686F69636522292E6C656E6774683E307C7C28746869732E73656C65637443686F696365286E756C6C292C746869732E636C656172506C616365686F6C64657228292C746869732E636F6E7461696E65722E';
wwv_flow_api.g_varchar2_table(504) := '686173436C617373282273656C656374322D636F6E7461696E65722D61637469766522297C7C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D666F6375732229292C746869732E6F70656E28';
wwv_flow_api.g_varchar2_table(505) := '292C746869732E666F63757353656172636828292C622E70726576656E7444656661756C74282929297D29292C746869732E636F6E7461696E65722E6F6E2822666F637573222C622C746869732E62696E642866756E6374696F6E28297B746869732E69';
wwv_flow_api.g_varchar2_table(506) := '73496E74657266616365456E61626C65642829262628746869732E636F6E7461696E65722E686173436C617373282273656C656374322D636F6E7461696E65722D61637469766522297C7C746869732E6F7074732E656C656D656E742E74726967676572';
wwv_flow_api.g_varchar2_table(507) := '28612E4576656E74282273656C656374322D666F6375732229292C746869732E636F6E7461696E65722E616464436C617373282273656C656374322D636F6E7461696E65722D61637469766522292C746869732E64726F70646F776E2E616464436C6173';
wwv_flow_api.g_varchar2_table(508) := '73282273656C656374322D64726F702D61637469766522292C746869732E636C656172506C616365686F6C6465722829297D29292C746869732E696E6974436F6E7461696E6572576964746828292C746869732E6F7074732E656C656D656E742E616464';
wwv_flow_api.g_varchar2_table(509) := '436C617373282273656C656374322D6F666673637265656E22292C746869732E636C65617253656172636828297D2C656E61626C65496E746572666163653A66756E6374696F6E28297B746869732E706172656E742E656E61626C65496E746572666163';
wwv_flow_api.g_varchar2_table(510) := '652E6170706C7928746869732C617267756D656E7473292626746869732E7365617263682E70726F70282264697361626C6564222C21746869732E6973496E74657266616365456E61626C65642829297D2C696E697453656C656374696F6E3A66756E63';
wwv_flow_api.g_varchar2_table(511) := '74696F6E28297B69662822223D3D3D746869732E6F7074732E656C656D656E742E76616C2829262622223D3D3D746869732E6F7074732E656C656D656E742E746578742829262628746869732E75706461746553656C656374696F6E285B5D292C746869';
wwv_flow_api.g_varchar2_table(512) := '732E636C6F736528292C746869732E636C6561725365617263682829292C746869732E73656C6563747C7C2222213D3D746869732E6F7074732E656C656D656E742E76616C2829297B76617220633D746869733B746869732E6F7074732E696E69745365';
wwv_flow_api.g_varchar2_table(513) := '6C656374696F6E2E63616C6C286E756C6C2C746869732E6F7074732E656C656D656E742C66756E6374696F6E2861297B61213D3D6226266E756C6C213D3D61262628632E75706461746553656C656374696F6E2861292C632E636C6F736528292C632E63';
wwv_flow_api.g_varchar2_table(514) := '6C6561725365617263682829297D297D7D2C636C6561725365617263683A66756E6374696F6E28297B76617220613D746869732E676574506C616365686F6C64657228292C633D746869732E6765744D6178536561726368576964746828293B61213D3D';
wwv_flow_api.g_varchar2_table(515) := '622626303D3D3D746869732E67657456616C28292E6C656E6774682626746869732E7365617263682E686173436C617373282273656C656374322D666F637573656422293D3D3D21313F28746869732E7365617263682E76616C2861292E616464436C61';
wwv_flow_api.g_varchar2_table(516) := '7373282273656C656374322D64656661756C7422292C746869732E7365617263682E776964746828633E303F633A746869732E636F6E7461696E65722E63737328227769647468222929293A746869732E7365617263682E76616C282222292E77696474';
wwv_flow_api.g_varchar2_table(517) := '68283130297D2C636C656172506C616365686F6C6465723A66756E6374696F6E28297B746869732E7365617263682E686173436C617373282273656C656374322D64656661756C7422292626746869732E7365617263682E76616C282222292E72656D6F';
wwv_flow_api.g_varchar2_table(518) := '7665436C617373282273656C656374322D64656661756C7422297D2C6F70656E696E673A66756E6374696F6E28297B746869732E636C656172506C616365686F6C64657228292C746869732E726573697A6553656172636828292C746869732E70617265';
wwv_flow_api.g_varchar2_table(519) := '6E742E6F70656E696E672E6170706C7928746869732C617267756D656E7473292C746869732E666F63757353656172636828292C746869732E757064617465526573756C7473282130292C746869732E7365617263682E666F63757328292C746869732E';
wwv_flow_api.g_varchar2_table(520) := '6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D6F70656E2229297D2C636C6F73653A66756E6374696F6E28297B746869732E6F70656E656428292626746869732E706172656E742E636C6F73652E617070';
wwv_flow_api.g_varchar2_table(521) := '6C7928746869732C617267756D656E7473297D2C666F6375733A66756E6374696F6E28297B746869732E636C6F736528292C746869732E7365617263682E666F63757328297D2C6973466F63757365643A66756E6374696F6E28297B72657475726E2074';
wwv_flow_api.g_varchar2_table(522) := '6869732E7365617263682E686173436C617373282273656C656374322D666F637573656422297D2C75706461746553656C656374696F6E3A66756E6374696F6E2862297B76617220633D5B5D2C643D5B5D2C653D746869733B612862292E656163682866';
wwv_flow_api.g_varchar2_table(523) := '756E6374696F6E28297B6F28652E69642874686973292C63293C30262628632E7075736828652E6964287468697329292C642E70757368287468697329297D292C623D642C746869732E73656C656374696F6E2E66696E6428222E73656C656374322D73';
wwv_flow_api.g_varchar2_table(524) := '65617263682D63686F69636522292E72656D6F766528292C612862292E656163682866756E6374696F6E28297B652E61646453656C656374656443686F6963652874686973297D292C652E706F737470726F63657373526573756C747328297D2C746F6B';
wwv_flow_api.g_varchar2_table(525) := '656E697A653A66756E6374696F6E28297B76617220613D746869732E7365617263682E76616C28293B613D746869732E6F7074732E746F6B656E697A65722E63616C6C28746869732C612C746869732E6461746128292C746869732E62696E6428746869';
wwv_flow_api.g_varchar2_table(526) := '732E6F6E53656C656374292C746869732E6F707473292C6E756C6C213D61262661213D62262628746869732E7365617263682E76616C2861292C612E6C656E6774683E302626746869732E6F70656E2829297D2C6F6E53656C6563743A66756E6374696F';
wwv_flow_api.g_varchar2_table(527) := '6E28612C62297B746869732E7472696767657253656C656374286129262628746869732E61646453656C656374656443686F6963652861292C746869732E6F7074732E656C656D656E742E74726967676572287B747970653A2273656C6563746564222C';
wwv_flow_api.g_varchar2_table(528) := '76616C3A746869732E69642861292C63686F6963653A617D292C28746869732E73656C6563747C7C21746869732E6F7074732E636C6F73654F6E53656C656374292626746869732E706F737470726F63657373526573756C747328612C21312C74686973';
wwv_flow_api.g_varchar2_table(529) := '2E6F7074732E636C6F73654F6E53656C6563743D3D3D2130292C746869732E6F7074732E636C6F73654F6E53656C6563743F28746869732E636C6F736528292C746869732E7365617263682E776964746828313029293A746869732E636F756E7453656C';
wwv_flow_api.g_varchar2_table(530) := '65637461626C65526573756C747328293E303F28746869732E7365617263682E7769647468283130292C746869732E726573697A6553656172636828292C746869732E6765744D6178696D756D53656C656374696F6E53697A6528293E30262674686973';
wwv_flow_api.g_varchar2_table(531) := '2E76616C28292E6C656E6774683E3D746869732E6765744D6178696D756D53656C656374696F6E53697A6528292626746869732E757064617465526573756C7473282130292C746869732E706F736974696F6E44726F70646F776E2829293A2874686973';
wwv_flow_api.g_varchar2_table(532) := '2E636C6F736528292C746869732E7365617263682E776964746828313029292C746869732E747269676765724368616E6765287B61646465643A617D292C622626622E6E6F466F6375737C7C746869732E666F6375735365617263682829297D2C63616E';
wwv_flow_api.g_varchar2_table(533) := '63656C3A66756E6374696F6E28297B746869732E636C6F736528292C746869732E666F63757353656172636828297D2C61646453656C656374656443686F6963653A66756E6374696F6E2863297B766172206A2C6B2C643D21632E6C6F636B65642C653D';
wwv_flow_api.g_varchar2_table(534) := '6128223C6C6920636C6173733D2773656C656374322D7365617263682D63686F696365273E202020203C6469763E3C2F6469763E202020203C6120687265663D272327206F6E636C69636B3D2772657475726E2066616C73653B2720636C6173733D2773';
wwv_flow_api.g_varchar2_table(535) := '656C656374322D7365617263682D63686F6963652D636C6F73652720746162696E6465783D272D31273E3C2F613E3C2F6C693E22292C663D6128223C6C6920636C6173733D2773656C656374322D7365617263682D63686F6963652073656C656374322D';
wwv_flow_api.g_varchar2_table(536) := '6C6F636B6564273E3C6469763E3C2F6469763E3C2F6C693E22292C673D643F653A662C683D746869732E69642863292C693D746869732E67657456616C28293B6A3D746869732E6F7074732E666F726D617453656C656374696F6E28632C672E66696E64';
wwv_flow_api.g_varchar2_table(537) := '282264697622292C746869732E6F7074732E6573636170654D61726B7570292C6A213D622626672E66696E64282264697622292E7265706C6163655769746828223C6469763E222B6A2B223C2F6469763E22292C6B3D746869732E6F7074732E666F726D';
wwv_flow_api.g_varchar2_table(538) := '617453656C656374696F6E437373436C61737328632C672E66696E6428226469762229292C6B213D622626672E616464436C617373286B292C642626672E66696E6428222E73656C656374322D7365617263682D63686F6963652D636C6F736522292E6F';
wwv_flow_api.g_varchar2_table(539) := '6E28226D6F757365646F776E222C41292E6F6E2822636C69636B2064626C636C69636B222C746869732E62696E642866756E6374696F6E2862297B746869732E6973496E74657266616365456E61626C656428292626286128622E746172676574292E63';
wwv_flow_api.g_varchar2_table(540) := '6C6F7365737428222E73656C656374322D7365617263682D63686F69636522292E666164654F7574282266617374222C746869732E62696E642866756E6374696F6E28297B746869732E756E73656C656374286128622E74617267657429292C74686973';
wwv_flow_api.g_varchar2_table(541) := '2E73656C656374696F6E2E66696E6428222E73656C656374322D7365617263682D63686F6963652D666F63757322292E72656D6F7665436C617373282273656C656374322D7365617263682D63686F6963652D666F63757322292C746869732E636C6F73';
wwv_flow_api.g_varchar2_table(542) := '6528292C746869732E666F63757353656172636828297D29292E6465717565756528292C41286229297D29292E6F6E2822666F637573222C746869732E62696E642866756E6374696F6E28297B746869732E6973496E74657266616365456E61626C6564';
wwv_flow_api.g_varchar2_table(543) := '2829262628746869732E636F6E7461696E65722E616464436C617373282273656C656374322D636F6E7461696E65722D61637469766522292C746869732E64726F70646F776E2E616464436C617373282273656C656374322D64726F702D616374697665';
wwv_flow_api.g_varchar2_table(544) := '2229297D29292C672E64617461282273656C656374322D64617461222C63292C672E696E736572744265666F726528746869732E736561726368436F6E7461696E6572292C692E707573682868292C746869732E73657456616C2869297D2C756E73656C';
wwv_flow_api.g_varchar2_table(545) := '6563743A66756E6374696F6E2862297B76617220642C652C633D746869732E67657456616C28293B696628623D622E636C6F7365737428222E73656C656374322D7365617263682D63686F69636522292C303D3D3D622E6C656E677468297468726F7722';
wwv_flow_api.g_varchar2_table(546) := '496E76616C696420617267756D656E743A20222B622B222E204D757374206265202E73656C656374322D7365617263682D63686F696365223B696628643D622E64617461282273656C656374322D646174612229297B666F72283B28653D6F2874686973';
wwv_flow_api.g_varchar2_table(547) := '2E69642864292C6329293E3D303B29632E73706C69636528652C31292C746869732E73657456616C2863292C746869732E73656C6563742626746869732E706F737470726F63657373526573756C747328293B76617220663D612E4576656E7428227365';
wwv_flow_api.g_varchar2_table(548) := '6C656374322D72656D6F76696E6722293B662E76616C3D746869732E69642864292C662E63686F6963653D642C746869732E6F7074732E656C656D656E742E747269676765722866292C662E697344656661756C7450726576656E74656428297C7C2862';
wwv_flow_api.g_varchar2_table(549) := '2E72656D6F766528292C746869732E6F7074732E656C656D656E742E74726967676572287B747970653A2273656C656374322D72656D6F766564222C76616C3A746869732E69642864292C63686F6963653A647D292C746869732E747269676765724368';
wwv_flow_api.g_varchar2_table(550) := '616E6765287B72656D6F7665643A647D29297D7D2C706F737470726F63657373526573756C74733A66756E6374696F6E28612C622C63297B76617220643D746869732E67657456616C28292C653D746869732E726573756C74732E66696E6428222E7365';
wwv_flow_api.g_varchar2_table(551) := '6C656374322D726573756C7422292C663D746869732E726573756C74732E66696E6428222E73656C656374322D726573756C742D776974682D6368696C6472656E22292C673D746869733B652E65616368322866756E6374696F6E28612C62297B766172';
wwv_flow_api.g_varchar2_table(552) := '20633D672E696428622E64617461282273656C656374322D646174612229293B6F28632C64293E3D30262628622E616464436C617373282273656C656374322D73656C656374656422292C622E66696E6428222E73656C656374322D726573756C742D73';
wwv_flow_api.g_varchar2_table(553) := '656C65637461626C6522292E616464436C617373282273656C656374322D73656C65637465642229297D292C662E65616368322866756E6374696F6E28612C62297B622E697328222E73656C656374322D726573756C742D73656C65637461626C652229';
wwv_flow_api.g_varchar2_table(554) := '7C7C30213D3D622E66696E6428222E73656C656374322D726573756C742D73656C65637461626C653A6E6F74282E73656C656374322D73656C65637465642922292E6C656E6774687C7C622E616464436C617373282273656C656374322D73656C656374';
wwv_flow_api.g_varchar2_table(555) := '656422297D292C2D313D3D746869732E686967686C696768742829262663213D3D21312626672E686967686C696768742830292C21746869732E6F7074732E63726561746553656172636843686F696365262621652E66696C74657228222E73656C6563';
wwv_flow_api.g_varchar2_table(556) := '74322D726573756C743A6E6F74282E73656C656374322D73656C65637465642922292E6C656E6774683E3026262821617C7C61262621612E6D6F72652626303D3D3D746869732E726573756C74732E66696E6428222E73656C656374322D6E6F2D726573';
wwv_flow_api.g_varchar2_table(557) := '756C747322292E6C656E6774682926264A28672E6F7074732E666F726D61744E6F4D6174636865732C22666F726D61744E6F4D61746368657322292626746869732E726573756C74732E617070656E6428223C6C6920636C6173733D2773656C65637432';
wwv_flow_api.g_varchar2_table(558) := '2D6E6F2D726573756C7473273E222B672E6F7074732E666F726D61744E6F4D61746368657328672E7365617263682E76616C2829292B223C2F6C693E22297D2C6765744D617853656172636857696474683A66756E6374696F6E28297B72657475726E20';
wwv_flow_api.g_varchar2_table(559) := '746869732E73656C656374696F6E2E776964746828292D7328746869732E736561726368297D2C726573697A655365617263683A66756E6374696F6E28297B76617220612C622C632C642C652C663D7328746869732E736561726368293B613D43287468';
wwv_flow_api.g_varchar2_table(560) := '69732E736561726368292B31302C623D746869732E7365617263682E6F666673657428292E6C6566742C633D746869732E73656C656374696F6E2E776964746828292C643D746869732E73656C656374696F6E2E6F666673657428292E6C6566742C653D';
wwv_flow_api.g_varchar2_table(561) := '632D28622D64292D662C613E65262628653D632D66292C34303E65262628653D632D66292C303E3D65262628653D61292C746869732E7365617263682E7769647468284D6174682E666C6F6F72286529297D2C67657456616C3A66756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(562) := '7B76617220613B72657475726E20746869732E73656C6563743F28613D746869732E73656C6563742E76616C28292C6E756C6C3D3D3D613F5B5D3A61293A28613D746869732E6F7074732E656C656D656E742E76616C28292C7228612C746869732E6F70';
wwv_flow_api.g_varchar2_table(563) := '74732E736570617261746F7229297D2C73657456616C3A66756E6374696F6E2862297B76617220633B746869732E73656C6563743F746869732E73656C6563742E76616C2862293A28633D5B5D2C612862292E656163682866756E6374696F6E28297B6F';
wwv_flow_api.g_varchar2_table(564) := '28746869732C63293C302626632E707573682874686973297D292C746869732E6F7074732E656C656D656E742E76616C28303D3D3D632E6C656E6774683F22223A632E6A6F696E28746869732E6F7074732E736570617261746F722929297D2C6275696C';
wwv_flow_api.g_varchar2_table(565) := '644368616E676544657461696C733A66756E6374696F6E28612C62297B666F722876617220623D622E736C6963652830292C613D612E736C6963652830292C633D303B633C622E6C656E6774683B632B2B29666F722876617220643D303B643C612E6C65';
wwv_flow_api.g_varchar2_table(566) := '6E6774683B642B2B297128746869732E6F7074732E696428625B635D292C746869732E6F7074732E696428615B645D2929262628622E73706C69636528632C31292C633E302626632D2D2C612E73706C69636528642C31292C642D2D293B72657475726E';
wwv_flow_api.g_varchar2_table(567) := '7B61646465643A622C72656D6F7665643A617D7D2C76616C3A66756E6374696F6E28632C64297B76617220652C663D746869733B696628303D3D3D617267756D656E74732E6C656E6774682972657475726E20746869732E67657456616C28293B696628';
wwv_flow_api.g_varchar2_table(568) := '653D746869732E6461746128292C652E6C656E6774687C7C28653D5B5D292C2163262630213D3D632972657475726E20746869732E6F7074732E656C656D656E742E76616C282222292C746869732E75706461746553656C656374696F6E285B5D292C74';
wwv_flow_api.g_varchar2_table(569) := '6869732E636C65617253656172636828292C642626746869732E747269676765724368616E6765287B61646465643A746869732E6461746128292C72656D6F7665643A657D292C766F696420303B696628746869732E73657456616C2863292C74686973';
wwv_flow_api.g_varchar2_table(570) := '2E73656C65637429746869732E6F7074732E696E697453656C656374696F6E28746869732E73656C6563742C746869732E62696E6428746869732E75706461746553656C656374696F6E29292C642626746869732E747269676765724368616E67652874';
wwv_flow_api.g_varchar2_table(571) := '6869732E6275696C644368616E676544657461696C7328652C746869732E64617461282929293B656C73657B696628746869732E6F7074732E696E697453656C656374696F6E3D3D3D62297468726F77206E6577204572726F72282276616C2829206361';
wwv_flow_api.g_varchar2_table(572) := '6E6E6F742062652063616C6C656420696620696E697453656C656374696F6E2829206973206E6F7420646566696E656422293B746869732E6F7074732E696E697453656C656374696F6E28746869732E6F7074732E656C656D656E742C66756E6374696F';
wwv_flow_api.g_varchar2_table(573) := '6E2862297B76617220633D612E6D617028622C662E6964293B662E73657456616C2863292C662E75706461746553656C656374696F6E2862292C662E636C65617253656172636828292C642626662E747269676765724368616E676528662E6275696C64';
wwv_flow_api.g_varchar2_table(574) := '4368616E676544657461696C7328652C662E64617461282929297D297D746869732E636C65617253656172636828297D2C6F6E536F727453746172743A66756E6374696F6E28297B696628746869732E73656C656374297468726F77206E657720457272';
wwv_flow_api.g_varchar2_table(575) := '6F722822536F7274696E67206F6620656C656D656E7473206973206E6F7420737570706F72746564207768656E20617474616368656420746F203C73656C6563743E2E2041747461636820746F203C696E70757420747970653D2768696464656E272F3E';
wwv_flow_api.g_varchar2_table(576) := '20696E73746561642E22293B746869732E7365617263682E77696474682830292C746869732E736561726368436F6E7461696E65722E6869646528297D2C6F6E536F7274456E643A66756E6374696F6E28297B76617220623D5B5D2C633D746869733B74';
wwv_flow_api.g_varchar2_table(577) := '6869732E736561726368436F6E7461696E65722E73686F7728292C746869732E736561726368436F6E7461696E65722E617070656E64546F28746869732E736561726368436F6E7461696E65722E706172656E742829292C746869732E726573697A6553';
wwv_flow_api.g_varchar2_table(578) := '656172636828292C746869732E73656C656374696F6E2E66696E6428222E73656C656374322D7365617263682D63686F69636522292E656163682866756E6374696F6E28297B622E7075736828632E6F7074732E696428612874686973292E6461746128';
wwv_flow_api.g_varchar2_table(579) := '2273656C656374322D64617461222929297D292C746869732E73657456616C2862292C746869732E747269676765724368616E676528297D2C646174613A66756E6374696F6E28622C63297B76617220652C662C643D746869733B72657475726E20303D';
wwv_flow_api.g_varchar2_table(580) := '3D3D617267756D656E74732E6C656E6774683F746869732E73656C656374696F6E2E66696E6428222E73656C656374322D7365617263682D63686F69636522292E6D61702866756E6374696F6E28297B72657475726E20612874686973292E6461746128';
wwv_flow_api.g_varchar2_table(581) := '2273656C656374322D6461746122297D292E67657428293A28663D746869732E6461746128292C627C7C28623D5B5D292C653D612E6D617028622C66756E6374696F6E2861297B72657475726E20642E6F7074732E69642861297D292C746869732E7365';
wwv_flow_api.g_varchar2_table(582) := '7456616C2865292C746869732E75706461746553656C656374696F6E2862292C746869732E636C65617253656172636828292C632626746869732E747269676765724368616E676528746869732E6275696C644368616E676544657461696C7328662C74';
wwv_flow_api.g_varchar2_table(583) := '6869732E64617461282929292C766F69642030297D7D292C612E666E2E73656C656374323D66756E6374696F6E28297B76617220642C672C682C692C6A2C633D41727261792E70726F746F747970652E736C6963652E63616C6C28617267756D656E7473';
wwv_flow_api.g_varchar2_table(584) := '2C30292C6B3D5B2276616C222C2264657374726F79222C226F70656E6564222C226F70656E222C22636C6F7365222C22666F637573222C226973466F6375736564222C22636F6E7461696E6572222C2264726F70646F776E222C226F6E536F7274537461';
wwv_flow_api.g_varchar2_table(585) := '7274222C226F6E536F7274456E64222C22656E61626C65222C2264697361626C65222C22726561646F6E6C79222C22706F736974696F6E44726F70646F776E222C2264617461222C22736561726368225D2C6C3D5B226F70656E6564222C226973466F63';
wwv_flow_api.g_varchar2_table(586) := '75736564222C22636F6E7461696E6572222C2264726F70646F776E225D2C6D3D5B2276616C222C2264617461225D2C6E3D7B7365617263683A2265787465726E616C536561726368227D3B72657475726E20746869732E656163682866756E6374696F6E';
wwv_flow_api.g_varchar2_table(587) := '28297B696628303D3D3D632E6C656E6774687C7C226F626A656374223D3D747970656F6620635B305D29643D303D3D3D632E6C656E6774683F7B7D3A612E657874656E64287B7D2C635B305D292C642E656C656D656E743D612874686973292C2273656C';
wwv_flow_api.g_varchar2_table(588) := '656374223D3D3D642E656C656D656E742E6765742830292E7461674E616D652E746F4C6F7765724361736528293F6A3D642E656C656D656E742E70726F7028226D756C7469706C6522293A286A3D642E6D756C7469706C657C7C21312C22746167732269';
wwv_flow_api.g_varchar2_table(589) := '6E2064262628642E6D756C7469706C653D6A3D213029292C673D6A3F6E657720663A6E657720652C672E696E69742864293B656C73657B69662822737472696E6722213D747970656F6620635B305D297468726F7722496E76616C696420617267756D65';
wwv_flow_api.g_varchar2_table(590) := '6E747320746F2073656C6563743220706C7567696E3A20222B633B6966286F28635B305D2C6B293C30297468726F7722556E6B6E6F776E206D6574686F643A20222B635B305D3B696628693D622C673D612874686973292E64617461282273656C656374';
wwv_flow_api.g_varchar2_table(591) := '3222292C673D3D3D622972657475726E3B696628683D635B305D2C22636F6E7461696E6572223D3D3D683F693D672E636F6E7461696E65723A2264726F70646F776E223D3D3D683F693D672E64726F70646F776E3A286E5B685D262628683D6E5B685D29';
wwv_flow_api.g_varchar2_table(592) := '2C693D675B685D2E6170706C7928672C632E736C69636528312929292C6F28635B305D2C6C293E3D307C7C6F28635B305D2C6D292626313D3D632E6C656E6774682972657475726E21317D7D292C693D3D3D623F746869733A697D2C612E666E2E73656C';
wwv_flow_api.g_varchar2_table(593) := '656374322E64656661756C74733D7B77696474683A22636F7079222C6C6F61644D6F726550616464696E673A302C636C6F73654F6E53656C6563743A21302C6F70656E4F6E456E7465723A21302C636F6E7461696E65724373733A7B7D2C64726F70646F';
wwv_flow_api.g_varchar2_table(594) := '776E4373733A7B7D2C636F6E7461696E6572437373436C6173733A22222C64726F70646F776E437373436C6173733A22222C666F726D6174526573756C743A66756E6374696F6E28612C622C632C64297B76617220653D5B5D3B72657475726E20452861';
wwv_flow_api.g_varchar2_table(595) := '2E746578742C632E7465726D2C652C64292C652E6A6F696E282222297D2C666F726D617453656C656374696F6E3A66756E6374696F6E28612C632C64297B72657475726E20613F6428612E74657874293A627D2C736F7274526573756C74733A66756E63';
wwv_flow_api.g_varchar2_table(596) := '74696F6E2861297B72657475726E20617D2C666F726D6174526573756C74437373436C6173733A66756E6374696F6E28297B72657475726E20627D2C666F726D617453656C656374696F6E437373436C6173733A66756E6374696F6E28297B7265747572';
wwv_flow_api.g_varchar2_table(597) := '6E20627D2C666F726D61744E6F4D6174636865733A66756E6374696F6E28297B72657475726E224E6F206D61746368657320666F756E64227D2C666F726D6174496E707574546F6F53686F72743A66756E6374696F6E28612C62297B76617220633D622D';
wwv_flow_api.g_varchar2_table(598) := '612E6C656E6774683B72657475726E22506C6561736520656E74657220222B632B22206D6F726520636861726163746572222B28313D3D633F22223A227322297D2C666F726D6174496E707574546F6F4C6F6E673A66756E6374696F6E28612C62297B76';
wwv_flow_api.g_varchar2_table(599) := '617220633D612E6C656E6774682D623B72657475726E22506C656173652064656C65746520222B632B2220636861726163746572222B28313D3D633F22223A227322297D2C666F726D617453656C656374696F6E546F6F4269673A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(600) := '61297B72657475726E22596F752063616E206F6E6C792073656C65637420222B612B22206974656D222B28313D3D613F22223A227322297D2C666F726D61744C6F61644D6F72653A66756E6374696F6E28297B72657475726E224C6F6164696E67206D6F';
wwv_flow_api.g_varchar2_table(601) := '726520726573756C74732E2E2E227D2C666F726D6174536561726368696E673A66756E6374696F6E28297B72657475726E22536561726368696E672E2E2E227D2C6D696E696D756D526573756C7473466F725365617263683A302C6D696E696D756D496E';
wwv_flow_api.g_varchar2_table(602) := '7075744C656E6774683A302C6D6178696D756D496E7075744C656E6774683A6E756C6C2C6D6178696D756D53656C656374696F6E53697A653A302C69643A66756E6374696F6E2861297B72657475726E20612E69647D2C6D6174636865723A66756E6374';
wwv_flow_api.g_varchar2_table(603) := '696F6E28612C62297B72657475726E206E2822222B62292E746F55707065724361736528292E696E6465784F66286E2822222B61292E746F5570706572436173652829293E3D307D2C736570617261746F723A222C222C746F6B656E536570617261746F';
wwv_flow_api.g_varchar2_table(604) := '72733A5B5D2C746F6B656E697A65723A4D2C6573636170654D61726B75703A462C626C75724F6E4368616E67653A21312C73656C6563744F6E426C75723A21312C6164617074436F6E7461696E6572437373436C6173733A66756E6374696F6E2861297B';
wwv_flow_api.g_varchar2_table(605) := '72657475726E20617D2C616461707444726F70646F776E437373436C6173733A66756E6374696F6E28297B72657475726E206E756C6C7D2C6E6578745365617263685465726D3A66756E6374696F6E28297B72657475726E20627D7D2C612E666E2E7365';
wwv_flow_api.g_varchar2_table(606) := '6C656374322E616A617844656661756C74733D7B7472616E73706F72743A612E616A61782C706172616D733A7B747970653A22474554222C63616368653A21312C64617461547970653A226A736F6E227D7D2C77696E646F772E53656C656374323D7B71';
wwv_flow_api.g_varchar2_table(607) := '756572793A7B616A61783A472C6C6F63616C3A482C746167733A497D2C7574696C3A7B6465626F756E63653A762C6D61726B4D617463683A452C6573636170654D61726B75703A462C7374726970446961637269746963733A6E7D2C22636C617373223A';
wwv_flow_api.g_varchar2_table(608) := '7B226162737472616374223A642C73696E676C653A652C6D756C74693A667D7D7D7D286A5175657279293B';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 74255762402113134 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2.min.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D494844520000003C000000280806000000A2BB99FF0000022C4944415478DAEDD9CF4B14611CC7F1B5084A8C85D62E625D2A28C9880E1176A964D60DA23C14FDA01F5004FD038621520771B754E8D0A148042308BC471411';
wwv_flow_api.g_varchar2_table(2) := '79ED52D8AFA58B9485814874304C983EBD85EFE139B82C6D29DBD779E07598D9857DDE3BCFCC0EB32949CB4A12BC2C83FFC7512814EEE358B01DE11E56B80B26EA12844F68C24614210C7B0C6EC67B089398802CFAA0D7255D8FD7901947638AE135780B';
wwv_flow_api.g_varchar2_table(3) := '3E40E633B6BB0C26AC0593C1321E0B96F799250FE643D3C82C62F0450813D88075C1393D543698379DC4299C089C45BAC2090DE3F1221FE50BD8116C6FC6795BD26583AF4308BDC39A0A26B20BBF2044A9A51FE5836DA2239099C3CE0ABFF951C8BCC5AA';
wwv_flow_api.g_varchar2_table(4) := '6A0DDE8419080315C67640080D5465B04DB81FDFFFE2DCBD863BB81DE8FBD747399BCDD66208A7837D873188CC9F04AFC7BE54950FA23A20C468430B66203C74F73B4C54039E4198C50F08CFD1ECF24E2B8AA21AE25E40A688D56E6F2D89DB8F2F909946';
wwv_flow_api.g_varchar2_table(5) := 'CE65306147F03358C68F82E5DDED31F8288497A8C34A8C42E8F1BAA45BD1106C6770C0D9922E3F92E02438094E82ABE191CE5A34CECBE7F335AE8389ECC214645EA1DD65306177218CE3326E41E6B8AB608272109E221DECDF8D6F9846BDA7E041C4D8BA';
wwv_flow_api.g_varchar2_table(6) := 'C06B5720E43C058F60D62E52A58E7EBBA7E07E08874A3C068EB1D75370138429B4D9BE3A7442F8E8F12A7D0E32457C854C8C1B1E7F87F7E001DE600C57D157EA31B0E77F0F7B217313B5AE832DBA1B73105ADD075BF413C4D8B650F06F7CE77D1E7108BF';
wwv_flow_api.g_varchar2_table(7) := 'D90000000049454E44AE426082';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 74264260676113878 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2.png'
 ,p_mime_type => 'image/png'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E666F726D2D636F6E74726F6C202E73656C656374322D63686F696365207B0A20202020626F726465723A20303B0A20202020626F726465722D7261646975733A203270783B0A7D0A0A2E666F726D2D636F6E74726F6C202E73656C656374322D63686F';
wwv_flow_api.g_varchar2_table(2) := '696365202E73656C656374322D6172726F77207B0A20202020626F726465722D7261646975733A2030203270782032707820303B2020200A7D0A0A2E666F726D2D636F6E74726F6C2E73656C656374322D636F6E7461696E6572207B0A20202020686569';
wwv_flow_api.g_varchar2_table(3) := '6768743A206175746F2021696D706F7274616E743B0A2020202070616464696E673A203070783B0A7D0A0A2E666F726D2D636F6E74726F6C2E73656C656374322D636F6E7461696E65722E73656C656374322D64726F70646F776E2D6F70656E207B0A20';
wwv_flow_api.g_varchar2_table(4) := '202020626F726465722D636F6C6F723A20233538393746423B0A20202020626F726465722D7261646975733A2033707820337078203020303B0A7D0A0A2E666F726D2D636F6E74726F6C202E73656C656374322D636F6E7461696E65722E73656C656374';
wwv_flow_api.g_varchar2_table(5) := '322D64726F70646F776E2D6F70656E202E73656C656374322D63686F69636573207B0A20202020626F726465722D7261646975733A2033707820337078203020303B0A7D0A0A2E666F726D2D636F6E74726F6C2E73656C656374322D636F6E7461696E65';
wwv_flow_api.g_varchar2_table(6) := '72202E73656C656374322D63686F69636573207B0A20202020626F726465723A20302021696D706F7274616E743B0A20202020626F726465722D7261646975733A203370783B0A7D0A0A2E636F6E74726F6C2D67726F75702E7761726E696E67202E7365';
wwv_flow_api.g_varchar2_table(7) := '6C656374322D636F6E7461696E6572202E73656C656374322D63686F6963652C0A2E636F6E74726F6C2D67726F75702E7761726E696E67202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365732C0A2E636F6E74726F';
wwv_flow_api.g_varchar2_table(8) := '6C2D67726F75702E7761726E696E67202E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F6963652C0A2E636F6E74726F6C2D67726F75702E7761726E696E67202E73656C656374322D636F6E7461696E6572';
wwv_flow_api.g_varchar2_table(9) := '2D616374697665202E73656C656374322D63686F696365732C0A2E636F6E74726F6C2D67726F75702E7761726E696E67202E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D';
wwv_flow_api.g_varchar2_table(10) := '63686F6963652C0A2E636F6E74726F6C2D67726F75702E7761726E696E67202E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F696365732C0A2E636F6E74726F6C2D';
wwv_flow_api.g_varchar2_table(11) := '67726F75702E7761726E696E67202E73656C656374322D636F6E7461696E65722D6D756C74692E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F69636573207B0A20202020626F726465723A203170782073';
wwv_flow_api.g_varchar2_table(12) := '6F6C696420234330393835332021696D706F7274616E743B0A7D0A0A2E636F6E74726F6C2D67726F75702E7761726E696E67202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F69636520646976207B0A20202020626F7264';
wwv_flow_api.g_varchar2_table(13) := '65722D6C6566743A2031707820736F6C696420234330393835332021696D706F7274616E743B0A202020206261636B67726F756E643A20234643463845332021696D706F7274616E743B0A7D0A0A2E636F6E74726F6C2D67726F75702E6572726F72202E';
wwv_flow_api.g_varchar2_table(14) := '73656C656374322D636F6E7461696E6572202E73656C656374322D63686F6963652C0A2E636F6E74726F6C2D67726F75702E6572726F72202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365732C0A2E636F6E74726F';
wwv_flow_api.g_varchar2_table(15) := '6C2D67726F75702E6572726F72202E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F6963652C0A2E636F6E74726F6C2D67726F75702E6572726F72202E73656C656374322D636F6E7461696E65722D616374';
wwv_flow_api.g_varchar2_table(16) := '697665202E73656C656374322D63686F696365732C0A2E636F6E74726F6C2D67726F75702E6572726F72202E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F696365';
wwv_flow_api.g_varchar2_table(17) := '2C0A2E636F6E74726F6C2D67726F75702E6572726F72202E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F696365732C0A2E636F6E74726F6C2D67726F75702E6572';
wwv_flow_api.g_varchar2_table(18) := '726F72202E73656C656374322D636F6E7461696E65722D6D756C74692E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F69636573207B0A20202020626F726465723A2031707820736F6C6964202342393441';
wwv_flow_api.g_varchar2_table(19) := '34382021696D706F7274616E743B0A7D0A0A2E636F6E74726F6C2D67726F75702E6572726F72202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F69636520646976207B0A20202020626F726465722D6C6566743A20317078';
wwv_flow_api.g_varchar2_table(20) := '20736F6C696420234239344134382021696D706F7274616E743B0A202020206261636B67726F756E643A20234632444544452021696D706F7274616E743B0A7D0A0A2E636F6E74726F6C2D67726F75702E696E666F202E73656C656374322D636F6E7461';
wwv_flow_api.g_varchar2_table(21) := '696E6572202E73656C656374322D63686F6963652C0A2E636F6E74726F6C2D67726F75702E696E666F202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365732C0A2E636F6E74726F6C2D67726F75702E696E666F202E';
wwv_flow_api.g_varchar2_table(22) := '73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F6963652C0A2E636F6E74726F6C2D67726F75702E696E666F202E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F';
wwv_flow_api.g_varchar2_table(23) := '696365732C0A2E636F6E74726F6C2D67726F75702E696E666F202E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F6963652C0A2E636F6E74726F6C2D67726F75702E';
wwv_flow_api.g_varchar2_table(24) := '696E666F202E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F696365732C0A2E636F6E74726F6C2D67726F75702E696E666F202E73656C656374322D636F6E746169';
wwv_flow_api.g_varchar2_table(25) := '6E65722D6D756C74692E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F69636573207B0A20202020626F726465723A2031707820736F6C696420233341383741442021696D706F7274616E743B0A7D0A0A2E';
wwv_flow_api.g_varchar2_table(26) := '636F6E74726F6C2D67726F75702E696E666F202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F69636520646976207B0A20202020626F726465722D6C6566743A2031707820736F6C696420233341383741442021696D706F';
wwv_flow_api.g_varchar2_table(27) := '7274616E743B0A202020206261636B67726F756E643A20234439454446372021696D706F7274616E743B0A7D0A0A2E636F6E74726F6C2D67726F75702E73756363657373202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F';
wwv_flow_api.g_varchar2_table(28) := '6963652C0A2E636F6E74726F6C2D67726F75702E73756363657373202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365732C0A2E636F6E74726F6C2D67726F75702E73756363657373202E73656C656374322D636F6E';
wwv_flow_api.g_varchar2_table(29) := '7461696E65722D616374697665202E73656C656374322D63686F6963652C0A2E636F6E74726F6C2D67726F75702E73756363657373202E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F696365732C0A2E63';
wwv_flow_api.g_varchar2_table(30) := '6F6E74726F6C2D67726F75702E73756363657373202E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F6963652C0A2E636F6E74726F6C2D67726F75702E7375636365';
wwv_flow_api.g_varchar2_table(31) := '7373202E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F696365732C0A2E636F6E74726F6C2D67726F75702E73756363657373202E73656C656374322D636F6E7461';
wwv_flow_api.g_varchar2_table(32) := '696E65722D6D756C74692E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F69636573207B0A20202020626F726465723A2031707820736F6C696420233436383834372021696D706F7274616E743B0A7D0A0A';
wwv_flow_api.g_varchar2_table(33) := '2E636F6E74726F6C2D67726F75702E73756363657373202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F69636520646976207B0A20202020626F726465722D6C6566743A2031707820736F6C696420233436383834372021';
wwv_flow_api.g_varchar2_table(34) := '696D706F7274616E743B0A202020206261636B67726F756E643A20234446463044382021696D706F7274616E743B0A7D0A';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 74272754207116887 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2-bootstrap.css'
 ,p_mime_type => 'text/css'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '47494638396110001000F40000FFFFFF000000F0F0F08A8A8AE0E0E04646467A7A7A000000585858242424ACACACBEBEBE1414149C9C9C040404363636686868000000000000000000000000000000000000000000000000000000000000000000000000';
wwv_flow_api.g_varchar2_table(2) := '00000000000000000021FF0B4E45545343415045322E30030100000021FE1A43726561746564207769746820616A61786C6F61642E696E666F0021F904090A0000002C0000000010001000000577202002020921E5A802444208C74190AB481C89E0C8C2';
wwv_flow_api.g_varchar2_table(3) := 'AC12B3C161B003A64482C210E640205EB61441E958F89050A440F1B822558382B3512309CEE142815C3B9FCD0BC331AA120C18056FCF3A32241A760340040A247C2C33040F0B0A0D04825F23020806000D6404803504063397220B73350B0B65210021F9';
wwv_flow_api.g_varchar2_table(4) := '04090A0000002C000000001000100000057620200202694065398E444108C941108CB28AC4F1C00E112FAB1960706824188D4361254020058CC7E97048A908089D10B078BD460281C275538914108301782385050D0404C22EBFDD84865914668E11044C';
wwv_flow_api.g_varchar2_table(5) := '025F2203050A700A33428357810410040B885D7C4C060D5C36927B7C7A9A389D375B37210021F904090A0000002C000000001000100000057820200202D90C65398E0444084522088FB28A8483C032722CAB17A07150C4148702800014186AB4C260F038';
wwv_flow_api.g_varchar2_table(6) := '100607EB12C240100838621648122C202AD1E230182DA60DF06D465718EEE439BD4C50A445332B020A1028820242220D060B668D7B882A42575F2F897F020D405F2489827E4B728137417237210021F904090A0000002C00000000100010000005762020';
wwv_flow_api.g_varchar2_table(7) := '0202D93465398E84210848F122CB2A128F1B0BD0518F2F4083B1882D0E1012813480100405C3A97010340E8C522BF7BC2D12079FE8B570AD08C8A760D1502896360883E1A09D1AF0552FFC2009080B2A2C0484290403282B2F5D226C4F852F862A416B91';
wwv_flow_api.g_varchar2_table(8) := '7F938A0B4B948C8A5D417E3636A036210021F904090A0000002C000000001000100000056C20200202691865398E042208C7F11ECB2A12871B0B0CBDBE00032DD6383048041282B1803D4E3BA10CD0CA11548445ECD010BD16AE15EE7115101AE8A4EDB1';
wwv_flow_api.g_varchar2_table(9) := '659E0CEA556F4B325F575AF2DD8C5689B4316A67570465407475482F2F77603F8589667E2392899636949323210021F904090A0000002C000000001000100000057E20200202B92C65398E82220883F11AC42A0A863B0C7052B3250284B0233006A49A60';
wwv_flow_api.g_varchar2_table(10) := 'A120C01A27C3639928A41603944A40401C1EBF17C1B512141A2F31C16903341088C260BD56AD1A89040342E2BE56040F0D757D842263070705614E692F0C075D070C29298D2D0708004C656C7F09070B6D697D0004070D6D655B2B210021F904090A0000';
wwv_flow_api.g_varchar2_table(11) := '002C000000001000100000057920200202491065398EC222084DF336C42AC2A8223745CD968481404728284C26D470716A405A85A789F9BA11200C84EF2540AD04100577AC5A29201084706C03280A8F8781D4AD8E080871F5752A131607075226630610';
wwv_flow_api.g_varchar2_table(12) := '090760070F2929280C070307737F5F4A9004883E5F5C0E07270E476D37088C242B210021F904090A0000002C000000001000100000057720200202491065398E022A2C8B2028C42ABE28FC42355B12311801B220A55AB2D349616821064797AA6578187A';
wwv_flow_api.g_varchar2_table(13) := 'B2EC4A308865BF36C0C240567C55AB0504F134BAB6446DB28525240ECD9BEB70180C0A095C07054700037809090D7D00402B047C040C0C020F073D2B0A0731932D09456135026C292B210021F904090A0000002C00000000100010000005792020020229';
wwv_flow_api.g_varchar2_table(14) := '9CE4A89E27419C4BA992AFE0DA8D2CA2B6FD0E049389455C286C839CA9263B35208DE01035124489C4198030E81EB3338261AC302D128B1590B52D1C0ED11DA1C01894048EC383704834141005560910250D690307030F0F0A705B52227C09028C02080E';
wwv_flow_api.g_varchar2_table(15) := '91230A9902090F3605695A7763772A210021F904090A0000002C000000001000100000057920200202299CE4A89E2C4B942AF9B6C4028BA8309F0B619A3BD78BD0B001593881626034E96EA41E0BC2A84262008262BB781CBE052CB1C1D41119BE91A0B1';
wwv_flow_api.g_varchar2_table(16) := 'CB16BECD13E4D128091207C8BDB01D20040B0806250A3E03070D08050B0C0A322A04070F028A02060F692A0B092F05053A10992B240303762A210021F904090A0000002C000000001000100000057520200202299CE4A89E6C5BAA24E10AB24A10715BA3';
wwv_flow_api.g_varchar2_table(17) := 'C2710C339960515BF80E351381F83A190E8A95F00449582130C072414438180C4376AB90C91405DC4850666911BEE469005194048F83415040701B1043060D2544000D500610040F5134360C05028A020D6963690210084E6A30770D842923210021F904';
wwv_flow_api.g_varchar2_table(18) := '090A0000002C000000001000100000057920200202299CE4A82E0C71BEA80A2C47020BAE4A10007228AF1C4A90380C088743F0E42A118A878642B42C991A8E85EA26183C0A85818CB4DB191268B10C577E2D10BC9160D12C090C8796F5A4182CEC3E0302';
wwv_flow_api.g_varchar2_table(19) := '10063B0A0D38524E3C2C0B0385103C31540F105D06020A9863049197270D716B240A40292321003B000000000000000000';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 74281251619118127 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2-spinner.gif'
 ,p_mime_type => 'image/gif'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000500806000000D29BB189000003144944415478DAED9DB16E13411040234111098A43A4051D257FE1025C50DD27A4A2F617208BCA1220512141759474FE04FF81AF44C2082B052D6E5C9824B78C';
wwv_flow_api.g_varchar2_table(2) := 'A58D345ADD66EF84386EEC77D22B925D29F2BDECECCCECE572E29C8303E6E86F008201C1806068C9CD359BCDCA3D27914BCF41B01DB438E7092537CE41B011B4B888E4E81C04DB13AC29B55C041B252171A5BF2644DB4FB25C0A922C7B82BB482E29938C';
wwv_flow_api.g_varchar2_table(3) := '115EB784E5950C5307B3821D37953D18C8A2813A18E8647522D6809FEE6918A2177D002545AE3E741E0C739AD4227CAC05D792F57F10BC503F7F110C731EDC42F0A883E051CF356321B88002C1DDF787790BB97399DA6738CB22D1652D64086E87DEE736';
wwv_flow_api.g_varchar2_table(4) := '31B97E2CEF59F0547011A608367A437562952047700BF4150B897DEE793AB14AB0407037C1B1846BD4A3E020B14A5220B87B59320F13ABFE04772FDB2CD5C1E3F1B814A275B09EF34F04EB84CB935377FE355A9CF384921BE6C4251F7D6B7068687111C9';
wwv_flow_api.g_varchar2_table(5) := 'B1391C361814AC29B55C041B25217115F93EE7C1468887E1383CD1614C7017C93C93658DF0BA252CF354252B18C1ECC140160DD4C140270B3AF7A209D1019C26016FD90104038201C1806040F0D173F43700C1806040302018100C081EF0FB4332612254';
wwv_flow_api.g_varchar2_table(6) := '82136AC5D28F656AFE1E041B792561D1F047F37580137E0905820DA0E49E0B7520F55AB8F25C37883E47F0B0D12B57AFD8DFC277E1A5F0587824BC1256C22EF84528103C60FC9EBB51C2B6C27BE1B4617F7E287CF2736ACF46C8103C5CC113256B27BC4B';
wwv_flow_api.g_varchar2_table(7) := 'BCD4EC8EF041B8542B7982E0E10A5EAAFDF69B704FF98C493E152E94E00AC10325D87B27CA634AF26B9D782178E082BDAC271D043F17AE106C4BF0530413A26F04CF08D106085A925F85FB2DE49E09174AF012C1C32E937483E3A3703791417FA64CB2D7';
wwv_flow_api.g_varchar2_table(8) := 'E8A83D5B2FF0AC41EE03E18BB055727742A6A62178A0AD4ADD7EBC147E086F8467C20BE1ADF053AF5C4589600B870DE14143FCB0C1355022D8D67161AD08C5EE6292116CE7C07FD920B8F2639950C62423F8F0FFAD5D8960F382D392116C5D705A728560';
wwv_flow_api.g_varchar2_table(9) := 'D382D392116C5C702819C1F649F5A92B25788A6040F031F0073126286D57A6B1DB0000000049454E44AE426082';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 74289749031119304 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2x2.png'
 ,p_mime_type => 'image/png'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A21206A5175657279205549202D2076312E31302E33202D20323031332D30392D30380A2A20687474703A2F2F6A717565727975692E636F6D0A2A20496E636C756465733A206A71756572792E75692E636F72652E6A732C206A71756572792E75692E';
wwv_flow_api.g_varchar2_table(2) := '7769646765742E6A732C206A71756572792E75692E6D6F7573652E6A732C206A71756572792E75692E736F727461626C652E6A730A2A20436F707972696768742032303133206A517565727920466F756E646174696F6E20616E64206F7468657220636F';
wwv_flow_api.g_varchar2_table(3) := '6E7472696275746F72733B204C6963656E736564204D4954202A2F0A0A2866756E6374696F6E28742C65297B66756E6374696F6E206E28652C6E297B76617220722C732C6F2C613D652E6E6F64654E616D652E746F4C6F7765724361736528293B726574';
wwv_flow_api.g_varchar2_table(4) := '75726E2261726561223D3D3D613F28723D652E706172656E744E6F64652C733D722E6E616D652C652E687265662626732626226D6170223D3D3D722E6E6F64654E616D652E746F4C6F7765724361736528293F286F3D742822696D675B7573656D61703D';
wwv_flow_api.g_varchar2_table(5) := '23222B732B225D22295B305D2C21216F262669286F29293A2131293A282F696E7075747C73656C6563747C74657874617265617C627574746F6E7C6F626A6563742F2E746573742861293F21652E64697361626C65643A2261223D3D3D613F652E687265';
wwv_flow_api.g_varchar2_table(6) := '667C7C6E3A6E292626692865297D66756E6374696F6E20692865297B72657475726E20742E657870722E66696C746572732E76697369626C65286529262621742865292E706172656E747328292E6164644261636B28292E66696C7465722866756E6374';
wwv_flow_api.g_varchar2_table(7) := '696F6E28297B72657475726E2268696464656E223D3D3D742E63737328746869732C227669736962696C69747922297D292E6C656E6774687D76617220723D302C733D2F5E75692D69642D5C642B242F3B742E75693D742E75697C7C7B7D2C742E657874';
wwv_flow_api.g_varchar2_table(8) := '656E6428742E75692C7B76657273696F6E3A22312E31302E33222C6B6579436F64653A7B4241434B53504143453A382C434F4D4D413A3138382C44454C4554453A34362C444F574E3A34302C454E443A33352C454E5445523A31332C4553434150453A32';
wwv_flow_api.g_varchar2_table(9) := '372C484F4D453A33362C4C4546543A33372C4E554D5041445F4144443A3130372C4E554D5041445F444543494D414C3A3131302C4E554D5041445F4449564944453A3131312C4E554D5041445F454E5445523A3130382C4E554D5041445F4D554C544950';
wwv_flow_api.g_varchar2_table(10) := '4C593A3130362C4E554D5041445F53554254524143543A3130392C504147455F444F574E3A33342C504147455F55503A33332C504552494F443A3139302C52494748543A33392C53504143453A33322C5441423A392C55503A33387D7D292C742E666E2E';
wwv_flow_api.g_varchar2_table(11) := '657874656E64287B666F6375733A66756E6374696F6E2865297B72657475726E2066756E6374696F6E286E2C69297B72657475726E226E756D626572223D3D747970656F66206E3F746869732E656163682866756E6374696F6E28297B76617220653D74';
wwv_flow_api.g_varchar2_table(12) := '6869733B73657454696D656F75742866756E6374696F6E28297B742865292E666F63757328292C692626692E63616C6C2865297D2C6E297D293A652E6170706C7928746869732C617267756D656E7473297D7D28742E666E2E666F637573292C7363726F';
wwv_flow_api.g_varchar2_table(13) := '6C6C506172656E743A66756E6374696F6E28297B76617220653B72657475726E20653D742E75692E696526262F287374617469637C72656C6174697665292F2E7465737428746869732E6373732822706F736974696F6E2229297C7C2F6162736F6C7574';
wwv_flow_api.g_varchar2_table(14) := '652F2E7465737428746869732E6373732822706F736974696F6E2229293F746869732E706172656E747328292E66696C7465722866756E6374696F6E28297B72657475726E2F2872656C61746976657C6162736F6C7574657C6669786564292F2E746573';
wwv_flow_api.g_varchar2_table(15) := '7428742E63737328746869732C22706F736974696F6E22292926262F286175746F7C7363726F6C6C292F2E7465737428742E63737328746869732C226F766572666C6F7722292B742E63737328746869732C226F766572666C6F772D7922292B742E6373';
wwv_flow_api.g_varchar2_table(16) := '7328746869732C226F766572666C6F772D782229297D292E65712830293A746869732E706172656E747328292E66696C7465722866756E6374696F6E28297B72657475726E2F286175746F7C7363726F6C6C292F2E7465737428742E6373732874686973';
wwv_flow_api.g_varchar2_table(17) := '2C226F766572666C6F7722292B742E63737328746869732C226F766572666C6F772D7922292B742E63737328746869732C226F766572666C6F772D782229297D292E65712830292C2F66697865642F2E7465737428746869732E6373732822706F736974';
wwv_flow_api.g_varchar2_table(18) := '696F6E2229297C7C21652E6C656E6774683F7428646F63756D656E74293A657D2C7A496E6465783A66756E6374696F6E286E297B6966286E213D3D652972657475726E20746869732E63737328227A496E646578222C6E293B696628746869732E6C656E';
wwv_flow_api.g_varchar2_table(19) := '67746829666F722876617220692C722C733D7428746869735B305D293B732E6C656E6774682626735B305D213D3D646F63756D656E743B297B696628693D732E6373732822706F736974696F6E22292C28226162736F6C757465223D3D3D697C7C227265';
wwv_flow_api.g_varchar2_table(20) := '6C6174697665223D3D3D697C7C226669786564223D3D3D6929262628723D7061727365496E7428732E63737328227A496E64657822292C3130292C2169734E614E287229262630213D3D72292972657475726E20723B733D732E706172656E7428297D72';
wwv_flow_api.g_varchar2_table(21) := '657475726E20307D2C756E6971756549643A66756E6374696F6E28297B72657475726E20746869732E656163682866756E6374696F6E28297B746869732E69647C7C28746869732E69643D2275692D69642D222B202B2B72297D297D2C72656D6F766555';
wwv_flow_api.g_varchar2_table(22) := '6E6971756549643A66756E6374696F6E28297B72657475726E20746869732E656163682866756E6374696F6E28297B732E7465737428746869732E6964292626742874686973292E72656D6F7665417474722822696422297D297D7D292C742E65787465';
wwv_flow_api.g_varchar2_table(23) := '6E6428742E657870725B223A225D2C7B646174613A742E657870722E63726561746550736575646F3F742E657870722E63726561746550736575646F2866756E6374696F6E2865297B72657475726E2066756E6374696F6E286E297B72657475726E2121';
wwv_flow_api.g_varchar2_table(24) := '742E64617461286E2C65297D7D293A66756E6374696F6E28652C6E2C69297B72657475726E2121742E6461746128652C695B335D297D2C666F63757361626C653A66756E6374696F6E2865297B72657475726E206E28652C2169734E614E28742E617474';
wwv_flow_api.g_varchar2_table(25) := '7228652C22746162696E646578222929297D2C7461626261626C653A66756E6374696F6E2865297B76617220693D742E6174747228652C22746162696E64657822292C723D69734E614E2869293B72657475726E28727C7C693E3D302926266E28652C21';
wwv_flow_api.g_varchar2_table(26) := '72297D7D292C7428223C613E22292E6F7574657257696474682831292E6A71756572797C7C742E65616368285B225769647468222C22486569676874225D2C66756E6374696F6E286E2C69297B66756E6374696F6E207228652C6E2C692C72297B726574';
wwv_flow_api.g_varchar2_table(27) := '75726E20742E6561636828732C66756E6374696F6E28297B6E2D3D7061727365466C6F617428742E63737328652C2270616464696E67222B7468697329297C7C302C692626286E2D3D7061727365466C6F617428742E63737328652C22626F7264657222';
wwv_flow_api.g_varchar2_table(28) := '2B746869732B2257696474682229297C7C30292C722626286E2D3D7061727365466C6F617428742E63737328652C226D617267696E222B7468697329297C7C30297D292C6E7D76617220733D225769647468223D3D3D693F5B224C656674222C22526967';
wwv_flow_api.g_varchar2_table(29) := '6874225D3A5B22546F70222C22426F74746F6D225D2C6F3D692E746F4C6F7765724361736528292C613D7B696E6E657257696474683A742E666E2E696E6E657257696474682C696E6E65724865696768743A742E666E2E696E6E65724865696768742C6F';
wwv_flow_api.g_varchar2_table(30) := '7574657257696474683A742E666E2E6F7574657257696474682C6F757465724865696768743A742E666E2E6F757465724865696768747D3B742E666E5B22696E6E6572222B695D3D66756E6374696F6E286E297B72657475726E206E3D3D3D653F615B22';
wwv_flow_api.g_varchar2_table(31) := '696E6E6572222B695D2E63616C6C2874686973293A746869732E656163682866756E6374696F6E28297B742874686973292E637373286F2C7228746869732C6E292B22707822297D297D2C742E666E5B226F75746572222B695D3D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(32) := '652C6E297B72657475726E226E756D62657222213D747970656F6620653F615B226F75746572222B695D2E63616C6C28746869732C65293A746869732E656163682866756E6374696F6E28297B742874686973292E637373286F2C7228746869732C652C';
wwv_flow_api.g_varchar2_table(33) := '21302C6E292B22707822297D297D7D292C742E666E2E6164644261636B7C7C28742E666E2E6164644261636B3D66756E6374696F6E2874297B72657475726E20746869732E616464286E756C6C3D3D743F746869732E707265764F626A6563743A746869';
wwv_flow_api.g_varchar2_table(34) := '732E707265764F626A6563742E66696C746572287429297D292C7428223C613E22292E646174612822612D62222C226122292E72656D6F7665446174612822612D6222292E646174612822612D622229262628742E666E2E72656D6F7665446174613D66';
wwv_flow_api.g_varchar2_table(35) := '756E6374696F6E2865297B72657475726E2066756E6374696F6E286E297B72657475726E20617267756D656E74732E6C656E6774683F652E63616C6C28746869732C742E63616D656C43617365286E29293A652E63616C6C2874686973297D7D28742E66';
wwv_flow_api.g_varchar2_table(36) := '6E2E72656D6F76654461746129292C742E75692E69653D21212F6D736965205B5C772E5D2B2F2E65786563286E6176696761746F722E757365724167656E742E746F4C6F776572436173652829292C742E737570706F72742E73656C6563747374617274';
wwv_flow_api.g_varchar2_table(37) := '3D226F6E73656C656374737461727422696E20646F63756D656E742E637265617465456C656D656E74282264697622292C742E666E2E657874656E64287B64697361626C6553656C656374696F6E3A66756E6374696F6E28297B72657475726E20746869';
wwv_flow_api.g_varchar2_table(38) := '732E62696E642828742E737570706F72742E73656C65637473746172743F2273656C6563747374617274223A226D6F757365646F776E22292B222E75692D64697361626C6553656C656374696F6E222C66756E6374696F6E2874297B742E70726576656E';
wwv_flow_api.g_varchar2_table(39) := '7444656661756C7428297D297D2C656E61626C6553656C656374696F6E3A66756E6374696F6E28297B72657475726E20746869732E756E62696E6428222E75692D64697361626C6553656C656374696F6E22297D7D292C742E657874656E6428742E7569';
wwv_flow_api.g_varchar2_table(40) := '2C7B706C7567696E3A7B6164643A66756E6374696F6E28652C6E2C69297B76617220722C733D742E75695B655D2E70726F746F747970653B666F72287220696E206929732E706C7567696E735B725D3D732E706C7567696E735B725D7C7C5B5D2C732E70';
wwv_flow_api.g_varchar2_table(41) := '6C7567696E735B725D2E70757368285B6E2C695B725D5D297D2C63616C6C3A66756E6374696F6E28742C652C6E297B76617220692C723D742E706C7567696E735B655D3B696628722626742E656C656D656E745B305D2E706172656E744E6F6465262631';
wwv_flow_api.g_varchar2_table(42) := '31213D3D742E656C656D656E745B305D2E706172656E744E6F64652E6E6F64655479706529666F7228693D303B722E6C656E6774683E693B692B2B29742E6F7074696F6E735B725B695D5B305D5D2626725B695D5B315D2E6170706C7928742E656C656D';
wwv_flow_api.g_varchar2_table(43) := '656E742C6E297D7D2C6861735363726F6C6C3A66756E6374696F6E28652C6E297B6966282268696464656E223D3D3D742865292E63737328226F766572666C6F7722292972657475726E21313B76617220693D6E2626226C656674223D3D3D6E3F227363';
wwv_flow_api.g_varchar2_table(44) := '726F6C6C4C656674223A227363726F6C6C546F70222C723D21313B72657475726E20655B695D3E303F21303A28655B695D3D312C723D655B695D3E302C655B695D3D302C72297D7D297D29286A5175657279293B2866756E6374696F6E28742C65297B76';
wwv_flow_api.g_varchar2_table(45) := '617220693D302C6E3D41727261792E70726F746F747970652E736C6963652C733D742E636C65616E446174613B742E636C65616E446174613D66756E6374696F6E2865297B666F722876617220692C6E3D303B6E756C6C213D28693D655B6E5D293B6E2B';
wwv_flow_api.g_varchar2_table(46) := '2B297472797B742869292E7472696767657248616E646C6572282272656D6F766522297D63617463682872297B7D732865297D2C742E7769646765743D66756E6374696F6E28692C6E2C73297B76617220722C6F2C612C752C6C3D7B7D2C683D692E7370';
wwv_flow_api.g_varchar2_table(47) := '6C697428222E22295B305D3B693D692E73706C697428222E22295B315D2C723D682B222D222B692C737C7C28733D6E2C6E3D742E576964676574292C742E657870725B223A225D5B722E746F4C6F7765724361736528295D3D66756E6374696F6E286529';
wwv_flow_api.g_varchar2_table(48) := '7B72657475726E2121742E6461746128652C72297D2C745B685D3D745B685D7C7C7B7D2C6F3D745B685D5B695D2C613D745B685D5B695D3D66756E6374696F6E28742C69297B72657475726E20746869732E5F6372656174655769646765743F28617267';
wwv_flow_api.g_varchar2_table(49) := '756D656E74732E6C656E6774682626746869732E5F63726561746557696467657428742C69292C65293A6E6577206128742C69297D2C742E657874656E6428612C6F2C7B76657273696F6E3A732E76657273696F6E2C5F70726F746F3A742E657874656E';
wwv_flow_api.g_varchar2_table(50) := '64287B7D2C73292C5F6368696C64436F6E7374727563746F72733A5B5D7D292C753D6E6577206E2C752E6F7074696F6E733D742E7769646765742E657874656E64287B7D2C752E6F7074696F6E73292C742E6561636828732C66756E6374696F6E28692C';
wwv_flow_api.g_varchar2_table(51) := '73297B72657475726E20742E697346756E6374696F6E2873293F286C5B695D3D66756E6374696F6E28297B76617220743D66756E6374696F6E28297B72657475726E206E2E70726F746F747970655B695D2E6170706C7928746869732C617267756D656E';
wwv_flow_api.g_varchar2_table(52) := '7473297D2C653D66756E6374696F6E2874297B72657475726E206E2E70726F746F747970655B695D2E6170706C7928746869732C74297D3B72657475726E2066756E6374696F6E28297B76617220692C6E3D746869732E5F73757065722C723D74686973';
wwv_flow_api.g_varchar2_table(53) := '2E5F73757065724170706C793B72657475726E20746869732E5F73757065723D742C746869732E5F73757065724170706C793D652C693D732E6170706C7928746869732C617267756D656E7473292C746869732E5F73757065723D6E2C746869732E5F73';
wwv_flow_api.g_varchar2_table(54) := '757065724170706C793D722C697D7D28292C65293A286C5B695D3D732C65297D292C612E70726F746F747970653D742E7769646765742E657874656E6428752C7B7769646765744576656E745072656669783A6F3F752E7769646765744576656E745072';
wwv_flow_api.g_varchar2_table(55) := '656669783A697D2C6C2C7B636F6E7374727563746F723A612C6E616D6573706163653A682C7769646765744E616D653A692C77696467657446756C6C4E616D653A727D292C6F3F28742E65616368286F2E5F6368696C64436F6E7374727563746F72732C';
wwv_flow_api.g_varchar2_table(56) := '66756E6374696F6E28652C69297B766172206E3D692E70726F746F747970653B742E776964676574286E2E6E616D6573706163652B222E222B6E2E7769646765744E616D652C612C692E5F70726F746F297D292C64656C657465206F2E5F6368696C6443';
wwv_flow_api.g_varchar2_table(57) := '6F6E7374727563746F7273293A6E2E5F6368696C64436F6E7374727563746F72732E707573682861292C742E7769646765742E62726964676528692C61297D2C742E7769646765742E657874656E643D66756E6374696F6E2869297B666F722876617220';
wwv_flow_api.g_varchar2_table(58) := '732C722C6F3D6E2E63616C6C28617267756D656E74732C31292C613D302C753D6F2E6C656E6774683B753E613B612B2B29666F72287320696E206F5B615D29723D6F5B615D5B735D2C6F5B615D2E6861734F776E50726F7065727479287329262672213D';
wwv_flow_api.g_varchar2_table(59) := '3D65262628695B735D3D742E6973506C61696E4F626A6563742872293F742E6973506C61696E4F626A65637428695B735D293F742E7769646765742E657874656E64287B7D2C695B735D2C72293A742E7769646765742E657874656E64287B7D2C72293A';
wwv_flow_api.g_varchar2_table(60) := '72293B72657475726E20697D2C742E7769646765742E6272696467653D66756E6374696F6E28692C73297B76617220723D732E70726F746F747970652E77696467657446756C6C4E616D657C7C693B742E666E5B695D3D66756E6374696F6E286F297B76';
wwv_flow_api.g_varchar2_table(61) := '617220613D22737472696E67223D3D747970656F66206F2C753D6E2E63616C6C28617267756D656E74732C31292C6C3D746869733B72657475726E206F3D21612626752E6C656E6774683F742E7769646765742E657874656E642E6170706C79286E756C';
wwv_flow_api.g_varchar2_table(62) := '6C2C5B6F5D2E636F6E636174287529293A6F2C613F746869732E656163682866756E6374696F6E28297B766172206E2C733D742E6461746128746869732C72293B72657475726E20733F742E697346756E6374696F6E28735B6F5D292626225F22213D3D';
wwv_flow_api.g_varchar2_table(63) := '6F2E6368617241742830293F286E3D735B6F5D2E6170706C7928732C75292C6E213D3D7326266E213D3D653F286C3D6E26266E2E6A71756572793F6C2E70757368537461636B286E2E6765742829293A6E2C2131293A65293A742E6572726F7228226E6F';
wwv_flow_api.g_varchar2_table(64) := '2073756368206D6574686F642027222B6F2B222720666F7220222B692B222077696467657420696E7374616E636522293A742E6572726F72282263616E6E6F742063616C6C206D6574686F6473206F6E20222B692B22207072696F7220746F20696E6974';
wwv_flow_api.g_varchar2_table(65) := '69616C697A6174696F6E3B20222B22617474656D7074656420746F2063616C6C206D6574686F642027222B6F2B222722297D293A746869732E656163682866756E6374696F6E28297B76617220653D742E6461746128746869732C72293B653F652E6F70';
wwv_flow_api.g_varchar2_table(66) := '74696F6E286F7C7C7B7D292E5F696E697428293A742E6461746128746869732C722C6E65772073286F2C7468697329297D292C6C7D7D2C742E5769646765743D66756E6374696F6E28297B7D2C742E5769646765742E5F6368696C64436F6E7374727563';
wwv_flow_api.g_varchar2_table(67) := '746F72733D5B5D2C742E5769646765742E70726F746F747970653D7B7769646765744E616D653A22776964676574222C7769646765744576656E745072656669783A22222C64656661756C74456C656D656E743A223C6469763E222C6F7074696F6E733A';
wwv_flow_api.g_varchar2_table(68) := '7B64697361626C65643A21312C6372656174653A6E756C6C7D2C5F6372656174655769646765743A66756E6374696F6E28652C6E297B6E3D74286E7C7C746869732E64656661756C74456C656D656E747C7C74686973295B305D2C746869732E656C656D';
wwv_flow_api.g_varchar2_table(69) := '656E743D74286E292C746869732E757569643D692B2B2C746869732E6576656E744E616D6573706163653D222E222B746869732E7769646765744E616D652B746869732E757569642C746869732E6F7074696F6E733D742E7769646765742E657874656E';
wwv_flow_api.g_varchar2_table(70) := '64287B7D2C746869732E6F7074696F6E732C746869732E5F6765744372656174654F7074696F6E7328292C65292C746869732E62696E64696E67733D7428292C746869732E686F76657261626C653D7428292C746869732E666F63757361626C653D7428';
wwv_flow_api.g_varchar2_table(71) := '292C6E213D3D74686973262628742E64617461286E2C746869732E77696467657446756C6C4E616D652C74686973292C746869732E5F6F6E2821302C746869732E656C656D656E742C7B72656D6F76653A66756E6374696F6E2874297B742E7461726765';
wwv_flow_api.g_varchar2_table(72) := '743D3D3D6E2626746869732E64657374726F7928297D7D292C746869732E646F63756D656E743D74286E2E7374796C653F6E2E6F776E6572446F63756D656E743A6E2E646F63756D656E747C7C6E292C746869732E77696E646F773D7428746869732E64';
wwv_flow_api.g_varchar2_table(73) := '6F63756D656E745B305D2E64656661756C74566965777C7C746869732E646F63756D656E745B305D2E706172656E7457696E646F7729292C746869732E5F63726561746528292C746869732E5F747269676765722822637265617465222C6E756C6C2C74';
wwv_flow_api.g_varchar2_table(74) := '6869732E5F6765744372656174654576656E74446174612829292C746869732E5F696E697428297D2C5F6765744372656174654F7074696F6E733A742E6E6F6F702C5F6765744372656174654576656E74446174613A742E6E6F6F702C5F637265617465';
wwv_flow_api.g_varchar2_table(75) := '3A742E6E6F6F702C5F696E69743A742E6E6F6F702C64657374726F793A66756E6374696F6E28297B746869732E5F64657374726F7928292C746869732E656C656D656E742E756E62696E6428746869732E6576656E744E616D657370616365292E72656D';
wwv_flow_api.g_varchar2_table(76) := '6F76654461746128746869732E7769646765744E616D65292E72656D6F76654461746128746869732E77696467657446756C6C4E616D65292E72656D6F76654461746128742E63616D656C4361736528746869732E77696467657446756C6C4E616D6529';
wwv_flow_api.g_varchar2_table(77) := '292C746869732E77696467657428292E756E62696E6428746869732E6576656E744E616D657370616365292E72656D6F7665417474722822617269612D64697361626C656422292E72656D6F7665436C61737328746869732E77696467657446756C6C4E';
wwv_flow_api.g_varchar2_table(78) := '616D652B222D64697361626C656420222B2275692D73746174652D64697361626C656422292C746869732E62696E64696E67732E756E62696E6428746869732E6576656E744E616D657370616365292C746869732E686F76657261626C652E72656D6F76';
wwv_flow_api.g_varchar2_table(79) := '65436C617373282275692D73746174652D686F76657222292C746869732E666F63757361626C652E72656D6F7665436C617373282275692D73746174652D666F63757322297D2C5F64657374726F793A742E6E6F6F702C7769646765743A66756E637469';
wwv_flow_api.g_varchar2_table(80) := '6F6E28297B72657475726E20746869732E656C656D656E747D2C6F7074696F6E3A66756E6374696F6E28692C6E297B76617220732C722C6F2C613D693B696628303D3D3D617267756D656E74732E6C656E6774682972657475726E20742E776964676574';
wwv_flow_api.g_varchar2_table(81) := '2E657874656E64287B7D2C746869732E6F7074696F6E73293B69662822737472696E67223D3D747970656F66206929696628613D7B7D2C733D692E73706C697428222E22292C693D732E736869667428292C732E6C656E677468297B666F7228723D615B';
wwv_flow_api.g_varchar2_table(82) := '695D3D742E7769646765742E657874656E64287B7D2C746869732E6F7074696F6E735B695D292C6F3D303B732E6C656E6774682D313E6F3B6F2B2B29725B735B6F5D5D3D725B735B6F5D5D7C7C7B7D2C723D725B735B6F5D5D3B696628693D732E706F70';
wwv_flow_api.g_varchar2_table(83) := '28292C6E3D3D3D652972657475726E20725B695D3D3D3D653F6E756C6C3A725B695D3B725B695D3D6E7D656C73657B6966286E3D3D3D652972657475726E20746869732E6F7074696F6E735B695D3D3D3D653F6E756C6C3A746869732E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(84) := '5B695D3B615B695D3D6E7D72657475726E20746869732E5F7365744F7074696F6E732861292C746869737D2C5F7365744F7074696F6E733A66756E6374696F6E2874297B76617220653B666F72286520696E207429746869732E5F7365744F7074696F6E';
wwv_flow_api.g_varchar2_table(85) := '28652C745B655D293B72657475726E20746869737D2C5F7365744F7074696F6E3A66756E6374696F6E28742C65297B72657475726E20746869732E6F7074696F6E735B745D3D652C2264697361626C6564223D3D3D74262628746869732E776964676574';
wwv_flow_api.g_varchar2_table(86) := '28292E746F67676C65436C61737328746869732E77696467657446756C6C4E616D652B222D64697361626C65642075692D73746174652D64697361626C6564222C212165292E617474722822617269612D64697361626C6564222C65292C746869732E68';
wwv_flow_api.g_varchar2_table(87) := '6F76657261626C652E72656D6F7665436C617373282275692D73746174652D686F76657222292C746869732E666F63757361626C652E72656D6F7665436C617373282275692D73746174652D666F6375732229292C746869737D2C656E61626C653A6675';
wwv_flow_api.g_varchar2_table(88) := '6E6374696F6E28297B72657475726E20746869732E5F7365744F7074696F6E282264697361626C6564222C2131297D2C64697361626C653A66756E6374696F6E28297B72657475726E20746869732E5F7365744F7074696F6E282264697361626C656422';
wwv_flow_api.g_varchar2_table(89) := '2C2130297D2C5F6F6E3A66756E6374696F6E28692C6E2C73297B76617220722C6F3D746869733B22626F6F6C65616E22213D747970656F662069262628733D6E2C6E3D692C693D2131292C733F286E3D723D74286E292C746869732E62696E64696E6773';
wwv_flow_api.g_varchar2_table(90) := '3D746869732E62696E64696E67732E616464286E29293A28733D6E2C6E3D746869732E656C656D656E742C723D746869732E7769646765742829292C742E6561636828732C66756E6374696F6E28732C61297B66756E6374696F6E207528297B72657475';
wwv_flow_api.g_varchar2_table(91) := '726E20697C7C6F2E6F7074696F6E732E64697361626C6564213D3D2130262621742874686973292E686173436C617373282275692D73746174652D64697361626C656422293F2822737472696E67223D3D747970656F6620613F6F5B615D3A61292E6170';
wwv_flow_api.g_varchar2_table(92) := '706C79286F2C617267756D656E7473293A657D22737472696E6722213D747970656F662061262628752E677569643D612E677569643D612E677569647C7C752E677569647C7C742E677569642B2B293B766172206C3D732E6D61746368282F5E285C772B';
wwv_flow_api.g_varchar2_table(93) := '295C732A282E2A29242F292C683D6C5B315D2B6F2E6576656E744E616D6573706163652C633D6C5B325D3B633F722E64656C656761746528632C682C75293A6E2E62696E6428682C75297D297D2C5F6F66663A66756E6374696F6E28742C65297B653D28';
wwv_flow_api.g_varchar2_table(94) := '657C7C2222292E73706C697428222022292E6A6F696E28746869732E6576656E744E616D6573706163652B222022292B746869732E6576656E744E616D6573706163652C742E756E62696E642865292E756E64656C65676174652865297D2C5F64656C61';
wwv_flow_api.g_varchar2_table(95) := '793A66756E6374696F6E28742C65297B66756E6374696F6E206928297B72657475726E2822737472696E67223D3D747970656F6620743F6E5B745D3A74292E6170706C79286E2C617267756D656E7473297D766172206E3D746869733B72657475726E20';
wwv_flow_api.g_varchar2_table(96) := '73657454696D656F757428692C657C7C30297D2C5F686F76657261626C653A66756E6374696F6E2865297B746869732E686F76657261626C653D746869732E686F76657261626C652E6164642865292C746869732E5F6F6E28652C7B6D6F757365656E74';
wwv_flow_api.g_varchar2_table(97) := '65723A66756E6374696F6E2865297B7428652E63757272656E74546172676574292E616464436C617373282275692D73746174652D686F76657222297D2C6D6F7573656C656176653A66756E6374696F6E2865297B7428652E63757272656E7454617267';
wwv_flow_api.g_varchar2_table(98) := '6574292E72656D6F7665436C617373282275692D73746174652D686F76657222297D7D297D2C5F666F63757361626C653A66756E6374696F6E2865297B746869732E666F63757361626C653D746869732E666F63757361626C652E6164642865292C7468';
wwv_flow_api.g_varchar2_table(99) := '69732E5F6F6E28652C7B666F637573696E3A66756E6374696F6E2865297B7428652E63757272656E74546172676574292E616464436C617373282275692D73746174652D666F63757322297D2C666F6375736F75743A66756E6374696F6E2865297B7428';
wwv_flow_api.g_varchar2_table(100) := '652E63757272656E74546172676574292E72656D6F7665436C617373282275692D73746174652D666F63757322297D7D297D2C5F747269676765723A66756E6374696F6E28652C692C6E297B76617220732C722C6F3D746869732E6F7074696F6E735B65';
wwv_flow_api.g_varchar2_table(101) := '5D3B6966286E3D6E7C7C7B7D2C693D742E4576656E742869292C692E747970653D28653D3D3D746869732E7769646765744576656E745072656669783F653A746869732E7769646765744576656E745072656669782B65292E746F4C6F77657243617365';
wwv_flow_api.g_varchar2_table(102) := '28292C692E7461726765743D746869732E656C656D656E745B305D2C723D692E6F726967696E616C4576656E7429666F72287320696E2072297320696E20697C7C28695B735D3D725B735D293B72657475726E20746869732E656C656D656E742E747269';
wwv_flow_api.g_varchar2_table(103) := '6767657228692C6E292C2128742E697346756E6374696F6E286F2926266F2E6170706C7928746869732E656C656D656E745B305D2C5B695D2E636F6E636174286E29293D3D3D21317C7C692E697344656661756C7450726576656E7465642829297D7D2C';
wwv_flow_api.g_varchar2_table(104) := '742E65616368287B73686F773A2266616465496E222C686964653A22666164654F7574227D2C66756E6374696F6E28652C69297B742E5769646765742E70726F746F747970655B225F222B655D3D66756E6374696F6E286E2C732C72297B22737472696E';
wwv_flow_api.g_varchar2_table(105) := '67223D3D747970656F662073262628733D7B6566666563743A737D293B766172206F2C613D733F733D3D3D21307C7C226E756D626572223D3D747970656F6620733F693A732E6566666563747C7C693A653B733D737C7C7B7D2C226E756D626572223D3D';
wwv_flow_api.g_varchar2_table(106) := '747970656F662073262628733D7B6475726174696F6E3A737D292C6F3D21742E6973456D7074794F626A6563742873292C732E636F6D706C6574653D722C732E64656C617926266E2E64656C617928732E64656C6179292C6F2626742E65666665637473';
wwv_flow_api.g_varchar2_table(107) := '2626742E656666656374732E6566666563745B615D3F6E5B655D2873293A61213D3D6526266E5B615D3F6E5B615D28732E6475726174696F6E2C732E656173696E672C72293A6E2E71756575652866756E6374696F6E2869297B742874686973295B655D';
wwv_flow_api.g_varchar2_table(108) := '28292C722626722E63616C6C286E5B305D292C6928297D297D7D297D29286A5175657279293B2866756E6374696F6E2874297B76617220653D21313B7428646F63756D656E74292E6D6F75736575702866756E6374696F6E28297B653D21317D292C742E';
wwv_flow_api.g_varchar2_table(109) := '776964676574282275692E6D6F757365222C7B76657273696F6E3A22312E31302E33222C6F7074696F6E733A7B63616E63656C3A22696E7075742C74657874617265612C627574746F6E2C73656C6563742C6F7074696F6E222C64697374616E63653A31';
wwv_flow_api.g_varchar2_table(110) := '2C64656C61793A307D2C5F6D6F757365496E69743A66756E6374696F6E28297B76617220653D746869733B746869732E656C656D656E742E62696E6428226D6F757365646F776E2E222B746869732E7769646765744E616D652C66756E6374696F6E2874';
wwv_flow_api.g_varchar2_table(111) := '297B72657475726E20652E5F6D6F757365446F776E2874297D292E62696E642822636C69636B2E222B746869732E7769646765744E616D652C66756E6374696F6E2869297B72657475726E21303D3D3D742E6461746128692E7461726765742C652E7769';
wwv_flow_api.g_varchar2_table(112) := '646765744E616D652B222E70726576656E74436C69636B4576656E7422293F28742E72656D6F76654461746128692E7461726765742C652E7769646765744E616D652B222E70726576656E74436C69636B4576656E7422292C692E73746F70496D6D6564';
wwv_flow_api.g_varchar2_table(113) := '6961746550726F7061676174696F6E28292C2131293A756E646566696E65647D292C746869732E737461727465643D21317D2C5F6D6F75736544657374726F793A66756E6374696F6E28297B746869732E656C656D656E742E756E62696E6428222E222B';
wwv_flow_api.g_varchar2_table(114) := '746869732E7769646765744E616D65292C746869732E5F6D6F7573654D6F766544656C656761746526267428646F63756D656E74292E756E62696E6428226D6F7573656D6F76652E222B746869732E7769646765744E616D652C746869732E5F6D6F7573';
wwv_flow_api.g_varchar2_table(115) := '654D6F766544656C6567617465292E756E62696E6428226D6F75736575702E222B746869732E7769646765744E616D652C746869732E5F6D6F757365557044656C6567617465297D2C5F6D6F757365446F776E3A66756E6374696F6E2869297B69662821';
wwv_flow_api.g_varchar2_table(116) := '65297B746869732E5F6D6F757365537461727465642626746869732E5F6D6F75736555702869292C746869732E5F6D6F757365446F776E4576656E743D693B76617220733D746869732C6E3D313D3D3D692E77686963682C613D22737472696E67223D3D';
wwv_flow_api.g_varchar2_table(117) := '747970656F6620746869732E6F7074696F6E732E63616E63656C2626692E7461726765742E6E6F64654E616D653F7428692E746172676574292E636C6F7365737428746869732E6F7074696F6E732E63616E63656C292E6C656E6774683A21313B726574';
wwv_flow_api.g_varchar2_table(118) := '75726E206E262621612626746869732E5F6D6F757365436170747572652869293F28746869732E6D6F75736544656C61794D65743D21746869732E6F7074696F6E732E64656C61792C746869732E6D6F75736544656C61794D65747C7C28746869732E5F';
wwv_flow_api.g_varchar2_table(119) := '6D6F75736544656C617954696D65723D73657454696D656F75742866756E6374696F6E28297B732E6D6F75736544656C61794D65743D21307D2C746869732E6F7074696F6E732E64656C617929292C746869732E5F6D6F75736544697374616E63654D65';
wwv_flow_api.g_varchar2_table(120) := '742869292626746869732E5F6D6F75736544656C61794D6574286929262628746869732E5F6D6F757365537461727465643D746869732E5F6D6F7573655374617274286929213D3D21312C21746869732E5F6D6F75736553746172746564293F28692E70';
wwv_flow_api.g_varchar2_table(121) := '726576656E7444656661756C7428292C2130293A2821303D3D3D742E6461746128692E7461726765742C746869732E7769646765744E616D652B222E70726576656E74436C69636B4576656E7422292626742E72656D6F76654461746128692E74617267';
wwv_flow_api.g_varchar2_table(122) := '65742C746869732E7769646765744E616D652B222E70726576656E74436C69636B4576656E7422292C746869732E5F6D6F7573654D6F766544656C65676174653D66756E6374696F6E2874297B72657475726E20732E5F6D6F7573654D6F76652874297D';
wwv_flow_api.g_varchar2_table(123) := '2C746869732E5F6D6F757365557044656C65676174653D66756E6374696F6E2874297B72657475726E20732E5F6D6F75736555702874297D2C7428646F63756D656E74292E62696E6428226D6F7573656D6F76652E222B746869732E7769646765744E61';
wwv_flow_api.g_varchar2_table(124) := '6D652C746869732E5F6D6F7573654D6F766544656C6567617465292E62696E6428226D6F75736575702E222B746869732E7769646765744E616D652C746869732E5F6D6F757365557044656C6567617465292C692E70726576656E7444656661756C7428';
wwv_flow_api.g_varchar2_table(125) := '292C653D21302C213029293A21307D7D2C5F6D6F7573654D6F76653A66756E6374696F6E2865297B72657475726E20742E75692E696526262821646F63756D656E742E646F63756D656E744D6F64657C7C393E646F63756D656E742E646F63756D656E74';
wwv_flow_api.g_varchar2_table(126) := '4D6F646529262621652E627574746F6E3F746869732E5F6D6F75736555702865293A746869732E5F6D6F757365537461727465643F28746869732E5F6D6F757365447261672865292C652E70726576656E7444656661756C742829293A28746869732E5F';
wwv_flow_api.g_varchar2_table(127) := '6D6F75736544697374616E63654D65742865292626746869732E5F6D6F75736544656C61794D6574286529262628746869732E5F6D6F757365537461727465643D746869732E5F6D6F757365537461727428746869732E5F6D6F757365446F776E457665';
wwv_flow_api.g_varchar2_table(128) := '6E742C6529213D3D21312C746869732E5F6D6F757365537461727465643F746869732E5F6D6F757365447261672865293A746869732E5F6D6F7573655570286529292C21746869732E5F6D6F75736553746172746564297D2C5F6D6F75736555703A6675';
wwv_flow_api.g_varchar2_table(129) := '6E6374696F6E2865297B72657475726E207428646F63756D656E74292E756E62696E6428226D6F7573656D6F76652E222B746869732E7769646765744E616D652C746869732E5F6D6F7573654D6F766544656C6567617465292E756E62696E6428226D6F';
wwv_flow_api.g_varchar2_table(130) := '75736575702E222B746869732E7769646765744E616D652C746869732E5F6D6F757365557044656C6567617465292C746869732E5F6D6F75736553746172746564262628746869732E5F6D6F757365537461727465643D21312C652E7461726765743D3D';
wwv_flow_api.g_varchar2_table(131) := '3D746869732E5F6D6F757365446F776E4576656E742E7461726765742626742E6461746128652E7461726765742C746869732E7769646765744E616D652B222E70726576656E74436C69636B4576656E74222C2130292C746869732E5F6D6F7573655374';
wwv_flow_api.g_varchar2_table(132) := '6F70286529292C21317D2C5F6D6F75736544697374616E63654D65743A66756E6374696F6E2874297B72657475726E204D6174682E6D6178284D6174682E61627328746869732E5F6D6F757365446F776E4576656E742E70616765582D742E7061676558';
wwv_flow_api.g_varchar2_table(133) := '292C4D6174682E61627328746869732E5F6D6F757365446F776E4576656E742E70616765592D742E706167655929293E3D746869732E6F7074696F6E732E64697374616E63657D2C5F6D6F75736544656C61794D65743A66756E6374696F6E28297B7265';
wwv_flow_api.g_varchar2_table(134) := '7475726E20746869732E6D6F75736544656C61794D65747D2C5F6D6F75736553746172743A66756E6374696F6E28297B7D2C5F6D6F757365447261673A66756E6374696F6E28297B7D2C5F6D6F75736553746F703A66756E6374696F6E28297B7D2C5F6D';
wwv_flow_api.g_varchar2_table(135) := '6F757365436170747572653A66756E6374696F6E28297B72657475726E21307D7D297D29286A5175657279293B2866756E6374696F6E2874297B66756E6374696F6E206528742C652C69297B72657475726E20743E652626652B693E747D66756E637469';
wwv_flow_api.g_varchar2_table(136) := '6F6E20692874297B72657475726E2F6C6566747C72696768742F2E7465737428742E6373732822666C6F61742229297C7C2F696E6C696E657C7461626C652D63656C6C2F2E7465737428742E6373732822646973706C61792229297D742E776964676574';
wwv_flow_api.g_varchar2_table(137) := '282275692E736F727461626C65222C742E75692E6D6F7573652C7B76657273696F6E3A22312E31302E33222C7769646765744576656E745072656669783A22736F7274222C72656164793A21312C6F7074696F6E733A7B617070656E64546F3A22706172';
wwv_flow_api.g_varchar2_table(138) := '656E74222C617869733A21312C636F6E6E656374576974683A21312C636F6E7461696E6D656E743A21312C637572736F723A226175746F222C637572736F7241743A21312C64726F704F6E456D7074793A21302C666F726365506C616365686F6C646572';
wwv_flow_api.g_varchar2_table(139) := '53697A653A21312C666F72636548656C70657253697A653A21312C677269643A21312C68616E646C653A21312C68656C7065723A226F726967696E616C222C6974656D733A223E202A222C6F7061636974793A21312C706C616365686F6C6465723A2131';
wwv_flow_api.g_varchar2_table(140) := '2C7265766572743A21312C7363726F6C6C3A21302C7363726F6C6C53656E73697469766974793A32302C7363726F6C6C53706565643A32302C73636F70653A2264656661756C74222C746F6C6572616E63653A22696E74657273656374222C7A496E6465';
wwv_flow_api.g_varchar2_table(141) := '783A3165332C61637469766174653A6E756C6C2C6265666F726553746F703A6E756C6C2C6368616E67653A6E756C6C2C646561637469766174653A6E756C6C2C6F75743A6E756C6C2C6F7665723A6E756C6C2C726563656976653A6E756C6C2C72656D6F';
wwv_flow_api.g_varchar2_table(142) := '76653A6E756C6C2C736F72743A6E756C6C2C73746172743A6E756C6C2C73746F703A6E756C6C2C7570646174653A6E756C6C7D2C5F6372656174653A66756E6374696F6E28297B76617220743D746869732E6F7074696F6E733B746869732E636F6E7461';
wwv_flow_api.g_varchar2_table(143) := '696E657243616368653D7B7D2C746869732E656C656D656E742E616464436C617373282275692D736F727461626C6522292C746869732E7265667265736828292C746869732E666C6F6174696E673D746869732E6974656D732E6C656E6774683F227822';
wwv_flow_api.g_varchar2_table(144) := '3D3D3D742E617869737C7C6928746869732E6974656D735B305D2E6974656D293A21312C746869732E6F66667365743D746869732E656C656D656E742E6F666673657428292C746869732E5F6D6F757365496E697428292C746869732E72656164793D21';
wwv_flow_api.g_varchar2_table(145) := '307D2C5F64657374726F793A66756E6374696F6E28297B746869732E656C656D656E742E72656D6F7665436C617373282275692D736F727461626C652075692D736F727461626C652D64697361626C656422292C746869732E5F6D6F7573654465737472';
wwv_flow_api.g_varchar2_table(146) := '6F7928293B666F722876617220743D746869732E6974656D732E6C656E6774682D313B743E3D303B742D2D29746869732E6974656D735B745D2E6974656D2E72656D6F76654461746128746869732E7769646765744E616D652B222D6974656D22293B72';
wwv_flow_api.g_varchar2_table(147) := '657475726E20746869737D2C5F7365744F7074696F6E3A66756E6374696F6E28652C69297B2264697361626C6564223D3D3D653F28746869732E6F7074696F6E735B655D3D692C746869732E77696467657428292E746F67676C65436C61737328227569';
wwv_flow_api.g_varchar2_table(148) := '2D736F727461626C652D64697361626C6564222C21216929293A742E5769646765742E70726F746F747970652E5F7365744F7074696F6E2E6170706C7928746869732C617267756D656E7473297D2C5F6D6F757365436170747572653A66756E6374696F';
wwv_flow_api.g_varchar2_table(149) := '6E28652C69297B76617220733D6E756C6C2C6E3D21312C6F3D746869733B72657475726E20746869732E726576657274696E673F21313A746869732E6F7074696F6E732E64697361626C65647C7C22737461746963223D3D3D746869732E6F7074696F6E';
wwv_flow_api.g_varchar2_table(150) := '732E747970653F21313A28746869732E5F726566726573684974656D732865292C7428652E746172676574292E706172656E747328292E656163682866756E6374696F6E28297B72657475726E20742E6461746128746869732C6F2E7769646765744E61';
wwv_flow_api.g_varchar2_table(151) := '6D652B222D6974656D22293D3D3D6F3F28733D742874686973292C2131293A756E646566696E65647D292C742E6461746128652E7461726765742C6F2E7769646765744E616D652B222D6974656D22293D3D3D6F262628733D7428652E74617267657429';
wwv_flow_api.g_varchar2_table(152) := '292C733F21746869732E6F7074696F6E732E68616E646C657C7C697C7C287428746869732E6F7074696F6E732E68616E646C652C73292E66696E6428222A22292E6164644261636B28292E656163682866756E6374696F6E28297B746869733D3D3D652E';
wwv_flow_api.g_varchar2_table(153) := '7461726765742626286E3D2130297D292C6E293F28746869732E63757272656E744974656D3D732C746869732E5F72656D6F766543757272656E747346726F6D4974656D7328292C2130293A21313A2131297D2C5F6D6F75736553746172743A66756E63';
wwv_flow_api.g_varchar2_table(154) := '74696F6E28652C692C73297B766172206E2C6F2C613D746869732E6F7074696F6E733B696628746869732E63757272656E74436F6E7461696E65723D746869732C746869732E72656672657368506F736974696F6E7328292C746869732E68656C706572';
wwv_flow_api.g_varchar2_table(155) := '3D746869732E5F63726561746548656C7065722865292C746869732E5F636163686548656C70657250726F706F7274696F6E7328292C746869732E5F63616368654D617267696E7328292C746869732E7363726F6C6C506172656E743D746869732E6865';
wwv_flow_api.g_varchar2_table(156) := '6C7065722E7363726F6C6C506172656E7428292C746869732E6F66667365743D746869732E63757272656E744974656D2E6F666673657428292C746869732E6F66667365743D7B746F703A746869732E6F66667365742E746F702D746869732E6D617267';
wwv_flow_api.g_varchar2_table(157) := '696E732E746F702C6C6566743A746869732E6F66667365742E6C6566742D746869732E6D617267696E732E6C6566747D2C742E657874656E6428746869732E6F66667365742C7B636C69636B3A7B6C6566743A652E70616765582D746869732E6F666673';
wwv_flow_api.g_varchar2_table(158) := '65742E6C6566742C746F703A652E70616765592D746869732E6F66667365742E746F707D2C706172656E743A746869732E5F676574506172656E744F666673657428292C72656C61746976653A746869732E5F67657452656C61746976654F6666736574';
wwv_flow_api.g_varchar2_table(159) := '28297D292C746869732E68656C7065722E6373732822706F736974696F6E222C226162736F6C75746522292C746869732E637373506F736974696F6E3D746869732E68656C7065722E6373732822706F736974696F6E22292C746869732E6F726967696E';
wwv_flow_api.g_varchar2_table(160) := '616C506F736974696F6E3D746869732E5F67656E6572617465506F736974696F6E2865292C746869732E6F726967696E616C50616765583D652E70616765582C746869732E6F726967696E616C50616765593D652E70616765592C612E637572736F7241';
wwv_flow_api.g_varchar2_table(161) := '742626746869732E5F61646A7573744F666673657446726F6D48656C70657228612E637572736F724174292C746869732E646F6D506F736974696F6E3D7B707265763A746869732E63757272656E744974656D2E7072657628295B305D2C706172656E74';
wwv_flow_api.g_varchar2_table(162) := '3A746869732E63757272656E744974656D2E706172656E7428295B305D7D2C746869732E68656C7065725B305D213D3D746869732E63757272656E744974656D5B305D2626746869732E63757272656E744974656D2E6869646528292C746869732E5F63';
wwv_flow_api.g_varchar2_table(163) := '7265617465506C616365686F6C64657228292C612E636F6E7461696E6D656E742626746869732E5F736574436F6E7461696E6D656E7428292C612E637572736F722626226175746F22213D3D612E637572736F722626286F3D746869732E646F63756D65';
wwv_flow_api.g_varchar2_table(164) := '6E742E66696E642822626F647922292C746869732E73746F726564437572736F723D6F2E6373732822637572736F7222292C6F2E6373732822637572736F72222C612E637572736F72292C746869732E73746F7265645374796C6573686565743D742822';
wwv_flow_api.g_varchar2_table(165) := '3C7374796C653E2A7B20637572736F723A20222B612E637572736F722B222021696D706F7274616E743B207D3C2F7374796C653E22292E617070656E64546F286F29292C612E6F706163697479262628746869732E68656C7065722E63737328226F7061';
wwv_flow_api.g_varchar2_table(166) := '636974792229262628746869732E5F73746F7265644F7061636974793D746869732E68656C7065722E63737328226F7061636974792229292C746869732E68656C7065722E63737328226F706163697479222C612E6F70616369747929292C612E7A496E';
wwv_flow_api.g_varchar2_table(167) := '646578262628746869732E68656C7065722E63737328227A496E6465782229262628746869732E5F73746F7265645A496E6465783D746869732E68656C7065722E63737328227A496E6465782229292C746869732E68656C7065722E63737328227A496E';
wwv_flow_api.g_varchar2_table(168) := '646578222C612E7A496E64657829292C746869732E7363726F6C6C506172656E745B305D213D3D646F63756D656E7426262248544D4C22213D3D746869732E7363726F6C6C506172656E745B305D2E7461674E616D65262628746869732E6F766572666C';
wwv_flow_api.g_varchar2_table(169) := '6F774F66667365743D746869732E7363726F6C6C506172656E742E6F66667365742829292C746869732E5F7472696767657228227374617274222C652C746869732E5F7569486173682829292C746869732E5F707265736572766548656C70657250726F';
wwv_flow_api.g_varchar2_table(170) := '706F7274696F6E737C7C746869732E5F636163686548656C70657250726F706F7274696F6E7328292C217329666F72286E3D746869732E636F6E7461696E6572732E6C656E6774682D313B6E3E3D303B6E2D2D29746869732E636F6E7461696E6572735B';
wwv_flow_api.g_varchar2_table(171) := '6E5D2E5F7472696767657228226163746976617465222C652C746869732E5F756948617368287468697329293B72657475726E20742E75692E64646D616E61676572262628742E75692E64646D616E616765722E63757272656E743D74686973292C742E';
wwv_flow_api.g_varchar2_table(172) := '75692E64646D616E61676572262621612E64726F704265686176696F75722626742E75692E64646D616E616765722E707265706172654F66667365747328746869732C65292C746869732E6472616767696E673D21302C746869732E68656C7065722E61';
wwv_flow_api.g_varchar2_table(173) := '6464436C617373282275692D736F727461626C652D68656C70657222292C746869732E5F6D6F757365447261672865292C21307D2C5F6D6F757365447261673A66756E6374696F6E2865297B76617220692C732C6E2C6F2C613D746869732E6F7074696F';
wwv_flow_api.g_varchar2_table(174) := '6E732C723D21313B666F7228746869732E706F736974696F6E3D746869732E5F67656E6572617465506F736974696F6E2865292C746869732E706F736974696F6E4162733D746869732E5F636F6E76657274506F736974696F6E546F28226162736F6C75';
wwv_flow_api.g_varchar2_table(175) := '746522292C746869732E6C617374506F736974696F6E4162737C7C28746869732E6C617374506F736974696F6E4162733D746869732E706F736974696F6E416273292C746869732E6F7074696F6E732E7363726F6C6C262628746869732E7363726F6C6C';
wwv_flow_api.g_varchar2_table(176) := '506172656E745B305D213D3D646F63756D656E7426262248544D4C22213D3D746869732E7363726F6C6C506172656E745B305D2E7461674E616D653F28746869732E6F766572666C6F774F66667365742E746F702B746869732E7363726F6C6C50617265';
wwv_flow_api.g_varchar2_table(177) := '6E745B305D2E6F66667365744865696768742D652E70616765593C612E7363726F6C6C53656E73697469766974793F746869732E7363726F6C6C506172656E745B305D2E7363726F6C6C546F703D723D746869732E7363726F6C6C506172656E745B305D';
wwv_flow_api.g_varchar2_table(178) := '2E7363726F6C6C546F702B612E7363726F6C6C53706565643A652E70616765592D746869732E6F766572666C6F774F66667365742E746F703C612E7363726F6C6C53656E7369746976697479262628746869732E7363726F6C6C506172656E745B305D2E';
wwv_flow_api.g_varchar2_table(179) := '7363726F6C6C546F703D723D746869732E7363726F6C6C506172656E745B305D2E7363726F6C6C546F702D612E7363726F6C6C5370656564292C746869732E6F766572666C6F774F66667365742E6C6566742B746869732E7363726F6C6C506172656E74';
wwv_flow_api.g_varchar2_table(180) := '5B305D2E6F666673657457696474682D652E70616765583C612E7363726F6C6C53656E73697469766974793F746869732E7363726F6C6C506172656E745B305D2E7363726F6C6C4C6566743D723D746869732E7363726F6C6C506172656E745B305D2E73';
wwv_flow_api.g_varchar2_table(181) := '63726F6C6C4C6566742B612E7363726F6C6C53706565643A652E70616765582D746869732E6F766572666C6F774F66667365742E6C6566743C612E7363726F6C6C53656E7369746976697479262628746869732E7363726F6C6C506172656E745B305D2E';
wwv_flow_api.g_varchar2_table(182) := '7363726F6C6C4C6566743D723D746869732E7363726F6C6C506172656E745B305D2E7363726F6C6C4C6566742D612E7363726F6C6C537065656429293A28652E70616765592D7428646F63756D656E74292E7363726F6C6C546F7028293C612E7363726F';
wwv_flow_api.g_varchar2_table(183) := '6C6C53656E73697469766974793F723D7428646F63756D656E74292E7363726F6C6C546F70287428646F63756D656E74292E7363726F6C6C546F7028292D612E7363726F6C6C5370656564293A742877696E646F77292E68656967687428292D28652E70';
wwv_flow_api.g_varchar2_table(184) := '616765592D7428646F63756D656E74292E7363726F6C6C546F702829293C612E7363726F6C6C53656E7369746976697479262628723D7428646F63756D656E74292E7363726F6C6C546F70287428646F63756D656E74292E7363726F6C6C546F7028292B';
wwv_flow_api.g_varchar2_table(185) := '612E7363726F6C6C537065656429292C652E70616765582D7428646F63756D656E74292E7363726F6C6C4C65667428293C612E7363726F6C6C53656E73697469766974793F723D7428646F63756D656E74292E7363726F6C6C4C656674287428646F6375';
wwv_flow_api.g_varchar2_table(186) := '6D656E74292E7363726F6C6C4C65667428292D612E7363726F6C6C5370656564293A742877696E646F77292E776964746828292D28652E70616765582D7428646F63756D656E74292E7363726F6C6C4C6566742829293C612E7363726F6C6C53656E7369';
wwv_flow_api.g_varchar2_table(187) := '746976697479262628723D7428646F63756D656E74292E7363726F6C6C4C656674287428646F63756D656E74292E7363726F6C6C4C65667428292B612E7363726F6C6C53706565642929292C72213D3D21312626742E75692E64646D616E616765722626';
wwv_flow_api.g_varchar2_table(188) := '21612E64726F704265686176696F75722626742E75692E64646D616E616765722E707265706172654F66667365747328746869732C6529292C746869732E706F736974696F6E4162733D746869732E5F636F6E76657274506F736974696F6E546F282261';
wwv_flow_api.g_varchar2_table(189) := '62736F6C75746522292C746869732E6F7074696F6E732E6178697326262279223D3D3D746869732E6F7074696F6E732E617869737C7C28746869732E68656C7065725B305D2E7374796C652E6C6566743D746869732E706F736974696F6E2E6C6566742B';
wwv_flow_api.g_varchar2_table(190) := '22707822292C746869732E6F7074696F6E732E6178697326262278223D3D3D746869732E6F7074696F6E732E617869737C7C28746869732E68656C7065725B305D2E7374796C652E746F703D746869732E706F736974696F6E2E746F702B22707822292C';
wwv_flow_api.g_varchar2_table(191) := '693D746869732E6974656D732E6C656E6774682D313B693E3D303B692D2D29696628733D746869732E6974656D735B695D2C6E3D732E6974656D5B305D2C6F3D746869732E5F696E746572736563747357697468506F696E7465722873292C6F2626732E';
wwv_flow_api.g_varchar2_table(192) := '696E7374616E63653D3D3D746869732E63757272656E74436F6E7461696E657226266E213D3D746869732E63757272656E744974656D5B305D2626746869732E706C616365686F6C6465725B313D3D3D6F3F226E657874223A2270726576225D28295B30';
wwv_flow_api.g_varchar2_table(193) := '5D213D3D6E262621742E636F6E7461696E7328746869732E706C616365686F6C6465725B305D2C6E292626282273656D692D64796E616D6963223D3D3D746869732E6F7074696F6E732E747970653F21742E636F6E7461696E7328746869732E656C656D';
wwv_flow_api.g_varchar2_table(194) := '656E745B305D2C6E293A213029297B696628746869732E646972656374696F6E3D313D3D3D6F3F22646F776E223A227570222C22706F696E74657222213D3D746869732E6F7074696F6E732E746F6C6572616E6365262621746869732E5F696E74657273';
wwv_flow_api.g_varchar2_table(195) := '6563747357697468536964657328732929627265616B3B746869732E5F7265617272616E676528652C73292C746869732E5F7472696767657228226368616E6765222C652C746869732E5F7569486173682829293B627265616B7D72657475726E207468';
wwv_flow_api.g_varchar2_table(196) := '69732E5F636F6E74616374436F6E7461696E6572732865292C742E75692E64646D616E616765722626742E75692E64646D616E616765722E6472616728746869732C65292C746869732E5F747269676765722822736F7274222C652C746869732E5F7569';
wwv_flow_api.g_varchar2_table(197) := '486173682829292C746869732E6C617374506F736974696F6E4162733D746869732E706F736974696F6E4162732C21317D2C5F6D6F75736553746F703A66756E6374696F6E28652C69297B69662865297B696628742E75692E64646D616E616765722626';
wwv_flow_api.g_varchar2_table(198) := '21746869732E6F7074696F6E732E64726F704265686176696F75722626742E75692E64646D616E616765722E64726F7028746869732C65292C746869732E6F7074696F6E732E726576657274297B76617220733D746869732C6E3D746869732E706C6163';
wwv_flow_api.g_varchar2_table(199) := '65686F6C6465722E6F666673657428292C6F3D746869732E6F7074696F6E732E617869732C613D7B7D3B6F2626227822213D3D6F7C7C28612E6C6566743D6E2E6C6566742D746869732E6F66667365742E706172656E742E6C6566742D746869732E6D61';
wwv_flow_api.g_varchar2_table(200) := '7267696E732E6C6566742B28746869732E6F6666736574506172656E745B305D3D3D3D646F63756D656E742E626F64793F303A746869732E6F6666736574506172656E745B305D2E7363726F6C6C4C65667429292C6F2626227922213D3D6F7C7C28612E';
wwv_flow_api.g_varchar2_table(201) := '746F703D6E2E746F702D746869732E6F66667365742E706172656E742E746F702D746869732E6D617267696E732E746F702B28746869732E6F6666736574506172656E745B305D3D3D3D646F63756D656E742E626F64793F303A746869732E6F66667365';
wwv_flow_api.g_varchar2_table(202) := '74506172656E745B305D2E7363726F6C6C546F7029292C746869732E726576657274696E673D21302C7428746869732E68656C706572292E616E696D61746528612C7061727365496E7428746869732E6F7074696F6E732E7265766572742C3130297C7C';
wwv_flow_api.g_varchar2_table(203) := '3530302C66756E6374696F6E28297B732E5F636C6561722865297D297D656C736520746869732E5F636C65617228652C69293B72657475726E21317D7D2C63616E63656C3A66756E6374696F6E28297B696628746869732E6472616767696E67297B7468';
wwv_flow_api.g_varchar2_table(204) := '69732E5F6D6F7573655570287B7461726765743A6E756C6C7D292C226F726967696E616C223D3D3D746869732E6F7074696F6E732E68656C7065723F746869732E63757272656E744974656D2E63737328746869732E5F73746F726564435353292E7265';
wwv_flow_api.g_varchar2_table(205) := '6D6F7665436C617373282275692D736F727461626C652D68656C70657222293A746869732E63757272656E744974656D2E73686F7728293B666F722876617220653D746869732E636F6E7461696E6572732E6C656E6774682D313B653E3D303B652D2D29';
wwv_flow_api.g_varchar2_table(206) := '746869732E636F6E7461696E6572735B655D2E5F74726967676572282264656163746976617465222C6E756C6C2C746869732E5F756948617368287468697329292C746869732E636F6E7461696E6572735B655D2E636F6E7461696E657243616368652E';
wwv_flow_api.g_varchar2_table(207) := '6F766572262628746869732E636F6E7461696E6572735B655D2E5F7472696767657228226F7574222C6E756C6C2C746869732E5F756948617368287468697329292C746869732E636F6E7461696E6572735B655D2E636F6E7461696E657243616368652E';
wwv_flow_api.g_varchar2_table(208) := '6F7665723D30297D72657475726E20746869732E706C616365686F6C646572262628746869732E706C616365686F6C6465725B305D2E706172656E744E6F64652626746869732E706C616365686F6C6465725B305D2E706172656E744E6F64652E72656D';
wwv_flow_api.g_varchar2_table(209) := '6F76654368696C6428746869732E706C616365686F6C6465725B305D292C226F726967696E616C22213D3D746869732E6F7074696F6E732E68656C7065722626746869732E68656C7065722626746869732E68656C7065725B305D2E706172656E744E6F';
wwv_flow_api.g_varchar2_table(210) := '64652626746869732E68656C7065722E72656D6F766528292C742E657874656E6428746869732C7B68656C7065723A6E756C6C2C6472616767696E673A21312C726576657274696E673A21312C5F6E6F46696E616C536F72743A6E756C6C7D292C746869';
wwv_flow_api.g_varchar2_table(211) := '732E646F6D506F736974696F6E2E707265763F7428746869732E646F6D506F736974696F6E2E70726576292E616674657228746869732E63757272656E744974656D293A7428746869732E646F6D506F736974696F6E2E706172656E74292E7072657065';
wwv_flow_api.g_varchar2_table(212) := '6E6428746869732E63757272656E744974656D29292C746869737D2C73657269616C697A653A66756E6374696F6E2865297B76617220693D746869732E5F6765744974656D7341736A517565727928652626652E636F6E6E6563746564292C733D5B5D3B';
wwv_flow_api.g_varchar2_table(213) := '72657475726E20653D657C7C7B7D2C742869292E656163682866756E6374696F6E28297B76617220693D287428652E6974656D7C7C74686973292E6174747228652E6174747269627574657C7C22696422297C7C2222292E6D6174636828652E65787072';
wwv_flow_api.g_varchar2_table(214) := '657373696F6E7C7C2F282E2B295B5C2D3D5F5D282E2B292F293B692626732E707573682828652E6B65797C7C695B315D2B225B5D22292B223D222B28652E6B65792626652E65787072657373696F6E3F695B315D3A695B325D29297D292C21732E6C656E';
wwv_flow_api.g_varchar2_table(215) := '6774682626652E6B65792626732E7075736828652E6B65792B223D22292C732E6A6F696E28222622297D2C746F41727261793A66756E6374696F6E2865297B76617220693D746869732E5F6765744974656D7341736A517565727928652626652E636F6E';
wwv_flow_api.g_varchar2_table(216) := '6E6563746564292C733D5B5D3B72657475726E20653D657C7C7B7D2C692E656163682866756E6374696F6E28297B732E70757368287428652E6974656D7C7C74686973292E6174747228652E6174747269627574657C7C22696422297C7C2222297D292C';
wwv_flow_api.g_varchar2_table(217) := '737D2C5F696E7465727365637473576974683A66756E6374696F6E2874297B76617220653D746869732E706F736974696F6E4162732E6C6566742C693D652B746869732E68656C70657250726F706F7274696F6E732E77696474682C733D746869732E70';
wwv_flow_api.g_varchar2_table(218) := '6F736974696F6E4162732E746F702C6E3D732B746869732E68656C70657250726F706F7274696F6E732E6865696768742C6F3D742E6C6566742C613D6F2B742E77696474682C723D742E746F702C683D722B742E6865696768742C6C3D746869732E6F66';
wwv_flow_api.g_varchar2_table(219) := '667365742E636C69636B2E746F702C633D746869732E6F66667365742E636C69636B2E6C6566742C753D2278223D3D3D746869732E6F7074696F6E732E617869737C7C732B6C3E722626683E732B6C2C643D2279223D3D3D746869732E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(220) := '2E617869737C7C652B633E6F2626613E652B632C703D752626643B72657475726E22706F696E746572223D3D3D746869732E6F7074696F6E732E746F6C6572616E63657C7C746869732E6F7074696F6E732E666F726365506F696E746572466F72436F6E';
wwv_flow_api.g_varchar2_table(221) := '7461696E6572737C7C22706F696E74657222213D3D746869732E6F7074696F6E732E746F6C6572616E63652626746869732E68656C70657250726F706F7274696F6E735B746869732E666C6F6174696E673F227769647468223A22686569676874225D3E';
wwv_flow_api.g_varchar2_table(222) := '745B746869732E666C6F6174696E673F227769647468223A22686569676874225D3F703A652B746869732E68656C70657250726F706F7274696F6E732E77696474682F323E6F2626613E692D746869732E68656C70657250726F706F7274696F6E732E77';
wwv_flow_api.g_varchar2_table(223) := '696474682F322626732B746869732E68656C70657250726F706F7274696F6E732E6865696768742F323E722626683E6E2D746869732E68656C70657250726F706F7274696F6E732E6865696768742F327D2C5F696E746572736563747357697468506F69';
wwv_flow_api.g_varchar2_table(224) := '6E7465723A66756E6374696F6E2874297B76617220693D2278223D3D3D746869732E6F7074696F6E732E617869737C7C6528746869732E706F736974696F6E4162732E746F702B746869732E6F66667365742E636C69636B2E746F702C742E746F702C74';
wwv_flow_api.g_varchar2_table(225) := '2E686569676874292C733D2279223D3D3D746869732E6F7074696F6E732E617869737C7C6528746869732E706F736974696F6E4162732E6C6566742B746869732E6F66667365742E636C69636B2E6C6566742C742E6C6566742C742E7769647468292C6E';
wwv_flow_api.g_varchar2_table(226) := '3D692626732C6F3D746869732E5F67657444726167566572746963616C446972656374696F6E28292C613D746869732E5F67657444726167486F72697A6F6E74616C446972656374696F6E28293B72657475726E206E3F746869732E666C6F6174696E67';
wwv_flow_api.g_varchar2_table(227) := '3F612626227269676874223D3D3D617C7C22646F776E223D3D3D6F3F323A313A6F26262822646F776E223D3D3D6F3F323A31293A21317D2C5F696E74657273656374735769746853696465733A66756E6374696F6E2874297B76617220693D6528746869';
wwv_flow_api.g_varchar2_table(228) := '732E706F736974696F6E4162732E746F702B746869732E6F66667365742E636C69636B2E746F702C742E746F702B742E6865696768742F322C742E686569676874292C733D6528746869732E706F736974696F6E4162732E6C6566742B746869732E6F66';
wwv_flow_api.g_varchar2_table(229) := '667365742E636C69636B2E6C6566742C742E6C6566742B742E77696474682F322C742E7769647468292C6E3D746869732E5F67657444726167566572746963616C446972656374696F6E28292C6F3D746869732E5F67657444726167486F72697A6F6E74';
wwv_flow_api.g_varchar2_table(230) := '616C446972656374696F6E28293B72657475726E20746869732E666C6F6174696E6726266F3F227269676874223D3D3D6F2626737C7C226C656674223D3D3D6F262621733A6E26262822646F776E223D3D3D6E2626697C7C227570223D3D3D6E26262169';
wwv_flow_api.g_varchar2_table(231) := '297D2C5F67657444726167566572746963616C446972656374696F6E3A66756E6374696F6E28297B76617220743D746869732E706F736974696F6E4162732E746F702D746869732E6C617374506F736974696F6E4162732E746F703B72657475726E2030';
wwv_flow_api.g_varchar2_table(232) := '213D3D74262628743E303F22646F776E223A22757022297D2C5F67657444726167486F72697A6F6E74616C446972656374696F6E3A66756E6374696F6E28297B76617220743D746869732E706F736974696F6E4162732E6C6566742D746869732E6C6173';
wwv_flow_api.g_varchar2_table(233) := '74506F736974696F6E4162732E6C6566743B72657475726E2030213D3D74262628743E303F227269676874223A226C65667422297D2C726566726573683A66756E6374696F6E2874297B72657475726E20746869732E5F726566726573684974656D7328';
wwv_flow_api.g_varchar2_table(234) := '74292C746869732E72656672657368506F736974696F6E7328292C746869737D2C5F636F6E6E656374576974683A66756E6374696F6E28297B76617220743D746869732E6F7074696F6E733B72657475726E20742E636F6E6E656374576974682E636F6E';
wwv_flow_api.g_varchar2_table(235) := '7374727563746F723D3D3D537472696E673F5B742E636F6E6E656374576974685D3A742E636F6E6E656374576974687D2C5F6765744974656D7341736A51756572793A66756E6374696F6E2865297B76617220692C732C6E2C6F2C613D5B5D2C723D5B5D';
wwv_flow_api.g_varchar2_table(236) := '2C683D746869732E5F636F6E6E6563745769746828293B6966286826266529666F7228693D682E6C656E6774682D313B693E3D303B692D2D29666F72286E3D7428685B695D292C733D6E2E6C656E6774682D313B733E3D303B732D2D296F3D742E646174';
wwv_flow_api.g_varchar2_table(237) := '61286E5B735D2C746869732E77696467657446756C6C4E616D65292C6F26266F213D3D746869732626216F2E6F7074696F6E732E64697361626C65642626722E70757368285B742E697346756E6374696F6E286F2E6F7074696F6E732E6974656D73293F';
wwv_flow_api.g_varchar2_table(238) := '6F2E6F7074696F6E732E6974656D732E63616C6C286F2E656C656D656E74293A74286F2E6F7074696F6E732E6974656D732C6F2E656C656D656E74292E6E6F7428222E75692D736F727461626C652D68656C70657222292E6E6F7428222E75692D736F72';
wwv_flow_api.g_varchar2_table(239) := '7461626C652D706C616365686F6C64657222292C6F5D293B666F7228722E70757368285B742E697346756E6374696F6E28746869732E6F7074696F6E732E6974656D73293F746869732E6F7074696F6E732E6974656D732E63616C6C28746869732E656C';
wwv_flow_api.g_varchar2_table(240) := '656D656E742C6E756C6C2C7B6F7074696F6E733A746869732E6F7074696F6E732C6974656D3A746869732E63757272656E744974656D7D293A7428746869732E6F7074696F6E732E6974656D732C746869732E656C656D656E74292E6E6F7428222E7569';
wwv_flow_api.g_varchar2_table(241) := '2D736F727461626C652D68656C70657222292E6E6F7428222E75692D736F727461626C652D706C616365686F6C64657222292C746869735D292C693D722E6C656E6774682D313B693E3D303B692D2D29725B695D5B305D2E656163682866756E6374696F';
wwv_flow_api.g_varchar2_table(242) := '6E28297B612E707573682874686973297D293B72657475726E20742861297D2C5F72656D6F766543757272656E747346726F6D4974656D733A66756E6374696F6E28297B76617220653D746869732E63757272656E744974656D2E66696E6428223A6461';
wwv_flow_api.g_varchar2_table(243) := '746128222B746869732E7769646765744E616D652B222D6974656D2922293B746869732E6974656D733D742E6772657028746869732E6974656D732C66756E6374696F6E2874297B666F722876617220693D303B652E6C656E6774683E693B692B2B2969';
wwv_flow_api.g_varchar2_table(244) := '6628655B695D3D3D3D742E6974656D5B305D2972657475726E21313B72657475726E21307D297D2C5F726566726573684974656D733A66756E6374696F6E2865297B746869732E6974656D733D5B5D2C746869732E636F6E7461696E6572733D5B746869';
wwv_flow_api.g_varchar2_table(245) := '735D3B76617220692C732C6E2C6F2C612C722C682C6C2C633D746869732E6974656D732C753D5B5B742E697346756E6374696F6E28746869732E6F7074696F6E732E6974656D73293F746869732E6F7074696F6E732E6974656D732E63616C6C28746869';
wwv_flow_api.g_varchar2_table(246) := '732E656C656D656E745B305D2C652C7B6974656D3A746869732E63757272656E744974656D7D293A7428746869732E6F7074696F6E732E6974656D732C746869732E656C656D656E74292C746869735D5D2C643D746869732E5F636F6E6E656374576974';
wwv_flow_api.g_varchar2_table(247) := '6828293B696628642626746869732E726561647929666F7228693D642E6C656E6774682D313B693E3D303B692D2D29666F72286E3D7428645B695D292C733D6E2E6C656E6774682D313B733E3D303B732D2D296F3D742E64617461286E5B735D2C746869';
wwv_flow_api.g_varchar2_table(248) := '732E77696467657446756C6C4E616D65292C6F26266F213D3D746869732626216F2E6F7074696F6E732E64697361626C6564262628752E70757368285B742E697346756E6374696F6E286F2E6F7074696F6E732E6974656D73293F6F2E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(249) := '2E6974656D732E63616C6C286F2E656C656D656E745B305D2C652C7B6974656D3A746869732E63757272656E744974656D7D293A74286F2E6F7074696F6E732E6974656D732C6F2E656C656D656E74292C6F5D292C746869732E636F6E7461696E657273';
wwv_flow_api.g_varchar2_table(250) := '2E70757368286F29293B666F7228693D752E6C656E6774682D313B693E3D303B692D2D29666F7228613D755B695D5B315D2C723D755B695D5B305D2C733D302C6C3D722E6C656E6774683B6C3E733B732B2B29683D7428725B735D292C682E6461746128';
wwv_flow_api.g_varchar2_table(251) := '746869732E7769646765744E616D652B222D6974656D222C61292C632E70757368287B6974656D3A682C696E7374616E63653A612C77696474683A302C6865696768743A302C6C6566743A302C746F703A307D297D2C72656672657368506F736974696F';
wwv_flow_api.g_varchar2_table(252) := '6E733A66756E6374696F6E2865297B746869732E6F6666736574506172656E742626746869732E68656C706572262628746869732E6F66667365742E706172656E743D746869732E5F676574506172656E744F66667365742829293B76617220692C732C';
wwv_flow_api.g_varchar2_table(253) := '6E2C6F3B666F7228693D746869732E6974656D732E6C656E6774682D313B693E3D303B692D2D29733D746869732E6974656D735B695D2C732E696E7374616E6365213D3D746869732E63757272656E74436F6E7461696E65722626746869732E63757272';
wwv_flow_api.g_varchar2_table(254) := '656E74436F6E7461696E65722626732E6974656D5B305D213D3D746869732E63757272656E744974656D5B305D7C7C286E3D746869732E6F7074696F6E732E746F6C6572616E6365456C656D656E743F7428746869732E6F7074696F6E732E746F6C6572';
wwv_flow_api.g_varchar2_table(255) := '616E6365456C656D656E742C732E6974656D293A732E6974656D2C657C7C28732E77696474683D6E2E6F75746572576964746828292C732E6865696768743D6E2E6F757465724865696768742829292C6F3D6E2E6F666673657428292C732E6C6566743D';
wwv_flow_api.g_varchar2_table(256) := '6F2E6C6566742C732E746F703D6F2E746F70293B696628746869732E6F7074696F6E732E637573746F6D2626746869732E6F7074696F6E732E637573746F6D2E72656672657368436F6E7461696E65727329746869732E6F7074696F6E732E637573746F';
wwv_flow_api.g_varchar2_table(257) := '6D2E72656672657368436F6E7461696E6572732E63616C6C2874686973293B656C736520666F7228693D746869732E636F6E7461696E6572732E6C656E6774682D313B693E3D303B692D2D296F3D746869732E636F6E7461696E6572735B695D2E656C65';
wwv_flow_api.g_varchar2_table(258) := '6D656E742E6F666673657428292C746869732E636F6E7461696E6572735B695D2E636F6E7461696E657243616368652E6C6566743D6F2E6C6566742C746869732E636F6E7461696E6572735B695D2E636F6E7461696E657243616368652E746F703D6F2E';
wwv_flow_api.g_varchar2_table(259) := '746F702C746869732E636F6E7461696E6572735B695D2E636F6E7461696E657243616368652E77696474683D746869732E636F6E7461696E6572735B695D2E656C656D656E742E6F75746572576964746828292C746869732E636F6E7461696E6572735B';
wwv_flow_api.g_varchar2_table(260) := '695D2E636F6E7461696E657243616368652E6865696768743D746869732E636F6E7461696E6572735B695D2E656C656D656E742E6F7574657248656967687428293B72657475726E20746869737D2C5F637265617465506C616365686F6C6465723A6675';
wwv_flow_api.g_varchar2_table(261) := '6E6374696F6E2865297B653D657C7C746869733B76617220692C733D652E6F7074696F6E733B732E706C616365686F6C6465722626732E706C616365686F6C6465722E636F6E7374727563746F72213D3D537472696E677C7C28693D732E706C61636568';
wwv_flow_api.g_varchar2_table(262) := '6F6C6465722C732E706C616365686F6C6465723D7B656C656D656E743A66756E6374696F6E28297B76617220733D652E63757272656E744974656D5B305D2E6E6F64654E616D652E746F4C6F7765724361736528292C6E3D7428223C222B732B223E222C';
wwv_flow_api.g_varchar2_table(263) := '652E646F63756D656E745B305D292E616464436C61737328697C7C652E63757272656E744974656D5B305D2E636C6173734E616D652B222075692D736F727461626C652D706C616365686F6C64657222292E72656D6F7665436C617373282275692D736F';
wwv_flow_api.g_varchar2_table(264) := '727461626C652D68656C70657222293B72657475726E227472223D3D3D733F652E63757272656E744974656D2E6368696C6472656E28292E656163682866756E6374696F6E28297B7428223C74643E26233136303B3C2F74643E222C652E646F63756D65';
wwv_flow_api.g_varchar2_table(265) := '6E745B305D292E617474722822636F6C7370616E222C742874686973292E617474722822636F6C7370616E22297C7C31292E617070656E64546F286E297D293A22696D67223D3D3D7326266E2E617474722822737263222C652E63757272656E74497465';
wwv_flow_api.g_varchar2_table(266) := '6D2E6174747228227372632229292C697C7C6E2E63737328227669736962696C697479222C2268696464656E22292C6E7D2C7570646174653A66756E6374696F6E28742C6E297B2821697C7C732E666F726365506C616365686F6C64657253697A652926';
wwv_flow_api.g_varchar2_table(267) := '26286E2E68656967687428297C7C6E2E68656967687428652E63757272656E744974656D2E696E6E657248656967687428292D7061727365496E7428652E63757272656E744974656D2E637373282270616464696E67546F7022297C7C302C3130292D70';
wwv_flow_api.g_varchar2_table(268) := '61727365496E7428652E63757272656E744974656D2E637373282270616464696E67426F74746F6D22297C7C302C313029292C6E2E776964746828297C7C6E2E776964746828652E63757272656E744974656D2E696E6E6572576964746828292D706172';
wwv_flow_api.g_varchar2_table(269) := '7365496E7428652E63757272656E744974656D2E637373282270616464696E674C65667422297C7C302C3130292D7061727365496E7428652E63757272656E744974656D2E637373282270616464696E67526967687422297C7C302C31302929297D7D29';
wwv_flow_api.g_varchar2_table(270) := '2C652E706C616365686F6C6465723D7428732E706C616365686F6C6465722E656C656D656E742E63616C6C28652E656C656D656E742C652E63757272656E744974656D29292C652E63757272656E744974656D2E616674657228652E706C616365686F6C';
wwv_flow_api.g_varchar2_table(271) := '646572292C732E706C616365686F6C6465722E75706461746528652C652E706C616365686F6C646572297D2C5F636F6E74616374436F6E7461696E6572733A66756E6374696F6E2873297B766172206E2C6F2C612C722C682C6C2C632C752C642C702C66';
wwv_flow_api.g_varchar2_table(272) := '3D6E756C6C2C673D6E756C6C3B666F72286E3D746869732E636F6E7461696E6572732E6C656E6774682D313B6E3E3D303B6E2D2D2969662821742E636F6E7461696E7328746869732E63757272656E744974656D5B305D2C746869732E636F6E7461696E';
wwv_flow_api.g_varchar2_table(273) := '6572735B6E5D2E656C656D656E745B305D2929696628746869732E5F696E74657273656374735769746828746869732E636F6E7461696E6572735B6E5D2E636F6E7461696E6572436163686529297B696628662626742E636F6E7461696E732874686973';
wwv_flow_api.g_varchar2_table(274) := '2E636F6E7461696E6572735B6E5D2E656C656D656E745B305D2C662E656C656D656E745B305D2929636F6E74696E75653B663D746869732E636F6E7461696E6572735B6E5D2C673D6E7D656C736520746869732E636F6E7461696E6572735B6E5D2E636F';
wwv_flow_api.g_varchar2_table(275) := '6E7461696E657243616368652E6F766572262628746869732E636F6E7461696E6572735B6E5D2E5F7472696767657228226F7574222C732C746869732E5F756948617368287468697329292C746869732E636F6E7461696E6572735B6E5D2E636F6E7461';
wwv_flow_api.g_varchar2_table(276) := '696E657243616368652E6F7665723D30293B6966286629696628313D3D3D746869732E636F6E7461696E6572732E6C656E67746829746869732E636F6E7461696E6572735B675D2E636F6E7461696E657243616368652E6F7665727C7C28746869732E63';
wwv_flow_api.g_varchar2_table(277) := '6F6E7461696E6572735B675D2E5F7472696767657228226F766572222C732C746869732E5F756948617368287468697329292C746869732E636F6E7461696E6572735B675D2E636F6E7461696E657243616368652E6F7665723D31293B656C73657B666F';
wwv_flow_api.g_varchar2_table(278) := '7228613D3165342C723D6E756C6C2C703D662E666C6F6174696E677C7C6928746869732E63757272656E744974656D292C683D703F226C656674223A22746F70222C6C3D703F227769647468223A22686569676874222C633D746869732E706F73697469';
wwv_flow_api.g_varchar2_table(279) := '6F6E4162735B685D2B746869732E6F66667365742E636C69636B5B685D2C6F3D746869732E6974656D732E6C656E6774682D313B6F3E3D303B6F2D2D29742E636F6E7461696E7328746869732E636F6E7461696E6572735B675D2E656C656D656E745B30';
wwv_flow_api.g_varchar2_table(280) := '5D2C746869732E6974656D735B6F5D2E6974656D5B305D292626746869732E6974656D735B6F5D2E6974656D5B305D213D3D746869732E63757272656E744974656D5B305D26262821707C7C6528746869732E706F736974696F6E4162732E746F702B74';
wwv_flow_api.g_varchar2_table(281) := '6869732E6F66667365742E636C69636B2E746F702C746869732E6974656D735B6F5D2E746F702C746869732E6974656D735B6F5D2E6865696768742929262628753D746869732E6974656D735B6F5D2E6974656D2E6F666673657428295B685D2C643D21';
wwv_flow_api.g_varchar2_table(282) := '312C4D6174682E61627328752D63293E4D6174682E61627328752B746869732E6974656D735B6F5D5B6C5D2D6329262628643D21302C752B3D746869732E6974656D735B6F5D5B6C5D292C613E4D6174682E61627328752D6329262628613D4D6174682E';
wwv_flow_api.g_varchar2_table(283) := '61627328752D63292C723D746869732E6974656D735B6F5D2C746869732E646972656374696F6E3D643F227570223A22646F776E2229293B6966282172262621746869732E6F7074696F6E732E64726F704F6E456D7074792972657475726E3B69662874';
wwv_flow_api.g_varchar2_table(284) := '6869732E63757272656E74436F6E7461696E65723D3D3D746869732E636F6E7461696E6572735B675D2972657475726E3B723F746869732E5F7265617272616E676528732C722C6E756C6C2C2130293A746869732E5F7265617272616E676528732C6E75';
wwv_flow_api.g_varchar2_table(285) := '6C6C2C746869732E636F6E7461696E6572735B675D2E656C656D656E742C2130292C746869732E5F7472696767657228226368616E6765222C732C746869732E5F7569486173682829292C746869732E636F6E7461696E6572735B675D2E5F7472696767';
wwv_flow_api.g_varchar2_table(286) := '657228226368616E6765222C732C746869732E5F756948617368287468697329292C746869732E63757272656E74436F6E7461696E65723D746869732E636F6E7461696E6572735B675D2C746869732E6F7074696F6E732E706C616365686F6C6465722E';
wwv_flow_api.g_varchar2_table(287) := '75706461746528746869732E63757272656E74436F6E7461696E65722C746869732E706C616365686F6C646572292C746869732E636F6E7461696E6572735B675D2E5F7472696767657228226F766572222C732C746869732E5F75694861736828746869';
wwv_flow_api.g_varchar2_table(288) := '7329292C746869732E636F6E7461696E6572735B675D2E636F6E7461696E657243616368652E6F7665723D317D7D2C5F63726561746548656C7065723A66756E6374696F6E2865297B76617220693D746869732E6F7074696F6E732C733D742E69734675';
wwv_flow_api.g_varchar2_table(289) := '6E6374696F6E28692E68656C706572293F7428692E68656C7065722E6170706C7928746869732E656C656D656E745B305D2C5B652C746869732E63757272656E744974656D5D29293A22636C6F6E65223D3D3D692E68656C7065723F746869732E637572';
wwv_flow_api.g_varchar2_table(290) := '72656E744974656D2E636C6F6E6528293A746869732E63757272656E744974656D3B72657475726E20732E706172656E74732822626F647922292E6C656E6774687C7C742822706172656E7422213D3D692E617070656E64546F3F692E617070656E6454';
wwv_flow_api.g_varchar2_table(291) := '6F3A746869732E63757272656E744974656D5B305D2E706172656E744E6F6465295B305D2E617070656E644368696C6428735B305D292C735B305D3D3D3D746869732E63757272656E744974656D5B305D262628746869732E5F73746F7265644353533D';
wwv_flow_api.g_varchar2_table(292) := '7B77696474683A746869732E63757272656E744974656D5B305D2E7374796C652E77696474682C6865696768743A746869732E63757272656E744974656D5B305D2E7374796C652E6865696768742C706F736974696F6E3A746869732E63757272656E74';
wwv_flow_api.g_varchar2_table(293) := '4974656D2E6373732822706F736974696F6E22292C746F703A746869732E63757272656E744974656D2E6373732822746F7022292C6C6566743A746869732E63757272656E744974656D2E63737328226C65667422297D292C2821735B305D2E7374796C';
wwv_flow_api.g_varchar2_table(294) := '652E77696474687C7C692E666F72636548656C70657253697A65292626732E776964746828746869732E63757272656E744974656D2E77696474682829292C2821735B305D2E7374796C652E6865696768747C7C692E666F72636548656C70657253697A';
wwv_flow_api.g_varchar2_table(295) := '65292626732E68656967687428746869732E63757272656E744974656D2E6865696768742829292C737D2C5F61646A7573744F666673657446726F6D48656C7065723A66756E6374696F6E2865297B22737472696E67223D3D747970656F662065262628';
wwv_flow_api.g_varchar2_table(296) := '653D652E73706C69742822202229292C742E69734172726179286529262628653D7B6C6566743A2B655B305D2C746F703A2B655B315D7C7C307D292C226C65667422696E2065262628746869732E6F66667365742E636C69636B2E6C6566743D652E6C65';
wwv_flow_api.g_varchar2_table(297) := '66742B746869732E6D617267696E732E6C656674292C22726967687422696E2065262628746869732E6F66667365742E636C69636B2E6C6566743D746869732E68656C70657250726F706F7274696F6E732E77696474682D652E72696768742B74686973';
wwv_flow_api.g_varchar2_table(298) := '2E6D617267696E732E6C656674292C22746F7022696E2065262628746869732E6F66667365742E636C69636B2E746F703D652E746F702B746869732E6D617267696E732E746F70292C22626F74746F6D22696E2065262628746869732E6F66667365742E';
wwv_flow_api.g_varchar2_table(299) := '636C69636B2E746F703D746869732E68656C70657250726F706F7274696F6E732E6865696768742D652E626F74746F6D2B746869732E6D617267696E732E746F70297D2C5F676574506172656E744F66667365743A66756E6374696F6E28297B74686973';
wwv_flow_api.g_varchar2_table(300) := '2E6F6666736574506172656E743D746869732E68656C7065722E6F6666736574506172656E7428293B76617220653D746869732E6F6666736574506172656E742E6F666673657428293B72657475726E226162736F6C757465223D3D3D746869732E6373';
wwv_flow_api.g_varchar2_table(301) := '73506F736974696F6E2626746869732E7363726F6C6C506172656E745B305D213D3D646F63756D656E742626742E636F6E7461696E7328746869732E7363726F6C6C506172656E745B305D2C746869732E6F6666736574506172656E745B305D29262628';
wwv_flow_api.g_varchar2_table(302) := '652E6C6566742B3D746869732E7363726F6C6C506172656E742E7363726F6C6C4C65667428292C652E746F702B3D746869732E7363726F6C6C506172656E742E7363726F6C6C546F702829292C28746869732E6F6666736574506172656E745B305D3D3D';
wwv_flow_api.g_varchar2_table(303) := '3D646F63756D656E742E626F64797C7C746869732E6F6666736574506172656E745B305D2E7461674E616D6526262268746D6C223D3D3D746869732E6F6666736574506172656E745B305D2E7461674E616D652E746F4C6F776572436173652829262674';
wwv_flow_api.g_varchar2_table(304) := '2E75692E696529262628653D7B746F703A302C6C6566743A307D292C7B746F703A652E746F702B287061727365496E7428746869732E6F6666736574506172656E742E6373732822626F72646572546F70576964746822292C3130297C7C30292C6C6566';
wwv_flow_api.g_varchar2_table(305) := '743A652E6C6566742B287061727365496E7428746869732E6F6666736574506172656E742E6373732822626F726465724C656674576964746822292C3130297C7C30297D7D2C5F67657452656C61746976654F66667365743A66756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(306) := '6966282272656C6174697665223D3D3D746869732E637373506F736974696F6E297B76617220743D746869732E63757272656E744974656D2E706F736974696F6E28293B72657475726E7B746F703A742E746F702D287061727365496E7428746869732E';
wwv_flow_api.g_varchar2_table(307) := '68656C7065722E6373732822746F7022292C3130297C7C30292B746869732E7363726F6C6C506172656E742E7363726F6C6C546F7028292C6C6566743A742E6C6566742D287061727365496E7428746869732E68656C7065722E63737328226C65667422';
wwv_flow_api.g_varchar2_table(308) := '292C3130297C7C30292B746869732E7363726F6C6C506172656E742E7363726F6C6C4C65667428297D7D72657475726E7B746F703A302C6C6566743A307D7D2C5F63616368654D617267696E733A66756E6374696F6E28297B746869732E6D617267696E';
wwv_flow_api.g_varchar2_table(309) := '733D7B6C6566743A7061727365496E7428746869732E63757272656E744974656D2E63737328226D617267696E4C65667422292C3130297C7C302C746F703A7061727365496E7428746869732E63757272656E744974656D2E63737328226D617267696E';
wwv_flow_api.g_varchar2_table(310) := '546F7022292C3130297C7C307D7D2C5F636163686548656C70657250726F706F7274696F6E733A66756E6374696F6E28297B746869732E68656C70657250726F706F7274696F6E733D7B77696474683A746869732E68656C7065722E6F75746572576964';
wwv_flow_api.g_varchar2_table(311) := '746828292C6865696768743A746869732E68656C7065722E6F7574657248656967687428297D7D2C5F736574436F6E7461696E6D656E743A66756E6374696F6E28297B76617220652C692C732C6E3D746869732E6F7074696F6E733B22706172656E7422';
wwv_flow_api.g_varchar2_table(312) := '3D3D3D6E2E636F6E7461696E6D656E742626286E2E636F6E7461696E6D656E743D746869732E68656C7065725B305D2E706172656E744E6F6465292C2822646F63756D656E74223D3D3D6E2E636F6E7461696E6D656E747C7C2277696E646F77223D3D3D';
wwv_flow_api.g_varchar2_table(313) := '6E2E636F6E7461696E6D656E7429262628746869732E636F6E7461696E6D656E743D5B302D746869732E6F66667365742E72656C61746976652E6C6566742D746869732E6F66667365742E706172656E742E6C6566742C302D746869732E6F6666736574';
wwv_flow_api.g_varchar2_table(314) := '2E72656C61746976652E746F702D746869732E6F66667365742E706172656E742E746F702C742822646F63756D656E74223D3D3D6E2E636F6E7461696E6D656E743F646F63756D656E743A77696E646F77292E776964746828292D746869732E68656C70';
wwv_flow_api.g_varchar2_table(315) := '657250726F706F7274696F6E732E77696474682D746869732E6D617267696E732E6C6566742C28742822646F63756D656E74223D3D3D6E2E636F6E7461696E6D656E743F646F63756D656E743A77696E646F77292E68656967687428297C7C646F63756D';
wwv_flow_api.g_varchar2_table(316) := '656E742E626F64792E706172656E744E6F64652E7363726F6C6C486569676874292D746869732E68656C70657250726F706F7274696F6E732E6865696768742D746869732E6D617267696E732E746F705D292C2F5E28646F63756D656E747C77696E646F';
wwv_flow_api.g_varchar2_table(317) := '777C706172656E7429242F2E74657374286E2E636F6E7461696E6D656E74297C7C28653D74286E2E636F6E7461696E6D656E74295B305D2C693D74286E2E636F6E7461696E6D656E74292E6F666673657428292C733D2268696464656E22213D3D742865';
wwv_flow_api.g_varchar2_table(318) := '292E63737328226F766572666C6F7722292C746869732E636F6E7461696E6D656E743D5B692E6C6566742B287061727365496E7428742865292E6373732822626F726465724C656674576964746822292C3130297C7C30292B287061727365496E742874';
wwv_flow_api.g_varchar2_table(319) := '2865292E637373282270616464696E674C65667422292C3130297C7C30292D746869732E6D617267696E732E6C6566742C692E746F702B287061727365496E7428742865292E6373732822626F72646572546F70576964746822292C3130297C7C30292B';
wwv_flow_api.g_varchar2_table(320) := '287061727365496E7428742865292E637373282270616464696E67546F7022292C3130297C7C30292D746869732E6D617267696E732E746F702C692E6C6566742B28733F4D6174682E6D617828652E7363726F6C6C57696474682C652E6F666673657457';
wwv_flow_api.g_varchar2_table(321) := '69647468293A652E6F66667365745769647468292D287061727365496E7428742865292E6373732822626F726465724C656674576964746822292C3130297C7C30292D287061727365496E7428742865292E637373282270616464696E67526967687422';
wwv_flow_api.g_varchar2_table(322) := '292C3130297C7C30292D746869732E68656C70657250726F706F7274696F6E732E77696474682D746869732E6D617267696E732E6C6566742C692E746F702B28733F4D6174682E6D617828652E7363726F6C6C4865696768742C652E6F66667365744865';
wwv_flow_api.g_varchar2_table(323) := '69676874293A652E6F6666736574486569676874292D287061727365496E7428742865292E6373732822626F72646572546F70576964746822292C3130297C7C30292D287061727365496E7428742865292E637373282270616464696E67426F74746F6D';
wwv_flow_api.g_varchar2_table(324) := '22292C3130297C7C30292D746869732E68656C70657250726F706F7274696F6E732E6865696768742D746869732E6D617267696E732E746F705D297D2C5F636F6E76657274506F736974696F6E546F3A66756E6374696F6E28652C69297B697C7C28693D';
wwv_flow_api.g_varchar2_table(325) := '746869732E706F736974696F6E293B76617220733D226162736F6C757465223D3D3D653F313A2D312C6E3D226162736F6C75746522213D3D746869732E637373506F736974696F6E7C7C746869732E7363726F6C6C506172656E745B305D213D3D646F63';
wwv_flow_api.g_varchar2_table(326) := '756D656E742626742E636F6E7461696E7328746869732E7363726F6C6C506172656E745B305D2C746869732E6F6666736574506172656E745B305D293F746869732E7363726F6C6C506172656E743A746869732E6F6666736574506172656E742C6F3D2F';
wwv_flow_api.g_varchar2_table(327) := '2868746D6C7C626F6479292F692E74657374286E5B305D2E7461674E616D65293B72657475726E7B746F703A692E746F702B746869732E6F66667365742E72656C61746976652E746F702A732B746869732E6F66667365742E706172656E742E746F702A';
wwv_flow_api.g_varchar2_table(328) := '732D28226669786564223D3D3D746869732E637373506F736974696F6E3F2D746869732E7363726F6C6C506172656E742E7363726F6C6C546F7028293A6F3F303A6E2E7363726F6C6C546F702829292A732C6C6566743A692E6C6566742B746869732E6F';
wwv_flow_api.g_varchar2_table(329) := '66667365742E72656C61746976652E6C6566742A732B746869732E6F66667365742E706172656E742E6C6566742A732D28226669786564223D3D3D746869732E637373506F736974696F6E3F2D746869732E7363726F6C6C506172656E742E7363726F6C';
wwv_flow_api.g_varchar2_table(330) := '6C4C65667428293A6F3F303A6E2E7363726F6C6C4C6566742829292A737D7D2C5F67656E6572617465506F736974696F6E3A66756E6374696F6E2865297B76617220692C732C6E3D746869732E6F7074696F6E732C6F3D652E70616765582C613D652E70';
wwv_flow_api.g_varchar2_table(331) := '616765592C723D226162736F6C75746522213D3D746869732E637373506F736974696F6E7C7C746869732E7363726F6C6C506172656E745B305D213D3D646F63756D656E742626742E636F6E7461696E7328746869732E7363726F6C6C506172656E745B';
wwv_flow_api.g_varchar2_table(332) := '305D2C746869732E6F6666736574506172656E745B305D293F746869732E7363726F6C6C506172656E743A746869732E6F6666736574506172656E742C683D2F2868746D6C7C626F6479292F692E7465737428725B305D2E7461674E616D65293B726574';
wwv_flow_api.g_varchar2_table(333) := '75726E2272656C617469766522213D3D746869732E637373506F736974696F6E7C7C746869732E7363726F6C6C506172656E745B305D213D3D646F63756D656E742626746869732E7363726F6C6C506172656E745B305D213D3D746869732E6F66667365';
wwv_flow_api.g_varchar2_table(334) := '74506172656E745B305D7C7C28746869732E6F66667365742E72656C61746976653D746869732E5F67657452656C61746976654F66667365742829292C746869732E6F726967696E616C506F736974696F6E262628746869732E636F6E7461696E6D656E';
wwv_flow_api.g_varchar2_table(335) := '74262628652E70616765582D746869732E6F66667365742E636C69636B2E6C6566743C746869732E636F6E7461696E6D656E745B305D2626286F3D746869732E636F6E7461696E6D656E745B305D2B746869732E6F66667365742E636C69636B2E6C6566';
wwv_flow_api.g_varchar2_table(336) := '74292C652E70616765592D746869732E6F66667365742E636C69636B2E746F703C746869732E636F6E7461696E6D656E745B315D262628613D746869732E636F6E7461696E6D656E745B315D2B746869732E6F66667365742E636C69636B2E746F70292C';
wwv_flow_api.g_varchar2_table(337) := '652E70616765582D746869732E6F66667365742E636C69636B2E6C6566743E746869732E636F6E7461696E6D656E745B325D2626286F3D746869732E636F6E7461696E6D656E745B325D2B746869732E6F66667365742E636C69636B2E6C656674292C65';
wwv_flow_api.g_varchar2_table(338) := '2E70616765592D746869732E6F66667365742E636C69636B2E746F703E746869732E636F6E7461696E6D656E745B335D262628613D746869732E636F6E7461696E6D656E745B335D2B746869732E6F66667365742E636C69636B2E746F7029292C6E2E67';
wwv_flow_api.g_varchar2_table(339) := '726964262628693D746869732E6F726967696E616C50616765592B4D6174682E726F756E642828612D746869732E6F726967696E616C5061676559292F6E2E677269645B315D292A6E2E677269645B315D2C613D746869732E636F6E7461696E6D656E74';
wwv_flow_api.g_varchar2_table(340) := '3F692D746869732E6F66667365742E636C69636B2E746F703E3D746869732E636F6E7461696E6D656E745B315D2626692D746869732E6F66667365742E636C69636B2E746F703C3D746869732E636F6E7461696E6D656E745B335D3F693A692D74686973';
wwv_flow_api.g_varchar2_table(341) := '2E6F66667365742E636C69636B2E746F703E3D746869732E636F6E7461696E6D656E745B315D3F692D6E2E677269645B315D3A692B6E2E677269645B315D3A692C733D746869732E6F726967696E616C50616765582B4D6174682E726F756E6428286F2D';
wwv_flow_api.g_varchar2_table(342) := '746869732E6F726967696E616C5061676558292F6E2E677269645B305D292A6E2E677269645B305D2C6F3D746869732E636F6E7461696E6D656E743F732D746869732E6F66667365742E636C69636B2E6C6566743E3D746869732E636F6E7461696E6D65';
wwv_flow_api.g_varchar2_table(343) := '6E745B305D2626732D746869732E6F66667365742E636C69636B2E6C6566743C3D746869732E636F6E7461696E6D656E745B325D3F733A732D746869732E6F66667365742E636C69636B2E6C6566743E3D746869732E636F6E7461696E6D656E745B305D';
wwv_flow_api.g_varchar2_table(344) := '3F732D6E2E677269645B305D3A732B6E2E677269645B305D3A7329292C7B746F703A612D746869732E6F66667365742E636C69636B2E746F702D746869732E6F66667365742E72656C61746976652E746F702D746869732E6F66667365742E706172656E';
wwv_flow_api.g_varchar2_table(345) := '742E746F702B28226669786564223D3D3D746869732E637373506F736974696F6E3F2D746869732E7363726F6C6C506172656E742E7363726F6C6C546F7028293A683F303A722E7363726F6C6C546F702829292C6C6566743A6F2D746869732E6F666673';
wwv_flow_api.g_varchar2_table(346) := '65742E636C69636B2E6C6566742D746869732E6F66667365742E72656C61746976652E6C6566742D746869732E6F66667365742E706172656E742E6C6566742B28226669786564223D3D3D746869732E637373506F736974696F6E3F2D746869732E7363';
wwv_flow_api.g_varchar2_table(347) := '726F6C6C506172656E742E7363726F6C6C4C65667428293A683F303A722E7363726F6C6C4C6566742829297D7D2C5F7265617272616E67653A66756E6374696F6E28742C652C692C73297B693F695B305D2E617070656E644368696C6428746869732E70';
wwv_flow_api.g_varchar2_table(348) := '6C616365686F6C6465725B305D293A652E6974656D5B305D2E706172656E744E6F64652E696E736572744265666F726528746869732E706C616365686F6C6465725B305D2C22646F776E223D3D3D746869732E646972656374696F6E3F652E6974656D5B';
wwv_flow_api.g_varchar2_table(349) := '305D3A652E6974656D5B305D2E6E6578745369626C696E67292C746869732E636F756E7465723D746869732E636F756E7465723F2B2B746869732E636F756E7465723A313B766172206E3D746869732E636F756E7465723B746869732E5F64656C617928';
wwv_flow_api.g_varchar2_table(350) := '66756E6374696F6E28297B6E3D3D3D746869732E636F756E7465722626746869732E72656672657368506F736974696F6E73282173297D297D2C5F636C6561723A66756E6374696F6E28742C65297B746869732E726576657274696E673D21313B766172';
wwv_flow_api.g_varchar2_table(351) := '20692C733D5B5D3B69662821746869732E5F6E6F46696E616C536F72742626746869732E63757272656E744974656D2E706172656E7428292E6C656E6774682626746869732E706C616365686F6C6465722E6265666F726528746869732E63757272656E';
wwv_flow_api.g_varchar2_table(352) := '744974656D292C746869732E5F6E6F46696E616C536F72743D6E756C6C2C746869732E68656C7065725B305D3D3D3D746869732E63757272656E744974656D5B305D297B666F72286920696E20746869732E5F73746F7265644353532928226175746F22';
wwv_flow_api.g_varchar2_table(353) := '3D3D3D746869732E5F73746F7265644353535B695D7C7C22737461746963223D3D3D746869732E5F73746F7265644353535B695D29262628746869732E5F73746F7265644353535B695D3D2222293B746869732E63757272656E744974656D2E63737328';
wwv_flow_api.g_varchar2_table(354) := '746869732E5F73746F726564435353292E72656D6F7665436C617373282275692D736F727461626C652D68656C70657222297D656C736520746869732E63757272656E744974656D2E73686F7728293B666F7228746869732E66726F6D4F757473696465';
wwv_flow_api.g_varchar2_table(355) := '262621652626732E707573682866756E6374696F6E2874297B746869732E5F74726967676572282272656365697665222C742C746869732E5F75694861736828746869732E66726F6D4F75747369646529297D292C21746869732E66726F6D4F75747369';
wwv_flow_api.g_varchar2_table(356) := '64652626746869732E646F6D506F736974696F6E2E707265763D3D3D746869732E63757272656E744974656D2E7072657628292E6E6F7428222E75692D736F727461626C652D68656C70657222295B305D2626746869732E646F6D506F736974696F6E2E';
wwv_flow_api.g_varchar2_table(357) := '706172656E743D3D3D746869732E63757272656E744974656D2E706172656E7428295B305D7C7C657C7C732E707573682866756E6374696F6E2874297B746869732E5F747269676765722822757064617465222C742C746869732E5F7569486173682829';
wwv_flow_api.g_varchar2_table(358) := '297D292C74686973213D3D746869732E63757272656E74436F6E7461696E6572262628657C7C28732E707573682866756E6374696F6E2874297B746869732E5F74726967676572282272656D6F7665222C742C746869732E5F7569486173682829297D29';
wwv_flow_api.g_varchar2_table(359) := '2C732E707573682866756E6374696F6E2874297B72657475726E2066756E6374696F6E2865297B742E5F74726967676572282272656365697665222C652C746869732E5F756948617368287468697329297D7D2E63616C6C28746869732C746869732E63';
wwv_flow_api.g_varchar2_table(360) := '757272656E74436F6E7461696E657229292C732E707573682866756E6374696F6E2874297B72657475726E2066756E6374696F6E2865297B742E5F747269676765722822757064617465222C652C746869732E5F756948617368287468697329297D7D2E';
wwv_flow_api.g_varchar2_table(361) := '63616C6C28746869732C746869732E63757272656E74436F6E7461696E6572292929292C693D746869732E636F6E7461696E6572732E6C656E6774682D313B693E3D303B692D2D29657C7C732E707573682866756E6374696F6E2874297B72657475726E';
wwv_flow_api.g_varchar2_table(362) := '2066756E6374696F6E2865297B742E5F74726967676572282264656163746976617465222C652C746869732E5F756948617368287468697329297D7D2E63616C6C28746869732C746869732E636F6E7461696E6572735B695D29292C746869732E636F6E';
wwv_flow_api.g_varchar2_table(363) := '7461696E6572735B695D2E636F6E7461696E657243616368652E6F766572262628732E707573682866756E6374696F6E2874297B72657475726E2066756E6374696F6E2865297B742E5F7472696767657228226F7574222C652C746869732E5F75694861';
wwv_flow_api.g_varchar2_table(364) := '7368287468697329297D7D2E63616C6C28746869732C746869732E636F6E7461696E6572735B695D29292C746869732E636F6E7461696E6572735B695D2E636F6E7461696E657243616368652E6F7665723D30293B696628746869732E73746F72656443';
wwv_flow_api.g_varchar2_table(365) := '7572736F72262628746869732E646F63756D656E742E66696E642822626F647922292E6373732822637572736F72222C746869732E73746F726564437572736F72292C746869732E73746F7265645374796C6573686565742E72656D6F76652829292C74';
wwv_flow_api.g_varchar2_table(366) := '6869732E5F73746F7265644F7061636974792626746869732E68656C7065722E63737328226F706163697479222C746869732E5F73746F7265644F706163697479292C746869732E5F73746F7265645A496E6465782626746869732E68656C7065722E63';
wwv_flow_api.g_varchar2_table(367) := '737328227A496E646578222C226175746F223D3D3D746869732E5F73746F7265645A496E6465783F22223A746869732E5F73746F7265645A496E646578292C746869732E6472616767696E673D21312C746869732E63616E63656C48656C70657252656D';
wwv_flow_api.g_varchar2_table(368) := '6F76616C297B6966282165297B666F7228746869732E5F7472696767657228226265666F726553746F70222C742C746869732E5F7569486173682829292C693D303B732E6C656E6774683E693B692B2B29735B695D2E63616C6C28746869732C74293B74';
wwv_flow_api.g_varchar2_table(369) := '6869732E5F74726967676572282273746F70222C742C746869732E5F7569486173682829297D72657475726E20746869732E66726F6D4F7574736964653D21312C21317D696628657C7C746869732E5F7472696767657228226265666F726553746F7022';
wwv_flow_api.g_varchar2_table(370) := '2C742C746869732E5F7569486173682829292C746869732E706C616365686F6C6465725B305D2E706172656E744E6F64652E72656D6F76654368696C6428746869732E706C616365686F6C6465725B305D292C746869732E68656C7065725B305D213D3D';
wwv_flow_api.g_varchar2_table(371) := '746869732E63757272656E744974656D5B305D2626746869732E68656C7065722E72656D6F766528292C746869732E68656C7065723D6E756C6C2C2165297B666F7228693D303B732E6C656E6774683E693B692B2B29735B695D2E63616C6C2874686973';
wwv_flow_api.g_varchar2_table(372) := '2C74293B746869732E5F74726967676572282273746F70222C742C746869732E5F7569486173682829297D72657475726E20746869732E66726F6D4F7574736964653D21312C21307D2C5F747269676765723A66756E6374696F6E28297B742E57696467';
wwv_flow_api.g_varchar2_table(373) := '65742E70726F746F747970652E5F747269676765722E6170706C7928746869732C617267756D656E7473293D3D3D21312626746869732E63616E63656C28297D2C5F7569486173683A66756E6374696F6E2865297B76617220693D657C7C746869733B72';
wwv_flow_api.g_varchar2_table(374) := '657475726E7B68656C7065723A692E68656C7065722C706C616365686F6C6465723A692E706C616365686F6C6465727C7C74285B5D292C706F736974696F6E3A692E706F736974696F6E2C6F726967696E616C506F736974696F6E3A692E6F726967696E';
wwv_flow_api.g_varchar2_table(375) := '616C506F736974696F6E2C6F66667365743A692E706F736974696F6E4162732C6974656D3A692E63757272656E744974656D2C73656E6465723A653F652E656C656D656E743A6E756C6C7D7D7D297D29286A5175657279293B';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 74403146251069510 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 77181374291134630 + wwv_flow_api.g_id_offset
 ,p_file_name => 'jquery-ui.custom.min.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

commit;
begin 
execute immediate 'begin dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
