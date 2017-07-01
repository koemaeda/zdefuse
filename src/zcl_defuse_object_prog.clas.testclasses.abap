*"* use this source file for your ABAP unit test classes

class test definition abstract inheriting from zcl_defuse.
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
      cl_aunit_assert=>fail( 'Syntax error!' ).
      return.
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
    commit work and wait.
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

class test_search_up definition for testing risk level harmless  duration medium
    inheriting from test.
  private section.
    class-methods: class_teardown.
    methods:
      prog_submit for testing,
      prog_perform for testing,
      include for testing,
      transaction for testing,
      dialog for testing,
      enhancement for testing.
endclass.

class test_search_down definition for testing risk level harmless  duration medium
    inheriting from test.
  private section.
    class-methods: class_teardown.
    methods:
      prog_submit for testing,
      prog_perform for testing,
      prog_include for testing,
      function_include for testing,
      function for testing,
      intf_ref for testing,
      intf_method for testing,
      intf_attr for testing,
      class_ref for testing,
      class_attr for testing,
      class_inst_method for testing,
      class_stat_method for testing,
      class_event for testing,
      message for testing,
      data_element for testing,
      struct for testing,
      table for testing,
      table_field for testing,
      table_type for testing,
      type_pool for testing,
      dialog for testing,
      transformation for testing,
      parameter for testing,
      auth_check for testing,
      search_help for testing.
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

  method transaction.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'PROG' obj_name = 'RSMON000_ALV_NEW' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'TRAN' obj_name = 'SM50' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method dialog.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'PROG' obj_name = 'SAPMSSCF' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    "// Currently, Dialog modules are not supported
    lo_defuse->comparer = new zcl_defuse_mock_comparer( ).
    data(ls_results) = lo_defuse->run( 'MOCK' ).

    assign ls_results-unsupported_objects[ object = 'DIAL' obj_name = 'EDIT_FORM' ]
      to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method enhancement.
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 1.
    lo_defuse->add_objects( value #( ( object = 'PROG' obj_name = 'RIAFVC20' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'ENHO' obj_name = 'OIO_MIOLVC20' ] to field-symbol(<object>).
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

    data(lt_objects) = new zcl_defuse( )->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'PROG' obj_name = lv_callee ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method prog_perform.
    data(lv_callee) = generate_report( |FORM test. WRITE 'dummy'. ENDFORM.| ).
    data(lv_caller) = generate_report( |PERFORM test IN PROGRAM { lv_callee }.| ).

    data(lt_objects) = new zcl_defuse( )->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'PROG' obj_name = lv_callee ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method prog_include.
    data(lv_include) = generate_report( type = 'I' source = |WRITE: 'dummy'.| ).
    data(lv_main) = generate_report( |INCLUDE { lv_include }.| ).

    data(lt_objects) = new zcl_defuse( )->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_main ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'REPS' obj_name = lv_include ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function_include.
    "// Make sure our includes are not converted to functions
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->filter_standard_objects = abap_false.
    lo_defuse->max_depth = 2.
    lo_defuse->add_objects( value #( ( object = 'PROG' obj_name = 'SAPLSNI_ADDR' ) ) ).
    data(lt_objects) = lo_defuse->get_objects_to_check( ).

    assign lt_objects[ object = 'FUNC' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_not_initial( sy-subrc ).
    assign lt_objects[ object = 'REPS' obj_name = 'LSNI_ADDRTOP' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'REPS' obj_name = 'LSNI_ADDRUXX' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_objects[ object = 'REPS' obj_name = 'LSNI_ADDRU01' ] to <object>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method function.
    data(lv_caller) = generate_report( |CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'FUNC' obj_name = 'BAPI_TRANSACTION_COMMIT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method intf_ref.
    data(lv_caller) = generate_report(
      |CL_HTTP_CLIENT=>CREATE_BY_URL( EXPORTING url = 'http://gihub.com/' IMPORTING client = DATA(lo_intf) ).| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'INTF' obj_name = 'IF_HTTP_CLIENT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method intf_attr.
    data(lv_caller) = generate_report( |DATA(lv_type) = CL_SXML_STRING_WRITER=>CREATE( )->IF_SXML~TYPE.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'INTF' obj_name = 'IF_SXML' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method intf_method.
    data(lv_caller) = generate_report( |CL_HTTP_CLIENT=>CREATE(\r\n| &&
      |EXPORTING host = 'dummy' IMPORTING client = DATA(lo_client) ).\r\n| &&
      |lo_client->SEND( ).| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'INTF' obj_name = 'IF_HTTP_CLIENT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_ref.
    data(lv_caller) = generate_report( |DATA(lo_class) = NEW CL_AUCV_RUNNER( ).| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'CLSD' obj_name = 'CL_AUCV_RUNNER' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_attr.
    data(lv_caller) = generate_report( |DATA(lv_crlf) = CL_ABAP_CHAR_UTILITIES=>CR_LF.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'CLSD' obj_name = 'CL_ABAP_CHAR_UTILITIES' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_inst_method.
    data(lv_caller) = generate_report( |DATA(lo_writer) = CL_SXML_STRING_WRITER=>CREATE( ).\r\n| &&
      |lo_writer->GET_OUTPUT( ).| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'METH' obj_name = 'CL_SXML_STRING_WRITER=>GET_OUTPUT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_stat_method.
    data(lv_caller) = generate_report( |DATA(lo_writer) = CL_SXML_STRING_WRITER=>CREATE( ).| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'METH' obj_name = 'CL_SXML_STRING_WRITER=>CREATE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_event.
    data(lv_caller) = generate_report(
      |CLASS lcl_eventhandler DEFINITION.\r\n| &&
      |  PUBLIC SECTION.\r\n| &&
      |    CLASS-METHODS:\r\n| &&
      |        on_user_command FOR EVENT user_command OF cl_gui_alv_grid_ext IMPORTING e_ucomm.\r\n| &&
      |ENDCLASS.\r\n| &&
      |CLASS lcl_eventhandler IMPLEMENTATION.\r\n| &&
      |  METHOD on_user_command.\r\n| &&
      |  ENDMETHOD.\r\n| &&
      |ENDCLASS.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'CLSD' obj_name = 'CL_GUI_ALV_GRID_EXT' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method message.
    data(lv_caller) = generate_report( |MESSAGE E099(SB).| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'MSAG' obj_name = 'SB' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method data_element.
    data(lv_caller) = generate_report( |DATA: lv_dummy TYPE usr41-bname.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'DTEL' obj_name = 'XUBNAME' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method struct.
    data(lv_caller) = generate_report( |DATA: lv_dummy TYPE usr41.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'TABL' obj_name = 'USR41' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method table.
    data(lv_caller) = generate_report( |SELECT COUNT( * ) FROM usr41 INTO sy-dbcnt.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'TABL' obj_name = 'USR41' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method table_field.
    data(lv_caller) = generate_report(
      |SELECT SINGLE bname FROM usr41 INTO @DATA(lv_bname) WHERE bname = @sy-uname.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 2.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'DTEL' obj_name = 'XUBNAME' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method table_type.
    data(lv_caller) = generate_report( |DATA: lt_dummy TYPE BAPIRET2_TAB.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'TTYP' obj_name = 'BAPIRET2_TAB' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method type_pool.
    data(lv_caller) = generate_report( |DATA(lv_dummy) = abap_true.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'TYPE' obj_name = 'ABAP' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method dialog.
    data(lv_caller) = generate_report( |CALL DIALOG 'JOB_SUBMIT'.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).

    "// Currently, Dialog modules are not supported
    lo_defuse->comparer = new zcl_defuse_mock_comparer( ).
    data(ls_results) = lo_defuse->run( 'MOCK' ).

    assign ls_results-unsupported_objects[ object = 'DIAL' obj_name = 'JOB_SUBMIT' ]
      to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method transformation.
    data(lv_caller) = generate_report( |CALL TRANSFORMATION id SOURCE a = sy-uname RESULT XML DATA(lv_xml).| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).

    "// Currently, Dialog modules are not supported
    lo_defuse->comparer = new zcl_defuse_mock_comparer( ).
    data(ls_results) = lo_defuse->run( 'MOCK' ).

    assign ls_results-unsupported_objects[ object = 'XSLT' obj_name = 'ID' ]
      to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method parameter.
    data(lv_caller) = generate_report( |SET PARAMETER ID 'BUK' FIELD '01'.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'PARA' obj_name = 'BUK' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method auth_check.
    data(lv_caller) = generate_report( |AUTHORITY-CHECK OBJECT 'S_TCODE' ID 'TCD' FIELD 'CO02'.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'SUSO' obj_name = 'S_TCODE' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method search_help.
    data(lv_caller) = generate_report( |PARAMETERS: dummy TYPE matnr MATCHCODE OBJECT mat1.| ).
    data(lo_defuse) = new zcl_defuse( ).
    lo_defuse->max_depth = 1.
    lo_defuse->filter_standard_objects = abap_false.
    data(lt_objects) = lo_defuse->add_objects( value #(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = lv_caller ) ) )->get_objects_to_check( ).
    assign lt_objects[ object = 'SHLP' obj_name = 'MAT1' ] to field-symbol(<object>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
