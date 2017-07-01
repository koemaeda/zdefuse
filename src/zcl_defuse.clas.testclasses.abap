*"* use this source file for your ABAP unit test classes

class test_ddic_objects definition for testing risk level harmless inheriting from zcl_defuse.
  private section.
    methods:
      setup,
      ddic_structure for testing,
      ddic_table for testing,
      ddic_table_type for testing,
      class_public_type for testing,
      class_private_type for testing,
      class_table for testing,
      typepool_type for testing,
      typepool_struct for testing,
      typepool_table for testing.
endclass.

class test_ddic_objects implementation.
  method setup.
    me->filter_standard_objects = abap_false.
    me->max_depth = 0.
  endmethod.

  method ddic_structure.
    data(lo_obj) = me->create_ddic_object( 'BAPIRETURN' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TABL' act = lo_obj->id-object ).
  endmethod.

  method ddic_table.
    data(lo_obj) = me->create_ddic_object( 'SFLIGHT' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TABL' act = lo_obj->id-object ).
  endmethod.

  method ddic_table_type.
    data(lo_obj) = me->create_ddic_object( 'BAPIRET2_TAB' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TTYP' act = lo_obj->id-object ).
  endmethod.

  method class_public_type.
    data(lo_obj) = me->create_ddic_object( 'CL_ABAP_COMPILER=>T_REF' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TABL' act = lo_obj->id-object ).
  endmethod.

  method class_private_type.
    data(lo_obj) = me->create_ddic_object( 'CL_GUI_ALV_GRID=>L_TYPE_S_SEARCH' ).
    cl_aunit_assert=>assert_initial( lo_obj ).
  endmethod.

  method class_table.
    data(lo_obj) = me->create_ddic_object( 'CL_WD_FLIGHT_MODEL=>TT_SCARR' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TTYP' act = lo_obj->id-object ).
  endmethod.

  method typepool_type.
    data(lo_obj) = me->create_ddic_object( 'CNHE_HTML_TEXT' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TYPE' act = lo_obj->id-object ).
    cl_aunit_assert=>assert_equals( exp = 'CNHE' act = lo_obj->id-obj_name ).
  endmethod.

  method typepool_struct.
    data(lo_obj) = me->create_ddic_object( 'CNHE_USER_ACTION' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TYPE' act = lo_obj->id-object ).
    cl_aunit_assert=>assert_equals( exp = 'CNHE' act = lo_obj->id-obj_name ).
  endmethod.

  method typepool_table.
    data(lo_obj) = me->create_ddic_object( 'CNHE_ITAB_ACTIONS' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TYPE' act = lo_obj->id-object ).
    cl_aunit_assert=>assert_equals( exp = 'CNHE' act = lo_obj->id-obj_name ).
  endmethod.
endclass.


class test_includes definition for testing risk level harmless inheriting from zcl_defuse.
  private section.
    methods:
      setup,
      report for testing,
      include for testing,
      module_pool for testing,
      function_module for testing,
      function_group for testing,
      type_pool for testing,
      class_section for testing,
      class_method for testing.
endclass.

class test_includes implementation.
  method setup.
    me->filter_standard_objects = abap_false.
    me->max_depth = 0.
  endmethod.

  method report.
    data(lo_obj) = me->create_object_for_include( 'RSHOWTIM' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'PROG' act = lo_obj->id-object ).
  endmethod.

  method include.
    data(lo_obj) = me->create_object_for_include( '<ICON>' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'REPS' act = lo_obj->id-object ).

    lo_obj = me->create_object_for_include( 'LSNI_ADDRTOP' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'REPS' act = lo_obj->id-object ).
  endmethod.

  method module_pool.
    data(lo_obj) = me->create_object_for_include( 'RSJAVA2ABAP' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'PROG' act = lo_obj->id-object ).
  endmethod.

  method function_module.
    data(lo_obj) = me->create_object_for_include( 'LSNI_ADDRU01' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'FUNC' act = lo_obj->id-object ).
  endmethod.

  method function_group.
    data(lo_obj) = me->create_object_for_include( 'SAPLSNI_ADDR' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'FUGR' act = lo_obj->id-object ).
  endmethod.

  method type_pool.
    data(lo_obj) = me->create_object_for_include( '%_CABAP' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TYPE' act = lo_obj->id-object ).
  endmethod.

  method class_section.
    data(lo_obj) = me->create_object_for_include( 'CL_AUNIT_ASSERT===============CCDEF' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'CLSD' act = lo_obj->id-object ).

    "// long class names
    lo_obj = me->create_object_for_include( 'CL_SOAP_MAPPING_OUTBOUND_ASYNCCCDEF' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'CLSD' act = lo_obj->id-object ).
  endmethod.

  method class_method.
    data(lo_obj) = me->create_object_for_include( 'CL_AUNIT_ASSERT===============CM002' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'METH' act = lo_obj->id-object ).

    "// different name patterns
    lo_obj = me->create_object_for_include( 'CL_HCP_DETAIL_PLANNING_ACTION=CM02I' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'METH' act = lo_obj->id-object ).
  endmethod.
endclass.


class test_performance definition for testing risk level harmless duration long inheriting from zcl_defuse.
  private section.
    methods:
      recursion_limit for testing,
      object_lightweight for testing,
      standard_obj_filtering for testing.
endclass.

class test_performance implementation.
  method recursion_limit.
    "// We will test with Maximum depth = 2
    "// Effectively, this tree will have 3 layers:
    "//     (root) <-> (0) <-> (1)
    "// Scenario:
    "//  [FUNC] FAGL_RWIN_SPLIT
    "//    --> [METH] CL_FAGL_SPLIT_SERVICES=>GET_VALIDATION_MODE
    "//          --> [TABL] FAGL_VAL_PROCESS
    "//                --> [DTEL] SYBINPT

    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'DTEL' obj_name = 'SYBINPT' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_FAGL_SPLIT_SERVICES=>GET_VALIDATION_MODE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'FUNC' obj_name = 'FAGL_RWIN_SPLIT' ] to <object>.
    cl_aunit_assert=>assert_not_initial( sy-subrc ). "// must not exist
  endmethod.

  method object_lightweight.
    "// Both classes have the same mother class.
    "// The object reference in the tree nodes of both roots must be the same
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #(
      ( object = 'CLSD' obj_name = 'CL_T100_MESSAGE' )
      ( object = 'CLSD' obj_name = 'CL_FREETEXT_MESSAGE' ) ) ).

    data(ls_id) = value zcl_defuse=>ty_object_id(
      pgmid = 'LIMU' object = 'CLSD' obj_name = 'CL_MESSAGE' ).
    field-symbols: <node1> type zcl_defuse=>ty_node,
                   <node2> type zcl_defuse=>ty_node.

    loop at lo_defuse->down_tree-root_nodes[ 1 ]-children assigning field-symbol(<child>).
      assign <child>->* to <node1>.
      if <node1>-id = ls_id.
        exit.
      endif.
    endloop.
    cl_aunit_assert=>assert_initial( sy-subrc ).
    cl_aunit_assert=>assert_equals( act = <node1>-id exp = ls_id ).

    loop at lo_defuse->down_tree-root_nodes[ 2 ]-children assigning <child>.
      assign <child>->* to <node2>.
      if <node2>-id = ls_id.
        exit.
      endif.
    endloop.
    cl_aunit_assert=>assert_initial( sy-subrc ).
    cl_aunit_assert=>assert_equals( act = <node2>-id exp = ls_id ).

    cl_aunit_assert=>assert_equals( act = <node1>-ref exp = <node2>-ref ).
  endmethod.

  method standard_obj_filtering.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'DTEL' obj_name = 'SYBINPT' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).
    cl_aunit_assert=>assert_initial( lt_objects ).
  endmethod.
endclass.


class test_paths definition for testing risk level harmless duration short.
  private section.
    methods:
      up for testing,
      down for testing,
      up_and_down for testing,
      up_method_to_classdef for testing,
      up_method_to_method for testing,
      down_method_to_classdef for testing,
      down_method_to_method for testing.
endclass.

class test_paths implementation.
  method up.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' ) ) ).

    data(lt_paths) = lo_defuse->get_object_paths( value #( object = 'METH' obj_name = 'CL_MI_PACKAGE_GENERATION=>UPDATE_PACKAGE' ) ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( lt_paths ) ).
    assign lt_paths[ 1 ] to field-symbol(<path>).

    cl_aunit_assert=>assert_equals( exp = 'LIMU' act = <path>-id_from-pgmid ).
    cl_aunit_assert=>assert_equals( exp = 'METH' act = <path>-id_from-object ).
    cl_aunit_assert=>assert_equals( exp = 'CL_MI_PACKAGE_GENERATION=>UPDATE_PACKAGE' act = <path>-id_from-obj_name ).
    cl_aunit_assert=>assert_equals( exp = 2 act = <path>-depth ).

    cl_aunit_assert=>assert_equals( exp = 3 act = lines( <path>-parts ) ).
    cl_aunit_assert=>assert_equals( exp = 'CL_MI_PACKAGE_GENERATION=>UPDATE_PACKAGE' act = <path>-parts[ 1 ]-obj_name ).
    cl_aunit_assert=>assert_equals( exp = 'CL_MI_PACKAGE_GENERATION=>SET_BAPIRETURN' act = <path>-parts[ 2 ]-obj_name ).
    cl_aunit_assert=>assert_equals( exp = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' act = <path>-parts[ 3 ]-obj_name ).
  endmethod.

  method down.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_MI_PACKAGE_GENERATION=>UPDATE_PACKAGE' ) ) ).

    data(lt_paths) = lo_defuse->get_object_paths( value #( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' ) ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( lt_paths ) ).
    assign lt_paths[ 1 ] to field-symbol(<path>).

    cl_aunit_assert=>assert_equals( exp = 'LIMU' act = <path>-id_from-pgmid ).
    cl_aunit_assert=>assert_equals( exp = 'METH' act = <path>-id_from-object ).
    cl_aunit_assert=>assert_equals( exp = 'CL_MI_PACKAGE_GENERATION=>UPDATE_PACKAGE' act = <path>-id_from-obj_name ).
    cl_aunit_assert=>assert_equals( exp = 2 act = <path>-depth ).

    cl_aunit_assert=>assert_equals( exp = 3 act = lines( <path>-parts ) ).
    cl_aunit_assert=>assert_equals( exp = 'CL_MI_PACKAGE_GENERATION=>UPDATE_PACKAGE' act = <path>-parts[ 1 ]-obj_name ).
    cl_aunit_assert=>assert_equals( exp = 'CL_MI_PACKAGE_GENERATION=>SET_BAPIRETURN' act = <path>-parts[ 2 ]-obj_name ).
    cl_aunit_assert=>assert_equals( exp = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' act = <path>-parts[ 3 ]-obj_name ).
  endmethod.

  method up_and_down.
    "// We would have 4 possible paths here, but we only keep the shortest
    "//  paths from an ID to another ID, so the expected result is only 2
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #(
      ( object = 'FUNC' obj_name = 'MI_PACKAGE_GETDETAIL' )
      ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' )
    ) ).

    data(lt_paths) = lo_defuse->get_object_paths( value #( object = 'METH' obj_name = 'CL_MI_PACKAGE_GENERATION=>SET_BAPIRETURN' ) ).
    cl_aunit_assert=>assert_equals( exp = 2 act = lines( lt_paths ) ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lt_paths[ 1 ]-depth ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lt_paths[ 2 ]-depth ).
  endmethod.

  method up_method_to_classdef.
    "// Paths from a method that lead FIRST to a class definition can not mention the latter's methods
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' ) ) ).

    data(lt_paths) = lo_defuse->get_object_paths( value #( object = 'METH' obj_name = 'CL_SAPSCRIPT_LONGTEXT=>ACCOMMODATE_T100_PLACEHOLDERS' ) ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( lt_paths ) ).
    assign lt_paths[ 1 ] to field-symbol(<path>).

    cl_aunit_assert=>assert_equals( exp = 2 act = lines( <path>-parts ) ).
    cl_aunit_assert=>assert_equals( exp = 'CL_SAPSCRIPT_LONGTEXT=>ACCOMMODATE_T100_PLACEHOLDERS' act = <path>-parts[ 1 ]-obj_name ).
    cl_aunit_assert=>assert_equals( exp = 'CL_T100_MESSAGE' act = <path>-parts[ 2 ]-obj_name ).
  endmethod.

  method up_method_to_method.
    "// Paths from a method that lead FIRST to another method can not mention the latter's class definition
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' ) ) ).

    data(lt_paths) = lo_defuse->get_object_paths( value #( object = 'METH' obj_name = 'CL_MI_PACKAGE_GENERATION=>SET_BAPIRETURN' ) ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( lt_paths ) ).
    assign lt_paths[ 1 ] to field-symbol(<path>).

    cl_aunit_assert=>assert_equals( exp = 2 act = lines( <path>-parts ) ).
    cl_aunit_assert=>assert_equals( exp = 'CL_MI_PACKAGE_GENERATION=>SET_BAPIRETURN' act = <path>-parts[ 1 ]-obj_name ).
    cl_aunit_assert=>assert_equals( exp = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' act = <path>-parts[ 2 ]-obj_name ).
  endmethod.

  method down_method_to_classdef.
    "// Paths to a class method that lead FIRST to its definition can not mention the method name
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_SAPSCRIPT_LONGTEXT=>ACCOMMODATE_T100_PLACEHOLDERS' ) ) ).

    data(lt_paths) = lo_defuse->get_object_paths( value #( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' ) ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( lt_paths ) ).
    assign lt_paths[ 1 ] to field-symbol(<path>).

    cl_aunit_assert=>assert_equals( exp = 2 act = lines( <path>-parts ) ).
    cl_aunit_assert=>assert_equals( exp = 'CL_SAPSCRIPT_LONGTEXT=>ACCOMMODATE_T100_PLACEHOLDERS' act = <path>-parts[ 1 ]-obj_name ).
    cl_aunit_assert=>assert_equals( exp = 'CL_T100_MESSAGE' act = <path>-parts[ 2 ]-obj_name ).
  endmethod.

  method down_method_to_method.
    "// Paths to a method that lead FIRST to another method can not mention the latter's class definition
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_MI_PACKAGE_GENERATION=>SET_BAPIRETURN' ) ) ).

    data(lt_paths) = lo_defuse->get_object_paths( value #( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' ) ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( lt_paths ) ).
    assign lt_paths[ 1 ] to field-symbol(<path>).

    cl_aunit_assert=>assert_equals( exp = 2 act = lines( <path>-parts ) ).
    cl_aunit_assert=>assert_equals( exp = 'CL_MI_PACKAGE_GENERATION=>SET_BAPIRETURN' act = <path>-parts[ 1 ]-obj_name ).
    cl_aunit_assert=>assert_equals( exp = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' act = <path>-parts[ 2 ]-obj_name ).
  endmethod.
endclass.


class test_check_list definition for testing risk level harmless duration short.
  private section.
    methods:
      program_source for testing,
      table_definition for testing,
      data_element_definition for testing,
      domain_definition for testing,
      class_parts for testing.
endclass.

class test_check_list implementation.
  method program_source.
    "// Root node:   Can not check:
    "// LIMU REPS => R3TR PROG
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'REPS' obj_name = 'RSHOWTIM' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'PROG' obj_name = 'RSHOWTIM' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_not_initial( sy-subrc ).

    "// Root node:   Can not check:
    "// R3TR PROG => LIMU REPS
    lo_defuse = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'PROG' obj_name = 'RSHOWTIM' ) ) ).
    lt_objects = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'REPS' obj_name = 'RSHOWTIM' ] to <object>.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
  endmethod.

  method table_definition.
    "// Root node:   Can not check:
    "// LIMU TABD => R3TR TABL
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TABD' obj_name = 'USR41' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'TABL' obj_name = 'USR41' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_not_initial( sy-subrc ).

    "// Root node:   Can not check:
    "// R3TR TABL => LIMU TABD
    lo_defuse = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TABL' obj_name = 'USR41' ) ) ).
    lt_objects = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'TABD' obj_name = 'USR41' ] to <object>.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
  endmethod.

  method data_element_definition.
    "// Root node:   Can not check:
    "// LIMU DTED => R3TR DTEL
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'DTED' obj_name = 'XUTERMINAL' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'DTEL' obj_name = 'XUTERMINAL' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_not_initial( sy-subrc ).

    "// Root node:   Can not check:
    "// R3TR DTEL => LIMU DTED
    lo_defuse = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'DTEL' obj_name = 'XUTERMINAL' ) ) ).
    lt_objects = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'DTED' obj_name = 'XUTERMINAL' ] to <object>.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
  endmethod.

  method domain_definition.
    "// Root node:   Can not check:
    "// LIMU DOMD => R3TR DOMA
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'DOMD' obj_name = 'XUTERMINAL' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'DOMA' obj_name = 'XUTERMINAL' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_not_initial( sy-subrc ).

    "// Root node:   Can not check:
    "// R3TR DOMA => LIMU DOMD
    lo_defuse = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'DOMA' obj_name = 'XUTERMINAL' ) ) ).
    lt_objects = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'DOMD' obj_name = 'XUTERMINAL' ] to <object>.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
  endmethod.

  method class_parts.
    "// Root node:   Can not check:
    "// LIMU METH => R3TR CLAS
    "//              But must check the parent LIMU CLSD
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>CONSTRUCTOR' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'CLAS' obj_name = 'CL_T100_MESSAGE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
    assign lt_objects[ object = 'CLSD' obj_name = 'CL_T100_MESSAGE' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).

    "// Root node:   Can not check:
    "// R3TR CLAS => LIMU CLSD
    "//              LIMU METH
    lo_defuse = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLAS' obj_name = 'CL_SAPSCRIPT_LONGTEXT' ) ) ).
    lo_defuse->add_objects( value #( ( object = 'CLAS' obj_name = 'CL_T100_MESSAGE' ) ) ).
    lt_objects = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'CLSD' obj_name = 'CL_T100_MESSAGE' ] to <object>.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
    assign lt_objects[ object = 'METH' obj_name = 'CL_T100_MESSAGE=>CONSTRUCTOR' ] to <object>.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
    assign lt_objects[ object = 'METH' obj_name = 'CL_SAPSCRIPT_LONGTEXT=>CREATE_FOR_MESSAGE' ] to <object>.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).

    "// Root node:   Can not check:
    "// LIMU CLSD => R3TR CLAS
    "//              LIMU METH
    lo_defuse = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_T100_MESSAGE' ) ) ).
    lt_objects = lo_defuse->get_objects_to_check( ).
    assign lt_objects[ object = 'CLAS' obj_name = 'CL_T100_MESSAGE' ] to <object>.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
    assign lt_objects[ object = 'METH' obj_name = 'CL_T100_MESSAGE=>CONSTRUCTOR' ] to <object>.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
  endmethod.
