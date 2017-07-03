class ZCL_DEFUSE_OBJECT_VIEW definition
  public
  inheriting from ZCL_DEFUSE_OBJECT_TABL
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



CLASS ZCL_DEFUSE_OBJECT_VIEW IMPLEMENTATION.


  method constructor.
    super->constructor( name ).
    if me->id-obj_name is not initial.
      me->id-object = 'VIEW'.
    endif.
  endmethod.


  method zif_defuse_object~search_down.
    objects = super->search_down( ).

    "// Read tables
    select * from dd26i into table @data(lt_tables)
      where viewname = @me->id-obj_name.
    loop at lt_tables assigning field-symbol(<table>).
      append parent->create_object( value #( pgmid = 'R3TR'
        object = 'TABL' obj_name = <table>-tabname ) ) to objects.
    endloop.
  endmethod.
ENDCLASS.
