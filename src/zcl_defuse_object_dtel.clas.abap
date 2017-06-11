class ZCL_DEFUSE_OBJECT_DTEL definition
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



CLASS ZCL_DEFUSE_OBJECT_DTEL IMPLEMENTATION.


  method constructor.
    super->constructor( ).
    me->id = value #( pgmid = 'R3TR' object = 'DTEL' obj_name = name ).
  endmethod.


  method ZIF_DEFUSE_OBJECT~SEARCH_DOWN.
    objects = super->search_down( ).

    data(lv_rollname) = conv rollname( me->id-obj_name ).
    select single * from dd04l into @data(ls_dtel)
      where rollname = @lv_rollname.

    "// Domain
    if ls_dtel-domname is not initial.
      append parent->create_ddic_object( ls_dtel-domname ) to objects.
    endif.

    "// Reference type
    if ls_dtel-reftype is not initial.
      append parent->create_ddic_object( ls_dtel-reftype ) to objects.
    endif.

    "// Parameter ID
    if ls_dtel-memoryid is not initial.
      append parent->create_object( value #( pgmid = 'R3TR'
        object = 'PARA' obj_name = ls_dtel-memoryid ) ) to objects.
    endif.

    "// Search help
    if ls_dtel-shlpname is not initial.
      append parent->create_object( value #( pgmid = 'R3TR'
        object = 'MCOB' obj_name = ls_dtel-shlpname ) ) to objects.
    endif.
  endmethod.
ENDCLASS.
