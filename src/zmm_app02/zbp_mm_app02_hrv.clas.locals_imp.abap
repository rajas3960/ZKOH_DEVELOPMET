CLASS lhc__hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _hdr RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR _hdr RESULT result.

    METHODS upexl FOR MODIFY
      IMPORTING keys FOR ACTION _hdr~upexl .

ENDCLASS.

CLASS lhc__hdr IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD upexl.
READ  ENTITY  zmm_app02_hrv
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT data(lt_hdr).
data: lt_listing_create TYPE TABLE FOR CREATE zmm_app02_hrv.
**********************************************************************
Types : BEGIN OF ty_excel,
        matnr type matnr,
        hsn  type c lenGTH 16,
        tax type p LENGTH 15 DECIMALS 0,
        eND OF ty_EXCEL.
**********************************************************************
data : lt_excel type table of ty_EXCEL,
         lo_table_desc  TYPE REF TO cl_abap_tabledescr,
           lo_struc_descr TYPE REF TO cl_abap_structdescr.
  DATA(lv_attach) = keys[ 1 ]-%param-_streamproperties-zattachment.
    IF lv_attach IS NOT INITIAL.
      DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attach )->read_access(  ).
      DATA(lo_worksheet) = lo_xlsx->get_workbook(  )->worksheet->at_position( 1 ).
      DATA(lo_select_patrn) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(  )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 ) )->get_pattern(   ).
      DATA(lo_execute) = lo_worksheet->select( lo_select_patrn )->row_stream(  )->operation->write_to( REF #( lt_excel ) ).
      lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value  )->if_xco_xlsx_ra_operation~execute(  ).
    ENDIF.
    TRY .
        lo_table_desc ?= cl_abap_tabledescr=>describe_by_data( p_data = lt_excel ).
        lo_struc_descr ?= lo_table_desc->get_table_line_type(  ).
        DATA(lv_no_of_cols) = lines( lo_struc_descr->components ).
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    DATA(ls_excel) = VALUE #( lt_excel[ 1 ] OPTIONAL ).
    DELETE lt_excel WHERE matnr IS INITIAL.

    DATA lv_short_time_stamp TYPE timestamp.
DATA lv_long_time_stamp TYPE timestampl.

GET TIME STAMP FIELD lv_short_time_stamp.
GET TIME STAMP FIELD lv_long_time_stamp.

zbp_mm_app02_hrv=>gt_hdr = value #( FOR ls in lt_excel ( matnr = ls-matnr
hsn = ls-hsn
tax = ls-tax
createdby = sy-uname
createdon = lv_long_time_stamp
lastchngat = lv_long_time_stamp
lastchngby = sy-uname
) ).

lt_listing_create = CORRESPONDING #( zbp_mm_app02_hrv=>gt_hdr ).


MODIFY ENTITIES OF zmm_app02_hrv IN LOCAL MODE
           ENTITY _hdr
           CREATE AUTO FILL CID FIELDS ( Matnr Status Tax Lastchngby Lastchngat Hsn Createdby Createdon )
           WITH lt_listing_create
           " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED DATA(lt_mapped)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(lt_reported)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED DATA(lt_failed).


  ENDMETHOD.


ENDCLASS.

*CLASS lsc_ZMM_APP02_HRV DEFINITION INHERITING FROM cl_abap_behavior_saver.
*  PROTECTED SECTION.
*
*    METHODS save_modified REDEFINITION.
*
*    METHODS cleanup_finalize REDEFINITION.
*
*ENDCLASS.
*
*CLASS lsc_ZMM_APP02_HRV IMPLEMENTATION.
*
*  METHOD save_modified.
* if zbp_mm_app02_hrv=>gt_hdr is not inITIAL.
* modify zmm_app02_tb from table @zbp_mm_app02_hrv=>gt_hdr.
* endif.
*  ENDMETHOD.
*
*  METHOD cleanup_finalize.
*  ENDMETHOD.
*
*ENDCLASS.
