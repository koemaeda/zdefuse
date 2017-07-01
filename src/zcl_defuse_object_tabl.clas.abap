class ZCL_DEFUSE_OBJECT_TABL definition
  public
  inheriting from ZCL_DEFUSE_OBJECT_DDIC
  create public .

public section.

  methods CONSTRUCTOR
    importing
      value(NAME) type CLIKE .

  methods ZIF_DEFUSE_OBJECT~SEARCH_DOWN
    redefinition .
protected section.

  data STRUCTDESCR type ref to CL_ABAP_STRUCTDESCR .
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_TABL IMPLEMENTATION.


  method constructor.
    super->constructor( ).
    me->id = value #( pgmid = 'R3TR' object = 'TABL' obj_name = name ).

    "// System structures convertion
    if me->id-obj_name = 'SY'.
      me->id-obj_name = 'SYST'.
    endif.

    "// Check if this table exists and is really a table
    cl_abap_typedescr=>describe_by_name(
      exporting p_name = me->id-obj_name
      receiving p_descr_ref = data(lo_type)
      exceptions others = 4 ).
    if lo_type is initial or lo_type->kind <> cl_abap_typedescr=>kind_struct.
      clear me->id.
    else.
      me->structdescr ?= lo_type.
    endif.
  endmethod.


  method zif_defuse_object~search_down.
    objects = super->search_down( ).

    "// Is this a table field?
    split me->id-obj_name at '-' into table data(lt_parts).
    if sy-subrc = 0.
      delete lt_parts index lines( lt_parts ).
      loop at lt_parts assigning field-symbol(<part>).
        append parent->create_ddic_object( <part> ) to objects.
      endloop.
    endif.

    "// Read table fields
    me->structdescr->get_ddic_field_list(
      receiving p_field_list = data(lt_fields)
      exceptions others = 4 ).
    loop at lt_fields assigning field-symbol(<field>).
      if <field>-rollname is not initial.
        append parent->create_ddic_object( <field>-rollname ) to objects.
      endif.
      if <field>-reftable is not initial.
        append parent->create_ddic_object( |{ <field>-reftable }| ) to objects.
      endif.
      if <field>-checktable is not initial.
        append parent->create_ddic_object( <field>-checktable ) to objects.
      endif.
    endloop.

    "// Explicit search helps
    data(lv_tabname) = conv tabname( me->id-obj_name ).
    select * from dd35l into table @data(lt_shelp)
      where tabname = @lv_tabname.
    loop at lt_shelp assigning field-symbol(<shelp>).
      append parent->create_object( value #(
        pgmid = 'R3TR' object = 'SHLP' obj_name = <shelp>-shlpname ) ) to objects.
    endloop.
  endmethod.
ENDCLASS.
