*"* use this source file for your ABAP unit test classes

class test_naming definition for testing risk level harmless duration short inheriting from zcl_defuse.
  private section.
    methods:
      full_name for testing,
      simple_name for testing,
      invalid_name for testing,
      standard_name for testing,
      alias for testing.
endclass.

class test_naming implementation.
  method full_name.
    me->filter_standard_objects = abap_false.
    data(lo_obj) = create_object( value #( pgmid = 'LIMU' object = 'METH'
      obj_name = '\TY:CL_MSG_TESTER\ME:TEST1_T100' ) ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( act = lo_obj->id-obj_name exp = 'CL_MSG_TESTER=>TEST1_T100' ).

    lo_obj = create_object( value #( pgmid = 'LIMU' object = 'METH'
      obj_name = '\TY:CL_GUI_MOVIE\ME:GET_DURATION' ) ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( act = lo_obj->id-obj_name exp = 'CL_GUI_MOVIE=>GET_DURATION' ).

    lo_obj = create_object( value #( pgmid = 'LIMU' object = 'METH'
      obj_name = 'CL_GUI_OBJECT\IN:IF_CACHED_PROP\ME:SET_PROP' ) ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( act = lo_obj->id-obj_name exp = 'CL_GUI_OBJECT=>IF_CACHED_PROP~SET_PROP' ).
  endmethod.

  method simple_name.
    me->filter_standard_objects = abap_false.
    data(lo_obj) = create_object( value #( pgmid = 'LIMU' object = 'METH'
      obj_name = 'CL_MSG_TESTER=>TEST1_T100' ) ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( act = lo_obj->id-obj_name exp = 'CL_MSG_TESTER=>TEST1_T100' ).
  endmethod.

  method invalid_name.
    me->filter_standard_objects = abap_false.
    data(lo_obj) = create_object( value #( pgmid = 'LIMU' object = 'METH'
      obj_name = '\TY:CL_GUI_OBJECT\DA:ACTIVEX' ) ).
    cl_aunit_assert=>assert_initial( lo_obj ).
  endmethod.

  method standard_name.
    me->filter_standard_objects = abap_false.
    data(lo_obj) = create_object( value #( pgmid = 'LIMU' object = 'METH'
      obj_name = 'CL_MSG_TESTER                 TEST1_T100' ) ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( act = lo_obj->id-obj_name exp = 'CL_MSG_TESTER=>TEST1_T100' ).
  endmethod.

  method alias.
    me->filter_standard_objects = abap_false.
    data(lt_names) = cast zcl_defuse_object_meth(
      create_object( value #( pgmid = 'LIMU' object = 'METH'
        obj_name = 'CL_T100_MESSAGE=>GET_TEXT' ) )
      )->get_fullnames( ).

    assign lt_names[ table_line = '\TY:CL_T100_MESSAGE\ME:GET_TEXT' ] to field-symbol(<dummy>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_names[ table_line = '\TY:CL_T100_MESSAGE\IN:IF_MESSAGE\ME:GET_TEXT' ] to <dummy>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.


class test_search_up definition for testing risk level harmless duration medium.
  private section.
    methods:
      class_definition for testing,
      no_circular_reference for testing,
      program for testing,
      function for testing,
      class_method for testing,
      interface_method for testing,
      web_dynpro for testing.
endclass.

class test_search_up implementation.
  method class_definition.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_GUI_CALENDAR=>SET_SELECTION' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_GUI_CALENDAR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method no_circular_reference.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2. "2 pass
    data(lo_obj) = cast zif_defuse_object(
      new zcl_defuse_object_meth( 'CL_T100_MESSAGE=>CONSTRUCTOR' ) ).
    lo_obj->parent = lo_defuse.
    data(lt_objects) = lo_obj->search_up( ).

    read table lt_objects with key table_line->id-obj_name = 'CL_T100_MESSAGE=>CONSTRUCTOR'
      transporting no fields.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
  endmethod.

  method program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_GUI_CALENDAR=>SET_SELECTION' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'SAPCALENDAR_NAVIGATOR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_T100_MESSAGE=>IF_MESSAGE~GET_TEXT' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'MEMGMT_MOBILE_CONT_TYPE_GET' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_GUI_CALENDAR=>SET_SELECTION' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_CALENDAR_CONTROL=>SET_NAVIGATOR_INFO' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method interface_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_DMS_CNV_MULTILEVEL=>EXPLODE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_DMS_CNV_MULTILEVEL=>IF_DMS_CNV~XML_CREATE' ]
      to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method web_dynpro.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_ABAP_XSDTYPE_HELPER\ME:FROM_XSDQNAME' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'WDYN' obj_name = 'C_SRT_DEST_TEMP' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.


class test_search_down definition for testing risk level harmless duration medium.
  private section.
    methods:
      own_class_definition for testing,
      class_definition for testing,
      no_circular_reference for testing,
      no_redundant_definition for testing,
      signature_ddic for testing,
      program for testing,
      function for testing,
      class_method for testing.
endclass.

class test_search_down implementation.
  method own_class_definition.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_DMS_CNV_MULTILEVEL=>EXPLODE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_DMS_CNV_MULTILEVEL' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_definition.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_SAPSCRIPT_LONGTEXT=>ACCOMMODATE_T100_PLACEHOLDERS' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    "// There must be no method calls to cl_t100_message
    assign lt_objects[ object = 'CLSD' obj_name = 'CL_T100_MESSAGE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method no_circular_reference.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    data(lo_obj) = cast zif_defuse_object(
      new zcl_defuse_object_meth( 'CL_T100_MESSAGE=>CONSTRUCTOR' ) ).
    lo_obj->parent = lo_defuse.
    data(lt_objects) = lo_obj->search_down( ).

    read table lt_objects with key table_line->id-obj_name = 'CL_T100_MESSAGE=>CONSTRUCTOR'
      transporting no fields.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
  endmethod.

  method no_redundant_definition.
    "// If we found a reference to a class method, we don't need its definition
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    data(lo_obj) = cast zif_defuse_object(
      new zcl_defuse_object_meth( 'CL_MI_PACKAGE_GENERATION=>SET_BAPIRETURN' ) ).
    lo_obj->parent = lo_defuse.
    data(lt_objects) = lo_obj->search_down( ).

    read table lt_objects with key table_line->id-obj_name = 'CL_T100_MESSAGE'
      transporting no fields.
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
  endmethod.

  method signature_ddic.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_DMS_CNV_MULTILEVEL=>EXPLODE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TTYP' obj_name = 'DMS_T_XML_DATA' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_DB6_ACTION_FILE_SYSTEMS=>GET_CALCULATED_DATA' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'RSDB6CALC' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH'
      obj_name = 'CL_SAPUSER_BCS=>IF_RECIPIENT_DIALOG_BCS~GET_ADDRESS_DATA' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'SO_ADDRESS_GET' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'METH' obj_name = 'CL_CALENDAR_CONTROL=>SET_NAVIGATOR_INFO' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_GUI_CALENDAR=>SET_SELECTION' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
