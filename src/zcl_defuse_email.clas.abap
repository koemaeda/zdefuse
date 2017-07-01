class ZCL_DEFUSE_EMAIL definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !SENDER type CLIKE default SY-UNAME
      !SUBJECT type CLIKE
      !COMMIT_WORK type ABAP_BOOL default ABAP_TRUE .
  methods SET_PRIORITY
    importing
      !PRIORITY type SO_OBJ_PRI .
  methods ADD_RECIPIENT
    importing
      !ADDRESS type CLIKE
      !EXPRESS type ABAP_BOOL optional
      !CC type ABAP_BOOL optional
      !BCC type ABAP_BOOL optional .
  methods SET_MESSAGE
    importing
      !MESSAGE type CLIKE
      value(IS_HTML) type ABAP_BOOL default ABAP_TRUE .
  methods ADD_ATTACHMENT
    importing
      !NAME type CLIKE
      !CONTENT type XSTRING
      !TYPE type SO_OBJ_TP default 'BIN' .
  methods SEND
    exporting
      value(OBJECT_ID) type SO_OBJ_ID
    returning
      value(RC) type SYSUBRC .
protected section.

  data SENDER type SO_REC_EXT .
  data COMMIT_WORK type ABAP_BOOL .
  data DOCUMENT_DATA type SODOCCHGI1 .
  data:
    receivers type table of somlreci1 .
  data:
    packing_list type table of sopcklsti1 .
  data:
    contents_bin type table of solix .
  data:
    contents_txt type table of solisti1 .
private section.

  methods ADD_PART
    importing
      !NAME type CLIKE optional
      !CONTENT type ANY
      !IS_BINARY type ABAP_BOOL default ABAP_FALSE
      !TYPE type SO_OBJ_TP default 'HTM' .
ENDCLASS.



CLASS ZCL_DEFUSE_EMAIL IMPLEMENTATION.


method add_attachment.
  me->add_part(
    name = name
    content = content
    is_binary = abap_true
    type = type
  ).
endmethod.


method add_part.
  "// Convert content to SAPScript format
  if is_binary = abap_true.
    data(lt_new_bin) = cl_bcs_convert=>xstring_to_solix( content ).
  else.
    data(lt_new_txt) = cl_bcs_convert=>string_to_soli( content ).
  endif.

  "// Add packaging list entry //
  append value #(
    transf_bin = is_binary
    body_start = switch i( is_binary when abap_true then lines( me->contents_bin )
                            else lines( me->contents_txt ) ) + 1
    body_num = switch i( is_binary when abap_true then lines( lt_new_bin )
                            else lines( lt_new_txt ) )
    head_start = '000000000000001'
    head_num = '000000000000000'
    doc_type = type
    obj_name = name
    obj_descr = name
  ) to me->packing_list.

  "// Add the content to the content table //
  append lines of lt_new_bin to me->contents_bin.
  append lines of lt_new_txt to me->contents_txt.
endmethod.


method add_recipient.
  append value #(
    "// U = Email address / B = SAP user
    rec_type = switch #( xsdbool( address cs '@' ) when abap_true then 'U' else 'B' )
    express = express
    com_type = 'INT'
    receiver = conv #( address )
    copy = cc
    blind_copy = bcc
  ) to me->receivers.
endmethod.


method CONSTRUCTOR.
  me->sender = sender.
  me->document_data-obj_descr = subject.
  me->commit_work = commit_work.
endmethod.


method send.
  data: lt_objheader   type table of solisti1.

  call function 'SO_DOCUMENT_SEND_API1'
    exporting
      document_data              = me->document_data
      sender_address             = me->sender
      sender_address_type        = switch so_adr_typ( xsdbool( me->sender cs '@' )
                                     when abap_true then 'U' else 'B' )
      commit_work                = me->commit_work
    importing
      new_object_id              = object_id
    tables
      packing_list               = me->packing_list
      object_header              = lt_objheader
      contents_hex               = me->contents_bin
      contents_txt               = me->contents_txt
      receivers                  = me->receivers
    exceptions
      too_many_receivers         = 51
      document_not_sent          = 52
      document_type_not_exist    = 53
      operation_no_authorization = 54
      parameter_error            = 55
      x_error                    = 56
      enqueue_error              = 57
      others                     = 58.

  rc = sy-subrc.
endmethod.


method set_message.
  me->add_part(
    content = message
    type = switch #( is_html when abap_true then 'HTM' else 'RAW' )
  ).
endmethod.


  method set_priority.
    me->document_data-obj_prio =
    me->document_data-priority = priority.
  endmethod.
ENDCLASS.
