*"* use this source file for your ABAP unit test classes

class test_search_down definition for testing risk level harmless duration short.
  private section.
    methods:
      function for testing.
endclass.

class test_search_down implementation.
  method function.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'FUGR' obj_name = 'SNI_ADDR' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'NI_NAME_TO_ADDR' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
