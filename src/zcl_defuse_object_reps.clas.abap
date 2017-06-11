class ZCL_DEFUSE_OBJECT_REPS definition
  public
  inheriting from ZCL_DEFUSE_OBJECT_PROG
  create public .

public section.

  methods CONSTRUCTOR
    importing
      value(NAME) type CLIKE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_REPS IMPLEMENTATION.


  method constructor.
    super->constructor( name ).
    me->id-pgmid = 'LIMU'.
    me->id-object = 'REPS'.
  endmethod.
ENDCLASS.
