class ZCL_DEFUSE_OBJECT_ENHO definition
  public
  create public .

public section.

  interfaces ZIF_DEFUSE_OBJECT .

  methods CONSTRUCTOR
    importing
      !NAME type CLIKE .
protected section.

  data INCLUDE type PROGNAME .
private section.

  aliases ID
    for ZIF_DEFUSE_OBJECT~ID .
  aliases PARENT
    for ZIF_DEFUSE_OBJECT~PARENT .
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_ENHO IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'R3TR' object = 'ENHO' obj_name = name ).

    "// Determine implementation include
    me->include = |{ me->id-obj_name width = 30 pad = '=' }E|.
  endmethod.


  method zif_defuse_object~search_down.
    objects = parent->get_include_references( me->include ).
  endmethod.


  method zif_defuse_object~search_up.
    "// Read enhanced objects
    "// (based on cl_enh_wb_access=>get_enh_childs)
    select distinct pgmid, obj_type, obj_name
      from enhobj into table @data(lt_objects)
      where enhname = @me->id-obj_name and
            state <> 'R'. "// deleted/removed

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
