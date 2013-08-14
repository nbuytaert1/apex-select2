-- GLOBAL TYPES
subtype gt_string is varchar2(32767);

type gt_optgroups
  is table of gt_string
  index by pls_integer;


-- GLOBAL CONSTANTS
gc_min_lov_cols constant number := 2;
gc_max_lov_cols constant number := 3;

gc_lov_display_col constant number := 1;
gc_lov_return_col  constant number := 2;
gc_lov_group_col   constant number := 3;

gc_contains_ignore_case    constant char(3) := 'CIC';
gc_contains_case_sensitive constant char(3) := 'CCS';
gc_exact_ignore_case       constant char(3) := 'EIC';
gc_exact_case_sensitive    constant char(3) := 'ECS';

gc_null_optgroup_label constant gt_string := 'Ungrouped';


-- UTIL
function boolean_to_string(p_boolean in boolean)
return varchar2 is
begin
  if (p_boolean) then
    return 'true';
  elsif (not p_boolean) then
    return 'false';
  else
    return '';
  end if;
end boolean_to_string;

function add_js_attr(p_param_name     in varchar2
                   , p_param_value    in varchar2
                   , p_include_quotes in boolean
                   , p_include_comma  in boolean default true)
return varchar2 is
  l_param_value gt_string;
  l_attr        gt_string;
begin
  if (p_param_value is not null) then
    if (p_include_quotes) then
      l_param_value := '"' || p_param_value || '"';
    end if;
    l_attr := p_param_name || ': ' || nvl(l_param_value, p_param_value);
    if (p_include_comma) then
      l_attr := l_attr || ',';
    end if;
  else
    l_attr := '';
  end if;

  return l_attr;
end add_js_attr;

function is_selected_value(p_value           in varchar2
                         , p_selected_values in varchar2)
return boolean is
  l_selected_values apex_application_global.vc_arr2;
begin
  l_selected_values := apex_util.string_to_table(p_selected_values);

  for i in 1 .. l_selected_values.count loop
    if (p_value = l_selected_values(i)) then
      return true;
    end if;
  end loop;

  return false;
end is_selected_value;

function optgroup_exists(p_optgroups in gt_optgroups
                       , p_optgroup  in varchar2)
return boolean is
  l_index pls_integer := p_optgroups.first;
begin
  while (l_index is not null) loop
    if (p_optgroups(l_index) = p_optgroup) then
      return true;
    end if;
    l_index := p_optgroups.next(l_index);
  end loop;

  return false;
end optgroup_exists;

function get_null_optgroup_label(p_default_null_optgroup_label in gt_string
                               , p_null_optgroup_label_app     in gt_string
                               , p_null_optgroup_label_cmp     in gt_string)
return varchar2 is
  l_null_optgroup_label gt_string;
begin
  if (p_null_optgroup_label_cmp is not null) then
    l_null_optgroup_label := p_null_optgroup_label_cmp;
  else
    l_null_optgroup_label := nvl(p_null_optgroup_label_app, p_default_null_optgroup_label);
  end if;

  return l_null_optgroup_label;
end get_null_optgroup_label;


-- FETCH LIST OF VALUES
function get_lov(p_item in apex_plugin.t_page_item)
return apex_plugin_util.t_column_value_list is
begin
  return apex_plugin_util.get_data(
           p_sql_statement  => p_item.lov_definition,
           p_min_columns    => gc_min_lov_cols,
           p_max_columns    => gc_max_lov_cols,
           p_component_name => p_item.name
         );
end get_lov;

function get_tags_option(p_item             in apex_plugin.t_page_item,
                         p_select_list_type in varchar2)
return varchar2 is
  l_lov         apex_plugin_util.t_column_value_list;
  l_tags_option gt_string;
begin
  l_lov := get_lov(p_item);

  if (p_select_list_type = 'TAG') then
    l_tags_option := 'tags: [';
    for i in 1 .. l_lov(gc_lov_display_col).count loop
      if (p_item.escape_output) then
        l_tags_option := l_tags_option || '"' || sys.htf.escape_sc(l_lov(gc_lov_display_col)(i)) || '",';
      else
        l_tags_option := l_tags_option || '"' || l_lov(gc_lov_display_col)(i) || '",';
      end if;
    end loop;
    if (l_lov(gc_lov_display_col).count > 0) then
      l_tags_option := substr(l_tags_option, 0, length(l_tags_option) - 1);
    end if;
    l_tags_option := l_tags_option || '],';
  else
    l_tags_option := '';
  end if;

  return l_tags_option;
end get_tags_option;


-- RENDER FUNCTION
function render(p_item                in apex_plugin.t_page_item,
                p_plugin              in apex_plugin.t_plugin,
                p_value               in varchar2,
                p_is_readonly         in boolean,
                p_is_printer_friendly in boolean)
