class ZCL_DEFUSE definition
  public
  create public

  global friends ZCL_DEFUSE_OBJECT_PROG
                 ZCL_DEFUSE_OBJECT_WDYN
                 ZIF_DEFUSE_COMPARER
                 ZIF_DEFUSE_OBJECT .

public section.

  types:
    begin of ty_progress_item,
        depth    type i,
        total    type i,
        analysed type i,
        progress type i,
      end of ty_progress_item .
  types:
    ty_progress type sorted table of ty_progress_item with unique key primary_key components depth .
  types:
    begin of ty_object_id,
        pgmid    type pgmid,
        object   type trobjtype,
        obj_name type trobj_name,
      end of ty_object_id .
  types:
    ty_t_object_id type standard table of ty_object_id with default key .
  types:
    begin of ty_object_path,
        depth     type i,
        id_from   type ty_object_id,
        id_to     type ty_object_id,
        parts     type ty_t_object_id,
      end of ty_object_path .
  types:
    ty_t_object_path type sorted table of ty_object_path with non-unique key primary_key components depth id_from id_to .
  types:
    begin of ty_compared_object,
      id type ty_object_id,
      different type abap_bool,
      not_found type abap_bool,
      paths type ty_t_object_path,
    end of ty_compared_object .
  types:
    ty_t_compared_object type sorted table of ty_compared_object with unique key primary_key components id .
  types:
    ty_t_package type sorted table of devclass with unique key primary_key components table_line .
  types:
    begin of ty_results,
        target_system          type rfcdest,
        messages               type bapiret2_tab,
        risk_level             type i,
        processed_packages     type ty_t_package,
        unsupported_objects    type ty_t_object_id,
        limited_objects        type ty_t_object_id,
        different_objects      type ty_t_compared_object,
        total_input_objects    type i,
        total_objects_analysed type i,
        total_objects_compared type i,
      end of ty_results .
  types:
    begin of ty_node,
        id        type ty_object_id,
        ref       type ref to zif_defuse_object,
        parent    type ref to data,
        children  type standard table of ref to data with default key,
        depth     type i,
        direction type i,
      end of ty_node .
  types:
    ty_t_node type standard table of ty_node with default key .
  types:
    begin of ty_tree,
        root_nodes type ty_t_node,
      end of ty_tree .

  constants DIRECTION_UP type I value 1 ##NO_TEXT.
  constants DIRECTION_DOWN type I value 2 ##NO_TEXT.
  constants RISK_SAFE type I value 0 ##NO_TEXT.
  constants RISK_WARNINGS type I value 1 ##NO_TEXT.
  constants RISK_RISKY type I value 2 ##NO_TEXT.
  constants RISK_DANGEROUS type I value 3 ##NO_TEXT.
  constants RISK_UNKNOWN type I value 99 ##NO_TEXT.
  data FILTER_STANDARD_OBJECTS type ABAP_BOOL value ABAP_TRUE ##NO_TEXT.
  data MAX_DEPTH type I value 3 ##NO_TEXT.
  data MAX_CHILDREN type I value 999 ##NO_TEXT.
  data UP_TREE type TY_TREE read-only .
  data DOWN_TREE type TY_TREE read-only .
  data TRANSPORTS type CRMT_BSP_BAB_TRREQUEST_TAB read-only .

  events PROGRESS
    exporting
      value(PROGRESS) type TY_PROGRESS .

  methods CONSTRUCTOR .
  class-methods CLASS_CONSTRUCTOR .
  methods ADD_OBJECTS
    importing
      value(OBJECTS) type TY_T_OBJECT_ID
    returning
      value(INSTANCE) type ref to ZCL_DEFUSE .
  methods ADD_TRANSPORTS
    importing
      value(TRANSPORTS) type TRKORRS
    returning
      value(INSTANCE) type ref to ZCL_DEFUSE .
  methods GET_HTML
    returning
      value(HTML) type STRING .
  methods RUN
    importing
      value(TARGET_SYSTEM) type SYSYSID
    returning
      value(RESULTS) type TY_RESULTS .
  methods GET_OBJECTS_TO_CHECK
    returning
      value(OBJECTS) type TY_T_OBJECT_ID .
  methods GET_OBJECT_PATHS
    importing
      value(ID) type TY_OBJECT_ID
    returning
      value(PATHS) type TY_T_OBJECT_PATH .
protected section.

  types:
    ty_t_object type standard table of ref to zif_defuse_object with default key .
  types:
    begin of ty_type_conv,
        tag   type scr_tag,
        cross type cross-type,
        repo  type trobjtype,
      end of ty_type_conv .
  types:
    ty_t_type_conv type standard table of ty_type_conv with default key .

  class-data OBJECT_TYPES type TR_OBJECT_TEXTS .
  class-data TYPE_CONVERSION_TABLE type TY_T_TYPE_CONV .
  data COMPARER type ref to ZIF_DEFUSE_COMPARER .

  methods CREATE_OBJECT
    importing
      value(ID) type TY_OBJECT_ID
    returning
      value(INSTANCE) type ref to ZIF_DEFUSE_OBJECT .
  methods CREATE_DDIC_OBJECT
    importing
      value(FULLNAME) type CLIKE
    returning
      value(INSTANCE) type ref to ZIF_DEFUSE_OBJECT .
  methods GET_WHERE_USED
    importing
      value(FULLNAME) type STRING
    returning
      value(OBJECTS) type TY_T_OBJECT .
  class-methods GET_TYPE_BY_NAME
    importing
      value(FULLNAME) type CLIKE
    exporting
      value(TYPE) type ref to CL_ABAP_TYPEDESCR
      value(REAL_NAME) type STRING .
  methods GET_INCLUDE_REFERENCES
    importing
      !INCLUDE type PROGNAME
    returning
      value(OBJECTS) type ZCL_DEFUSE=>TY_T_OBJECT .
  methods CREATE_OBJECT_FOR_INCLUDE
    importing
      value(INCLUDE) type PROGNAME
    returning
      value(INSTANCE) type ref to ZIF_DEFUSE_OBJECT .
  class-methods GLOBAL_TO_SUBOBJECTS
    importing
      value(GLOBAL) type TY_OBJECT_ID
    returning
      value(SUBS) type TY_T_OBJECT_ID .
  class-methods SUBOBJECT_TO_GLOBAL
    importing
      value(SUB) type TY_OBJECT_ID
    returning
      value(GLOBAL) type TY_OBJECT_ID .
  class-methods GET_OBJECT_PACKAGE
    importing
      value(ID) type TY_OBJECT_ID
    returning
      value(PACKAGE) type DEVCLASS .
  class-methods OBJECT_ID_TO_E071
    importing
      value(ID) type TY_OBJECT_ID
    returning
      value(E071) type E071 .
