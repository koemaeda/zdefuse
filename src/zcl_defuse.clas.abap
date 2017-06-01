class ZCL_DEFUSE definition
  public
  create public

  global friends ZCL_DEFUSE_OBJECT_PROG
                 ZCL_DEFUSE_OBJECT_WDYN
                 ZIF_DEFUSE_OBJECT .

public section.

  types:
    ty_t_object type standard table of ref to zif_defuse_object with default key .
  types:
    begin of ty_object_id,
        pgmid    type pgmid,
        object   type trobjtype,
        obj_name type trobj_name,
      end of ty_object_id .
  types:
    ty_t_object_id type standard table of ty_object_id with default key .
  types:
    begin of ty_object_cache,
        id  type ty_object_id,
        ref type ref to zif_defuse_object,
      end of ty_object_cache .
  types:
    ty_t_object_cache type hashed table of ty_object_cache with unique key primary_key components id .
  types:
    begin of ty_node,
        id       type ty_object_id,
        ref      type ref to zif_defuse_object,
        children type standard table of ref to data with default key,
      end of ty_node .
  types:
    ty_t_node type standard table of ty_node with default key .
  types:
    begin of ty_tree,
        root_nodes type ty_t_node,
      end of ty_tree .
  types:
    begin of ty_type_conv,
        tag   type scr_tag,
        cross type cross-type,
        repo  type trobjtype,
      end of ty_type_conv .
  types:
    ty_t_type_conv type standard table of ty_type_conv with default key .

  class-data TYPE_CONVERSION_TABLE type TY_T_TYPE_CONV read-only .
  class-data OBJECT_TYPES type TR_OBJECT_TEXTS read-only .
  data FILTER_STANDARD_OBJECTS type ABAP_BOOL value ABAP_TRUE ##NO_TEXT.
  data MAX_DEPTH type I value 10 ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      value(TARGET_SYSTEM) type RFCDEST optional .
  class-methods CLASS_CONSTRUCTOR .
  methods ADD_OBJECTS
    importing
      value(OBJECTS) type TY_T_OBJECT_ID
    returning
      value(INSTANCE) type ref to ZCL_DEFUSE .
  methods ADD_TRANSPORTS
    importing
      value(TRANSPORTS) type E070_T
    returning
      value(INSTANCE) type ref to ZCL_DEFUSE .
  methods GET_HTML
    returning
      value(HTML) type STRING .
  methods RUN
    returning
      value(INSTANCE) type ref to ZCL_DEFUSE .
  methods GET_OBJECTS_TO_CHECK
    importing
      !NODE type TY_NODE optional
    returning
      value(OBJECTS) type TY_T_OBJECT_ID .
protected section.

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
private section.

  data TARGET_SYSTEM type RFCDEST .
  class-data OBJECT_CACHE type TY_T_OBJECT_CACHE .
  data UP_TREE type TY_TREE .
  data DOWN_TREE type TY_TREE .
  data UNSUPPORTED_OBJECTS type TY_T_OBJECT_ID .
  data MESSAGES type BAPIRET2_TAB .
  data COMPARE_RESULTS type VRS_COMPARE_ITEM_TAB .
  data ANALYSIS_RESULT type I .
  data TRANSPORTS type E070_T .
  data TRANSPORT_TEXTS type E07T_T .

  class-methods GET_TYPE_CONVERSION_TABLE
    returning
      value(CONVERSION_TABLE) type TY_T_TYPE_CONV .
  methods BUILD_TREE
    importing
      value(DEPTH) type I default 0
      value(DIRECTION) type I
    changing
      !NODE type TY_NODE .
  methods COMPARE_OBJECTS
    returning
      value(RESULTS) type VRS_COMPARE_ITEM_TAB .
  class-methods SUBOBJECT_TO_GLOBAL
    importing
      value(SUB) type TY_OBJECT_ID
    returning
      value(GLOBAL) type TY_OBJECT_ID .
ENDCLASS.



