class ZCL_DEFUSE_OBJECT_INTF definition
  public
  inheriting from ZCL_DEFUSE_OBJECT_CLSD
  create public .

public section.

  methods CONSTRUCTOR
    importing
      value(NAME) type CLIKE .

  methods ZIF_DEFUSE_OBJECT~SEARCH_UP
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_INTF IMPLEMENTATION.


  method constructor.
    super->constructor( name ).
    me->id = value #( pgmid = 'R3TR' object = 'INTF' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_up.
    objects = super->search_up( ).

    "// Interface implementations
    select * from seometarel into table @data(lt_impl)
      where refclsname = @me->id-obj_name and
            reltype = '1'.
    loop at lt_impl assigning field-symbol(<impl>).
      append parent->create_object( value #( pgmid = 'LIMU'
        object = 'CLSD' obj_name = <impl>-clsname ) ) to objects.
    endloop.
  endmethod.
ENDCLASS.
