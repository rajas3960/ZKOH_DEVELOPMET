CLASS lhc__item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS gtdata FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~gtdata.

ENDCLASS.

CLASS lhc__item IMPLEMENTATION.

  METHOD gtdata.
**********************************************************************
    DATA : gsdata TYPE zmm_app01_itb1.
    data : gsdata2 type zmm_app01_itb2.
    READ ENTITIES OF zmm_app01_rv IN LOCAL MODE ENTITY _item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).
**********************************************************************
*    read ENTITY ZMM_APP01_rv
*    BY \_item
*    ALL FIELDS WITH CORRESPONDING #( keys )
*    RESULT data(lt_item).
**********************************************************************
    DATA(ls_result) = lt_result[ 1 ].

    MOVE-CORRESPONDING ls_result TO gsdata.
    gsdata-lastchngat = sy-datum.
    gsdata-lastchngby = sy-uname.
    gsdata-changetime = sy-timlo.

    APPEND gsdata TO zbp_mm_app01_rv=>gtdata2.
**********************************************************************
    lOop at lt_result into data(ls_item) .
    select single from zmm_app01_itb2 fields max( slno ) as slno
    where matnr = @ls_item-Matnr
    into @data(ls_no)  .
**********************************************************************
    if ls_no is not inITIAL.
    data(lv_sno) = ls_no + 1.
    else.
    lv_sno = 1.
    endif.
**********************************************************************
    gsdata2-uuid = ls_item-Suid.
     gsdata2-matnr = ls_item-Matnr.
      gsdata2-slno = lv_sno.
      gsdata2-hsn = ls_item-Hsn.
      gsdata2-tax = ls_item-Tax.
       gsdata2-createdby = cl_abap_context_info=>get_user_description(  ).
        gsdata2-createdon = sy-datum.
        gsdata2-changetime = sy-timlo.
    APPEND gsdata2 to zbp_mm_app01_rv=>gtdata3.






    endLOOP.



  ENDMETHOD.

ENDCLASS.

CLASS lhc__hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _hdr RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR _hdr RESULT result.

    METHODS loadexcl FOR MODIFY
      IMPORTING keys FOR ACTION _hdr~loadexcl RESULT result.

    METHODS gtdata FOR DETERMINE ON SAVE
      IMPORTING keys FOR _hdr~gtdata.

ENDCLASS.

CLASS lhc__hdr IMPLEMENTATION.

  METHOD get_instance_features.

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
*  read ENTITIES OF zmm_app01_rv IN LOCAL MODE ENTITY _hdr ALL FIELDS WITH CORRESPONDING  result DATA(lt_hdr).
*  result = value#( )
  ENDMETHOD.

  METHOD loadexcl.
**********************************************************************
    TYPES : BEGIN OF ty_excel,
              matnr TYPE matnr,
              hsn   TYPE string,
              tax   TYPE string,
            END OF ty_excel.
    TYPES :  zchar18 TYPE c LENGTH 18.

    DATA : lt_excel       TYPE STANDARD TABLE OF ty_excel,
           lt_itd         TYPE TABLE OF zmm_app01_tb1,
           ls_itd         TYPE  zmm_app01_tb1,
           lo_table_desc  TYPE REF TO cl_abap_tabledescr,
           lo_struc_descr TYPE REF TO cl_abap_structdescr,
           lv_index       TYPE sy-index.
    FIELD-SYMBOLS : <lfs_col_header> TYPE any.
**********************************************************************
    READ ENTITIES OF zmm_app01_rv IN LOCAL MODE ENTITY _hdr ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_attac).
    DATA(ls_hdr) = lt_attac[ 1 ].
    DATA(lv_suid) = lt_attac[ 1 ]-suid.
    DATA(lv_attach) = lt_attac[ 1 ]-attachment.
    IF lv_attach IS NOT INITIAL.
      DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attach )->read_access(  ).
      DATA(lo_worksheet) = lo_xlsx->get_workbook(  )->worksheet->at_position( 1 ).
      DATA(lo_select_patrn) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(  )->get_pattern(  ).
      DATA(lo_execute) = lo_worksheet->select( lo_select_patrn )->row_stream(  )->operation->write_to( REF #( lt_excel ) ).
      lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value  )->if_xco_xlsx_ra_operation~execute(  ).
    ENDIF.

    TRY .
        lo_table_desc ?= cl_abap_tabledescr=>describe_by_data( p_data = lt_excel ).
        lo_struc_descr ?= lo_table_desc->get_table_line_type(  ).
        DATA(lv_no_of_cols) = lines( lo_struc_descr->components ).
      CATCH cx_sy_move_cast_error.

    ENDTRY.

