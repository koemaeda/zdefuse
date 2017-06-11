class ZCL_DEFUSE_OBJECT_PROG definition
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
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_PROG IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'R3TR' object = 'PROG' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    objects = parent->get_include_references( conv #( me->id-obj_name ) ).
  endmethod.


  method zif_defuse_object~search_up.
    objects = parent->get_where_used( |\\PR:{ me->id-obj_name }| ).
  endmethod.
ENDCLASS.
