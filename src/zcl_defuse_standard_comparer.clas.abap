class ZCL_DEFUSE_STANDARD_COMPARER definition
  public
  create public .

public section.

  interfaces ZIF_DEFUSE_COMPARER .
protected section.

  class-methods OBJECT_LIST_ZDEF_TO_STANDARD
    importing
      !OBJECTS type ZCL_DEFUSE=>TY_T_OBJECT_ID
    returning
      value(T_E071) type E071_T .
  class-methods OBJECT_LIST_STANDARD_TO_ZDEF
    importing
      !T_RESULTS type VRS_COMPARE_ITEM_TAB
    returning
      value(OBJECTS) type ZCL_DEFUSE=>TY_T_OBJECT_ID .
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_STANDARD_COMPARER IMPLEMENTATION.


  method object_list_standard_to_zdef.
    loop at t_results assigning field-symbol(<result>).
      append initial line to objects assigning field-symbol(<object>).
      <object>-pgmid = <result>-fragid.
      <object>-object = <result>-fragment.

      "// Convert special subobjects
      case <result>-fragment.
        when 'METH'. "// Methods
          data: ls_method_key type seocmpkey.
          ls_method_key = <result>-fragname.
          <object>-obj_name = |{ ls_method_key-clsname }=>{ ls_method_key-cmpname }|.
        when 'DTED' or "// Data element definition
             'TABD'.   "// Table definition
          <object> = corresponding #( <result> ).
        when 'CPUB' or "// Class definition parts
             'CPRO' or
             'CPRI' or
             'CINC'.
          <object>-object = 'CLSD'.
          <object>-obj_name = <result>-fragname.
        when others.
          <object>-obj_name = <result>-fragname.
      endcase.
    endloop.
  endmethod.


  method object_list_zdef_to_standard.
    data: lt_bao             type table of bao6163,
          lt_tadir           type table of tadir,
          lt_non_versionable type table of e071.

    t_e071 = corresponding #( objects ).

    "// Convert our object IDs to standard naming
    loop at t_e071 assigning field-symbol(<e071>).
      case <e071>-object.
        when 'METH'. "// Methods
          data: ls_method_key type seocmpkey.
          split <e071>-obj_name at '=>' into ls_method_key-clsname ls_method_key-cmpname.
          if sy-subrc = 0.
            <e071>-obj_name = ls_method_key.
          endif.
      endcase.
    endloop.

    "// Use standard function to break down our object list
    "//  into fragments/global objects and to find out
    "//  what is not versionable
    call function 'SCWB_RESOLVE_OBJECT_LIST'
      tables
        it_e071                = t_e071
        et_bao6163             = lt_bao
        et_tadir               = lt_tadir
        et_nonversionable_objs = lt_non_versionable.

    t_e071 = corresponding #( lt_bao mapping pgmid = fragid object = fragment obj_name = fragname ).
  endmethod.


  method zif_defuse_comparer~compare_objects.
    if target_system is initial.
      append value #( type = 'E' message = 'Comparison is impossible. Target system is not defined!' )
        to messages.
      return.
    endif.

    "// Build comparison list
    data(lt_std_objects) = object_list_zdef_to_standard( objects ).
    if lt_std_objects is initial.
      append value #( type = 'E' message = 'There are no valid objects to compare.' )
        to messages.
      return.
    endif.

    "// Call standard comparison
    data: lt_compare_results type vrs_compare_item_tab.
    call function 'SVRS_MASSCOMPARE_ACT_OBJECTS'
      exporting
        it_e071          = lt_std_objects
        iv_rfcdest_b     = target_system
      importing
        et_compare_items = lt_compare_results
      exceptions
        rfc_error        = 1
        not_supported    = 2
        others           = 3.
    if sy-subrc <> 0.
      log-point id zdefuse subkey 'COMPARE_OBJECTS_ERROR'.
      append initial line to messages assigning field-symbol(<message>).
      call function 'BALW_BAPIRETURN_GET2'
        exporting
          type   = sy-msgty
          cl     = sy-msgid
          number = sy-msgno
          par1   = sy-msgv1
          par2   = sy-msgv2
          par3   = sy-msgv3
          par4   = sy-msgv4
        importing
          return = <message>.
      return.
    endif.

    total_compared = lines( lt_compare_results ).

    "// Discard useless results
    delete lt_compare_results where equal = abap_true.
    loop at lt_compare_results assigning field-symbol(<result>).
      case <result>-fragment.
        when 'DYNP'. "// Selection screens
          find regex |{ <result>-obj_name }\\s*1000| in <result>-fragname.
          if sy-subrc = 0.
            delete table lt_compare_results from <result>.
            continue.
          endif.
        when 'REPT' or "// Report texts
             'TABT'.   "// Technical attributes of a table
          delete table lt_compare_results from <result>.
          continue.
      endcase.
    endloop.

    "// Separate the results into different lists
    data: lt_std_different type vrs_compare_item_tab,
          lt_std_not_found type vrs_compare_item_tab,
          lt_std_ignored   type vrs_compare_item_tab.
    loop at lt_compare_results assigning <result>.
      if <result>-nonversionable = abap_true.
        append corresponding #( <result> ) to lt_std_ignored.
      elseif <result>-not_comparable = abap_true.
        append <result> to lt_std_not_found.
      elseif <result>-equal = abap_false.
        append <result> to lt_std_different.
      endif.
    endloop.

    "// Convert back IDs
    different = object_list_standard_to_zdef( lt_std_different ).
    not_found = object_list_standard_to_zdef( lt_std_not_found ).
    ignored = object_list_standard_to_zdef( lt_std_ignored ).
  endmethod.
ENDCLASS.
