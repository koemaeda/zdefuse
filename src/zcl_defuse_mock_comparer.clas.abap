class ZCL_DEFUSE_MOCK_COMPARER definition
  public
  final
  create public .

public section.

  interfaces ZIF_DEFUSE_COMPARER .

  data DIFFERENT type ZCL_DEFUSE=>TY_T_OBJECT_ID .
  data NOT_FOUND type ZCL_DEFUSE=>TY_T_OBJECT_ID .
  data IGNORED type ZCL_DEFUSE=>TY_T_OBJECT_ID .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_MOCK_COMPARER IMPLEMENTATION.


  method zif_defuse_comparer~compare_objects.
    "//
    "// This should be used ONLY for unit tests!
    "//
    loop at objects assigning field-symbol(<object>).
      read table me->different transporting no fields with key
        pgmid = <object>-pgmid
        object = <object>-object
        obj_name = <object>-obj_name.
      if sy-subrc = 0.
        append <object> to different.
      endif.

      read table me->not_found transporting no fields with key
        pgmid = <object>-pgmid
        object = <object>-object
        obj_name = <object>-obj_name.
      if sy-subrc = 0.
        append <object> to not_found.
      endif.

      read table me->ignored transporting no fields with key
        pgmid = <object>-pgmid
        object = <object>-object
        obj_name = <object>-obj_name.
      if sy-subrc = 0.
        append <object> to ignored.
      endif.
    endloop.

    total_compared = lines( objects ).
  endmethod.
ENDCLASS.
