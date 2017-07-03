class ZCL_DEFUSE_OBJECT_VCLS definition
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
  aliases PARENT
    for ZIF_DEFUSE_OBJECT~PARENT .
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_VCLS IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'R3TR' object = 'VCLS' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    "// Select exit program
    select single exitprog from vcldir into @data(lv_program)
      where vclname = @me->id-obj_name.
    if lv_program is not initial.
      append parent->create_object_for_include( lv_program ) to objects.
    endif.

    "// Select participating tables/views
    select * from vclstruc into table @data(lt_tables)
      where vclname = @me->id-obj_name.
    loop at lt_tables assigning field-symbol(<table>).
      append parent->create_ddic_object( <table>-object ) to objects.
    endloop.
  endmethod.


  method zif_defuse_object~search_up.
    "// Nothing depends on a view cluster
  endmethod.
ENDCLASS.
