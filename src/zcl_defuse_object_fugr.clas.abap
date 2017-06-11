class ZCL_DEFUSE_OBJECT_FUGR definition
  public
  inheriting from ZCL_DEFUSE_OBJECT_PROG
  create public .

public section.

  methods CONSTRUCTOR
    importing
      value(NAME) type CLIKE .

  methods ZIF_DEFUSE_OBJECT~SEARCH_DOWN
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_FUGR IMPLEMENTATION.


  method constructor.
    super->constructor( |SAPL{ name }| ).
    me->id-pgmid = 'R3TR'.
    me->id-object = 'FUGR'.
  endmethod.


  method zif_defuse_object~search_down.
    objects = super->search_down( ).

    "// Read function modules
    select funcname from tfdir into table @data(lt_funcname)
      where pname = @me->id-obj_name.
    loop at lt_funcname assigning field-symbol(<funcname>).
      append parent->create_object( value #( pgmid = 'LIMU'
        object = 'FUNC' obj_name = <funcname> ) ) to objects.
    endloop.
  endmethod.
ENDCLASS.