CLASS ZCL_DEFUSE IMPLEMENTATION.


  method add_objects.
    data: lv_progress type i.

    loop at objects assigning field-symbol(<id>).
      lv_progress = ( sy-tabix * 100 ) / lines( objects ).
      call function 'SAPGUI_PROGRESS_INDICATOR'
        exporting
          percentage = lv_progress
          text       = |Analysing { <id>-object } { <id>-obj_name }|.

      data(lo_object) = create_object( <id> ).
      check lo_object is not initial.

      "// Search dependents (up tree)
      append value #( id = <id> ref = lo_object ) to me->up_tree-root_nodes
        assigning field-symbol(<root_node>).
      build_tree( exporting direction = 1 changing node = <root_node> ).

      "// Search dependencies (down tree)
      append value #( id = <id> ref = lo_object ) to me->down_tree-root_nodes
        assigning <root_node>.
      build_tree( exporting direction = 2 changing node = <root_node> ).
    endloop.

    instance = me.
  endmethod.


  method add_transports.
    check transports is not initial.

    append lines of transports to me->transports.

    "// Read transport texts
    select * from e07t appending table @me->transport_texts
      for all entries in @transports
      where trkorr = @transports-trkorr.

    "// Select objects
    select * from e071 into table @data(lt_e071)
      for all entries in @transports
      where trkorr = @transports-trkorr.

    "// Add objects to be processed
    me->add_objects( corresponding ty_t_object_id( lt_e071 ) ).
  endmethod.


  method build_tree.
    field-symbols: <child> type ty_node.

    check depth <= max_depth.

    "// Search for objects
    check node-ref is not initial.
    if direction = 1.
      data(lt_objects) = node-ref->search_up( ).
    else.
      lt_objects = node-ref->search_down( ).
    endif.
    delete lt_objects where table_line is initial.

    "// Add the children to the tree node
    loop at lt_objects assigning field-symbol(<object>).
      append initial line to node-children assigning field-symbol(<child_ref>).
      create data <child_ref> type ty_node.
      assign <child_ref>->* to <child>.

      <child>-id = <object>->id.
      <child>-ref = <object>.

      build_tree( exporting depth = ( depth + 1 ) direction = direction
        changing node = <child> ).
    endloop.
  endmethod.


  method class_constructor.
    type_conversion_table = get_type_conversion_table( ).

    call function 'TR_OBJECT_TABLE'
      tables
        wt_object_text = object_types.
  endmethod.


  method compare_objects.
    if me->target_system is initial.
      append value #( type = 'E' message = 'Comparison is impossible. Target system is not defined!' )
        to me->messages.
      return.
    endif.

    "// Build comparison list
    data(lt_objects) = corresponding e071_t( me->get_objects_to_check( ) ).
    check lt_objects is not initial.

    "// Use standard comparison
    call function 'SVRS_MASSCOMPARE_ACT_OBJECTS'
      exporting
        it_e071          = lt_objects
        iv_rfcdest_b     = me->target_system
      importing
        et_compare_items = results
      exceptions
        rfc_error        = 1
        not_supported    = 2
        others           = 3.
    if sy-subrc <> 0.
      log-point id zdefuse subkey 'COMPARE_OBJECTS_ERROR'.
      append initial line to me->messages assigning field-symbol(<message>).
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
    endif.
  endmethod.


  method constructor.
    me->target_system = target_system.
  endmethod.


  method create_ddic_object.
    get_type_by_name( exporting fullname = fullname
      importing real_name = data(lv_name) type = data(lo_type) ).
    check lo_type is not initial. "// ignore invalid types

    "// Determine object type according to ABAP kind
    case lo_type->kind.
      when cl_abap_typedescr=>kind_class.
        instance = create_object( id = value #( pgmid = 'R3TR' object = 'CLSD' obj_name = lv_name ) ).
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
    assign object_cache[ id = id ] to field-symbol(<cache>).
    if sy-subrc = 0.
      instance = <cache>-ref.
      return.
    else.
      data(ls_cache) = value ty_object_cache( id = id ).

      "// Create instance
      data(lv_classname) = |ZCL_DEFUSE_OBJECT_{ id-object }|.
      try.
          create object ls_cache-ref type (lv_classname)
            exporting name = id-obj_name.
          ls_cache-ref->parent = me.
          insert ls_cache into table object_cache.
          instance = ls_cache-ref.
        catch cx_sy_create_object_error into data(lo_exc).

          "// Try to create the object as global
          data(ls_global) = subobject_to_global( id ).
          if ls_global is not initial and ls_global <> id.
            instance = create_object( ls_global ).
            if instance is initial.
              log-point id zdefuse subkey 'OBJECT_TYPE_NOT_IMPLEMENTED'
                fields id-pgmid id-object id-obj_name.
              append id to me->unsupported_objects.
            endif.
          endif.
      endtry.
    endif.
  endmethod.


  method create_object_for_include.
    if include cs '='.
      data(lv_clsname) = conv seoclsname( include ).
      replace regex '=.+' in lv_clsname with ''.
      select count( * ) from seoclass into sy-dbcnt where clsname = lv_clsname.
      if sy-dbcnt > 0.
        "//------------------------------------------------------------
        "// Class parts
        "//------------------------------------------------------------
        data(lo_class) = cast if_oo_class_incl_naming(
          cl_oo_include_naming=>get_instance_by_include( include ) ).
        check lo_class is not initial.
        lo_class->get_mtdname_by_include( exporting progname = include
           receiving mtdname = data(lv_methname)
           exceptions others = 4 ).
        if lv_methname is not initial.
          instance = create_object( id = value #( pgmid = 'LIMU' object = 'METH'
            obj_name = |{ lo_class->clskey-clsname }=>{ lv_methname }| ) ).
        else.
          instance = create_object( id = value #( pgmid = 'LIMU' object = 'CLSD'
            obj_name = lo_class->clskey-clsname ) ).
        endif.
      else.
        "// Other objects
        select single pgmid, object, obj_name from tadir into @data(ls_id)
          where pgmid = 'R3TR' and
                obj_name = @lv_clsname.
        if sy-subrc = 0.
          instance = create_object( corresponding #( ls_id ) ).
        endif.
      endif.

    elseif strlen( include ) > 4 and include(4) = 'SAPL'.
      "//------------------------------------------------------------
      "// Function-groups
      "//------------------------------------------------------------
      find regex '^SAPL(\w+)\s*$' in include submatches data(lv_fugr_name).
      if sy-subrc = 0.
        instance = create_object( id = value #( pgmid = 'R3TR' object = 'FUGR' obj_name = lv_fugr_name ) ).
      else.
        "// Weird-named include
        instance = create_object( id = value #( pgmid = 'LIMU' object = 'REPS' obj_name = include ) ).
      endif.

    elseif strlen( include ) > 3 and include(3) = '%_C'.
      "//------------------------------------------------------------
      "// Type pools
      "//------------------------------------------------------------
      instance = create_object( id = value #( pgmid = 'R3TR' object = 'TYPE' obj_name = include+3 ) ).

    else.
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
      else.
        "//------------------------------------------------------------
        "// Regular programs
        "//------------------------------------------------------------
        instance = create_object( id = value #( pgmid = 'R3TR' object = 'PROG' obj_name = include ) ).
      endif.
    endif.
  endmethod.


  method get_html.
    data: lv_class     type string,
          lv_situation type string.

    "// HTML header
    html =
      |<!DOCTYPE html>\r\n| &&
      |<html lang="en">\r\n| &&
      |<head>\r\n| &&
      |<meta charset="utf-8">\r\n| &&
      |<meta http-equiv="X-UA-Compatible" content="IE=edge">\r\n| &&
      |<meta name="viewport" content="width=device-width, initial-scale=1">\r\n| &&
      |<!-- Latest compiled and minified CSS -->\r\n| &&
      |<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" crossorigin="anonymous">\r\n| &&
      |<title>zDefuse Report</title>\r\n| &&
      |</head>\r\n| &&
      |<body>\r\n| &&
      |<div class="container">\r\n| &&
      |<h1>zDefuse Report</h1>\r\n| &&
      |<small>Generated by { sy-uname } on { sy-datum date = user } at { sy-uzeit time = user }</small>\r\n| &&
      |<hr>\r\n|.

    "// Target system
    html = html &&
      |<h2>Target system</h2>\r\n| &&
      |<big>{ me->target_system }</big>\r\n|.

    "// Transport numbers and descriptions
    if me->transports is not initial.
      html = html && |<h2>Transport requests</h2>\r\n| &&
        |<table class="table table-condensed table-bordered">\r\n| &&
        |<thead><th>#</th><th>Owner</th><th>Description</th></thead>\r\n| &&
        |<tbody style="font-family: monospace">\r\n|.
      loop at me->transports assigning field-symbol(<transport>).
        assign me->transport_texts[ trkorr = <transport>-trkorr ] to field-symbol(<transp_text>).
        html = html &&
          |<tr><td>{ <transport>-trkorr }</td>| &&
          |<td>{ <transport>-as4user }</td><td>{ <transp_text>-as4text }</td></tr>\r\n|.
      endloop.
      html = html && |</tbody></table>\r\n|.
    endif.

    "// Analysis result
    html = html && |<h2>Result</h2>\r\n|.
    case me->analysis_result.
      when 0.
        lv_class = 'success'.
        lv_situation = '<b>No problem!</b> Transport will not cause errors.'.
      when 1.
        lv_class = 'warning'.
        lv_situation = '<b>Be careful.</b> Minor problems were found, you probably want to check them manually.'.
      when 2.
        lv_class = 'danger'.
        lv_situation = '<b>Danger!</b> Differences were found that could cause errors after the transport.'.
      when 3.
        lv_class = 'danger'.
        lv_situation = '<b>Critical!</b> Dependent objects are missing in the target system. Do not transport!'.
    endcase.
    html = html &&
      |<div class="alert alert-{ lv_class }" role="alert">{ lv_situation }</div>\r\n|.

    "// Processing messages
    if me->messages is not initial.
      html = html && |<h2>Processing messages</h2>\r\n|.
      loop at me->messages assigning field-symbol(<message>).
        case <message>-type.
          when 'E' or 'A' or 'X'. lv_class = 'error'.
          when 'W'. lv_class = 'warning'.
          when others. lv_class = 'info'.
        endcase.
        html = html &&
          |<div class="alert alert-{ lv_class }" role="alert">{ <message>-message }</div>\r\n|.
      endloop.
    endif.

    "// Unsupported objects
    if me->unsupported_objects is not initial.
      html = html && |<h2>Unsuported objects</h2>\r\n| &&
        |<p>The following objects were found during the dependency analysis but are not supported.<br>\r\n| &&
        |They must be checked <b>manually</b>.</p>\r\n| &&
        |<table class="table table-condensed table-bordered">\r\n| &&
        |<thead><th>Object Type</th><th>Object Name</th></thead>\r\n| &&
        |<tbody>\r\n|.
      loop at me->unsupported_objects assigning field-symbol(<unsupported>).
        html = html &&
          |<tr><td>{ object_types[ object = <unsupported>-object ]-text }</td>| &&
          |<td style="font-family: monospace">{ <unsupported>-obj_name }</td></tr>\r\n|.
      endloop.
      html = html && |</tbody></table>\r\n|.
    endif. "me->unsupported_objects is not initial.

    "// Different objects
    if me->compare_results is not initial.
      html = html && |<h2>Different objects in target system</h2>\r\n| &&
        |<p>The following objects were found to be dependent or dependencies of the transported objects.<br>\r\n| &&
        |Objects marked in yellow are different in the target system.<br>\r\n| &&
        |Objects marked in red don't exist in the target system.<br>\r\n| &&
        |<table class="table table-condensed table-bordered">\r\n| &&
        |<thead><th>Object Type</th><th>Object Name</th><th>Situation</th></thead>\r\n| &&
        |<tbody>\r\n|.
      loop at me->compare_results assigning field-symbol(<compare>) where equal is initial.
        lv_class = 'warning'.
        lv_situation = 'Different'.
        if <compare>-nonversionable = 'X'.
          lv_class = 'danger'.
          lv_situation = 'Error: not versionable'.
        elseif <compare>-not_readable = 'X'.
          lv_class = 'danger'.
          lv_situation = 'Error: not readable'.
        elseif <compare>-not_comparable = 'X'.
          lv_class = 'danger'.
          lv_situation = 'Not found in target system'.
        endif.
        html = html &&
          |<tr class="{ lv_class }"><td>{ object_types[ object = <compare>-fragment ]-text }</td>| &&
          |<td style="font-family: monospace">{ <compare>-fragname }</td><td>{ lv_situation }</td></tr>\r\n|.
      endloop.
      html = html && |</tbody></table>\r\n|.
    endif. "me->compare_results is not initial.

    html = html &&
      |<footer style="text-align: center;">\r\n| &&
      |zDefuse (<a href="https://github.com/koemaeda/zdefuse">github.com/koemaeda/zdefuse</a>)\r\n| &&
      |<hr></footer>\r\n| &&
      |</div></body>\r\n| &&
      |</html>\r\n|.
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
        pgmid = 'R3TR' object = 'PROG' obj_name = <incl>-name ) ) to objects.
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
        data(lv_type) = type_conversion_table[ cross = <module>-type ].
        if sy-subrc <> 0.
          log-point id zdefuse subkey 'CROSS_TYPE_NOT_SUPPORTED' fields <module>-type <module>-prog <module>-name.
        elseif lv_type-repo is not initial.
          append create_object( value #(
            object = lv_type-repo obj_name = <module>-name ) ) to objects.
        endif.
      endif.
    endloop.

    "//----------------------------------------------------------------
    select * from wbcrossgt into table @data(lt_gtypes)
      where include = @include.
    loop at lt_gtypes assigning field-symbol(<gtype>).
      lv_type = type_conversion_table[ tag = <gtype>-otype ].
      if sy-subrc <> 0.
        log-point id zdefuse subkey 'TAG_NOT_SUPPORTED' fields <module>-type <module>-prog <module>-name.
        continue.
      endif.
      case lv_type-tag.
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
          if lv_type-repo is not initial.
            append create_object( value #(
              object = lv_type-repo obj_name = <gtype>-name ) ) to objects.
          endif.
      endcase.
    endloop.

    "// Organize results
    sort objects. delete adjacent duplicates from objects.
  endmethod.


  method get_objects_to_check.
    if node is not supplied.
      "// Return all objects from both trees
      loop at me->up_tree-root_nodes assigning field-symbol(<node>).
        append lines of get_objects_to_check( <node> ) to objects.
      endloop.
      loop at me->down_tree-root_nodes assigning <node>.
        append lines of get_objects_to_check( <node> ) to objects.
      endloop.

      "// Remove root objects from the list
      loop at me->up_tree-root_nodes assigning <node>.
        delete objects where pgmid = <node>-id-pgmid and
                             object = <node>-id-object and
                             obj_name = <node>-id-obj_name.
      endloop.
      loop at me->down_tree-root_nodes assigning <node>.
        delete objects where pgmid = <node>-id-pgmid and
                             object = <node>-id-object and
                             obj_name = <node>-id-obj_name.
      endloop.
    else.
      "// Return this node's object and all childrens' objects
      append node-id to objects.
      loop at node-children assigning field-symbol(<child_ref>).
        assign <child_ref>->* to <node>.
        append lines of get_objects_to_check( <node> ) to objects.
      endloop.
    endif.

    sort objects. delete adjacent duplicates from objects.
  endmethod.


  method GET_TYPE_BY_NAME.
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
        real_name = <fullname>.
        return.
      endif.
    endloop.
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
      ( tag = cl_abap_compiler=>tag_matchcode          cross = 'V'  repo = 'MCOB' )
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
    data(lv_tag) = conv scr_tag( fullname+1 ).

    "//--------------------------------------------------------------
    "// For methods, select directly from WBCROSSGT
    "//--------------------------------------------------------------
    if lv_tag = cl_abap_compiler=>tag_method or
       lv_tag = cl_abap_compiler=>tag_event.

      select * from wbcrossgt into table @data(lt_gtypes)
        where otype = @lv_tag and
              name = @fullname+3 and
              direct = 'X'.
      loop at lt_gtypes assigning field-symbol(<gtype>).
        append create_object_for_include( <gtype>-include ) to objects.
      endloop.

    else.
      "//--------------------------------------------------------------
      "// Use RS_EU_CROSSREF to get the regular where-used list
      "//--------------------------------------------------------------

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
            append create_object_for_include( conv #( <found>-object ) ) to objects.
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
            if <found>-encl_objec is not initial.
              append create_ddic_object( <found>-encl_objec ) to objects.
            else.
              append create_ddic_object( <found>-object ) to objects.
            endif.
        endcase. "<found>-object_cls(1)
      endloop.

    endif. "methods or regular

    sort objects. delete adjacent duplicates from objects.
  endmethod.


  method run.
    "// Analyse objects
    me->compare_results = compare_objects( ).
    sort me->unsupported_objects. delete adjacent duplicates from me->unsupported_objects.

    "// Determine if the transport will cause errors
    me->analysis_result = 0. "// No problem
    if me->unsupported_objects is not initial.
      me->analysis_result = 1. "// Maybe
    endif.
    read table me->compare_results transporting no fields with key equal = space.
    if sy-subrc = 0.
      me->analysis_result = 2. "// Dangerous
    endif.
    read table me->compare_results transporting no fields
      with key equal = space not_comparable = 'X'.
    if sy-subrc = 0.
      me->analysis_result = 3. "// Critical
    endif.

    instance = me.
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
ENDCLASS.
