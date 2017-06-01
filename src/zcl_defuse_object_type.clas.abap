class ZCL_DEFUSE_OBJECT_TYPE definition
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



CLASS ZCL_DEFUSE_OBJECT_TYPE IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'R3TR' object = 'TYPE' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    objects = parent->get_include_references(
      conv progname( '%_C' && me->id-obj_name ) ).
  endmethod.


  method zif_defuse_object~search_up.
    data(lv_fullname) = '\TP:' && me->id-obj_name.
    objects = parent->get_where_used( lv_fullname ).
  endmethod.
ENDCLASS.
