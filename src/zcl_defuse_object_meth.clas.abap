class ZCL_DEFUSE_OBJECT_METH definition
  public
  create public .

public section.

  interfaces ZIF_DEFUSE_OBJECT .

  methods CONSTRUCTOR
    importing
      !NAME type CLIKE .
  methods GET_FULLNAMES
    returning
      value(FULLNAMES) type STRINGTAB .
protected section.

  aliases ID
    for ZIF_DEFUSE_OBJECT~ID .
  aliases PARENT
    for ZIF_DEFUSE_OBJECT~PARENT .

  data CLASSNAME type SEOCLSNAME .
  data METHODNAME type STRING .
  data FULLNAMES type STRINGTAB .
  data INCLUDE type PROGNAME .

  methods READ_ALIASES .
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_METH IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'LIMU' object = 'METH' obj_name = name ).

    "// Fix name
    replace regex '^\\TY:' in me->id-obj_name with ''.
    replace regex '\\IN:(\w+)\\ME:(\w+)' in me->id-obj_name with '=>$1~$2'.
    replace regex '\\ME:(\w+)' in me->id-obj_name with '=>$1'.
    if me->id-obj_name cs '=>'.
      split me->id-obj_name at '=>' into me->classname me->methodname.
    else.
      data(ls_method_key) = conv seocmpkey( me->id-obj_name ).
      me->classname = ls_method_key-clsname.
      me->methodname = ls_method_key-cmpname.
      me->id-obj_name = |{ me->classname }=>{ me->methodname }|.
    endif.

    "// Find include name
    cl_oo_include_naming=>get_instance_by_name(
      exporting name = me->classname
      receiving cifref = data(lo_naming_dummy)
      exceptions others = 4 ).
    data(lo_naming) = cast if_oo_class_incl_naming( lo_naming_dummy ).
    if lo_naming is initial.
      clear me->id. return.
    endif.

    lo_naming->get_include_by_mtdname( exporting mtdname = conv #( me->methodname )
       receiving progname = me->include
       exceptions others = 4 ).
    if me->include is initial.
      clear me->id. return.
    endif.
    me->methodname = lo_naming->get_mtdname_by_include( me->include ).

    "// Build (primary) fullname
    if me->methodname cs '~'.
      split me->methodname at '~' into data(lv_intfname) data(lv_ifmtdname).
      append |\\TY:{ me->classname }\\IN:{ lv_intfname }\\ME:{ lv_ifmtdname }| to me->fullnames.
    else.
      append |\\TY:{ me->classname }\\ME:{ me->methodname }| to me->fullnames.
    endif.

    "// Search alias names (all must be considered)
    read_aliases( ).
  endmethod.


  method get_fullnames.
    fullnames = me->fullnames.
  endmethod.


  method READ_ALIASES.
    "// Only if this is an interface method
    split me->methodname at '~' into data(lv_intfname) data(lv_ifmtdname).
    check sy-subrc = 0.

    "// Look up all the inheritance chain
    data: lt_classnames type table of seoclsname.
    data(lv_curclass) = me->classname.
    do.
      append lv_curclass to lt_classnames.
      select single refclsname from seometarel into lv_curclass
        where clsname = lv_curclass and
              reltype = '2'.
      if sy-subrc <> 0.
        exit.
      endif.
    enddo.

    "// Find protected and public aliases for every mother class
    data: lt_aliases type table of string.
    select cmpname from seocompodf into table lt_aliases
      for all entries in lt_classnames
      where clsname = lt_classnames-table_line and
            refclsname = lv_intfname and
            refcmpname = lv_ifmtdname and
            alias = 'X' and
            exposure in (1, 2).
    loop at lt_aliases assigning field-symbol(<alias>).
      append |\\TY:{ me->classname }\\ME:{ <alias> }| to me->fullnames.
    endloop.
  endmethod.


  method zif_defuse_object~search_down.
    check me->include is not initial.

    "// Class definition
    append parent->create_ddic_object( me->classname ) to objects.

    "// Method code
    append lines of me->parent->get_include_references( me->include ) to objects.

    sort objects. delete adjacent duplicates from objects.
    delete objects where table_line is initial.

    "// No redundant definitions
    loop at objects assigning field-symbol(<object>)
        where table_line->id-object = 'METH'.
      split <object>->id-obj_name at '=>' into data(lv_class) data(lv_method).
      if sy-subrc = 0.
        delete objects where table_line->id-object = 'CLSD' and
                             table_line->id-obj_name = lv_class.
      endif.
    endloop.
  endmethod.


  method zif_defuse_object~search_up.
    "// Class definition

    append parent->create_ddic_object( me->classname ) to objects.

    loop at me->fullnames assigning field-symbol(<fullname>).
      append lines of parent->get_where_used( <fullname> ) to objects.
    endloop.
  endmethod.
ENDCLASS.
