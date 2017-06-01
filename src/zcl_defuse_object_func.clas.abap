class ZCL_DEFUSE_OBJECT_FUNC definition
  public
  final
  create public .

public section.

  interfaces ZIF_DEFUSE_OBJECT .

  methods CONSTRUCTOR
    importing
      value(NAME) type CLIKE .
protected section.
private section.

  aliases ID
    for ZIF_DEFUSE_OBJECT~ID .
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_FUNC IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'LIMU' object = 'FUNC' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.

  endmethod.


  method zif_defuse_object~search_up.

  endmethod.
ENDCLASS.
