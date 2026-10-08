CLASS zustom_badi_imp_cl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_edoc_adaptor_cloud .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZUSTOM_BADI_IMP_CL IMPLEMENTATION.


  METHOD if_edoc_adaptor_cloud~change_edocument_type.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~change_form.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~change_invoice_type.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~get_variable_key.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~is_relevant.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~restrict_cancel.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~set_output_data.
*************************************add shift to details node in e-invoice*****************************************
*    DATA(lv_doc) = iv_source_key.
*    DATA: lv_bill TYPE i_billingdocument-billingdocument.
*    DATA: lv_billc TYPE I_BillingDocument-Country.
*    lv_bill = lv_doc.
*    CONDENSE lv_bill.
*    SELECT SINGLE billingdocument,billingdocumentitem,addressid,customer,partnerfunction FROM I_BillingDocItemPartner WITH PRIVILEGED ACCESS
*    WHERE billingdocument = @lv_bill
*    AND partnerfunction = 'WE'
*    INTO @DATA(ls_add).
*
*    SELECT SINGLE cityname,postalcode,country,organizationname1,statecode,streetname FROM zcustom_add WITH PRIVILEGED ACCESS
*    WHERE addressid = @ls_add-addressid INTO @DATA(ls_address).
*
*    SELECT SINGLE customer,taxnumber3
*    FROM i_customer WITH PRIVILEGED ACCESS AS c
*    WHERE c~customer = @ls_add-customer
*    INTO @DATA(ls_customer).
*
*    SELECT SINGLE billingdocument,country FROM I_BillingDocument WITH PRIVILEGED ACCESS
*    WHERE BillingDocument = @ls_add-BillingDocument INTO @DATA(ls_BILL).
*
*    SELECT SINGLE billingdocument,billingdocumentitem,addressid,customer,partnerfunction FROM I_BillingDocItemPartner WITH PRIVILEGED ACCESS
*   WHERE billingdocument = @lv_bill
*   AND partnerfunction = 'AG' INTO @DATA(ls_add1).
*
*    SELECT SINGLE cityname,postalcode,country,organizationname1,statecode,streetname FROM zcustom_add WITH PRIVILEGED ACCESS
*    WHERE addressid = @ls_add1-addressid INTO @DATA(ls_address1).
*
*    SELECT SINGLE customer,taxnumber3
*    FROM i_customer WITH PRIVILEGED ACCESS AS c
*    WHERE c~customer = @ls_add1-customer
*    INTO @DATA(ls_customer1).
*
*
*    IF ls_customer1-taxnumber3 = ls_customer-taxnumber3  and ls_BILL = 'IN'.
*   IF sy-subrc = 1.
*      ASSIGN COMPONENT 'REQUEST' OF STRUCTURE cs_output_data TO FIELD-SYMBOL(<fs_request>).
*      IF <fs_request> IS ASSIGNED.
*        ASSIGN COMPONENT 'DOC_DATA' OF STRUCTURE <fs_request> TO FIELD-SYMBOL(<fs_doc_data>).
*
*        IF <fs_doc_data> IS ASSIGNED.
**      ASSIGN COMPONENT 'BUYER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls9>).
*          ASSIGN COMPONENT 'SHIP_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_seller_dtls1>).
**            IF <fs_buyer_dtls9> IS ASSIGNED AND <fs_seller_dtls9> IS ASSIGNED.
**              ASSIGN COMPONENT 'GSTIN' OF STRUCTURE <fs_buyer_dtls9> TO FIELD-SYMBOL(<fs_pos>).
*          ASSIGN COMPONENT 'GSTIN' OF STRUCTURE <fs_seller_dtls1> TO FIELD-SYMBOL(<fs_stcd>).
*          IF <fs_stcd> IS ASSIGNED.
*            <fs_stcd> = ls_customer-taxnumber3.
*          ENDIF.
*
*          ASSIGN COMPONENT 'SHIP_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_seller_dtls2>).
*          ASSIGN COMPONENT 'LGL_NM' OF STRUCTURE <fs_seller_dtls2> TO FIELD-SYMBOL(<adddr1>).
*          IF <adddr1> IS ASSIGNED.
*            <adddr1> = ls_address-organizationname1.
*          ENDIF.
*
*          ASSIGN COMPONENT 'SHIP_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_seller_dtls3>).
*          ASSIGN COMPONENT 'TRD_NM' OF STRUCTURE <fs_seller_dtls3> TO FIELD-SYMBOL(<adddr2>).
*          IF <adddr2> IS ASSIGNED.
*            <adddr2> = ls_address-organizationname1.
*          ENDIF.
*
*          ASSIGN COMPONENT 'SHIP_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_seller_dtls4>).
*          ASSIGN COMPONENT 'POS' OF STRUCTURE <fs_seller_dtls4> TO FIELD-SYMBOL(<adddr3>).
*          IF <adddr3> IS ASSIGNED.
*            <adddr3> = ls_address-cityname.
*          ENDIF.
*
*          ASSIGN COMPONENT 'SHIP_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_seller_dtls5>).
*          ASSIGN COMPONENT 'ADDR1' OF STRUCTURE <fs_seller_dtls5> TO FIELD-SYMBOL(<adddr4>).
*          IF <adddr4> IS ASSIGNED.
*            <adddr4> = ls_address-streetname.
*          ENDIF.
*
*          ASSIGN COMPONENT 'SHIP_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_seller_dtls6>).
*          ASSIGN COMPONENT 'ADDR2' OF STRUCTURE <fs_seller_dtls6> TO FIELD-SYMBOL(<adddr8>).
*          IF <adddr8> IS ASSIGNED.
*            <adddr8> = ls_address-cityname.
*          ENDIF.
*
*          ASSIGN COMPONENT 'SHIP_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_seller_dtls7>).
*          ASSIGN COMPONENT 'LOC' OF STRUCTURE <fs_seller_dtls7> TO FIELD-SYMBOL(<adddr5>).
*          IF <adddr5> IS ASSIGNED.
*            <adddr5> = ls_address-cityname.
*          ENDIF.
*
*          ASSIGN COMPONENT 'SHIP_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_seller_dtls8>).
*          ASSIGN COMPONENT 'PIN' OF STRUCTURE <fs_seller_dtls8> TO FIELD-SYMBOL(<adddr6>).
*          IF <adddr6> IS ASSIGNED.
*            <adddr6> = ls_address-postalcode.
*          ENDIF.
*
*          ASSIGN COMPONENT 'SHIP_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_seller_dtls9>).
*          ASSIGN COMPONENT 'STCD' OF STRUCTURE <fs_seller_dtls9> TO FIELD-SYMBOL(<adddr7>).
*          IF <adddr7> IS ASSIGNED.
*            <adddr7> = ls_address-statecode.
*          ENDIF.
*
*
*        ENDIF.
* ENDIF.
*      ENDIF.
*    ENDIF.
*************************************add shift to details in buyer node in e-invoice*****************************************
*      IF <fs_doc_data> IS ASSIGNED.
*      ASSIGN COMPONENT 'BUYER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls>).
*        ASSIGN COMPONENT 'LGL_NM' OF STRUCTURE <fs_buyer_dtls> TO FIELD-SYMBOL(<addr1>).
*        IF <addr1> IS ASSIGNED.
*          <addr1> = 'ABC'.
*        ENDIF.
*
*        ASSIGN COMPONENT 'BUYER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls1>).
*        ASSIGN COMPONENT 'TRD_NM' OF STRUCTURE <fs_buyer_dtls1> TO FIELD-SYMBOL(<addr2>).
*        IF <addr2> IS ASSIGNED.
*          <addr2> = 'ABC1'.
*        ENDIF.
*
*        ASSIGN COMPONENT 'BUYER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls2>).
*        ASSIGN COMPONENT 'POS' OF STRUCTURE <fs_buyer_dtls2> TO FIELD-SYMBOL(<addr3>).
*        IF <addr3> IS ASSIGNED.
*          <addr3> = '29'.
*        ENDIF.
*
*        ASSIGN COMPONENT 'BUYER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls3>).
*        ASSIGN COMPONENT 'ADDR1' OF STRUCTURE <fs_buyer_dtls3> TO FIELD-SYMBOL(<addr4>).
*        IF <addr4> IS ASSIGNED.
*          <addr4> = 'ABC3'.
*        ENDIF.
*
*        ASSIGN COMPONENT 'BUYER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls7>).
*        ASSIGN COMPONENT 'ADDR2' OF STRUCTURE <fs_buyer_dtls3> TO FIELD-SYMBOL(<addr8>).
*        IF <addr8> IS ASSIGNED.
*          <addr8> = 'ABC3'.
*        ENDIF.
*
*        ASSIGN COMPONENT 'BUYER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls4>).
*        ASSIGN COMPONENT 'LOC' OF STRUCTURE <fs_buyer_dtls4> TO FIELD-SYMBOL(<addr5>).
*        IF <addr5> IS ASSIGNED.
*          <addr5> = 'ABC4'.
*        ENDIF.
*
*        ASSIGN COMPONENT 'BUYER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls5>).
*        ASSIGN COMPONENT 'PIN' OF STRUCTURE <fs_buyer_dtls5> TO FIELD-SYMBOL(<addr6>).
*        IF <addr6> IS ASSIGNED.
*          <addr6> = '575001'.
*        ENDIF.
*
*        ASSIGN COMPONENT 'BUYER_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls6>).
*        ASSIGN COMPONENT 'STCD' OF STRUCTURE <fs_buyer_dtls6> TO FIELD-SYMBOL(<addr7>).
*        IF <addr7> IS ASSIGNED.
*          <addr7> = '29'.
*        ENDIF.
*
*      ENDIF.
*    ENDIF.

