class ZCL_DEFUSE_OBJECT_CLAS definition
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



CLASS ZCL_DEFUSE_OBJECT_CLAS IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'R3TR' object = 'CLAS' obj_name = name ).
  endmethod.


  method ZIF_DEFUSE_OBJECT~SEARCH_DOWN.
  endmethod.


  method ZIF_DEFUSE_OBJECT~SEARCH_UP.
  endmethod.
ENDCLASS.