endclass.


class test_comparison definition for testing risk level harmless duration short inheriting from zcl_defuse.
  private section.
    methods:
      different_program for testing,
      different_class for testing,
      different_method for testing,
      different_table for testing,
      different_data_element for testing,
      risk_level_safe for testing,
      risk_level_warnings for testing,
      risk_level_risky for testing,
      risk_level_dangerous for testing,
      risk_level_unknown for testing.
endclass.

class test_comparison implementation.
  method different_program.
    data(lo_comparer) = new zcl_defuse_mock_comparer( ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' ) ) ).

    lo_comparer->different = value #( ( pgmid = 'LIMU' object = 'REPS' obj_name = 'RPUBWSB0_F01' ) ).

    "// Different objects out of the input list
    data(ls_results) = lo_defuse->run( 'MOCK' ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( ls_results-different_objects ) ).

    "// Different objects in the input list
    lo_defuse = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #(
      ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' )
      ( object = 'REPS' obj_name = 'RPUBWSB0_F01' )
    ) ).
    ls_results = lo_defuse->run( 'MOCK' ).

    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-different_objects ) ).
  endmethod.

  method different_class.
    data(lo_comparer) = new zcl_defuse_mock_comparer( ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' ) ) ).

    lo_comparer->different = value #( ( pgmid = 'LIMU' object = 'CLSD' obj_name = 'CL_MSG_TESTER' ) ).

    "// Different objects out of the input list
    data(ls_results) = lo_defuse->run( 'MOCK' ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( ls_results-different_objects ) ).

    "// Different objects in the input list
    lo_defuse = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #(
      ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' )
      ( object = 'CLSD' obj_name = 'CL_MSG_TESTER' )
    ) ).
    ls_results = lo_defuse->run( 'MOCK' ).

    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-different_objects ) ).
  endmethod.

  method different_method.
    data(lo_comparer) = new zcl_defuse_mock_comparer( ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' ) ) ).

    lo_comparer->different = value #( ( pgmid = 'LIMU' object = 'METH' obj_name = 'CL_MI_PACKAGE_GENERATION=>SET_BAPIRETURN' ) ).

    "// Different objects out of the input list
    data(ls_results) = lo_defuse->run( 'MOCK' ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( ls_results-different_objects ) ).

    "// Different objects in the input list
    lo_defuse = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #(
      ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' )
      ( object = 'METH' obj_name = 'CL_MI_PACKAGE_GENERATION=>SET_BAPIRETURN' )
    ) ).
    ls_results = lo_defuse->run( 'MOCK' ).

    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-different_objects ) ).
  endmethod.

  method different_table.
    data(lo_comparer) = new zcl_defuse_mock_comparer( ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'PROG' obj_name = 'RSPOPUP' ) ) ).

    lo_comparer->different = value #( ( pgmid = 'R3TR' object = 'TABL' obj_name = 'USR41' ) ).

    "// Different objects out of the input list
    data(ls_results) = lo_defuse->run( 'MOCK' ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( ls_results-different_objects ) ).

    "// Different objects in the input list
    lo_defuse = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #(
      ( object = 'PROG' obj_name = 'RSPOPUP' )
      ( object = 'TABL' obj_name = 'USR41' )
    ) ).
    ls_results = lo_defuse->run( 'MOCK' ).

    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-different_objects ) ).
  endmethod.

  method different_data_element.
    data(lo_comparer) = new zcl_defuse_mock_comparer( ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'TABL' obj_name = 'USR41' ) ) ).

    lo_comparer->different = value #( ( pgmid = 'R3TR' object = 'DTEL' obj_name = 'XUTERMID' ) ).

    "// Different objects out of the input list
    data(ls_results) = lo_defuse->run( 'MOCK' ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( ls_results-different_objects ) ).

    "// Different objects in the input list
    lo_defuse = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #(
      ( object = 'TABL' obj_name = 'USR41' )
      ( object = 'DTEL' obj_name = 'XUTERMID' )
    ) ).
    ls_results = lo_defuse->run( 'MOCK' ).

    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-different_objects ) ).
  endmethod.

  method risk_level_safe.
    data(lo_comparer) = new zcl_defuse_mock_comparer( ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLAS' obj_name = 'CL_T100_MESSAGE' ) ) ).

    "// Nothing is different
    data(ls_results) = lo_defuse->run( 'MOCK' ).
    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-messages ) ).
    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-different_objects ) ).
    cl_aunit_assert=>assert_equals( exp = zcl_defuse=>risk_safe act = ls_results-risk_level ).
  endmethod.

  method risk_level_warnings.
    data(lo_comparer) = new zcl_defuse_mock_comparer( ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.

    "// To cause a warning we need to make the Search find an unsupported object. Currently, this
    "// is done with a Transformation. In the future, if we implement support for transformations,
    "// this test will have to be rewritten.
    "//  Expect: R3TR XSLT SEC_DSIG_SIGNATURE_IN
    lo_defuse->add_objects( value #( ( object = 'PROG' obj_name = 'SECXML_DIGEST_READER' ) ) ).

    data(ls_results) = lo_defuse->run( 'MOCK' ).
    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-messages ) ).
    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-different_objects ) ).
    cl_aunit_assert=>assert_equals( exp = zcl_defuse=>risk_warnings act = ls_results-risk_level ).
  endmethod.

  method risk_level_risky.
    data(lo_comparer) = new zcl_defuse_mock_comparer( ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TABL' obj_name = 'USR41' ) ) ).

    lo_comparer->different = value #( ( pgmid = 'R3TR' object = 'DTEL' obj_name = 'XUTERMID' ) ).

    data(ls_results) = lo_defuse->run( 'MOCK' ).
    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-messages ) ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( ls_results-different_objects ) ).
    cl_aunit_assert=>assert_equals( exp = zcl_defuse=>risk_risky act = ls_results-risk_level ).
  endmethod.

  method risk_level_dangerous.
    data(lo_comparer) = new zcl_defuse_mock_comparer( ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TABL' obj_name = 'USR41' ) ) ).

    lo_comparer->not_found = value #( ( pgmid = 'R3TR' object = 'DTEL' obj_name = 'XUTERMID' ) ).

    data(ls_results) = lo_defuse->run( 'MOCK' ).
    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-messages ) ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( ls_results-different_objects ) ).
    cl_aunit_assert=>assert_equals( exp = zcl_defuse=>risk_dangerous act = ls_results-risk_level ).
  endmethod.

  method risk_level_unknown.
    data(lo_comparer) = new zcl_defuse_mock_comparer( ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->comparer = lo_comparer.
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_children = 5.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'PROG' obj_name = 'RSPOPUP' ) ) ).

    data(ls_results) = lo_defuse->run( 'MOCK' ).
    cl_aunit_assert=>assert_equals( exp = 0 act = lines( ls_results-messages ) ).
    cl_aunit_assert=>assert_equals( exp = 1 act = lines( ls_results-limited_objects ) ).
    cl_aunit_assert=>assert_equals( exp = zcl_defuse=>risk_unknown act = ls_results-risk_level ).
  endmethod.
endclass.