****************************************************************************end********************************************************
**    DATA(lv_doc) = iv_source_key.
**    DATA: lv_bill TYPE i_billingdocument-billingdocument.
**    lv_bill = lv_doc.  SELECT SINGLE billingdocument,addressid,customer,partnerfunction FROM i_billingdocumentpartner WITH PRIVILEGED ACCESS
**    WHERE billingdocument = @lv_bill
**    AND partnerfunction = 'LW' INTO @DATA(ls_add).
**
**    SELECT SINGLE cityname,postalcode,country,organizationname1,statecode,streetname FROM zcustom_add WITH PRIVILEGED ACCESS
**    WHERE addressid = @ls_add-addressid INTO @DATA(ls_address).
**
**
**    IF ls_add IS NOT INITIAL.
**      ASSIGN COMPONENT 'REQUEST' OF STRUCTURE cs_output_data TO FIELD-SYMBOL(<fs_request>).
**      IF <fs_request> IS ASSIGNED.
**        ASSIGN COMPONENT 'DOC_DATA' OF STRUCTURE <fs_request> TO FIELD-SYMBOL(<fs_doc_data>).
**
**        IF <fs_doc_data> IS ASSIGNED.
**          ASSIGN COMPONENT 'DISP_DTLS' OF STRUCTURE <fs_doc_data> TO FIELD-SYMBOL(<fs_buyer_dtls>).
**
**          ASSIGN COMPONENT 'NM' OF STRUCTURE <fs_buyer_dtls> TO FIELD-SYMBOL(<addr>).
**          IF <addr> IS ASSIGNED.
**            <addr> = ls_address-OrganizationName1.
**          ENDIF.
**
**
**          ASSIGN COMPONENT 'ADDR1' OF STRUCTURE <fs_buyer_dtls> TO FIELD-SYMBOL(<addr1>).
**          IF <addr1> IS ASSIGNED.
**            <addr1> = ls_address-StreetName.
**          ENDIF.
**
**
**          ASSIGN COMPONENT 'ADDR2' OF STRUCTURE <fs_buyer_dtls> TO FIELD-SYMBOL(<addr2>).
**          IF <addr2> IS ASSIGNED.
**            <addr2> = ls_address-CityName.
**          ENDIF.
**
**
**          ASSIGN COMPONENT 'LOC' OF STRUCTURE <fs_buyer_dtls> TO FIELD-SYMBOL(<addr3>).
**          IF <addr3> IS ASSIGNED.
**            <addr3> = ls_address-CityName.
**          ENDIF.
**
**
**          ASSIGN COMPONENT 'PIN' OF STRUCTURE <fs_buyer_dtls> TO FIELD-SYMBOL(<addr4>).
**          IF <addr4> IS ASSIGNED.
**            <addr4> = ls_address-PostalCode.
**          ENDIF.
**
**
**          ASSIGN COMPONENT 'STCD' OF STRUCTURE <fs_buyer_dtls> TO FIELD-SYMBOL(<addr5>).
**          IF <addr5> IS ASSIGNED.
**            <addr5> = ls_address-Statecode.
**          ENDIF.
**        ENDIF.
**      ENDIF.
**    ENDIF.
  ENDMETHOD.
ENDCLASS.
