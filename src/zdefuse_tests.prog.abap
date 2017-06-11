*----------------------------------------------------------------------
*
*                              zDefuse
*   Check destructive transport requests before they wreck Production
*                     http://abap.ninja/zdefuse
*
*                 Copyright (c) 2017 Guilherme Maeda
*                  Licensed under the MIT license.
*----------------------------------------------------------------------
report zdefuse_tests.

data: gt_keys type sabp_t_tadir_keys.

start-of-selection.
  "// Find every zDefuse class
  select
      obj_name
      object as object_type
    from tadir into table gt_keys
    where pgmid = 'R3TR' and
          object = 'CLAS' and
          obj_name like 'ZCL_DEFUSE%'.

  "// Run ABAPUnit
  data(lo_runner) = new cl_aucv_runner( ).
  lo_runner->run_abap_unit_in_batch( i_tadir_keys = gt_keys  i_by_devc = abap_false ).