*    DATA(ls_excel) = VALUE #( lt_excel[ 1 ] OPTIONAL ).
**********************************************************************
    DELETE lt_excel INDEX 1.


    zbp_mm_app01_rv=>gtdata2 = VALUE #( FOR ls IN lt_excel ( suid = lv_suid
    matnr =  CONV zchar18( |{ ls-matnr ALPHA = IN }| )
    hsn = ls-hsn
    tax = ls-tax
    createdby = sy-uname
    createdon = sy-datum
    lastchngby = sy-uname
    lastchngat = sy-datum
    changetime = sy-timlo
     ) ).
     zbp_mm_app01_rv=>gtdata3 = VALUE #( FOR ls IN lt_excel  ( uuid = lv_suid
    matnr =  CONV zchar18( |{ ls-matnr ALPHA = IN }| )
    slno = 1
    hsn = ls-hsn
    tax = ls-tax
    createdby = sy-uname
    createdon = sy-datum
    changetime = sy-timlo
     ) ).



    MOVE-CORRESPONDING ls_hdr TO ls_itd.
    ls_itd-status = 'Active'.
    APPEND ls_itd TO lt_itd.
    zbp_mm_app01_rv=>gtdata = lt_itd.


    result = VALUE #( FOR ls_ord IN lt_attac
                   ( %tky = ls_ord-%tky
                   %param = ls_ord ) ).


  ENDMETHOD.

  METHOD gtdata.
**********************************************************************
    DATA : gsdata TYPE zmm_app01_tb1.
    READ ENTITIES OF zmm_app01_rv IN LOCAL MODE ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).
    DATA(ls_result) = lt_result[ 1 ].

    MOVE-CORRESPONDING ls_result TO gsdata.
    gsdata-status = 'Inactive'.

    APPEND gsdata TO zbp_mm_app01_rv=>gtdata.
**********************************************************************



  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_app01_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app01_rv IMPLEMENTATION.

  METHOD save_modified.
    IF zbp_mm_app01_rv=>gtdata IS NOT INITIAL.
      MODIFY  zmm_app01_tb1 FROM TABLE @zbp_mm_app01_rv=>gtdata.
    ENDIF.
    IF zbp_mm_app01_rv=>gtdata2 IS NOT INITIAL.
      MODIFY  zmm_app01_itb1 FROM TABLE @zbp_mm_app01_rv=>gtdata2.
    ENDIF.
    if zbp_mm_app01_rv=>gtdata3 is not inITIAL.
      MODIFY  zmm_app01_itb2 FROM TABLE @zbp_mm_app01_rv=>gtdata3.
    endif.
    IF delete-_hdr IS NOT INITIAL.
      LOOP AT delete-_hdr INTO DATA(ls_dele).
*        DELETE FROM  zmm_app01_tb1   WHERE suid = @ls_dele-suid.
*        DELETE FROM zmm_app01_itb1 WHERE suid = @ls_dele-suid.
      select single * from zmm_app01_tb1 where suid = @ls_dele-Suid into @data(ls_hdr).
      if ls_hdr is not inITIAL.
      ls_hdr-deletion = 'X'.
      MODIFY zmm_app01_tb1 from @ls_hdr.
      endIF.


      ENDLOOP.
    ENDIF.
    IF delete-_item IS NOT INITIAL.
      LOOP AT delete-_item INTO DATA(lsi_dele).
*  DELETE FROM  zmm_app01_tb1   WHERE suid = @ls_dele-Suid.
*        DELETE FROM zmm_app01_itb1 WHERE suid = @lsi_dele-suid AND matnr = @lsi_dele-matnr.
    select single * from zmm_app01_itb1 where suid = @lsi_dele-Suid and matnr = @lsi_dele-Matnr into @data(ls_item).
    if ls_item is not inITIAL.
    ls_item-status = 'X'.
    modify zmm_app01_itb1 from @ls_item.
    endif.
*MODIFY zmm_app01_itb1
      ENDLOOP.
    ENDIF.


  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
