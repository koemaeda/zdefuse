interface ZIF_DEFUSE_OBJECT
  public .


  data ID type ZCL_DEFUSE=>TY_OBJECT_ID read-only .
  data PACKAGE type DEVCLASS .
  data CHILDREN type ZCL_DEFUSE=>TY_T_NODE .
  data PARENT type ref to ZCL_DEFUSE .

  methods SEARCH_UP
    returning
      value(OBJECTS) type ZCL_DEFUSE=>TY_T_OBJECT .
  methods SEARCH_DOWN
    returning
      value(OBJECTS) type ZCL_DEFUSE=>TY_T_OBJECT .
endinterface.
