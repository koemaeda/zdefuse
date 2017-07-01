*----------------------------------------------------------------------
*
*                              zDefuse
*   Check destructive transport requests before they wreck Production
*                     http://abap.ninja/zdefuse
*
*                 Copyright (c) 2017 Guilherme Maeda
*                  Licensed under the MIT license.
*----------------------------------------------------------------------
report zdefuse.

data: _sel_e070 type e070,
      _sel_smtp type adr6,
      gt_trkorr type trkorrs,
      go_defuse type ref to zcl_defuse,
      go_ui     type ref to zcl_defuse_ui.

selection-screen begin of block b1 with frame title text-t01.
select-options: s_trkorr for _sel_e070-trkorr obligatory.
parameters: p_tarsys type sysysid obligatory.
selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-t02.
parameters: p_max_dp type i default 3,
            p_fil_st type flag as checkbox default 'X'.
selection-screen end of block b2.

selection-screen begin of block b3 with frame title text-t03.
parameters: p_show type flag radiobutton group out default 'X',
            p_send type flag radiobutton group out.
selection-screen begin of block b3_1 with frame title text-t04.
select-options: s_email for _sel_smtp-smtp_addr no intervals default sy-uname.
parameters: p_risky type flag as checkbox default 'X'.
selection-screen end of block b3_1.
selection-screen end of block b3.


start-of-selection.
  "// Select requests
  select trkorr from e070 into table gt_trkorr
    where trkorr in s_trkorr and
          strkorr = space
    order by trkorr.
  check gt_trkorr[] is not initial.

  "// Run the Defuse analysis
  go_defuse = new zcl_defuse( ).
  go_ui = new zcl_defuse_ui( go_defuse ).

  go_defuse->max_depth = p_max_dp.
  go_defuse->filter_standard_objects = p_fil_st.

  go_defuse->add_transports( gt_trkorr ).
  data(ls_results) = go_defuse->run( p_tarsys ).

  "// Show/send results
  if p_show is not initial.
    go_ui->show_html( ls_results ).
  elseif p_send is not initial and s_email[] is not initial.
    if p_risky is initial or ls_results-risk_level >= zcl_defuse=>risk_risky.
      go_ui->send_email( results = ls_results
        receivers = value #( for item in s_email ( conv #( item-low ) ) ) ).
    endif.
  else.
    message 'No valid output mode was selected.' type 'E'.
  endif.
