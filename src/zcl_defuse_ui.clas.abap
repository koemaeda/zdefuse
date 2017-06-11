class ZCL_DEFUSE_UI definition
  public
  create public .

public section.

  class-methods CLASS_CONSTRUCTOR .
  methods CONSTRUCTOR
    importing
      !DEFUSE type ref to ZCL_DEFUSE .
  methods SHOW_HTML
    importing
      !RESULTS type ZCL_DEFUSE=>TY_RESULTS .
protected section.

  data DEFUSE type ref to ZCL_DEFUSE .
  class-data OBJECT_TYPES type TR_OBJECT_TEXTS .

  methods ON_PROGRESS
    for event PROGRESS of ZCL_DEFUSE
    importing
      !PROGRESS .
  methods GET_HTML
    importing
      !RESULTS type ZCL_DEFUSE=>TY_RESULTS
    returning
      value(HTML) type STRING .
private section.
ENDCLASS.



CLASS ZCL_DEFUSE_UI IMPLEMENTATION.


  method class_constructor.
*----------------------------------------------------------------------
*
*                              zDefuse
*   Check destructive transport requests before they wreck Production
*                     http://abap.ninja/zdefuse
*
*                 Copyright (c) 2017 Guilherme Maeda
*                  Licensed under the MIT license.
*----------------------------------------------------------------------

    call function 'TR_OBJECT_TABLE'
      tables
        wt_object_text = object_types.
  endmethod.


  method constructor.
    me->defuse = defuse.

    "// Subscribe to events
    set handler me->on_progress for me->defuse.
  endmethod.


  method get_html.
    constants: lc_icon_warning type string value '<span class="glyphicon glyphicon-warning-sign"></span>',
               lc_icon_up      type string value '<span class="glyphicon glyphicon-arrow-up"></span>',
               lc_icon_down    type string value '<span class="glyphicon glyphicon-arrow-down"></span>'.

    data: lv_class     type string,
          lv_situation type string,
          lv_paths     type string.

    "// HTML header (Bootstrap3/CDN hosted)
    html =
      |<!DOCTYPE html>\r\n| &&
      |<html lang="en">\r\n| &&
      |<head>\r\n| &&
      |<meta charset="utf-8">\r\n| &&
      |<meta http-equiv="X-UA-Compatible" content="IE=edge">\r\n| &&
      |<meta name="viewport" content="width=device-width, initial-scale=1">\r\n| &&
      |<!-- Latest compiled and minified CSS -->\r\n| &&
      |<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" crossorigin="anonymous">\r\n| &&
      |<title>zDefuse Report</title>\r\n| &&
      |</head>\r\n| &&
      |<body>\r\n| &&
      |<div class="container">\r\n| &&
      |<h1>zDefuse Report</h1>\r\n| &&
      |<small>Generated by { sy-uname } on { sy-datum date = user } at { sy-uzeit time = user }</small>\r\n| &&
      |<hr>\r\n|.

    "// Target system/totals
    html = html &&
      |<b>Target system/destination:</b> { results-target_system }<br>\r\n| &&
      |Total input objects: { results-total_input_objects number = environment }<br>\r\n| &&
      |Toal objects analysed: { results-total_objects_analysed number = environment }<br>\r\n| &&
      |Toal objects compared: { results-total_objects_compared number = environment }<br>\r\n| &&
      |<br>\r\n|.

    "// Transport numbers and descriptions
    if defuse->transports is not initial.
      html = html && |<b>Transport requests:</b>\r\n| &&
        |<table class="table table-condensed table-bordered">\r\n| &&
        |<thead><th>#</th><th>Owner</th><th>Description</th></thead>\r\n| &&
        |<tbody style="font-family: monospace">\r\n|.
      loop at defuse->transports assigning field-symbol(<transport>).
        html = html &&
          |<tr><td>{ <transport>-trkorr }</td>| &&
          |<td>{ <transport>-as4user }</td><td>{ <transport>-as4text }</td></tr>\r\n|.
      endloop.
      html = html && |</tbody></table>\r\n|.
    endif.

    "// Risk level
    html = html && |<h3>Result</h3>\r\n|.
    case results-risk_level.
      when zcl_defuse=>risk_safe.
        lv_class = 'success'.
        lv_situation = '<b>Safe</b> - Transport will not cause errors.'.
      when zcl_defuse=>risk_warnings.
        lv_class = 'warning'.
        lv_situation = '<b>Be careful</b> - Minor problems were found, you probably want to check them manually.'.
      when zcl_defuse=>risk_risky.
        lv_class = 'warning'.
        lv_situation = '<b>Risky</b> - Dependencies are different in the target system.'.
      when zcl_defuse=>risk_dangerous.
        lv_class = 'danger'.
        lv_situation = '<b>Dangerous</b> - Dependencies are different or missing in the target system.'.
      when zcl_defuse=>risk_unknown.
        lv_class = 'danger'.
        lv_situation = '<b>Unknown</b> - Analysis was not possible because of errors or processing limits reached.'.
    endcase.
    html = html &&
      |<div class="alert alert-{ lv_class }" role="alert">{ lv_situation }</div>\r\n|.

    "// Processing messages
    if results-messages is not initial.
      html = html && |<h3>Processing messages</h3>\r\n|.
      loop at results-messages assigning field-symbol(<message>).
        case <message>-type.
          when 'E' or 'A' or 'X'. lv_class = 'error'.
          when 'W'. lv_class = 'warning'.
          when others. lv_class = 'info'.
        endcase.
        html = html &&
          |<div class="alert alert-{ lv_class }" role="alert">{ <message>-message }</div>\r\n|.
      endloop.
    endif.

    "// Unsupported objects
    if results-unsupported_objects is not initial.
      html = html && |<h3>Unsuported objects</h3>\r\n| &&
        |<p>The following objects were found during the dependency analysis but are not supported.<br>\r\n| &&
        |They must be checked <b>manually</b>.</p>\r\n| &&
        |<table class="table table-condensed table-bordered">\r\n| &&
        |<thead><th>Object Type</th><th>Object Name</th></thead>\r\n| &&
        |<tbody>\r\n|.
      loop at results-unsupported_objects assigning field-symbol(<unsupported>).
        html = html &&
          |<tr><td>{ object_types[ object = <unsupported>-object ]-text }</td>| &&
          |<td style="font-family: monospace">{ <unsupported>-obj_name }</td></tr>\r\n|.
      endloop.
      html = html && |</tbody></table>\r\n|.
    endif. "results-unsupported_objects is not initial.

    "// Limited objects
    if results-limited_objects is not initial.
      html = html && |<h3>Limited objects</h3>\r\n| &&
        |<p>The following objects had too many dependents and/or dependencies, and therefore| &&
        | made the zDefuse analysis <b>impossible</b>.\r\n| &&
        |Increase the Maximum children parameter or remove these objects from your selection,| &&
        | and try again.</p>\r\n| &&
        |<table class="table table-condensed table-bordered">\r\n| &&
        |<thead><th>Object Type</th><th>Object Name</th></thead>\r\n| &&
        |<tbody>\r\n|.
      loop at results-limited_objects assigning field-symbol(<limited>).
        html = html &&
          |<tr><td>{ object_types[ object = <limited>-object ]-text }</td>| &&
          |<td style="font-family: monospace">{ <limited>-obj_name }</td></tr>\r\n|.
      endloop.
      html = html && |</tbody></table>\r\n|.
    endif. "results-limited_objects is not initial.

    "// Different objects
    if results-different_objects is not initial.
      html = html && |<h3>Different objects in target system</h3>\r\n| &&
        |<p>The following objects were found to be dependent or dependencies of the transported objects.<br>\r\n| &&
        |Objects marked in yellow are different in the target system.<br>\r\n| &&
        |Objects marked in red don't exist in the target system.<br>\r\n| &&
        |<table class="table table-condensed table-bordered">\r\n| &&
        |<thead><th>Object Type</th><th>Object Name</th><th>Paths</th><th>Situation</th></thead>\r\n| &&
        |<tbody>\r\n|.
      loop at results-different_objects assigning field-symbol(<different>).
        if <different>-different = abap_true.
          lv_class = 'warning'.
          lv_situation = 'Different'.
        elseif <different>-not_found = abap_true.
          lv_class = 'danger'.
          lv_situation = |{ lc_icon_warning } Not found in target system|.
        endif.

        clear lv_paths.
        loop at <different>-paths assigning field-symbol(<path>).
          if sy-tabix > 3. "// no need to show so many
            lv_paths = lv_paths && |* { lines( <different>-paths ) - 3 } more...|.
            exit.
          endif.
          data(lt_parts) = value stringtab( ).
          loop at <path>-parts assigning field-symbol(<part>).
            append |[{ <part>-object }] { <part>-obj_name }| to lt_parts.
          endloop.
          lv_paths = lv_paths && |* { concat_lines_of( table = lt_parts sep = | > | ) }<br>\r\n|.
        endloop.
        if lv_paths is initial.
          lv_paths = |{ lc_icon_warning } No paths were found.|.
        endif.
        html = html &&
          |<tr class="{ lv_class }"><td>{ object_types[ object = <different>-id-object ]-text }</td>| &&
          |<td style="font-family: monospace">{ <different>-id-obj_name }</td>| &&
          |<td><small>{ lv_paths }</small></td>| &&
          |<td>{ lv_situation }</td></tr>\r\n|.
      endloop.
      html = html && |</tbody></table>\r\n|.
    endif. "results-different_objects is not initial.

    html = html &&
      |<footer style="text-align: center;">\r\n| &&
      |zDefuse (<a href="http://abap.ninja/zdefuse">abap.ninja/zdefuse</a>)\r\n| &&
      |<hr></footer>\r\n| &&
      |</div></body>\r\n| &&
      |</html>\r\n|.
  endmethod.


  method on_progress.
    data: lv_text type string value 'Analysis:'.

    "// Show the progress information
    loop at progress assigning field-symbol(<progress>).
      lv_text = lv_text && | [{ <progress>-depth }] { <progress>-progress }%|.
    endloop.
    call function 'SAPGUI_PROGRESS_INDICATOR'
      exporting
        percentage = progress[ 1 ]-progress
        text       = lv_text.
  endmethod.


  method show_html.
    "// Show the HTML report in the client
    try.
      data(lv_xhtml) = cl_bcs_convert=>string_to_xstring( me->get_html( results ) ).
      data(lt_xhtml) = cl_bcs_convert=>xstring_to_solix( iv_xstring = lv_xhtml ).
    catch cx_bcs into data(lo_exc).
      message lo_exc->get_text( ) type 'E'.
    endtry.

    call method cl_gui_frontend_services=>show_document
      exporting
        document_name         = 'zDefuse Report.htm'
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
  endmethod.
ENDCLASS.