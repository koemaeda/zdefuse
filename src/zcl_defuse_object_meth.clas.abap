class ZCL_DEFUSE_OBJECT_METH definition
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



CLASS ZCL_DEFUSE_OBJECT_METH IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'LIMU' object = 'METH' obj_name = name ).

    "// Fix name
    replace regex '\IF:(\w+)\ME:(\w+)' in me->id-obj_name with '=>$1~$2'.
    replace regex '\ME:(\w+)' in me->id-obj_name with '=>$1'.
  endmethod.


  method ZIF_DEFUSE_OBJECT~SEARCH_DOWN.
  endmethod.


  method ZIF_DEFUSE_OBJECT~SEARCH_UP.
  endmethod.
ENDCLASS.
