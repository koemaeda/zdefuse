class ZCL_DEFUSE_STANDARD_COMPARER definition
  public
  create public .

public section.

  interfaces ZIF_DEFUSE_COMPARER .
protected section.

  class-methods OBJECT_LIST_ZDEF_TO_STANDARD
    importing
      !TARGET_SYSTEM type SYSYSID optional
      !OBJECTS type ZCL_DEFUSE=>TY_T_OBJECT_ID
    returning
      value(T_COMPARE) type VRS_COMPARE_ITEM_TAB .
  class-methods OBJECT_LIST_STANDARD_TO_ZDEF
    importing
      !T_RESULTS type VRS_COMPARE_ITEM_TAB
    returning
      value(OBJECTS) type ZCL_DEFUSE=>TY_T_OBJECT_ID .
  class-methods GET_RFC_DESTINATION
    importing
      value(SYSID) type SYSYSID
    returning
      value(DESTINATION) type RFCDEST .
  class-methods CHECK_RFC_DESTINATION
    importing
      !TARGET_SYSTEM type SYSYSID
    returning
      value(MESSAGES) type BAPIRET2_TAB .
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_STANDARD_COMPARER IMPLEMENTATION.


  method check_rfc_destination.
    "// Based on FM SVRS_MASSCOMPARE_ACT_OBJECTS
    data: ls_rfcsi type rfcsi.

    data(lv_destination) = get_rfc_destination( target_system ).
    call function 'SCWB_RFC_PING'
      exporting
        iv_destination = lv_destination
      importing
        es_rfcsi       = ls_rfcsi
      exceptions
        rfc_error      = 1
        others         = 2.
    if sy-subrc <> 0.
      log-point id zdefuse subkey 'RFC_ERROR' fields target_system lv_destination.
      append initial line to messages assigning field-symbol(<message>).
      call function 'BALW_BAPIRETURN_GET2'
        exporting
          type   = 'E' "// force error
          cl     = sy-msgid
          number = sy-msgno
          par1   = sy-msgv1
          par2   = sy-msgv2
          par3   = sy-msgv3
          par4   = sy-msgv4
        importing
          return = <message>.
    endif.
  endmethod.


  method get_rfc_destination.
    "// Based on FM SVRS_GET_RFC_DESTINATION
    data: lt_all_systems type tmscsyslst_typ.

    "// Default/fallback
    destination = sysid.

    "// Get transport domain
    call function 'TMS_CI_GET_SYSTEMLIST'
      exporting
        iv_system                   = conv tmssysnam( sy-sysid )
        iv_only_active              = abap_true
      tables
        tt_syslst                   = lt_all_systems
      exceptions
        tms_is_not_active           = 1
        invalid_ci_conf_with_domain = 2
        no_systems                  = 3
        others                      = 4.
    check sy-subrc = 0 and lt_all_systems is not initial.

    "// Get all systems of local domain
    call function 'TMS_CI_GET_SYSTEMLIST'
      exporting
        iv_domain                   = lt_all_systems[ 1 ]-domnam
        iv_only_active              = abap_true
      tables
        tt_syslst                   = lt_all_systems
      exceptions
        tms_is_not_active           = 1
        invalid_ci_conf_with_domain = 2
        no_systems                  = 3
        others                      = 4.

    "// Build destination name
    assign lt_all_systems[ sysnam = sysid ] to field-symbol(<target_sys>).
    if sy-subrc = 0.
      destination = |TMSADM@{ <target_sys>-sysnam }.{ <target_sys>-domnam }|.
    endif.
  endmethod.


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


  method OBJECT_LIST_ZDEF_TO_STANDARD.
    "// Based on FM SVRS_MASSCOMPARE_ACT_OBJECTS
    data: lt_e071            type table of e071,
          lt_bao             type table of bao6163,
          lt_tadir           type table of tadir,
          lt_non_versionable type table of e071.

    "// Convert our object IDs to standard naming
    loop at objects assigning field-symbol(<id>).
      append zcl_defuse=>object_id_to_e071( <id> ) to lt_e071.
    endloop.

    "// Use standard function to break down our object list
    "//  into fragments/global objects and to find out
    "//  what is not versionable
    call function 'SCWB_RESOLVE_OBJECT_LIST'
      tables
        it_e071                = lt_e071
        et_bao6163             = lt_bao
        et_tadir               = lt_tadir
        et_nonversionable_objs = lt_non_versionable.

    "// The TMS user usually isn't authorized to call SCWB_RESOLVE_OBJECT_LIST.
    "// Because of this, we build the comparison list locally, assuming all the
    "//  objects exist in both systems (this is what we hope, after all)
    "// Objects that eventualy are not found, are flagged as "not readable"
    "//  instead of "not versionable".
    data(lv_destination) = get_rfc_destination( target_system ).
    loop at lt_bao assigning field-symbol(<bao>).
      assign lt_tadir[ pgmid = <bao>-pgmid object = <bao>-object obj_name = <bao>-obj_name ]
        to field-symbol(<tadir>).
      check sy-subrc = 0.

      append value #(
        fragid = <bao>-fragid       pgmid = <tadir>-pgmid
        fragment = <bao>-fragment   object = <tadir>-object
        fragname = <bao>-fragname   obj_name = <tadir>-obj_name

        versno_a = 99998                    versno_b = 99998
        rfcdest_a = space                   rfcdest_b = lv_destination
        sysid_a = sy-sysid                  sysid_b = target_system
        devclass_a = <tadir>-devclass       devclass_b = <tadir>-devclass
        masterlang_a = <tadir>-masterlang   masterlang_b = <tadir>-masterlang
      ) to t_compare.
    endloop.
  endmethod.


  method zif_defuse_comparer~compare_objects.
    "// Check target system
    if target_system is initial.
      append value #( type = 'E' message = 'Comparison is impossible. Target system is not defined!' )
        to messages.
      return.
    endif.
    append lines of check_rfc_destination( target_system ) to messages.
    check messages is initial.

    "// Build comparison list
    data(lt_compare_results) = object_list_zdef_to_standard(
      target_system = target_system objects = objects ).
    if lt_compare_results is initial.
      append value #( type = 'E' message = 'There are no valid objects to compare.' )
        to messages.
      return.
    endif.

    "// Call standard comparison
    call function 'SVRS_MASSCOMPARE_OBJECTS'
      exporting
        iv_filter_lang        = 'X'
        iv_ignore_report_text = 'X'
      changing
        ct_compare_items      = lt_compare_results.
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
      elseif <result>-not_comparable = abap_true or <result>-not_readable = abap_true.
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
