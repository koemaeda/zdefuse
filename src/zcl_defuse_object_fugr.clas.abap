class ZCL_DEFUSE_OBJECT_FUGR definition
  public
  create public .

public section.

  interfaces ZIF_DEFUSE_OBJECT.

  methods CONSTRUCTOR
    importing
      value(NAME) type CLIKE .

protected section.
private section.

  aliases ID
    for ZIF_DEFUSE_OBJECT~ID .
  aliases PARENT
    for ZIF_DEFUSE_OBJECT~PARENT .

  data PROGNAME type PROGNAME .
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_FUGR IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'R3TR' object = 'FUGR' obj_name = name ).
    me->progname = 'SAPL' && me->id-obj_name.
  endmethod.


  method zif_defuse_object~search_down.
    objects = parent->get_include_references( conv #( me->progname ) ).

    "// Read function modules
    select funcname from tfdir into table @data(lt_funcname)
      where pname = @me->progname.
    loop at lt_funcname assigning field-symbol(<funcname>).
      append parent->create_object( value #( pgmid = 'LIMU'
        object = 'FUNC' obj_name = <funcname> ) ) to objects.
    endloop.
  endmethod.


  method zif_defuse_object~search_up.
    objects = parent->get_where_used( |\\PR:{ me->progname }| ).
  endmethod.
ENDCLASS.
