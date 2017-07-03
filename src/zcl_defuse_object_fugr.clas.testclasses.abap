*"* use this source file for your ABAP unit test classes

class test_search_down definition for testing risk level harmless duration short.
  private section.
    methods:
      function for testing.
endclass.

class test_search_down implementation.
  method function.
    data(lo_fugr) = cast zif_defuse_object( new zcl_defuse_object_fugr( 'SNI_ADDR' ) ).
    lo_fugr->parent = new zcl_defuse( ).
    lo_fugr->parent->filter_standard_objects = abap_false.
    data(lt_objects) = lo_fugr->search_down( ).

    data(lv_found) = 0.
    loop at lt_objects assigning field-symbol(<object>).
      if ( <object>->id-object = 'FUNC' and <object>->id-obj_name = 'NI_NAME_TO_ADDR' ).
        add 1 to lv_found.
      endif.
    endloop.
    cl_aunit_assert=>assert_equals( exp = 1 act = lv_found ).
  endmethod.
endclass.