private section.

  types:
    ty_progress_map type hashed table of ty_progress_item with unique key primary_key components depth .
  types:
    begin of ty_object_cache,
        id  type ty_object_id,
        ref type ref to zif_defuse_object,
      end of ty_object_cache .
  types:
    ty_t_object_cache type hashed table of ty_object_cache with unique key primary_key components id .
  types:
    begin of ty_node_map_item,
    id type ty_object_id,
    nodes type standard table of ref to ty_node with default key,
  end of ty_node_map_item .
  types:
    ty_node_map type hashed table of ty_node_map_item with unique key primary_key components id .
  types:
    ty_object_id_range type range of ty_object_id .
  types:
    ty_t_ref_object_path type standard table of ref to ty_object_path with default key .
  types:
    ty_t_package_map type hashed table of devclass with unique key primary_key components table_line .

  data OBJECT_CACHE type TY_T_OBJECT_CACHE .
  data NODE_MAP type TY_NODE_MAP .
  data UNSUPPORTED_OBJECTS type TY_T_OBJECT_ID .
  data LIMITED_OBJECTS type TY_T_OBJECT_ID .
  data PROGRESS_MAP type TY_PROGRESS_MAP .
  data LAST_PROGRESS_TIME type SYUZEIT .
  data PACKAGE_MAP type TY_T_PACKAGE_MAP .

  class-methods GET_TYPE_CONVERSION_TABLE
    returning
      value(CONVERSION_TABLE) type TY_T_TYPE_CONV .
  methods BUILD_TREE
    importing
      value(DEPTH) type I
      value(EXCLUSION_RANGE) type TY_OBJECT_ID_RANGE optional
    exporting
      !PATHS type TY_T_OBJECT_PATH
    changing
      !NODE type TY_NODE .
  methods UPDATE_PROGRESS
    importing
      value(DEPTH) type I
      value(TOTAL) type I
      value(ANALYSED) type I .
ENDCLASS.



CLASS ZCL_DEFUSE IMPLEMENTATION.


  method add_objects.
    data(lv_total) = lines( objects ).

    "// Add objects as root nodes
    loop at objects assigning field-symbol(<id>).
      me->update_progress( depth = 0 total = lv_total analysed = sy-tabix ).

      data(lo_object) = create_object( <id> ).
      check lo_object is not initial.
      <id> = lo_object->id.

      "// Search dependents (up tree)
      append value #( id = <id> ref = lo_object direction = direction_up )
        to me->up_tree-root_nodes assigning field-symbol(<root_node>).
      build_tree( exporting depth = 1 changing node = <root_node> ).

      "// Search dependencies (down tree)
      append value #( id = <id> ref = lo_object direction = direction_down )
        to me->down_tree-root_nodes assigning <root_node>.
      build_tree( exporting depth = 1 changing node = <root_node> ).
    endloop.

    instance = me.
  endmethod.


  method add_transports.
    check transports is not initial.

    "// Read transport requests
    loop at transports assigning field-symbol(<trkorr>).
      append value #( trkorr = <trkorr> ) to me->transports.
    endloop.
    call function 'TMS_WBO_READ_E070V'
      tables
        tt_e070v = me->transports.

    "// Select tasks
    data(lt_tasks) = me->transports.
    select * from e070 appending table lt_tasks
      for all entries in me->transports
      where strkorr = me->transports-trkorr.

    "// Select objects
    select * from e071 into table @data(lt_e071)
      for all entries in @lt_tasks
      where trkorr = @lt_tasks-trkorr.

    "// Add objects to be processed
    me->add_objects( corresponding ty_t_object_id( lt_e071 ) ).
  endmethod.


  method build_tree.
    data: lt_objects type ty_t_object.
    field-symbols: <tree>  type ty_tree,
                   <node>  type ty_node,
                   <child> type ty_node.

    check depth <= max_depth.
    check node-ref is not initial.

    "// Keep track of processed packages (for testing purposes)
    data(ls_dc) = value zteste_package( devclass = get_object_package( node-id ) ).
    insert zteste_package from ls_dc.

    "// Search for objects (or cached results)
    if node-direction = direction_up. "// Up
      if node-ref->cached_results_up is initial.
        create data node-ref->cached_results_up.
        assign node-ref->cached_results_up->* to field-symbol(<cached_results>).
        <cached_results> = node-ref->search_up( ).
      else.
        assign node-ref->cached_results_up->* to <cached_results>.
      endif.
    else. "// Down
      if node-ref->cached_results_down is initial.
        create data node-ref->cached_results_down.
        assign node-ref->cached_results_down->* to <cached_results>.
        <cached_results> = node-ref->search_down( ).
      else.
        assign node-ref->cached_results_down->* to <cached_results>.
      endif.
    endif.
    lt_objects = <cached_results>.
    delete lt_objects where table_line is initial.

    "// Create children nodes
    append value #( sign = 'E' option = 'EQ' low = node-id ) to exclusion_range.
    loop at lt_objects assigning field-symbol(<object>)
        where table_line->id in exclusion_range. "// No circular references!
      if sy-tabix > me->max_children.
        append node-id to me->limited_objects.
        exit.
      endif.
      append initial line to node-children assigning field-symbol(<child_ref>).
      create data <child_ref> type ty_node.
      assign <child_ref>->* to <child>.
      <child>-id = <object>->id.
      <child>-parent = ref #( node ).
      <child>-ref = <object>.
      <child>-depth = depth.
      <child>-direction = node-direction.

      "// Add to node hashmap
      assign me->node_map[ id = <child>-id ] to field-symbol(<node_map>).
      if sy-subrc <> 0.
        insert value #( id = <child>-id ) into table me->node_map assigning <node_map>.
      endif.
      append ref #( <child> ) to <node_map>-nodes.
    endloop.

    "// Travel down/up the node's children
    check depth < max_depth.
    data(lv_total) = lines( node-children ).
    loop at node-children assigning <child_ref>.
      assign <child_ref>->* to <child>.
      me->update_progress( depth = depth total = lv_total analysed = sy-tabix ).

      build_tree( exporting depth = ( depth + 1 )
                            exclusion_range = exclusion_range
                   changing node = <child> ).
    endloop.
  endmethod.


  method class_constructor.
