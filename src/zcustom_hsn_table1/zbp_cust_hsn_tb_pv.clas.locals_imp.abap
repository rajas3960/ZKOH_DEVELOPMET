CLASS lhc_zcust_hsn_tb_pv DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcust_hsn_tb_pv RESULT result.

ENDCLASS.

CLASS lhc_zcust_hsn_tb_pv IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
