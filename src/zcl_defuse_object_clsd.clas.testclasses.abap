*"* use this source file for your ABAP unit test classes

class test_search_up definition for testing risk level harmless duration medium.
  private section.
    methods:
      own_method for testing,
      no_circular_reference for testing,
      program for testing,
      function_signature for testing,
      function_code for testing,
      class_attribute for testing,
      class_method_signature for testing,
      class_method_code for testing,
      child_class for testing,
      interface_attribute for testing,
      interface_method_code for testing,
      type_pool for testing,
      ddic_table for testing,
      ddic_table_type for testing,
      web_dynpro for testing.
endclass.

class test_search_up implementation.
  method own_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    data(lo_obj) = cast zif_defuse_object(
      new zcl_defuse_object_clsd( 'CL_GUI_CALENDAR' ) ).
    lo_obj->parent = lo_defuse.
    data(lt_objects) = lo_obj->search_up( ).

    loop at lt_objects assigning field-symbol(<object>).
      if <object>->id-obj_name = 'CL_GUI_CALENDAR=>SET_SELECTION'.
        return. "// OK
      endif.
    endloop.
    cl_aunit_assert=>fail( 'Own method not found' ).
  endmethod.

  method no_circular_reference.
    "// When searching up, the class reference can only appear if the parent node
    "//  is not already the same class definition
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2. "2 pass
    data(lo_obj) = cast zif_defuse_object(
      new zcl_defuse_object_clsd( 'CL_T100_MESSAGE' ) ).
    lo_obj->parent = lo_defuse.
    data(lt_objects) = lo_obj->search_up( ).

    loop at lt_objects assigning field-symbol(<object>).
      if <object>->id-obj_name = 'CL_T100_MESSAGE'.
        cl_aunit_assert=>fail( 'Circular reference found!' ).
      endif.
    endloop.
  endmethod.

  method program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_GUI_CALENDAR' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'RSDEMO_CALENDAR_CONTROL' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'PROG' obj_name = 'SAPCALENDAR_DEMO1' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function_signature.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_DYNP_TREE_DME' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'SDME_DLG_DOCK_TREE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function_code.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_ERP_EHP_SWITCH_CHECK' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'MRM_INVOICE_CHECK' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_attribute.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_GUI_CALENDAR' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_DB6_CALENDAR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_method_signature.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_T100_MESSAGE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_MSG_TESTER=>TEST1_T100' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_method_code.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_T100_MESSAGE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METHOD' obj_name = 'CL_MESSAGE=>CREATE_FOR_EXCEPTION' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method child_class.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_T100_MESSAGE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_MESSAGE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method interface_attribute.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'ZCL_DEFUSE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'INTF' obj_name = 'ZIF_DEFUSE_OBJECT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method interface_method_code.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_T100_MESSAGE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_CTS_ORGANIZER_WD_MAIN=>IF_CTS_ORGANIZER_WD_MAIN~NAVIGATE_ON_MESSAGE_AREA' ]
      to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method type_pool.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_GUI_DYNPRO_COMPANION' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TYPE' obj_name = 'CNTL' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method ddic_table.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_ABAP_DB_X_WRITER' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TABL' obj_name = 'AUDDS_LOHS_FOR_TB1' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method ddic_table_type.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_BUKF_KF' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TTYP' obj_name = 'BUKF_T_KF_REF' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method web_dynpro.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_DBA_XPLM_COLUMN' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'WDYN' obj_name = 'DBA_ACTION_ACCESS_PLAN' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.

"//--------------------------------------------------------------------

class test_search_down_def definition for testing risk level harmless duration medium.
  private section.
    methods:
      own_method for testing,
      no_circular_reference for testing,
      data_element for testing,
      ddic_structure for testing,
      ddic_table_type for testing,
      type_pool for testing,
      class_type for testing,
      super_class for testing,
      class_reference for testing,
      class_constant for testing,
      interface_implementation for testing,
      interface_reference for testing.
endclass.

class test_search_down_def implementation.
  method own_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    data(lo_obj) = cast zif_defuse_object(
      new zcl_defuse_object_clsd( 'CL_GUI_CALENDAR' ) ).
    lo_obj->parent = lo_defuse.
    data(lt_objects) = lo_obj->search_down( ).

    loop at lt_objects assigning field-symbol(<object>).
      if <object>->id-obj_name = 'CL_GUI_CALENDAR=>SET_SELECTION'.
        return. "// OK
      endif.
    endloop.
    cl_aunit_assert=>fail( 'Own method not found' ).
  endmethod.

  method no_circular_reference.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2. "2 pass
    data(lo_obj) = cast zif_defuse_object(
      new zcl_defuse_object_clsd( 'CL_T100_MESSAGE' ) ).
    lo_obj->parent = lo_defuse.
    data(lt_objects) = lo_obj->search_down( ).

    loop at lt_objects assigning field-symbol(<object>).
      if <object>->id-obj_name = 'CL_T100_MESSAGE'.
        cl_aunit_assert=>fail( 'Circular reference found!' ).
      endif.
    endloop.
  endmethod.

  method data_element.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_DBA_XPLM_COLUMN' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TTYP' obj_name = 'DBAXPLNDET_TAB' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method ddic_structure.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_DB_CUSTOMIZING_MMSRV' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TABL' obj_name = 'EBAN' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'TABL' obj_name = 'T141' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method ddic_table_type.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_DBA_XPLM_OBJECT' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TTYP' obj_name = 'DBAXPLNDET_TAB' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method type_pool.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_DBA_XPLM_COLUMN' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TYPE' obj_name = 'ABAP' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_type.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'INTF' obj_name = 'IF_NWBC_RUNTIME' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_URL' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method super_class.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_DBA_XPLM_COLUMN' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_DBA_XPLM_OBJECT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_reference.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_DBA_XPLM_OBJECT' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_DBA_EXPLAIN_OBJECT_EXT_DATA' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_constant.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'INTF' obj_name = 'IF_WDR_CFG_CONSTANTS' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_ABAP_CHAR_UTILITIES' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method interface_implementation.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_ACO_USER_GROUP' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'INTF' obj_name = 'IF_ACO_MEMBER_INFO' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method interface_reference.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_HRECM00_T002' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'INTF' obj_name = 'IF_HRPA_MESSAGE_HANDLER' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.

