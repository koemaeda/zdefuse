class ZCL_DEFUSE_OBJECT_MSAG definition
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



CLASS ZCL_DEFUSE_OBJECT_MSAG IMPLEMENTATION.


  method constructor.
    me->id = value #( pgmid = 'R3TR' object = 'MSAG' obj_name = name ).
  endmethod.


  method zif_defuse_object~search_down.
    "// Message objects don't use anything
  endmethod.


  method zif_defuse_object~search_up.
    "// Find all message numbers
    select distinct msgnr from t100 into table @data(lt_t100)
      where arbgb = @me->id-obj_name.

    "// Find references to each message
    loop at lt_t100 assigning field-symbol(<t100>).
      append lines of parent->get_where_used( |\\MI:{ me->id-obj_name width = 20 }{ <t100>-msgnr }| )
        to objects.
    endloop.
    sort objects. delete adjacent duplicates from objects.
  endmethod.
ENDCLASS.
