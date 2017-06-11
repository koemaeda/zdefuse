*"* use this source file for your ABAP unit test classes

class test_zdefuse_to_standard definition for testing risk level harmless duration short
    inheriting from zcl_defuse_standard_comparer.
  private section.
    methods:
      program for testing,
      table for testing,
      whole_class for testing,
      class_definition for testing,
      class_method for testing,
      data_element for testing.
endclass.

class test_zdefuse_to_standard implementation.
  method program.
    data(lt_zdef) = value zcl_defuse=>ty_t_object_id(
      ( pgmid = 'R3TR' object = 'PROG' obj_name = 'DEMO_DYNPRO_FIELD' )
    ).
    data(lt_std) = object_list_zdef_to_standard( lt_zdef ).

    assign lt_std[ object = 'REPS' obj_name = 'DEMO_DYNPRO_FIELD' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_std[ object = 'DYNP' obj_name = 'DEMO_DYNPRO_FIELD                       0100' ] to <std>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method table.
    data(lt_zdef) = value zcl_defuse=>ty_t_object_id(
      ( pgmid = 'R3TR' object = 'TABL' obj_name = 'SFLIGHT' )
    ).
    data(lt_std) = object_list_zdef_to_standard( lt_zdef ).

    assign lt_std[ object = 'TABD' obj_name = 'SFLIGHT' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_std[ object = 'TABT' obj_name = 'SFLIGHT' ] to <std>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method whole_class.
    data(lt_zdef) = value zcl_defuse=>ty_t_object_id(
      ( pgmid = 'R3TR' object = 'CLAS' obj_name = 'CL_ABAP_COMPILER' )
    ).
    data(lt_std) = object_list_zdef_to_standard( lt_zdef ).

    assign lt_std[ object = 'CLSD' obj_name = 'CL_ABAP_COMPILER' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_std[ object = 'CPUB' obj_name = 'CL_ABAP_COMPILER' ] to <std>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_std[ object = 'CPRI' obj_name = 'CL_ABAP_COMPILER' ] to <std>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
    assign lt_std[ object = 'METH' obj_name = 'CL_ABAP_COMPILER              CREATE' ] to <std>.
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_definition.
    data(lt_zdef) = value zcl_defuse=>ty_t_object_id(
      ( pgmid = 'LIMU' object = 'CLSD' obj_name = 'CL_ABAP_COMPILER' )
    ).
    data(lt_std) = object_list_zdef_to_standard( lt_zdef ).

    assign lt_std[ object = 'CLSD' obj_name = 'CL_ABAP_COMPILER' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_method.
    data(lt_zdef) = value zcl_defuse=>ty_t_object_id(
      ( pgmid = 'LIMU' object = 'METH' obj_name = 'CL_ABAP_COMPILER=>CREATE' )
    ).
    data(lt_std) = object_list_zdef_to_standard( lt_zdef ).

    assign lt_std[ object = 'METH' obj_name = 'CL_ABAP_COMPILER              CREATE' ]
      to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method data_element.
    data(lt_zdef) = value zcl_defuse=>ty_t_object_id(
      ( pgmid = 'R3TR' object = 'DTEL' obj_name = 'SYBINPT' )
    ).
    data(lt_std) = object_list_zdef_to_standard( lt_zdef ).

    assign lt_std[ object = 'DTED' obj_name = 'SYBINPT' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.


class test_standard_to_zdefuse definition for testing risk level harmless duration short
    inheriting from zcl_defuse_standard_comparer.
  private section.
    methods:
      report for testing,
      table for testing,
      class_section for testing,
      class_definition for testing,
      class_method for testing,
      data_element for testing.
endclass.

class test_standard_to_zdefuse implementation.
  method report.
    data(lt_std) = value vrs_compare_item_tab(
      ( fragid = 'LIMU' fragment = 'REPS' fragname = 'RSHOWTIM' )
    ).
    data(lt_zdef) = object_list_standard_to_zdef( lt_std ).

    assign lt_zdef[ object = 'REPS' obj_name = 'RSHOWTIM' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method table.
    data(lt_std) = value vrs_compare_item_tab(
      ( fragid = 'LIMU' fragment = 'TABD' fragname = 'SFLIGHT' pgmid = 'R3TR' object = 'TABL' obj_name = 'SFLIGHT' )
    ).
    data(lt_zdef) = object_list_standard_to_zdef( lt_std ).

    assign lt_zdef[ pgmid = 'R3TR' object = 'TABL' obj_name = 'SFLIGHT' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_section.
    data(lt_std) = value vrs_compare_item_tab(
      ( fragid = 'LIMU' fragment = 'CPUB' fragname = 'CL_ABAP_COMPILER' )
    ).
    data(lt_zdef) = object_list_standard_to_zdef( lt_std ).

    assign lt_zdef[ object = 'CLSD' obj_name = 'CL_ABAP_COMPILER' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_definition.
    data(lt_std) = value vrs_compare_item_tab(
      ( fragid = 'LIMU' fragment = 'CLSD' fragname = 'CL_ABAP_COMPILER' )
    ).
    data(lt_zdef) = object_list_standard_to_zdef( lt_std ).

    assign lt_zdef[ object = 'CLSD' obj_name = 'CL_ABAP_COMPILER' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method class_method.
    data(lt_std) = value vrs_compare_item_tab(
      ( fragid = 'LIMU' fragment = 'METH' fragname = 'CL_ABAP_COMPILER              CREATE' )
    ).
    data(lt_zdef) = object_list_standard_to_zdef( lt_std ).

    assign lt_zdef[ object = 'METH' obj_name = 'CL_ABAP_COMPILER=>CREATE' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.

  method data_element.
    data(lt_std) = value vrs_compare_item_tab(
      ( fragid = 'LIMU' fragment = 'DTED' fragname = 'SYBINPT' pgmid = 'R3TR' object = 'DTEL' obj_name = 'SYBINPT' )
    ).
    data(lt_zdef) = object_list_standard_to_zdef( lt_std ).

    assign lt_zdef[ pgmid = 'R3TR' object = 'DTEL' obj_name = 'SYBINPT' ] to field-symbol(<std>).
    cl_aunit_assert=>assert_initial( sy-subrc ).
  endmethod.
endclass.
