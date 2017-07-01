*"* use this source file for your ABAP unit test classes

class test_search_up definition for testing risk level harmless duration short.
  private section.
    methods:
      function for testing,
      todo for testing.
endclass.

class test_search_up implementation.
  method function.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'MSAG' obj_name = 'CTS_API' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'CTS_API_CREATE_CHANGE_REQUEST' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method todo.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.
endclass.
