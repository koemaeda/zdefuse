class ZCL_DEFUSE_OBJECT_FUNC definition
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

  data FULLNAME type STRING .
  data MAIN_PROGRAM type PROGNAME .
  data INCLUDE type PROGNAME .
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_FUNC IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'LIMU' object = 'FUNC' obj_name = name ).

    me->fullname = |\\FU:{ me->id-obj_name }|.

    "// Read main program/include
    select single pname, include from tfdir
      into (@me->main_program, @data(lv_index))
      where funcname = @me->id-obj_name.
    me->include = me->main_program+3 && 'U' && lv_index.
  endmethod.


  method zif_defuse_object~search_down.
    "// Function signature
    select * from fupararef into table @data(lt_params)
      where funcname = @me->id-obj_name.
    loop at lt_params assigning field-symbol(<param>) where structure is not initial.
      append parent->create_ddic_object( <param>-structure ) to objects.
    endloop.

    "// Code references
    append lines of parent->get_include_references( me->include ) to objects.

    "// The main program is always related
    append parent->create_object( value #( pgmid = 'R3TR'
      object = 'PROG' obj_name = me->main_program ) ) to objects.
  endmethod.


  method zif_defuse_object~search_up.
    objects = parent->get_where_used( me->fullname ).

    "// The main program is always related
    append parent->create_object( value #( pgmid = 'R3TR'
      object = 'PROG' obj_name = me->main_program ) ) to objects.
  endmethod.
ENDCLASS.
