-- GLOBAL
subtype gt_string is varchar2(32767);

gco_min_lov_cols constant number := 2;
gco_max_lov_cols constant number := 3;

gco_lov_display_col constant number := 1;
gco_lov_return_col  constant number := 2;
gco_lov_group_col   constant number := 3;


-- UTIL
function add_js_attr(
           p_param_name     in gt_string,
           p_param_value    in gt_string,
           p_include_quotes in boolean default false,
           p_include_comma  in boolean default true
         )
return gt_string is
  l_param_value gt_string;
  l_attr        gt_string;
begin
  if (p_param_value is not null) then
    if (p_include_quotes) then
      l_param_value := '"' || p_param_value || '"';
    end if;
    l_attr := p_param_name || ': ' || nvl(l_param_value, p_param_value);
    if (p_include_comma) then
      l_attr := '
        ' || l_attr || ',';
    end if;
  else
    l_attr := '';
  end if;

  return l_attr;
end add_js_attr;


function get_lov(
           p_item in apex_plugin.t_page_item
         )
return apex_plugin_util.t_column_value_list is
begin
  return apex_plugin_util.get_data(
           p_sql_statement  => p_item.lov_definition,
           p_min_columns    => gco_min_lov_cols,
           p_max_columns    => gco_max_lov_cols,
           p_component_name => p_item.name
         );
end get_lov;


-- PRINT LIST OF VALUES
function get_options_html(
           p_item   in apex_plugin.t_page_item,
           p_plugin in apex_plugin.t_plugin,
           p_value  in gt_string
         )
