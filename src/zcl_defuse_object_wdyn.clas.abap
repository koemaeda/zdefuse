class ZCL_DEFUSE_OBJECT_WDYN definition
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



CLASS ZCL_DEFUSE_OBJECT_WDYN IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'R3TR' object = 'WDYN' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    data(lv_compname) = conv wdy_component_name( me->id-obj_name ).

    "// Components' signatures
    select * from wdy_ctlr_compo into table @data(lt_components)
      where component_name = @lv_compname and abap_type <> ''.
    loop at lt_components assigning field-symbol(<component>).
      append parent->create_ddic_object( <component>-abap_type ) to objects.
    endloop.

    "// Implemented interfaces
    select * from wdy_intf_implem into table @data(lt_interfaces)
      where component_name = @lv_compname.
    loop at lt_interfaces assigning field-symbol(<interface>).
      append parent->create_ddic_object( <interface>-interface_name ) to objects.
    endloop.

    "// Parameters
    select * from wdy_ctlr_param into table @data(lt_parameters)
      where component_name = @lv_compname and abap_type <> ''.
    loop at lt_parameters assigning field-symbol(<parameter>).
      append parent->create_ddic_object( <parameter>-abap_type ) to objects.
    endloop.

    "// Exceptions
    select * from wdy_ctlr_exc into table @data(lt_exceptions)
      where component_name = @lv_compname and exception_name <> ''.
    loop at lt_exceptions assigning field-symbol(<exception>).
      append parent->create_ddic_object( <exception>-exception_name ) to objects.
    endloop.

    "// Includes
    select * from wdy_wb_geninfo into table @data(lt_geninfo)
      where component_name = @lv_compname and controller_name <> ''.
    loop at lt_geninfo assigning field-symbol(<geninfo>).
      append parent->create_object_for_include( |/1BCWDY/B_{ <geninfo>-guid }| ) to objects.
      append parent->create_object_for_include( |/1BCWDY/S_{ <geninfo>-guid }| ) to objects.
    endloop.

    sort objects. delete adjacent duplicates from objects.
    delete objects where table_line is initial.
  endmethod.


  method zif_defuse_object~search_up.
    "// nothing references a web dynpro object
  endmethod.
ENDCLASS.
