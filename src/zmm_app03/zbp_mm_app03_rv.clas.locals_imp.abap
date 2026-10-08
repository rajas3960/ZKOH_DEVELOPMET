CLASS lhc__hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _hdr RESULT result.

    METHODS upexl FOR MODIFY
      IMPORTING keys FOR ACTION _hdr~upexl RESULT result.
    METHODS gtdata FOR DETERMINE ON SAVE
      IMPORTING keys FOR _hdr~gtdata.
    METHODS vtron FOR VALIDATE ON SAVE
      IMPORTING keys FOR _hdr~vtron.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _hdr RESULT result.

ENDCLASS.

CLASS lhc__hdr IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD upexl.
    READ  ENTITIES OF zmm_app03_rv IN LOCAL MODE
    ENTITY _hdr

      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_hdr).
    DATA: lt_listing_create TYPE TABLE FOR CREATE zmm_app02_hrv.
    DATA: gs_hdr TYPE zmm_app03_tb.
    DATA: gs_item TYPE zmm_app03_itb.
    TYPES :  zchar18 TYPE c LENGTH 18.
**********************************************************************
    TYPES : BEGIN OF ty_excel,
              matnr TYPE matnr,
              hsn   TYPE c LENGTH 16,
              tax   TYPE p LENGTH 15 DECIMALS 0,
            END OF ty_EXCEL.
**********************************************************************
    DATA : lt_excel       TYPE TABLE OF ty_EXCEL,
           lo_table_desc  TYPE REF TO cl_abap_tabledescr,
           lo_struc_descr TYPE REF TO cl_abap_structdescr.
    DATA(lv_attach) = keys[ 1 ]-%param-_streamproperties-zattachment.
    IF lv_attach IS NOT INITIAL.
      DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attach )->read_access( ).
      DATA(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).
      DATA(lo_select_patrn) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(  )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 ) )->get_pattern(   ).
      DATA(lo_execute) = lo_worksheet->select( lo_select_patrn )->row_stream(  )->operation->write_to( REF #( lt_excel ) ).
      lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value )->if_xco_xlsx_ra_operation~execute( ).
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

*zbp_mm_app03_rv=>gt_hdr = value #( FOR ls in lt_excel INDEX INTO lv ( uuid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( )
*matnr = ls-matnr
*hsn = ls-hsn
*tax = ls-tax
*createdby = sy-uname
*createdon = lv_long_time_stamp
*lastchngat = lv_long_time_stamp
*lastchngby = sy-uname
*) ).
*    LOOP AT lt_excel INTO DATA(ls).
*      TRY.
*          gs_hdr-uuid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*        CATCH cx_uuid_error.
*      ENDTRY.
*      gs_hdr-matnr = CONV zchar18( |{ ls-matnr ALPHA = IN }| ).
*      gs_hdr-hsn = ls-hsn.
*      if ls-tax = 0 or ls-tax = 18 or ls-tax = 5.
*
*      gs_hdr-tax = ls-tax.
*      else.
*           APPEND new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text     = |Tax % wrong Maintain|
*      ) TO reported-%other.
*APPEND VALUE #( %cid = keys[ 1 ]-%cid ) TO failed-_hdr.
*      endif.
*      gs_hdr-createdby = sy-uname.
*      gs_hdr-createdon = lv_long_time_stamp.
*      gs_hdr-lastchngat = lv_long_time_stamp.
*      gs_hdr-lastchngby = sy-uname.
*
*
*
*
*      SELECT SINGLE matnr
*        FROM zmm_app03_tb as _hdr
*        WHERE matnr = @gs_hdr-matnr
*        INTO @DATA(ls_mat).
*
*      IF sy-subrc <> 0.
*
*      select single matnr from @lt_excel  as hd
*      where matnr = @ls-matnr
*      into @data(lsmat1).
*
*
*      if sy-subrc <> 0.
*
*
*        gs_item = CORRESPONDING #( gs_hdr ).
*        TRY.
*            gs_item-item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*          CATCH cx_uuid_error.
*        ENDTRY.
*
*
*
*        APPEND gs_item TO zbp_mm_app03_rv=>gt_item.
*        APPEND gs_hdr TO zbp_mm_app03_rv=>gt_hdr.
*
*        else.
*           APPEND new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text     = |Mateial is Already exits { sy-index }|
*      ) TO reported-%other.
*APPEND VALUE #( %cid = keys[ 1 ]-%cid ) TO failed-_hdr.
*endif.
*      ENDIF.
*
*
*      CLEAR gs_hdr.
*
*    ENDLOOP.
DATA: lv_prev_matnr TYPE matnr.

