class ZCL_DEFUSE_OBJECT_DDIC definition
  public
  abstract
  create public .

public section.

  interfaces ZIF_DEFUSE_OBJECT .
protected section.

  aliases CHILDREN
    for ZIF_DEFUSE_OBJECT~CHILDREN .
  aliases ID
    for ZIF_DEFUSE_OBJECT~ID .
  aliases PACKAGE
    for ZIF_DEFUSE_OBJECT~PACKAGE .
  aliases PARENT
    for ZIF_DEFUSE_OBJECT~PARENT .
  aliases SEARCH_DOWN
    for ZIF_DEFUSE_OBJECT~SEARCH_DOWN .
  aliases SEARCH_UP
    for ZIF_DEFUSE_OBJECT~SEARCH_UP .
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_OBJECT_DDIC IMPLEMENTATION.


  method ZIF_DEFUSE_OBJECT~SEARCH_DOWN.

  endmethod.


  method zif_defuse_object~search_up.
    data(lv_fullname) = '\TY:' && me->id-obj_name.

    "// If this is a class/interface type
    replace '=>' in lv_fullname with '\TY:'.

    "// If this is a member of another type
    replace '-' in lv_fullname with '\TY:'.

    "// Find references
    objects = parent->get_where_used( lv_fullname ).
  endmethod.
ENDCLASS.
