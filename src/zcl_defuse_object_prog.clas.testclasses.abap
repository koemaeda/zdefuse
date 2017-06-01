*"* use this source file for your ABAP unit test classes

class test definition abstract.
  protected section.
    class-data: dummy_index type n length 3.

    class-methods:
      destroy_generated_reports,
      generate_report importing type            type c default '1'
                                source          type string
                      returning value(progname) type progname,
      delete_report importing progname type progname.
endclass.

class test implementation.
  method destroy_generated_reports.
    "// Delete all the generated dummy programs
    select name from trdir into table @data(lt_progname)
      where name like 'ZDEFUSE_TEST_DUMMY%'.
    loop at lt_progname assigning field-symbol(<progname>).
      delete_report( conv #( <progname> ) ).
    endloop.
  endmethod.

  method generate_report.
    data: lt_source type table of string.

    "// Generate program name
    add 1 to dummy_index.
    progname = |ZDEFUSE_TEST_DUMMY{ dummy_index }|.

    split source at %_cr_lf into table lt_source.

    "// Fix program source
    find regex '^(REPORT) .+' in source ignoring case.
    if sy-subrc <> 0 and type = '1'.
      insert |REPORT { progname }.| into lt_source index 1.
      insert initial line into lt_source index 2.
    endif.

    insert report progname from lt_source program type type.
    commit work and wait.
    generate report progname.
    if sy-subrc <> 0 and type <> 'I'.
      message 'Syntax error!' type 'X'.
    endif.

    "// Create package entry (for searches to work)
    call function 'TRINT_CHANGE_TADIR_PACK_ATTR'
      exporting
        iv_tadir_pgmid    = 'R3TR'
        iv_tadir_object   = 'PROG'
        iv_tadir_obj_name = progname
        iv_insert         = 'X'
        iv_tadir_devclass = '$TMP'.
    commit work and wait.

    "// Force update of where-used lists
    new cl_wb_crossreference( p_name = progname p_include = '' )->index_actualize( ).
  endmethod.

  method delete_report.
    cl_wb_crossreference=>delete_index( value #( ( progname ) ) ).

    "// Delete program source
    delete report progname.

    "// Delete TADIR entry
    call function 'TRINT_TADIR_INTERFACE'
      exporting
        wi_delete_tadir_entry = 'X'
        wi_test_modus         = ' '
        wi_tadir_pgmid        = 'R3TR'
        wi_tadir_object       = 'PROG'
        wi_tadir_obj_name     = progname.
    commit work.
  endmethod.
endclass.

class test_search_up definition for testing risk level harmless inheriting from test.
  private section.
    class-methods: class_teardown.
    methods:
      prog_submit for testing,
      prog_perform for testing,
      include for testing.
*      tran for testing,
*      dial for testing,
*      enho for testing,
*      enhs for testing.

endclass.

class test_search_down definition for testing risk level harmless inheriting from test.
  private section.
    class-methods: class_teardown.
    methods:
      prog_submit for testing,
      prog_perform for testing,
      prog_include for testing,
      function for testing,
      intf_ref for testing,
      intf_method for testing,
      intf_attr for testing,
      intf_event for testing,
      class_ref for testing,
      class_attr for testing,
      class_inst_method for testing,
      class_stat_method for testing,
      class_event for testing,
      message for testing,
      dtel for testing,
      struct for testing,
      table for testing,
      table_field for testing,
      table_type for testing,
      type_pool for testing,
      dialog for testing,
      transformation for testing,
      parameter for testing,
      auth_check for testing,
      matchcode for testing.
endclass.


class test_search_up implementation.
  method class_teardown.
    destroy_generated_reports( ).
  endmethod.

  method prog_submit.
    data(lv_callee) = generate_report( |WRITE 'dummy'.  FORM test. WRITE 'dummy'. ENDFORM.| ).
    data(lv_caller) = generate_report( |SUBMIT { lv_callee } AND RETURN.| ).

    data(lt_objects) = new zcl_defuse( )->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_callee ) ) )->get_objects_to_check( ).
    read table lt_objects with key obj_name = lv_caller transporting no fields.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method prog_perform.
    data(lv_callee) = generate_report( |WRITE 'dummy'.  FORM test. WRITE 'dummy'. ENDFORM.| ).
    data(lv_caller) = generate_report( |PERFORM test IN PROGRAM { lv_callee }.| ).

    data(lt_objects) = new zcl_defuse( )->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_callee ) ) )->get_objects_to_check( ).
    read table lt_objects with key obj_name = lv_caller transporting no fields.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method include.
    data(lv_callee) = generate_report( type = 'I' source = |WRITE 'dummy'.| ).
    data(lv_caller) = generate_report( |INCLUDE { lv_callee }.| ).

    data(lt_objects) = new zcl_defuse( )->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_callee ) ) )->get_objects_to_check( ).
    read table lt_objects with key obj_name = lv_caller transporting no fields.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