SORT lt_excel BY matnr.

LOOP AT lt_excel INTO DATA(ls).

* Generate Header UUID
  TRY.
      gs_hdr-uuid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
    CATCH cx_uuid_error.
  ENDTRY.

* Convert Material
  gs_hdr-matnr = CONV zchar18( |{ ls-matnr ALPHA = IN }| ).
  gs_hdr-hsn   = ls-hsn.

*-----------------------------
* Tax Validation
*-----------------------------
if ls-tax = 0 or ls-tax = 18 or ls-tax = 5.
    gs_hdr-tax = ls-tax.
  ELSE.

    APPEND new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = |Tax % is wrong for material code: { ls-matnr }|
          ) TO reported-%other.

    APPEND VALUE #( %cid = keys[ 1 ]-%cid ) TO failed-_hdr.

    CONTINUE.
  ENDIF.

*-----------------------------
* Duplicate Material in Excel
*-----------------------------
  IF lv_prev_matnr = ls-matnr.

    APPEND new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = |Material { ls-matnr } duplicated in Excel|
          ) TO reported-%other.

    APPEND VALUE #( %cid = keys[ 1 ]-%cid ) TO failed-_hdr.

    CONTINUE.
  ENDIF.

  lv_prev_matnr = ls-matnr.

*-----------------------------
* Created/Changed Fields
*-----------------------------
  gs_hdr-createdby  = sy-uname.
  gs_hdr-createdon  = lv_long_time_stamp.
  gs_hdr-lastchngat = lv_long_time_stamp.
  gs_hdr-lastchngby = sy-uname.

*-----------------------------
* Check Material Already Exists in DB
*-----------------------------
  SELECT SINGLE matnr
    FROM zmm_app03_tb
    WHERE matnr = @gs_hdr-matnr
    and status <> 'X'
    INTO @DATA(ls_mat).

  IF sy-subrc = 0.

    APPEND new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = |Material { ls-matnr } already exists in system|
          ) TO reported-%other.

    APPEND VALUE #( %cid = keys[ 1 ]-%cid ) TO failed-_hdr.

    CONTINUE.

  ENDIF.

*-----------------------------
* Create Item
*-----------------------------
  gs_item = CORRESPONDING #( gs_hdr ).

  TRY.
      gs_item-item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
    CATCH cx_uuid_error.
  ENDTRY.

*-----------------------------
* Append Data
*-----------------------------
  APPEND gs_item TO zbp_mm_app03_rv=>gt_item.
  APPEND gs_hdr  TO zbp_mm_app03_rv=>gt_hdr.

ENDLOOP.
    IF zbp_mm_app03_rv=>gt_hdr IS NOT INITIAL.
      lt_hdr = CORRESPONDING #( zbp_mm_app03_rv=>gt_hdr ).
      DATA(ls_hdr) = lt_hdr[ 1 ].
    ENDIF.

    result = VALUE #( FOR ls1 IN keys ( %cid   = ls1-%cid
                                        %param = ls_hdr
                      ) ).
  ENDMETHOD.

  METHOD gtdata.
**********************************************************************
    DATA: gs_hdr TYPE zmm_app03_tb.
    DATA : gs_item TYPE zmm_app03_itb.
    TYPES :  zchar18 TYPE c LENGTH 18.
    READ ENTITIES OF zmm_app03_rv IN LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr).
