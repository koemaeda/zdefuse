*"* use this source file for your ABAP unit test classes

class test_search_up definition for testing risk level harmless duration short.
  private section.
    methods:
      program for testing,
      class_definition for testing,
      method for testing,
      web_dynpro for testing,
      function for testing,
      enhancement for testing.
endclass.

class test_search_up implementation.
  method program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'CNHE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'SAPHTMLPAGEEDITOR_DEMO1' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_definition.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'CNHE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_GUI_HTML_EDITOR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'CICL' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH'
      obj_name = 'CL_EX_CEWB_TSK_UPDATE=>IF_EX_CEWB_TSK_UPDATE~CHECK_TSK_AT_SAVE' ]
      to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method web_dynpro.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'WDCTX' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'WDYN' obj_name = 'FPB_EXP_STATUS_OVERVIEW' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'CICL' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'CI_DU_PAC_READ_BY_OPR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'FUNC' obj_name = 'CI_OV_PAC_ID_PROVIDE' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method enhancement.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'CNHE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'ENHO' obj_name = 'ZDEFUSE_TEST_TYPE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.


class test_search_down definition for testing risk level harmless duration short.
  private section.
    methods:
      structure for testing,
      data_element for testing,
      table_type for testing,
      class for testing,
      interface for testing,
      type_pool for testing.
endclass.

class test_search_down implementation.
  method structure.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'CORE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TABL' obj_name = 'TCF02' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method data_element.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'CNHE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'DTEL' obj_name = 'UI_FUNC' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method table_type.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'PPEAR' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TTYP' obj_name = 'PPE_ATTRIBUTE_TAB' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'GMALV' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_DD_AREA' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method interface.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'SXDBG' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'INTF' obj_name = 'IF_IXML_NODE_COLLECTION' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method type_pool.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'TYPE' obj_name = 'SCCON' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TYPE' obj_name = 'ICON' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
