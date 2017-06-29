interface ZIF_DEFUSE_COMPARER
  public .


  methods COMPARE_OBJECTS
    importing
      !OBJECTS type ZCL_DEFUSE=>TY_T_OBJECT_ID
      !TARGET_SYSTEM type SYSYSID optional
    exporting
      value(TOTAL_COMPARED) type I
      value(DIFFERENT) type ZCL_DEFUSE=>TY_T_OBJECT_ID
      value(NOT_FOUND) type ZCL_DEFUSE=>TY_T_OBJECT_ID
      value(IGNORED) type ZCL_DEFUSE=>TY_T_OBJECT_ID
      value(MESSAGES) type BAPIRET2_TAB .
endinterface.
