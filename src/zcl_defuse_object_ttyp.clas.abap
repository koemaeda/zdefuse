class ZCL_DEFUSE_OBJECT_TTYP definition
  public
  inheriting from ZCL_DEFUSE_OBJECT_DDIC
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !NAME type CLIKE .

  methods ZIF_DEFUSE_OBJECT~SEARCH_DOWN
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_TTYP IMPLEMENTATION.


  method constructor.
    super->constructor( ).
    me->id = value #( pgmid = 'R3TR' object = 'TTYP' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    objects = super->search_down( ).

    "// Line type
    data(lt_comps) = cl_salv_ddic=>get_by_name( me->id-obj_name ).
    if lt_comps is not initial.
      append parent->create_ddic_object( lt_comps[ 1 ]-tabname ) to objects.
    endif.
  endmethod.
ENDCLASS.
