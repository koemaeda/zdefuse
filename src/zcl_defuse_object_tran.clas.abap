class ZCL_DEFUSE_OBJECT_TRAN definition
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



CLASS ZCL_DEFUSE_OBJECT_TRAN IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'R3TR' object = 'TRAN' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    "// Read transaction information
    select single * from tstc into @data(ls_header)
      where tcode = @me->id-obj_name.
    select single * from tstcp into @data(ls_parameters)
      where tcode = @me->id-obj_name.
    select single * from tstca into @data(ls_auth)
      where tcode = @me->id-obj_name.

    "// Program/module-pool/function group
    if ls_header-pgmna is not initial.
      append parent->create_object_for_include( ls_header-pgmna ) to objects.
    endif.

    "// Class method
    find regex '\\CLASS=(\w+)\\METHOD=(\w+)' in ls_parameters-param
      submatches data(lv_class) data(lv_method).
    if sy-subrc = 0.
      append parent->create_object( value #( pgmid = 'LIMU'
        object = 'METH' obj_name = |{ lv_class }=>{ lv_method }| ) ) to objects.
    endif.

    "// Transaction with parameters
    find regex '/*(\w+)' in ls_parameters-param submatches data(lv_ref_tcode).
    if sy-subrc = 0.
      append parent->create_object( value #( pgmid = 'R3TR'
        object = 'TRAN' obj_name = lv_ref_tcode ) ) to objects.
    endif.

    "// Transaction with variant
    find regex '/*START_REPORT .+;D_SREPOVARI-REPORT=(\w+);.*' in ls_parameters-param
      submatches data(lv_ref_program).
    if sy-subrc = 0.
      append parent->create_object( value #( pgmid = 'R3TR'
        object = 'PROG' obj_name = lv_ref_program ) ) to objects.
    endif.

    "// Authorization object
    if ls_auth-objct is not initial.
      append parent->create_object( value #( pgmid = 'R3TR'
        object = 'SUSO' obj_name = ls_auth-objct ) ) to objects.
    endif.
  endmethod.


  method zif_defuse_object~search_up.
    objects = parent->get_where_used( '\TA:' && me->id-obj_name ).
  endmethod.
ENDCLASS.
