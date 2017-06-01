report zdefuse.

data: _sel_e070 type e070,
      gt_e070   type table of e070,
      go_defuse type ref to zcl_defuse.

selection-screen begin of block b1 with frame title text-t01.
select-options: s_trkorr for _sel_e070-trkorr obligatory.
parameters: p_tarsys type sysysid obligatory.
selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-t02.
parameters: p_max_dp type i default 10,
            p_fil_st type flag as checkbox.
selection-screen end of block b2.

start-of-selection.
  "// Select tasks
  select * from e070 into table gt_e070
    where trkorr in s_trkorr or
          strkorr in s_trkorr
    order by trkorr.
  check gt_e070[] is not initial.
  delete gt_e070 where strkorr is initial. "// Keep only tasks

  "// Run the Defuse analysis
  break-point.
  go_defuse = new zcl_defuse( target_system = conv #( p_tarsys ) ).
  go_defuse->max_depth = p_max_dp.
  go_defuse->filter_standard_objects = p_fil_st.
  go_defuse->add_transports( gt_e070 ).
  go_defuse->run( ).

  "// Show results
  perform show_html.


form show_html.
  data(lv_xhtml) = cl_bcs_convert=>string_to_xstring( go_defuse->get_html( ) ).
  data(lt_xhtml) = cl_bcs_convert=>xstring_to_solix( iv_xstring = lv_xhtml ).

  call method cl_gui_frontend_services=>show_document
    exporting
      document_name         = 'zDefuse report.htm'
      mime_type             = 'text/html'
      data_length           = xstrlen( lv_xhtml )
    changing
      document_data         = lt_xhtml
    exceptions
      cntl_error            = 1
      error_no_gui          = 2
      bad_parameter         = 3
      error_writing_data    = 4
      error_starting_viewer = 5
      unknown_mime_type     = 6
      not_supported_by_gui  = 7
      access_denied         = 8
      no_authority          = 9
      others                = 10.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
      with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
endform.
