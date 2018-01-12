# Select2 APEX Plugin

The Select2 plugin is a jQuery based replacement for select lists in Oracle Application Express.
It supports searching, multiselection, tagging, lazy loading and infinite scrolling of results.

## About

This is a fork of great [Select2 APEX Plugin](https://github.com/nbuytaert1/apex-select2) adapted for using with *Interactive Grid*.

A demo can be found [here](https://apex.oracle.com/pls/apex/f?p=106000).
Sample application to analyse is located in repository. 

## Installation

Install SELECT2 - PL/SQL package from *\src\main\plsql*

* select2.pks.sql
* select2.pkb.sql

Grant necessary rights:

*GRANT EXECUTE ON SELECT2 TO #USER#;*

Where *#USER#* should be replaced to APEX Application Parsing Schema.

Install plugin from *\src\main\plugin*

* item_type_plugin_be_ctb_select2.sql

like described in [documentation](https://docs.oracle.com/cd/E59726_01/doc.50/e39147/deploy_import.htm#HTMDB26010)


## Known issues

* All columns listed in "Cascading LOV Parent Column(s)" should have Static ID's. 
* SQL-queries referenced to the other columns should return all the data if such columns listed in "Cascading LOV Parent Column(s)" have a null value(s)

   select descr,
          id
   from (select 'Alexander' as descr,
         'A1' as id,
         'A' as parent_id 
         from dual)
   where instr(:FIRST_LETTER,parent_id) > 0
      or :FIRST_LETTER is null -- !important

## Current version

4.0.0.

## License

See LICENSE.md
