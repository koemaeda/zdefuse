class ZCL_DEFUSE_OBJECT_SHLP definition
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
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_SHLP IMPLEMENTATION.


  method CONSTRUCTOR.
    me->id = value #( pgmid = 'R3TR' object = 'SHLP' obj_name = name ).
  endmethod.


  method ZIF_DEFUSE_OBJECT~SEARCH_DOWN.
    "// TODO
  endmethod.


  method ZIF_DEFUSE_OBJECT~SEARCH_UP.
    "// TODO
  endmethod.
ENDCLASS.
