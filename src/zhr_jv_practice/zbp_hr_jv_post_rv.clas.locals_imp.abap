CLASS lhc_zhr_jv_post_rv DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zhr_jv_post_rv RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zhr_jv_post_rv RESULT result.

    METHODS postgi FOR MODIFY
      IMPORTING keys FOR ACTION zhr_jv_post_rv~postgi RESULT result.

    METHODS getdata1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR zhr_jv_post_rv~getdata1.

ENDCLASS.

CLASS lhc_zhr_jv_post_rv IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD postgi.
  ENDMETHOD.

  METHOD getdata1.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zhr_jv_post1_rv DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zhr_jv_post1_rv RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zhr_jv_post1_rv RESULT result.

    METHODS postgm FOR MODIFY
      IMPORTING keys FOR ACTION zhr_jv_post1_rv~postgm RESULT result.

ENDCLASS.

CLASS lhc_zhr_jv_post1_rv IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD postgm.
  ENDMETHOD.

ENDCLASS.
