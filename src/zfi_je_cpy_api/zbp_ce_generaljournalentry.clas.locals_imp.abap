CLASS lhc_jheader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR jheader RESULT result.

    METHODS post FOR DETERMINE ON SAVE
      IMPORTING keys FOR jheader~post.

ENDCLASS.

CLASS lhc_jheader IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD post.
    DATA: lt_entry    TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          ls_entry    LIKE LINE OF lt_entry,
          ls_glitem   LIKE LINE OF ls_entry-%param-_glitems,
          ls_aritem   LIKE LINE OF ls_entry-%param-_aritems,
          ls_apitem   LIKE LINE OF ls_entry-%param-_apitems,
          ls_amount   LIKE LINE OF ls_glitem-_currencyamount,
          ls_aramt    LIKE LINE OF ls_aritem-_currencyamount,
          lt_temp_key TYPE zgje_transaction_handler=>tt_temp_key,
          ls_temp_key LIKE LINE OF lt_temp_key.

    READ ENTITIES OF zce_generaljournalentry IN LOCAL MODE
        ENTITY jheader ALL FIELDS WITH CORRESPONDING #( keys ) RESULT FINAL(header).

    "start to call I_JournalEntryTP~Post
    LOOP AT header REFERENCE INTO DATA(ls_header).
      CLEAR ls_entry.
      ls_entry-%cid = ls_header->uuid. "use UUID as CID
      ls_entry-%param-companycode = ls_header->bukrs.
      ls_entry-%param-businesstransactiontype = 'RFPI'.
      ls_entry-%param-accountingdocumenttype = 'DZ'.
      ls_entry-%param-accountingdocumentheadertext = ls_header->bktxt.
      ls_entry-%param-documentdate = ls_header->bldat.
      ls_entry-%param-postingdate = ls_header->budat.
      ls_entry-%param-createdbyuser = ls_header->createdby.
      ls_entry-%param-documentreferenceid = 'BKPFF'.

      CLEAR ls_glitem.
      ls_glitem-glaccountlineitem = 1.
      ls_glitem-glaccount         = ls_header->hkont.
      ls_glitem-costcenter        = ls_header->kostl.
      ls_glitem-profitcenter        = ls_header->prctr.
      ls_glitem-documentitemtext       = ls_header->sgtxt.
      ls_glitem-housebank = ls_header->hbkid.
      ls_glitem-housebankaccount = ls_header->hktid.
      ls_glitem-assignmentreference = ls_header->awkey.
      ls_glitem-businessplace = ls_header->bbranc.
      ls_glitem-segment = ls_header->segment.
      ls_glitem-_profitabilitysupplement-customer  = ls_header->kunnr.

      CLEAR ls_amount.
      ls_amount-currencyrole = '00'.
      ls_amount-currency = ls_header->waers.
      ls_amount-journalentryitemamount = ls_header->wrbtr.
      APPEND ls_amount TO ls_glitem-_currencyamount.
      APPEND ls_glitem TO ls_entry-%param-_glitems.

      ls_aritem-glaccountlineitem = 2.
      ls_aritem-customer = ls_header->kunnr.
      ls_aritem-businessplace = ls_header->bbranc.
      ls_aritem-reference1idbybusinesspartner = ls_header->kunnr.
      ls_aritem-paymentreference =  ls_header->kunnr.
      CLEAR ls_aramt.
      ls_aramt-currencyrole = '00'.
      ls_aramt-currency = ls_header->waers.
      ls_aramt-journalentryitemamount = ls_header->wrbtr   * -1.
      APPEND ls_aramt TO ls_aritem-_currencyamount.
      APPEND ls_aritem TO ls_entry-%param-_aritems.


      APPEND ls_entry TO lt_entry.

    ENDLOOP.



    IF lt_entry IS NOT INITIAL.
      MODIFY ENTITIES OF i_journalentrytp PRIVILEGED
      ENTITY journalentry
      EXECUTE post FROM lt_entry
        MAPPED FINAL(ls_post_mapped)
        FAILED FINAL(ls_post_failed)
        REPORTED FINAL(ls_post_reported).

      IF ls_post_failed IS NOT INITIAL.
        LOOP AT ls_post_reported-journalentry INTO DATA(ls_report).
          APPEND VALUE #( uuid = ls_report-%cid
                          %create = if_abap_behv=>mk-on
                          %is_draft = if_abap_behv=>mk-on
                          %msg = ls_report-%msg ) TO reported-jheader.
        ENDLOOP.
      ENDIF.

      LOOP AT ls_post_mapped-journalentry INTO DATA(ls_je_mapped).
        ls_temp_key-cid = ls_je_mapped-%cid.
        ls_temp_key-pid = ls_je_mapped-%pid.
        APPEND ls_temp_key TO lt_temp_key.
      ENDLOOP.

    ENDIF.

    zcje_transaction_handler=>get_instance( )->set_temp_key( lt_temp_key ).



  ENDMETHOD.

ENDCLASS.

CLASS lsc_zce_generaljournalentry DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zce_generaljournalentry IMPLEMENTATION.

  METHOD save_modified.
    "unmanaged save for table ZGJE_HEADER
    DATA: lt_create TYPE TABLE OF zcje_header,
          lt_delete TYPE TABLE OF zcje_header.


    lt_create = CORRESPONDING #( create-jheader MAPPING FROM ENTITY ).
    lt_delete = CORRESPONDING #( delete-jheader MAPPING FROM ENTITY ).
    zcje_transaction_handler=>get_instance( )->additional_save( it_create = lt_create
                                                                it_delete = lt_delete ).

  ENDMETHOD.

  METHOD cleanup_finalize.
    zcje_transaction_handler=>get_instance( )->clean_up( ).
  ENDMETHOD.

ENDCLASS.
