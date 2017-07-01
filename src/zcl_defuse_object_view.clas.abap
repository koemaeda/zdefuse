class ZCL_DEFUSE_OBJECT_VIEW definition
  public
  inheriting from ZCL_DEFUSE_OBJECT_DDIC
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !NAME type CLIKE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_VIEW IMPLEMENTATION.


  method constructor.
    super->constructor( ).
    me->id = value #( pgmid = 'R3TR' object = 'VIEW' obj_name = name ).
  endmethod.
ENDCLASS.
