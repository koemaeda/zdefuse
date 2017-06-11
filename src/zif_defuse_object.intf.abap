interface ZIF_DEFUSE_OBJECT
  public .


  data ID type ZCL_DEFUSE=>TY_OBJECT_ID read-only .
  data PARENT type ref to ZCL_DEFUSE .
  data PATHS type ZCL_DEFUSE=>TY_T_OBJECT_PATH .
  data CACHED_RESULTS_UP type ref to ZCL_DEFUSE=>TY_T_OBJECT .
  data CACHED_RESULTS_DOWN type ref to ZCL_DEFUSE=>TY_T_OBJECT .

  methods SEARCH_UP
    returning
      value(OBJECTS) type ZCL_DEFUSE=>TY_T_OBJECT .
  methods SEARCH_DOWN
    returning
      value(OBJECTS) type ZCL_DEFUSE=>TY_T_OBJECT .
endinterface.
