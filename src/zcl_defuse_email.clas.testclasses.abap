*"* use this source file for your ABAP unit test classes

class test_email definition for testing risk level harmless duration medium.
  public section.
    constants: email_subject type string value 'zDefuse test'.
  private section.
    methods:
      teardown,
      get_email importing id type so_obj_id returning value(content) type sx_content,
      internal_recipient for testing,
      external_recipient for testing,
      attachment for testing.
endclass.

class test_email implementation.
  method teardown.
    "// Delete our unsent emails
    data: lt_recs type soxsp2tab.
    call function 'SX_SNDREC_SELECT'
      exporting
        status      = value soststatus( wait = 'X' )
        description = conv so_obj_des( email_subject )
      importing
        sndrecs     = lt_recs.

    data(lt_sosc) = corresponding sosctab( lt_recs ).
    loop at lt_recs assigning field-symbol(<rec>).
      data(lv_index) = sy-tabix.
      data(lt_recipients) = value sx_recipient_tab( ).
      call function 'SO_RECIPIENTS_FOR_SEND_GET'
        exporting
          sosc_entry         = corresponding sosc( <rec> )
          object_id          = conv sx_obj_id( |{ <rec>-objtp }{ <rec>-objyr }{ <rec>-objno }| )
        tables
          queue_buffer       = lt_sosc
          recipient_addrs    = lt_recipients
        exceptions
          err_no_recipients  = 1
          err_no_sendrequest = 2
          x_error            = 3
          others             = 4.
      check sy-subrc = 0.

      if lt_recipients[ 1 ]-address cs 'abap.ninja'.
        perform mark_table in program saplsbcs_out
          using lt_recs <rec> lv_index.
      endif.
    endloop.

    perform delete in program saplsbcs_out using lt_recs.
  endmethod.

  method get_email.
    call function 'SO_OBJECT_DATA_FOR_SEND_GET'
      exporting
        object_id            = conv sx_obj_id( id )
      importing
        content              = content
      exceptions
        err_obj_not_found    = 1
        err_no_authorization = 2
        err_wrong_reference  = 3
        others               = 4.
  endmethod.

  method internal_recipient.
    data(lo_email) = new zcl_defuse_email( email_subject ).
    lo_email->set_message( message = |This\r\nis\r\na\r\ntest!| is_html = abap_false ).
    lo_email->add_recipient( sy-uname ).
    lo_email->send( importing object_id = data(lv_id) receiving rc = data(lv_rc) ).
    cl_aunit_assert=>assert_initial( lv_rc ).
    cl_aunit_assert=>assert_not_initial( lv_id ).

    data(ls_content) = get_email( lv_id ).
    cl_aunit_assert=>assert_not_initial( ls_content ).
    cl_aunit_assert=>assert_not_initial( ls_content-lines ).
  endmethod.

  method external_recipient.
    data(lo_email) = new zcl_defuse_email( email_subject ).
    lo_email->set_message( message = |This\r\nis\r\na\r\ntest!| is_html = abap_false ).
    lo_email->add_recipient( 'guilherme@abap.ninja' ).
    lo_email->send( importing object_id = data(lv_id) receiving rc = data(lv_rc) ).
    cl_aunit_assert=>assert_initial( lv_rc ).
    cl_aunit_assert=>assert_not_initial( lv_id ).

    data(ls_content) = get_email( lv_id ).
    cl_aunit_assert=>assert_not_initial( ls_content ).
    cl_aunit_assert=>assert_not_initial( ls_content-lines ).
  endmethod.

  method attachment.
    data(lv_smiley) = cl_http_utility=>decode_x_base64(
      'R0lGODlhEAAQAOZDAPTOTPzWXPzifGxSFGRCBNyuFGRKBPzmjGRKDPzqjPTKPPTCJPTSXHRWFPzO' &&
      'RPzabJx2DPzKPPzebKR+DNSqHGRGBPTORJRyDLySDJx6DHRSBOy2FPS+JIxyHPTGLPzKNKyCDOzC' &&
      'NIxyFKyKHOSyFPzaZLSODPzihIxuFOy6FMyeHPTGPMSWDJR2FNSiDPzOPPTCLLSKDPzWVMymHNyq' &&
      'DJx2BPzGNPzSVOzGPNSiBPzGLPzSTGxOFPzqlPzedPzmhGRGDKyCFGxKBP///wAAAAAAAAAAAAAA' &&
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' &&
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' &&
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5' &&
      'BAEAAEMALAAAAAAQABAAAAfGgEOCgwYVPAODiYQaEyosEA0IioJCIDgBEjIKJBk8ikIzNxInBz8P' &&
      'Ox4YnoIGQTs+Pwk9CQKnMBBAghohPz9CQj09vz47BQ1DQBM7Ar7AwkI+DCsXQAYFAbFBQcHa0QoU' &&
      'QAgFDrAH5gI+JQEAHxQEPDU6AUI/AugP8xYcIrkN4wxCtGkTAuCFC0RDEGRYAGDHr18WImzoQGAQ' &&
      'DwwcIgAA4ECBjQ0jJCXi0YLGAg8LUuTokGsSkAEXTMRAMaDipEFAgFSwmSgQADs='
    ).
    data(lo_email) = new zcl_defuse_email( email_subject ).
    lo_email->set_message( message = |This is a <b>test</b>! <img src="cid:smiley.gif">| ).
    lo_email->add_recipient( 'guilherme@abap.ninja' ).
    lo_email->add_attachment( name = 'smiley.gif' content = lv_smiley ).
    lo_email->send( importing object_id = data(lv_id) receiving rc = data(lv_rc) ).
    cl_aunit_assert=>assert_initial( lv_rc ).
    cl_aunit_assert=>assert_not_initial( lv_id ).

    data(ls_content) = get_email( lv_id ).
    cl_aunit_assert=>assert_not_initial( ls_content-info-attlen ).
    cl_aunit_assert=>assert_not_initial( ls_content ).
    cl_aunit_assert=>assert_not_initial( ls_content-lines ).
  endmethod.
endclass.
