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
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,2033609683807851));
 
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
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,148);
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
  p_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'BE.CTB.SELECT2'
 ,p_display_name => 'Select2'
 ,p_supported_ui_types => 'DESKTOP'
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
''||unistr('\000a')||
'-- UTIL'||unistr('\000a')||
'function add_js_attr('||unistr('\000a')||
'           p_param_name     in gt_string,'||unistr('\000a')||
'           p_param_value    in gt_string,'||unistr('\000a')||
'           p_include_quotes i'||
'n boolean default false,'||unistr('\000a')||
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
'    if (p_include_comma) t'||
'hen'||unistr('\000a')||
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
''||
'           p_max_columns    => gco_max_lov_cols,'||unistr('\000a')||
'           p_component_name => p_item.name'||unistr('\000a')||
'         );'||unistr('\000a')||
'end get_lov;'||unistr('\000a')||
''||unistr('\000a')||
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
'  l_null'||
'_optgroup_label_cmp gt_string := p_item.attribute_09;'||unistr('\000a')||
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
'     '||
'        p_default_null_optgroup_label in gt_string,'||unistr('\000a')||
'             p_null_optgroup_label_app     in gt_string,'||unistr('\000a')||
'             p_null_optgroup_label_cmp     in gt_string'||unistr('\000a')||
'           )'||unistr('\000a')||
'  return gt_string is'||unistr('\000a')||
'    l_null_optgroup_label gt_string;'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    if (p_null_optgroup_label_cmp is not null) then'||unistr('\000a')||
'      l_null_optgroup_label := p_null_optgroup_label_cmp;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_null_optgroup_label := nvl(p'||
'_null_optgroup_label_app, p_default_null_optgroup_label);'||unistr('\000a')||
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
'      if (p_optgroups(l_index)'||
' = p_optgroup) then'||unistr('\000a')||
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
'    l_selected_values := ape'||
'x_util.string_to_table(p_selected_values);'||unistr('\000a')||
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
'    sys.htp.p(''<option></option>'');'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_lov.exists(gco_lov_group_col)) then'||unistr('\000a')||
'    l_n'||
'ull_optgroup := get_null_optgroup_label('||unistr('\000a')||
'                         p_default_null_optgroup_label => lco_null_optgroup_label,'||unistr('\000a')||
'                         p_null_optgroup_label_app     => l_null_optgroup_label_app,'||unistr('\000a')||
'                         p_null_optgroup_label_cmp     => l_null_optgroup_label_cmp'||unistr('\000a')||
'                       );'||unistr('\000a')||
''||unistr('\000a')||
'    for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'      l_tmp_optgroup := '||
'nvl(l_lov(gco_lov_group_col)(i), l_null_optgroup);'||unistr('\000a')||
''||unistr('\000a')||
'      if (not optgroup_exists(laa_optgroups, l_tmp_optgroup)) then'||unistr('\000a')||
'        sys.htp.p(''<optgroup label="'' || l_tmp_optgroup || ''">'');'||unistr('\000a')||
'        for j in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'          if (nvl(l_lov(gco_lov_group_col)(j), l_null_optgroup) = l_tmp_optgroup) then'||unistr('\000a')||
'            apex_plugin_util.print_option('||unistr('\000a')||
'              p_display_v'||
'alue => l_lov(gco_lov_display_col)(j),'||unistr('\000a')||
'              p_return_value  => l_lov(gco_lov_return_col)(j),'||unistr('\000a')||
'              p_is_selected   => is_selected_value(l_lov(gco_lov_return_col)(j), p_value),'||unistr('\000a')||
'              p_attributes    => p_item.element_option_attributes,'||unistr('\000a')||
'              p_escape        => p_item.escape_output'||unistr('\000a')||
'            );'||unistr('\000a')||
'          end if;'||unistr('\000a')||
'        end loop;'||unistr('\000a')||
'        sys.htp.p(''</optgroup>'');'||unistr('\000a')||
''||unistr('\000a')||
''||
'        laa_optgroups(i) := l_tmp_optgroup;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'    end loop;'||unistr('\000a')||
'  else'||unistr('\000a')||
'    for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'      apex_plugin_util.print_option('||unistr('\000a')||
'        p_display_value => l_lov(gco_lov_display_col)(i),'||unistr('\000a')||
'        p_return_value  => l_lov(gco_lov_return_col)(i),'||unistr('\000a')||
'        p_is_selected   => is_selected_value(l_lov(gco_lov_return_col)(i), p_value),'||unistr('\000a')||
'        p_attributes    => p'||
'_item.element_option_attributes,'||unistr('\000a')||
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
'return gt_string is'||unistr('\000a')||
'  l_lov         apex_plugin_util.t_column_value_list;'||unistr('\000a')||
'  l_tags_option gt_string;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  l_lov := get_'||
'lov(p_item);'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_include_key) then'||unistr('\000a')||
'    l_tags_option := '''||unistr('\000a')||
'        tags: ['';'||unistr('\000a')||
''||unistr('\000a')||
'    for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'      if (p_item.escape_output) then'||unistr('\000a')||
'        l_tags_option := l_tags_option || ''"'' || sys.htf.escape_sc(l_lov(gco_lov_display_col)(i)) || ''",'';'||unistr('\000a')||
'      else'||unistr('\000a')||
'        l_tags_option := l_tags_option || ''"'' || l_lov(gco_lov_display_col)(i) || ''",'';'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'    e'||
'nd loop;'||unistr('\000a')||
'  else'||unistr('\000a')||
'    for i in 1 .. l_lov(gco_lov_display_col).count loop'||unistr('\000a')||
'      if (p_item.escape_output) then'||unistr('\000a')||
'        l_tags_option := l_tags_option || sys.htf.escape_sc(l_lov(gco_lov_display_col)(i)) || '','';'||unistr('\000a')||
'      else'||unistr('\000a')||
'        l_tags_option := l_tags_option || l_lov(gco_lov_display_col)(i) || '','';'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'    end loop;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_lov(gco_lov_display_col).count > 0) then'||unistr('\000a')||
'    l_tags_op'||
'tion := substr(l_tags_option, 0, length(l_tags_option) - 1);'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_include_key) then'||unistr('\000a')||
'    l_tags_option := l_tags_option || '']'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_tags_option;'||unistr('\000a')||
'end get_tags_option;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'-- PLUGIN INTERFACE FUNCTIONS'||unistr('\000a')||
'function render('||unistr('\000a')||
'           p_item                in apex_plugin.t_page_item,'||unistr('\000a')||
'           p_plugin              in apex_plugin.t_plugin,'||unistr('\000a')||
'           p_value               i'||
'n gt_string,'||unistr('\000a')||
'           p_is_readonly         in boolean,'||unistr('\000a')||
'           p_is_printer_friendly in boolean'||unistr('\000a')||
'         )'||unistr('\000a')||
'return apex_plugin.t_page_item_render_result is'||unistr('\000a')||
'  l_no_matches_msg          gt_string := p_plugin.attribute_01;'||unistr('\000a')||
'  l_input_too_short_msg     gt_string := p_plugin.attribute_02;'||unistr('\000a')||
'  l_selection_too_big_msg   gt_string := p_plugin.attribute_03;'||unistr('\000a')||
'  l_searching_msg           gt_string := p_plug'||
'in.attribute_04;'||unistr('\000a')||
'  l_null_optgroup_label_app gt_string := p_plugin.attribute_05;'||unistr('\000a')||
''||unistr('\000a')||
'  l_select_list_type        gt_string := p_item.attribute_01;'||unistr('\000a')||
'  l_min_results_for_search  gt_string := p_item.attribute_02;'||unistr('\000a')||
'  l_min_input_length        gt_string := p_item.attribute_03;'||unistr('\000a')||
'  l_max_input_length        gt_string := p_item.attribute_04;'||unistr('\000a')||
'  l_max_selection_size      gt_string := p_item.attribute_05;'||unistr('\000a')||
'  l_rapi'||
'd_selection         gt_string := p_item.attribute_06;'||unistr('\000a')||
'  l_select_on_blur          gt_string := p_item.attribute_07;'||unistr('\000a')||
'  l_search_logic            gt_string := p_item.attribute_08;'||unistr('\000a')||
'  l_null_optgroup_label_cmp gt_string := p_item.attribute_09;'||unistr('\000a')||
'  l_width                   gt_string := p_item.attribute_10;'||unistr('\000a')||
''||unistr('\000a')||
'  l_value          gt_string;'||unistr('\000a')||
'  l_display_values apex_application_global.vc_arr2;'||unistr('\000a')||
'  l_multiselect'||
'    gt_string;'||unistr('\000a')||
''||unistr('\000a')||
'  l_item_jq                    gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.name);'||unistr('\000a')||
'  l_cascade_parent_items_jq    gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.lov_cascade_parent_items);'||unistr('\000a')||
'  l_cascade_items_to_submit_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.ajax_items_to_submit);'||unistr('\000a')||
'  l_items_for_session_state_jq gt_string;'||unistr('\000a')||
'  l'||
'_cascade_parent_items       apex_application_global.vc_arr2;'||unistr('\000a')||
'  l_optimize_refresh_condition gt_string;'||unistr('\000a')||
''||unistr('\000a')||
'  l_onload_code   gt_string;'||unistr('\000a')||
'  l_render_result apex_plugin.t_page_item_render_result;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'  -- local subprograms'||unistr('\000a')||
'  function get_select2_constructor('||unistr('\000a')||
'            p_include_tags    boolean,'||unistr('\000a')||
'            p_end_constructor boolean'||unistr('\000a')||
'           )'||unistr('\000a')||
'  return gt_string is'||unistr('\000a')||
'    lco_contains_ignore_case    const'||
'ant gt_string := ''CIC'';'||unistr('\000a')||
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
'      l_placeholder := '''';'||unistr('\000a')||
'    end'||
' if;'||unistr('\000a')||
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
'      $("'' || l_item_jq || ''").select2({'' ||'||unistr('\000a')||
'        '||
'add_js_attr(''width'', l_width, true) ||'||unistr('\000a')||
'        add_js_attr(''placeholder'', l_placeholder, true) ||'||unistr('\000a')||
'        add_js_attr(''allowClear'', ''true'') ||'||unistr('\000a')||
'        add_js_attr(''minimumInputLength'', l_min_input_length) ||'||unistr('\000a')||
'        add_js_attr(''maximumInputLength'', l_max_input_length) ||'||unistr('\000a')||
'        add_js_attr(''minimumResultsForSearch'', l_min_results_for_search) ||'||unistr('\000a')||
'        add_js_attr(''maximumSelectionSize'', l_max_s'||
'election_size) ||'||unistr('\000a')||
'        add_js_attr(''closeOnSelect'', l_rapid_selection) ||'||unistr('\000a')||
'        add_js_attr(''selectOnBlur'', l_select_on_blur);'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_no_matches_msg is not null) then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        formatNoMatches: function(term) {'||unistr('\000a')||
'                           var msg = "'' || l_no_matches_msg || ''";'||unistr('\000a')||
'                           msg = msg.replace("#TERM#", term);'||unistr('\000a')||
'                         '||
'  return msg;'||unistr('\000a')||
'                         },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_input_too_short_msg is not null) then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        formatInputTooShort: function(term, minLength) {'||unistr('\000a')||
'                               var msg = "'' || l_input_too_short_msg || ''";'||unistr('\000a')||
'                               msg = msg.replace("#TERM#", term);'||unistr('\000a')||
'                               msg = msg.replace("#MINLENGTH#", minL'||
'ength);'||unistr('\000a')||
'                               return msg;'||unistr('\000a')||
'                             },'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_selection_too_big_msg is not null) then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'        formatSelectionTooBig: function(maxSize) {'||unistr('\000a')||
'                                 var msg = "'' || l_selection_too_big_msg || ''";'||unistr('\000a')||
'                                 msg = msg.replace("#MAXSIZE#", maxSize);'||unistr('\000a')||
'                   '||
'              return msg;'||unistr('\000a')||
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
'    if (l_search_logic != lco_contains_ignore_case) then'||unistr('\000a')||
'      case l'||
'_search_logic'||unistr('\000a')||
'        when lco_contains_case_sensitive then l_search_logic := ''return text.indexOf(term) >= 0;'';'||unistr('\000a')||
'        when lco_exact_ignore_case then l_search_logic := ''return text.toUpperCase() === term.toUpperCase() || term.length === 0;'';'||unistr('\000a')||
'        when lco_exact_case_sensitive then l_search_logic := ''return text === term || term.length === 0;'';'||unistr('\000a')||
'        else l_search_logic := ''return text.toUp'||
'perCase().indexOf(term.toUpperCase()) >= 0;'';'||unistr('\000a')||
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
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
' '||
'   if (p_end_constructor) then'||unistr('\000a')||
'      l_code := l_code || '''||unistr('\000a')||
'      });'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    return l_code;'||unistr('\000a')||
'  end get_select2_constructor;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  if (apex_application.g_debug) then'||unistr('\000a')||
'    apex_plugin_util.debug_page_item(p_plugin, p_item, p_value, p_is_readonly, p_is_printer_friendly);'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_item.escape_output) then'||unistr('\000a')||
'    l_value := sys.htf.escape_sc(p_value);'||unistr('\000a')||
'  else'||unistr('\000a')||
'    l_value := p_value;'||unistr('\000a')||
'  '||
'end if;'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_is_readonly or p_is_printer_friendly) then'||unistr('\000a')||
'    apex_plugin_util.print_hidden_if_readonly(p_item.name, p_value, p_is_readonly, p_is_printer_friendly);'||unistr('\000a')||
''||unistr('\000a')||
'    l_display_values := apex_plugin_util.get_display_data('||unistr('\000a')||
'                          p_sql_statement     => p_item.lov_definition,'||unistr('\000a')||
'                          p_min_columns       => gco_min_lov_cols,'||unistr('\000a')||
'                          p_max_co'||
'lumns       => gco_max_lov_cols,'||unistr('\000a')||
'                          p_component_name    => p_item.name,'||unistr('\000a')||
'                          p_search_value_list => apex_util.string_to_table(p_value),'||unistr('\000a')||
'                          p_display_extra     => p_item.lov_display_extra'||unistr('\000a')||
'                        );'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_display_values.count = 1) then'||unistr('\000a')||
'      apex_plugin_util.print_display_only('||unistr('\000a')||
'        p_item_name        => p_it'||
'em.name,'||unistr('\000a')||
'        p_display_value    => l_display_values(1),'||unistr('\000a')||
'        p_show_line_breaks => false,'||unistr('\000a')||
'        p_escape           => p_item.escape_output,'||unistr('\000a')||
'        p_attributes       => p_item.element_attributes'||unistr('\000a')||
'      );'||unistr('\000a')||
'    elsif (l_display_values.count > 1) then'||unistr('\000a')||
'      sys.htp.p('''||unistr('\000a')||
'        <ul id="'' || p_item.name || ''_DISPLAY"'||unistr('\000a')||
'            class="display_only">'');'||unistr('\000a')||
''||unistr('\000a')||
'      for i in 1 .. l_display_values.co'||
'unt loop'||unistr('\000a')||
'        if (p_item.escape_output) then'||unistr('\000a')||
'          sys.htp.p(''<li>'' || sys.htf.escape_sc(l_display_values(i)) || ''</li>'');'||unistr('\000a')||
'        else'||unistr('\000a')||
'          sys.htp.p(''<li>'' || l_display_values(i) || ''</li>'');'||unistr('\000a')||
'        end if;'||unistr('\000a')||
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
'    p_directory =>'||
' p_plugin.file_prefix,'||unistr('\000a')||
'    p_version   => null'||unistr('\000a')||
'  );'||unistr('\000a')||
'  apex_css.add_file('||unistr('\000a')||
'    p_name      => ''select2'','||unistr('\000a')||
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
'    sys.htp.p('''||unistr('\000a')||
'      <input type="hidden"'||unistr('\000a')||
'             id="'' || p_ite'||
'm.name || ''"'||unistr('\000a')||
'             name="'' || apex_plugin.get_input_name_for_page_item(true) || ''"'||unistr('\000a')||
'             value="'' || l_value || ''"'||unistr('\000a')||
'             class="'' || p_item.element_css_classes || ''" '' ||'||unistr('\000a')||
'             p_item.element_attributes || ''>'');'||unistr('\000a')||
'  else'||unistr('\000a')||
'    sys.htp.p('''||unistr('\000a')||
'      <select '' || l_multiselect || '''||unistr('\000a')||
'              id="'' || p_item.name || ''"'||unistr('\000a')||
'              name="'' || apex_plugin.get_input_name_for_pa'||
'ge_item(true) || ''"'||unistr('\000a')||
'              class="selectlist '' || p_item.element_css_classes || ''" '' ||'||unistr('\000a')||
'              p_item.element_attributes || ''>'');'||unistr('\000a')||
''||unistr('\000a')||
'    sys.htp.p(get_options_html(p_item, p_plugin, p_value));'||unistr('\000a')||
''||unistr('\000a')||
'    sys.htp.p(''</select>'');'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  l_onload_code := get_select2_constructor(true, true);'||unistr('\000a')||
''||unistr('\000a')||
'  if (p_item.lov_cascade_parent_items is not null) then'||unistr('\000a')||
'    l_items_for_session_state_jq := l_casc'||
'ade_parent_items_jq;'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_cascade_items_to_submit_jq is not null) then'||unistr('\000a')||
'      l_items_for_session_state_jq := l_items_for_session_state_jq || '','' || l_cascade_items_to_submit_jq;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    l_onload_code := l_onload_code || '''||unistr('\000a')||
'      $("'' || l_cascade_parent_items_jq || ''").on("change", function(e) {'';'||unistr('\000a')||
''||unistr('\000a')||
'    if (p_item.ajax_optimize_refresh) then'||unistr('\000a')||
'      l_cascade_parent_items := apex_util.s'||
'tring_to_table(l_cascade_parent_items_jq, '','');'||unistr('\000a')||
''||unistr('\000a')||
'      l_optimize_refresh_condition := ''$("'' || l_cascade_parent_items(1) || ''").val() === ""'';'||unistr('\000a')||
''||unistr('\000a')||
'      for i in 2 .. l_cascade_parent_items.count loop'||unistr('\000a')||
'        l_optimize_refresh_condition := l_optimize_refresh_condition || '' || $("'' || l_cascade_parent_items(i) || ''").val() === ""'';'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
''||unistr('\000a')||
'      l_onload_code := l_onload_code || '''||unistr('\000a')||
'        v'||
'ar item = $("'' || l_item_jq || ''");'||unistr('\000a')||
'        if ('' || l_optimize_refresh_condition || '') {'';'||unistr('\000a')||
''||unistr('\000a')||
'      if (l_select_list_type = ''TAG'') then'||unistr('\000a')||
'        l_onload_code := l_onload_code ||'||unistr('\000a')||
'          get_select2_constructor(false, false) || '','||unistr('\000a')||
'        tags: []'||unistr('\000a')||
'      });'';'||unistr('\000a')||
'      else'||unistr('\000a')||
'        if (p_item.lov_display_null) then'||unistr('\000a')||
'          l_onload_code := l_onload_code || '''||unistr('\000a')||
'          item.html("<option></option>")'||
';'';'||unistr('\000a')||
'        else'||unistr('\000a')||
'          l_onload_code := l_onload_code || '''||unistr('\000a')||
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
'            { pageItems: "'' || l_items_'||
'for_session_state_jq || ''" },'||unistr('\000a')||
'            { refreshObject: "'' || l_item_jq || ''",'||unistr('\000a')||
'              loadingIndicator: "'' || l_item_jq || ''",'||unistr('\000a')||
'              loadingIndicatorPosition: "after",'||unistr('\000a')||
'              dataType: "text",'||unistr('\000a')||
'              success: function(pData) {'||unistr('\000a')||
'                         var item = $("'' || l_item_jq || ''");'';'||unistr('\000a')||
''||unistr('\000a')||
'    if (l_select_list_type = ''TAG'') then'||unistr('\000a')||
'      l_onload_code := l_onload_cod'||
'e || '''||unistr('\000a')||
'                         var tagsArray;'||unistr('\000a')||
'                         tagsArray = pData.slice(0, -1).split(",");'||unistr('\000a')||
'                         if (tagsArray.length === 1 && tagsArray[0] === "") {'||unistr('\000a')||
'                           tagsArray = [];'||unistr('\000a')||
'                         }'||unistr('\000a')||
'      '' || get_select2_constructor(false, false) || '','||unistr('\000a')||
'        tags: tagsArray'||unistr('\000a')||
'      });'';'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_onload_code := l_onload_code '||
'|| '''||unistr('\000a')||
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
'    l_onload_code := l_onload_code || ''});'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  apex_javascript.add_onload_code(l_onload_code);'||unistr('\000a')||
'  l_render_result.is_navigable := true;'||unistr('\000a')||
'  return l_render_result;'||unistr('\000a')||
'en'||
'd render;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function ajax('||unistr('\000a')||
'           p_item   in apex_plugin.t_page_item,'||unistr('\000a')||
'           p_plugin in apex_plugin.t_plugin'||unistr('\000a')||
'         )'||unistr('\000a')||
'return apex_plugin.t_page_item_ajax_result is'||unistr('\000a')||
'  l_select_list_type gt_string := p_item.attribute_01;'||unistr('\000a')||
''||unistr('\000a')||
'  l_result apex_plugin.t_page_item_ajax_result;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  if (l_select_list_type = ''TAG'') then'||unistr('\000a')||
'    sys.htp.p(get_tags_option(p_item, false));'||unistr('\000a')||
'  else'||unistr('\000a')||
'    sys.htp.p(get_opt'||
'ions_html(p_item, p_plugin, ''''));'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_result;'||unistr('\000a')||
'end ajax;'
 ,p_render_function => 'render'
 ,p_ajax_function => 'ajax'
 ,p_standard_attributes => 'VISIBLE:SESSION_STATE:READONLY:ESCAPE_OUTPUT:QUICKPICK:SOURCE:ELEMENT:ELEMENT_OPTION:ENCRYPT:LOV:LOV_REQUIRED:LOV_DISPLAY_NULL:CASCADING_LOV'
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
 ,p_subscribe_plugin_settings => true
 ,p_version_identifier => '1.4'
 ,p_about_url => 'http://apex.oracle.com/pls/apex/f?p=64237:20'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 48943101390612927307 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
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
  p_id => 48943102686515929300 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
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
  p_id => 48943103283711930584 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
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
  p_id => 24678005978298092461 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
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
  p_id => 49191608794067668843 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
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
  p_id => 48942056786281750875 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
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
  p_id => 48942060582831752401 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 48942056786281750875 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Single-value Select List'
 ,p_return_value => 'SINGLE'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 48942061780890688752 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 48942056786281750875 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Multi-value Select List'
 ,p_return_value => 'MULTI'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 48942062878086690062 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 48942056786281750875 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Tagging Support'
 ,p_return_value => 'TAG'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 48942514281678844132 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Minimum Results for Search Field'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 48942056786281750875 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'SINGLE'
 ,p_help_text => 'The minimum number of results that must be populated in order to display the search field. A negative value always hides the search field.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 48942653592664789643 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
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
  p_id => 48942656576706861628 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Maximum Input Length'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 48942056786281750875 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'TAG'
 ,p_help_text => 'Maximum number of characters that can be entered for a new option.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 48942776291142870092 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Maximum Selection Size'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 8
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 48942056786281750875 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'MULTI,TAG'
 ,p_help_text => 'The maximum number of items that can be selected.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 48942779580144810641 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Rapid Selection'
 ,p_attribute_type => 'CHECKBOXES'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 48942056786281750875 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'MULTI,TAG'
 ,p_help_text => 'Keep open the options dropdown after a selection is made, allowing for rapid selection of multiple items.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 48942781178634811401 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 48942779580144810641 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => ' '
 ,p_return_value => 'Y'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 48942839178800872046 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
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
  p_id => 48942839677722872591 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 48942839178800872046 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => ' '
 ,p_return_value => 'Y'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 48971774487974912980 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
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
  p_id => 48971777083660914943 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 48971774487974912980 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Contains & Ignore Case'
 ,p_return_value => 'CIC'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 48971777681719915825 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 48971774487974912980 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Contains & Case Sensitive'
 ,p_return_value => 'CCS'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 48971778878700917235 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 48971774487974912980 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Exact & Ignore Case'
 ,p_return_value => 'EIC'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 48971782276112918396 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 48971774487974912980 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Exact & Case Sensitive'
 ,p_return_value => 'ECS'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 49191636476167677210 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 9
 ,p_display_sequence => 90
 ,p_prompt => 'Label for Null Option Group'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'The name of the option group for records whose grouping column value is null. Overwrites the "Label for Null Option Group" attribute in component settings if filled in.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 20530117702297668 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
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
'  <li>off: No width attribute will be set. Keep in mind that the Select2 item copies classes from the source element so setting the width attribute may not always be necessary.</li>'||unistr('\000a')||
'  <li><b>element</b> (default): Uses javascript to calculate the width of the source element.</li>'||unistr('\000a')||
'  <li>copy: Copies the value of the width style attribute set on the source element.</li>'||unistr('\000a')||
'  <li>resolve: First attempts to copy than falls back on element.</li>'||unistr('\000a')||
'  <li>other values: Any valid CSS style width value (e.g. 400px or 100%).</li>'||unistr('\000a')||
'</ul>'
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
  p_id => 40942025191291279 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2-spinner.gif'
 ,p_mime_type => 'image/gif'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A56657273696F6E3A20332E342E322054696D657374616D703A204D6F6E204175672031322031353A30343A31322050445420323031330A2A2F0A2E73656C656374322D636F6E7461696E6572207B0A202020206D617267696E3A20303B0A202020';
wwv_flow_api.g_varchar2_table(2) := '20706F736974696F6E3A2072656C61746976653B0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0A202020202F2A20696E6C696E652D626C6F636B20666F7220696537202A2F0A202020207A6F6F6D3A20313B0A202020202A646973';
wwv_flow_api.g_varchar2_table(3) := '706C61793A20696E6C696E653B0A20202020766572746963616C2D616C69676E3A206D6964646C653B0A7D0A0A2E73656C656374322D636F6E7461696E65722C0A2E73656C656374322D64726F702C0A2E73656C656374322D7365617263682C0A2E7365';
wwv_flow_api.g_varchar2_table(4) := '6C656374322D73656172636820696E707574207B0A20202F2A0A20202020466F72636520626F726465722D626F7820736F2074686174202520776964746873206669742074686520706172656E740A20202020636F6E7461696E657220776974686F7574';
wwv_flow_api.g_varchar2_table(5) := '206F7665726C61702062656361757365206F66206D617267696E2F70616464696E672E0A0A202020204D6F726520496E666F203A20687474703A2F2F7777772E717569726B736D6F64652E6F72672F6373732F626F782E68746D6C0A20202A2F0A20202D';
wwv_flow_api.g_varchar2_table(6) := '7765626B69742D626F782D73697A696E673A20626F726465722D626F783B202F2A207765626B6974202A2F0A20202020202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B202F2A2066697265666F78202A2F0A2020202020202020';
wwv_flow_api.g_varchar2_table(7) := '2020626F782D73697A696E673A20626F726465722D626F783B202F2A2063737333202A2F0A7D0A0A2E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365207B0A20202020646973706C61793A20626C6F636B3B0A202020';
wwv_flow_api.g_varchar2_table(8) := '206865696768743A20323670783B0A2020202070616464696E673A203020302030203870783B0A202020206F766572666C6F773A2068696464656E3B0A20202020706F736974696F6E3A2072656C61746976653B0A0A20202020626F726465723A203170';
wwv_flow_api.g_varchar2_table(9) := '7820736F6C696420236161613B0A2020202077686974652D73706163653A206E6F777261703B0A202020206C696E652D6865696768743A20323670783B0A20202020636F6C6F723A20233434343B0A20202020746578742D6465636F726174696F6E3A20';
wwv_flow_api.g_varchar2_table(10) := '6E6F6E653B0A0A20202020626F726465722D7261646975733A203470783B0A0A202020206261636B67726F756E642D636C69703A2070616464696E672D626F783B0A0A202020202D7765626B69742D746F7563682D63616C6C6F75743A206E6F6E653B0A';
wwv_flow_api.g_varchar2_table(11) := '2020202020202D7765626B69742D757365722D73656C6563743A206E6F6E653B0A202020202020202D6B68746D6C2D757365722D73656C6563743A206E6F6E653B0A2020202020202020202D6D6F7A2D757365722D73656C6563743A206E6F6E653B0A20';
wwv_flow_api.g_varchar2_table(12) := '2020202020202020202D6D732D757365722D73656C6563743A206E6F6E653B0A2020202020202020202020202020757365722D73656C6563743A206E6F6E653B0A0A202020206261636B67726F756E642D636F6C6F723A20236666663B0A202020206261';
wwv_flow_api.g_varchar2_table(13) := '636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E74286C696E6561722C206C65667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302C2023656565292C20636F6C6F722D73746F7028302E352C';
wwv_flow_api.g_varchar2_table(14) := '202366666629293B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C20236565652030252C202366666620353025293B0A202020206261636B6772';
wwv_flow_api.g_varchar2_table(15) := '6F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C20236565652030252C202366666620353025293B0A202020206261636B67726F756E642D696D6167653A202D6F2D6C696E6561722D';
wwv_flow_api.g_varchar2_table(16) := '6772616469656E7428626F74746F6D2C20236565652030252C202366666620353025293B0A202020206261636B67726F756E642D696D6167653A202D6D732D6C696E6561722D6772616469656E7428746F702C20236666662030252C2023656565203530';
wwv_flow_api.g_varchar2_table(17) := '25293B0A2020202066696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F72737472203D202723666666666666272C20656E64436F6C6F72737472203D20';
wwv_flow_api.g_varchar2_table(18) := '2723656565656565272C204772616469656E7454797065203D2030293B0A202020206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E7428746F702C20236666662030252C202365656520353025293B0A7D0A0A2E73656C';
wwv_flow_api.g_varchar2_table(19) := '656374322D636F6E7461696E65722E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F696365207B0A20202020626F726465722D626F74746F6D2D636F6C6F723A20236161613B0A0A20202020626F726465722D7261646975';
wwv_flow_api.g_varchar2_table(20) := '733A2030203020347078203470783B0A0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E74286C696E6561722C206C65667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302C';
wwv_flow_api.g_varchar2_table(21) := '2023656565292C20636F6C6F722D73746F7028302E392C202366666629293B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C2023656565203025';
wwv_flow_api.g_varchar2_table(22) := '2C202366666620393025293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C20236565652030252C202366666620393025293B0A202020206261636B67';
wwv_flow_api.g_varchar2_table(23) := '726F756E642D696D6167653A202D6F2D6C696E6561722D6772616469656E7428626F74746F6D2C20236565652030252C202366666620393025293B0A202020206261636B67726F756E642D696D6167653A202D6D732D6C696E6561722D6772616469656E';
wwv_flow_api.g_varchar2_table(24) := '7428746F702C20236565652030252C202366666620393025293B0A2020202066696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F727374723D27236666';
wwv_flow_api.g_varchar2_table(25) := '66666666272C20656E64436F6C6F727374723D2723656565656565272C204772616469656E74547970653D30293B0A202020206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E7428746F702C20236565652030252C2023';
wwv_flow_api.g_varchar2_table(26) := '66666620393025293B0A7D0A0A2E73656C656374322D636F6E7461696E65722E73656C656374322D616C6C6F77636C656172202E73656C656374322D63686F696365202E73656C656374322D63686F73656E207B0A202020206D617267696E2D72696768';
wwv_flow_api.g_varchar2_table(27) := '743A20343270783B0A7D0A0A2E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365203E202E73656C656374322D63686F73656E207B0A202020206D617267696E2D72696768743A20323670783B0A20202020646973706C';
wwv_flow_api.g_varchar2_table(28) := '61793A20626C6F636B3B0A202020206F766572666C6F773A2068696464656E3B0A0A2020202077686974652D73706163653A206E6F777261703B0A0A20202020746578742D6F766572666C6F773A20656C6C69707369733B0A7D0A0A2E73656C65637432';
wwv_flow_api.g_varchar2_table(29) := '2D636F6E7461696E6572202E73656C656374322D63686F6963652061626272207B0A20202020646973706C61793A206E6F6E653B0A2020202077696474683A20313270783B0A202020206865696768743A20313270783B0A20202020706F736974696F6E';
wwv_flow_api.g_varchar2_table(30) := '3A206162736F6C7574653B0A2020202072696768743A20323470783B0A20202020746F703A203870783B0A0A20202020666F6E742D73697A653A203170783B0A20202020746578742D6465636F726174696F6E3A206E6F6E653B0A0A20202020626F7264';
wwv_flow_api.g_varchar2_table(31) := '65723A20303B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322E706E67272920726967687420746F70206E6F2D7265706561743B0A20202020637572736F723A20706F696E7465723B0A20';
wwv_flow_api.g_varchar2_table(32) := '2020206F75746C696E653A20303B0A7D0A0A2E73656C656374322D636F6E7461696E65722E73656C656374322D616C6C6F77636C656172202E73656C656374322D63686F6963652061626272207B0A20202020646973706C61793A20696E6C696E652D62';
wwv_flow_api.g_varchar2_table(33) := '6C6F636B3B0A7D0A0A2E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F69636520616262723A686F766572207B0A202020206261636B67726F756E642D706F736974696F6E3A207269676874202D313170783B0A2020202063';
wwv_flow_api.g_varchar2_table(34) := '7572736F723A20706F696E7465723B0A7D0A0A2E73656C656374322D64726F702D6D61736B207B0A20202020626F726465723A20303B0A202020206D617267696E3A20303B0A2020202070616464696E673A20303B0A20202020706F736974696F6E3A20';
wwv_flow_api.g_varchar2_table(35) := '66697865643B0A202020206C6566743A20303B0A20202020746F703A20303B0A202020206D696E2D6865696768743A20313030253B0A202020206D696E2D77696474683A20313030253B0A202020206865696768743A206175746F3B0A20202020776964';
wwv_flow_api.g_varchar2_table(36) := '74683A206175746F3B0A202020206F7061636974793A20303B0A202020207A2D696E6465783A20393939383B0A202020202F2A207374796C657320726571756972656420666F7220494520746F20776F726B202A2F0A202020206261636B67726F756E64';
wwv_flow_api.g_varchar2_table(37) := '2D636F6C6F723A20236666663B0A202020206F7061636974793A20303B0A2020202066696C7465723A20616C706861286F7061636974793D30293B0A7D0A0A2E73656C656374322D64726F70207B0A2020202077696474683A20313030253B0A20202020';
wwv_flow_api.g_varchar2_table(38) := '6D617267696E2D746F703A202D3170783B0A20202020706F736974696F6E3A206162736F6C7574653B0A202020207A2D696E6465783A20393939393B0A20202020746F703A20313030253B0A0A202020206261636B67726F756E643A20236666663B0A20';
wwv_flow_api.g_varchar2_table(39) := '202020636F6C6F723A20233030303B0A20202020626F726465723A2031707820736F6C696420236161613B0A20202020626F726465722D746F703A20303B0A0A20202020626F726465722D7261646975733A2030203020347078203470783B0A0A202020';
wwv_flow_api.g_varchar2_table(40) := '202D7765626B69742D626F782D736861646F773A20302034707820357078207267626128302C20302C20302C202E3135293B0A202020202020202020202020626F782D736861646F773A20302034707820357078207267626128302C20302C20302C202E';
wwv_flow_api.g_varchar2_table(41) := '3135293B0A7D0A0A2E73656C656374322D64726F702D6175746F2D7769647468207B0A20202020626F726465722D746F703A2031707820736F6C696420236161613B0A2020202077696474683A206175746F3B0A7D0A0A2E73656C656374322D64726F70';
wwv_flow_api.g_varchar2_table(42) := '2D6175746F2D7769647468202E73656C656374322D736561726368207B0A2020202070616464696E672D746F703A203470783B0A7D0A0A2E73656C656374322D64726F702E73656C656374322D64726F702D61626F7665207B0A202020206D617267696E';
wwv_flow_api.g_varchar2_table(43) := '2D746F703A203170783B0A20202020626F726465722D746F703A2031707820736F6C696420236161613B0A20202020626F726465722D626F74746F6D3A20303B0A0A20202020626F726465722D7261646975733A2034707820347078203020303B0A0A20';
wwv_flow_api.g_varchar2_table(44) := '2020202D7765626B69742D626F782D736861646F773A2030202D34707820357078207267626128302C20302C20302C202E3135293B0A202020202020202020202020626F782D736861646F773A2030202D34707820357078207267626128302C20302C20';
wwv_flow_api.g_varchar2_table(45) := '302C202E3135293B0A7D0A0A2E73656C656374322D64726F702D616374697665207B0A20202020626F726465723A2031707820736F6C696420233538393766623B0A20202020626F726465722D746F703A206E6F6E653B0A7D0A0A2E73656C656374322D';
wwv_flow_api.g_varchar2_table(46) := '64726F702E73656C656374322D64726F702D61626F76652E73656C656374322D64726F702D616374697665207B0A20202020626F726465722D746F703A2031707820736F6C696420233538393766623B0A7D0A0A2E73656C656374322D636F6E7461696E';
wwv_flow_api.g_varchar2_table(47) := '6572202E73656C656374322D63686F696365202E73656C656374322D6172726F77207B0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0A2020202077696474683A20313870783B0A202020206865696768743A20313030253B0A2020';
wwv_flow_api.g_varchar2_table(48) := '2020706F736974696F6E3A206162736F6C7574653B0A2020202072696768743A20303B0A20202020746F703A20303B0A0A20202020626F726465722D6C6566743A2031707820736F6C696420236161613B0A20202020626F726465722D7261646975733A';
wwv_flow_api.g_varchar2_table(49) := '2030203470782034707820303B0A0A202020206261636B67726F756E642D636C69703A2070616464696E672D626F783B0A0A202020206261636B67726F756E643A20236363633B0A202020206261636B67726F756E642D696D6167653A202D7765626B69';
wwv_flow_api.g_varchar2_table(50) := '742D6772616469656E74286C696E6561722C206C65667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302C2023636363292C20636F6C6F722D73746F7028302E362C202365656529293B0A202020206261636B67726F756E';
wwv_flow_api.g_varchar2_table(51) := '642D696D6167653A202D7765626B69742D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C20236363632030252C202365656520363025293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561';
wwv_flow_api.g_varchar2_table(52) := '722D6772616469656E742863656E74657220626F74746F6D2C20236363632030252C202365656520363025293B0A202020206261636B67726F756E642D696D6167653A202D6F2D6C696E6561722D6772616469656E7428626F74746F6D2C202363636320';
wwv_flow_api.g_varchar2_table(53) := '30252C202365656520363025293B0A202020206261636B67726F756E642D696D6167653A202D6D732D6C696E6561722D6772616469656E7428746F702C20236363632030252C202365656520363025293B0A2020202066696C7465723A2070726F676964';
wwv_flow_api.g_varchar2_table(54) := '3A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F72737472203D202723656565656565272C20656E64436F6C6F72737472203D202723636363636363272C204772616469656E74547970';
wwv_flow_api.g_varchar2_table(55) := '65203D2030293B0A202020206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E7428746F702C20236363632030252C202365656520363025293B0A7D0A0A2E73656C656374322D636F6E7461696E6572202E73656C656374';
wwv_flow_api.g_varchar2_table(56) := '322D63686F696365202E73656C656374322D6172726F772062207B0A20202020646973706C61793A20626C6F636B3B0A2020202077696474683A20313030253B0A202020206865696768743A20313030253B0A202020206261636B67726F756E643A2075';
wwv_flow_api.g_varchar2_table(57) := '726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D7265706561742030203170783B0A7D0A0A2E73656C656374322D736561726368207B0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0A2020';
wwv_flow_api.g_varchar2_table(58) := '202077696474683A20313030253B0A202020206D696E2D6865696768743A20323670783B0A202020206D617267696E3A20303B0A2020202070616464696E672D6C6566743A203470783B0A2020202070616464696E672D72696768743A203470783B0A0A';
wwv_flow_api.g_varchar2_table(59) := '20202020706F736974696F6E3A2072656C61746976653B0A202020207A2D696E6465783A2031303030303B0A0A2020202077686974652D73706163653A206E6F777261703B0A7D0A0A2E73656C656374322D73656172636820696E707574207B0A202020';
wwv_flow_api.g_varchar2_table(60) := '2077696474683A20313030253B0A202020206865696768743A206175746F2021696D706F7274616E743B0A202020206D696E2D6865696768743A20323670783B0A2020202070616464696E673A20347078203230707820347078203570783B0A20202020';
wwv_flow_api.g_varchar2_table(61) := '6D617267696E3A20303B0A0A202020206F75746C696E653A20303B0A20202020666F6E742D66616D696C793A2073616E732D73657269663B0A20202020666F6E742D73697A653A2031656D3B0A0A20202020626F726465723A2031707820736F6C696420';
wwv_flow_api.g_varchar2_table(62) := '236161613B0A20202020626F726465722D7261646975733A20303B0A0A202020202D7765626B69742D626F782D736861646F773A206E6F6E653B0A202020202020202020202020626F782D736861646F773A206E6F6E653B0A0A202020206261636B6772';
wwv_flow_api.g_varchar2_table(63) := '6F756E643A20236666662075726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D7265706561742031303025202D323270783B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F50524546';
wwv_flow_api.g_varchar2_table(64) := '49582373656C656374322E706E672729206E6F2D7265706561742031303025202D323270782C202D7765626B69742D6772616469656E74286C696E6561722C206C65667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302E';
wwv_flow_api.g_varchar2_table(65) := '38352C2023666666292C20636F6C6F722D73746F7028302E39392C202365656529293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D7265706561742031303025';
wwv_flow_api.g_varchar2_table(66) := '202D323270782C202D7765626B69742D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C2023666666203835252C202365656520393925293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F505245';
wwv_flow_api.g_varchar2_table(67) := '4649582373656C656374322E706E672729206E6F2D7265706561742031303025202D323270782C202D6D6F7A2D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C2023666666203835252C202365656520393925293B0A202020';
wwv_flow_api.g_varchar2_table(68) := '206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D7265706561742031303025202D323270782C202D6F2D6C696E6561722D6772616469656E7428626F74746F6D2C2023666666';
wwv_flow_api.g_varchar2_table(69) := '203835252C202365656520393925293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D7265706561742031303025202D323270782C202D6D732D6C696E6561722D';
wwv_flow_api.g_varchar2_table(70) := '6772616469656E7428746F702C2023666666203835252C202365656520393925293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322E706E672729206E6F2D726570656174203130302520';
wwv_flow_api.g_varchar2_table(71) := '2D323270782C206C696E6561722D6772616469656E7428746F702C2023666666203835252C202365656520393925293B0A7D0A0A2E73656C656374322D64726F702E73656C656374322D64726F702D61626F7665202E73656C656374322D736561726368';
wwv_flow_api.g_varchar2_table(72) := '20696E707574207B0A202020206D617267696E2D746F703A203470783B0A7D0A0A2E73656C656374322D73656172636820696E7075742E73656C656374322D616374697665207B0A202020206261636B67726F756E643A20236666662075726C28272350';
wwv_flow_api.g_varchar2_table(73) := '4C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030253B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322D7370696E6E';
wwv_flow_api.g_varchar2_table(74) := '65722E6769662729206E6F2D72657065617420313030252C202D7765626B69742D6772616469656E74286C696E6561722C206C65667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302E38352C2023666666292C20636F6C';
wwv_flow_api.g_varchar2_table(75) := '6F722D73746F7028302E39392C202365656529293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030252C202D776562';
wwv_flow_api.g_varchar2_table(76) := '6B69742D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C2023666666203835252C202365656520393925293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322D';
wwv_flow_api.g_varchar2_table(77) := '7370696E6E65722E6769662729206E6F2D72657065617420313030252C202D6D6F7A2D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C2023666666203835252C202365656520393925293B0A202020206261636B67726F756E';
wwv_flow_api.g_varchar2_table(78) := '643A2075726C282723504C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030252C202D6F2D6C696E6561722D6772616469656E7428626F74746F6D2C2023666666203835252C202365';
wwv_flow_api.g_varchar2_table(79) := '656520393925293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030252C202D6D732D6C696E6561722D677261646965';
wwv_flow_api.g_varchar2_table(80) := '6E7428746F702C2023666666203835252C202365656520393925293B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030';
wwv_flow_api.g_varchar2_table(81) := '252C206C696E6561722D6772616469656E7428746F702C2023666666203835252C202365656520393925293B0A7D0A0A2E73656C656374322D636F6E7461696E65722D616374697665202E73656C656374322D63686F6963652C0A2E73656C656374322D';
wwv_flow_api.g_varchar2_table(82) := '636F6E7461696E65722D616374697665202E73656C656374322D63686F69636573207B0A20202020626F726465723A2031707820736F6C696420233538393766623B0A202020206F75746C696E653A206E6F6E653B0A0A202020202D7765626B69742D62';
wwv_flow_api.g_varchar2_table(83) := '6F782D736861646F773A2030203020357078207267626128302C20302C20302C202E33293B0A202020202020202020202020626F782D736861646F773A2030203020357078207267626128302C20302C20302C202E33293B0A7D0A0A2E73656C65637432';
wwv_flow_api.g_varchar2_table(84) := '2D64726F70646F776E2D6F70656E202E73656C656374322D63686F696365207B0A20202020626F726465722D626F74746F6D2D636F6C6F723A207472616E73706172656E743B0A202020202D7765626B69742D626F782D736861646F773A203020317078';
wwv_flow_api.g_varchar2_table(85) := '2030202366666620696E7365743B0A202020202020202020202020626F782D736861646F773A2030203170782030202366666620696E7365743B0A0A20202020626F726465722D626F74746F6D2D6C6566742D7261646975733A20303B0A20202020626F';
wwv_flow_api.g_varchar2_table(86) := '726465722D626F74746F6D2D72696768742D7261646975733A20303B0A0A202020206261636B67726F756E642D636F6C6F723A20236565653B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E74286C696E';
wwv_flow_api.g_varchar2_table(87) := '6561722C206C65667420626F74746F6D2C206C65667420746F702C20636F6C6F722D73746F7028302C2023666666292C20636F6C6F722D73746F7028302E352C202365656529293B0A202020206261636B67726F756E642D696D6167653A202D7765626B';
wwv_flow_api.g_varchar2_table(88) := '69742D6C696E6561722D6772616469656E742863656E74657220626F74746F6D2C20236666662030252C202365656520353025293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E742863656E';
wwv_flow_api.g_varchar2_table(89) := '74657220626F74746F6D2C20236666662030252C202365656520353025293B0A202020206261636B67726F756E642D696D6167653A202D6F2D6C696E6561722D6772616469656E7428626F74746F6D2C20236666662030252C202365656520353025293B';
wwv_flow_api.g_varchar2_table(90) := '0A202020206261636B67726F756E642D696D6167653A202D6D732D6C696E6561722D6772616469656E7428746F702C20236666662030252C202365656520353025293B0A2020202066696C7465723A2070726F6769643A4458496D6167655472616E7366';
wwv_flow_api.g_varchar2_table(91) := '6F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F727374723D2723656565656565272C20656E64436F6C6F727374723D2723666666666666272C204772616469656E74547970653D30293B0A202020206261636B67726F75';
wwv_flow_api.g_varchar2_table(92) := '6E642D696D6167653A206C696E6561722D6772616469656E7428746F702C20236666662030252C202365656520353025293B0A7D0A0A2E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C';
wwv_flow_api.g_varchar2_table(93) := '656374322D63686F6963652C0A2E73656C656374322D64726F70646F776E2D6F70656E2E73656C656374322D64726F702D61626F7665202E73656C656374322D63686F69636573207B0A20202020626F726465723A2031707820736F6C69642023353839';
wwv_flow_api.g_varchar2_table(94) := '3766623B0A20202020626F726465722D746F702D636F6C6F723A207472616E73706172656E743B0A0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E74286C696E6561722C206C65667420746F702C206C65';
wwv_flow_api.g_varchar2_table(95) := '667420626F74746F6D2C20636F6C6F722D73746F7028302C2023666666292C20636F6C6F722D73746F7028302E352C202365656529293B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6C696E6561722D6772616469656E';
wwv_flow_api.g_varchar2_table(96) := '742863656E74657220746F702C20236666662030252C202365656520353025293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E742863656E74657220746F702C20236666662030252C202365';
wwv_flow_api.g_varchar2_table(97) := '656520353025293B0A202020206261636B67726F756E642D696D6167653A202D6F2D6C696E6561722D6772616469656E7428746F702C20236666662030252C202365656520353025293B0A202020206261636B67726F756E642D696D6167653A202D6D73';
wwv_flow_api.g_varchar2_table(98) := '2D6C696E6561722D6772616469656E7428626F74746F6D2C20236666662030252C202365656520353025293B0A2020202066696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E7428';
wwv_flow_api.g_varchar2_table(99) := '7374617274436F6C6F727374723D2723656565656565272C20656E64436F6C6F727374723D2723666666666666272C204772616469656E74547970653D30293B0A202020206261636B67726F756E642D696D6167653A206C696E6561722D677261646965';
wwv_flow_api.g_varchar2_table(100) := '6E7428626F74746F6D2C20236666662030252C202365656520353025293B0A7D0A0A2E73656C656374322D64726F70646F776E2D6F70656E202E73656C656374322D63686F696365202E73656C656374322D6172726F77207B0A202020206261636B6772';
wwv_flow_api.g_varchar2_table(101) := '6F756E643A207472616E73706172656E743B0A20202020626F726465722D6C6566743A206E6F6E653B0A2020202066696C7465723A206E6F6E653B0A7D0A2E73656C656374322D64726F70646F776E2D6F70656E202E73656C656374322D63686F696365';
wwv_flow_api.g_varchar2_table(102) := '202E73656C656374322D6172726F772062207B0A202020206261636B67726F756E642D706F736974696F6E3A202D31387078203170783B0A7D0A0A2F2A20726573756C7473202A2F0A2E73656C656374322D726573756C7473207B0A202020206D61782D';
wwv_flow_api.g_varchar2_table(103) := '6865696768743A2032303070783B0A2020202070616464696E673A203020302030203470783B0A202020206D617267696E3A20347078203470782034707820303B0A20202020706F736974696F6E3A2072656C61746976653B0A202020206F766572666C';
wwv_flow_api.g_varchar2_table(104) := '6F772D783A2068696464656E3B0A202020206F766572666C6F772D793A206175746F3B0A202020202D7765626B69742D7461702D686967686C696768742D636F6C6F723A207267626128302C20302C20302C2030293B0A7D0A0A2E73656C656374322D72';
wwv_flow_api.g_varchar2_table(105) := '6573756C747320756C2E73656C656374322D726573756C742D737562207B0A202020206D617267696E3A20303B0A2020202070616464696E672D6C6566743A20303B0A7D0A0A2E73656C656374322D726573756C747320756C2E73656C656374322D7265';
wwv_flow_api.g_varchar2_table(106) := '73756C742D737562203E206C69202E73656C656374322D726573756C742D6C6162656C207B2070616464696E672D6C6566743A2032307078207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220756C';
wwv_flow_api.g_varchar2_table(107) := '2E73656C656374322D726573756C742D737562203E206C69202E73656C656374322D726573756C742D6C6162656C207B2070616464696E672D6C6566743A2034307078207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D7265';
wwv_flow_api.g_varchar2_table(108) := '73756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D737562203E206C69202E73656C656374322D726573756C742D6C6162656C207B2070616464696E672D6C6566743A2036307078';
wwv_flow_api.g_varchar2_table(109) := '207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573';
wwv_flow_api.g_varchar2_table(110) := '756C742D737562203E206C69202E73656C656374322D726573756C742D6C6162656C207B2070616464696E672D6C6566743A2038307078207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220756C2E';
wwv_flow_api.g_varchar2_table(111) := '73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D737562203E206C69202E73656C656374322D72';
wwv_flow_api.g_varchar2_table(112) := '6573756C742D6C6162656C207B2070616464696E672D6C6566743A203130307078207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E';
wwv_flow_api.g_varchar2_table(113) := '73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D737562203E206C69202E73656C656374322D72';
wwv_flow_api.g_varchar2_table(114) := '6573756C742D6C6162656C207B2070616464696E672D6C6566743A203131307078207D0A2E73656C656374322D726573756C747320756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E';
wwv_flow_api.g_varchar2_table(115) := '73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D726573756C742D73756220756C2E73656C656374322D72657375';
wwv_flow_api.g_varchar2_table(116) := '6C742D737562203E206C69202E73656C656374322D726573756C742D6C6162656C207B2070616464696E672D6C6566743A203132307078207D0A0A2E73656C656374322D726573756C7473206C69207B0A202020206C6973742D7374796C653A206E6F6E';
wwv_flow_api.g_varchar2_table(117) := '653B0A20202020646973706C61793A206C6973742D6974656D3B0A202020206261636B67726F756E642D696D6167653A206E6F6E653B0A7D0A0A2E73656C656374322D726573756C7473206C692E73656C656374322D726573756C742D776974682D6368';
wwv_flow_api.g_varchar2_table(118) := '696C6472656E203E202E73656C656374322D726573756C742D6C6162656C207B0A20202020666F6E742D7765696768743A20626F6C643B0A7D0A0A2E73656C656374322D726573756C7473202E73656C656374322D726573756C742D6C6162656C207B0A';
wwv_flow_api.g_varchar2_table(119) := '2020202070616464696E673A2033707820377078203470783B0A202020206D617267696E3A20303B0A20202020637572736F723A20706F696E7465723B0A0A202020206D696E2D6865696768743A2031656D3B0A0A202020202D7765626B69742D746F75';
wwv_flow_api.g_varchar2_table(120) := '63682D63616C6C6F75743A206E6F6E653B0A2020202020202D7765626B69742D757365722D73656C6563743A206E6F6E653B0A202020202020202D6B68746D6C2D757365722D73656C6563743A206E6F6E653B0A2020202020202020202D6D6F7A2D7573';
wwv_flow_api.g_varchar2_table(121) := '65722D73656C6563743A206E6F6E653B0A202020202020202020202D6D732D757365722D73656C6563743A206E6F6E653B0A2020202020202020202020202020757365722D73656C6563743A206E6F6E653B0A7D0A0A2E73656C656374322D726573756C';
wwv_flow_api.g_varchar2_table(122) := '7473202E73656C656374322D686967686C696768746564207B0A202020206261636B67726F756E643A20233338373564373B0A20202020636F6C6F723A20236666663B0A7D0A0A2E73656C656374322D726573756C7473206C6920656D207B0A20202020';
wwv_flow_api.g_varchar2_table(123) := '6261636B67726F756E643A20236665666664653B0A20202020666F6E742D7374796C653A206E6F726D616C3B0A7D0A0A2E73656C656374322D726573756C7473202E73656C656374322D686967686C69676874656420656D207B0A202020206261636B67';
wwv_flow_api.g_varchar2_table(124) := '726F756E643A207472616E73706172656E743B0A7D0A0A2E73656C656374322D726573756C7473202E73656C656374322D686967686C69676874656420756C207B0A202020206261636B67726F756E643A20236666663B0A20202020636F6C6F723A2023';
wwv_flow_api.g_varchar2_table(125) := '3030303B0A7D0A0A0A2E73656C656374322D726573756C7473202E73656C656374322D6E6F2D726573756C74732C0A2E73656C656374322D726573756C7473202E73656C656374322D736561726368696E672C0A2E73656C656374322D726573756C7473';
wwv_flow_api.g_varchar2_table(126) := '202E73656C656374322D73656C656374696F6E2D6C696D6974207B0A202020206261636B67726F756E643A20236634663466343B0A20202020646973706C61793A206C6973742D6974656D3B0A7D0A0A2F2A0A64697361626C6564206C6F6F6B20666F72';
wwv_flow_api.g_varchar2_table(127) := '2064697361626C65642063686F6963657320696E2074686520726573756C74732064726F70646F776E0A2A2F0A2E73656C656374322D726573756C7473202E73656C656374322D64697361626C65642E73656C656374322D686967686C69676874656420';
wwv_flow_api.g_varchar2_table(128) := '7B0A20202020636F6C6F723A20233636363B0A202020206261636B67726F756E643A20236634663466343B0A20202020646973706C61793A206C6973742D6974656D3B0A20202020637572736F723A2064656661756C743B0A7D0A2E73656C656374322D';
wwv_flow_api.g_varchar2_table(129) := '726573756C7473202E73656C656374322D64697361626C6564207B0A20206261636B67726F756E643A20236634663466343B0A2020646973706C61793A206C6973742D6974656D3B0A2020637572736F723A2064656661756C743B0A7D0A0A2E73656C65';
wwv_flow_api.g_varchar2_table(130) := '6374322D726573756C7473202E73656C656374322D73656C6563746564207B0A20202020646973706C61793A206E6F6E653B0A7D0A0A2E73656C656374322D6D6F72652D726573756C74732E73656C656374322D616374697665207B0A20202020626163';
wwv_flow_api.g_varchar2_table(131) := '6B67726F756E643A20236634663466342075726C282723504C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030253B0A7D0A0A2E73656C656374322D6D6F72652D726573756C747320';
wwv_flow_api.g_varchar2_table(132) := '7B0A202020206261636B67726F756E643A20236634663466343B0A20202020646973706C61793A206C6973742D6974656D3B0A7D0A0A2F2A2064697361626C6564207374796C6573202A2F0A0A2E73656C656374322D636F6E7461696E65722E73656C65';
wwv_flow_api.g_varchar2_table(133) := '6374322D636F6E7461696E65722D64697361626C6564202E73656C656374322D63686F696365207B0A202020206261636B67726F756E642D636F6C6F723A20236634663466343B0A202020206261636B67726F756E642D696D6167653A206E6F6E653B0A';
wwv_flow_api.g_varchar2_table(134) := '20202020626F726465723A2031707820736F6C696420236464643B0A20202020637572736F723A2064656661756C743B0A7D0A0A2E73656C656374322D636F6E7461696E65722E73656C656374322D636F6E7461696E65722D64697361626C6564202E73';
wwv_flow_api.g_varchar2_table(135) := '656C656374322D63686F696365202E73656C656374322D6172726F77207B0A202020206261636B67726F756E642D636F6C6F723A20236634663466343B0A202020206261636B67726F756E642D696D6167653A206E6F6E653B0A20202020626F72646572';
wwv_flow_api.g_varchar2_table(136) := '2D6C6566743A20303B0A7D0A0A2E73656C656374322D636F6E7461696E65722E73656C656374322D636F6E7461696E65722D64697361626C6564202E73656C656374322D63686F6963652061626272207B0A20202020646973706C61793A206E6F6E653B';
wwv_flow_api.g_varchar2_table(137) := '0A7D0A0A0A2F2A206D756C746973656C656374202A2F0A0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573207B0A202020206865696768743A206175746F2021696D706F7274616E743B0A202020';
wwv_flow_api.g_varchar2_table(138) := '206865696768743A2031253B0A202020206D617267696E3A20303B0A2020202070616464696E673A20303B0A20202020706F736974696F6E3A2072656C61746976653B0A0A20202020626F726465723A2031707820736F6C696420236161613B0A202020';
wwv_flow_api.g_varchar2_table(139) := '20637572736F723A20746578743B0A202020206F766572666C6F773A2068696464656E3B0A0A202020206261636B67726F756E642D636F6C6F723A20236666663B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D67726164';
wwv_flow_api.g_varchar2_table(140) := '69656E74286C696E6561722C2030252030252C20302520313030252C20636F6C6F722D73746F702831252C2023656565292C20636F6C6F722D73746F70283135252C202366666629293B0A202020206261636B67726F756E642D696D6167653A202D7765';
wwv_flow_api.g_varchar2_table(141) := '626B69742D6C696E6561722D6772616469656E7428746F702C20236565652031252C202366666620313525293B0A202020206261636B67726F756E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E7428746F702C20236565652031';
wwv_flow_api.g_varchar2_table(142) := '252C202366666620313525293B0A202020206261636B67726F756E642D696D6167653A202D6F2D6C696E6561722D6772616469656E7428746F702C20236565652031252C202366666620313525293B0A202020206261636B67726F756E642D696D616765';
wwv_flow_api.g_varchar2_table(143) := '3A202D6D732D6C696E6561722D6772616469656E7428746F702C20236565652031252C202366666620313525293B0A202020206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E7428746F702C20236565652031252C2023';
wwv_flow_api.g_varchar2_table(144) := '66666620313525293B0A7D0A0A2E73656C656374322D6C6F636B6564207B0A202070616464696E673A203370782035707820337078203570782021696D706F7274616E743B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73';
wwv_flow_api.g_varchar2_table(145) := '656C656374322D63686F69636573207B0A202020206D696E2D6865696768743A20323670783B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C74692E73656C656374322D636F6E7461696E65722D616374697665202E73656C65637432';
wwv_flow_api.g_varchar2_table(146) := '2D63686F69636573207B0A20202020626F726465723A2031707820736F6C696420233538393766623B0A202020206F75746C696E653A206E6F6E653B0A0A202020202D7765626B69742D626F782D736861646F773A203020302035707820726762612830';
wwv_flow_api.g_varchar2_table(147) := '2C20302C20302C202E33293B0A202020202020202020202020626F782D736861646F773A2030203020357078207267626128302C20302C20302C202E33293B0A7D0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D';
wwv_flow_api.g_varchar2_table(148) := '63686F69636573206C69207B0A20202020666C6F61743A206C6566743B0A202020206C6973742D7374796C653A206E6F6E653B0A7D0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573202E73656C';
wwv_flow_api.g_varchar2_table(149) := '656374322D7365617263682D6669656C64207B0A202020206D617267696E3A20303B0A2020202070616464696E673A20303B0A2020202077686974652D73706163653A206E6F777261703B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D75';
wwv_flow_api.g_varchar2_table(150) := '6C7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D6669656C6420696E707574207B0A2020202070616464696E673A203570783B0A202020206D617267696E3A2031707820303B0A0A20202020666F6E742D6661';
wwv_flow_api.g_varchar2_table(151) := '6D696C793A2073616E732D73657269663B0A20202020666F6E742D73697A653A20313030253B0A20202020636F6C6F723A20233636363B0A202020206F75746C696E653A20303B0A20202020626F726465723A20303B0A202020202D7765626B69742D62';
wwv_flow_api.g_varchar2_table(152) := '6F782D736861646F773A206E6F6E653B0A202020202020202020202020626F782D736861646F773A206E6F6E653B0A202020206261636B67726F756E643A207472616E73706172656E742021696D706F7274616E743B0A7D0A0A2E73656C656374322D63';
wwv_flow_api.g_varchar2_table(153) := '6F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D6669656C6420696E7075742E73656C656374322D616374697665207B0A202020206261636B67726F756E643A2023666666207572';
wwv_flow_api.g_varchar2_table(154) := '6C282723504C5547494E5F5052454649582373656C656374322D7370696E6E65722E6769662729206E6F2D72657065617420313030252021696D706F7274616E743B0A7D0A0A2E73656C656374322D64656661756C74207B0A20202020636F6C6F723A20';
wwv_flow_api.g_varchar2_table(155) := '233939392021696D706F7274616E743B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63686F696365207B0A2020202070616464696E673A20';
wwv_flow_api.g_varchar2_table(156) := '337078203570782033707820313870783B0A202020206D617267696E3A20337078203020337078203570783B0A20202020706F736974696F6E3A2072656C61746976653B0A0A202020206C696E652D6865696768743A20313370783B0A20202020636F6C';
wwv_flow_api.g_varchar2_table(157) := '6F723A20233333333B0A20202020637572736F723A2064656661756C743B0A20202020626F726465723A2031707820736F6C696420236161616161613B0A0A20202020626F726465722D7261646975733A203370783B0A0A202020202D7765626B69742D';
wwv_flow_api.g_varchar2_table(158) := '626F782D736861646F773A2030203020327078202366666620696E7365742C2030203170782030207267626128302C20302C20302C20302E3035293B0A202020202020202020202020626F782D736861646F773A2030203020327078202366666620696E';
wwv_flow_api.g_varchar2_table(159) := '7365742C2030203170782030207267626128302C20302C20302C20302E3035293B0A0A202020206261636B67726F756E642D636C69703A2070616464696E672D626F783B0A0A202020202D7765626B69742D746F7563682D63616C6C6F75743A206E6F6E';
wwv_flow_api.g_varchar2_table(160) := '653B0A2020202020202D7765626B69742D757365722D73656C6563743A206E6F6E653B0A202020202020202D6B68746D6C2D757365722D73656C6563743A206E6F6E653B0A2020202020202020202D6D6F7A2D757365722D73656C6563743A206E6F6E65';
wwv_flow_api.g_varchar2_table(161) := '3B0A202020202020202020202D6D732D757365722D73656C6563743A206E6F6E653B0A2020202020202020202020202020757365722D73656C6563743A206E6F6E653B0A0A202020206261636B67726F756E642D636F6C6F723A20236534653465343B0A';
wwv_flow_api.g_varchar2_table(162) := '2020202066696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E74287374617274436F6C6F727374723D2723656565656565272C20656E64436F6C6F727374723D2723663466346634';
wwv_flow_api.g_varchar2_table(163) := '272C204772616469656E74547970653D30293B0A202020206261636B67726F756E642D696D6167653A202D7765626B69742D6772616469656E74286C696E6561722C2030252030252C20302520313030252C20636F6C6F722D73746F70283230252C2023';
wwv_flow_api.g_varchar2_table(164) := '663466346634292C20636F6C6F722D73746F70283530252C2023663066306630292C20636F6C6F722D73746F70283532252C2023653865386538292C20636F6C6F722D73746F7028313030252C202365656529293B0A202020206261636B67726F756E64';
wwv_flow_api.g_varchar2_table(165) := '2D696D6167653A202D7765626B69742D6C696E6561722D6772616469656E7428746F702C2023663466346634203230252C2023663066306630203530252C2023653865386538203532252C20236565652031303025293B0A202020206261636B67726F75';
wwv_flow_api.g_varchar2_table(166) := '6E642D696D6167653A202D6D6F7A2D6C696E6561722D6772616469656E7428746F702C2023663466346634203230252C2023663066306630203530252C2023653865386538203532252C20236565652031303025293B0A202020206261636B67726F756E';
wwv_flow_api.g_varchar2_table(167) := '642D696D6167653A202D6F2D6C696E6561722D6772616469656E7428746F702C2023663466346634203230252C2023663066306630203530252C2023653865386538203532252C20236565652031303025293B0A202020206261636B67726F756E642D69';
wwv_flow_api.g_varchar2_table(168) := '6D6167653A202D6D732D6C696E6561722D6772616469656E7428746F702C2023663466346634203230252C2023663066306630203530252C2023653865386538203532252C20236565652031303025293B0A202020206261636B67726F756E642D696D61';
wwv_flow_api.g_varchar2_table(169) := '67653A206C696E6561722D6772616469656E7428746F702C2023663466346634203230252C2023663066306630203530252C2023653865386538203532252C20236565652031303025293B0A7D0A2E73656C656374322D636F6E7461696E65722D6D756C';
wwv_flow_api.g_varchar2_table(170) := '7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63686F696365202E73656C656374322D63686F73656E207B0A20202020637572736F723A2064656661756C743B0A7D0A2E73656C656374322D636F6E7461696E';
wwv_flow_api.g_varchar2_table(171) := '65722D6D756C7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63686F6963652D666F637573207B0A202020206261636B67726F756E643A20236434643464343B0A7D0A0A2E73656C656374322D736561726368';
wwv_flow_api.g_varchar2_table(172) := '2D63686F6963652D636C6F7365207B0A20202020646973706C61793A20626C6F636B3B0A2020202077696474683A20313270783B0A202020206865696768743A20313370783B0A20202020706F736974696F6E3A206162736F6C7574653B0A2020202072';
wwv_flow_api.g_varchar2_table(173) := '696768743A203370783B0A20202020746F703A203470783B0A0A20202020666F6E742D73697A653A203170783B0A202020206F75746C696E653A206E6F6E653B0A202020206261636B67726F756E643A2075726C282723504C5547494E5F505245464958';
wwv_flow_api.g_varchar2_table(174) := '2373656C656374322E706E67272920726967687420746F70206E6F2D7265706561743B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D7365617263682D63686F6963652D636C6F7365207B0A202020206C';
wwv_flow_api.g_varchar2_table(175) := '6566743A203370783B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63686F696365202E73656C656374322D7365617263682D63686F696365';
wwv_flow_api.g_varchar2_table(176) := '2D636C6F73653A686F766572207B0A20206261636B67726F756E642D706F736974696F6E3A207269676874202D313170783B0A7D0A2E73656C656374322D636F6E7461696E65722D6D756C7469202E73656C656374322D63686F69636573202E73656C65';
wwv_flow_api.g_varchar2_table(177) := '6374322D7365617263682D63686F6963652D666F637573202E73656C656374322D7365617263682D63686F6963652D636C6F7365207B0A202020206261636B67726F756E642D706F736974696F6E3A207269676874202D313170783B0A7D0A0A2F2A2064';
wwv_flow_api.g_varchar2_table(178) := '697361626C6564207374796C6573202A2F0A2E73656C656374322D636F6E7461696E65722D6D756C74692E73656C656374322D636F6E7461696E65722D64697361626C6564202E73656C656374322D63686F69636573207B0A202020206261636B67726F';
wwv_flow_api.g_varchar2_table(179) := '756E642D636F6C6F723A20236634663466343B0A202020206261636B67726F756E642D696D6167653A206E6F6E653B0A20202020626F726465723A2031707820736F6C696420236464643B0A20202020637572736F723A2064656661756C743B0A7D0A0A';
wwv_flow_api.g_varchar2_table(180) := '2E73656C656374322D636F6E7461696E65722D6D756C74692E73656C656374322D636F6E7461696E65722D64697361626C6564202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63686F696365207B0A202020207061';
wwv_flow_api.g_varchar2_table(181) := '6464696E673A203370782035707820337078203570783B0A20202020626F726465723A2031707820736F6C696420236464643B0A202020206261636B67726F756E642D696D6167653A206E6F6E653B0A202020206261636B67726F756E642D636F6C6F72';
wwv_flow_api.g_varchar2_table(182) := '3A20236634663466343B0A7D0A0A2E73656C656374322D636F6E7461696E65722D6D756C74692E73656C656374322D636F6E7461696E65722D64697361626C6564202E73656C656374322D63686F69636573202E73656C656374322D7365617263682D63';
wwv_flow_api.g_varchar2_table(183) := '686F696365202E73656C656374322D7365617263682D63686F6963652D636C6F7365207B20202020646973706C61793A206E6F6E653B0A202020206261636B67726F756E643A206E6F6E653B0A7D0A2F2A20656E64206D756C746973656C656374202A2F';
wwv_flow_api.g_varchar2_table(184) := '0A0A0A2E73656C656374322D726573756C742D73656C65637461626C65202E73656C656374322D6D617463682C0A2E73656C656374322D726573756C742D756E73656C65637461626C65202E73656C656374322D6D61746368207B0A2020202074657874';
wwv_flow_api.g_varchar2_table(185) := '2D6465636F726174696F6E3A20756E6465726C696E653B0A7D0A0A2E73656C656374322D6F666673637265656E2C202E73656C656374322D6F666673637265656E3A666F637573207B0A20202020636C69703A2072656374283020302030203029202169';
wwv_flow_api.g_varchar2_table(186) := '6D706F7274616E743B0A2020202077696474683A203170782021696D706F7274616E743B0A202020206865696768743A203170782021696D706F7274616E743B0A20202020626F726465723A20302021696D706F7274616E743B0A202020206D61726769';
wwv_flow_api.g_varchar2_table(187) := '6E3A20302021696D706F7274616E743B0A2020202070616464696E673A20302021696D706F7274616E743B0A202020206F766572666C6F773A2068696464656E2021696D706F7274616E743B0A20202020706F736974696F6E3A206162736F6C75746520';
wwv_flow_api.g_varchar2_table(188) := '21696D706F7274616E743B0A202020206F75746C696E653A20302021696D706F7274616E743B0A202020206C6566743A203070782021696D706F7274616E743B0A20202020746F703A203070782021696D706F7274616E743B0A7D0A0A2E73656C656374';
wwv_flow_api.g_varchar2_table(189) := '322D646973706C61792D6E6F6E65207B0A20202020646973706C61793A206E6F6E653B0A7D0A0A2E73656C656374322D6D6561737572652D7363726F6C6C626172207B0A20202020706F736974696F6E3A206162736F6C7574653B0A20202020746F703A';
wwv_flow_api.g_varchar2_table(190) := '202D313030303070783B0A202020206C6566743A202D313030303070783B0A2020202077696474683A2031303070783B0A202020206865696768743A2031303070783B0A202020206F766572666C6F773A207363726F6C6C3B0A7D0A2F2A20526574696E';
wwv_flow_api.g_varchar2_table(191) := '612D697A652069636F6E73202A2F0A0A406D65646961206F6E6C792073637265656E20616E6420282D7765626B69742D6D696E2D6465766963652D706978656C2D726174696F3A20312E35292C206F6E6C792073637265656E20616E6420286D696E2D72';
wwv_flow_api.g_varchar2_table(192) := '65736F6C7574696F6E3A203134346470692920207B0A20202E73656C656374322D73656172636820696E7075742C202E73656C656374322D7365617263682D63686F6963652D636C6F73652C202E73656C656374322D636F6E7461696E6572202E73656C';
wwv_flow_api.g_varchar2_table(193) := '656374322D63686F69636520616262722C202E73656C656374322D636F6E7461696E6572202E73656C656374322D63686F696365202E73656C656374322D6172726F772062207B0A2020202020206261636B67726F756E642D696D6167653A2075726C28';
wwv_flow_api.g_varchar2_table(194) := '2723504C5547494E5F5052454649582373656C6563743278322E706E6727292021696D706F7274616E743B0A2020202020206261636B67726F756E642D7265706561743A206E6F2D7265706561742021696D706F7274616E743B0A202020202020626163';
wwv_flow_api.g_varchar2_table(195) := '6B67726F756E642D73697A653A203630707820343070782021696D706F7274616E743B0A20207D0A20202E73656C656374322D73656172636820696E707574207B0A2020202020206261636B67726F756E642D706F736974696F6E3A2031303025202D32';
wwv_flow_api.g_varchar2_table(196) := '3170782021696D706F7274616E743B0A20207D0A7D0A';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 40942746257292374 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2.css'
 ,p_mime_type => 'text/css'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A436F7079726967687420323031322049676F72205661796E626572670A0A56657273696F6E3A20332E342E322054696D657374616D703A204D6F6E204175672031322031353A30343A31322050445420323031330A0A5468697320736F66747761';
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
wwv_flow_api.g_varchar2_table(40) := '74322D2229262628673D642874686973292C672626662E70757368287468697329297D29292C622E617474722822636C617373222C662E6A6F696E2822202229297D66756E6374696F6E204528612C622C632C64297B76617220653D6E28612E746F5570';
wwv_flow_api.g_varchar2_table(41) := '706572436173652829292E696E6465784F66286E28622E746F557070657243617365282929292C663D622E6C656E6774683B72657475726E20303E653F28632E707573682864286129292C766F69642030293A28632E70757368286428612E7375627374';
wwv_flow_api.g_varchar2_table(42) := '72696E6728302C652929292C632E7075736828223C7370616E20636C6173733D2773656C656374322D6D61746368273E22292C632E70757368286428612E737562737472696E6728652C652B662929292C632E7075736828223C2F7370616E3E22292C63';
wwv_flow_api.g_varchar2_table(43) := '2E70757368286428612E737562737472696E6728652B662C612E6C656E6774682929292C766F69642030297D66756E6374696F6E20462861297B76617220623D7B225C5C223A22262339323B222C2226223A2226616D703B222C223C223A22266C743B22';
wwv_flow_api.g_varchar2_table(44) := '2C223E223A222667743B222C2722273A222671756F743B222C2227223A22262333393B222C222F223A22262334373B227D3B72657475726E20537472696E672861292E7265706C616365282F5B263C3E22275C2F5C5C5D2F672C66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(45) := '297B72657475726E20625B615D7D297D66756E6374696F6E20472863297B76617220642C653D6E756C6C2C663D632E71756965744D696C6C69737C7C3130302C673D632E75726C2C683D746869733B72657475726E2066756E6374696F6E2869297B7769';
wwv_flow_api.g_varchar2_table(46) := '6E646F772E636C65617254696D656F75742864292C643D77696E646F772E73657454696D656F75742866756E6374696F6E28297B76617220643D632E646174612C663D672C6A3D632E7472616E73706F72747C7C612E666E2E73656C656374322E616A61';
wwv_flow_api.g_varchar2_table(47) := '7844656661756C74732E7472616E73706F72742C6B3D7B747970653A632E747970657C7C22474554222C63616368653A632E63616368657C7C21312C6A736F6E7043616C6C6261636B3A632E6A736F6E7043616C6C6261636B7C7C622C64617461547970';
wwv_flow_api.g_varchar2_table(48) := '653A632E64617461547970657C7C226A736F6E227D2C6C3D612E657874656E64287B7D2C612E666E2E73656C656374322E616A617844656661756C74732E706172616D732C6B293B643D643F642E63616C6C28682C692E7465726D2C692E706167652C69';
wwv_flow_api.g_varchar2_table(49) := '2E636F6E74657874293A6E756C6C2C663D2266756E6374696F6E223D3D747970656F6620663F662E63616C6C28682C692E7465726D2C692E706167652C692E636F6E74657874293A662C652626652E61626F727428292C632E706172616D73262628612E';
wwv_flow_api.g_varchar2_table(50) := '697346756E6374696F6E28632E706172616D73293F612E657874656E64286C2C632E706172616D732E63616C6C286829293A612E657874656E64286C2C632E706172616D7329292C612E657874656E64286C2C7B75726C3A662C64617461547970653A63';
wwv_flow_api.g_varchar2_table(51) := '2E64617461547970652C646174613A642C737563636573733A66756E6374696F6E2861297B76617220623D632E726573756C747328612C692E70616765293B692E63616C6C6261636B2862297D7D292C653D6A2E63616C6C28682C6C297D2C66297D7D66';
wwv_flow_api.g_varchar2_table(52) := '756E6374696F6E20482862297B76617220642C652C633D622C663D66756E6374696F6E2861297B72657475726E22222B612E746578747D3B612E69734172726179286329262628653D632C633D7B726573756C74733A657D292C612E697346756E637469';
wwv_flow_api.g_varchar2_table(53) := '6F6E2863293D3D3D2131262628653D632C633D66756E6374696F6E28297B72657475726E20657D293B76617220673D6328293B72657475726E20672E74657874262628663D672E746578742C612E697346756E6374696F6E2866297C7C28643D672E7465';
wwv_flow_api.g_varchar2_table(54) := '78742C663D66756E6374696F6E2861297B72657475726E20615B645D7D29292C66756E6374696F6E2862297B76617220672C643D622E7465726D2C653D7B726573756C74733A5B5D7D3B72657475726E22223D3D3D643F28622E63616C6C6261636B2863';
wwv_flow_api.g_varchar2_table(55) := '2829292C766F69642030293A28673D66756E6374696F6E28632C65297B76617220682C693B696628633D635B305D2C632E6368696C6472656E297B683D7B7D3B666F72286920696E206329632E6861734F776E50726F7065727479286929262628685B69';
wwv_flow_api.g_varchar2_table(56) := '5D3D635B695D293B682E6368696C6472656E3D5B5D2C6128632E6368696C6472656E292E65616368322866756E6374696F6E28612C62297B6728622C682E6368696C6472656E297D292C28682E6368696C6472656E2E6C656E6774687C7C622E6D617463';
wwv_flow_api.g_varchar2_table(57) := '68657228642C662868292C6329292626652E707573682868297D656C736520622E6D61746368657228642C662863292C63292626652E707573682863297D2C61286328292E726573756C7473292E65616368322866756E6374696F6E28612C62297B6728';
wwv_flow_api.g_varchar2_table(58) := '622C652E726573756C7473297D292C622E63616C6C6261636B2865292C766F69642030297D7D66756E6374696F6E20492863297B76617220643D612E697346756E6374696F6E2863293B72657475726E2066756E6374696F6E2865297B76617220663D65';
wwv_flow_api.g_varchar2_table(59) := '2E7465726D2C673D7B726573756C74733A5B5D7D3B6128643F6328293A63292E656163682866756E6374696F6E28297B76617220613D746869732E74657874213D3D622C633D613F746869732E746578743A746869733B2822223D3D3D667C7C652E6D61';
wwv_flow_api.g_varchar2_table(60) := '746368657228662C6329292626672E726573756C74732E7075736828613F746869733A7B69643A746869732C746578743A746869737D297D292C652E63616C6C6261636B2867297D7D66756E6374696F6E204A28622C63297B696628612E697346756E63';
wwv_flow_api.g_varchar2_table(61) := '74696F6E2862292972657475726E21303B69662821622972657475726E21313B7468726F77206E6577204572726F7228632B22206D75737420626520612066756E6374696F6E206F7220612066616C73792076616C756522297D66756E6374696F6E204B';
wwv_flow_api.g_varchar2_table(62) := '2862297B72657475726E20612E697346756E6374696F6E2862293F6228293A627D66756E6374696F6E204C2862297B76617220633D303B72657475726E20612E6561636828622C66756E6374696F6E28612C62297B622E6368696C6472656E3F632B3D4C';
wwv_flow_api.g_varchar2_table(63) := '28622E6368696C6472656E293A632B2B7D292C637D66756E6374696F6E204D28612C632C642C65297B76617220682C692C6A2C6B2C6C2C663D612C673D21313B69662821652E63726561746553656172636843686F6963657C7C21652E746F6B656E5365';
wwv_flow_api.g_varchar2_table(64) := '70617261746F72737C7C652E746F6B656E536570617261746F72732E6C656E6774683C312972657475726E20623B666F72283B3B297B666F7228693D2D312C6A3D302C6B3D652E746F6B656E536570617261746F72732E6C656E6774683B6B3E6A262628';
wwv_flow_api.g_varchar2_table(65) := '6C3D652E746F6B656E536570617261746F72735B6A5D2C693D612E696E6465784F66286C292C2128693E3D3029293B6A2B2B293B696628303E6929627265616B3B696628683D612E737562737472696E6728302C69292C613D612E737562737472696E67';
wwv_flow_api.g_varchar2_table(66) := '28692B6C2E6C656E677468292C682E6C656E6774683E30262628683D652E63726561746553656172636843686F6963652E63616C6C28746869732C682C63292C68213D3D6226266E756C6C213D3D682626652E6964286829213D3D6226266E756C6C213D';
wwv_flow_api.g_varchar2_table(67) := '3D652E696428682929297B666F7228673D21312C6A3D302C6B3D632E6C656E6774683B6B3E6A3B6A2B2B296966287128652E69642868292C652E696428635B6A5D2929297B673D21303B627265616B7D677C7C642868297D7D72657475726E2066213D3D';
wwv_flow_api.g_varchar2_table(68) := '613F613A766F696420307D66756E6374696F6E204E28622C63297B76617220643D66756E6374696F6E28297B7D3B72657475726E20642E70726F746F747970653D6E657720622C642E70726F746F747970652E636F6E7374727563746F723D642C642E70';
wwv_flow_api.g_varchar2_table(69) := '726F746F747970652E706172656E743D622E70726F746F747970652C642E70726F746F747970653D612E657874656E6428642E70726F746F747970652C63292C647D69662877696E646F772E53656C656374323D3D3D62297B76617220632C642C652C66';
wwv_flow_api.g_varchar2_table(70) := '2C672C682C6A2C6B2C693D7B783A302C793A307D2C633D7B5441423A392C454E5445523A31332C4553433A32372C53504143453A33322C4C4546543A33372C55503A33382C52494748543A33392C444F574E3A34302C53484946543A31362C4354524C3A';
wwv_flow_api.g_varchar2_table(71) := '31372C414C543A31382C504147455F55503A33332C504147455F444F574E3A33342C484F4D453A33362C454E443A33352C4241434B53504143453A382C44454C4554453A34362C69734172726F773A66756E6374696F6E2861297B73776974636828613D';
wwv_flow_api.g_varchar2_table(72) := '612E77686963683F612E77686963683A61297B6361736520632E4C4546543A6361736520632E52494748543A6361736520632E55503A6361736520632E444F574E3A72657475726E21307D72657475726E21317D2C6973436F6E74726F6C3A66756E6374';
wwv_flow_api.g_varchar2_table(73) := '696F6E2861297B76617220623D612E77686963683B7377697463682862297B6361736520632E53484946543A6361736520632E4354524C3A6361736520632E414C543A72657475726E21307D72657475726E20612E6D6574614B65793F21303A21317D2C';
wwv_flow_api.g_varchar2_table(74) := '697346756E6374696F6E4B65793A66756E6374696F6E2861297B72657475726E20613D612E77686963683F612E77686963683A612C613E3D31313226263132333E3D617D7D2C6C3D223C64697620636C6173733D2773656C656374322D6D656173757265';
wwv_flow_api.g_varchar2_table(75) := '2D7363726F6C6C626172273E3C2F6469763E222C6D3D7B225C7532346236223A2241222C225C7566663231223A2241222C225C786330223A2241222C225C786331223A2241222C225C786332223A2241222C225C7531656136223A2241222C225C753165';
wwv_flow_api.g_varchar2_table(76) := '6134223A2241222C225C7531656161223A2241222C225C7531656138223A2241222C225C786333223A2241222C225C7530313030223A2241222C225C7530313032223A2241222C225C7531656230223A2241222C225C7531656165223A2241222C225C75';
wwv_flow_api.g_varchar2_table(77) := '31656234223A2241222C225C7531656232223A2241222C225C7530323236223A2241222C225C7530316530223A2241222C225C786334223A2241222C225C7530316465223A2241222C225C7531656132223A2241222C225C786335223A2241222C225C75';
wwv_flow_api.g_varchar2_table(78) := '30316661223A2241222C225C7530316364223A2241222C225C7530323030223A2241222C225C7530323032223A2241222C225C7531656130223A2241222C225C7531656163223A2241222C225C7531656236223A2241222C225C7531653030223A224122';
wwv_flow_api.g_varchar2_table(79) := '2C225C7530313034223A2241222C225C7530323361223A2241222C225C7532633666223A2241222C225C7561373332223A224141222C225C786336223A224145222C225C7530316663223A224145222C225C7530316532223A224145222C225C75613733';
wwv_flow_api.g_varchar2_table(80) := '34223A22414F222C225C7561373336223A224155222C225C7561373338223A224156222C225C7561373361223A224156222C225C7561373363223A224159222C225C7532346237223A2242222C225C7566663232223A2242222C225C7531653032223A22';
wwv_flow_api.g_varchar2_table(81) := '42222C225C7531653034223A2242222C225C7531653036223A2242222C225C7530323433223A2242222C225C7530313832223A2242222C225C7530313831223A2242222C225C7532346238223A2243222C225C7566663233223A2243222C225C75303130';
wwv_flow_api.g_varchar2_table(82) := '36223A2243222C225C7530313038223A2243222C225C7530313061223A2243222C225C7530313063223A2243222C225C786337223A2243222C225C7531653038223A2243222C225C7530313837223A2243222C225C7530323362223A2243222C225C7561';
wwv_flow_api.g_varchar2_table(83) := '373365223A2243222C225C7532346239223A2244222C225C7566663234223A2244222C225C7531653061223A2244222C225C7530313065223A2244222C225C7531653063223A2244222C225C7531653130223A2244222C225C7531653132223A2244222C';
wwv_flow_api.g_varchar2_table(84) := '225C7531653065223A2244222C225C7530313130223A2244222C225C7530313862223A2244222C225C7530313861223A2244222C225C7530313839223A2244222C225C7561373739223A2244222C225C7530316631223A22445A222C225C753031633422';
wwv_flow_api.g_varchar2_table(85) := '3A22445A222C225C7530316632223A22447A222C225C7530316335223A22447A222C225C7532346261223A2245222C225C7566663235223A2245222C225C786338223A2245222C225C786339223A2245222C225C786361223A2245222C225C7531656330';
wwv_flow_api.g_varchar2_table(86) := '223A2245222C225C7531656265223A2245222C225C7531656334223A2245222C225C7531656332223A2245222C225C7531656263223A2245222C225C7530313132223A2245222C225C7531653134223A2245222C225C7531653136223A2245222C225C75';
wwv_flow_api.g_varchar2_table(87) := '30313134223A2245222C225C7530313136223A2245222C225C786362223A2245222C225C7531656261223A2245222C225C7530313161223A2245222C225C7530323034223A2245222C225C7530323036223A2245222C225C7531656238223A2245222C22';
wwv_flow_api.g_varchar2_table(88) := '5C7531656336223A2245222C225C7530323238223A2245222C225C7531653163223A2245222C225C7530313138223A2245222C225C7531653138223A2245222C225C7531653161223A2245222C225C7530313930223A2245222C225C7530313865223A22';
wwv_flow_api.g_varchar2_table(89) := '45222C225C7532346262223A2246222C225C7566663236223A2246222C225C7531653165223A2246222C225C7530313931223A2246222C225C7561373762223A2246222C225C7532346263223A2247222C225C7566663237223A2247222C225C75303166';
wwv_flow_api.g_varchar2_table(90) := '34223A2247222C225C7530313163223A2247222C225C7531653230223A2247222C225C7530313165223A2247222C225C7530313230223A2247222C225C7530316536223A2247222C225C7530313232223A2247222C225C7530316534223A2247222C225C';
wwv_flow_api.g_varchar2_table(91) := '7530313933223A2247222C225C7561376130223A2247222C225C7561373764223A2247222C225C7561373765223A2247222C225C7532346264223A2248222C225C7566663238223A2248222C225C7530313234223A2248222C225C7531653232223A2248';
wwv_flow_api.g_varchar2_table(92) := '222C225C7531653236223A2248222C225C7530323165223A2248222C225C7531653234223A2248222C225C7531653238223A2248222C225C7531653261223A2248222C225C7530313236223A2248222C225C7532633637223A2248222C225C7532633735';
wwv_flow_api.g_varchar2_table(93) := '223A2248222C225C7561373864223A2248222C225C7532346265223A2249222C225C7566663239223A2249222C225C786363223A2249222C225C786364223A2249222C225C786365223A2249222C225C7530313238223A2249222C225C7530313261223A';
wwv_flow_api.g_varchar2_table(94) := '2249222C225C7530313263223A2249222C225C7530313330223A2249222C225C786366223A2249222C225C7531653265223A2249222C225C7531656338223A2249222C225C7530316366223A2249222C225C7530323038223A2249222C225C7530323061';
wwv_flow_api.g_varchar2_table(95) := '223A2249222C225C7531656361223A2249222C225C7530313265223A2249222C225C7531653263223A2249222C225C7530313937223A2249222C225C7532346266223A224A222C225C7566663261223A224A222C225C7530313334223A224A222C225C75';
wwv_flow_api.g_varchar2_table(96) := '30323438223A224A222C225C7532346330223A224B222C225C7566663262223A224B222C225C7531653330223A224B222C225C7530316538223A224B222C225C7531653332223A224B222C225C7530313336223A224B222C225C7531653334223A224B22';
wwv_flow_api.g_varchar2_table(97) := '2C225C7530313938223A224B222C225C7532633639223A224B222C225C7561373430223A224B222C225C7561373432223A224B222C225C7561373434223A224B222C225C7561376132223A224B222C225C7532346331223A224C222C225C756666326322';
wwv_flow_api.g_varchar2_table(98) := '3A224C222C225C7530313366223A224C222C225C7530313339223A224C222C225C7530313364223A224C222C225C7531653336223A224C222C225C7531653338223A224C222C225C7530313362223A224C222C225C7531653363223A224C222C225C7531';
wwv_flow_api.g_varchar2_table(99) := '653361223A224C222C225C7530313431223A224C222C225C7530323364223A224C222C225C7532633632223A224C222C225C7532633630223A224C222C225C7561373438223A224C222C225C7561373436223A224C222C225C7561373830223A224C222C';
wwv_flow_api.g_varchar2_table(100) := '225C7530316337223A224C4A222C225C7530316338223A224C6A222C225C7532346332223A224D222C225C7566663264223A224D222C225C7531653365223A224D222C225C7531653430223A224D222C225C7531653432223A224D222C225C7532633665';
wwv_flow_api.g_varchar2_table(101) := '223A224D222C225C7530313963223A224D222C225C7532346333223A224E222C225C7566663265223A224E222C225C7530316638223A224E222C225C7530313433223A224E222C225C786431223A224E222C225C7531653434223A224E222C225C753031';
wwv_flow_api.g_varchar2_table(102) := '3437223A224E222C225C7531653436223A224E222C225C7530313435223A224E222C225C7531653461223A224E222C225C7531653438223A224E222C225C7530323230223A224E222C225C7530313964223A224E222C225C7561373930223A224E222C22';
wwv_flow_api.g_varchar2_table(103) := '5C7561376134223A224E222C225C7530316361223A224E4A222C225C7530316362223A224E6A222C225C7532346334223A224F222C225C7566663266223A224F222C225C786432223A224F222C225C786433223A224F222C225C786434223A224F222C22';
wwv_flow_api.g_varchar2_table(104) := '5C7531656432223A224F222C225C7531656430223A224F222C225C7531656436223A224F222C225C7531656434223A224F222C225C786435223A224F222C225C7531653463223A224F222C225C7530323263223A224F222C225C7531653465223A224F22';
wwv_flow_api.g_varchar2_table(105) := '2C225C7530313463223A224F222C225C7531653530223A224F222C225C7531653532223A224F222C225C7530313465223A224F222C225C7530323265223A224F222C225C7530323330223A224F222C225C786436223A224F222C225C7530323261223A22';
wwv_flow_api.g_varchar2_table(106) := '4F222C225C7531656365223A224F222C225C7530313530223A224F222C225C7530316431223A224F222C225C7530323063223A224F222C225C7530323065223A224F222C225C7530316130223A224F222C225C7531656463223A224F222C225C75316564';
wwv_flow_api.g_varchar2_table(107) := '61223A224F222C225C7531656530223A224F222C225C7531656465223A224F222C225C7531656532223A224F222C225C7531656363223A224F222C225C7531656438223A224F222C225C7530316561223A224F222C225C7530316563223A224F222C225C';
wwv_flow_api.g_varchar2_table(108) := '786438223A224F222C225C7530316665223A224F222C225C7530313836223A224F222C225C7530313966223A224F222C225C7561373461223A224F222C225C7561373463223A224F222C225C7530316132223A224F49222C225C7561373465223A224F4F';
wwv_flow_api.g_varchar2_table(109) := '222C225C7530323232223A224F55222C225C7532346335223A2250222C225C7566663330223A2250222C225C7531653534223A2250222C225C7531653536223A2250222C225C7530316134223A2250222C225C7532633633223A2250222C225C75613735';
wwv_flow_api.g_varchar2_table(110) := '30223A2250222C225C7561373532223A2250222C225C7561373534223A2250222C225C7532346336223A2251222C225C7566663331223A2251222C225C7561373536223A2251222C225C7561373538223A2251222C225C7530323461223A2251222C225C';
wwv_flow_api.g_varchar2_table(111) := '7532346337223A2252222C225C7566663332223A2252222C225C7530313534223A2252222C225C7531653538223A2252222C225C7530313538223A2252222C225C7530323130223A2252222C225C7530323132223A2252222C225C7531653561223A2252';
wwv_flow_api.g_varchar2_table(112) := '222C225C7531653563223A2252222C225C7530313536223A2252222C225C7531653565223A2252222C225C7530323463223A2252222C225C7532633634223A2252222C225C7561373561223A2252222C225C7561376136223A2252222C225C7561373832';
wwv_flow_api.g_varchar2_table(113) := '223A2252222C225C7532346338223A2253222C225C7566663333223A2253222C225C7531653965223A2253222C225C7530313561223A2253222C225C7531653634223A2253222C225C7530313563223A2253222C225C7531653630223A2253222C225C75';
wwv_flow_api.g_varchar2_table(114) := '30313630223A2253222C225C7531653636223A2253222C225C7531653632223A2253222C225C7531653638223A2253222C225C7530323138223A2253222C225C7530313565223A2253222C225C7532633765223A2253222C225C7561376138223A225322';
wwv_flow_api.g_varchar2_table(115) := '2C225C7561373834223A2253222C225C7532346339223A2254222C225C7566663334223A2254222C225C7531653661223A2254222C225C7530313634223A2254222C225C7531653663223A2254222C225C7530323161223A2254222C225C753031363222';
wwv_flow_api.g_varchar2_table(116) := '3A2254222C225C7531653730223A2254222C225C7531653665223A2254222C225C7530313636223A2254222C225C7530316163223A2254222C225C7530316165223A2254222C225C7530323365223A2254222C225C7561373836223A2254222C225C7561';
wwv_flow_api.g_varchar2_table(117) := '373238223A22545A222C225C7532346361223A2255222C225C7566663335223A2255222C225C786439223A2255222C225C786461223A2255222C225C786462223A2255222C225C7530313638223A2255222C225C7531653738223A2255222C225C753031';
wwv_flow_api.g_varchar2_table(118) := '3661223A2255222C225C7531653761223A2255222C225C7530313663223A2255222C225C786463223A2255222C225C7530316462223A2255222C225C7530316437223A2255222C225C7530316435223A2255222C225C7530316439223A2255222C225C75';
wwv_flow_api.g_varchar2_table(119) := '31656536223A2255222C225C7530313665223A2255222C225C7530313730223A2255222C225C7530316433223A2255222C225C7530323134223A2255222C225C7530323136223A2255222C225C7530316166223A2255222C225C7531656561223A225522';
wwv_flow_api.g_varchar2_table(120) := '2C225C7531656538223A2255222C225C7531656565223A2255222C225C7531656563223A2255222C225C7531656630223A2255222C225C7531656534223A2255222C225C7531653732223A2255222C225C7530313732223A2255222C225C753165373622';
wwv_flow_api.g_varchar2_table(121) := '3A2255222C225C7531653734223A2255222C225C7530323434223A2255222C225C7532346362223A2256222C225C7566663336223A2256222C225C7531653763223A2256222C225C7531653765223A2256222C225C7530316232223A2256222C225C7561';
wwv_flow_api.g_varchar2_table(122) := '373565223A2256222C225C7530323435223A2256222C225C7561373630223A225659222C225C7532346363223A2257222C225C7566663337223A2257222C225C7531653830223A2257222C225C7531653832223A2257222C225C7530313734223A225722';
wwv_flow_api.g_varchar2_table(123) := '2C225C7531653836223A2257222C225C7531653834223A2257222C225C7531653838223A2257222C225C7532633732223A2257222C225C7532346364223A2258222C225C7566663338223A2258222C225C7531653861223A2258222C225C753165386322';
wwv_flow_api.g_varchar2_table(124) := '3A2258222C225C7532346365223A2259222C225C7566663339223A2259222C225C7531656632223A2259222C225C786464223A2259222C225C7530313736223A2259222C225C7531656638223A2259222C225C7530323332223A2259222C225C75316538';
wwv_flow_api.g_varchar2_table(125) := '65223A2259222C225C7530313738223A2259222C225C7531656636223A2259222C225C7531656634223A2259222C225C7530316233223A2259222C225C7530323465223A2259222C225C7531656665223A2259222C225C7532346366223A225A222C225C';
wwv_flow_api.g_varchar2_table(126) := '7566663361223A225A222C225C7530313739223A225A222C225C7531653930223A225A222C225C7530313762223A225A222C225C7530313764223A225A222C225C7531653932223A225A222C225C7531653934223A225A222C225C7530316235223A225A';
wwv_flow_api.g_varchar2_table(127) := '222C225C7530323234223A225A222C225C7532633766223A225A222C225C7532633662223A225A222C225C7561373632223A225A222C225C7532346430223A2261222C225C7566663431223A2261222C225C7531653961223A2261222C225C786530223A';
wwv_flow_api.g_varchar2_table(128) := '2261222C225C786531223A2261222C225C786532223A2261222C225C7531656137223A2261222C225C7531656135223A2261222C225C7531656162223A2261222C225C7531656139223A2261222C225C786533223A2261222C225C7530313031223A2261';
wwv_flow_api.g_varchar2_table(129) := '222C225C7530313033223A2261222C225C7531656231223A2261222C225C7531656166223A2261222C225C7531656235223A2261222C225C7531656233223A2261222C225C7530323237223A2261222C225C7530316531223A2261222C225C786534223A';
wwv_flow_api.g_varchar2_table(130) := '2261222C225C7530316466223A2261222C225C7531656133223A2261222C225C786535223A2261222C225C7530316662223A2261222C225C7530316365223A2261222C225C7530323031223A2261222C225C7530323033223A2261222C225C7531656131';
wwv_flow_api.g_varchar2_table(131) := '223A2261222C225C7531656164223A2261222C225C7531656237223A2261222C225C7531653031223A2261222C225C7530313035223A2261222C225C7532633635223A2261222C225C7530323530223A2261222C225C7561373333223A226161222C225C';
wwv_flow_api.g_varchar2_table(132) := '786536223A226165222C225C7530316664223A226165222C225C7530316533223A226165222C225C7561373335223A22616F222C225C7561373337223A226175222C225C7561373339223A226176222C225C7561373362223A226176222C225C75613733';
wwv_flow_api.g_varchar2_table(133) := '64223A226179222C225C7532346431223A2262222C225C7566663432223A2262222C225C7531653033223A2262222C225C7531653035223A2262222C225C7531653037223A2262222C225C7530313830223A2262222C225C7530313833223A2262222C22';
wwv_flow_api.g_varchar2_table(134) := '5C7530323533223A2262222C225C7532346432223A2263222C225C7566663433223A2263222C225C7530313037223A2263222C225C7530313039223A2263222C225C7530313062223A2263222C225C7530313064223A2263222C225C786537223A226322';
wwv_flow_api.g_varchar2_table(135) := '2C225C7531653039223A2263222C225C7530313838223A2263222C225C7530323363223A2263222C225C7561373366223A2263222C225C7532313834223A2263222C225C7532346433223A2264222C225C7566663434223A2264222C225C753165306222';
wwv_flow_api.g_varchar2_table(136) := '3A2264222C225C7530313066223A2264222C225C7531653064223A2264222C225C7531653131223A2264222C225C7531653133223A2264222C225C7531653066223A2264222C225C7530313131223A2264222C225C7530313863223A2264222C225C7530';
wwv_flow_api.g_varchar2_table(137) := '323536223A2264222C225C7530323537223A2264222C225C7561373761223A2264222C225C7530316633223A22647A222C225C7530316336223A22647A222C225C7532346434223A2265222C225C7566663435223A2265222C225C786538223A2265222C';
wwv_flow_api.g_varchar2_table(138) := '225C786539223A2265222C225C786561223A2265222C225C7531656331223A2265222C225C7531656266223A2265222C225C7531656335223A2265222C225C7531656333223A2265222C225C7531656264223A2265222C225C7530313133223A2265222C';
wwv_flow_api.g_varchar2_table(139) := '225C7531653135223A2265222C225C7531653137223A2265222C225C7530313135223A2265222C225C7530313137223A2265222C225C786562223A2265222C225C7531656262223A2265222C225C7530313162223A2265222C225C7530323035223A2265';
wwv_flow_api.g_varchar2_table(140) := '222C225C7530323037223A2265222C225C7531656239223A2265222C225C7531656337223A2265222C225C7530323239223A2265222C225C7531653164223A2265222C225C7530313139223A2265222C225C7531653139223A2265222C225C7531653162';
wwv_flow_api.g_varchar2_table(141) := '223A2265222C225C7530323437223A2265222C225C7530323562223A2265222C225C7530316464223A2265222C225C7532346435223A2266222C225C7566663436223A2266222C225C7531653166223A2266222C225C7530313932223A2266222C225C75';
wwv_flow_api.g_varchar2_table(142) := '61373763223A2266222C225C7532346436223A2267222C225C7566663437223A2267222C225C7530316635223A2267222C225C7530313164223A2267222C225C7531653231223A2267222C225C7530313166223A2267222C225C7530313231223A226722';
wwv_flow_api.g_varchar2_table(143) := '2C225C7530316537223A2267222C225C7530313233223A2267222C225C7530316535223A2267222C225C7530323630223A2267222C225C7561376131223A2267222C225C7531643739223A2267222C225C7561373766223A2267222C225C753234643722';
wwv_flow_api.g_varchar2_table(144) := '3A2268222C225C7566663438223A2268222C225C7530313235223A2268222C225C7531653233223A2268222C225C7531653237223A2268222C225C7530323166223A2268222C225C7531653235223A2268222C225C7531653239223A2268222C225C7531';
wwv_flow_api.g_varchar2_table(145) := '653262223A2268222C225C7531653936223A2268222C225C7530313237223A2268222C225C7532633638223A2268222C225C7532633736223A2268222C225C7530323635223A2268222C225C7530313935223A226876222C225C7532346438223A226922';
wwv_flow_api.g_varchar2_table(146) := '2C225C7566663439223A2269222C225C786563223A2269222C225C786564223A2269222C225C786565223A2269222C225C7530313239223A2269222C225C7530313262223A2269222C225C7530313264223A2269222C225C786566223A2269222C225C75';
wwv_flow_api.g_varchar2_table(147) := '31653266223A2269222C225C7531656339223A2269222C225C7530316430223A2269222C225C7530323039223A2269222C225C7530323062223A2269222C225C7531656362223A2269222C225C7530313266223A2269222C225C7531653264223A226922';
wwv_flow_api.g_varchar2_table(148) := '2C225C7530323638223A2269222C225C7530313331223A2269222C225C7532346439223A226A222C225C7566663461223A226A222C225C7530313335223A226A222C225C7530316630223A226A222C225C7530323439223A226A222C225C753234646122';
wwv_flow_api.g_varchar2_table(149) := '3A226B222C225C7566663462223A226B222C225C7531653331223A226B222C225C7530316539223A226B222C225C7531653333223A226B222C225C7530313337223A226B222C225C7531653335223A226B222C225C7530313939223A226B222C225C7532';
wwv_flow_api.g_varchar2_table(150) := '633661223A226B222C225C7561373431223A226B222C225C7561373433223A226B222C225C7561373435223A226B222C225C7561376133223A226B222C225C7532346462223A226C222C225C7566663463223A226C222C225C7530313430223A226C222C';
wwv_flow_api.g_varchar2_table(151) := '225C7530313361223A226C222C225C7530313365223A226C222C225C7531653337223A226C222C225C7531653339223A226C222C225C7530313363223A226C222C225C7531653364223A226C222C225C7531653362223A226C222C225C7530313766223A';
wwv_flow_api.g_varchar2_table(152) := '226C222C225C7530313432223A226C222C225C7530313961223A226C222C225C7530323662223A226C222C225C7532633631223A226C222C225C7561373439223A226C222C225C7561373831223A226C222C225C7561373437223A226C222C225C753031';
wwv_flow_api.g_varchar2_table(153) := '6339223A226C6A222C225C7532346463223A226D222C225C7566663464223A226D222C225C7531653366223A226D222C225C7531653431223A226D222C225C7531653433223A226D222C225C7530323731223A226D222C225C7530323666223A226D222C';
wwv_flow_api.g_varchar2_table(154) := '225C7532346464223A226E222C225C7566663465223A226E222C225C7530316639223A226E222C225C7530313434223A226E222C225C786631223A226E222C225C7531653435223A226E222C225C7530313438223A226E222C225C7531653437223A226E';
wwv_flow_api.g_varchar2_table(155) := '222C225C7530313436223A226E222C225C7531653462223A226E222C225C7531653439223A226E222C225C7530313965223A226E222C225C7530323732223A226E222C225C7530313439223A226E222C225C7561373931223A226E222C225C7561376135';
wwv_flow_api.g_varchar2_table(156) := '223A226E222C225C7530316363223A226E6A222C225C7532346465223A226F222C225C7566663466223A226F222C225C786632223A226F222C225C786633223A226F222C225C786634223A226F222C225C7531656433223A226F222C225C753165643122';
wwv_flow_api.g_varchar2_table(157) := '3A226F222C225C7531656437223A226F222C225C7531656435223A226F222C225C786635223A226F222C225C7531653464223A226F222C225C7530323264223A226F222C225C7531653466223A226F222C225C7530313464223A226F222C225C75316535';
wwv_flow_api.g_varchar2_table(158) := '31223A226F222C225C7531653533223A226F222C225C7530313466223A226F222C225C7530323266223A226F222C225C7530323331223A226F222C225C786636223A226F222C225C7530323262223A226F222C225C7531656366223A226F222C225C7530';
wwv_flow_api.g_varchar2_table(159) := '313531223A226F222C225C7530316432223A226F222C225C7530323064223A226F222C225C7530323066223A226F222C225C7530316131223A226F222C225C7531656464223A226F222C225C7531656462223A226F222C225C7531656531223A226F222C';
wwv_flow_api.g_varchar2_table(160) := '225C7531656466223A226F222C225C7531656533223A226F222C225C7531656364223A226F222C225C7531656439223A226F222C225C7530316562223A226F222C225C7530316564223A226F222C225C786638223A226F222C225C7530316666223A226F';
wwv_flow_api.g_varchar2_table(161) := '222C225C7530323534223A226F222C225C7561373462223A226F222C225C7561373464223A226F222C225C7530323735223A226F222C225C7530316133223A226F69222C225C7530323233223A226F75222C225C7561373466223A226F6F222C225C7532';
wwv_flow_api.g_varchar2_table(162) := '346466223A2270222C225C7566663530223A2270222C225C7531653535223A2270222C225C7531653537223A2270222C225C7530316135223A2270222C225C7531643764223A2270222C225C7561373531223A2270222C225C7561373533223A2270222C';
wwv_flow_api.g_varchar2_table(163) := '225C7561373535223A2270222C225C7532346530223A2271222C225C7566663531223A2271222C225C7530323462223A2271222C225C7561373537223A2271222C225C7561373539223A2271222C225C7532346531223A2272222C225C7566663532223A';
wwv_flow_api.g_varchar2_table(164) := '2272222C225C7530313535223A2272222C225C7531653539223A2272222C225C7530313539223A2272222C225C7530323131223A2272222C225C7530323133223A2272222C225C7531653562223A2272222C225C7531653564223A2272222C225C753031';
wwv_flow_api.g_varchar2_table(165) := '3537223A2272222C225C7531653566223A2272222C225C7530323464223A2272222C225C7530323764223A2272222C225C7561373562223A2272222C225C7561376137223A2272222C225C7561373833223A2272222C225C7532346532223A2273222C22';
wwv_flow_api.g_varchar2_table(166) := '5C7566663533223A2273222C225C786466223A2273222C225C7530313562223A2273222C225C7531653635223A2273222C225C7530313564223A2273222C225C7531653631223A2273222C225C7530313631223A2273222C225C7531653637223A227322';
wwv_flow_api.g_varchar2_table(167) := '2C225C7531653633223A2273222C225C7531653639223A2273222C225C7530323139223A2273222C225C7530313566223A2273222C225C7530323366223A2273222C225C7561376139223A2273222C225C7561373835223A2273222C225C753165396222';
wwv_flow_api.g_varchar2_table(168) := '3A2273222C225C7532346533223A2274222C225C7566663534223A2274222C225C7531653662223A2274222C225C7531653937223A2274222C225C7530313635223A2274222C225C7531653664223A2274222C225C7530323162223A2274222C225C7530';
wwv_flow_api.g_varchar2_table(169) := '313633223A2274222C225C7531653731223A2274222C225C7531653666223A2274222C225C7530313637223A2274222C225C7530316164223A2274222C225C7530323838223A2274222C225C7532633636223A2274222C225C7561373837223A2274222C';
wwv_flow_api.g_varchar2_table(170) := '225C7561373239223A22747A222C225C7532346534223A2275222C225C7566663535223A2275222C225C786639223A2275222C225C786661223A2275222C225C786662223A2275222C225C7530313639223A2275222C225C7531653739223A2275222C22';
wwv_flow_api.g_varchar2_table(171) := '5C7530313662223A2275222C225C7531653762223A2275222C225C7530313664223A2275222C225C786663223A2275222C225C7530316463223A2275222C225C7530316438223A2275222C225C7530316436223A2275222C225C7530316461223A227522';
wwv_flow_api.g_varchar2_table(172) := '2C225C7531656537223A2275222C225C7530313666223A2275222C225C7530313731223A2275222C225C7530316434223A2275222C225C7530323135223A2275222C225C7530323137223A2275222C225C7530316230223A2275222C225C753165656222';
wwv_flow_api.g_varchar2_table(173) := '3A2275222C225C7531656539223A2275222C225C7531656566223A2275222C225C7531656564223A2275222C225C7531656631223A2275222C225C7531656535223A2275222C225C7531653733223A2275222C225C7530313733223A2275222C225C7531';
wwv_flow_api.g_varchar2_table(174) := '653737223A2275222C225C7531653735223A2275222C225C7530323839223A2275222C225C7532346535223A2276222C225C7566663536223A2276222C225C7531653764223A2276222C225C7531653766223A2276222C225C7530323862223A2276222C';
wwv_flow_api.g_varchar2_table(175) := '225C7561373566223A2276222C225C7530323863223A2276222C225C7561373631223A227679222C225C7532346536223A2277222C225C7566663537223A2277222C225C7531653831223A2277222C225C7531653833223A2277222C225C753031373522';
wwv_flow_api.g_varchar2_table(176) := '3A2277222C225C7531653837223A2277222C225C7531653835223A2277222C225C7531653938223A2277222C225C7531653839223A2277222C225C7532633733223A2277222C225C7532346537223A2278222C225C7566663538223A2278222C225C7531';
wwv_flow_api.g_varchar2_table(177) := '653862223A2278222C225C7531653864223A2278222C225C7532346538223A2279222C225C7566663539223A2279222C225C7531656633223A2279222C225C786664223A2279222C225C7530313737223A2279222C225C7531656639223A2279222C225C';
wwv_flow_api.g_varchar2_table(178) := '7530323333223A2279222C225C7531653866223A2279222C225C786666223A2279222C225C7531656637223A2279222C225C7531653939223A2279222C225C7531656635223A2279222C225C7530316234223A2279222C225C7530323466223A2279222C';
wwv_flow_api.g_varchar2_table(179) := '225C7531656666223A2279222C225C7532346539223A227A222C225C7566663561223A227A222C225C7530313761223A227A222C225C7531653931223A227A222C225C7530313763223A227A222C225C7530313765223A227A222C225C7531653933223A';
wwv_flow_api.g_varchar2_table(180) := '227A222C225C7531653935223A227A222C225C7530316236223A227A222C225C7530323235223A227A222C225C7530323430223A227A222C225C7532633663223A227A222C225C7561373633223A227A227D3B6A3D6128646F63756D656E74292C673D66';
wwv_flow_api.g_varchar2_table(181) := '756E6374696F6E28297B76617220613D313B72657475726E2066756E6374696F6E28297B72657475726E20612B2B7D7D28292C6A2E6F6E28226D6F7573656D6F7665222C66756E6374696F6E2861297B692E783D612E70616765582C692E793D612E7061';
wwv_flow_api.g_varchar2_table(182) := '6765597D292C643D4E284F626A6563742C7B62696E643A66756E6374696F6E2861297B76617220623D746869733B72657475726E2066756E6374696F6E28297B612E6170706C7928622C617267756D656E7473297D7D2C696E69743A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(183) := '2863297B76617220642C652C682C692C663D222E73656C656374322D726573756C7473223B746869732E6F7074733D633D746869732E707265706172654F7074732863292C746869732E69643D632E69642C632E656C656D656E742E6461746128227365';
wwv_flow_api.g_varchar2_table(184) := '6C656374322229213D3D6226266E756C6C213D3D632E656C656D656E742E64617461282273656C6563743222292626632E656C656D656E742E64617461282273656C6563743222292E64657374726F7928292C746869732E636F6E7461696E65723D7468';
wwv_flow_api.g_varchar2_table(185) := '69732E637265617465436F6E7461696E657228292C746869732E636F6E7461696E657249643D22733269645F222B28632E656C656D656E742E617474722822696422297C7C226175746F67656E222B672829292C746869732E636F6E7461696E65725365';
wwv_flow_api.g_varchar2_table(186) := '6C6563746F723D2223222B746869732E636F6E7461696E657249642E7265706C616365282F285B3B262C5C2E5C2B5C2A5C7E273A225C215C5E232425405C5B5C5D5C285C293D3E5C7C5D292F672C225C5C243122292C746869732E636F6E7461696E6572';
wwv_flow_api.g_varchar2_table(187) := '2E6174747228226964222C746869732E636F6E7461696E65724964292C746869732E626F64793D772866756E6374696F6E28297B72657475726E20632E656C656D656E742E636C6F736573742822626F647922297D292C4428746869732E636F6E746169';
wwv_flow_api.g_varchar2_table(188) := '6E65722C746869732E6F7074732E656C656D656E742C746869732E6F7074732E6164617074436F6E7461696E6572437373436C617373292C746869732E636F6E7461696E65722E6174747228227374796C65222C632E656C656D656E742E617474722822';
wwv_flow_api.g_varchar2_table(189) := '7374796C652229292C746869732E636F6E7461696E65722E637373284B28632E636F6E7461696E657243737329292C746869732E636F6E7461696E65722E616464436C617373284B28632E636F6E7461696E6572437373436C61737329292C746869732E';
wwv_flow_api.g_varchar2_table(190) := '656C656D656E74546162496E6465783D746869732E6F7074732E656C656D656E742E617474722822746162696E64657822292C746869732E6F7074732E656C656D656E742E64617461282273656C65637432222C74686973292E61747472282274616269';
wwv_flow_api.g_varchar2_table(191) := '6E646578222C222D3122292E6265666F726528746869732E636F6E7461696E6572292C746869732E636F6E7461696E65722E64617461282273656C65637432222C74686973292C746869732E64726F70646F776E3D746869732E636F6E7461696E65722E';
wwv_flow_api.g_varchar2_table(192) := '66696E6428222E73656C656374322D64726F7022292C746869732E64726F70646F776E2E616464436C617373284B28632E64726F70646F776E437373436C61737329292C746869732E64726F70646F776E2E64617461282273656C65637432222C746869';
wwv_flow_api.g_varchar2_table(193) := '73292C4428746869732E64726F70646F776E2C746869732E6F7074732E656C656D656E742C746869732E6F7074732E616461707444726F70646F776E437373436C617373292C746869732E726573756C74733D643D746869732E636F6E7461696E65722E';
wwv_flow_api.g_varchar2_table(194) := '66696E642866292C746869732E7365617263683D653D746869732E636F6E7461696E65722E66696E642822696E7075742E73656C656374322D696E70757422292C746869732E7175657279436F756E743D302C746869732E726573756C7473506167653D';
wwv_flow_api.g_varchar2_table(195) := '302C746869732E636F6E746578743D6E756C6C2C746869732E696E6974436F6E7461696E657228292C7528746869732E726573756C7473292C746869732E64726F70646F776E2E6F6E28226D6F7573656D6F76652D66696C746572656420746F75636873';
wwv_flow_api.g_varchar2_table(196) := '7461727420746F7563686D6F766520746F756368656E64222C662C746869732E62696E6428746869732E686967686C69676874556E6465724576656E7429292C782838302C746869732E726573756C7473292C746869732E64726F70646F776E2E6F6E28';
wwv_flow_api.g_varchar2_table(197) := '227363726F6C6C2D6465626F756E636564222C662C746869732E62696E6428746869732E6C6F61644D6F726549664E656564656429292C6128746869732E636F6E7461696E6572292E6F6E28226368616E6765222C222E73656C656374322D696E707574';
wwv_flow_api.g_varchar2_table(198) := '222C66756E6374696F6E2861297B612E73746F7050726F7061676174696F6E28297D292C6128746869732E64726F70646F776E292E6F6E28226368616E6765222C222E73656C656374322D696E707574222C66756E6374696F6E2861297B612E73746F70';
wwv_flow_api.g_varchar2_table(199) := '50726F7061676174696F6E28297D292C612E666E2E6D6F757365776865656C2626642E6D6F757365776865656C2866756E6374696F6E28612C622C632C65297B76617220663D642E7363726F6C6C546F7028293B653E302626303E3D662D653F28642E73';
wwv_flow_api.g_varchar2_table(200) := '63726F6C6C546F702830292C41286129293A303E652626642E6765742830292E7363726F6C6C4865696768742D642E7363726F6C6C546F7028292B653C3D642E6865696768742829262628642E7363726F6C6C546F7028642E6765742830292E7363726F';
wwv_flow_api.g_varchar2_table(201) := '6C6C4865696768742D642E6865696768742829292C41286129297D292C742865292C652E6F6E28226B657975702D6368616E676520696E707574207061737465222C746869732E62696E6428746869732E757064617465526573756C747329292C652E6F';
wwv_flow_api.g_varchar2_table(202) := '6E2822666F637573222C66756E6374696F6E28297B652E616464436C617373282273656C656374322D666F637573656422297D292C652E6F6E2822626C7572222C66756E6374696F6E28297B652E72656D6F7665436C617373282273656C656374322D66';
wwv_flow_api.g_varchar2_table(203) := '6F637573656422297D292C746869732E64726F70646F776E2E6F6E28226D6F7573657570222C662C746869732E62696E642866756E6374696F6E2862297B6128622E746172676574292E636C6F7365737428222E73656C656374322D726573756C742D73';
wwv_flow_api.g_varchar2_table(204) := '656C65637461626C6522292E6C656E6774683E30262628746869732E686967686C69676874556E6465724576656E742862292C746869732E73656C656374486967686C696768746564286229297D29292C746869732E64726F70646F776E2E6F6E282263';
wwv_flow_api.g_varchar2_table(205) := '6C69636B206D6F7573657570206D6F757365646F776E222C66756E6374696F6E2861297B612E73746F7050726F7061676174696F6E28297D292C612E697346756E6374696F6E28746869732E6F7074732E696E697453656C656374696F6E292626287468';
wwv_flow_api.g_varchar2_table(206) := '69732E696E697453656C656374696F6E28292C746869732E6D6F6E69746F72536F757263652829292C6E756C6C213D3D632E6D6178696D756D496E7075744C656E6774682626746869732E7365617263682E6174747228226D61786C656E677468222C63';
wwv_flow_api.g_varchar2_table(207) := '2E6D6178696D756D496E7075744C656E677468293B76617220683D632E656C656D656E742E70726F70282264697361626C656422293B683D3D3D62262628683D2131292C746869732E656E61626C65282168293B76617220693D632E656C656D656E742E';
wwv_flow_api.g_varchar2_table(208) := '70726F702822726561646F6E6C7922293B693D3D3D62262628693D2131292C746869732E726561646F6E6C792869292C6B3D6B7C7C7028292C746869732E6175746F666F6375733D632E656C656D656E742E70726F7028226175746F666F63757322292C';
wwv_flow_api.g_varchar2_table(209) := '632E656C656D656E742E70726F7028226175746F666F637573222C2131292C746869732E6175746F666F6375732626746869732E666F63757328292C746869732E6E6578745365617263685465726D3D627D2C64657374726F793A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(210) := '297B76617220613D746869732E6F7074732E656C656D656E742C633D612E64617461282273656C6563743222293B746869732E636C6F736528292C746869732E70726F70657274794F6273657276657226262864656C65746520746869732E70726F7065';
wwv_flow_api.g_varchar2_table(211) := '7274794F627365727665722C746869732E70726F70657274794F627365727665723D6E756C6C292C63213D3D62262628632E636F6E7461696E65722E72656D6F766528292C632E64726F70646F776E2E72656D6F766528292C612E72656D6F7665436C61';
wwv_flow_api.g_varchar2_table(212) := '7373282273656C656374322D6F666673637265656E22292E72656D6F766544617461282273656C6563743222292E6F666628222E73656C6563743222292E70726F7028226175746F666F637573222C746869732E6175746F666F6375737C7C2131292C74';
wwv_flow_api.g_varchar2_table(213) := '6869732E656C656D656E74546162496E6465783F612E61747472287B746162696E6465783A746869732E656C656D656E74546162496E6465787D293A612E72656D6F7665417474722822746162696E64657822292C612E73686F772829297D2C6F707469';
wwv_flow_api.g_varchar2_table(214) := '6F6E546F446174613A66756E6374696F6E2861297B72657475726E20612E697328226F7074696F6E22293F7B69643A612E70726F70282276616C756522292C746578743A612E7465787428292C656C656D656E743A612E67657428292C6373733A612E61';
wwv_flow_api.g_varchar2_table(215) := '7474722822636C61737322292C64697361626C65643A612E70726F70282264697361626C656422292C6C6F636B65643A7128612E6174747228226C6F636B656422292C226C6F636B656422297C7C7128612E6461746128226C6F636B656422292C213029';
wwv_flow_api.g_varchar2_table(216) := '7D3A612E697328226F707467726F757022293F7B746578743A612E6174747228226C6162656C22292C6368696C6472656E3A5B5D2C656C656D656E743A612E67657428292C6373733A612E617474722822636C61737322297D3A766F696420307D2C7072';
wwv_flow_api.g_varchar2_table(217) := '65706172654F7074733A66756E6374696F6E2863297B76617220642C652C662C672C683D746869733B696628643D632E656C656D656E742C2273656C656374223D3D3D642E6765742830292E7461674E616D652E746F4C6F776572436173652829262628';
wwv_flow_api.g_varchar2_table(218) := '746869732E73656C6563743D653D632E656C656D656E74292C652626612E65616368285B226964222C226D756C7469706C65222C22616A6178222C227175657279222C2263726561746553656172636843686F696365222C22696E697453656C65637469';
wwv_flow_api.g_varchar2_table(219) := '6F6E222C2264617461222C2274616773225D2C66756E6374696F6E28297B6966287468697320696E2063297468726F77206E6577204572726F7228224F7074696F6E2027222B746869732B2227206973206E6F7420616C6C6F77656420666F722053656C';
wwv_flow_api.g_varchar2_table(220) := '65637432207768656E20617474616368656420746F2061203C73656C6563743E20656C656D656E742E22297D292C633D612E657874656E64287B7D2C7B706F70756C617465526573756C74733A66756E6374696F6E28642C652C66297B76617220672C6C';
wwv_flow_api.g_varchar2_table(221) := '3D746869732E6F7074732E69643B673D66756E6374696F6E28642C652C69297B766172206A2C6B2C6D2C6E2C6F2C702C712C722C732C743B666F7228643D632E736F7274526573756C747328642C652C66292C6A3D302C6B3D642E6C656E6774683B6B3E';
wwv_flow_api.g_varchar2_table(222) := '6A3B6A2B3D31296D3D645B6A5D2C6F3D6D2E64697361626C65643D3D3D21302C6E3D216F26266C286D29213D3D622C703D6D2E6368696C6472656E26266D2E6368696C6472656E2E6C656E6774683E302C713D6128223C6C693E3C2F6C693E22292C712E';
wwv_flow_api.g_varchar2_table(223) := '616464436C617373282273656C656374322D726573756C74732D646570742D222B69292C712E616464436C617373282273656C656374322D726573756C7422292C712E616464436C617373286E3F2273656C656374322D726573756C742D73656C656374';
wwv_flow_api.g_varchar2_table(224) := '61626C65223A2273656C656374322D726573756C742D756E73656C65637461626C6522292C6F2626712E616464436C617373282273656C656374322D64697361626C656422292C702626712E616464436C617373282273656C656374322D726573756C74';
wwv_flow_api.g_varchar2_table(225) := '2D776974682D6368696C6472656E22292C712E616464436C61737328682E6F7074732E666F726D6174526573756C74437373436C617373286D29292C723D6128646F63756D656E742E637265617465456C656D656E7428226469762229292C722E616464';
wwv_flow_api.g_varchar2_table(226) := '436C617373282273656C656374322D726573756C742D6C6162656C22292C743D632E666F726D6174526573756C74286D2C722C662C682E6F7074732E6573636170654D61726B7570292C74213D3D622626722E68746D6C2874292C712E617070656E6428';
wwv_flow_api.g_varchar2_table(227) := '72292C70262628733D6128223C756C3E3C2F756C3E22292C732E616464436C617373282273656C656374322D726573756C742D73756222292C67286D2E6368696C6472656E2C732C692B31292C712E617070656E64287329292C712E6461746128227365';
wwv_flow_api.g_varchar2_table(228) := '6C656374322D64617461222C6D292C652E617070656E642871297D2C6728652C642C30297D7D2C612E666E2E73656C656374322E64656661756C74732C63292C2266756E6374696F6E22213D747970656F6620632E6964262628663D632E69642C632E69';
wwv_flow_api.g_varchar2_table(229) := '643D66756E6374696F6E2861297B72657475726E20615B665D7D292C612E6973417272617928632E656C656D656E742E64617461282273656C6563743254616773222929297B696628227461677322696E2063297468726F772274616773207370656369';
wwv_flow_api.g_varchar2_table(230) := '6669656420617320626F746820616E206174747269627574652027646174612D73656C656374322D746167732720616E6420696E206F7074696F6E73206F662053656C6563743220222B632E656C656D656E742E617474722822696422293B632E746167';
wwv_flow_api.g_varchar2_table(231) := '733D632E656C656D656E742E64617461282273656C656374325461677322297D696628653F28632E71756572793D746869732E62696E642866756E6374696F6E2861297B76617220662C672C692C633D7B726573756C74733A5B5D2C6D6F72653A21317D';
wwv_flow_api.g_varchar2_table(232) := '2C653D612E7465726D3B693D66756E6374696F6E28622C63297B76617220643B622E697328226F7074696F6E22293F612E6D61746368657228652C622E7465787428292C62292626632E7075736828682E6F7074696F6E546F44617461286229293A622E';
wwv_flow_api.g_varchar2_table(233) := '697328226F707467726F75702229262628643D682E6F7074696F6E546F446174612862292C622E6368696C6472656E28292E65616368322866756E6374696F6E28612C62297B6928622C642E6368696C6472656E297D292C642E6368696C6472656E2E6C';
wwv_flow_api.g_varchar2_table(234) := '656E6774683E302626632E70757368286429297D2C663D642E6368696C6472656E28292C746869732E676574506C616365686F6C6465722829213D3D622626662E6C656E6774683E30262628673D746869732E676574506C616365686F6C6465724F7074';
wwv_flow_api.g_varchar2_table(235) := '696F6E28292C67262628663D662E6E6F7428672929292C662E65616368322866756E6374696F6E28612C62297B6928622C632E726573756C7473297D292C612E63616C6C6261636B2863297D292C632E69643D66756E6374696F6E2861297B7265747572';
wwv_flow_api.g_varchar2_table(236) := '6E20612E69647D2C632E666F726D6174526573756C74437373436C6173733D66756E6374696F6E2861297B72657475726E20612E6373737D293A22717565727922696E20637C7C2822616A617822696E20633F28673D632E656C656D656E742E64617461';
wwv_flow_api.g_varchar2_table(237) := '2822616A61782D75726C22292C672626672E6C656E6774683E30262628632E616A61782E75726C3D67292C632E71756572793D472E63616C6C28632E656C656D656E742C632E616A617829293A226461746122696E20633F632E71756572793D4828632E';
wwv_flow_api.g_varchar2_table(238) := '64617461293A227461677322696E2063262628632E71756572793D4928632E74616773292C632E63726561746553656172636843686F6963653D3D3D62262628632E63726561746553656172636843686F6963653D66756E6374696F6E2862297B726574';
wwv_flow_api.g_varchar2_table(239) := '75726E7B69643A612E7472696D2862292C746578743A612E7472696D2862297D7D292C632E696E697453656C656374696F6E3D3D3D62262628632E696E697453656C656374696F6E3D66756E6374696F6E28622C64297B76617220653D5B5D3B61287228';
wwv_flow_api.g_varchar2_table(240) := '622E76616C28292C632E736570617261746F7229292E656163682866756E6374696F6E28297B76617220623D746869732C643D746869732C663D632E746167733B612E697346756E6374696F6E286629262628663D662829292C612866292E6561636828';
wwv_flow_api.g_varchar2_table(241) := '66756E6374696F6E28297B72657475726E207128746869732E69642C62293F28643D746869732E746578742C2131293A766F696420307D292C652E70757368287B69643A622C746578743A647D297D292C642865297D2929292C2266756E6374696F6E22';
wwv_flow_api.g_varchar2_table(242) := '213D747970656F6620632E7175657279297468726F772271756572792066756E6374696F6E206E6F7420646566696E656420666F722053656C6563743220222B632E656C656D656E742E617474722822696422293B72657475726E20637D2C6D6F6E6974';
wwv_flow_api.g_varchar2_table(243) := '6F72536F757263653A66756E6374696F6E28297B76617220632C613D746869732E6F7074732E656C656D656E743B612E6F6E28226368616E67652E73656C65637432222C746869732E62696E642866756E6374696F6E28297B746869732E6F7074732E65';
wwv_flow_api.g_varchar2_table(244) := '6C656D656E742E64617461282273656C656374322D6368616E67652D7472696767657265642229213D3D21302626746869732E696E697453656C656374696F6E28297D29292C633D746869732E62696E642866756E6374696F6E28297B76617220642C66';
wwv_flow_api.g_varchar2_table(245) := '3D612E70726F70282264697361626C656422293B663D3D3D62262628663D2131292C746869732E656E61626C65282166293B76617220643D612E70726F702822726561646F6E6C7922293B643D3D3D62262628643D2131292C746869732E726561646F6E';
wwv_flow_api.g_varchar2_table(246) := '6C792864292C4428746869732E636F6E7461696E65722C746869732E6F7074732E656C656D656E742C746869732E6F7074732E6164617074436F6E7461696E6572437373436C617373292C746869732E636F6E7461696E65722E616464436C617373284B';
wwv_flow_api.g_varchar2_table(247) := '28746869732E6F7074732E636F6E7461696E6572437373436C61737329292C4428746869732E64726F70646F776E2C746869732E6F7074732E656C656D656E742C746869732E6F7074732E616461707444726F70646F776E437373436C617373292C7468';
wwv_flow_api.g_varchar2_table(248) := '69732E64726F70646F776E2E616464436C617373284B28746869732E6F7074732E64726F70646F776E437373436C61737329297D292C612E6F6E282270726F70657274796368616E67652E73656C6563743220444F4D417474724D6F6469666965642E73';
wwv_flow_api.g_varchar2_table(249) := '656C65637432222C63292C746869732E6D75746174696F6E43616C6C6261636B3D3D3D62262628746869732E6D75746174696F6E43616C6C6261636B3D66756E6374696F6E2861297B612E666F72456163682863297D292C22756E646566696E65642221';
wwv_flow_api.g_varchar2_table(250) := '3D747970656F66205765624B69744D75746174696F6E4F62736572766572262628746869732E70726F70657274794F6273657276657226262864656C65746520746869732E70726F70657274794F627365727665722C746869732E70726F70657274794F';
wwv_flow_api.g_varchar2_table(251) := '627365727665723D6E756C6C292C746869732E70726F70657274794F627365727665723D6E6577205765624B69744D75746174696F6E4F6273657276657228746869732E6D75746174696F6E43616C6C6261636B292C746869732E70726F70657274794F';
wwv_flow_api.g_varchar2_table(252) := '627365727665722E6F62736572766528612E6765742830292C7B617474726962757465733A21302C737562747265653A21317D29297D2C7472696767657253656C6563743A66756E6374696F6E2862297B76617220633D612E4576656E74282273656C65';
wwv_flow_api.g_varchar2_table(253) := '6374322D73656C656374696E67222C7B76616C3A746869732E69642862292C6F626A6563743A627D293B72657475726E20746869732E6F7074732E656C656D656E742E747269676765722863292C21632E697344656661756C7450726576656E74656428';
wwv_flow_api.g_varchar2_table(254) := '297D2C747269676765724368616E67653A66756E6374696F6E2862297B623D627C7C7B7D2C623D612E657874656E64287B7D2C622C7B747970653A226368616E6765222C76616C3A746869732E76616C28297D292C746869732E6F7074732E656C656D65';
wwv_flow_api.g_varchar2_table(255) := '6E742E64617461282273656C656374322D6368616E67652D747269676765726564222C2130292C746869732E6F7074732E656C656D656E742E747269676765722862292C746869732E6F7074732E656C656D656E742E64617461282273656C656374322D';
wwv_flow_api.g_varchar2_table(256) := '6368616E67652D747269676765726564222C2131292C746869732E6F7074732E656C656D656E742E636C69636B28292C746869732E6F7074732E626C75724F6E4368616E67652626746869732E6F7074732E656C656D656E742E626C757228297D2C6973';
wwv_flow_api.g_varchar2_table(257) := '496E74657266616365456E61626C65643A66756E6374696F6E28297B72657475726E20746869732E656E61626C6564496E746572666163653D3D3D21307D2C656E61626C65496E746572666163653A66756E6374696F6E28297B76617220613D74686973';
wwv_flow_api.g_varchar2_table(258) := '2E5F656E61626C6564262621746869732E5F726561646F6E6C792C623D21613B72657475726E20613D3D3D746869732E656E61626C6564496E746572666163653F21313A28746869732E636F6E7461696E65722E746F67676C65436C617373282273656C';
wwv_flow_api.g_varchar2_table(259) := '656374322D636F6E7461696E65722D64697361626C6564222C62292C746869732E636C6F736528292C746869732E656E61626C6564496E746572666163653D612C2130297D2C656E61626C653A66756E6374696F6E2861297B613D3D3D62262628613D21';
wwv_flow_api.g_varchar2_table(260) := '30292C746869732E5F656E61626C6564213D3D61262628746869732E5F656E61626C65643D612C746869732E6F7074732E656C656D656E742E70726F70282264697361626C6564222C2161292C746869732E656E61626C65496E74657266616365282929';
wwv_flow_api.g_varchar2_table(261) := '7D2C64697361626C653A66756E6374696F6E28297B746869732E656E61626C65282131297D2C726561646F6E6C793A66756E6374696F6E2861297B72657475726E20613D3D3D62262628613D2131292C746869732E5F726561646F6E6C793D3D3D613F21';
wwv_flow_api.g_varchar2_table(262) := '313A28746869732E5F726561646F6E6C793D612C746869732E6F7074732E656C656D656E742E70726F702822726561646F6E6C79222C61292C746869732E656E61626C65496E7465726661636528292C2130297D2C6F70656E65643A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(263) := '28297B72657475726E20746869732E636F6E7461696E65722E686173436C617373282273656C656374322D64726F70646F776E2D6F70656E22297D2C706F736974696F6E44726F70646F776E3A66756E6374696F6E28297B76617220712C722C732C742C';
wwv_flow_api.g_varchar2_table(264) := '623D746869732E64726F70646F776E2C633D746869732E636F6E7461696E65722E6F666673657428292C643D746869732E636F6E7461696E65722E6F75746572486569676874282131292C653D746869732E636F6E7461696E65722E6F75746572576964';
wwv_flow_api.g_varchar2_table(265) := '7468282131292C663D622E6F75746572486569676874282131292C673D612877696E646F77292E7363726F6C6C4C65667428292B612877696E646F77292E776964746828292C683D612877696E646F77292E7363726F6C6C546F7028292B612877696E64';
wwv_flow_api.g_varchar2_table(266) := '6F77292E68656967687428292C693D632E746F702B642C6A3D632E6C6566742C6C3D683E3D692B662C6D3D632E746F702D663E3D746869732E626F647928292E7363726F6C6C546F7028292C6E3D622E6F757465725769647468282131292C6F3D673E3D';
wwv_flow_api.g_varchar2_table(267) := '6A2B6E2C703D622E686173436C617373282273656C656374322D64726F702D61626F766522293B746869732E6F7074732E64726F70646F776E4175746F57696474683F28743D6128222E73656C656374322D726573756C7473222C62295B305D2C622E61';
wwv_flow_api.g_varchar2_table(268) := '6464436C617373282273656C656374322D64726F702D6175746F2D776964746822292C622E63737328227769647468222C2222292C6E3D622E6F757465725769647468282131292B28742E7363726F6C6C4865696768743D3D3D742E636C69656E744865';
wwv_flow_api.g_varchar2_table(269) := '696768743F303A6B2E7769647468292C6E3E653F653D6E3A6E3D652C6F3D673E3D6A2B6E293A746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D64726F702D6175746F2D776964746822292C2273746174696322';
wwv_flow_api.g_varchar2_table(270) := '213D3D746869732E626F647928292E6373732822706F736974696F6E2229262628713D746869732E626F647928292E6F666673657428292C692D3D712E746F702C6A2D3D712E6C656674292C703F28723D21302C216D26266C262628723D213129293A28';
wwv_flow_api.g_varchar2_table(271) := '723D21312C216C26266D262628723D213029292C6F7C7C286A3D632E6C6566742B652D6E292C723F28693D632E746F702D662C746869732E636F6E7461696E65722E616464436C617373282273656C656374322D64726F702D61626F766522292C622E61';
wwv_flow_api.g_varchar2_table(272) := '6464436C617373282273656C656374322D64726F702D61626F76652229293A28746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D64726F702D61626F766522292C622E72656D6F7665436C617373282273656C65';
wwv_flow_api.g_varchar2_table(273) := '6374322D64726F702D61626F76652229292C733D612E657874656E64287B746F703A692C6C6566743A6A2C77696474683A657D2C4B28746869732E6F7074732E64726F70646F776E43737329292C622E6373732873297D2C73686F756C644F70656E3A66';
wwv_flow_api.g_varchar2_table(274) := '756E6374696F6E28297B76617220623B72657475726E20746869732E6F70656E656428293F21313A746869732E5F656E61626C65643D3D3D21317C7C746869732E5F726561646F6E6C793D3D3D21303F21313A28623D612E4576656E74282273656C6563';
wwv_flow_api.g_varchar2_table(275) := '74322D6F70656E696E6722292C746869732E6F7074732E656C656D656E742E747269676765722862292C21622E697344656661756C7450726576656E7465642829297D2C636C65617244726F70646F776E416C69676E6D656E74507265666572656E6365';
wwv_flow_api.g_varchar2_table(276) := '3A66756E6374696F6E28297B746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D64726F702D61626F766522292C746869732E64726F70646F776E2E72656D6F7665436C617373282273656C656374322D64726F70';
wwv_flow_api.g_varchar2_table(277) := '2D61626F766522297D2C6F70656E3A66756E6374696F6E28297B72657475726E20746869732E73686F756C644F70656E28293F28746869732E6F70656E696E6728292C2130293A21317D2C6F70656E696E673A66756E6374696F6E28297B76617220662C';
wwv_flow_api.g_varchar2_table(278) := '623D746869732E636F6E7461696E657249642C633D227363726F6C6C2E222B622C643D22726573697A652E222B622C653D226F7269656E746174696F6E6368616E67652E222B623B746869732E636F6E7461696E65722E616464436C617373282273656C';
wwv_flow_api.g_varchar2_table(279) := '656374322D64726F70646F776E2D6F70656E22292E616464436C617373282273656C656374322D636F6E7461696E65722D61637469766522292C746869732E636C65617244726F70646F776E416C69676E6D656E74507265666572656E636528292C7468';
wwv_flow_api.g_varchar2_table(280) := '69732E64726F70646F776E5B305D213D3D746869732E626F647928292E6368696C6472656E28292E6C61737428295B305D2626746869732E64726F70646F776E2E64657461636828292E617070656E64546F28746869732E626F64792829292C663D6128';
wwv_flow_api.g_varchar2_table(281) := '222373656C656374322D64726F702D6D61736B22292C303D3D662E6C656E677468262628663D6128646F63756D656E742E637265617465456C656D656E7428226469762229292C662E6174747228226964222C2273656C656374322D64726F702D6D6173';
wwv_flow_api.g_varchar2_table(282) := '6B22292E617474722822636C617373222C2273656C656374322D64726F702D6D61736B22292C662E6869646528292C662E617070656E64546F28746869732E626F64792829292C662E6F6E28226D6F757365646F776E20746F756368737461727420636C';
wwv_flow_api.g_varchar2_table(283) := '69636B222C66756E6374696F6E2862297B76617220642C633D6128222373656C656374322D64726F7022293B632E6C656E6774683E30262628643D632E64617461282273656C6563743222292C642E6F7074732E73656C6563744F6E426C75722626642E';
wwv_flow_api.g_varchar2_table(284) := '73656C656374486967686C696768746564287B6E6F466F6375733A21307D292C642E636C6F7365287B666F6375733A21317D292C622E70726576656E7444656661756C7428292C622E73746F7050726F7061676174696F6E2829297D29292C746869732E';
wwv_flow_api.g_varchar2_table(285) := '64726F70646F776E2E7072657628295B305D213D3D665B305D2626746869732E64726F70646F776E2E6265666F72652866292C6128222373656C656374322D64726F7022292E72656D6F7665417474722822696422292C746869732E64726F70646F776E';
wwv_flow_api.g_varchar2_table(286) := '2E6174747228226964222C2273656C656374322D64726F7022292C662E73686F7728292C746869732E706F736974696F6E44726F70646F776E28292C746869732E64726F70646F776E2E73686F7728292C746869732E706F736974696F6E44726F70646F';
wwv_flow_api.g_varchar2_table(287) := '776E28292C746869732E64726F70646F776E2E616464436C617373282273656C656374322D64726F702D61637469766522293B76617220683D746869733B746869732E636F6E7461696E65722E706172656E747328292E6164642877696E646F77292E65';
wwv_flow_api.g_varchar2_table(288) := '6163682866756E6374696F6E28297B612874686973292E6F6E28642B2220222B632B2220222B652C66756E6374696F6E28297B682E706F736974696F6E44726F70646F776E28297D297D297D2C636C6F73653A66756E6374696F6E28297B696628746869';
wwv_flow_api.g_varchar2_table(289) := '732E6F70656E65642829297B76617220623D746869732E636F6E7461696E657249642C633D227363726F6C6C2E222B622C643D22726573697A652E222B622C653D226F7269656E746174696F6E6368616E67652E222B623B746869732E636F6E7461696E';
wwv_flow_api.g_varchar2_table(290) := '65722E706172656E747328292E6164642877696E646F77292E656163682866756E6374696F6E28297B612874686973292E6F66662863292E6F66662864292E6F66662865297D292C746869732E636C65617244726F70646F776E416C69676E6D656E7450';
wwv_flow_api.g_varchar2_table(291) := '7265666572656E636528292C6128222373656C656374322D64726F702D6D61736B22292E6869646528292C746869732E64726F70646F776E2E72656D6F7665417474722822696422292C746869732E64726F70646F776E2E6869646528292C746869732E';
wwv_flow_api.g_varchar2_table(292) := '636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D64726F70646F776E2D6F70656E22292C746869732E726573756C74732E656D70747928292C746869732E636C65617253656172636828292C746869732E7365617263682E72';
wwv_flow_api.g_varchar2_table(293) := '656D6F7665436C617373282273656C656374322D61637469766522292C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D636C6F73652229297D7D2C65787465726E616C5365617263683A6675';
wwv_flow_api.g_varchar2_table(294) := '6E6374696F6E2861297B746869732E6F70656E28292C746869732E7365617263682E76616C2861292C746869732E757064617465526573756C7473282131297D2C636C6561725365617263683A66756E6374696F6E28297B7D2C6765744D6178696D756D';
wwv_flow_api.g_varchar2_table(295) := '53656C656374696F6E53697A653A66756E6374696F6E28297B72657475726E204B28746869732E6F7074732E6D6178696D756D53656C656374696F6E53697A65297D2C656E73757265486967686C6967687456697369626C653A66756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(296) := '7B76617220632C642C652C662C672C682C692C623D746869732E726573756C74733B696628643D746869732E686967686C6967687428292C2128303E6429297B696628303D3D642972657475726E20622E7363726F6C6C546F702830292C766F69642030';
wwv_flow_api.g_varchar2_table(297) := '3B633D746869732E66696E64486967686C6967687461626C6543686F6963657328292E66696E6428222E73656C656374322D726573756C742D6C6162656C22292C653D6128635B645D292C663D652E6F666673657428292E746F702B652E6F7574657248';
wwv_flow_api.g_varchar2_table(298) := '6569676874282130292C643D3D3D632E6C656E6774682D31262628693D622E66696E6428226C692E73656C656374322D6D6F72652D726573756C747322292C692E6C656E6774683E30262628663D692E6F666673657428292E746F702B692E6F75746572';
wwv_flow_api.g_varchar2_table(299) := '4865696768742821302929292C673D622E6F666673657428292E746F702B622E6F75746572486569676874282130292C663E672626622E7363726F6C6C546F7028622E7363726F6C6C546F7028292B28662D6729292C683D652E6F666673657428292E74';
wwv_flow_api.g_varchar2_table(300) := '6F702D622E6F666673657428292E746F702C303E682626226E6F6E6522213D652E6373732822646973706C617922292626622E7363726F6C6C546F7028622E7363726F6C6C546F7028292B68297D7D2C66696E64486967686C6967687461626C6543686F';
wwv_flow_api.g_varchar2_table(301) := '696365733A66756E6374696F6E28297B72657475726E20746869732E726573756C74732E66696E6428222E73656C656374322D726573756C742D73656C65637461626C653A6E6F74282E73656C656374322D73656C6563746564293A6E6F74282E73656C';
wwv_flow_api.g_varchar2_table(302) := '656374322D64697361626C65642922297D2C6D6F7665486967686C696768743A66756E6374696F6E2862297B666F722876617220633D746869732E66696E64486967686C6967687461626C6543686F6963657328292C643D746869732E686967686C6967';
wwv_flow_api.g_varchar2_table(303) := '687428293B643E2D312626643C632E6C656E6774683B297B642B3D623B76617220653D6128635B645D293B696628652E686173436C617373282273656C656374322D726573756C742D73656C65637461626C652229262621652E686173436C6173732822';
wwv_flow_api.g_varchar2_table(304) := '73656C656374322D64697361626C65642229262621652E686173436C617373282273656C656374322D73656C65637465642229297B746869732E686967686C696768742864293B627265616B7D7D7D2C686967686C696768743A66756E6374696F6E2862';
wwv_flow_api.g_varchar2_table(305) := '297B76617220642C652C633D746869732E66696E64486967686C6967687461626C6543686F6963657328293B72657475726E20303D3D3D617267756D656E74732E6C656E6774683F6F28632E66696C74657228222E73656C656374322D686967686C6967';
wwv_flow_api.g_varchar2_table(306) := '6874656422295B305D2C632E6765742829293A28623E3D632E6C656E677468262628623D632E6C656E6774682D31292C303E62262628623D30292C746869732E72656D6F7665486967686C6967687428292C643D6128635B625D292C642E616464436C61';
wwv_flow_api.g_varchar2_table(307) := '7373282273656C656374322D686967686C69676874656422292C746869732E656E73757265486967686C6967687456697369626C6528292C653D642E64617461282273656C656374322D6461746122292C652626746869732E6F7074732E656C656D656E';
wwv_flow_api.g_varchar2_table(308) := '742E74726967676572287B747970653A2273656C656374322D686967686C69676874222C76616C3A746869732E69642865292C63686F6963653A657D292C766F69642030297D2C72656D6F7665486967686C696768743A66756E6374696F6E28297B7468';
wwv_flow_api.g_varchar2_table(309) := '69732E726573756C74732E66696E6428222E73656C656374322D686967686C69676874656422292E72656D6F7665436C617373282273656C656374322D686967686C69676874656422297D2C636F756E7453656C65637461626C65526573756C74733A66';
wwv_flow_api.g_varchar2_table(310) := '756E6374696F6E28297B72657475726E20746869732E66696E64486967686C6967687461626C6543686F6963657328292E6C656E6774687D2C686967686C69676874556E6465724576656E743A66756E6374696F6E2862297B76617220633D6128622E74';
wwv_flow_api.g_varchar2_table(311) := '6172676574292E636C6F7365737428222E73656C656374322D726573756C742D73656C65637461626C6522293B696628632E6C656E6774683E30262621632E697328222E73656C656374322D686967686C6967687465642229297B76617220643D746869';
wwv_flow_api.g_varchar2_table(312) := '732E66696E64486967686C6967687461626C6543686F6963657328293B746869732E686967686C6967687428642E696E646578286329297D656C736520303D3D632E6C656E6774682626746869732E72656D6F7665486967686C6967687428297D2C6C6F';
wwv_flow_api.g_varchar2_table(313) := '61644D6F726549664E65656465643A66756E6374696F6E28297B76617220632C613D746869732E726573756C74732C623D612E66696E6428226C692E73656C656374322D6D6F72652D726573756C747322292C653D746869732E726573756C7473506167';
wwv_flow_api.g_varchar2_table(314) := '652B312C663D746869732C673D746869732E7365617263682E76616C28292C683D746869732E636F6E746578743B30213D3D622E6C656E677468262628633D622E6F666673657428292E746F702D612E6F666673657428292E746F702D612E6865696768';
wwv_flow_api.g_varchar2_table(315) := '7428292C633C3D746869732E6F7074732E6C6F61644D6F726550616464696E67262628622E616464436C617373282273656C656374322D61637469766522292C746869732E6F7074732E7175657279287B656C656D656E743A746869732E6F7074732E65';
wwv_flow_api.g_varchar2_table(316) := '6C656D656E742C7465726D3A672C706167653A652C636F6E746578743A682C6D6174636865723A746869732E6F7074732E6D6174636865722C63616C6C6261636B3A746869732E62696E642866756E6374696F6E2863297B662E6F70656E656428292626';
wwv_flow_api.g_varchar2_table(317) := '28662E6F7074732E706F70756C617465526573756C74732E63616C6C28746869732C612C632E726573756C74732C7B7465726D3A672C706167653A652C636F6E746578743A687D292C662E706F737470726F63657373526573756C747328632C21312C21';
wwv_flow_api.g_varchar2_table(318) := '31292C632E6D6F72653D3D3D21303F28622E64657461636828292E617070656E64546F2861292E7465787428662E6F7074732E666F726D61744C6F61644D6F726528652B3129292C77696E646F772E73657454696D656F75742866756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(319) := '7B662E6C6F61644D6F726549664E656564656428297D2C313029293A622E72656D6F766528292C662E706F736974696F6E44726F70646F776E28292C662E726573756C7473506167653D652C662E636F6E746578743D632E636F6E746578742C74686973';
wwv_flow_api.g_varchar2_table(320) := '2E6F7074732E656C656D656E742E74726967676572287B747970653A2273656C656374322D6C6F61646564222C6974656D733A637D29297D297D2929297D2C746F6B656E697A653A66756E6374696F6E28297B7D2C757064617465526573756C74733A66';
wwv_flow_api.g_varchar2_table(321) := '756E6374696F6E2863297B66756E6374696F6E206D28297B642E72656D6F7665436C617373282273656C656374322D61637469766522292C682E706F736974696F6E44726F70646F776E28297D66756E6374696F6E206E2861297B652E68746D6C286129';
wwv_flow_api.g_varchar2_table(322) := '2C6D28297D76617220672C692C6C2C643D746869732E7365617263682C653D746869732E726573756C74732C663D746869732E6F7074732C683D746869732C6A3D642E76616C28292C6B3D612E6461746128746869732E636F6E7461696E65722C227365';
wwv_flow_api.g_varchar2_table(323) := '6C656374322D6C6173742D7465726D22293B69662828633D3D3D21307C7C216B7C7C2171286A2C6B2929262628612E6461746128746869732E636F6E7461696E65722C2273656C656374322D6C6173742D7465726D222C6A292C633D3D3D21307C7C7468';
wwv_flow_api.g_varchar2_table(324) := '69732E73686F77536561726368496E707574213D3D21312626746869732E6F70656E6564282929297B6C3D2B2B746869732E7175657279436F756E743B766172206F3D746869732E6765744D6178696D756D53656C656374696F6E53697A6528293B6966';
wwv_flow_api.g_varchar2_table(325) := '286F3E3D31262628673D746869732E6461746128292C612E697341727261792867292626672E6C656E6774683E3D6F26264A28662E666F726D617453656C656374696F6E546F6F4269672C22666F726D617453656C656374696F6E546F6F426967222929';
wwv_flow_api.g_varchar2_table(326) := '2972657475726E206E28223C6C6920636C6173733D2773656C656374322D73656C656374696F6E2D6C696D6974273E222B662E666F726D617453656C656374696F6E546F6F426967286F292B223C2F6C693E22292C766F696420303B696628642E76616C';
wwv_flow_api.g_varchar2_table(327) := '28292E6C656E6774683C662E6D696E696D756D496E7075744C656E6774682972657475726E204A28662E666F726D6174496E707574546F6F53686F72742C22666F726D6174496E707574546F6F53686F727422293F6E28223C6C6920636C6173733D2773';
wwv_flow_api.g_varchar2_table(328) := '656C656374322D6E6F2D726573756C7473273E222B662E666F726D6174496E707574546F6F53686F727428642E76616C28292C662E6D696E696D756D496E7075744C656E677468292B223C2F6C693E22293A6E282222292C632626746869732E73686F77';
wwv_flow_api.g_varchar2_table(329) := '5365617263682626746869732E73686F77536561726368282130292C766F696420303B696628662E6D6178696D756D496E7075744C656E6774682626642E76616C28292E6C656E6774683E662E6D6178696D756D496E7075744C656E6774682972657475';
wwv_flow_api.g_varchar2_table(330) := '726E204A28662E666F726D6174496E707574546F6F4C6F6E672C22666F726D6174496E707574546F6F4C6F6E6722293F6E28223C6C6920636C6173733D2773656C656374322D6E6F2D726573756C7473273E222B662E666F726D6174496E707574546F6F';
wwv_flow_api.g_varchar2_table(331) := '4C6F6E6728642E76616C28292C662E6D6178696D756D496E7075744C656E677468292B223C2F6C693E22293A6E282222292C766F696420303B0A662E666F726D6174536561726368696E672626303D3D3D746869732E66696E64486967686C6967687461';
wwv_flow_api.g_varchar2_table(332) := '626C6543686F6963657328292E6C656E67746826266E28223C6C6920636C6173733D2773656C656374322D736561726368696E67273E222B662E666F726D6174536561726368696E6728292B223C2F6C693E22292C642E616464436C617373282273656C';
wwv_flow_api.g_varchar2_table(333) := '656374322D61637469766522292C746869732E72656D6F7665486967686C6967687428292C693D746869732E746F6B656E697A6528292C69213D6226266E756C6C213D692626642E76616C2869292C746869732E726573756C7473506167653D312C662E';
wwv_flow_api.g_varchar2_table(334) := '7175657279287B656C656D656E743A662E656C656D656E742C7465726D3A642E76616C28292C706167653A746869732E726573756C7473506167652C636F6E746578743A6E756C6C2C6D6174636865723A662E6D6174636865722C63616C6C6261636B3A';
wwv_flow_api.g_varchar2_table(335) := '746869732E62696E642866756E6374696F6E2867297B76617220693B6966286C3D3D746869732E7175657279436F756E74297B69662821746869732E6F70656E656428292972657475726E20746869732E7365617263682E72656D6F7665436C61737328';
wwv_flow_api.g_varchar2_table(336) := '2273656C656374322D61637469766522292C766F696420303B696628746869732E636F6E746578743D672E636F6E746578743D3D3D623F6E756C6C3A672E636F6E746578742C746869732E6F7074732E63726561746553656172636843686F6963652626';
wwv_flow_api.g_varchar2_table(337) := '2222213D3D642E76616C2829262628693D746869732E6F7074732E63726561746553656172636843686F6963652E63616C6C28682C642E76616C28292C672E726573756C7473292C69213D3D6226266E756C6C213D3D692626682E6964286929213D3D62';
wwv_flow_api.g_varchar2_table(338) := '26266E756C6C213D3D682E69642869292626303D3D3D6128672E726573756C7473292E66696C7465722866756E6374696F6E28297B72657475726E207128682E69642874686973292C682E6964286929297D292E6C656E6774682626672E726573756C74';
wwv_flow_api.g_varchar2_table(339) := '732E756E7368696674286929292C303D3D3D672E726573756C74732E6C656E67746826264A28662E666F726D61744E6F4D6174636865732C22666F726D61744E6F4D61746368657322292972657475726E206E28223C6C6920636C6173733D2773656C65';
wwv_flow_api.g_varchar2_table(340) := '6374322D6E6F2D726573756C7473273E222B662E666F726D61744E6F4D61746368657328642E76616C2829292B223C2F6C693E22292C766F696420303B652E656D70747928292C682E6F7074732E706F70756C617465526573756C74732E63616C6C2874';
wwv_flow_api.g_varchar2_table(341) := '6869732C652C672E726573756C74732C7B7465726D3A642E76616C28292C706167653A746869732E726573756C7473506167652C636F6E746578743A6E756C6C7D292C672E6D6F72653D3D3D213026264A28662E666F726D61744C6F61644D6F72652C22';
wwv_flow_api.g_varchar2_table(342) := '666F726D61744C6F61644D6F72652229262628652E617070656E6428223C6C6920636C6173733D2773656C656374322D6D6F72652D726573756C7473273E222B682E6F7074732E6573636170654D61726B757028662E666F726D61744C6F61644D6F7265';
wwv_flow_api.g_varchar2_table(343) := '28746869732E726573756C74735061676529292B223C2F6C693E22292C77696E646F772E73657454696D656F75742866756E6374696F6E28297B682E6C6F61644D6F726549664E656564656428297D2C313029292C746869732E706F737470726F636573';
wwv_flow_api.g_varchar2_table(344) := '73526573756C747328672C63292C6D28292C746869732E6F7074732E656C656D656E742E74726967676572287B747970653A2273656C656374322D6C6F61646564222C6974656D733A677D297D7D297D297D7D2C63616E63656C3A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(345) := '297B746869732E636C6F736528297D2C626C75723A66756E6374696F6E28297B746869732E6F7074732E73656C6563744F6E426C75722626746869732E73656C656374486967686C696768746564287B6E6F466F6375733A21307D292C746869732E636C';
wwv_flow_api.g_varchar2_table(346) := '6F736528292C746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D636F6E7461696E65722D61637469766522292C746869732E7365617263685B305D3D3D3D646F63756D656E742E616374697665456C656D656E74';
wwv_flow_api.g_varchar2_table(347) := '2626746869732E7365617263682E626C757228292C746869732E636C65617253656172636828292C746869732E73656C656374696F6E2E66696E6428222E73656C656374322D7365617263682D63686F6963652D666F63757322292E72656D6F7665436C';
wwv_flow_api.g_varchar2_table(348) := '617373282273656C656374322D7365617263682D63686F6963652D666F63757322297D2C666F6375735365617263683A66756E6374696F6E28297B7928746869732E736561726368297D2C73656C656374486967686C6967687465643A66756E6374696F';
wwv_flow_api.g_varchar2_table(349) := '6E2861297B76617220623D746869732E686967686C6967687428292C633D746869732E726573756C74732E66696E6428222E73656C656374322D686967686C69676874656422292C643D632E636C6F7365737428222E73656C656374322D726573756C74';
wwv_flow_api.g_varchar2_table(350) := '22292E64617461282273656C656374322D6461746122293B643F28746869732E686967686C696768742862292C746869732E6F6E53656C65637428642C6129293A612626612E6E6F466F6375732626746869732E636C6F736528297D2C676574506C6163';
wwv_flow_api.g_varchar2_table(351) := '65686F6C6465723A66756E6374696F6E28297B76617220613B72657475726E20746869732E6F7074732E656C656D656E742E617474722822706C616365686F6C64657222297C7C746869732E6F7074732E656C656D656E742E617474722822646174612D';
wwv_flow_api.g_varchar2_table(352) := '706C616365686F6C64657222297C7C746869732E6F7074732E656C656D656E742E646174612822706C616365686F6C64657222297C7C746869732E6F7074732E706C616365686F6C6465727C7C2828613D746869732E676574506C616365686F6C646572';
wwv_flow_api.g_varchar2_table(353) := '4F7074696F6E282929213D3D623F612E7465787428293A62297D2C676574506C616365686F6C6465724F7074696F6E3A66756E6374696F6E28297B696628746869732E73656C656374297B76617220613D746869732E73656C6563742E6368696C647265';
wwv_flow_api.g_varchar2_table(354) := '6E28292E666972737428293B696628746869732E6F7074732E706C616365686F6C6465724F7074696F6E213D3D622972657475726E226669727374223D3D3D746869732E6F7074732E706C616365686F6C6465724F7074696F6E2626617C7C2266756E63';
wwv_flow_api.g_varchar2_table(355) := '74696F6E223D3D747970656F6620746869732E6F7074732E706C616365686F6C6465724F7074696F6E2626746869732E6F7074732E706C616365686F6C6465724F7074696F6E28746869732E73656C656374293B69662822223D3D3D612E746578742829';
wwv_flow_api.g_varchar2_table(356) := '262622223D3D3D612E76616C28292972657475726E20617D7D2C696E6974436F6E7461696E657257696474683A66756E6374696F6E28297B66756E6374696F6E206328297B76617220632C642C652C662C673B696628226F6666223D3D3D746869732E6F';
wwv_flow_api.g_varchar2_table(357) := '7074732E77696474682972657475726E206E756C6C3B69662822656C656D656E74223D3D3D746869732E6F7074732E77696474682972657475726E20303D3D3D746869732E6F7074732E656C656D656E742E6F757465725769647468282131293F226175';
wwv_flow_api.g_varchar2_table(358) := '746F223A746869732E6F7074732E656C656D656E742E6F757465725769647468282131292B227078223B69662822636F7079223D3D3D746869732E6F7074732E77696474687C7C227265736F6C7665223D3D3D746869732E6F7074732E7769647468297B';
wwv_flow_api.g_varchar2_table(359) := '696628633D746869732E6F7074732E656C656D656E742E6174747228227374796C6522292C63213D3D6229666F7228643D632E73706C697428223B22292C663D302C673D642E6C656E6774683B673E663B662B3D3129696628653D645B665D2E7265706C';
wwv_flow_api.g_varchar2_table(360) := '616365282F5C732F672C2222292E6D61746368282F5B5E2D5D77696474683A28285B2D2B5D3F285B302D395D2A5C2E293F5B302D395D2B292870787C656D7C65787C257C696E7C636D7C6D6D7C70747C706329292F69292C6E756C6C213D3D652626652E';
wwv_flow_api.g_varchar2_table(361) := '6C656E6774683E3D312972657475726E20655B315D3B72657475726E227265736F6C7665223D3D3D746869732E6F7074732E77696474683F28633D746869732E6F7074732E656C656D656E742E6373732822776964746822292C632E696E6465784F6628';
wwv_flow_api.g_varchar2_table(362) := '222522293E303F633A303D3D3D746869732E6F7074732E656C656D656E742E6F757465725769647468282131293F226175746F223A746869732E6F7074732E656C656D656E742E6F757465725769647468282131292B22707822293A6E756C6C7D726574';
wwv_flow_api.g_varchar2_table(363) := '75726E20612E697346756E6374696F6E28746869732E6F7074732E7769647468293F746869732E6F7074732E776964746828293A746869732E6F7074732E77696474687D76617220643D632E63616C6C2874686973293B6E756C6C213D3D642626746869';
wwv_flow_api.g_varchar2_table(364) := '732E636F6E7461696E65722E63737328227769647468222C64297D7D292C653D4E28642C7B637265617465436F6E7461696E65723A66756E6374696F6E28297B76617220623D6128646F63756D656E742E637265617465456C656D656E74282264697622';
wwv_flow_api.g_varchar2_table(365) := '29292E61747472287B22636C617373223A2273656C656374322D636F6E7461696E6572227D292E68746D6C285B223C6120687265663D276A6176617363726970743A766F696428302927206F6E636C69636B3D2772657475726E2066616C73653B272063';
wwv_flow_api.g_varchar2_table(366) := '6C6173733D2773656C656374322D63686F6963652720746162696E6465783D272D31273E222C222020203C7370616E20636C6173733D2773656C656374322D63686F73656E273E266E6273703B3C2F7370616E3E3C6162627220636C6173733D2773656C';
wwv_flow_api.g_varchar2_table(367) := '656374322D7365617263682D63686F6963652D636C6F7365273E3C2F616262723E222C222020203C7370616E20636C6173733D2773656C656374322D6172726F77273E3C623E3C2F623E3C2F7370616E3E222C223C2F613E222C223C696E70757420636C';
wwv_flow_api.g_varchar2_table(368) := '6173733D2773656C656374322D666F6375737365722073656C656374322D6F666673637265656E2720747970653D2774657874272F3E222C223C64697620636C6173733D2773656C656374322D64726F702073656C656374322D646973706C61792D6E6F';
wwv_flow_api.g_varchar2_table(369) := '6E65273E222C222020203C64697620636C6173733D2773656C656374322D736561726368273E222C22202020202020203C696E70757420747970653D277465787427206175746F636F6D706C6574653D276F666627206175746F636F72726563743D276F';
wwv_flow_api.g_varchar2_table(370) := '666627206175746F6361706974616C697A653D276F666627207370656C6C636865636B3D2766616C73652720636C6173733D2773656C656374322D696E707574272F3E222C222020203C2F6469763E222C222020203C756C20636C6173733D2773656C65';
wwv_flow_api.g_varchar2_table(371) := '6374322D726573756C7473273E222C222020203C2F756C3E222C223C2F6469763E225D2E6A6F696E28222229293B72657475726E20627D2C656E61626C65496E746572666163653A66756E6374696F6E28297B746869732E706172656E742E656E61626C';
wwv_flow_api.g_varchar2_table(372) := '65496E746572666163652E6170706C7928746869732C617267756D656E7473292626746869732E666F6375737365722E70726F70282264697361626C6564222C21746869732E6973496E74657266616365456E61626C65642829297D2C6F70656E696E67';
wwv_flow_api.g_varchar2_table(373) := '3A66756E6374696F6E28297B76617220632C642C653B746869732E6F7074732E6D696E696D756D526573756C7473466F725365617263683E3D302626746869732E73686F77536561726368282130292C746869732E706172656E742E6F70656E696E672E';
wwv_flow_api.g_varchar2_table(374) := '6170706C7928746869732C617267756D656E7473292C746869732E73686F77536561726368496E707574213D3D21312626746869732E7365617263682E76616C28746869732E666F6375737365722E76616C2829292C746869732E7365617263682E666F';
wwv_flow_api.g_varchar2_table(375) := '63757328292C633D746869732E7365617263682E6765742830292C632E6372656174655465787452616E67653F28643D632E6372656174655465787452616E676528292C642E636F6C6C61707365282131292C642E73656C6563742829293A632E736574';
wwv_flow_api.g_varchar2_table(376) := '53656C656374696F6E52616E6765262628653D746869732E7365617263682E76616C28292E6C656E6774682C632E73657453656C656374696F6E52616E676528652C6529292C22223D3D3D746869732E7365617263682E76616C28292626746869732E6E';
wwv_flow_api.g_varchar2_table(377) := '6578745365617263685465726D213D62262628746869732E7365617263682E76616C28746869732E6E6578745365617263685465726D292C746869732E7365617263682E73656C6563742829292C746869732E666F6375737365722E70726F7028226469';
wwv_flow_api.g_varchar2_table(378) := '7361626C6564222C2130292E76616C282222292C746869732E757064617465526573756C7473282130292C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D6F70656E2229297D2C636C6F7365';
wwv_flow_api.g_varchar2_table(379) := '3A66756E6374696F6E2861297B746869732E6F70656E65642829262628746869732E706172656E742E636C6F73652E6170706C7928746869732C617267756D656E7473292C613D617C7C7B666F6375733A21307D2C746869732E666F6375737365722E72';
wwv_flow_api.g_varchar2_table(380) := '656D6F766541747472282264697361626C656422292C612E666F6375732626746869732E666F6375737365722E666F6375732829297D2C666F6375733A66756E6374696F6E28297B746869732E6F70656E656428293F746869732E636C6F736528293A28';
wwv_flow_api.g_varchar2_table(381) := '746869732E666F6375737365722E72656D6F766541747472282264697361626C656422292C746869732E666F6375737365722E666F6375732829297D2C6973466F63757365643A66756E6374696F6E28297B72657475726E20746869732E636F6E746169';
wwv_flow_api.g_varchar2_table(382) := '6E65722E686173436C617373282273656C656374322D636F6E7461696E65722D61637469766522297D2C63616E63656C3A66756E6374696F6E28297B746869732E706172656E742E63616E63656C2E6170706C7928746869732C617267756D656E747329';
wwv_flow_api.g_varchar2_table(383) := '2C746869732E666F6375737365722E72656D6F766541747472282264697361626C656422292C746869732E666F6375737365722E666F63757328297D2C64657374726F793A66756E6374696F6E28297B6128226C6162656C5B666F723D27222B74686973';
wwv_flow_api.g_varchar2_table(384) := '2E666F6375737365722E617474722822696422292B22275D22292E617474722822666F72222C746869732E6F7074732E656C656D656E742E61747472282269642229292C746869732E706172656E742E64657374726F792E6170706C7928746869732C61';
wwv_flow_api.g_varchar2_table(385) := '7267756D656E7473297D2C696E6974436F6E7461696E65723A66756E6374696F6E28297B76617220622C643D746869732E636F6E7461696E65722C653D746869732E64726F70646F776E3B746869732E6F7074732E6D696E696D756D526573756C747346';
wwv_flow_api.g_varchar2_table(386) := '6F725365617263683C303F746869732E73686F77536561726368282131293A746869732E73686F77536561726368282130292C746869732E73656C656374696F6E3D623D642E66696E6428222E73656C656374322D63686F69636522292C746869732E66';
wwv_flow_api.g_varchar2_table(387) := '6F6375737365723D642E66696E6428222E73656C656374322D666F63757373657222292C746869732E666F6375737365722E6174747228226964222C22733269645F6175746F67656E222B672829292C6128226C6162656C5B666F723D27222B74686973';
wwv_flow_api.g_varchar2_table(388) := '2E6F7074732E656C656D656E742E617474722822696422292B22275D22292E617474722822666F72222C746869732E666F6375737365722E61747472282269642229292C746869732E666F6375737365722E617474722822746162696E646578222C7468';
wwv_flow_api.g_varchar2_table(389) := '69732E656C656D656E74546162496E646578292C746869732E7365617263682E6F6E28226B6579646F776E222C746869732E62696E642866756E6374696F6E2861297B696628746869732E6973496E74657266616365456E61626C65642829297B696628';
wwv_flow_api.g_varchar2_table(390) := '612E77686963683D3D3D632E504147455F55507C7C612E77686963683D3D3D632E504147455F444F574E2972657475726E20412861292C766F696420303B73776974636828612E7768696368297B6361736520632E55503A6361736520632E444F574E3A';
wwv_flow_api.g_varchar2_table(391) := '72657475726E20746869732E6D6F7665486967686C6967687428612E77686963683D3D3D632E55503F2D313A31292C412861292C766F696420303B6361736520632E454E5445523A72657475726E20746869732E73656C656374486967686C6967687465';
wwv_flow_api.g_varchar2_table(392) := '6428292C412861292C766F696420303B6361736520632E5441423A72657475726E20746869732E6F7074732E73656C6563744F6E426C75722626746869732E73656C656374486967686C696768746564287B6E6F466F6375733A21307D292C766F696420';
wwv_flow_api.g_varchar2_table(393) := '303B6361736520632E4553433A72657475726E20746869732E63616E63656C2861292C412861292C766F696420307D7D7D29292C746869732E7365617263682E6F6E2822626C7572222C746869732E62696E642866756E6374696F6E28297B646F63756D';
wwv_flow_api.g_varchar2_table(394) := '656E742E616374697665456C656D656E743D3D3D746869732E626F647928292E676574283029262677696E646F772E73657454696D656F757428746869732E62696E642866756E6374696F6E28297B746869732E7365617263682E666F63757328297D29';
wwv_flow_api.g_varchar2_table(395) := '2C30297D29292C746869732E666F6375737365722E6F6E28226B6579646F776E222C746869732E62696E642866756E6374696F6E2861297B696628746869732E6973496E74657266616365456E61626C656428292626612E7768696368213D3D632E5441';
wwv_flow_api.g_varchar2_table(396) := '42262621632E6973436F6E74726F6C286129262621632E697346756E6374696F6E4B65792861292626612E7768696368213D3D632E455343297B696628746869732E6F7074732E6F70656E4F6E456E7465723D3D3D21312626612E77686963683D3D3D63';
wwv_flow_api.g_varchar2_table(397) := '2E454E5445522972657475726E20412861292C766F696420303B696628612E77686963683D3D632E444F574E7C7C612E77686963683D3D632E55507C7C612E77686963683D3D632E454E5445522626746869732E6F7074732E6F70656E4F6E456E746572';
wwv_flow_api.g_varchar2_table(398) := '297B696628612E616C744B65797C7C612E6374726C4B65797C7C612E73686966744B65797C7C612E6D6574614B65792972657475726E3B72657475726E20746869732E6F70656E28292C412861292C766F696420307D72657475726E20612E7768696368';
wwv_flow_api.g_varchar2_table(399) := '3D3D632E44454C4554457C7C612E77686963683D3D632E4241434B53504143453F28746869732E6F7074732E616C6C6F77436C6561722626746869732E636C65617228292C412861292C766F69642030293A766F696420307D7D29292C7428746869732E';
wwv_flow_api.g_varchar2_table(400) := '666F637573736572292C746869732E666F6375737365722E6F6E28226B657975702D6368616E676520696E707574222C746869732E62696E642866756E6374696F6E2861297B696628746869732E6F7074732E6D696E696D756D526573756C7473466F72';
wwv_flow_api.g_varchar2_table(401) := '5365617263683E3D30297B696628612E73746F7050726F7061676174696F6E28292C746869732E6F70656E656428292972657475726E3B746869732E6F70656E28297D7D29292C622E6F6E28226D6F757365646F776E222C2261626272222C746869732E';
wwv_flow_api.g_varchar2_table(402) := '62696E642866756E6374696F6E2861297B746869732E6973496E74657266616365456E61626C65642829262628746869732E636C65617228292C422861292C746869732E636C6F736528292C746869732E73656C656374696F6E2E666F6375732829297D';
wwv_flow_api.g_varchar2_table(403) := '29292C622E6F6E28226D6F757365646F776E222C746869732E62696E642866756E6374696F6E2862297B746869732E636F6E7461696E65722E686173436C617373282273656C656374322D636F6E7461696E65722D61637469766522297C7C746869732E';
wwv_flow_api.g_varchar2_table(404) := '6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D666F6375732229292C746869732E6F70656E656428293F746869732E636C6F736528293A746869732E6973496E74657266616365456E61626C6564282926';
wwv_flow_api.g_varchar2_table(405) := '26746869732E6F70656E28292C412862297D29292C652E6F6E28226D6F757365646F776E222C746869732E62696E642866756E6374696F6E28297B746869732E7365617263682E666F63757328297D29292C622E6F6E2822666F637573222C746869732E';
wwv_flow_api.g_varchar2_table(406) := '62696E642866756E6374696F6E2861297B412861297D29292C746869732E666F6375737365722E6F6E2822666F637573222C746869732E62696E642866756E6374696F6E28297B746869732E636F6E7461696E65722E686173436C617373282273656C65';
wwv_flow_api.g_varchar2_table(407) := '6374322D636F6E7461696E65722D61637469766522297C7C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D666F6375732229292C746869732E636F6E7461696E65722E616464436C61737328';
wwv_flow_api.g_varchar2_table(408) := '2273656C656374322D636F6E7461696E65722D61637469766522297D29292E6F6E2822626C7572222C746869732E62696E642866756E6374696F6E28297B746869732E6F70656E656428297C7C28746869732E636F6E7461696E65722E72656D6F766543';
wwv_flow_api.g_varchar2_table(409) := '6C617373282273656C656374322D636F6E7461696E65722D61637469766522292C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D626C7572222929297D29292C746869732E7365617263682E';
wwv_flow_api.g_varchar2_table(410) := '6F6E2822666F637573222C746869732E62696E642866756E6374696F6E28297B746869732E636F6E7461696E65722E686173436C617373282273656C656374322D636F6E7461696E65722D61637469766522297C7C746869732E6F7074732E656C656D65';
wwv_flow_api.g_varchar2_table(411) := '6E742E7472696767657228612E4576656E74282273656C656374322D666F6375732229292C746869732E636F6E7461696E65722E616464436C617373282273656C656374322D636F6E7461696E65722D61637469766522297D29292C746869732E696E69';
wwv_flow_api.g_varchar2_table(412) := '74436F6E7461696E6572576964746828292C746869732E6F7074732E656C656D656E742E616464436C617373282273656C656374322D6F666673637265656E22292C746869732E736574506C616365686F6C64657228297D2C636C6561723A66756E6374';
wwv_flow_api.g_varchar2_table(413) := '696F6E2861297B76617220623D746869732E73656C656374696F6E2E64617461282273656C656374322D6461746122293B69662862297B76617220633D746869732E676574506C616365686F6C6465724F7074696F6E28293B746869732E6F7074732E65';
wwv_flow_api.g_varchar2_table(414) := '6C656D656E742E76616C28633F632E76616C28293A2222292C746869732E73656C656374696F6E2E66696E6428222E73656C656374322D63686F73656E22292E656D70747928292C746869732E73656C656374696F6E2E72656D6F766544617461282273';
wwv_flow_api.g_varchar2_table(415) := '656C656374322D6461746122292C746869732E736574506C616365686F6C64657228292C61213D3D2131262628746869732E6F7074732E656C656D656E742E74726967676572287B747970653A2273656C656374322D72656D6F766564222C76616C3A74';
wwv_flow_api.g_varchar2_table(416) := '6869732E69642862292C63686F6963653A627D292C746869732E747269676765724368616E6765287B72656D6F7665643A627D29297D7D2C696E697453656C656374696F6E3A66756E6374696F6E28297B696628746869732E6973506C616365686F6C64';
wwv_flow_api.g_varchar2_table(417) := '65724F7074696F6E53656C6563746564282929746869732E75706461746553656C656374696F6E286E756C6C292C746869732E636C6F736528292C746869732E736574506C616365686F6C64657228293B656C73657B76617220633D746869733B746869';
wwv_flow_api.g_varchar2_table(418) := '732E6F7074732E696E697453656C656374696F6E2E63616C6C286E756C6C2C746869732E6F7074732E656C656D656E742C66756E6374696F6E2861297B61213D3D6226266E756C6C213D3D61262628632E75706461746553656C656374696F6E2861292C';
wwv_flow_api.g_varchar2_table(419) := '632E636C6F736528292C632E736574506C616365686F6C6465722829297D297D7D2C6973506C616365686F6C6465724F7074696F6E53656C65637465643A66756E6374696F6E28297B76617220613B72657475726E20746869732E6F7074732E706C6163';
wwv_flow_api.g_varchar2_table(420) := '65686F6C6465723F28613D746869732E676574506C616365686F6C6465724F7074696F6E282929213D3D622626612E697328223A73656C656374656422297C7C22223D3D3D746869732E6F7074732E656C656D656E742E76616C28297C7C746869732E6F';
wwv_flow_api.g_varchar2_table(421) := '7074732E656C656D656E742E76616C28293D3D3D627C7C6E756C6C3D3D3D746869732E6F7074732E656C656D656E742E76616C28293A21317D2C707265706172654F7074733A66756E6374696F6E28297B76617220623D746869732E706172656E742E70';
wwv_flow_api.g_varchar2_table(422) := '7265706172654F7074732E6170706C7928746869732C617267756D656E7473292C633D746869733B72657475726E2273656C656374223D3D3D622E656C656D656E742E6765742830292E7461674E616D652E746F4C6F7765724361736528293F622E696E';
wwv_flow_api.g_varchar2_table(423) := '697453656C656374696F6E3D66756E6374696F6E28612C62297B76617220643D612E66696E6428223A73656C656374656422293B6228632E6F7074696F6E546F44617461286429297D3A226461746122696E2062262628622E696E697453656C65637469';
wwv_flow_api.g_varchar2_table(424) := '6F6E3D622E696E697453656C656374696F6E7C7C66756E6374696F6E28632C64297B76617220653D632E76616C28292C663D6E756C6C3B622E7175657279287B6D6174636865723A66756E6374696F6E28612C632C64297B76617220673D7128652C622E';
wwv_flow_api.g_varchar2_table(425) := '6964286429293B72657475726E2067262628663D64292C677D2C63616C6C6261636B3A612E697346756E6374696F6E2864293F66756E6374696F6E28297B642866297D3A612E6E6F6F707D297D292C627D2C676574506C616365686F6C6465723A66756E';
wwv_flow_api.g_varchar2_table(426) := '6374696F6E28297B72657475726E20746869732E73656C6563742626746869732E676574506C616365686F6C6465724F7074696F6E28293D3D3D623F623A746869732E706172656E742E676574506C616365686F6C6465722E6170706C7928746869732C';
wwv_flow_api.g_varchar2_table(427) := '617267756D656E7473297D2C736574506C616365686F6C6465723A66756E6374696F6E28297B76617220613D746869732E676574506C616365686F6C64657228293B696628746869732E6973506C616365686F6C6465724F7074696F6E53656C65637465';
wwv_flow_api.g_varchar2_table(428) := '642829262661213D3D62297B696628746869732E73656C6563742626746869732E676574506C616365686F6C6465724F7074696F6E28293D3D3D622972657475726E3B746869732E73656C656374696F6E2E66696E6428222E73656C656374322D63686F';
wwv_flow_api.g_varchar2_table(429) := '73656E22292E68746D6C28746869732E6F7074732E6573636170654D61726B7570286129292C746869732E73656C656374696F6E2E616464436C617373282273656C656374322D64656661756C7422292C746869732E636F6E7461696E65722E72656D6F';
wwv_flow_api.g_varchar2_table(430) := '7665436C617373282273656C656374322D616C6C6F77636C65617222297D7D2C706F737470726F63657373526573756C74733A66756E6374696F6E28612C622C63297B76617220643D302C653D746869733B696628746869732E66696E64486967686C69';
wwv_flow_api.g_varchar2_table(431) := '67687461626C6543686F6963657328292E65616368322866756E6374696F6E28612C62297B72657475726E207128652E696428622E64617461282273656C656374322D646174612229292C652E6F7074732E656C656D656E742E76616C2829293F28643D';
wwv_flow_api.g_varchar2_table(432) := '612C2131293A766F696420307D292C63213D3D2131262628623D3D3D21302626643E3D303F746869732E686967686C696768742864293A746869732E686967686C69676874283029292C623D3D3D2130297B76617220673D746869732E6F7074732E6D69';
wwv_flow_api.g_varchar2_table(433) := '6E696D756D526573756C7473466F725365617263683B673E3D302626746869732E73686F77536561726368284C28612E726573756C7473293E3D67297D7D2C73686F775365617263683A66756E6374696F6E2862297B746869732E73686F775365617263';
wwv_flow_api.g_varchar2_table(434) := '68496E707574213D3D62262628746869732E73686F77536561726368496E7075743D622C746869732E64726F70646F776E2E66696E6428222E73656C656374322D73656172636822292E746F67676C65436C617373282273656C656374322D7365617263';
wwv_flow_api.g_varchar2_table(435) := '682D68696464656E222C2162292C746869732E64726F70646F776E2E66696E6428222E73656C656374322D73656172636822292E746F67676C65436C617373282273656C656374322D6F666673637265656E222C2162292C6128746869732E64726F7064';
wwv_flow_api.g_varchar2_table(436) := '6F776E2C746869732E636F6E7461696E6572292E746F67676C65436C617373282273656C656374322D776974682D736561726368626F78222C6229297D2C6F6E53656C6563743A66756E6374696F6E28612C62297B696628746869732E74726967676572';
wwv_flow_api.g_varchar2_table(437) := '53656C656374286129297B76617220633D746869732E6F7074732E656C656D656E742E76616C28292C643D746869732E6461746128293B746869732E6F7074732E656C656D656E742E76616C28746869732E6964286129292C746869732E757064617465';
wwv_flow_api.g_varchar2_table(438) := '53656C656374696F6E2861292C746869732E6F7074732E656C656D656E742E74726967676572287B747970653A2273656C656374322D73656C6563746564222C76616C3A746869732E69642861292C63686F6963653A617D292C746869732E6E65787453';
wwv_flow_api.g_varchar2_table(439) := '65617263685465726D3D746869732E6F7074732E6E6578745365617263685465726D28612C746869732E7365617263682E76616C2829292C746869732E636C6F736528292C622626622E6E6F466F6375737C7C746869732E73656C656374696F6E2E666F';
wwv_flow_api.g_varchar2_table(440) := '63757328292C7128632C746869732E6964286129297C7C746869732E747269676765724368616E6765287B61646465643A612C72656D6F7665643A647D297D7D2C75706461746553656C656374696F6E3A66756E6374696F6E2861297B76617220642C65';
wwv_flow_api.g_varchar2_table(441) := '2C633D746869732E73656C656374696F6E2E66696E6428222E73656C656374322D63686F73656E22293B746869732E73656C656374696F6E2E64617461282273656C656374322D64617461222C61292C632E656D70747928292C6E756C6C213D3D612626';
wwv_flow_api.g_varchar2_table(442) := '28643D746869732E6F7074732E666F726D617453656C656374696F6E28612C632C746869732E6F7074732E6573636170654D61726B757029292C64213D3D622626632E617070656E642864292C653D746869732E6F7074732E666F726D617453656C6563';
wwv_flow_api.g_varchar2_table(443) := '74696F6E437373436C61737328612C63292C65213D3D622626632E616464436C6173732865292C746869732E73656C656374696F6E2E72656D6F7665436C617373282273656C656374322D64656661756C7422292C746869732E6F7074732E616C6C6F77';
wwv_flow_api.g_varchar2_table(444) := '436C6561722626746869732E676574506C616365686F6C6465722829213D3D622626746869732E636F6E7461696E65722E616464436C617373282273656C656374322D616C6C6F77636C65617222297D2C76616C3A66756E6374696F6E28297B76617220';
wwv_flow_api.g_varchar2_table(445) := '612C633D21312C643D6E756C6C2C653D746869732C663D746869732E6461746128293B696628303D3D3D617267756D656E74732E6C656E6774682972657475726E20746869732E6F7074732E656C656D656E742E76616C28293B696628613D617267756D';
wwv_flow_api.g_varchar2_table(446) := '656E74735B305D2C617267756D656E74732E6C656E6774683E31262628633D617267756D656E74735B315D292C746869732E73656C65637429746869732E73656C6563742E76616C2861292E66696E6428223A73656C656374656422292E656163683228';
wwv_flow_api.g_varchar2_table(447) := '66756E6374696F6E28612C62297B72657475726E20643D652E6F7074696F6E546F446174612862292C21317D292C746869732E75706461746553656C656374696F6E2864292C746869732E736574506C616365686F6C64657228292C632626746869732E';
wwv_flow_api.g_varchar2_table(448) := '747269676765724368616E6765287B61646465643A642C72656D6F7665643A667D293B656C73657B6966282161262630213D3D612972657475726E20746869732E636C6561722863292C766F696420303B696628746869732E6F7074732E696E69745365';
wwv_flow_api.g_varchar2_table(449) := '6C656374696F6E3D3D3D62297468726F77206E6577204572726F72282263616E6E6F742063616C6C2076616C282920696620696E697453656C656374696F6E2829206973206E6F7420646566696E656422293B746869732E6F7074732E656C656D656E74';
wwv_flow_api.g_varchar2_table(450) := '2E76616C2861292C746869732E6F7074732E696E697453656C656374696F6E28746869732E6F7074732E656C656D656E742C66756E6374696F6E2861297B652E6F7074732E656C656D656E742E76616C28613F652E69642861293A2222292C652E757064';
wwv_flow_api.g_varchar2_table(451) := '61746553656C656374696F6E2861292C652E736574506C616365686F6C64657228292C632626652E747269676765724368616E6765287B61646465643A612C72656D6F7665643A667D297D297D7D2C636C6561725365617263683A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(452) := '297B746869732E7365617263682E76616C282222292C746869732E666F6375737365722E76616C282222297D2C646174613A66756E6374696F6E2861297B76617220632C643D21313B72657475726E20303D3D3D617267756D656E74732E6C656E677468';
wwv_flow_api.g_varchar2_table(453) := '3F28633D746869732E73656C656374696F6E2E64617461282273656C656374322D6461746122292C633D3D62262628633D6E756C6C292C63293A28617267756D656E74732E6C656E6774683E31262628643D617267756D656E74735B315D292C613F2863';
wwv_flow_api.g_varchar2_table(454) := '3D746869732E6461746128292C746869732E6F7074732E656C656D656E742E76616C28613F746869732E69642861293A2222292C746869732E75706461746553656C656374696F6E2861292C642626746869732E747269676765724368616E6765287B61';
wwv_flow_api.g_varchar2_table(455) := '646465643A612C72656D6F7665643A637D29293A746869732E636C6561722864292C766F69642030297D7D292C663D4E28642C7B637265617465436F6E7461696E65723A66756E6374696F6E28297B76617220623D6128646F63756D656E742E63726561';
wwv_flow_api.g_varchar2_table(456) := '7465456C656D656E7428226469762229292E61747472287B22636C617373223A2273656C656374322D636F6E7461696E65722073656C656374322D636F6E7461696E65722D6D756C7469227D292E68746D6C285B223C756C20636C6173733D2773656C65';
wwv_flow_api.g_varchar2_table(457) := '6374322D63686F69636573273E222C2220203C6C6920636C6173733D2773656C656374322D7365617263682D6669656C64273E222C22202020203C696E70757420747970653D277465787427206175746F636F6D706C6574653D276F666627206175746F';
wwv_flow_api.g_varchar2_table(458) := '636F72726563743D276F666627206175746F6361706974616C697A653D276F666627207370656C6C636865636B3D2766616C73652720636C6173733D2773656C656374322D696E707574273E222C2220203C2F6C693E222C223C2F756C3E222C223C6469';
wwv_flow_api.g_varchar2_table(459) := '7620636C6173733D2773656C656374322D64726F702073656C656374322D64726F702D6D756C74692073656C656374322D646973706C61792D6E6F6E65273E222C222020203C756C20636C6173733D2773656C656374322D726573756C7473273E222C22';
wwv_flow_api.g_varchar2_table(460) := '2020203C2F756C3E222C223C2F6469763E225D2E6A6F696E28222229293B72657475726E20627D2C707265706172654F7074733A66756E6374696F6E28297B76617220623D746869732E706172656E742E707265706172654F7074732E6170706C792874';
wwv_flow_api.g_varchar2_table(461) := '6869732C617267756D656E7473292C633D746869733B72657475726E2273656C656374223D3D3D622E656C656D656E742E6765742830292E7461674E616D652E746F4C6F7765724361736528293F622E696E697453656C656374696F6E3D66756E637469';
wwv_flow_api.g_varchar2_table(462) := '6F6E28612C62297B76617220643D5B5D3B612E66696E6428223A73656C656374656422292E65616368322866756E6374696F6E28612C62297B642E7075736828632E6F7074696F6E546F44617461286229297D292C622864297D3A226461746122696E20';
wwv_flow_api.g_varchar2_table(463) := '62262628622E696E697453656C656374696F6E3D622E696E697453656C656374696F6E7C7C66756E6374696F6E28632C64297B76617220653D7228632E76616C28292C622E736570617261746F72292C663D5B5D3B622E7175657279287B6D6174636865';
wwv_flow_api.g_varchar2_table(464) := '723A66756E6374696F6E28632C642C67297B76617220683D612E6772657028652C66756E6374696F6E2861297B72657475726E207128612C622E6964286729297D292E6C656E6774683B72657475726E20682626662E707573682867292C687D2C63616C';
wwv_flow_api.g_varchar2_table(465) := '6C6261636B3A612E697346756E6374696F6E2864293F66756E6374696F6E28297B666F722876617220613D5B5D2C633D303B633C652E6C656E6774683B632B2B29666F722876617220673D655B635D2C683D303B683C662E6C656E6774683B682B2B297B';
wwv_flow_api.g_varchar2_table(466) := '76617220693D665B685D3B6966287128672C622E696428692929297B612E707573682869292C662E73706C69636528682C31293B627265616B7D7D642861297D3A612E6E6F6F707D297D292C627D2C73656C65637443686F6963653A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(467) := '2861297B76617220623D746869732E636F6E7461696E65722E66696E6428222E73656C656374322D7365617263682D63686F6963652D666F63757322293B622E6C656E6774682626612626615B305D3D3D625B305D7C7C28622E6C656E67746826267468';
wwv_flow_api.g_varchar2_table(468) := '69732E6F7074732E656C656D656E742E74726967676572282263686F6963652D646573656C6563746564222C62292C622E72656D6F7665436C617373282273656C656374322D7365617263682D63686F6963652D666F63757322292C612626612E6C656E';
wwv_flow_api.g_varchar2_table(469) := '677468262628746869732E636C6F736528292C612E616464436C617373282273656C656374322D7365617263682D63686F6963652D666F63757322292C746869732E6F7074732E656C656D656E742E74726967676572282263686F6963652D73656C6563';
wwv_flow_api.g_varchar2_table(470) := '746564222C612929297D2C64657374726F793A66756E6374696F6E28297B6128226C6162656C5B666F723D27222B746869732E7365617263682E617474722822696422292B22275D22292E617474722822666F72222C746869732E6F7074732E656C656D';
wwv_flow_api.g_varchar2_table(471) := '656E742E61747472282269642229292C746869732E706172656E742E64657374726F792E6170706C7928746869732C617267756D656E7473297D2C696E6974436F6E7461696E65723A66756E6374696F6E28297B76617220642C623D222E73656C656374';
wwv_flow_api.g_varchar2_table(472) := '322D63686F69636573223B746869732E736561726368436F6E7461696E65723D746869732E636F6E7461696E65722E66696E6428222E73656C656374322D7365617263682D6669656C6422292C746869732E73656C656374696F6E3D643D746869732E63';
wwv_flow_api.g_varchar2_table(473) := '6F6E7461696E65722E66696E642862293B76617220653D746869733B746869732E73656C656374696F6E2E6F6E2822636C69636B222C222E73656C656374322D7365617263682D63686F696365222C66756E6374696F6E28297B652E7365617263685B30';
wwv_flow_api.g_varchar2_table(474) := '5D2E666F63757328292C652E73656C65637443686F6963652861287468697329297D292C746869732E7365617263682E6174747228226964222C22733269645F6175746F67656E222B672829292C6128226C6162656C5B666F723D27222B746869732E6F';
wwv_flow_api.g_varchar2_table(475) := '7074732E656C656D656E742E617474722822696422292B22275D22292E617474722822666F72222C746869732E7365617263682E61747472282269642229292C746869732E7365617263682E6F6E2822696E707574207061737465222C746869732E6269';
wwv_flow_api.g_varchar2_table(476) := '6E642866756E6374696F6E28297B746869732E6973496E74657266616365456E61626C65642829262628746869732E6F70656E656428297C7C746869732E6F70656E2829297D29292C746869732E7365617263682E617474722822746162696E64657822';
wwv_flow_api.g_varchar2_table(477) := '2C746869732E656C656D656E74546162496E646578292C746869732E6B6579646F776E733D302C746869732E7365617263682E6F6E28226B6579646F776E222C746869732E62696E642866756E6374696F6E2861297B696628746869732E6973496E7465';
wwv_flow_api.g_varchar2_table(478) := '7266616365456E61626C65642829297B2B2B746869732E6B6579646F776E733B76617220623D642E66696E6428222E73656C656374322D7365617263682D63686F6963652D666F63757322292C653D622E7072657628222E73656C656374322D73656172';
wwv_flow_api.g_varchar2_table(479) := '63682D63686F6963653A6E6F74282E73656C656374322D6C6F636B65642922292C663D622E6E65787428222E73656C656374322D7365617263682D63686F6963653A6E6F74282E73656C656374322D6C6F636B65642922292C673D7A28746869732E7365';
wwv_flow_api.g_varchar2_table(480) := '61726368293B696628622E6C656E677468262628612E77686963683D3D632E4C4546547C7C612E77686963683D3D632E52494748547C7C612E77686963683D3D632E4241434B53504143457C7C612E77686963683D3D632E44454C4554457C7C612E7768';
wwv_flow_api.g_varchar2_table(481) := '6963683D3D632E454E54455229297B76617220683D623B72657475726E20612E77686963683D3D632E4C4546542626652E6C656E6774683F683D653A612E77686963683D3D632E52494748543F683D662E6C656E6774683F663A6E756C6C3A612E776869';
wwv_flow_api.g_varchar2_table(482) := '63683D3D3D632E4241434B53504143453F28746869732E756E73656C65637428622E66697273742829292C746869732E7365617263682E7769647468283130292C683D652E6C656E6774683F653A66293A612E77686963683D3D632E44454C4554453F28';
wwv_flow_api.g_varchar2_table(483) := '746869732E756E73656C65637428622E66697273742829292C746869732E7365617263682E7769647468283130292C683D662E6C656E6774683F663A6E756C6C293A612E77686963683D3D632E454E544552262628683D6E756C6C292C746869732E7365';
wwv_flow_api.g_varchar2_table(484) := '6C65637443686F6963652868292C412861292C682626682E6C656E6774687C7C746869732E6F70656E28292C766F696420307D69662828612E77686963683D3D3D632E4241434B53504143452626313D3D746869732E6B6579646F776E737C7C612E7768';
wwv_flow_api.g_varchar2_table(485) := '6963683D3D632E4C454654292626303D3D672E6F6666736574262621672E6C656E6774682972657475726E20746869732E73656C65637443686F69636528642E66696E6428222E73656C656374322D7365617263682D63686F6963653A6E6F74282E7365';
wwv_flow_api.g_varchar2_table(486) := '6C656374322D6C6F636B65642922292E6C6173742829292C412861292C766F696420303B696628746869732E73656C65637443686F696365286E756C6C292C746869732E6F70656E656428292973776974636828612E7768696368297B6361736520632E';
wwv_flow_api.g_varchar2_table(487) := '55503A6361736520632E444F574E3A72657475726E20746869732E6D6F7665486967686C6967687428612E77686963683D3D3D632E55503F2D313A31292C412861292C766F696420303B6361736520632E454E5445523A72657475726E20746869732E73';
wwv_flow_api.g_varchar2_table(488) := '656C656374486967686C69676874656428292C412861292C766F696420303B6361736520632E5441423A72657475726E20746869732E6F7074732E73656C6563744F6E426C75722626746869732E73656C656374486967686C696768746564287B6E6F46';
wwv_flow_api.g_varchar2_table(489) := '6F6375733A21307D292C746869732E636C6F736528292C766F696420303B6361736520632E4553433A72657475726E20746869732E63616E63656C2861292C412861292C766F696420307D696628612E7768696368213D3D632E544142262621632E6973';
wwv_flow_api.g_varchar2_table(490) := '436F6E74726F6C286129262621632E697346756E6374696F6E4B65792861292626612E7768696368213D3D632E4241434B53504143452626612E7768696368213D3D632E455343297B696628612E77686963683D3D3D632E454E544552297B6966287468';
wwv_flow_api.g_varchar2_table(491) := '69732E6F7074732E6F70656E4F6E456E7465723D3D3D21312972657475726E3B696628612E616C744B65797C7C612E6374726C4B65797C7C612E73686966744B65797C7C612E6D6574614B65792972657475726E7D746869732E6F70656E28292C28612E';
wwv_flow_api.g_varchar2_table(492) := '77686963683D3D3D632E504147455F55507C7C612E77686963683D3D3D632E504147455F444F574E292626412861292C612E77686963683D3D3D632E454E5445522626412861297D7D7D29292C746869732E7365617263682E6F6E28226B65797570222C';
wwv_flow_api.g_varchar2_table(493) := '746869732E62696E642866756E6374696F6E28297B746869732E6B6579646F776E733D302C746869732E726573697A6553656172636828297D29292C746869732E7365617263682E6F6E2822626C7572222C746869732E62696E642866756E6374696F6E';
wwv_flow_api.g_varchar2_table(494) := '2862297B746869732E636F6E7461696E65722E72656D6F7665436C617373282273656C656374322D636F6E7461696E65722D61637469766522292C746869732E7365617263682E72656D6F7665436C617373282273656C656374322D666F637573656422';
wwv_flow_api.g_varchar2_table(495) := '292C746869732E73656C65637443686F696365286E756C6C292C746869732E6F70656E656428297C7C746869732E636C65617253656172636828292C622E73746F70496D6D65646961746550726F7061676174696F6E28292C746869732E6F7074732E65';
wwv_flow_api.g_varchar2_table(496) := '6C656D656E742E7472696767657228612E4576656E74282273656C656374322D626C75722229297D29292C746869732E636F6E7461696E65722E6F6E2822636C69636B222C622C746869732E62696E642866756E6374696F6E2862297B746869732E6973';
wwv_flow_api.g_varchar2_table(497) := '496E74657266616365456E61626C656428292626286128622E746172676574292E636C6F7365737428222E73656C656374322D7365617263682D63686F69636522292E6C656E6774683E307C7C28746869732E73656C65637443686F696365286E756C6C';
wwv_flow_api.g_varchar2_table(498) := '292C746869732E636C656172506C616365686F6C64657228292C746869732E636F6E7461696E65722E686173436C617373282273656C656374322D636F6E7461696E65722D61637469766522297C7C746869732E6F7074732E656C656D656E742E747269';
wwv_flow_api.g_varchar2_table(499) := '6767657228612E4576656E74282273656C656374322D666F6375732229292C746869732E6F70656E28292C746869732E666F63757353656172636828292C622E70726576656E7444656661756C74282929297D29292C746869732E636F6E7461696E6572';
wwv_flow_api.g_varchar2_table(500) := '2E6F6E2822666F637573222C622C746869732E62696E642866756E6374696F6E28297B746869732E6973496E74657266616365456E61626C65642829262628746869732E636F6E7461696E65722E686173436C617373282273656C656374322D636F6E74';
wwv_flow_api.g_varchar2_table(501) := '61696E65722D61637469766522297C7C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D666F6375732229292C746869732E636F6E7461696E65722E616464436C617373282273656C65637432';
wwv_flow_api.g_varchar2_table(502) := '2D636F6E7461696E65722D61637469766522292C746869732E64726F70646F776E2E616464436C617373282273656C656374322D64726F702D61637469766522292C746869732E636C656172506C616365686F6C6465722829297D29292C746869732E69';
wwv_flow_api.g_varchar2_table(503) := '6E6974436F6E7461696E6572576964746828292C746869732E6F7074732E656C656D656E742E616464436C617373282273656C656374322D6F666673637265656E22292C746869732E636C65617253656172636828297D2C656E61626C65496E74657266';
wwv_flow_api.g_varchar2_table(504) := '6163653A66756E6374696F6E28297B746869732E706172656E742E656E61626C65496E746572666163652E6170706C7928746869732C617267756D656E7473292626746869732E7365617263682E70726F70282264697361626C6564222C21746869732E';
wwv_flow_api.g_varchar2_table(505) := '6973496E74657266616365456E61626C65642829297D2C696E697453656C656374696F6E3A66756E6374696F6E28297B69662822223D3D3D746869732E6F7074732E656C656D656E742E76616C2829262622223D3D3D746869732E6F7074732E656C656D';
wwv_flow_api.g_varchar2_table(506) := '656E742E746578742829262628746869732E75706461746553656C656374696F6E285B5D292C746869732E636C6F736528292C746869732E636C6561725365617263682829292C746869732E73656C6563747C7C2222213D3D746869732E6F7074732E65';
wwv_flow_api.g_varchar2_table(507) := '6C656D656E742E76616C2829297B76617220633D746869733B746869732E6F7074732E696E697453656C656374696F6E2E63616C6C286E756C6C2C746869732E6F7074732E656C656D656E742C66756E6374696F6E2861297B61213D3D6226266E756C6C';
wwv_flow_api.g_varchar2_table(508) := '213D3D61262628632E75706461746553656C656374696F6E2861292C632E636C6F736528292C632E636C6561725365617263682829297D297D7D2C636C6561725365617263683A66756E6374696F6E28297B76617220613D746869732E676574506C6163';
wwv_flow_api.g_varchar2_table(509) := '65686F6C64657228292C633D746869732E6765744D6178536561726368576964746828293B61213D3D622626303D3D3D746869732E67657456616C28292E6C656E6774682626746869732E7365617263682E686173436C617373282273656C656374322D';
wwv_flow_api.g_varchar2_table(510) := '666F637573656422293D3D3D21313F28746869732E7365617263682E76616C2861292E616464436C617373282273656C656374322D64656661756C7422292C746869732E7365617263682E776964746828633E303F633A746869732E636F6E7461696E65';
wwv_flow_api.g_varchar2_table(511) := '722E63737328227769647468222929293A746869732E7365617263682E76616C282222292E7769647468283130297D2C636C656172506C616365686F6C6465723A66756E6374696F6E28297B746869732E7365617263682E686173436C61737328227365';
wwv_flow_api.g_varchar2_table(512) := '6C656374322D64656661756C7422292626746869732E7365617263682E76616C282222292E72656D6F7665436C617373282273656C656374322D64656661756C7422297D2C6F70656E696E673A66756E6374696F6E28297B746869732E636C656172506C';
wwv_flow_api.g_varchar2_table(513) := '616365686F6C64657228292C746869732E726573697A6553656172636828292C746869732E706172656E742E6F70656E696E672E6170706C7928746869732C617267756D656E7473292C746869732E666F63757353656172636828292C746869732E7570';
wwv_flow_api.g_varchar2_table(514) := '64617465526573756C7473282130292C746869732E7365617263682E666F63757328292C746869732E6F7074732E656C656D656E742E7472696767657228612E4576656E74282273656C656374322D6F70656E2229297D2C636C6F73653A66756E637469';
wwv_flow_api.g_varchar2_table(515) := '6F6E28297B746869732E6F70656E656428292626746869732E706172656E742E636C6F73652E6170706C7928746869732C617267756D656E7473297D2C666F6375733A66756E6374696F6E28297B746869732E636C6F736528292C746869732E73656172';
wwv_flow_api.g_varchar2_table(516) := '63682E666F63757328297D2C6973466F63757365643A66756E6374696F6E28297B72657475726E20746869732E7365617263682E686173436C617373282273656C656374322D666F637573656422297D2C75706461746553656C656374696F6E3A66756E';
wwv_flow_api.g_varchar2_table(517) := '6374696F6E2862297B76617220633D5B5D2C643D5B5D2C653D746869733B612862292E656163682866756E6374696F6E28297B6F28652E69642874686973292C63293C30262628632E7075736828652E6964287468697329292C642E7075736828746869';
wwv_flow_api.g_varchar2_table(518) := '7329297D292C623D642C746869732E73656C656374696F6E2E66696E6428222E73656C656374322D7365617263682D63686F69636522292E72656D6F766528292C612862292E656163682866756E6374696F6E28297B652E61646453656C656374656443';
wwv_flow_api.g_varchar2_table(519) := '686F6963652874686973297D292C652E706F737470726F63657373526573756C747328297D2C746F6B656E697A653A66756E6374696F6E28297B76617220613D746869732E7365617263682E76616C28293B613D746869732E6F7074732E746F6B656E69';
wwv_flow_api.g_varchar2_table(520) := '7A65722E63616C6C28746869732C612C746869732E6461746128292C746869732E62696E6428746869732E6F6E53656C656374292C746869732E6F707473292C6E756C6C213D61262661213D62262628746869732E7365617263682E76616C2861292C61';
wwv_flow_api.g_varchar2_table(521) := '2E6C656E6774683E302626746869732E6F70656E2829297D2C6F6E53656C6563743A66756E6374696F6E28612C62297B746869732E7472696767657253656C656374286129262628746869732E61646453656C656374656443686F6963652861292C7468';
wwv_flow_api.g_varchar2_table(522) := '69732E6F7074732E656C656D656E742E74726967676572287B747970653A2273656C6563746564222C76616C3A746869732E69642861292C63686F6963653A617D292C28746869732E73656C6563747C7C21746869732E6F7074732E636C6F73654F6E53';
wwv_flow_api.g_varchar2_table(523) := '656C656374292626746869732E706F737470726F63657373526573756C747328612C21312C746869732E6F7074732E636C6F73654F6E53656C6563743D3D3D2130292C746869732E6F7074732E636C6F73654F6E53656C6563743F28746869732E636C6F';
wwv_flow_api.g_varchar2_table(524) := '736528292C746869732E7365617263682E776964746828313029293A746869732E636F756E7453656C65637461626C65526573756C747328293E303F28746869732E7365617263682E7769647468283130292C746869732E726573697A65536561726368';
wwv_flow_api.g_varchar2_table(525) := '28292C746869732E6765744D6178696D756D53656C656374696F6E53697A6528293E302626746869732E76616C28292E6C656E6774683E3D746869732E6765744D6178696D756D53656C656374696F6E53697A6528292626746869732E75706461746552';
wwv_flow_api.g_varchar2_table(526) := '6573756C7473282130292C746869732E706F736974696F6E44726F70646F776E2829293A28746869732E636C6F736528292C746869732E7365617263682E776964746828313029292C746869732E747269676765724368616E6765287B61646465643A61';
wwv_flow_api.g_varchar2_table(527) := '7D292C622626622E6E6F466F6375737C7C746869732E666F6375735365617263682829297D2C63616E63656C3A66756E6374696F6E28297B746869732E636C6F736528292C746869732E666F63757353656172636828297D2C61646453656C6563746564';
wwv_flow_api.g_varchar2_table(528) := '43686F6963653A66756E6374696F6E2863297B766172206A2C6B2C643D21632E6C6F636B65642C653D6128223C6C6920636C6173733D2773656C656374322D7365617263682D63686F696365273E202020203C6469763E3C2F6469763E202020203C6120';
wwv_flow_api.g_varchar2_table(529) := '687265663D272327206F6E636C69636B3D2772657475726E2066616C73653B2720636C6173733D2773656C656374322D7365617263682D63686F6963652D636C6F73652720746162696E6465783D272D31273E3C2F613E3C2F6C693E22292C663D612822';
wwv_flow_api.g_varchar2_table(530) := '3C6C6920636C6173733D2773656C656374322D7365617263682D63686F6963652073656C656374322D6C6F636B6564273E3C6469763E3C2F6469763E3C2F6C693E22292C673D643F653A662C683D746869732E69642863292C693D746869732E67657456';
wwv_flow_api.g_varchar2_table(531) := '616C28293B6A3D746869732E6F7074732E666F726D617453656C656374696F6E28632C672E66696E64282264697622292C746869732E6F7074732E6573636170654D61726B7570292C6A213D622626672E66696E64282264697622292E7265706C616365';
wwv_flow_api.g_varchar2_table(532) := '5769746828223C6469763E222B6A2B223C2F6469763E22292C6B3D746869732E6F7074732E666F726D617453656C656374696F6E437373436C61737328632C672E66696E6428226469762229292C6B213D622626672E616464436C617373286B292C6426';
wwv_flow_api.g_varchar2_table(533) := '26672E66696E6428222E73656C656374322D7365617263682D63686F6963652D636C6F736522292E6F6E28226D6F757365646F776E222C41292E6F6E2822636C69636B2064626C636C69636B222C746869732E62696E642866756E6374696F6E2862297B';
wwv_flow_api.g_varchar2_table(534) := '746869732E6973496E74657266616365456E61626C656428292626286128622E746172676574292E636C6F7365737428222E73656C656374322D7365617263682D63686F69636522292E666164654F7574282266617374222C746869732E62696E642866';
wwv_flow_api.g_varchar2_table(535) := '756E6374696F6E28297B746869732E756E73656C656374286128622E74617267657429292C746869732E73656C656374696F6E2E66696E6428222E73656C656374322D7365617263682D63686F6963652D666F63757322292E72656D6F7665436C617373';
wwv_flow_api.g_varchar2_table(536) := '282273656C656374322D7365617263682D63686F6963652D666F63757322292C746869732E636C6F736528292C746869732E666F63757353656172636828297D29292E6465717565756528292C41286229297D29292E6F6E2822666F637573222C746869';
wwv_flow_api.g_varchar2_table(537) := '732E62696E642866756E6374696F6E28297B746869732E6973496E74657266616365456E61626C65642829262628746869732E636F6E7461696E65722E616464436C617373282273656C656374322D636F6E7461696E65722D61637469766522292C7468';
wwv_flow_api.g_varchar2_table(538) := '69732E64726F70646F776E2E616464436C617373282273656C656374322D64726F702D6163746976652229297D29292C672E64617461282273656C656374322D64617461222C63292C672E696E736572744265666F726528746869732E73656172636843';
wwv_flow_api.g_varchar2_table(539) := '6F6E7461696E6572292C692E707573682868292C746869732E73657456616C2869297D2C756E73656C6563743A66756E6374696F6E2861297B76617220632C642C623D746869732E67657456616C28293B696628613D612E636C6F7365737428222E7365';
wwv_flow_api.g_varchar2_table(540) := '6C656374322D7365617263682D63686F69636522292C303D3D3D612E6C656E677468297468726F7722496E76616C696420617267756D656E743A20222B612B222E204D757374206265202E73656C656374322D7365617263682D63686F696365223B633D';
wwv_flow_api.g_varchar2_table(541) := '612E64617461282273656C656374322D6461746122292C63262628643D6F28746869732E69642863292C62292C643E3D30262628622E73706C69636528642C31292C746869732E73657456616C2862292C746869732E73656C6563742626746869732E70';
wwv_flow_api.g_varchar2_table(542) := '6F737470726F63657373526573756C74732829292C612E72656D6F766528292C746869732E6F7074732E656C656D656E742E74726967676572287B747970653A2272656D6F766564222C76616C3A746869732E69642863292C63686F6963653A637D292C';
wwv_flow_api.g_varchar2_table(543) := '746869732E747269676765724368616E6765287B72656D6F7665643A637D29297D2C706F737470726F63657373526573756C74733A66756E6374696F6E28612C622C63297B76617220643D746869732E67657456616C28292C653D746869732E72657375';
wwv_flow_api.g_varchar2_table(544) := '6C74732E66696E6428222E73656C656374322D726573756C7422292C663D746869732E726573756C74732E66696E6428222E73656C656374322D726573756C742D776974682D6368696C6472656E22292C673D746869733B652E65616368322866756E63';
wwv_flow_api.g_varchar2_table(545) := '74696F6E28612C62297B76617220633D672E696428622E64617461282273656C656374322D646174612229293B6F28632C64293E3D30262628622E616464436C617373282273656C656374322D73656C656374656422292C622E66696E6428222E73656C';
wwv_flow_api.g_varchar2_table(546) := '656374322D726573756C742D73656C65637461626C6522292E616464436C617373282273656C656374322D73656C65637465642229297D292C662E65616368322866756E6374696F6E28612C62297B622E697328222E73656C656374322D726573756C74';
wwv_flow_api.g_varchar2_table(547) := '2D73656C65637461626C6522297C7C30213D3D622E66696E6428222E73656C656374322D726573756C742D73656C65637461626C653A6E6F74282E73656C656374322D73656C65637465642922292E6C656E6774687C7C622E616464436C617373282273';
wwv_flow_api.g_varchar2_table(548) := '656C656374322D73656C656374656422297D292C2D313D3D746869732E686967686C696768742829262663213D3D21312626672E686967686C696768742830292C21746869732E6F7074732E63726561746553656172636843686F696365262621652E66';
wwv_flow_api.g_varchar2_table(549) := '696C74657228222E73656C656374322D726573756C743A6E6F74282E73656C656374322D73656C65637465642922292E6C656E6774683E3026262821617C7C61262621612E6D6F72652626303D3D3D746869732E726573756C74732E66696E6428222E73';
wwv_flow_api.g_varchar2_table(550) := '656C656374322D6E6F2D726573756C747322292E6C656E6774682926264A28672E6F7074732E666F726D61744E6F4D6174636865732C22666F726D61744E6F4D61746368657322292626746869732E726573756C74732E617070656E6428223C6C692063';
wwv_flow_api.g_varchar2_table(551) := '6C6173733D2773656C656374322D6E6F2D726573756C7473273E222B672E6F7074732E666F726D61744E6F4D61746368657328672E7365617263682E76616C2829292B223C2F6C693E22297D2C6765744D617853656172636857696474683A66756E6374';
wwv_flow_api.g_varchar2_table(552) := '696F6E28297B72657475726E20746869732E73656C656374696F6E2E776964746828292D7328746869732E736561726368297D2C726573697A655365617263683A66756E6374696F6E28297B76617220612C622C632C642C652C663D7328746869732E73';
wwv_flow_api.g_varchar2_table(553) := '6561726368293B613D4328746869732E736561726368292B31302C623D746869732E7365617263682E6F666673657428292E6C6566742C633D746869732E73656C656374696F6E2E776964746828292C643D746869732E73656C656374696F6E2E6F6666';
wwv_flow_api.g_varchar2_table(554) := '73657428292E6C6566742C653D632D28622D64292D662C613E65262628653D632D66292C34303E65262628653D632D66292C303E3D65262628653D61292C746869732E7365617263682E77696474682865297D2C67657456616C3A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(555) := '297B76617220613B72657475726E20746869732E73656C6563743F28613D746869732E73656C6563742E76616C28292C6E756C6C3D3D3D613F5B5D3A61293A28613D746869732E6F7074732E656C656D656E742E76616C28292C7228612C746869732E6F';
wwv_flow_api.g_varchar2_table(556) := '7074732E736570617261746F7229297D2C73657456616C3A66756E6374696F6E2862297B76617220633B746869732E73656C6563743F746869732E73656C6563742E76616C2862293A28633D5B5D2C612862292E656163682866756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(557) := '6F28746869732C63293C302626632E707573682874686973297D292C746869732E6F7074732E656C656D656E742E76616C28303D3D3D632E6C656E6774683F22223A632E6A6F696E28746869732E6F7074732E736570617261746F722929297D2C627569';
wwv_flow_api.g_varchar2_table(558) := '6C644368616E676544657461696C733A66756E6374696F6E28612C62297B666F722876617220623D622E736C6963652830292C613D612E736C6963652830292C633D303B633C622E6C656E6774683B632B2B29666F722876617220643D303B643C612E6C';
wwv_flow_api.g_varchar2_table(559) := '656E6774683B642B2B297128746869732E6F7074732E696428625B635D292C746869732E6F7074732E696428615B645D2929262628622E73706C69636528632C31292C632D2D2C612E73706C69636528642C31292C642D2D293B72657475726E7B616464';
wwv_flow_api.g_varchar2_table(560) := '65643A622C72656D6F7665643A617D7D2C76616C3A66756E6374696F6E28632C64297B76617220652C663D746869733B696628303D3D3D617267756D656E74732E6C656E6774682972657475726E20746869732E67657456616C28293B696628653D7468';
wwv_flow_api.g_varchar2_table(561) := '69732E6461746128292C652E6C656E6774687C7C28653D5B5D292C2163262630213D3D632972657475726E20746869732E6F7074732E656C656D656E742E76616C282222292C746869732E75706461746553656C656374696F6E285B5D292C746869732E';
wwv_flow_api.g_varchar2_table(562) := '636C65617253656172636828292C642626746869732E747269676765724368616E6765287B61646465643A746869732E6461746128292C72656D6F7665643A657D292C766F696420303B696628746869732E73657456616C2863292C746869732E73656C';
wwv_flow_api.g_varchar2_table(563) := '65637429746869732E6F7074732E696E697453656C656374696F6E28746869732E73656C6563742C746869732E62696E6428746869732E75706461746553656C656374696F6E29292C642626746869732E747269676765724368616E676528746869732E';
wwv_flow_api.g_varchar2_table(564) := '6275696C644368616E676544657461696C7328652C746869732E64617461282929293B656C73657B696628746869732E6F7074732E696E697453656C656374696F6E3D3D3D62297468726F77206E6577204572726F72282276616C28292063616E6E6F74';
wwv_flow_api.g_varchar2_table(565) := '2062652063616C6C656420696620696E697453656C656374696F6E2829206973206E6F7420646566696E656422293B746869732E6F7074732E696E697453656C656374696F6E28746869732E6F7074732E656C656D656E742C66756E6374696F6E286229';
wwv_flow_api.g_varchar2_table(566) := '7B76617220633D612E6D617028622C662E6964293B662E73657456616C2863292C662E75706461746553656C656374696F6E2862292C662E636C65617253656172636828292C642626662E747269676765724368616E676528662E6275696C644368616E';
wwv_flow_api.g_varchar2_table(567) := '676544657461696C7328652C746869732E64617461282929297D297D746869732E636C65617253656172636828297D2C6F6E536F727453746172743A66756E6374696F6E28297B696628746869732E73656C656374297468726F77206E6577204572726F';
wwv_flow_api.g_varchar2_table(568) := '722822536F7274696E67206F6620656C656D656E7473206973206E6F7420737570706F72746564207768656E20617474616368656420746F203C73656C6563743E2E2041747461636820746F203C696E70757420747970653D2768696464656E272F3E20';
wwv_flow_api.g_varchar2_table(569) := '696E73746561642E22293B746869732E7365617263682E77696474682830292C746869732E736561726368436F6E7461696E65722E6869646528297D2C6F6E536F7274456E643A66756E6374696F6E28297B76617220623D5B5D2C633D746869733B7468';
wwv_flow_api.g_varchar2_table(570) := '69732E736561726368436F6E7461696E65722E73686F7728292C746869732E736561726368436F6E7461696E65722E617070656E64546F28746869732E736561726368436F6E7461696E65722E706172656E742829292C746869732E726573697A655365';
wwv_flow_api.g_varchar2_table(571) := '6172636828292C746869732E73656C656374696F6E2E66696E6428222E73656C656374322D7365617263682D63686F69636522292E656163682866756E6374696F6E28297B622E7075736828632E6F7074732E696428612874686973292E646174612822';
wwv_flow_api.g_varchar2_table(572) := '73656C656374322D64617461222929297D292C746869732E73657456616C2862292C746869732E747269676765724368616E676528297D2C646174613A66756E6374696F6E28622C63297B76617220652C662C643D746869733B72657475726E20303D3D';
wwv_flow_api.g_varchar2_table(573) := '3D617267756D656E74732E6C656E6774683F746869732E73656C656374696F6E2E66696E6428222E73656C656374322D7365617263682D63686F69636522292E6D61702866756E6374696F6E28297B72657475726E20612874686973292E646174612822';
wwv_flow_api.g_varchar2_table(574) := '73656C656374322D6461746122297D292E67657428293A28663D746869732E6461746128292C627C7C28623D5B5D292C653D612E6D617028622C66756E6374696F6E2861297B72657475726E20642E6F7074732E69642861297D292C746869732E736574';
wwv_flow_api.g_varchar2_table(575) := '56616C2865292C746869732E75706461746553656C656374696F6E2862292C746869732E636C65617253656172636828292C632626746869732E747269676765724368616E676528746869732E6275696C644368616E676544657461696C7328662C7468';
wwv_flow_api.g_varchar2_table(576) := '69732E64617461282929292C766F69642030297D7D292C612E666E2E73656C656374323D66756E6374696F6E28297B76617220642C672C682C692C6A2C633D41727261792E70726F746F747970652E736C6963652E63616C6C28617267756D656E74732C';
wwv_flow_api.g_varchar2_table(577) := '30292C6B3D5B2276616C222C2264657374726F79222C226F70656E6564222C226F70656E222C22636C6F7365222C22666F637573222C226973466F6375736564222C22636F6E7461696E6572222C2264726F70646F776E222C226F6E536F727453746172';
wwv_flow_api.g_varchar2_table(578) := '74222C226F6E536F7274456E64222C22656E61626C65222C2264697361626C65222C22726561646F6E6C79222C22706F736974696F6E44726F70646F776E222C2264617461222C22736561726368225D2C6C3D5B226F70656E6564222C226973466F6375';
wwv_flow_api.g_varchar2_table(579) := '736564222C22636F6E7461696E6572222C2264726F70646F776E225D2C6D3D5B2276616C222C2264617461225D2C6E3D7B7365617263683A2265787465726E616C536561726368227D3B72657475726E20746869732E656163682866756E6374696F6E28';
wwv_flow_api.g_varchar2_table(580) := '297B696628303D3D3D632E6C656E6774687C7C226F626A656374223D3D747970656F6620635B305D29643D303D3D3D632E6C656E6774683F7B7D3A612E657874656E64287B7D2C635B305D292C642E656C656D656E743D612874686973292C2273656C65';
wwv_flow_api.g_varchar2_table(581) := '6374223D3D3D642E656C656D656E742E6765742830292E7461674E616D652E746F4C6F7765724361736528293F6A3D642E656C656D656E742E70726F7028226D756C7469706C6522293A286A3D642E6D756C7469706C657C7C21312C227461677322696E';
wwv_flow_api.g_varchar2_table(582) := '2064262628642E6D756C7469706C653D6A3D213029292C673D6A3F6E657720663A6E657720652C672E696E69742864293B656C73657B69662822737472696E6722213D747970656F6620635B305D297468726F7722496E76616C696420617267756D656E';
wwv_flow_api.g_varchar2_table(583) := '747320746F2073656C6563743220706C7567696E3A20222B633B6966286F28635B305D2C6B293C30297468726F7722556E6B6E6F776E206D6574686F643A20222B635B305D3B696628693D622C673D612874686973292E64617461282273656C65637432';
wwv_flow_api.g_varchar2_table(584) := '22292C673D3D3D622972657475726E3B696628683D635B305D2C22636F6E7461696E6572223D3D3D683F693D672E636F6E7461696E65723A2264726F70646F776E223D3D3D683F693D672E64726F70646F776E3A286E5B685D262628683D6E5B685D292C';
wwv_flow_api.g_varchar2_table(585) := '693D675B685D2E6170706C7928672C632E736C69636528312929292C6F28635B305D2C6C293E3D307C7C6F28635B305D2C6D292626313D3D632E6C656E6774682972657475726E21317D7D292C693D3D3D623F746869733A697D2C612E666E2E73656C65';
wwv_flow_api.g_varchar2_table(586) := '6374322E64656661756C74733D7B77696474683A22636F7079222C6C6F61644D6F726550616464696E673A302C636C6F73654F6E53656C6563743A21302C6F70656E4F6E456E7465723A21302C636F6E7461696E65724373733A7B7D2C64726F70646F77';
wwv_flow_api.g_varchar2_table(587) := '6E4373733A7B7D2C636F6E7461696E6572437373436C6173733A22222C64726F70646F776E437373436C6173733A22222C666F726D6174526573756C743A66756E6374696F6E28612C622C632C64297B76617220653D5B5D3B72657475726E204528612E';
wwv_flow_api.g_varchar2_table(588) := '746578742C632E7465726D2C652C64292C652E6A6F696E282222297D2C666F726D617453656C656374696F6E3A66756E6374696F6E28612C632C64297B72657475726E20613F6428612E74657874293A627D2C736F7274526573756C74733A66756E6374';
wwv_flow_api.g_varchar2_table(589) := '696F6E2861297B72657475726E20617D2C666F726D6174526573756C74437373436C6173733A66756E6374696F6E28297B72657475726E20627D2C666F726D617453656C656374696F6E437373436C6173733A66756E6374696F6E28297B72657475726E';
wwv_flow_api.g_varchar2_table(590) := '20627D2C666F726D61744E6F4D6174636865733A66756E6374696F6E28297B72657475726E224E6F206D61746368657320666F756E64227D2C666F726D6174496E707574546F6F53686F72743A66756E6374696F6E28612C62297B76617220633D622D61';
wwv_flow_api.g_varchar2_table(591) := '2E6C656E6774683B72657475726E22506C6561736520656E74657220222B632B22206D6F726520636861726163746572222B28313D3D633F22223A227322297D2C666F726D6174496E707574546F6F4C6F6E673A66756E6374696F6E28612C62297B7661';
wwv_flow_api.g_varchar2_table(592) := '7220633D612E6C656E6774682D623B72657475726E22506C656173652064656C65746520222B632B2220636861726163746572222B28313D3D633F22223A227322297D2C666F726D617453656C656374696F6E546F6F4269673A66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(593) := '297B72657475726E22596F752063616E206F6E6C792073656C65637420222B612B22206974656D222B28313D3D613F22223A227322297D2C666F726D61744C6F61644D6F72653A66756E6374696F6E28297B72657475726E224C6F6164696E67206D6F72';
wwv_flow_api.g_varchar2_table(594) := '6520726573756C74732E2E2E227D2C666F726D6174536561726368696E673A66756E6374696F6E28297B72657475726E22536561726368696E672E2E2E227D2C6D696E696D756D526573756C7473466F725365617263683A302C6D696E696D756D496E70';
wwv_flow_api.g_varchar2_table(595) := '75744C656E6774683A302C6D6178696D756D496E7075744C656E6774683A6E756C6C2C6D6178696D756D53656C656374696F6E53697A653A302C69643A66756E6374696F6E2861297B72657475726E20612E69647D2C6D6174636865723A66756E637469';
wwv_flow_api.g_varchar2_table(596) := '6F6E28612C62297B72657475726E206E2822222B62292E746F55707065724361736528292E696E6465784F66286E2822222B61292E746F5570706572436173652829293E3D307D2C736570617261746F723A222C222C746F6B656E536570617261746F72';
wwv_flow_api.g_varchar2_table(597) := '733A5B5D2C746F6B656E697A65723A4D2C6573636170654D61726B75703A462C626C75724F6E4368616E67653A21312C73656C6563744F6E426C75723A21312C6164617074436F6E7461696E6572437373436C6173733A66756E6374696F6E2861297B72';
wwv_flow_api.g_varchar2_table(598) := '657475726E20617D2C616461707444726F70646F776E437373436C6173733A66756E6374696F6E28297B72657475726E206E756C6C7D2C6E6578745365617263685465726D3A66756E6374696F6E28297B72657475726E20627D7D2C612E666E2E73656C';
wwv_flow_api.g_varchar2_table(599) := '656374322E616A617844656661756C74733D7B7472616E73706F72743A612E616A61782C706172616D733A7B747970653A22474554222C63616368653A21312C64617461547970653A226A736F6E227D7D2C77696E646F772E53656C656374323D7B7175';
wwv_flow_api.g_varchar2_table(600) := '6572793A7B616A61783A472C6C6F63616C3A482C746167733A497D2C7574696C3A7B6465626F756E63653A762C6D61726B4D617463683A452C6573636170654D61726B75703A462C7374726970446961637269746963733A6E7D2C22636C617373223A7B';
wwv_flow_api.g_varchar2_table(601) := '226162737472616374223A642C73696E676C653A652C6D756C74693A667D7D7D7D286A5175657279293B';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 40943434768293187 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2.min.js'
 ,p_mime_type => 'text/javascript'
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
  p_id => 40944156047294019 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2.png'
 ,p_mime_type => 'image/png'
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
  p_id => 40944833494294962 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 48942052171629742426 + wwv_flow_api.g_id_offset
 ,p_file_name => 'select2x2.png'
 ,p_mime_type => 'image/png'
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