"//--------------------------------------------------------------------

class test_search_down_imp definition for testing risk level harmless.
  private section.
    methods:
      attributes for testing,
      methods for testing,
      inherited_methods for testing,
      redefined_methods for testing,
      interface_methods for testing,
      interface_methods_alias for testing,
      types for testing.
endclass.

class test_search_down_imp implementation.
  method attributes.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_T100_MESSAGE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_SAPSCRIPT_LONGTEXT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method methods.
    data(lo_clsd) = cast zif_defuse_object( new zcl_defuse_object_clsd( 'CL_GUI_CALENDAR' ) ).
    lo_clsd->parent = new zcl_defuse( ).
    lo_clsd->parent->filter_standard_objects = abap_false.
    data(lt_objects) = lo_clsd->search_down( ).

    data(lv_found) = 0.
    loop at lt_objects assigning field-symbol(<object>).
      if ( <object>->id-object = 'METH' and <object>->id-obj_name = 'CL_GUI_CALENDAR=>SET_SELECTION' ).
        add 1 to lv_found.
      endif.
    endloop.
    cl_aunit_assert=>assert_equals( exp = 1 act = lv_found ).
  endmethod.

  method inherited_methods.
    data(lo_clsd) = cast zif_defuse_object( new zcl_defuse_object_clsd( 'CL_GUI_CALENDAR' ) ).
    lo_clsd->parent = new zcl_defuse( ).
    lo_clsd->parent->filter_standard_objects = abap_false.
    data(lt_objects) = lo_clsd->search_down( ).

    "// Inherited (not redefined) methods should not appear here
    data(lv_found) = 0.
    loop at lt_objects assigning field-symbol(<object>).
      if ( <object>->id-object = 'METH' and <object>->id-obj_name = 'CL_GUI_CALENDAR=>FREE' ).
        add 1 to lv_found.
      endif.
    endloop.
    cl_aunit_assert=>assert_equals( exp = 0 act = lv_found ).
  endmethod.

  method redefined_methods.
    data(lo_clsd) = cast zif_defuse_object( new zcl_defuse_object_clsd( 'CL_GUI_MOVIE' ) ).
    lo_clsd->parent = new zcl_defuse( ).
    lo_clsd->parent->filter_standard_objects = abap_false.
    data(lt_objects) = lo_clsd->search_down( ).

    data(lv_found) = 0.
    loop at lt_objects assigning field-symbol(<object>).
      if ( <object>->id-object = 'METH' and <object>->id-obj_name = 'CL_GUI_MOVIE=>DISPATCH' ).
        add 1 to lv_found.
      endif.
    endloop.
    cl_aunit_assert=>assert_equals( exp = 1 act = lv_found ).
  endmethod.

  method interface_methods.
    data(lo_clsd) = cast zif_defuse_object( new zcl_defuse_object_clsd( 'CL_ABAP_STRING_C_WRITER' ) ).
    lo_clsd->parent = new zcl_defuse( ).
    lo_clsd->parent->filter_standard_objects = abap_false.
    data(lt_objects) = lo_clsd->search_down( ).

    data(lv_found) = 0.
    loop at lt_objects assigning field-symbol(<object>).
      if ( <object>->id-object = 'INTF' and <object>->id-obj_name = 'IF_ABAP_STRING_WRITER' ) or
         ( <object>->id-object = 'METH' and <object>->id-obj_name = 'CL_ABAP_STRING_C_WRITER=>IF_ABAP_MEMORY_WRITER~GET_RESULT_TYPE' ).
        add 1 to lv_found.
      endif.
    endloop.
    cl_aunit_assert=>assert_equals( exp = 2 act = lv_found ).
  endmethod.

  method interface_methods_alias.
    data(lo_clsd) = cast zif_defuse_object( new zcl_defuse_object_clsd( 'CL_HTTP_CLIENT' ) ).
    lo_clsd->parent = new zcl_defuse( ).
    lo_clsd->parent->filter_standard_objects = abap_false.
    data(lt_objects) = lo_clsd->search_down( ).

    data(lv_found) = 0.
    loop at lt_objects assigning field-symbol(<object>).
      if ( <object>->id-object = 'INTF' and <object>->id-obj_name = 'IF_HTTP_CLIENT' ) or
         ( <object>->id-object = 'METH' and <object>->id-obj_name = 'CL_HTTP_CLIENT=>SEND' ).
        add 1 to lv_found.
      endif.
    endloop.
    cl_aunit_assert=>assert_equals( exp = 2 act = lv_found ).
  endmethod.

  method types.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'CLSD' obj_name = 'CL_ABAP_COMPILER' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TABL' obj_name = 'CL_ABAP_COMPILER=>T_REF' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'TTYP' obj_name = 'CL_ABAP_COMPILER=>T_ALL_REFS' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
