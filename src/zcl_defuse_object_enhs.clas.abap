class ZCL_DEFUSE_OBJECT_ENHS definition
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



CLASS ZCL_DEFUSE_OBJECT_ENHS IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'R3TR' object = 'ENHS' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    "// Read implementations
    data(lt_impl) = cl_enh_utilities=>get_enhancements_to_spot( conv #( me->id-obj_name ) ).
    loop at lt_impl assigning field-symbol(<impl>).
      append parent->create_object( value #( pgmid = 'R3TR'
        object = 'ENHO' obj_name = <impl>-enhname ) ) to objects.
    endloop.
    delete objects where table_line is initial.
  endmethod.


  method zif_defuse_object~search_up.
    "// Read enhanced objects
    "// (based on cl_enh_wb_access=>get_enh_spot_childs)
    select distinct pgmid, obj_type, obj_name
      from enhspotobj into table @data(lt_objects)
      where enhspot = @me->id-obj_name.

    loop at lt_objects assigning field-symbol(<object>).
      if <object>-obj_type = 'REPS'.
        append parent->create_object_for_include( conv #( <object>-obj_name ) ) to objects.
      else.
        append parent->create_object( value #( pgmid = <object>-pgmid
          object = <object>-obj_type obj_name = <object>-obj_name ) ) to objects.
      endif.
    endloop.
    delete objects where table_line is initial.
  endmethod.
ENDCLASS.