**********************************************************************
    DATA(ls_hdr) = lt_hdr[ 1 ].
**********************************************************************
    GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).

    MOVE-CORRESPONDING  ls_hdr TO gs_hdr.

    gs_hdr-matnr = CONV zchar18( |{ ls_hdr-matnr ALPHA = IN }| ).
    IF gs_hdr-createdby IS INITIAL OR gs_hdr-createdon IS INITIAL.
      gs_hdr-createdby = sy-uname.
      gs_hdr-createdon = ts.
    ENDIF.
    gs_hdr-lastchngat = ts.
    gs_hdr-lastchngby = sy-uname.
**********************************************************************



      gs_item = CORRESPONDING #( gs_hdr ).
      TRY.
          gs_item-item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).

        CATCH cx_uuid_error.


      ENDTRY.
      gs_item-createdby = sy-uname.
      gs_item-createdon = ts.
      APPEND gs_item TO zbp_mm_app03_rv=>gt_item.
      APPEND gs_hdr TO zbp_mm_app03_rv=>gt_hdr.





**********************************************************************
  ENDMETHOD.

  METHOD vtron.
    DATA : gs_item TYPE zmm_app03_itb.
    TYPES :  zchar18 TYPE c LENGTH 18.
    READ ENTITIES OF zmm_app03_rv IN LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr).
**********************************************************************
    DATA(ls_hdr) = lt_hdr[ 1 ].
    data(ls_matnr) = CONV zchar18( |{ ls_hdr-matnr ALPHA = IN }| ).
**********************************************************************
SELECT SINGLE matnr
  FROM zmm_app03_tb
  WHERE matnr = @ls_matnr
  INTO @data(lv_mat).

IF sy-subrc = 0 AND ls_hdr-uuid IS not inITIAL.

          DATA(lv_msg2) = |Material { ls_hdr-matnr } already exists|.
      APPEND VALUE #( %tky = ls_hdr-%tky )
                  TO failed-_hdr.

      APPEND VALUE #( %tky           = ls_hdr-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg2 )   )
             TO reported-_hdr.
endIF.

  ENDMETHOD.

  METHOD get_instance_features.
**********************************************************************
READ ENTITIES OF zmm_app03_rv IN LOCAL MODE
ENTITY _hdr
ALL FIELDS WITH CORRESPONDING #( keys )
RESULT data(lt_hdr).
**********************************************************************

result = VALUE #( FOR ls_data IN Lt_hdr
        (   %tky =  ls_data-%tky

    %action-Edit         =            COND #( WHEN ls_data-Status = 'X'
                                                    THEN
                                                     if_abap_behv=>fc-o-disabled
                                                    ELSE
                                                     if_abap_behv=>fc-o-enabled
     )
     %delete =             COND #( WHEN ls_data-Status = 'X'
                                                    THEN
                                                     if_abap_behv=>fc-o-disabled
                                                    ELSE
                                                     if_abap_behv=>fc-o-enabled )

     ) ).



**********************************************************************

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMM_APP03_RV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMM_APP03_RV IMPLEMENTATION.

  METHOD save_modified.
    IF zbp_mm_app03_rv=>gt_hdr IS NOT INITIAL.
      MODIFY zmm_app03_tb FROM TABLE @zbp_mm_app03_rv=>gt_hdr.
    ENDIF.
    IF zbp_mm_app03_rv=>gt_item IS NOT INITIAL.
      MODIFY zmm_app03_itb FROM TABLE @zbp_mm_app03_rv=>gt_item.
    ENDIF.
    IF delete-_hdr IS NOT INITIAL.
      LOOP AT delete-_hdr INTO DATA(ls_del).

      select single * from  zmm_app03_tb where uuid = @ls_del-Uuid into @data(ls_hd).
      ls_hd-status = 'X'.
      modify zmm_app03_tb from @ls_hd.
*       DELETE FROM zmm_app03_tb WHERE uuid = @ls_del-Uuid.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
