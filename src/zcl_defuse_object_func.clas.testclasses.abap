*"* use this source file for your ABAP unit test classes

class test_search_up definition for testing risk level harmless duration medium.
  private section.
    methods:
      own_program for testing,
      program for testing,
      function for testing,
      method for testing,
      web_dynpro for testing.
endclass.

class test_search_up implementation.
  method own_program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'NI_ADDR_TO_NAME' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'SAPLSNI_ADDR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'REPS' obj_name = 'LSNI_ADDRTOP' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'NI_ADDR_TO_NAME' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'RSNITEST' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'NI_ADDR_TO_NAME' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'C1SVC_LOCAL_CONNECTION_CHECK' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'NI_ADDR_TO_NAME' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_ICI_LB_HELPER=>INITIATE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method web_dynpro.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'GRIX_CALCULATE_HASH_NUMBER' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'WDYN' obj_name = 'FCOM_EXP_CCHIERASSIGN' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.


class test_search_down definition for testing risk level harmless duration medium.
  private section.
    methods:
      signature_data_element for testing,
      signature_table for testing,
      signature_table_type for testing,
      signature_type_group for testing,
      signature_class for testing,
      signature_interface for testing,
      code_method for testing,
      code_program for testing,
      code_function for testing.
endclass.

class test_search_down implementation.
  method signature_data_element.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'NI_ADDR_TO_NAME' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'DTEL' obj_name = 'NI_NODEADDR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method signature_table.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'NI_GET_ADDR_LIST' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TABL' obj_name = 'NIS_NODEADDR_LIST' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method signature_table_type.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'SO_SOLITAB_TO_SOLIXTAB' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TTYP' obj_name = 'SOLIX_TAB' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method signature_type_group.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'CLS_EDIT_LINKS' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TYPE' obj_name = 'ABAP' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method signature_class.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'SAI_TEST_CALL_SCREEN' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_GUI_HTML_VIEWER' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method signature_interface.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'SAI_AE_DETAILS_GET' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'INTF' obj_name = 'IF_XMS_TRACE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method code_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'SAI_AE_DETAILS_GET' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_SLD_ACCESSOR=>ENUMERATE_INSTANCES' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method code_program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'SO_DYNP_SHORT_MESSAGE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'SAPFSSO0' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method code_function.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUNC' obj_name = 'SO_DYNP_SHORT_MESSAGE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'SO_NAME_CONVERT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
