*"* use this source file for your ABAP unit test classes

class test_search_up definition for testing risk level harmless duration medium.
  private section.
    methods:
      class for testing,
      inherited_class for testing,
      interface for testing,
      program for testing,
      function for testing,
      class_method for testing.
endclass.

class test_search_up implementation.
  method class.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'INTF' obj_name = 'IF_GUI_DYNAMIC_DATA' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'CLSD' obj_name = 'CL_DYNAMIC_GUI_EXTENSIONS' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method inherited_class.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'INTF' obj_name = 'ZIF_DEFUSE_OBJECT' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    "// Inheriting from ZCL_DEFUSE_OBJECT_CLSD
    assign lt_objects[ object = 'CLSD' obj_name = 'ZCL_DEFUSE_OBJECT_INTF' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method interface.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'INTF' obj_name = 'IF_GUI_RSNETGRAPHIC_INTERNAL' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'INTF' obj_name = 'IF_GUI_RSNETGRAPHIC_ALL' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method program.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'INTF' obj_name = 'IF_HTTP_HEADER_FIELDS' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'PROG' obj_name = 'SPROX_HTTP_REQUEST' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'INTF' obj_name = 'IF_HTTP_PROXY_CONFIG' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' obj_name = 'ICF_READ_PROXY_CONFIGURATION' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_method.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'INTF' obj_name = 'IF_HTTP_HEADER_FIELDS' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'METH' obj_name = 'CL_BSP_RUNTIME=>ON_CHECK_REWRITE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
