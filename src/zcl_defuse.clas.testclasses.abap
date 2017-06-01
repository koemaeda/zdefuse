*"* use this source file for your ABAP unit test classes

class test_ddic_objects definition for testing risk level harmless inheriting from zcl_defuse.
  private section.
    methods:
      setup,
      ddic_structure for testing,
      ddic_table for testing,
      ddic_table_type for testing,
      class_public_type for testing,
      class_private_type for testing,
      class_table for testing,
      typepool_type for testing,
      typepool_struct for testing,
      typepool_table for testing.
endclass.

class test_ddic_objects implementation.
  method setup.
    me->filter_standard_objects = abap_false.
    me->max_depth = 1.
  endmethod.

  method ddic_structure.
    data(lo_obj) = me->create_ddic_object( 'BAPIRETURN' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TABL' act = lo_obj->id-object ).
  endmethod.

  method ddic_table.
    data(lo_obj) = me->create_ddic_object( 'SFLIGHT' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TABL' act = lo_obj->id-object ).
  endmethod.

  method ddic_table_type.
    data(lo_obj) = me->create_ddic_object( 'BAPIRET2_TAB' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TTYP' act = lo_obj->id-object ).
  endmethod.

  method class_public_type.
    data(lo_obj) = me->create_ddic_object( 'CL_ABAP_COMPILER=>T_REF' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TABL' act = lo_obj->id-object ).
  endmethod.

  method class_private_type.
    data(lo_obj) = me->create_ddic_object( 'CL_GUI_ALV_GRID=>L_TYPE_S_SEARCH' ).
    cl_aunit_assert=>assert_initial( lo_obj ).
  endmethod.

  method class_table.
    data(lo_obj) = me->create_ddic_object( 'CL_WD_FLIGHT_MODEL=>TT_SCARR' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TTYP' act = lo_obj->id-object ).
  endmethod.

  method typepool_type.
    data(lo_obj) = me->create_ddic_object( 'CNHE_HTML_TEXT' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'DTEL' act = lo_obj->id-object ).
  endmethod.

  method typepool_struct.
    data(lo_obj) = me->create_ddic_object( 'CNHE_USER_ACTION' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TABL' act = lo_obj->id-object ).
  endmethod.

  method typepool_table.
    data(lo_obj) = me->create_ddic_object( 'CNHE_ITAB_ACTIONS' ).
    cl_aunit_assert=>assert_not_initial( lo_obj ).
    cl_aunit_assert=>assert_equals( exp = 'TTYP' act = lo_obj->id-object ).
  endmethod.
endclass.


class test_includes definition for testing risk level harmless inheriting from zcl_defuse.
  private section.
    methods:
      setup,
      report for testing,
      include for testing,
      module_pool for testing,
      function_module for testing,
      function_group for testing,
      type_pool for testing,
      class_section for testing,
      class_method for testing.
endclass.

class test_includes implementation.
  method setup.
    me->filter_standard_objects = abap_false.
    me->max_depth = 1.
  endmethod.

  method report.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method include.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method module_pool.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method function_module.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method function_group.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method type_pool.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method class_section.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method class_method.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.
endclass.
