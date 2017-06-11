class ZCL_DEFUSE_OBJECT_DOMA definition
  public
  inheriting from ZCL_DEFUSE_OBJECT_DDIC
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !NAME type CLIKE .

  methods ZIF_DEFUSE_OBJECT~SEARCH_DOWN
    redefinition .
  methods ZIF_DEFUSE_OBJECT~SEARCH_UP
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_DOMA IMPLEMENTATION.


  method constructor.
    super->constructor( ).
    me->id = value #( pgmid = 'R3TR' object = 'DOMA' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    objects = super->search_down( ).

    data(lv_domname) = conv domname( me->id-obj_name ).
    select single * from dd01l into @data(ls_doma)
      where domname = @lv_domname.

    "// Conversion EXIT
    if ls_doma-convexit is not initial.
      append parent->create_object( value #( pgmid = 'LIMU'
        object = 'FUNC' obj_name = |CONVERSION_EXIT_{ ls_doma-convexit }_INPUT| ) ) to objects.
      append parent->create_object( value #( pgmid = 'LIMU'
        object = 'FUNC' obj_name = |CONVERSION_EXIT_{ ls_doma-convexit }_OUTPUT| ) ) to objects.
    endif.

    "// Value table
    if ls_doma-entitytab is not initial.
      append parent->create_ddic_object( ls_doma-entitytab ) to objects.
    endif.
  endmethod.


  method zif_defuse_object~search_up.
    "// Domains can only be referenced by data elements
    select * from dd03l into table @data(lt_dtel)
      where domname = @me->id-obj_name.
    loop at lt_dtel assigning field-symbol(<dtel>).
      append parent->create_ddic_object( <dtel>-rollname ) to objects.
    endloop.
  endmethod.
ENDCLASS.