return gt_string is
  l_null_optgroup_label_app gt_string := p_plugin.attribute_05;
  l_null_optgroup_label_cmp gt_string := p_item.attribute_09;

  lco_null_optgroup_label constant gt_string := 'Ungrouped';

  l_lov           apex_plugin_util.t_column_value_list;
  l_null_optgroup gt_string;
  l_tmp_optgroup  gt_string;

  type gt_optgroups
    is table of gt_string
    index by pls_integer;
  laa_optgroups gt_optgroups;


  -- local subprograms
  function get_null_optgroup_label(
             p_default_null_optgroup_label in gt_string,
             p_null_optgroup_label_app     in gt_string,
             p_null_optgroup_label_cmp     in gt_string
           )
  return gt_string is
    l_null_optgroup_label gt_string;
  begin
    if (p_null_optgroup_label_cmp is not null) then
      l_null_optgroup_label := p_null_optgroup_label_cmp;
    else
      l_null_optgroup_label := nvl(p_null_optgroup_label_app, p_default_null_optgroup_label);
    end if;

    return l_null_optgroup_label;
  end get_null_optgroup_label;


  function optgroup_exists(
             p_optgroups in gt_optgroups,
             p_optgroup  in gt_string
           )
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


  function is_selected_value(
             p_value           in gt_string,
             p_selected_values in gt_string
           )
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
begin
  l_lov := get_lov(p_item);

  if (p_item.lov_display_null) then
    if p_value is null then
      sys.htp.p('<option value="" selected="selected"></option>');
    else
      sys.htp.p('<option></option>');
    end if;
  end if;

  if (l_lov.exists(gco_lov_group_col)) then
    l_null_optgroup := get_null_optgroup_label(
                         p_default_null_optgroup_label => lco_null_optgroup_label,
                         p_null_optgroup_label_app     => l_null_optgroup_label_app,
                         p_null_optgroup_label_cmp     => l_null_optgroup_label_cmp
                       );

    for i in 1 .. l_lov(gco_lov_display_col).count loop
      l_tmp_optgroup := nvl(l_lov(gco_lov_group_col)(i), l_null_optgroup);

      if (not optgroup_exists(laa_optgroups, l_tmp_optgroup)) then
        sys.htp.p('<optgroup label="' || l_tmp_optgroup || '">');
        for j in 1 .. l_lov(gco_lov_display_col).count loop
          if (nvl(l_lov(gco_lov_group_col)(j), l_null_optgroup) = l_tmp_optgroup) then
            apex_plugin_util.print_option(
              p_display_value => l_lov(gco_lov_display_col)(j),
              p_return_value  => l_lov(gco_lov_return_col)(j),
              p_is_selected   => is_selected_value(l_lov(gco_lov_return_col)(j), p_value),
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
    for i in 1 .. l_lov(gco_lov_display_col).count loop
      apex_plugin_util.print_option(
        p_display_value => l_lov(gco_lov_display_col)(i),
        p_return_value  => l_lov(gco_lov_return_col)(i),
        p_is_selected   => is_selected_value(l_lov(gco_lov_return_col)(i), p_value),
        p_attributes    => p_item.element_option_attributes,
        p_escape        => p_item.escape_output
      );
    end loop;
  end if;

  return '';
end get_options_html;


function get_tags_option(
           p_item        in apex_plugin.t_page_item,
           p_include_key in boolean
         )
return gt_string is
  l_lov                   apex_plugin_util.t_column_value_list;
  l_select_list_type      gt_string := p_item.attribute_01;
  l_return_value_based_on gt_string := p_item.attribute_12;
  l_tags_option           gt_string;
begin
  l_lov := get_lov(p_item);

  if (l_select_list_type != 'TAG' or
     (l_select_list_type = 'TAG' and l_return_value_based_on = 'DISPLAY')) then
    if (p_include_key) then
      for i in 1 .. l_lov(gco_lov_display_col).count loop
        l_tags_option := l_tags_option || '"' || l_lov(gco_lov_display_col)(i) || '",';
      end loop;
    elsif (not p_include_key) then
      for i in 1 .. l_lov(gco_lov_display_col).count loop
        l_tags_option := l_tags_option || l_lov(gco_lov_display_col)(i) || ',';
      end loop;
    end if;
  else
    for i in 1 .. l_lov(gco_lov_display_col).count loop
      l_tags_option := l_tags_option || '{' ||
                                           add_js_attr('"id"', l_lov(gco_lov_return_col)(i)) ||
                                           add_js_attr('"text"', l_lov(gco_lov_display_col)(i), true, false) ||
                                        '},';
    end loop;

    if (not p_include_key) then
      if (l_lov(gco_lov_display_col).count > 0) then
        l_tags_option := substr(l_tags_option, 0, length(l_tags_option) - 1);
      end if;

      return '[' || l_tags_option || ']';
    end if;
  end if;

  if (l_lov(gco_lov_display_col).count > 0) then
    l_tags_option := substr(l_tags_option, 0, length(l_tags_option) - 1);
  end if;

  if (p_include_key) then
    l_tags_option := '
        tags: [' || l_tags_option || ']';
  end if;

  return l_tags_option;
end get_tags_option;


-- PLUGIN INTERFACE FUNCTIONS
function render(
           p_item                in apex_plugin.t_page_item,
           p_plugin              in apex_plugin.t_plugin,
           p_value               in gt_string,
           p_is_readonly         in boolean,
           p_is_printer_friendly in boolean
         )
return apex_plugin.t_page_item_render_result is
  l_no_matches_msg          gt_string := p_plugin.attribute_01;
  l_input_too_short_msg     gt_string := p_plugin.attribute_02;
  l_selection_too_big_msg   gt_string := p_plugin.attribute_03;
  l_searching_msg           gt_string := p_plugin.attribute_04;
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
  l_width                   gt_string := p_item.attribute_10;
  l_drag_and_drop_sorting   gt_string := p_item.attribute_11;
  l_return_value_based_on   gt_string := p_item.attribute_12;

  l_display_values apex_application_global.vc_arr2;
  l_multiselect    gt_string;

  l_item_jq                    gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.name);
  l_cascade_parent_items_jq    gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.lov_cascade_parent_items);
  l_cascade_items_to_submit_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.ajax_items_to_submit);
  l_items_for_session_state_jq gt_string;
  l_cascade_parent_items       apex_application_global.vc_arr2;
  l_optimize_refresh_condition gt_string;

  l_apex_version  gt_string;
  l_onload_code   gt_string;
  l_render_result apex_plugin.t_page_item_render_result;


  -- local subprograms
  function get_select2_constructor(
             p_include_tags    in boolean,
             p_end_constructor in boolean
           )
  return gt_string is
    lco_contains_ignore_case    constant gt_string := 'CIC';
    lco_contains_case_sensitive constant gt_string := 'CCS';
    lco_exact_ignore_case       constant gt_string := 'EIC';
    lco_exact_case_sensitive    constant gt_string := 'ECS';

    l_placeholder gt_string;
    l_code        gt_string;
  begin
    if (p_item.lov_display_null) then
      l_placeholder := p_item.lov_null_text;
    else
      l_placeholder := '';
    end if;

    if (l_width is null) then
      l_width := 'element';
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

    l_code := '
      $("' || l_item_jq || '").select2({' ||
        add_js_attr('width', l_width, true) ||
        add_js_attr('placeholder', l_placeholder, true) ||
        add_js_attr('allowClear', 'true') ||
        add_js_attr('minimumInputLength', l_min_input_length) ||
        add_js_attr('maximumInputLength', l_max_input_length) ||
        add_js_attr('minimumResultsForSearch', l_min_results_for_search) ||
        add_js_attr('maximumSelectionSize', l_max_selection_size) ||
        add_js_attr('closeOnSelect', l_rapid_selection) ||
        add_js_attr('selectOnBlur', l_select_on_blur);

    if (l_no_matches_msg is not null) then
      l_code := l_code || '
        formatNoMatches: function(term) {
                           var msg = "' || l_no_matches_msg || '";
                           msg = msg.replace("#TERM#", term);
                           return msg;
                         },';
    end if;

    if (l_input_too_short_msg is not null) then
      l_code := l_code || '
        formatInputTooShort: function(term, minLength) {
                               var msg = "' || l_input_too_short_msg || '";
                               msg = msg.replace("#TERM#", term);
                               msg = msg.replace("#MINLENGTH#", minLength);
                               return msg;
                             },';
    end if;

    if (l_selection_too_big_msg is not null) then
      l_code := l_code || '
        formatSelectionTooBig: function(maxSize) {
                                 var msg = "' || l_selection_too_big_msg || '";
                                 msg = msg.replace("#MAXSIZE#", maxSize);
                                 return msg;
                               },';
    end if;

    if (l_searching_msg is not null) then
      l_code := l_code || '
        formatSearching: function() {
                           var msg = "' || l_searching_msg || '";
                           return msg;
                         },';
    end if;

    if (l_search_logic != lco_contains_ignore_case) then
      case l_search_logic
        when lco_contains_case_sensitive then l_search_logic := 'return text.indexOf(term) >= 0;';
        when lco_exact_ignore_case then l_search_logic := 'return text.toUpperCase() === term.toUpperCase() || term.length === 0;';
        when lco_exact_case_sensitive then l_search_logic := 'return text === term || term.length === 0;';
        else l_search_logic := 'return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;';
      end case;

      l_code := l_code || '
        matcher: function(term, text) {
                   ' || l_search_logic || '
                 },';
    end if;

    l_code := l_code || '
        separator: ":"';

    if (l_select_list_type = 'TAG' and p_include_tags) then
      l_code := l_code || ',' || get_tags_option(p_item, true);
    end if;

    if (p_end_constructor) then
      l_code := l_code || '
      });';
    end if;

    return l_code;
  end get_select2_constructor;


  function get_sortable_constructor
  return gt_string is
    l_code gt_string;
  begin
    l_code := '
      $("' || l_item_jq || '").select2("container").find("ul.select2-choices").sortable({
        containment: "parent",
        start: function() { $("' || l_item_jq || '").select2("onSortStart"); },
        update: function() { $("' || l_item_jq || '").select2("onSortEnd"); }
      });';

    return l_code;
  end get_sortable_constructor;
