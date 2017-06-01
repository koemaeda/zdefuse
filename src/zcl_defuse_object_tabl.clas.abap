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
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_TABL IMPLEMENTATION.


  method constructor.
    super->constructor( ).
    me->id = value #( pgmid = 'R3TR' object = 'TABL' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    objects = super->search_down( ).

    "// Is this a table field?
    split me->id-obj_name at '-' into table data(lt_parts).
    delete lt_parts index lines( lt_parts ).
    loop at lt_parts assigning field-symbol(<part>).
      append parent->create_ddic_object( <part> ) to objects.
    endloop.

    "// Read table fields
    data(lt_fields) = cl_salv_ddic=>get_by_name( me->id-obj_name ).
    loop at lt_fields assigning field-symbol(<field>).
      if <field>-rollname is not initial.
        append parent->create_ddic_object( <field>-rollname ) to objects.
      endif.
      if <field>-reftable is not initial.
        append parent->create_ddic_object( |{ <field>-reftable }-{ <field>-reffield }| ) to objects.
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
        pgmid = 'R3TR' object = 'MCOB' obj_name = <shelp>-shlpname ) ) to objects.
    endloop.
  endmethod.
ENDCLASS.