return apex_plugin.t_page_item_render_result is
  -- LOCAL VARIABLES
  l_no_matches_msg          gt_string := p_plugin.attribute_01;
  l_input_too_short_msg     gt_string := p_plugin.attribute_02;
  l_selection_too_big_msg   gt_string := p_plugin.attribute_03;
  --l_searching_msg         gt_string := p_plugin.attribute_04;
  l_null_optgroup_label_app gt_string := p_plugin.attribute_05;

  l_select_list_type        gt_string := p_item.attribute_01;
  l_min_results_for_search  gt_string := p_item.attribute_02;
  l_min_input_length        gt_string := p_item.attribute_03;
  l_max_input_length        gt_string := p_item.attribute_04;
  l_max_selection_size      gt_string := p_item.attribute_05;
  l_rapid_selection         gt_string := p_item.attribute_06;
  l_select_on_blur          gt_string := p_item.attribute_07;
  l_search_logic            gt_string := p_item.attribute_08;
  l_null_optgroup_label_cmp gt_string := p_item.attribute_09;

  l_value          gt_string;
  l_display_values apex_application_global.vc_arr2;
  l_lov            apex_plugin_util.t_column_value_list;
  laa_optgroups    gt_optgroups;
  l_null_optgroup  gt_string;
  l_tmp_optgroup   gt_string;
  l_multiselect    gt_string;
  l_placeholder    gt_string;

  l_onload_code    gt_string;
  l_render_result  apex_plugin.t_page_item_render_result;