*----------------------------------------------------------------------
*
*                              zDefuse
*   Check destructive transport requests before they wreck Production
*                     http://abap.ninja/zdefuse
*
*                 Copyright (c) 2017 Guilherme Maeda
*                  Licensed under the MIT license.
*----------------------------------------------------------------------

    type_conversion_table = get_type_conversion_table( ).

    call function 'TR_OBJECT_TABLE'
      tables
        wt_object_text = object_types.
  endmethod.


  method constructor.
    "// Create our Comparer
    me->comparer = new zcl_defuse_standard_comparer( ).
  endmethod.


  method create_ddic_object.
    get_type_by_name( exporting fullname = fullname
      importing real_name = data(lv_name) type = data(lo_type) ).
    check lo_type is not initial. "// ignore invalid types

    "// Type pool?
    find regex '^\\TYPE-POOL=(\w+)\\' in lo_type->absolute_name submatches data(lv_typepool).
    if sy-subrc = 0.
      instance = create_object( id = value #( pgmid = 'R3TR' object = 'TYPE' obj_name = lv_typepool ) ).
      return.
    endif.

    "// View?
    select count( * ) from dd25l into sy-dbcnt
      where viewname = lv_name.
    if sy-dbcnt > 0.
      instance = create_object( id = value #( pgmid = 'R3TR' object = 'VIEW' obj_name = lv_name ) ).
      return.
    endif.

    "// Determine object type according to ABAP kind
    case lo_type->kind.
      when cl_abap_typedescr=>kind_class.
        instance = create_object( id = value #( pgmid = 'LIMU' object = 'CLSD' obj_name = lv_name ) ).
      when cl_abap_typedescr=>kind_intf.
        instance = create_object( id = value #( pgmid = 'R3TR' object = 'INTF' obj_name = lv_name ) ).
      when cl_abap_typedescr=>kind_elem.
        instance = create_object( id = value #( pgmid = 'R3TR' object = 'DTEL' obj_name = lv_name ) ).
      when cl_abap_typedescr=>kind_struct.
        instance = create_object( id = value #( pgmid = 'R3TR' object = 'TABL' obj_name = lv_name ) ).
      when cl_abap_typedescr=>kind_table.
        instance = create_object( id = value #( pgmid = 'R3TR' object = 'TTYP' obj_name = lv_name ) ).
    endcase.
  endmethod.


  method create_object.
    "// Consistency check
    check:
      id-object is not initial,
      id-obj_name is not initial.
    if id-pgmid is initial and id-object is not initial.
      id-pgmid = object_types[ object = id-object ]-pgmid.
    endif.

    "// Filters
    if me->filter_standard_objects = abap_true.
      check id-obj_name(1) ca 'ZY'. "// No standard objects!
    endif.

    "// Check the cache (lightweight)
    assign me->object_cache[ id = id ] to field-symbol(<cache>).
    if sy-subrc = 0.
      instance = <cache>-ref.
      return.
    else.
      data(ls_cache) = value ty_object_cache( id = id ).

      "// Create instance
      data(lv_classname) = |ZCL_DEFUSE_OBJECT_{ id-object }|.
      try.
          create object instance type (lv_classname)
            exporting name = id-obj_name.

          instance->parent = me.
        catch cx_sy_create_object_error into data(lo_exc).
          "// Try to create the object as global
          data(ls_global_id) = subobject_to_global( id ).
          if ls_global_id is not initial and ls_global_id <> id.
            instance = create_object( ls_global_id ).
            if instance is initial.
              log-point id zdefuse subkey 'OBJECT_TYPE_NOT_IMPLEMENTED'
                fields id-pgmid id-object id-obj_name.
              append id to me->unsupported_objects.
            endif.
          else.
            append id to me->unsupported_objects.
          endif.
      endtry.

      "// Check if the object is valid
      if instance is not initial and instance->id is initial.
        free instance.
      endif.
      check instance is not initial.

      "// Add to cache (wanted and real ID)
      insert value #( id = id ref = instance ) into table me->object_cache.
      if id <> instance->id.
        assign object_cache[ id = instance->id ] to <cache>.
        if sy-subrc <> 0.
          insert value #( id = instance->id ref = instance ) into table me->object_cache.
        endif.
      endif.

      "// Keep track of processed packages
      data(lv_package) = get_object_package( instance->id ).
      read table me->package_map with key table_line = lv_package transporting no fields.
      if sy-subrc <> 0 and lv_package is not initial.
        insert lv_package into table me->package_map.
      endif.
    endif.
  endmethod.


  method create_object_for_include.
    "//------------------------------------------------------------
    "// Class parts
    "//------------------------------------------------------------
    if include cs '=' or strlen( include ) = 35.
      data(lv_clsname) = conv seoclsname( include ).
      replace regex '=.*' in lv_clsname with ''.
      select count( * ) from seoclass into sy-dbcnt where clsname = lv_clsname.
      if sy-dbcnt > 0.
        cl_oo_include_naming=>get_instance_by_include(
          exporting progname = include
          receiving cifref = data(lo_class_dummy)
          exceptions others = 4 ).
        data(lo_class) = cast if_oo_class_incl_naming( lo_class_dummy ).
        check lo_class is not initial.
        lo_class->get_mtdname_by_include( exporting progname = include
           receiving mtdname = data(lv_methname)
           exceptions others = 4 ).
        if lv_methname is not initial.
          instance = create_object( id = value #( pgmid = 'LIMU' object = 'METH'
            obj_name = |{ lo_class->clskey-clsname }=>{ lv_methname }| ) ).
        else.
          select single clstype from seoclass into @data(lv_clstype)
            where clsname = @lo_class->clskey-clsname.
          if lv_clstype = '1'. "// Interface
            instance = create_object( id = value #( pgmid = 'R3TR' object = 'INTF'
              obj_name = lo_class->clskey-clsname ) ).
          else. "// Normal class
            instance = create_object( id = value #( pgmid = 'LIMU' object = 'CLSD'
              obj_name = lo_class->clskey-clsname ) ).
          endif.
        endif.
        return.
      endif.
    endif.

    "//------------------------------------------------------------
    "// Enhancement implementation
    "//------------------------------------------------------------
    if include cs '=' and strlen( include ) = 31 and
       include+30(1) = 'E'.
      find regex '^(\w+)=+E\s*$' in include submatches data(lv_enhoname).
      if sy-subrc = 0.
        instance = create_object( id = value #( pgmid = 'R3TR' object = 'ENHO' obj_name = lv_enhoname ) ).
        return.
      endif.
    endif.

    "//------------------------------------------------------------
    "// Function-groups
    "//------------------------------------------------------------
    if strlen( include ) > 4 and include(4) = 'SAPL'.
      find regex '^SAPL(\w+)\s*$' in include submatches data(lv_fugr_name).
      if sy-subrc = 0.
        instance = create_object( id = value #( pgmid = 'R3TR' object = 'FUGR' obj_name = lv_fugr_name ) ).
      else.
        "// Weird-named include
        instance = create_object( id = value #( pgmid = 'LIMU' object = 'REPS' obj_name = include ) ).
      endif.
      return.
    endif.

    "//------------------------------------------------------------
    "// Type pools
    "//------------------------------------------------------------
    if strlen( include ) > 3 and include(3) = '%_C'.
      instance = create_object( id = value #( pgmid = 'R3TR' object = 'TYPE' obj_name = include+3 ) ).
      return.
    endif.

    "//------------------------------------------------------------
    "// Function modules
    "//------------------------------------------------------------
    find regex '^L(\w+)U(\d{2})\s*$' in include submatches lv_fugr_name data(lv_func_index).
    if sy-subrc = 0.
      data(lv_main_include) = |SAPL{ lv_fugr_name }|.
      select single funcname from tfdir into @data(lv_funcname)
        where pname = @lv_main_include and
              include = @lv_func_index.
      if sy-subrc = 0.
        instance = create_object( id = value #( pgmid = 'LIMU' object = 'FUNC' obj_name = lv_funcname ) ).
      else.
        instance = create_object( id = value #( pgmid = 'R3TR' object = 'FUGR' obj_name = lv_fugr_name ) ).
      endif.
      return.
    endif.

    "//------------------------------------------------------------
    "// Regular programs
    "//------------------------------------------------------------
    select single subc from trdir into @data(lv_program_type)
      where name = @include.
    if lv_program_type = 'I'. "// Include
      instance = create_object( id = value #( pgmid = 'LIMU' object = 'REPS' obj_name = include ) ).
    else.
      instance = create_object( id = value #( pgmid = 'R3TR' object = 'PROG' obj_name = include ) ).
    endif.
  endmethod.


  method get_html.
*    data: lv_class     type string,
*          lv_situation type string.
*
*    "// HTML header
*    html =
*      |<!DOCTYPE html>\r\n| &&
*      |<html lang="en">\r\n| &&
*      |<head>\r\n| &&
*      |<meta charset="utf-8">\r\n| &&
*      |<meta http-equiv="X-UA-Compatible" content="IE=edge">\r\n| &&
*      |<meta name="viewport" content="width=device-width, initial-scale=1">\r\n| &&
*      |<!-- Latest compiled and minified CSS -->\r\n| &&
*      |<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" crossorigin="anonymous">\r\n| &&
*      |<title>zDefuse Report</title>\r\n| &&
*      |</head>\r\n| &&
*      |<body>\r\n| &&
*      |<div class="container">\r\n| &&
*      |<h1>zDefuse Report</h1>\r\n| &&
*      |<small>Generated by { sy-uname } on { sy-datum date = user } at { sy-uzeit time = user }</small>\r\n| &&
*      |<hr>\r\n|.
*
*    "// Target system
*    html = html &&
*      |<h2>Target system</h2>\r\n| &&
*      |<big>{ me->target_system }</big>\r\n|.
*
*    "// Transport numbers and descriptions
*    if me->transports is not initial.
*      html = html && |<h2>Transport requests</h2>\r\n| &&
*        |<table class="table table-condensed table-bordered">\r\n| &&
*        |<thead><th>#</th><th>Owner</th><th>Description</th></thead>\r\n| &&
*        |<tbody style="font-family: monospace">\r\n|.
*      loop at me->transports assigning field-symbol(<transport>)
*          where strkorr is initial. "no tasks
*        assign me->transport_texts[ trkorr = <transport>-trkorr ] to field-symbol(<transp_text>).
*        html = html &&
*          |<tr><td>{ <transport>-trkorr }</td>| &&
*          |<td>{ <transport>-as4user }</td><td>{ <transp_text>-as4text }</td></tr>\r\n|.
*      endloop.
*      html = html && |</tbody></table>\r\n|.
*    endif.
*
**    html = html &&
**      |<p>\r\n| &&
**      |Number of objects analysed: { lines( me->up_tree-root_nodes ) number = environment }<br>\r\n| &&
**      |Number of objects compared: { lines( me->object_cache ) number = environment }<br>\r\n| &&
**      |Maximum recursivity used: { me->highest_depth }<br>\r\n| &&
**      |</p>\r\n|.
**    "// TODO - total time
*
*    "// Analysis result
*    html = html && |<h2>Result</h2>\r\n|.
*    case me->analysis_result.
*      when 0.
*        lv_class = 'success'.
*        lv_situation = '<b>No problem!</b> Transport will not cause errors.'.
*      when 1.
*        lv_class = 'warning'.
*        lv_situation = '<b>Be careful.</b> Minor problems were found, you probably want to check them manually.'.
*      when 2.
*        lv_class = 'warning'.
*        lv_situation = '<b>Danger!</b> Differences were found that could cause errors after the transport.'.
*      when 3.
*        lv_class = 'danger'.
*        lv_situation = '<b>Analysis impossible!</b> Some objects could not be analysed because of processing limits.'.
*      when 4.
*        lv_class = 'danger'.
*        lv_situation = '<b>Do not transport!</b> Dependent objects are missing in the target system.'.
*    endcase.
*    html = html &&
*      |<div class="alert alert-{ lv_class }" role="alert">{ lv_situation }</div>\r\n|.
*
*    "// Processing messages
*    if me->messages is not initial.
*      html = html && |<h2>Processing messages</h2>\r\n|.
*      loop at me->messages assigning field-symbol(<message>).
*        case <message>-type.
*          when 'E' or 'A' or 'X'. lv_class = 'error'.
*          when 'W'. lv_class = 'warning'.
*          when others. lv_class = 'info'.
*        endcase.
*        html = html &&
*          |<div class="alert alert-{ lv_class }" role="alert">{ <message>-message }</div>\r\n|.
*      endloop.
*    endif.
*
*    "// Unsupported objects
*    if me->unsupported_objects is not initial.
*      html = html && |<h2>Unsuported objects</h2>\r\n| &&
*        |<p>The following objects were found during the dependency analysis but are not supported.<br>\r\n| &&
*        |They must be checked <b>manually</b>.</p>\r\n| &&
*        |<table class="table table-condensed table-bordered">\r\n| &&
*        |<thead><th>Object Type</th><th>Object Name</th></thead>\r\n| &&
*        |<tbody>\r\n|.
*      loop at me->unsupported_objects assigning field-symbol(<unsupported>).
*        html = html &&
*          |<tr><td>{ object_types[ object = <unsupported>-object ]-text }</td>| &&
*          |<td style="font-family: monospace">{ <unsupported>-obj_name }</td></tr>\r\n|.
*      endloop.
*      html = html && |</tbody></table>\r\n|.
*    endif. "me->unsupported_objects is not initial.
*
*    "// Limited objects
*    if me->limited_objects is not initial.
*      html = html && |<h2>Limited objects</h2>\r\n| &&
*        |<p>The following objects had too many dependents and/or dependencies, and therefore| &&
*        | made the Defuse analysis <b>impossible</b>.\r\n| &&
*        |Increase the Maximum children parameter or remove these objects from your selection,| &&
*        | and try again.</p>\r\n| &&
*        |<table class="table table-condensed table-bordered">\r\n| &&
*        |<thead><th>Object Type</th><th>Object Name</th></thead>\r\n| &&
*        |<tbody>\r\n|.
*      loop at me->limited_objects assigning field-symbol(<limited>).
*        html = html &&
*          |<tr><td>{ object_types[ object = <limited>-object ]-text }</td>| &&
*          |<td style="font-family: monospace">{ <limited>-obj_name }</td></tr>\r\n|.
*      endloop.
*      html = html && |</tbody></table>\r\n|.
*    endif. "me->limited_objects is not initial.
*
*    "// Different objects
*    if me->compare_results is not initial.
*      html = html && |<h2>Different objects in target system</h2>\r\n| &&
*        |<p>The following objects were found to be dependent or dependencies of the transported objects.<br>\r\n| &&
*        |Objects marked in yellow are different in the target system.<br>\r\n| &&
*        |Objects marked in red don't exist in the target system.<br>\r\n| &&
*        |<table class="table table-condensed table-bordered">\r\n| &&
*        |<thead><th>Object Type</th><th>Object Name</th><th>Situation</th></thead>\r\n| &&
*        |<tbody>\r\n|.
*      loop at me->compare_results assigning field-symbol(<compare>) where equal is initial.
*        lv_class = 'warning'.
*        lv_situation = 'Different'.
*        if <compare>-nonversionable = 'X'.
*          lv_class = 'danger'.
*          lv_situation = 'Error: not versionable'.
*        elseif <compare>-not_readable = 'X'.
*          lv_class = 'danger'.
*          lv_situation = 'Error: not readable'.
*        elseif <compare>-not_comparable = 'X'.
*          lv_class = 'danger'.
*          lv_situation = 'Not found in target system'.
*        endif.
*        html = html &&
*          |<tr class="{ lv_class }"><td>{ object_types[ object = <compare>-fragment ]-text }</td>| &&
*          |<td style="font-family: monospace">{ <compare>-fragname }</td><td>{ lv_situation }</td></tr>\r\n|.
*      endloop.
*      html = html && |</tbody></table>\r\n|.
*    endif. "me->compare_results is not initial.
*
*    html = html &&
*      |<footer style="text-align: center;">\r\n| &&
*      |zDefuse (<a href="https://github.com/koemaeda/zdefuse">github.com/koemaeda/zdefuse</a>)\r\n| &&
*      |<hr></footer>\r\n| &&
*      |</div></body>\r\n| &&
*      |</html>\r\n|.
  endmethod.


  method get_include_references.
    "//
    "// This code is based on class CL_WB_CROSSREFERENCE
    "// (resposible for generating the indexes of referenced objects)
    "//

    "//----------------------------------------------------------------
    "// Read referenced includes
    "//----------------------------------------------------------------
    select * from wbcrossi into table @data(lt_incls)
      where include = @include.
    loop at lt_incls assigning field-symbol(<incl>).
      append create_object( value #(
        pgmid = 'LIMU' object = 'REPS' obj_name = <incl>-name ) ) to objects.
    endloop.

    "//----------------------------------------------------------------
    "// Read references to other ABAP objects
    "//----------------------------------------------------------------
    select * from cross into table @data(lt_modules)
      where include = @include.
    loop at lt_modules assigning field-symbol(<module>).
      if <module>-prog is not initial.
        append create_object( value #(
          pgmid = 'R3TR' object = 'PROG' obj_name = <module>-prog ) ) to objects.
      else.
        assign type_conversion_table[ cross = <module>-type ] to field-symbol(<type>).
        if sy-subrc <> 0.
          log-point id zdefuse subkey 'CROSS_TYPE_NOT_SUPPORTED' fields <module>-type <module>-prog <module>-name.
        elseif <type>-repo is not initial.
          append create_object( value #(
            object = <type>-repo obj_name = <module>-name ) ) to objects.
        endif.
      endif.
    endloop.

    "//----------------------------------------------------------------
    select * from wbcrossgt into table @data(lt_gtypes)
      where include = @include.
    loop at lt_gtypes assigning field-symbol(<gtype>).
      assign type_conversion_table[ tag = <gtype>-otype ] to <type>.
      if sy-subrc <> 0.
        log-point id zdefuse subkey 'TAG_NOT_SUPPORTED' fields <module>-type <module>-prog <module>-name.
        continue.
      endif.
      case <type>-tag.
          "// Special objects
        when cl_abap_compiler=>tag_type.
          append create_ddic_object( <gtype>-name ) to objects.
        when cl_abap_compiler=>tag_data.
          "// Determine if it's a class or interface
          data(lv_clsname) = conv seoclsname( <gtype>-name ).
          replace regex '\\.+' in lv_clsname with ''.
          select single clstype from seoclass into @data(lv_class_type)
            where clsname = @lv_clsname.
          if lv_class_type = '1'.
            append create_object( value #(
              pgmid = 'R3TR' object = 'INTF' obj_name = lv_clsname ) ) to objects.
          else.
            append create_object( value #(
              pgmid = 'R3TR' object = 'CLSD' obj_name = lv_clsname ) ) to objects.
          endif.
        when others.
          "// Simple name matching
          if <type>-repo is not initial.
            append create_object( value #(
              object = <type>-repo obj_name = <gtype>-name ) ) to objects.
          endif.
      endcase.
    endloop.

    "// Organize results
    sort objects. delete adjacent duplicates from objects.
  endmethod.


  method get_objects_to_check.
    loop at me->object_cache assigning field-symbol(<cache>).
      append <cache>-ref->id to objects.
    endloop.
    sort objects. delete adjacent duplicates from objects.

    "// Remove root objects from the list
    loop at me->down_tree-root_nodes assigning field-symbol(<node>).
      "// Exclude exact-matching object ID
      delete objects where pgmid = <node>-id-pgmid and
                           object = <node>-id-object and
                           obj_name = <node>-id-obj_name.

      if <node>-id-pgmid = 'R3TR' or "// Global object
         <node>-id-object = 'CLSD'.
        "// Exclude subobjects
        data(lt_subs) = global_to_subobjects( <node>-id ).
        loop at lt_subs assigning field-symbol(<sub>).
          delete objects where pgmid = <sub>-pgmid and
                               object = <sub>-object and
                               obj_name = <sub>-obj_name.
        endloop.
      else. "// Subobjects
        "//
        "// Exclude global object, if practically they are the same
        data(ls_global) = subobject_to_global( <node>-id ).
        if 'PROG|DOMA|DTEL|TABL' cs ls_global-object.
          delete objects where pgmid = ls_global-pgmid and
                               object = ls_global-object and
                               obj_name = ls_global-obj_name.
        endif.
      endif.

    endloop.
  endmethod.


  method get_object_package.
    data(ls_e071) = object_id_to_e071( id ).

    data(ls_tadir_key) = value tadir( ).
    call function 'TR_CHECK_TYPE'
      exporting
        wi_e071              = ls_e071
        iv_translate_objname = 'X'
      importing
        we_tadir             = ls_tadir_key.
    if ls_tadir_key is not initial.
      select single devclass from tadir into package
        where pgmid = ls_tadir_key-pgmid and
              object = ls_tadir_key-object and
              obj_name = ls_tadir_key-obj_name.
    endif.
  endmethod.


  method get_object_paths.
    "// Consistency check
    check:
      id-object is not initial,
      id-obj_name is not initial.
    if id-pgmid is initial and id-object is not initial.
      id-pgmid = object_types[ object = id-object ]-pgmid.
    endif.

    "// Traverse all the nodes referencing this object,
    "//  and build the paths according to the tree it is in.
    "// ALWAYS from the node towards a root node.
    assign me->node_map[ id = id ] to field-symbol(<node_map>).
    if sy-subrc <> 0.
      data(ls_global) = subobject_to_global( id ).
      assign me->node_map[ id = ls_global ] to <node_map>.
      if sy-subrc <> 0.
        log-point id zdefuse subkey 'NODE_PATH_NOT_FOUND' fields id.
        return.
      endif.
    endif.

    loop at <node_map>-nodes into data(lr_node)
        where table_line->*-depth > 0.
      data(ls_path) = value ty_object_path(
        depth = lr_node->*-depth ).
      while lr_node is bound.
        if lr_node->*-direction = direction_up. "// Up = dependents
          append lr_node->*-id to ls_path-parts.
        else. "// Down = dependencies
          insert lr_node->*-id into ls_path-parts index 1.
        endif.
        lr_node = cast #( lr_node->*-parent ).
      endwhile.
      ls_path-id_from = ls_path-parts[ 1 ].
      ls_path-id_to = ls_path-parts[ lines( ls_path-parts ) ].

      insert ls_path into table paths.
    endloop.
    delete adjacent duplicates from paths.

    "// Keep only the shortest (lowest depth) paths
    loop at paths assigning field-symbol(<path>).
      delete paths where depth > <path>-depth and
                         id_from = <path>-id_from and
                         id_to = <path>-id_to.
    endloop.

    "// Special class/method rules:
    "// We only keep one part for a pair of class definition/method
    "// Stays whatever comes FIRST
    loop at paths assigning <path>.
      check lines( <path>-parts ) > 2.
      data: ls_prev_part type ty_object_id.
      loop at <path>-parts assigning field-symbol(<part>).
        if <part>-object = 'METH' and ls_prev_part-object = 'CLSD'.
          split <part>-obj_name at '=>' into data(lv_class) data(lv_method).
          if sy-subrc = 0 and lv_class = ls_prev_part-obj_name.
            delete table <path>-parts from <part>.
            continue.
          endif.
        elseif <part>-object = 'CLSD' and ls_prev_part-object = 'METH'.
          split ls_prev_part-obj_name at '=>' into lv_class lv_method.
          if sy-subrc = 0 and lv_class = <part>-obj_name.
            delete table <path>-parts from <part>.
            continue.
          endif.
        endif.
        ls_prev_part = <part>.
      endloop.
    endloop.
  endmethod.


  method get_type_by_name.
    "// Build a list of all possible type names
    data: lt_prev_pass type table of string,
          lt_curr_pass type table of string.
    split fullname at '\TY:' into table data(lt_parts).
    loop at lt_parts assigning field-symbol(<part>).
      at first.
        append <part> to lt_prev_pass.
        continue.
      endat.
      loop at lt_prev_pass assigning field-symbol(<prev_possibility>).
        append |{ <prev_possibility> }=>{ <part> }| to lt_curr_pass.
        append |{ <prev_possibility> }-{ <part> }| to lt_curr_pass.
      endloop.
      lt_prev_pass = lt_curr_pass.
      clear lt_curr_pass.
    endloop.

    "// Use RTTS to determine the kind
    loop at lt_prev_pass assigning field-symbol(<fullname>).
      cl_abap_typedescr=>describe_by_name(
        exporting p_name = <fullname>
        receiving p_descr_ref = type
        exceptions type_not_found = 1 ).
      if sy-subrc = 0.
        real_name = type->get_relative_name( ).
        if real_name cs '%'.
          real_name = <fullname>.
        endif.
        exit.
      endif.
    endloop.
    check type is not initial.

    "// Class type?
    find regex '^\\CLASS=(\w+)\\TYPE=(\w+)' in type->absolute_name
      submatches data(lv_classname) data(lv_typename).
    if sy-subrc = 0.
      real_name = |{ lv_classname }=>{ lv_typename }|.
    endif.
  endmethod.


  method GET_TYPE_CONVERSION_TABLE.
    "// @see CL_WB_CROSSREFERENCE=>GET_INDEX
    "// @see include CRFORM01
    conversion_table = value #(
      ( tag = cl_abap_compiler=>tag_function           cross = 'F'  repo = 'FUNC' )
      ( tag = cl_abap_compiler=>tag_type_pool          cross = 'G'  repo = 'TYPE' )
      ( tag = cl_abap_compiler=>tag_dialog             cross = 'D'  repo = 'DIAL' )
      ( tag = cl_abap_compiler=>tag_transformation     cross = '2'  repo = 'XSLT' )
      ( tag = cl_abap_compiler=>tag_transaction        cross = 'T'  repo = 'TRAN' )
      ( tag = cl_abap_compiler=>tag_set_get_id         cross = 'P'  repo = 'PARA' )
      ( tag = cl_abap_compiler=>tag_authority_object   cross = 'A'  repo = 'SUSO' )
      ( tag = cl_abap_compiler=>tag_matchcode          cross = 'V'  repo = 'SHLP' )
      ( tag = cl_abap_compiler=>tag_matchcode          cross = 'M'  repo = 'SHLP' )
      ( tag = cl_abap_compiler=>tag_program            cross = 'R'  repo = 'PROG' )
      ( tag = cl_abap_compiler=>tag_enhancement_exit   cross = '4'                )
      ( tag = cl_abap_compiler=>tag_enhancement_impl   cross = '5'  repo = 'ENHO' )
      ( tag = cl_abap_compiler=>tag_section            cross = '6'                )
      ( tag = cl_abap_compiler=>tag_enhancement_spot   cross = '7'  repo = 'ENHS' )
      ( tag = cl_abap_compiler=>tag_infotype           cross = '8'                )
      ( tag = cl_abap_compiler=>tag_form               cross = 'U'  repo = 'PROG' )
      ( tag = cl_abap_compiler=>tag_common_part        cross = 'O'  repo = 'PROG' )
      ( tag = cl_abap_compiler=>tag_break_point        cross = 'H'                )
      ( tag = cl_abap_compiler=>tag_pf_status          cross = 'E'                )
      ( tag = cl_abap_compiler=>tag_title              cross = 'I'                )
      ( tag = cl_abap_compiler=>tag_message_number     cross = 'N'  repo = 'MSAG' )
      ( tag = cl_abap_compiler=>tag_message_id         cross = 'N'  repo = 'MSAG' )
      ( tag = cl_abap_compiler=>tag_rmac_macro         cross = 'K'                )
      ( tag = cl_abap_compiler=>tag_db_function        cross = '~'                )
      ( tag = cl_abap_compiler=>tag_type               cross = 'S'  repo = 'TABL' )
      ( tag = cl_abap_compiler=>tag_type                           ) "// Special
      ( tag = cl_abap_compiler=>tag_data                           ) "// Special
      ( tag = cl_abap_compiler=>tag_event                          ) "// Special
      ( tag = cl_abap_compiler=>tag_method                          repo = 'METH' )
      ( tag = cl_abap_compiler=>tag_table_key                                     )
      ( tag = cl_abap_compiler=>tag_include                         repo = 'PROG' )
      ( tag = cl_abap_compiler=>tag_screen                          repo = 'PROG' )
    ).
  endmethod.


  method get_where_used.
    "// Use the standard Where Used list
    data: lt_findstrings type table of string,
          lt_founds      type table of rsfindlst.
    call function 'RS_EU_CROSSREF'
      exporting
        i_find_obj_cls           = ''
        no_dialog                = 'X'
        with_generated_objects   = 'X'
        i_full_name              = fullname
      tables
        i_findstrings            = lt_findstrings
        o_founds                 = lt_founds
      exceptions
        not_executed             = 1
        not_found                = 2
        illegal_object           = 3
        no_cross_for_this_object = 4
        batch                    = 5
        batchjob_error           = 6
        wrong_type               = 7
        object_not_exist         = 8
        others                   = 9.
    if sy-subrc <> 0 and sy-subrc <> 2.
      log-point id zdefuse subkey 'RS_EU_CROSSREF' fields fullname sy-subrc.
      return.
    endif.

    loop at lt_founds assigning field-symbol(<found>).
      case <found>-object_cls(1).
          "//--------------------------------------------------
        when 'P' or "// ABAP programs
             'O'.   "// Objects/classes
          "//--------------------------------------------------
          case <found>-object_cls.
            when swbm_c_type_prg_dynpro.
              append create_object_for_include( conv #( <found>-encl_objec ) ) to objects.
            when others.
              append create_object_for_include( conv #( <found>-object ) ) to objects.
          endcase. "<found>-object_cls
          "//--------------------------------------------------
        when 'I'. "// Interfaces
          "//--------------------------------------------------
          append create_object( id = value #( pgmid = 'R3TR' object = 'INTF'
            obj_name = <found>-object ) ) to objects.
          "//--------------------------------------------------
        when 'F'. "// Functions
          "//--------------------------------------------------
          case <found>-object_cls.
            when swbm_c_type_function.
              append create_object( id = value #( pgmid = 'LIMU' object = 'FUNC'
                obj_name = <found>-object ) ) to objects.
            when others.
              append create_object_for_include( conv #( <found>-object ) ) to objects.
          endcase. "<found>-object_cls
          "//--------------------------------------------------
        when 'R'. "// Get/Set parameter
          "//--------------------------------------------------
          append create_object( id = value #( pgmid = 'R3TR' object = 'PARA'
            obj_name = <found>-object ) ) to objects.
          "//--------------------------------------------------
        when 'T'. "// Transactions
          "//--------------------------------------------------
          append create_object( id = value #( pgmid = 'R3TR' object = 'TRAN'
            obj_name = <found>-object ) ) to objects.
          "//--------------------------------------------------
        when 'A'. "// Dialog modules
          "//--------------------------------------------------
          append create_object( id = value #( pgmid = 'R3TR' object = 'DIAL'
            obj_name = <found>-object ) ) to objects.
          "//--------------------------------------------------
        when 'X'. "// Enhancements
          "//--------------------------------------------------
          case <found>-object_cls.
            when swbm_c_type_badi_def or swbm_c_type_badi_imp or
                 swbm_c_type_enhancement or swbm_c_type_enh_dictionary or swbm_c_type_enh_composite.
              append create_object( id = value #( pgmid = 'R3TR' object = 'ENHO'
                obj_name = <found>-object ) ) to objects.
            when others.
              append create_object( id = value #( pgmid = 'R3TR' object = 'ENHS'
                obj_name = <found>-object ) ) to objects.
          endcase. "<found>-object_cls
          "//--------------------------------------------------
        when 'Y'. "// Web Dynpro
          "//--------------------------------------------------
          if <found>-encl_objec is not initial.
            append create_object( id = value #( pgmid = 'R3TR' object = 'WDYN'
              obj_name = <found>-encl_objec ) ) to objects.
          endif.
          "//--------------------------------------------------
        when 'D'. "// Data dictionary
          "//--------------------------------------------------
          case <found>-object_cls.
            when swbm_c_type_ddic_searchhelp or swbm_c_type_ddic_matchcode.
              append create_object( value #( pgmid = 'R3TR' object = 'SHLP'
                obj_name = <found>-object ) ) to objects.
            when others.
              if <found>-encl_objec is not initial.
                append create_ddic_object( <found>-encl_objec ) to objects.
              else.
                append create_ddic_object( <found>-object ) to objects.
              endif.
          endcase.
      endcase. "<found>-object_cls(1)
    endloop.

    sort objects. delete adjacent duplicates from objects.
    delete objects where table_line is initial.
  endmethod.


  method global_to_subobjects.
    "// Class definitions are read as global objects
    if global-object = 'CLSD'.
      global-pgmid = 'R3TR'.
      global-object = 'CLAS'.
    endif.

    "// Use standard function to break down our object list
    "//  into fragments/global objects
    data: lt_fragments type table of vrso.
    call function 'SVRS_RESOLVE_E071_OBJ'
      exporting
        e071_obj        = corresponding e071( global )
      tables
        obj_tab         = lt_fragments
      exceptions
        not_versionable = 1
        others          = 2.
    if sy-subrc <> 0.
      append global to subs.
      return.
    endif.

    loop at lt_fragments assigning field-symbol(<fragment>).
      append value #( pgmid = 'LIMU' object = <fragment>-objtype obj_name = <fragment>-objname )
        to subs assigning field-symbol(<sub>).

      "// Convert standard naming
      case <sub>-object.
        when 'METH'. "// Methods
          data: ls_method_key type seocmpkey.
          ls_method_key = <sub>-obj_name.
          <sub>-obj_name = |{ ls_method_key-clsname }=>{ ls_method_key-cmpname }|.
      endcase.
    endloop.
    sort subs. delete adjacent duplicates from subs.
  endmethod.


  method object_id_to_e071.
    e071 = corresponding #( id ).

    case e071-object.
      when 'METH'. "// Methods
        data: ls_method_key type seocmpkey.
        split e071-obj_name at '=>' into ls_method_key-clsname ls_method_key-cmpname.
        if sy-subrc = 0.
          e071-obj_name = ls_method_key.
        endif.
    endcase.
  endmethod.


  method run.
    results-target_system = target_system.

    "// Copy Search results
    results-total_input_objects = lines( me->down_tree-root_nodes ).
    results-total_objects_analysed = lines( me->object_cache ).
    results-processed_packages = corresponding #( me->package_map ).

    sort me->unsupported_objects. delete adjacent duplicates from me->unsupported_objects.
    results-unsupported_objects = me->unsupported_objects.
    sort me->limited_objects. delete adjacent duplicates from me->limited_objects.
    results-limited_objects = me->limited_objects.

    "// Compare the objects in the target system
    me->comparer->compare_objects(
      exporting target_system = target_system
                objects = me->get_objects_to_check( )
      importing total_compared = results-total_objects_compared
                different = data(lt_different)
                not_found = data(lt_not_found)
                ignored = data(lt_ignored)
                messages = data(lt_comp_messages) ).

    loop at lt_different assigning field-symbol(<object>).
      insert value #( id = <object> different = abap_true paths = get_object_paths( <object> ) )
        into table results-different_objects.
    endloop.
    loop at lt_not_found assigning <object>.
      insert value #( id = <object> not_found = abap_true paths = get_object_paths( <object> ) )
        into table results-different_objects.
    endloop.
    append lines of lt_comp_messages to results-messages.

    "// Objects in the up tree (dependents) must exist in the target system to be relevant
    loop at results-different_objects assigning field-symbol(<not_found>)
        where not_found = abap_true.
      assign me->node_map[ id = <not_found>-id ]
        to field-symbol(<node_map>).
      if sy-subrc <> 0.
        log-point id zdefuse subkey 'COMPARE_OBJECT_TYPE_UNSUPPORTED'
          fields <not_found>-id.
        delete table results-different_objects from <not_found>.
        continue.
      endif.
      read table <node_map>-nodes with key table_line->*-direction = direction_down
        transporting no fields.
      if sy-subrc <> 0. "// no nodes in the down tree
        delete table results-different_objects from <not_found>.
      endif.
    endloop.

    "//----------------------------------------------------------------
    "//   Determine the risk level
    "//----------------------------------------------------------------

    "// (1) The risk level starts as SAFE.
    results-risk_level = risk_safe.

    "// (2) The risk level is UNKNOWN and the analysis is finished if:
    "//   * Any relevant object was "limited" - has not been completely analysed
    "//      due to processing restrictions
    "//   * There are error messages
    if results-limited_objects is not initial.
      results-risk_level = risk_unknown.
      return.
    endif.
    loop at results-messages transporting no fields where type ca 'EAX'.
      results-risk_level = risk_unknown.
      return.
    endloop.

    "// (3) The risk level is WARNINGS if:
    "//   * There are unsupported objects found in the Search
    "//   * Any compared object is different in the target system
    read table results-different_objects transporting no fields with key different = abap_true.
    if sy-subrc = 0 or results-unsupported_objects is not initial.
      results-risk_level = risk_warnings.
    endif.

    "// (4) The risk level is RISKY if:
    "//   * Any object in the first level (depth=1) is different in the target system
    loop at results-different_objects assigning field-symbol(<different>)
        where different = abap_true.
      assign me->node_map[ id = <different>-id ] to <node_map>.
      if sy-subrc <> 0.
        log-point id zdefuse subkey 'COMPARE_OBJECT_TYPE_UNSUPPORTED'
          fields <different>-id.
        continue.
      endif.
      read table <node_map>-nodes with key table_line->*-depth = 1
        transporting no fields.
      if sy-subrc = 0. "//
        results-risk_level = risk_risky.
        exit.
      endif.
    endloop.

    "// (5) The risk level is DANGEROUS if:
    "//   * Any object in the down tree (dependencies) is not found in the target system
    loop at results-different_objects transporting no fields where not_found = abap_true.
      results-risk_level = risk_dangerous.
      exit.
    endloop.
  endmethod.


  method subobject_to_global.
    data: ls_tadir type tadir.

    "// Convert subobject ID to global ID
    "// e.g. LIMU REPS to R3TR PROG
    call function 'TR_CHECK_TYPE'
      exporting
        wi_e071              = corresponding e071( sub )
        iv_translate_objname = 'X'
      importing
        we_tadir             = ls_tadir.

    global = corresponding #( ls_tadir ).
  endmethod.


  method update_progress.
    "// Save on CPU and bandwidth (max. 1 update/sec)
    if depth > 0.
      check me->last_progress_time <> sy-uzeit.
    endif.

    "// Update progress map
    assign me->progress_map[ depth = depth ] to field-symbol(<progress>).
    if sy-subrc <> 0.
      data(ls_new_progress) = value ty_progress_item( depth = depth ).
      insert ls_new_progress into table me->progress_map assigning <progress>.
    endif.
    <progress>-total = total.
    <progress>-analysed = analysed.
    <progress>-progress = ( <progress>-analysed * 100 ) / <progress>-total.

    "// If running on background -> max 1 event/minute
    if sy-batch is not initial.
      check me->last_progress_time(4) <> sy-uzeit(4).
    endif.

    "// Trigger progress information event
    data: lt_progress type ty_progress.
    do depth + 1 times.
      insert me->progress_map[ depth = sy-index - 1 ] into table lt_progress.
    enddo.
    raise event progress exporting progress = lt_progress.

    me->last_progress_time = sy-uzeit.
  endmethod.
ENDCLASS.
