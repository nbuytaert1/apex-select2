create or replace package body select2 is

  --subtype gt_string is varchar2(32767);

  gco_min_lov_cols constant number(1) := 2;
  gco_max_lov_cols constant number(1) := 3;
  gco_lov_display_col constant number(1) := 1;
  gco_lov_return_col constant number(1) := 2;
  gco_lov_group_col constant number(1) := 3;
  gco_contains_ignore_case constant char(3) := 'CIC';
  gco_contains_case_sensitive constant char(3) := 'CCS';
  gco_exact_ignore_case constant char(3) := 'EIC';
  gco_exact_case_sensitive constant char(3) := 'ECS';
  gco_starts_with_ignore_case constant char(3) := 'SIC';
  gco_starts_with_case_sensitive constant char(3) := 'SCS';


  procedure print_lov_options(
              p_item in apex_plugin.t_page_item,
              p_plugin in apex_plugin.t_plugin,
              p_value in gt_string default null
            ) is
    l_null_optgroup_label_app gt_string := p_plugin.attribute_05;
    l_select_list_type gt_string := p_item.attribute_01;
    l_null_optgroup_label_cmp gt_string := p_item.attribute_09;
    l_drag_and_drop_sorting gt_string := p_item.attribute_11;
    l_lazy_loading gt_string := p_item.attribute_14;

    lco_null_optgroup_label constant gt_string := 'Ungrouped';

    l_lov apex_plugin_util.t_column_value_list;
    l_null_optgroup gt_string;
    l_tmp_optgroup gt_string;
    l_selected_values apex_application_global.vc_arr2;
    l_display_value gt_string;

    type gt_optgroups
      is table of gt_string
      index by pls_integer;
    laa_optgroups gt_optgroups;

    -- local subprograms
    function optgroup_exists(
               p_optgroups in gt_optgroups,
               p_optgroup in gt_string
             ) return boolean is
      l_index pls_integer := p_optgroups.first;
    begin
      while (l_index is not null) loop
        if p_optgroups(l_index) = p_optgroup then
          return true;
        end if;

        l_index := p_optgroups.next(l_index);
      end loop;

      return false;
    end optgroup_exists;


    function is_selected_value(
               p_value in gt_string,
               p_selected_values in gt_string
             ) return boolean is
      l_selected_values apex_application_global.vc_arr2;
    begin
      l_selected_values := apex_util.string_to_table(p_selected_values);

      for i in 1 .. l_selected_values.count loop
        if apex_plugin_util.is_equal(p_value, l_selected_values(i)) then
          return true;
        end if;
      end loop;

      return false;
    end is_selected_value;
  begin
    l_lov := apex_plugin_util.get_data(
               p_sql_statement  => p_item.lov_definition,
               p_min_columns => gco_min_lov_cols,
               p_max_columns => gco_max_lov_cols,
               p_component_name => p_item.name
             );

    -- print the selected LOV options in case of lazy loading or when drag and drop sorting is enabled
    if (l_lazy_loading is not null or l_drag_and_drop_sorting is not null) then
      if p_value is not null then
        l_selected_values := apex_util.string_to_table(p_value);

        for i in 1 .. l_selected_values.count loop
          begin
            l_display_value := apex_plugin_util.get_display_data(
                                 p_sql_statement => p_item.lov_definition,
                                 p_min_columns => gco_min_lov_cols,
                                 p_max_columns => gco_max_lov_cols,
                                 p_component_name => p_item.name,
                                 p_display_column_no => gco_lov_display_col,
                                 p_search_column_no => gco_lov_return_col,
                                 p_search_string => l_selected_values(i),
                                 p_display_extra => false
                               );
          exception
            when no_data_found then
              l_display_value := null;
          end;

          if not (l_display_value is null and not p_item.lov_display_extra) then
            -- print the display value, or return value if no display value was found
            apex_plugin_util.print_option(
              p_display_value => nvl(l_display_value, l_selected_values(i)),
              p_return_value => l_selected_values(i),
              p_is_selected => true,
              p_attributes => p_item.element_option_attributes,
              p_escape => p_item.escape_output
            );
          end if;
        end loop;
      end if;
    end if;

    if l_lazy_loading is null then
      if l_lov.exists(gco_lov_group_col) then
        if l_null_optgroup_label_cmp is not null then
          l_null_optgroup := l_null_optgroup_label_cmp;
        else
          l_null_optgroup := nvl(l_null_optgroup_label_app, lco_null_optgroup_label);
        end if;

        for i in 1 .. l_lov(gco_lov_display_col).count loop
          l_tmp_optgroup := nvl(l_lov(gco_lov_group_col)(i), l_null_optgroup);

          if not optgroup_exists(laa_optgroups, l_tmp_optgroup) then
            htp.p('<optgroup label="' || l_tmp_optgroup || '">');
            for j in 1 .. l_lov(gco_lov_display_col).count loop
              if nvl(l_lov(gco_lov_group_col)(j), l_null_optgroup) = l_tmp_optgroup then
                apex_plugin_util.print_option(
                  p_display_value => l_lov(gco_lov_display_col)(j),
                  p_return_value => l_lov(gco_lov_return_col)(j),
                  p_is_selected => is_selected_value(l_lov(gco_lov_return_col)(j), p_value),
                  p_attributes => p_item.element_option_attributes,
                  p_escape => p_item.escape_output
                );
              end if;
            end loop;
            htp.p('</optgroup>');

            laa_optgroups(i) := l_tmp_optgroup;
          end if;
        end loop;
      else
        if (l_drag_and_drop_sorting is not null and p_value is not null) then
          for i in 1 .. l_lov(gco_lov_display_col).count loop
            if not is_selected_value(l_lov(gco_lov_return_col)(i), p_value) then
              apex_plugin_util.print_option(
                p_display_value => l_lov(gco_lov_display_col)(i),
                p_return_value => l_lov(gco_lov_return_col)(i),
                p_is_selected => false,
                p_attributes => p_item.element_option_attributes,
                p_escape => p_item.escape_output
              );
            end if;
          end loop;
        else
          for i in 1 .. l_lov(gco_lov_display_col).count loop
            apex_plugin_util.print_option(
              p_display_value => l_lov(gco_lov_display_col)(i),
              p_return_value => l_lov(gco_lov_return_col)(i),
              p_is_selected => is_selected_value(l_lov(gco_lov_return_col)(i), p_value),
              p_attributes => p_item.element_option_attributes,
              p_escape => p_item.escape_output
            );
          end loop;
        end if;
      end if;
    end if;

    if (p_value is not null and (l_select_list_type = 'TAG' or p_item.lov_display_extra)) then
      if not (l_lazy_loading is not null or l_drag_and_drop_sorting is not null) then
        l_selected_values := apex_util.string_to_table(p_value);

        for i in 1 .. l_selected_values.count loop
          begin
            l_display_value := apex_plugin_util.get_display_data(
                                 p_sql_statement => p_item.lov_definition,
                                 p_min_columns => gco_min_lov_cols,
                                 p_max_columns => gco_max_lov_cols,
                                 p_component_name => p_item.name,
                                 p_display_column_no => gco_lov_display_col,
                                 p_search_column_no => gco_lov_return_col,
                                 p_search_string => l_selected_values(i),
                                 p_display_extra => false
                               );
          exception
            when no_data_found then
              l_display_value := null;
          end;

          if l_display_value is null then
            apex_plugin_util.print_option(
              p_display_value => l_selected_values(i),
              p_return_value => l_selected_values(i),
              p_is_selected => true,
              p_attributes => p_item.element_option_attributes,
              p_escape => p_item.escape_output
            );
          end if;
        end loop;
      end if;
    end if;
  end print_lov_options;


  function render(
             p_item in apex_plugin.t_page_item,
             p_plugin in apex_plugin.t_plugin,
             p_value in gt_string,
             p_is_readonly in boolean,
             p_is_printer_friendly in boolean
           ) return apex_plugin.t_page_item_render_result is
    l_no_matches_msg gt_string := p_plugin.attribute_01;
    l_input_too_short_msg gt_string := p_plugin.attribute_02;
    l_selection_too_big_msg gt_string := p_plugin.attribute_03;
    l_searching_msg gt_string := p_plugin.attribute_04;
    l_null_optgroup_label_app gt_string := p_plugin.attribute_05;
    l_loading_more_results_msg gt_string := p_plugin.attribute_06;
    l_look_and_feel gt_string := p_plugin.attribute_07;
    l_error_loading_msg gt_string := p_plugin.attribute_08;
    l_input_too_long_msg gt_string := p_plugin.attribute_09;

    l_select_list_type gt_string := p_item.attribute_01;
    l_min_results_for_search gt_string := p_item.attribute_02;
    l_min_input_length gt_string := p_item.attribute_03;
    l_max_input_length gt_string := p_item.attribute_04;
    l_max_selection_size gt_string := p_item.attribute_05;
    l_rapid_selection gt_string := p_item.attribute_06;
    l_select_on_blur gt_string := p_item.attribute_07;
    l_search_logic gt_string := p_item.attribute_08;
    l_null_optgroup_label_cmp gt_string := p_item.attribute_09;
    l_width gt_string := p_item.attribute_10;
    l_drag_and_drop_sorting gt_string := p_item.attribute_11;
    l_lazy_loading gt_string := p_item.attribute_14;
    l_lazy_append_row_count gt_string := p_item.attribute_15;

    l_display_values apex_application_global.vc_arr2;
    l_multiselect gt_string;

    l_item_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.name);
    l_cascade_parent_items_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.lov_cascade_parent_items);
    l_cascade_items_to_submit_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.ajax_items_to_submit);
    l_items_for_session_state_jq gt_string;
    l_cascade_parent_items apex_application_global.vc_arr2;
    l_optimize_refresh_condition gt_string;

    l_apex_version gt_string;
    l_onload_code gt_string;
    l_render_result apex_plugin.t_page_item_render_result;

    -- local subprograms
    function get_select2_constructor
    return gt_string is
      l_selected_values apex_application_global.vc_arr2;
      l_display_values apex_application_global.vc_arr2;
      l_json gt_string;
      l_code gt_string;

      l_allow_clear_bool boolean;
      l_rapid_selection_bool boolean;
      l_select_on_blur_bool boolean;
    begin
      if p_item.lov_display_null then
        l_allow_clear_bool := true;
      else
        l_allow_clear_bool := false;
      end if;

      if l_rapid_selection is null then
        l_rapid_selection_bool := true;
      else
        l_rapid_selection_bool := false;
      end if;

      if l_select_on_blur is null then
        l_select_on_blur_bool := false;
      else
        l_select_on_blur_bool := true;
      end if;

      l_code := '
        $("' || l_item_jq || '").select2({' ||
          apex_javascript.add_attribute('placeholder', p_item.lov_null_text, false) ||
          apex_javascript.add_attribute('allowClear', l_allow_clear_bool) ||
          apex_javascript.add_attribute('minimumInputLength', to_number(l_min_input_length)) ||
          apex_javascript.add_attribute('maximumInputLength', to_number(l_max_input_length)) ||
          apex_javascript.add_attribute('minimumResultsForSearch', to_number(l_min_results_for_search)) ||
          apex_javascript.add_attribute('maximumSelectionLength', to_number(l_max_selection_size)) ||
          apex_javascript.add_attribute('closeOnSelect', l_rapid_selection_bool) ||
          apex_javascript.add_attribute('selectOnClose', l_select_on_blur_bool);

      if l_look_and_feel in ('UT', 'SELECT2_CLASSIC') then
        l_code := l_code || apex_javascript.add_attribute('theme', 'classic');
      end if;

      l_code := l_code || '"language": {';

      if l_error_loading_msg is not null then
        l_code := l_code || '
          "errorLoading": function() {
                            return "' || l_error_loading_msg || '";
                          },';
      end if;
      if l_input_too_long_msg is not null then
        l_code := l_code || '
          "inputTooLong": function(args) {
                            var msg = "' || l_input_too_long_msg || '";
                            msg = msg.replace("#TERM#", args.input);
                            msg = msg.replace("#MAXLENGTH#", args.maximum);
                            msg = msg.replace("#OVERCHARS#", args.input.length - args.maximum);
                            return msg;
                          },';
      end if;
      if l_input_too_short_msg is not null then
        l_code := l_code || '
          "inputTooShort": function(args) {
                             var msg = "' || l_input_too_short_msg || '";
                             msg = msg.replace("#TERM#", args.input);
                             msg = msg.replace("#MINLENGTH#", args.minimum);
                             msg = msg.replace("#REMAININGCHARS#", args.minimum - args.input.length);
                             return msg;
                           },';
      end if;
      if l_loading_more_results_msg is not null then
        l_code := l_code || '
          "loadingMore": function() {
                           return "' || l_loading_more_results_msg || '";
                         },';
      end if;
      if l_selection_too_big_msg is not null then
        l_code := l_code || '
          "maximumSelected": function(args) {
                               var msg = "' || l_selection_too_big_msg || '";
                               msg = msg.replace("#MAXSIZE#", args.maximum);
                               return msg;
                             },';
      end if;
      if l_no_matches_msg is not null then
        l_code := l_code || '
          "noResults": function() {
                         return "' || l_no_matches_msg || '";
                       },';
      end if;
      if l_searching_msg is not null then
        l_code := l_code || '
          "searching": function() {
                         return "' || l_searching_msg || '";
                       },';
      end if;

      l_code := rtrim(l_code, ',') || '},';

      if l_search_logic != gco_contains_ignore_case then
        case l_search_logic
          when gco_contains_case_sensitive then l_search_logic := 'return text.indexOf(term) >= 0;';
          when gco_exact_ignore_case then l_search_logic := 'return text.toUpperCase() === term.toUpperCase() || term.length === 0;';
          when gco_exact_case_sensitive then l_search_logic := 'return text === term || term.length === 0;';
          when gco_starts_with_ignore_case then l_search_logic := 'return text.toUpperCase().indexOf(term.toUpperCase()) === 0;';
          when gco_starts_with_case_sensitive then l_search_logic := 'return text.indexOf(term) === 0;';
          else l_search_logic := 'return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;';
        end case;

        l_code := '$.fn.select2.amd.require([''select2/compat/matcher''], function(oldMatcher) {' ||
          l_code || '
          matcher: oldMatcher(
                     function(term, text) {
                       ' || l_search_logic || '
                     }
                   ),';
      end if;

      if l_lazy_loading is not null then
        l_code := l_code || '
          ajax: {
            url: "wwv_flow.show",
            type: "POST",
            dataType: "json",
            delay: 250,
            data: function(params) {
                    return {
                      p_flow_id: $("#pFlowId").val(),
                      p_flow_step_id: $("#pFlowStepId").val(),
                      p_instance: $("#pInstance").val(),
                      x01: params.term,
                      x02: params.page,
                      x03: "LAZY_LOAD",
                      p_request: "PLUGIN=' || apex_plugin.get_ajax_identifier || '"
                    };
                  },
            processResults: function(data, params) {
                              var select2Data = $.map(data.row, function(obj) {
                                obj.id = obj.R;
                                obj.text = obj.D;
                                return obj;
                              });

                              return {
                                results: select2Data,
                                pagination: { more: data.more }
                              };
                            },
            cache: true
          },';
      end if;

      if l_select_list_type = 'TAG' then
        l_code := l_code || apex_javascript.add_attribute('tags', true);
      end if;

      l_code := l_code || apex_javascript.add_attribute('width', nvl(l_width, 'element'), true, false);
      l_code := l_code || '})';

      if l_search_logic != gco_contains_ignore_case then
        l_code := l_code || '});';
      else
        l_code := l_code || ';';
      end if;

      return l_code;
    end get_select2_constructor;


    function get_sortable_constructor
    return gt_string is
      l_code gt_string;
    begin
      l_code := '
        var s2item = $("' || l_item_jq || '");
        var s2ul = s2item.next(".select2-container").find("ul.select2-selection__rendered");
        s2ul.sortable({
          containment: "parent",
          items: "li:not(.select2-search)",
          tolerance: "pointer",
          stop: function() {
            $(s2ul.find(".select2-selection__choice").get().reverse()).each(function() {
              s2item.prepend(s2item.find(''option[value="'' + $(this).data("data").id + ''"]'')[0]);
            });
          }
        });';

        /* prevent automatic tags sorting
           http://stackoverflow.com/questions/31431197/select2-how-to-prevent-tags-sorting
        s2item.on("select2:select", function(e) {
          var $element = $(e.params.data.element);

          $element.detach();
          $(this).append($element);
          $(this).trigger("change");
        });';
        */

      return l_code;
    end get_sortable_constructor;
  begin
    if apex_application.g_debug then
      apex_plugin_util.debug_page_item(p_plugin, p_item, p_value, p_is_readonly, p_is_printer_friendly);
    end if;

    if (p_is_readonly or p_is_printer_friendly) then
      apex_plugin_util.print_hidden_if_readonly(p_item.name, p_value, p_is_readonly, p_is_printer_friendly);

      l_display_values := apex_plugin_util.get_display_data(
                            p_sql_statement => p_item.lov_definition,
                            p_min_columns => gco_min_lov_cols,
                            p_max_columns => gco_max_lov_cols,
                            p_component_name => p_item.name,
                            p_search_value_list => apex_util.string_to_table(p_value),
                            p_display_extra => p_item.lov_display_extra
                          );

      if l_display_values.count = 1 then
        apex_plugin_util.print_display_only(
          p_item_name => p_item.name,
          p_display_value => l_display_values(1),
          p_show_line_breaks => false,
          p_escape => p_item.escape_output,
          p_attributes => p_item.element_attributes
        );
      elsif l_display_values.count > 1 then
        htp.p('
          <ul id="' || p_item.name || '_DISPLAY"
            class="display_only ' || p_item.element_css_classes || '"' ||
            p_item.element_attributes || '>');

        for i in 1 .. l_display_values.count loop
          if p_item.escape_output then
            htp.p('<li>' || htf.escape_sc(l_display_values(i)) || '</li>');
          else
            htp.p('<li>' || l_display_values(i) || '</li>');
          end if;
        end loop;

        htp.p('</ul>');
      end if;

      return l_render_result;
    end if;

    apex_javascript.add_library(
      p_name => 'select2.full.min',
      p_directory => p_plugin.file_prefix,
      p_version => null
    );
    apex_javascript.add_library(
      p_name => 'select2-apex',
      p_directory => p_plugin.file_prefix,
      p_version => null
    );
    apex_css.add_file(
      p_name => 'select2.min',
      p_directory => p_plugin.file_prefix,
      p_version => null
    );
    if l_look_and_feel = 'UT' then
      apex_css.add_file(
        p_name => 'select2-ut',
        p_directory => p_plugin.file_prefix,
        p_version => null
      );
    end if;

    if l_select_list_type in ('MULTI', 'TAG') then
      l_multiselect := 'multiple="multiple"';
    end if;

    htp.p('
      <select ' || l_multiselect || '
        id="' || p_item.name || '"
        name="' || apex_plugin.get_input_name_for_page_item(true) || '"
        class="selectlist ' || p_item.element_css_classes || '"' ||
        p_item.element_attributes || '>');

    if (l_select_list_type = 'SINGLE' and p_item.lov_display_null) then
      apex_plugin_util.print_option(
        p_display_value => p_item.lov_null_text,
        p_return_value => p_item.lov_null_value,
        p_is_selected => false,
        p_attributes => p_item.element_option_attributes,
        p_escape => p_item.escape_output
      );
    end if;

    print_lov_options(p_item, p_plugin, p_value);

    htp.p('</select>');

    l_onload_code := get_select2_constructor;

    if l_drag_and_drop_sorting is not null then
      select substr(version_no, 1, 3)
      into l_apex_version
      from apex_release;

      if l_apex_version = '4.2' then
        apex_javascript.add_library(
          p_name => 'jquery.ui.sortable.min',
          p_directory => '#IMAGE_PREFIX#libraries/jquery-ui/1.8.22/ui/minified/',
          p_version => null
        );
      else
        apex_javascript.add_library(
          p_name => 'jquery.ui.sortable.min',
          p_directory => '#IMAGE_PREFIX#libraries/jquery-ui/1.10.4/ui/minified/',
          p_version => null
        );
      end if;

      l_onload_code := l_onload_code || get_sortable_constructor();
    end if;

    if p_item.lov_cascade_parent_items is not null then
      l_items_for_session_state_jq := l_cascade_parent_items_jq;

      if l_cascade_items_to_submit_jq is not null then
        l_items_for_session_state_jq := l_items_for_session_state_jq || ',' || l_cascade_items_to_submit_jq;
      end if;

      l_onload_code := l_onload_code || '
        $("' || l_cascade_parent_items_jq || '").on("change", function(e) {';

      if p_item.ajax_optimize_refresh then
        l_cascade_parent_items := apex_util.string_to_table(l_cascade_parent_items_jq, ',');

        l_optimize_refresh_condition := '$("' || l_cascade_parent_items(1) || '").val() === ""';

        for i in 2 .. l_cascade_parent_items.count loop
          l_optimize_refresh_condition := l_optimize_refresh_condition || ' || $("' || l_cascade_parent_items(i) || '").val() === ""';
        end loop;

        l_onload_code := l_onload_code || '
          var item = $("' || l_item_jq || '");
          if (' || l_optimize_refresh_condition || ') {
            item.val("").trigger("change");
          } else {';
      end if;

      l_onload_code := l_onload_code || '
            apex.server.plugin(
              "' || apex_plugin.get_ajax_identifier || '",
              { pageItems: "' || l_items_for_session_state_jq || '" },
              { refreshObject: "' || l_item_jq || '",
                loadingIndicator: "' || l_item_jq || '",
                loadingIndicatorPosition: "after",
                dataType: "text",
                success: function(pData) {
                           var item = $("' || l_item_jq || '");
                           item.html(pData);
                           item.val("").trigger("change");
                         }
              });';

      if p_item.ajax_optimize_refresh then
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
             p_item in apex_plugin.t_page_item,
             p_plugin in apex_plugin.t_plugin
           ) return apex_plugin.t_page_item_ajax_result is
    l_select_list_type gt_string := p_item.attribute_01;
    l_search_logic gt_string := p_item.attribute_08;
    l_lazy_append_row_count gt_string := p_item.attribute_15;

    l_lov apex_plugin_util.t_column_value_list;
    l_json gt_string;
    l_apex_plugin_search_logic gt_string;
    l_search_string gt_string;
    l_search_page number;
    l_first_row number;
    l_loop_count number;
    l_more_rows_boolean boolean;

    l_result apex_plugin.t_page_item_ajax_result;
  begin
    if apex_application.g_x03 = 'LAZY_LOAD' then
      l_search_string := nvl(apex_application.g_x01, '%');
      l_search_page := nvl(apex_application.g_x02, 1);
      l_first_row := ((l_search_page - 1) * nvl(l_lazy_append_row_count, 0)) + 1;

      -- translate Select2 search logic into APEX_PLUGIN_UTIL search logic
      -- the percentage wildcard returns all rows whenever the search string is null
      case l_search_logic
        when gco_contains_case_sensitive then
          l_apex_plugin_search_logic := apex_plugin_util.c_search_like_case; -- uses LIKE %value%
        when gco_exact_ignore_case then
          l_apex_plugin_search_logic := apex_plugin_util.c_search_exact_ignore; -- uses LIKE VALUE% with UPPER (not completely correct)
        when gco_exact_case_sensitive then
          l_apex_plugin_search_logic := apex_plugin_util.c_search_lookup; -- uses = value
        when gco_starts_with_ignore_case then
          l_apex_plugin_search_logic := apex_plugin_util.c_search_exact_ignore; -- uses LIKE VALUE% with UPPER
        when gco_starts_with_case_sensitive then
          l_apex_plugin_search_logic := apex_plugin_util.c_search_exact_case; -- uses LIKE value%
        else
          l_apex_plugin_search_logic := apex_plugin_util.c_search_like_ignore; -- uses LIKE %VALUE% with UPPER
      end case;

      l_lov := apex_plugin_util.get_data(
                 p_sql_statement => p_item.lov_definition,
                 p_min_columns => gco_min_lov_cols,
                 p_max_columns => gco_max_lov_cols,
                 p_component_name => p_item.name,
                 p_search_type => l_apex_plugin_search_logic,
                 p_search_column_no => gco_lov_display_col,
                 p_search_string => apex_plugin_util.get_search_string(
                                      p_search_type => l_apex_plugin_search_logic,
                                      p_search_string => l_search_string
                                    ),
                 p_first_row => l_first_row,
                 p_max_rows => l_lazy_append_row_count + 1
               );

      if l_lov(gco_lov_return_col).count = l_lazy_append_row_count + 1 then
        l_loop_count := l_lov(gco_lov_return_col).count - 1;
      else
        l_loop_count := l_lov(gco_lov_return_col).count;
      end if;

      l_json := '{"row":[';

      if p_item.escape_output then
        for i in 1 .. l_loop_count loop
          l_json := l_json || '{' ||
            apex_javascript.add_attribute('R', htf.escape_sc(l_lov(gco_lov_return_col)(i)), false, true) ||
            apex_javascript.add_attribute('D', htf.escape_sc(l_lov(gco_lov_display_col)(i)), false, false) ||
          '},';
        end loop;
      else
        for i in 1 .. l_loop_count loop
          l_json := l_json || '{' ||
            apex_javascript.add_attribute('R', l_lov(gco_lov_return_col)(i), false, true) ||
            apex_javascript.add_attribute('D', l_lov(gco_lov_display_col)(i), false, false) ||
          '},';
        end loop;
      end if;

      l_json := rtrim(l_json, ',');

      if l_lov(gco_lov_return_col).exists(l_lazy_append_row_count + 1) then
        l_more_rows_boolean := true;
      else
        l_more_rows_boolean := false;
      end if;

      l_json := l_json || '],' || apex_javascript.add_attribute('more', l_more_rows_boolean, true, false) || '}';

      htp.p(l_json);
    else
      print_lov_options(p_item, p_plugin);
    end if;

    return l_result;
  end ajax;

end select2;