begin
  if (apex_application.g_debug) then
    apex_plugin_util.debug_page_item(p_plugin, p_item, p_value, p_is_readonly, p_is_printer_friendly);
  end if;

  if (p_item.escape_output) then
    l_value := sys.htf.escape_sc(p_value);
  else
    l_value := p_value;
  end if;

  if (p_is_readonly or p_is_printer_friendly) then
    apex_plugin_util.print_hidden_if_readonly(p_item.name, p_value, p_is_readonly, p_is_printer_friendly);

    l_display_values := apex_plugin_util.get_display_data(
                          p_sql_statement     => p_item.lov_definition,
                          p_min_columns       => gc_min_lov_cols,
                          p_max_columns       => gc_max_lov_cols,
                          p_component_name    => p_item.name,
                          p_search_value_list => apex_util.string_to_table(p_value),
                          p_display_extra     => p_item.lov_display_extra
                        );

    if (l_display_values.count = 1) then
      apex_plugin_util.print_display_only(
        p_item_name        => p_item.name,
        p_display_value    => l_display_values(1),
        p_show_line_breaks => false,
        p_escape           => p_item.escape_output,
        p_attributes       => p_item.element_attributes
      );
    elsif (l_display_values.count > 1) then
      sys.htp.p('
        <ul id="' || p_item.name || '_DISPLAY"
            class="display_only">');

      for i in 1 .. l_display_values.count loop
        if (p_item.escape_output) then
          sys.htp.p('<li>' || sys.htf.escape_sc(l_display_values(i)) || '</li>');
        else
          sys.htp.p('<li>' || l_display_values(i) || '</li>');
        end if;
      end loop;

      sys.htp.p('</ul>');
    end if;

    return l_render_result;
  end if;

  apex_javascript.add_library(
    p_name      => 'select2.min',
    p_directory => p_plugin.file_prefix,
    p_version   => null
  );
  apex_css.add_file(
    p_name      => 'select2',
    p_directory => p_plugin.file_prefix,
    p_version   => null
  );

  l_lov := get_lov(p_item);

  if (l_select_list_type = 'MULTI') then
    l_multiselect := 'multiple';
  else
    l_multiselect := '';
  end if;

  if (l_select_list_type = 'TAG') then
    sys.htp.p('
      <input type="hidden"
             id="' || p_item.name || '"
             name="' || apex_plugin.get_input_name_for_page_item(true) || '"
             value="' || l_value || '"
             class="' || p_item.element_css_classes || '" ' ||
             p_item.element_attributes || '>');
  else
    sys.htp.p('
      <select ' || l_multiselect || '
              id="' || p_item.name || '"
              name="' || apex_plugin.get_input_name_for_page_item(true) || '"
              class="selectlist ' || p_item.element_css_classes || '" ' ||
              p_item.element_attributes || '>');

    if (p_item.lov_display_null) then
      sys.htp.p('<option></option>');
    end if;

    if (l_lov.exists(gc_lov_group_col)) then
      l_null_optgroup := get_null_optgroup_label(
                           p_default_null_optgroup_label => gc_null_optgroup_label,
                           p_null_optgroup_label_app     => l_null_optgroup_label_app,
                           p_null_optgroup_label_cmp     => l_null_optgroup_label_cmp
                         );

      for i in 1 .. l_lov(gc_lov_display_col).count loop
        l_tmp_optgroup := nvl(l_lov(gc_lov_group_col)(i), l_null_optgroup);

        if (not optgroup_exists(laa_optgroups, l_tmp_optgroup)) then
          sys.htp.p('<optgroup label="' || l_tmp_optgroup || '">');
          for j in 1 .. l_lov(gc_lov_display_col).count loop
            if (nvl(l_lov(gc_lov_group_col)(j), l_null_optgroup) = l_tmp_optgroup) then
              apex_plugin_util.print_option(
                p_display_value => l_lov(gc_lov_display_col)(j),
                p_return_value  => l_lov(gc_lov_return_col)(j),
                p_is_selected   => is_selected_value(l_lov(gc_lov_return_col)(j), p_value),
                p_attributes    => p_item.element_option_attributes,
                p_escape        => p_item.escape_output
              );
            end if;
          end loop;
          sys.htp.p('</optgroup>');

          laa_optgroups(i) := l_tmp_optgroup;
        end if;
      end loop;
    else
      for i in 1 .. l_lov(gc_lov_display_col).count loop
        apex_plugin_util.print_option(
          p_display_value => l_lov(gc_lov_display_col)(i),
          p_return_value  => l_lov(gc_lov_return_col)(i),
          p_is_selected   => is_selected_value(l_lov(gc_lov_return_col)(i), p_value),
          p_attributes    => p_item.element_option_attributes,
          p_escape        => p_item.escape_output
        );
      end loop;
    end if;

    sys.htp.p('</select>');
  end if;

  if (p_item.lov_display_null) then
    l_placeholder := p_item.lov_null_text;
  else
    l_placeholder := '';
  end if;

  if (l_rapid_selection is null) then
    l_rapid_selection := '';
  else
    l_rapid_selection := 'false';
  end if;

  if (l_select_on_blur is null) then
    l_select_on_blur := '';
  else
    l_select_on_blur := 'true';
  end if;

  l_onload_code := '
    $("#' || p_item.name || '").select2({' ||
      add_js_attr('minimumInputLength', l_min_input_length, false) ||
      add_js_attr('maximumInputLength', l_max_input_length, false) ||
      add_js_attr('minimumResultsForSearch', l_min_results_for_search, false) ||
      add_js_attr('maximumSelectionSize', l_max_selection_size, false) ||
      add_js_attr('placeholder', l_placeholder, true) || '
      separator: ":",
      allowClear: true,' ||
      add_js_attr('closeOnSelect', l_rapid_selection, false) ||
      get_tags_option(p_item, l_select_list_type) ||
      add_js_attr('selectOnBlur', l_select_on_blur, false);

  if (l_no_matches_msg is not null) then
    l_onload_code := l_onload_code || '
      formatNoMatches: function(term) {
                         var msg = "' || l_no_matches_msg || '";
                         msg = msg.replace("#TERM#", term);
                         return msg;
                       },';
  end if;

  if (l_input_too_short_msg is not null) then
    l_onload_code := l_onload_code || '
      formatInputTooShort: function(term, minLength) {
                             var msg = "' || l_input_too_short_msg || '";
                             msg = msg.replace("#TERM#", term);
                             msg = msg.replace("#MINLENGTH#", minLength);
                             return msg;
                           },';
  end if;

  if (l_selection_too_big_msg is not null) then
    l_onload_code := l_onload_code || '
      formatSelectionTooBig: function(maxSize) {
                               var msg = "' || l_selection_too_big_msg || '";
                               msg = msg.replace("#MAXSIZE#", maxSize);
                               return msg;
                             },';
  end if;

  if (l_search_logic != gc_contains_ignore_case) then
    case l_search_logic
      when gc_contains_case_sensitive then l_search_logic := 'return text.indexOf(term) >= 0;';
      when gc_exact_ignore_case then l_search_logic := 'return text.toUpperCase() == term.toUpperCase() || term.length === 0;';
      when gc_exact_case_sensitive then l_search_logic := 'return text == term || term.length === 0;';
      else l_search_logic := 'return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;';
    end case;

    l_onload_code := l_onload_code || '
      matcher: function(term, text) {
                 ' || l_search_logic || '
               },';
  end if;

  l_onload_code := l_onload_code || 'width: "resolve"});';

  apex_javascript.add_onload_code(l_onload_code);
  l_render_result.is_navigable := true;
  return l_render_result;
end render;


-- AJAX FUNCTION
function ajax(p_item   in apex_plugin.t_page_item
            , p_plugin in apex_plugin.t_plugin)
return apex_plugin.t_page_item_ajax_result is
  l_lov           apex_plugin_util.t_column_value_list;
  l_display_value gt_string;
  l_json          gt_string;
  l_result        apex_plugin.t_page_item_ajax_result;
begin
  l_lov := get_lov(p_item);

  if (l_lov.exists(gc_lov_group_col)) then
    l_json := '{"values":[';

    for i in 1 .. l_lov(gc_lov_display_col).count loop
      if (p_item.escape_output) then
        l_display_value := sys.htf.escape_sc(l_lov(gc_lov_display_col)(i));
      else
        l_display_value := l_lov(gc_lov_display_col)(i);
      end if;
      l_json := l_json || '{"d":"' || l_display_value || '","r":"' || l_lov(gc_lov_return_col)(i) || '"},';
    end loop;

    if (l_lov(gc_lov_display_col).count > 0) then
      l_json := substr(l_json, 0, (length(l_json) - 1));
    end if;

    l_json := l_json || '], "default":""}';
    sys.htp.p(l_json);
  else
    apex_plugin_util.print_page_item_lov_as_json(
      p_sql_statement  => p_item.lov_definition,
      p_page_item_name => p_item.name,
      p_escape         => p_item.escape_output
    );
  end if;

  return l_result;
end ajax;