class ZCL_DEFUSE_OBJECT_SHLP definition
  public
  create public .

public section.

  interfaces ZIF_DEFUSE_OBJECT .

  methods CONSTRUCTOR
    importing
      !NAME type CLIKE .
protected section.
private section.

  aliases ID
    for ZIF_DEFUSE_OBJECT~ID .
  aliases PARENT
    for ZIF_DEFUSE_OBJECT~PARENT .
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_SHLP IMPLEMENTATION.


  method CONSTRUCTOR.
    me->id = value #( pgmid = 'R3TR' object = 'SHLP' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    "// Read information from Data Dictionary
    select single * from dd30l into @data(ls_header)
      where shlpname = @me->id-obj_name.
    check sy-subrc = 0.
    select * from dd31s into table @data(lt_sub_shlps)
      where shlpname = @me->id-obj_name.
    select * from dd32s into table @data(lt_fields)
      where shlpname = @me->id-obj_name.

    "// Enclosed search helps
    loop at lt_sub_shlps assigning field-symbol(<sub_shlp>).
      append parent->create_object( id = value #( pgmid = 'R3TR' object = 'SHLP'
        obj_name = <sub_shlp>-subshlp ) ) to objects.
    endloop.

    "// Selection method (table/view)
    if ls_header-selmethod is not initial.
      append parent->create_ddic_object( ls_header-selmethod ) to objects.
    endif.

    "// Text table
    if ls_header-texttab is not initial.
      append parent->create_ddic_object( ls_header-texttab ) to objects.
    endif.

    "// Exit function
    if ls_header-selmexit is not initial.
      append parent->create_object( id = value #( pgmid = 'LIMU' object = 'FUNC'
        obj_name = ls_header-selmexit ) ) to objects.
    endif.

    "// Fields
    loop at lt_fields assigning field-symbol(<field>).
      append parent->create_ddic_object( <field>-rollname ) to objects.
    endloop.
  endmethod.


  method zif_defuse_object~search_up.
    objects = parent->get_where_used( objtype = swbm_c_type_ddic_searchhelp
      objname = me->id-obj_name ).
  endmethod.
ENDCLASS.
