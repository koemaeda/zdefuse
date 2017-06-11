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

  data TABLEDESCR type ref to CL_ABAP_TABLEDESCR .
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_TTYP IMPLEMENTATION.


  method constructor.
    super->constructor( ).
    me->id = value #( pgmid = 'R3TR' object = 'TTYP' obj_name = name ).

    "// Check if it really exists
    cl_abap_typedescr=>describe_by_name(
      exporting p_name = me->id-obj_name
      receiving p_descr_ref = data(lo_type)
      exceptions others = 4 ).
    if lo_type is initial or lo_type->kind <> cl_abap_typedescr=>kind_table.
      clear me->id.
    else.
      me->tabledescr ?= lo_type.
    endif.
  endmethod.


  method zif_defuse_object~search_down.
    objects = super->search_down( ).

    "// Line type
    data(lo_structdescr) = me->tabledescr->get_table_line_type( ).
    if lo_structdescr is not initial.
      append parent->create_ddic_object( lo_structdescr->absolute_name ) to objects.
    endif.
  endmethod.
ENDCLASS.
