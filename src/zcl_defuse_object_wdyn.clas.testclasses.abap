*"* use this source file for your ABAP unit test classes

class test_search_down definition for testing risk level harmless.
  private section.
    methods:
      controller_interface for testing,
      controller_attribute for testing,
      controller_method for testing,
      view_attribute for testing,
      view_method for testing.
endclass.

class test_search_down implementation.
  method controller_interface.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'WDYN' obj_name = 'DEMO_TABLE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'INTF' obj_name = 'IWCI_DEMO_TABLE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method controller_attribute.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'WDYN' obj_name = 'DEMO_TABLE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'DTEL' obj_name = 'S_CARR_ID' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method controller_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'WDYN' obj_name = 'DEMO_TABLE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_WD_FLIGHT_MODEL=>GET_SBOOK_BY_KEY_RANGE' ]
      to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method view_attribute.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'WDYN' obj_name = 'DEMO_TABLE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'INTF' obj_name = 'IF_WD_TABLE_METHOD_HNDL' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).

    assign lt_objects[ object = 'TTYP' obj_name = 'WD_FLIGHTTAB' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method view_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'WDYN' obj_name = 'DEMO_TABLE' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_WD_FLIGHT_MODEL=>GET_SFLIGHT_BY_KEY' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
