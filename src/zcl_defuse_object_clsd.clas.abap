class ZCL_DEFUSE_OBJECT_CLSD definition
  public
  create public .

public section.

  interfaces ZIF_DEFUSE_OBJECT .

  methods CONSTRUCTOR
    importing
      value(NAME) type CLIKE .
protected section.

  aliases ID
    for ZIF_DEFUSE_OBJECT~ID .
  aliases PARENT
    for ZIF_DEFUSE_OBJECT~PARENT .
  aliases SEARCH_DOWN
    for ZIF_DEFUSE_OBJECT~SEARCH_DOWN .
  aliases SEARCH_UP
    for ZIF_DEFUSE_OBJECT~SEARCH_UP .

  methods GET_COMPONENT_DEFINITIONS
    returning
      value(OBJECTS) type ZCL_DEFUSE=>TY_T_OBJECT .
  methods GET_COMPONENT_IMPLEMENTATIONS
    returning
      value(OBJECTS) type ZCL_DEFUSE=>TY_T_OBJECT .
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_CLSD IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'LIMU' object = 'CLSD' obj_name = name ).

    "// Get root name
    replace regex '\\.+$' in me->id-obj_name with ''.
  endmethod.


  method get_component_definitions.
    "// Attributes
    select * from seocompodf into table @data(lt_attr)
      where clsname = @me->id-obj_name and
            type <> ''.
    loop at lt_attr assigning field-symbol(<attr>).
      append parent->create_ddic_object( <attr>-type ) to objects.
      if <attr>-attvalue is not initial and <attr>-attvalue cs '=>'.
        find regex '^(\w+)=>.+' in <attr>-attvalue submatches data(lv_classname).
        append parent->create_ddic_object( lv_classname ) to objects.
      endif.
    endloop.

    "// Method/event signatures
    select * from seosubcodf into table @data(lt_methsig)
      where clsname = @me->id-obj_name and
            type <> ''.
    loop at lt_methsig assigning field-symbol(<methsig>).
      append parent->create_ddic_object( <methsig>-type ) to objects.
      if <methsig>-parvalue is not initial and <methsig>-parvalue cs '=>'.
        find regex '^(\w+)=>.+' in <methsig>-parvalue submatches lv_classname.
        append parent->create_ddic_object( lv_classname ) to objects.
      endif.
    endloop.

    "// Types
    select * from seocompo into table @data(lt_types)
      where clsname = @me->id-obj_name and
            cmptype = '3'.
    loop at lt_types assigning field-symbol(<type>).
      append parent->create_ddic_object( |{ <type>-clsname }=>{ <type>-cmpname }| ) to objects.
    endloop.

    sort objects. delete adjacent duplicates from objects.
  endmethod.


  method get_component_implementations.
    "// Methods (including interface methods)
    cl_oo_include_naming=>get_instance_by_name(
      exporting name = me->id-obj_name
      receiving cifref = data(lo_naming)
      exceptions others = 4 ).
    check lo_naming is not initial.
    cast if_oo_class_incl_naming( lo_naming )->get_all_method_includes(
      receiving methods_w_include = data(lt_includes)
      exceptions others = 4 ).
    loop at lt_includes assigning field-symbol(<include>).
      data(lv_name) = |{ <include>-cpdkey-clsname }=>{ <include>-cpdkey-cpdname }|.
      append parent->create_object( value #( pgmid = 'LIMU'
        object = 'METH' obj_name = lv_name ) ) to objects.
    endloop.

    "// Methods (aliases)
    select * from seocompo into table @data(lt_methods)
      where clsname = @me->id-obj_name and
            cmptype = '1'.
    loop at lt_methods assigning field-symbol(<method>).
      lv_name = |{ me->id-obj_name }=>{ <method>-cmpname }|.
      append parent->create_object( value #(
        pgmid = 'LIMU' object = 'METH' obj_name = lv_name ) ) to objects.
    endloop.
  endmethod.


  method zif_defuse_object~search_down.
    "// Interfaces
    select * from seometarel into table @data(lt_interf)
      where clsname = @me->id-obj_name and
            reltype = '1'.
    loop at lt_interf assigning field-symbol(<interf>).
      append parent->create_object( value #( pgmid = 'LIMU'
        object = 'INTF' obj_name = <interf>-refclsname ) ) to objects.
    endloop.

    "// Friends
    select * from seofriends into table @data(lt_friends)
      where clsname = @me->id-obj_name.
    loop at lt_friends assigning field-symbol(<friend>).
      append parent->create_object( value #( pgmid = 'LIMU'
        object = 'CLSD' obj_name = <friend>-refclsname ) ) to objects.
    endloop.

    "// Mother class
    select single * from seometarel into @data(ls_mother)
      where clsname = @me->id-obj_name and
            reltype = '2'.
    if sy-subrc = 0.
      append parent->create_object( value #( pgmid = 'LIMU'
        object = 'CLSD' obj_name = ls_mother-refclsname ) ) to objects.
    endif.

    "// Component dependencies
    append lines of get_component_definitions( ) to objects.
    append lines of get_component_implementations( ) to objects.

    sort objects. delete adjacent duplicates from objects.
    delete objects where table_line is initial.
  endmethod.


  method zif_defuse_object~search_up.
    objects = parent->get_where_used( |\\TY:{ me->id-obj_name }| ).

    "// Friend of ?
    select * from seofriends into table @data(lt_friends)
      where refclsname = @me->id-obj_name.
    loop at lt_friends assigning field-symbol(<friend>).
      append parent->create_ddic_object( <friend>-clsname ) to objects.
    endloop.

    "// Child classes
    select * from seometarel into table @data(lt_children)
      where refclsname = @me->id-obj_name and
            reltype = '2'.
    loop at lt_children assigning field-symbol(<child>).
      append parent->create_ddic_object( <child>-clsname ) to objects.
    endloop.
  endmethod.
ENDCLASS.
