class ZCL_DEFUSE_OBJECT_PARA definition
  public
  create public .

public section.

  interfaces ZIF_DEFUSE_OBJECT .

  methods CONSTRUCTOR
    importing
      !NAME type CLIKE .
protected section.
private section.

  aliases ID
    for ZIF_DEFUSE_OBJECT~ID .
  aliases PARENT
    for ZIF_DEFUSE_OBJECT~PARENT .
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_PARA IMPLEMENTATION.


  method CONSTRUCTOR.
    me->id = value #( pgmid = 'R3TR' object = 'PARA' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    "// SPA/GPA parameter don't reference anything
  endmethod.


  method zif_defuse_object~search_up.
    objects = parent->get_where_used( '\SG:' && me->id-obj_name ).
  endmethod.
ENDCLASS.
