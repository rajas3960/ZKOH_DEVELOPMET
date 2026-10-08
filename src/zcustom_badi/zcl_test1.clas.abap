CLASS zcl_test1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_edoc_adaptor_cloud .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST1 IMPLEMENTATION.


  METHOD if_edoc_adaptor_cloud~change_edocument_type.

*TYPES : BEGIN OF TY_JEI,
*        FISCALYEAR TYPE CHAR4,
*        ACCDOC TYPE CHAR10,
*        END OF ty_JEI.
*
*  DATA : WA_JEI TYPE TY_JEI.
  SELECT SINGLE  FROM I_JournalEntry AS JEI FIELDS AbsoluteExchangeRate , AccountingDocCreatedByUser

  WHERE JEI~FiscalYear = '2024' INTO  @DATA(WA_JEI).

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
  ENDMETHOD.
ENDCLASS.