endclass.


class test_search_down implementation.
  method class_teardown.
    destroy_generated_reports( ).
  endmethod.

  method prog_submit.
    data(lv_callee) = generate_report( |WRITE 'dummy'.| ).
    data(lv_caller) = generate_report( |SUBMIT { lv_callee } AND RETURN.| ).
*    cl_aunit_assert=>assert_not_initial( zcl_defuse=>create_node(
*      type = 'PROG' name = lv_caller )-ref->search_down( ) ).
  endmethod.

  method prog_perform.
    data(lv_callee) = generate_report( |FORM test. WRITE 'dummy'. ENDFORM.| ).
    data(lv_caller) = generate_report( |PERFORM test IN PROGRAM { lv_callee }.| ).
*    cl_aunit_assert=>assert_not_initial( zcl_defuse=>create_node(
*      type = 'PROG' name = lv_caller )-ref->search_down( ) ).
  endmethod.

  method prog_include.
    data(lv_include) = generate_report( type = 'I' source = |WRITE: 'dummy'.| ).
    data(lv_main) = generate_report( |INCLUDE { lv_include }.| ).
*    cl_aunit_assert=>assert_not_initial( zcl_defuse=>create_node(
*      type = 'PROG' name = lv_main )-ref->search_down( ) ).
  endmethod.

  method function.
*    data(lt_nodes) = zcl_defuse=>create_node(
*      type = 'PROG' name = 'RSRFCTES' )-ref->search_down( ).
*    delete lt_nodes where name <> 'RFC_SYSTEM_INFO'.
*    cl_aunit_assert=>assert_not_initial( lt_nodes ).
  endmethod.

  method intf_ref.
    data(lv_caller) = generate_report( |DATA(lo_intf) = CL_SXML_STRING_WRITER=>CREATE( ).| ).
*    data(lt_nodes) = zcl_defuse=>create_node(
*      type = 'PROG' name = lv_caller )-ref->search_down( ).
*    delete lt_nodes where type <> 'INTF' and name <> 'IF_SXML_WRITER'.
*    cl_aunit_assert=>assert_not_initial( lt_nodes ).
  endmethod.

  method intf_attr.
    data(lv_caller) = generate_report( |DATA(lv_type) = CL_SXML_STRING_WRITER=>CREATE( )->IF_SXML~TYPE.| ).
*    data(lt_nodes) = zcl_defuse=>create_node(
*      type = 'PROG' name = lv_caller )-ref->search_down( ).
*    delete lt_nodes where type <> 'INTF' and name <> 'IF_SXML'.
*    cl_aunit_assert=>assert_not_initial( lt_nodes ).
  endmethod.

  method intf_method.
    data(lv_caller) = generate_report( |CL_HTTP_CLIENT=>CREATE(\r\n| &&
      |EXPORTING host = 'dummy' IMPORTING client = DATA(lo_client) ).\r\n| &&
      |lo_client->SEND( ).| ).
*    data(lt_nodes) = zcl_defuse=>create_node(
*      type = 'PROG' name = lv_caller )-ref->search_down( ).
*    delete lt_nodes where type <> 'INTF' and name <> 'IF_HTTP_CLIENT'.
*    cl_aunit_assert=>assert_not_initial( lt_nodes ).
  endmethod.

  method intf_event.
    "// TODO
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method class_ref.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method class_attr.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method class_inst_method.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method class_stat_method.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method class_event.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method message.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method dtel.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method struct.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method table.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method table_field.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method table_type.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method type_pool.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method dialog.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method transformation.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method parameter.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method auth_check.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

  method matchcode.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.

endclass.
