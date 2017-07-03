*"* use this source file for your ABAP unit test classes

class test_search_down definition for testing risk level harmless duration short.
  private section.
    methods:
      view for testing,
      table for testing,
      exit_program for testing.
endclass.

class test_search_down implementation.
  method view.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'VCLS' obj_name = 'METACLUST' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'VIEW' obj_name = 'V_VCLDIR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'VIEW' obj_name = 'V_VCLMF' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method table.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'VCLS' obj_name = 'METACLUST' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'VIEW' obj_name = 'V_VCLDIR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'VIEW' obj_name = 'V_VCLMF' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method exit_program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'VCLS' obj_name = 'METACLUST' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'SAPSSVCD' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
