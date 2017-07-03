*"* use this source file for your ABAP unit test classes

class test_search_up definition for testing risk level harmless duration short.
  private section.
    methods:
      data_element for testing.
endclass.

class test_search_up implementation.
  method data_element.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'DOMA' obj_name = 'LANG' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'DTEL' obj_name = 'XULANGU' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.


class test_search_down definition for testing risk level harmless.
  private section.
    methods:
      conversion_exit for testing,
      value_table for testing.
endclass.

class test_search_down implementation.
  method conversion_exit.
    data(lo_doma) = cast zif_defuse_object( new zcl_defuse_object_doma( 'LANG' ) ).
    lo_doma->parent = new zcl_defuse( ).
    lo_doma->parent->filter_standard_objects = abap_false.
    data(lt_objects) = lo_doma->search_down( ).

    data(lv_found) = 0.
    loop at lt_objects assigning field-symbol(<object>).
      if ( <object>->id-object = 'FUNC' and <object>->id-obj_name = 'CONVERSION_EXIT_ISOLA_INPUT' ) or
         ( <object>->id-object = 'FUNC' and <object>->id-obj_name = 'CONVERSION_EXIT_ISOLA_OUTPUT' ).
        add 1 to lv_found.
      endif.
    endloop.
    cl_aunit_assert=>assert_equals( exp = 2 act = lv_found ).
  endmethod.

  method value_table.
    data(lo_doma) = cast zif_defuse_object( new zcl_defuse_object_doma( 'MANDT' ) ).
    lo_doma->parent = new zcl_defuse( ).
    lo_doma->parent->filter_standard_objects = abap_false.
    data(lt_objects) = lo_doma->search_down( ).

    data(lv_found) = 0.
    loop at lt_objects assigning field-symbol(<object>).
      if ( <object>->id-object = 'TABL' and <object>->id-obj_name = 'T000' ).
        add 1 to lv_found.
      endif.
    endloop.
    cl_aunit_assert=>assert_equals( exp = 1 act = lv_found ).
  endmethod.
endclass.
