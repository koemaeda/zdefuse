class ZCL_DEFUSE_OBJECT_CLSD definition
  public
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



CLASS ZCL_DEFUSE_OBJECT_CLSD IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'LIMU' object = 'CLSD' obj_name = name ).

    "// Get root name
    replace regex '\\.+$' in me->id-obj_name with ''.
  endmethod.


  method ZIF_DEFUSE_OBJECT~SEARCH_DOWN.
  endmethod.


  method ZIF_DEFUSE_OBJECT~SEARCH_UP.
  endmethod.
ENDCLASS.
