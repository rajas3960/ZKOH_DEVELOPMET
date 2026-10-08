CLASS lhc_ZI_JENTRY_RV DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_jentry_rv RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_jentry_rv RESULT result.

    METHODS Post FOR MODIFY
      IMPORTING keys FOR ACTION zi_jentry_rv~Post RESULT result.

ENDCLASS.

CLASS lhc_ZI_JENTRY_RV IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD Post.

    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid     TYPE abp_behv_cid.


    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

    DATA(lv_syuser) = cl_abap_context_info=>get_user_description( ).
    DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).

    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
    <je_deep>-%cid = lv_cid.
    <je_deep>-%param = VALUE #(
     companycode = '1000' " Success
     documentreferenceid = 'BKPFF'
     createdbyuser = lv_syuser
     businesstransactiontype = 'RFBU'
     accountingdocumenttype = 'DZ'
     documentdate = lv_sydate
     postingdate = lv_sydate
     accountingdocumentheadertext = ' Custom API Post'
     _glitems = VALUE #( ( glaccountlineitem = |001|
                           glaccount = '0000179020'
                           _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '12000.00' currency = 'INR' ) ) )
     ( glaccountlineitem = |002|
       glaccount = '0000175011'
*         = '0300000136'
       _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '-12000.00' currency = 'INR'  ) ) ) )


    ).


    MODIFY ENTITIES OF i_journalentrytp
     ENTITY journalentry
     EXECUTE post FROM lt_je_deep
     FAILED DATA(ls_failed_deep)
     REPORTED DATA(ls_reported_deep)
     MAPPED DATA(ls_mapped_deep).


    IF ls_failed_deep IS NOT INITIAL.


      LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
        DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).

      ENDLOOP.
    ELSE.

      zbp_i_jentry_rv=>cv_avvtdoc-journalentry = ls_mapped_deep-journalentry.
*COMMIT ENTITIES BEGIN
* RESPONSE OF i_journalentrytp
* FAILED DATA(lt_commit_failed)
* REPORTED DATA(lt_commit_reported).
* ...
* COMMIT ENTITIES END.
    ENDIF.



  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_JENTRY_RV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_JENTRY_RV IMPLEMENTATION.

  METHOD save_modified.

    IF zbp_i_jentry_rv=>cv_avvtdoc-journalentry IS NOT INITIAL.
      LOOP AT zbp_i_jentry_rv=>cv_avvtdoc-journalentry ASSIGNING FIELD-SYMBOL(<fs_ord>).
*        CONVERT KEY OF i_journalentrytp FROM <fs_ord>-AccountingDocument TO DATA(ls_ordnum).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
