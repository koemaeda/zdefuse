*"* use this source file for your ABAP unit test classes

class test_search_up definition for testing risk level harmless duration short.
  private section.
    methods:
      badi_interface for testing,
      include for testing,
      program for testing,
      function for testing,
      class_method for testing.
endclass.

class test_search_up implementation.
  method badi_interface.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'ENHS' obj_name = 'SUID_IDENTITY' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'INTF' obj_name = 'IF_BADI_IDENTITY_CHECK' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'INTF' obj_name = 'IF_BADI_IDENTITY_F4_AUTH_CHECK' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'INTF' obj_name = 'IF_BADI_SU01_CREATE' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'INTF' obj_name = 'IF_BADI_IDENTITY_UPDATE' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method include.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'ENHS' obj_name = 'SEEF_ADT_TEST_ENHS_2' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'REPS' obj_name = 'LSEEF_ADT_TEST_AUNIT_FUGR1F01' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'ENHS' obj_name = 'SEEF_ADJ_TEST_TEMPLATE_001' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'SEEF_ADJ_TEST_TEMPLATE_001' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'ENHS' obj_name = 'SEEF_ADT_TEST_ENHS_2' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'SEEF_ADT_TEST_AUNIT_FMODULE1' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'ENHS' obj_name = 'SEU_TEST_CLASS_SPOT_0000001' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_SPOT_ENH_TEMPLATE_001=>SOME_METHOD' ]
      to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.


class test_search_down definition for testing risk level harmless duration short.
  private section.
    methods:
      badi_implementation for testing,
      point_implementation for testing,
      section_implementation for testing.
endclass.

class test_search_down implementation.
  method badi_implementation.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'ENHS' obj_name = 'SUPPORT_QUERY_FRAMEWORK' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'ENHO' obj_name = 'SCPCONT_SQF_QUERY' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'ENHO' obj_name = 'SQF_TOOL_UIS' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'ENHO' obj_name = 'SQF_UI_WINGUI' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'ENHO' obj_name = 'SQF_UI_WEBDYNPRO' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method point_implementation.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'ENHS' obj_name = 'SEU_TEST_CLASS_SPOT_0000001' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'ENHO' obj_name = 'SEU_TEST_CLS_ENH_IMPL_TEMPLATE' ] to field-symbol(<object>).
  endmethod.

  method section_implementation.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'ENHS' obj_name = 'SEEF_ADJ_TEST_TEMPLATE_001' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'ENHO' obj_name = 'SEEF_ADJ_TEST_TEMPLATE_001' ] to field-symbol(<object>).
  endmethod.
endclass.
