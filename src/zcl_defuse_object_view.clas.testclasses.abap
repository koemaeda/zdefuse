*"* use this source file for your ABAP unit test classes

class test_search_up definition for testing risk level harmless duration short.
  private section.
    methods:
      program for testing,
      function for testing,
      class_method for testing,
      view_maintenance for testing.
endclass.

class test_search_up implementation.
  method program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'VIEW' obj_name = 'V_VCLDIR' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'RSVTPROT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'VIEW' obj_name = 'V_VCLDIR' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'GET_ALE_OBJECT_TEXT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'VIEW' obj_name = 'V_ADRCITY' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_BSP_ACCESS_MODEL_ADDRESS=>GET_WHERE_COND_STREET' ]
      to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method view_maintenance.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'VIEW' obj_name = 'V_VCLDIR' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUGR' obj_name = '0SVM' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.


class test_search_down definition for testing risk level harmless duration short.
  private section.
    methods:
      table for testing.
endclass.

class test_search_down implementation.
  method table.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'VIEW' obj_name = 'V_VCLDIR' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TABL' obj_name = 'VCLDIR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'TABL' obj_name = 'VCLDIRT' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