begin
  if (apex_application.g_debug) then
    apex_plugin_util.debug_page_item(p_plugin, p_item, p_value, p_is_readonly, p_is_printer_friendly);
  end if;

  if (p_is_readonly or p_is_printer_friendly) then
    apex_plugin_util.print_hidden_if_readonly(p_item.name, p_value, p_is_readonly, p_is_printer_friendly);

    l_display_values := apex_plugin_util.get_display_data(
                          p_sql_statement     => p_item.lov_definition,
                          p_min_columns       => gco_min_lov_cols,
                          p_max_columns       => gco_max_lov_cols,
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
        sys.htp.p('<li>' || l_display_values(i) || '</li>');
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
  apex_javascript.add_library(
    p_name      => 'select2-apex',
    p_directory => p_plugin.file_prefix,
    p_version   => null
  );
  apex_css.add_file(
    p_name      => 'select2',
    p_directory => p_plugin.file_prefix,
    p_version   => null
  );
  apex_css.add_file(
    p_name      => '﻿select2-bootstrap',
    p_directory => p_plugin.file_prefix,
    p_version   => null
  );

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
             value="' || p_value || '"' ||
             p_item.element_attributes || '>');
  else
    sys.htp.p('
      <select ' || l_multiselect || '
              id="' || p_item.name || '"
              name="' || apex_plugin.get_input_name_for_page_item(true) || '"
              class="selectlist"' ||
              p_item.element_attributes || '>');

    sys.htp.p(get_options_html(p_item, p_plugin, p_value));

    sys.htp.p('</select>');
  end if;

  l_onload_code := get_select2_constructor(
                     p_include_tags    => true,
                     p_end_constructor => true
                   );

  if (l_drag_and_drop_sorting is not null) then
    select substr(version_no, 1, 3)
    into l_apex_version
    from apex_release;

    if (l_apex_version = '4.1') then
      apex_javascript.add_library(
        p_name      => 'jquery-ui.custom.min',
        p_directory => p_plugin.file_prefix,
        p_version   => null
      );
    else
      apex_javascript.add_library(
        p_name      => 'jquery.ui.sortable.min',
        p_directory => '#IMAGE_PREFIX#libraries/jquery-ui/1.8.22/ui/minified/',
        p_version   => null
      );
    end if;

    l_onload_code := l_onload_code || get_sortable_constructor();
  end if;

  if (p_item.lov_cascade_parent_items is not null) then
    l_items_for_session_state_jq := l_cascade_parent_items_jq;

    if (l_cascade_items_to_submit_jq is not null) then
      l_items_for_session_state_jq := l_items_for_session_state_jq || ',' || l_cascade_items_to_submit_jq;
    end if;

    l_onload_code := l_onload_code || '
      $("' || l_cascade_parent_items_jq || '").on("change", function(e) {';

    if (p_item.ajax_optimize_refresh) then
      l_cascade_parent_items := apex_util.string_to_table(l_cascade_parent_items_jq, ',');

      l_optimize_refresh_condition := '$("' || l_cascade_parent_items(1) || '").val() === ""';

      for i in 2 .. l_cascade_parent_items.count loop
        l_optimize_refresh_condition := l_optimize_refresh_condition || ' || $("' || l_cascade_parent_items(i) || '").val() === ""';
      end loop;

      l_onload_code := l_onload_code || '
        var item = $("' || l_item_jq || '");
        if (' || l_optimize_refresh_condition || ') {';

      if (l_select_list_type = 'TAG') then
        l_onload_code := l_onload_code ||
          get_select2_constructor(
            p_include_tags    => false,
            p_end_constructor => false
          ) || ',
        tags: []
      });';
      else
        if (p_item.lov_display_null) then
          l_onload_code := l_onload_code || '
          item.html("<option></option>");';
        else
          l_onload_code := l_onload_code || '
          item.html("");';
        end if;
      end if;

      l_onload_code := l_onload_code || '
          item.select2("data", null);
        } else {';
    end if;
      l_onload_code := l_onload_code || '
          apex.server.plugin(
            "' || apex_plugin.get_ajax_identifier || '",
            { pageItems: "' || l_items_for_session_state_jq || '" },
            { refreshObject: "' || l_item_jq || '",
              loadingIndicator: "' || l_item_jq || '",
              loadingIndicatorPosition: "after",';
    if (l_select_list_type = 'TAG' and l_return_value_based_on = 'RETURN') then
      l_onload_code := l_onload_code || '
              dataType: "json",';
    else
      l_onload_code := l_onload_code || '
              dataType: "text",';
    end if;
      l_onload_code := l_onload_code || '
              success: function(pData) {
                         var item = $("' || l_item_jq || '");';
    if (l_select_list_type = 'TAG') then
      if (l_return_value_based_on = 'DISPLAY') then
        l_onload_code := l_onload_code || '
                         var tagsArray;
                         tagsArray = pData.slice(0, -1).split(",");
                         if (tagsArray.length === 1 && tagsArray[0] === "") {
                           tagsArray = [];
                         }';
      else
        l_onload_code := l_onload_code || '
                         var tagsArray = pData;';
      end if;

      l_onload_code := l_onload_code || '
      ' || get_select2_constructor(
             p_include_tags    => false,
             p_end_constructor => false
           ) || ',
        tags: tagsArray
      });';
    else
      l_onload_code := l_onload_code || '
      item.html(pData);';
    end if;

    l_onload_code := l_onload_code || '
      item.select2("data", null);}});';

    if (p_item.ajax_optimize_refresh) then
      l_onload_code := l_onload_code || '}';
    end if;

    l_onload_code := l_onload_code || '});';
  end if;

  l_onload_code := l_onload_code || '
      beCtbSelect2.events.bind("' || l_item_jq || '");';

  apex_javascript.add_onload_code(l_onload_code);
  l_render_result.is_navigable := true;
  return l_render_result;
end render;


function ajax(
           p_item   in apex_plugin.t_page_item,
           p_plugin in apex_plugin.t_plugin
         )
return apex_plugin.t_page_item_ajax_result is
  l_select_list_type gt_string := p_item.attribute_01;
  l_result apex_plugin.t_page_item_ajax_result;
begin
  if (l_select_list_type = 'TAG') then
    sys.htp.p(get_tags_option(p_item, false));
  else
    sys.htp.p(get_options_html(p_item, p_plugin, ''));
  end if;

  return l_result;
end ajax;