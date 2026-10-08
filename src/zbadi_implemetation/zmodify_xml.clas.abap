CLASS zmodify_xml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_badi_interface.
    INTERFACES if_edoc_adaptor_cloud.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMODIFY_XML IMPLEMENTATION.


  METHOD if_edoc_adaptor_cloud~set_output_data.

    IF iv_interface_id IS INITIAL AND iv_source_type = 'FI_INVOICE'.

      SELECT SINGLE accountingdocumenttype FROM i_journalentry
      WHERE companycode = @iv_source_key+0(4) AND accountingdocument = @iv_source_key+4(10) AND fiscalyear = @iv_source_key+14(4)
      INTO @DATA(lv_doctype) PRIVILEGED ACCESS.

      IF lv_doctype = 'D6' OR lv_doctype = 'D5'.
        ASSIGN COMPONENT 'REQUEST' OF STRUCTURE cs_output_data TO FIELD-SYMBOL(<fs_request>).
        IF <fs_request> IS ASSIGNED.
          ASSIGN COMPONENT 'DOC_DATA' OF STRUCTURE <fs_request> TO FIELD-SYMBOL(<fs_doc_data>).
          IF <fs_doc_data> IS ASSIGNED.
            ASSIGN COMPONENT 'BUYER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls>).
            ASSIGN COMPONENT 'SELLER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_seller_dtls>).
            IF <fs_buyer_dtls> IS ASSIGNED AND <fs_seller_dtls> IS ASSIGNED.
              ASSIGN COMPONENT 'POS' OF STRUCTURE <fs_buyer_dtls> TO FIELD-SYMBOL(<fs_pos>).
              ASSIGN COMPONENT 'STCD' OF STRUCTURE <fs_seller_dtls> TO FIELD-SYMBOL(<fs_stcd>).
              IF <fs_pos> IS ASSIGNED AND <fs_stcd> IS ASSIGNED.
                <fs_pos> = <fs_stcd>.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~change_edocument_type.

  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~change_form.

  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~get_variable_key.

  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~is_relevant.

  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~restrict_cancel.

  ENDMETHOD.
ENDCLASS.
