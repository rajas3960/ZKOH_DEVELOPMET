CLASS lsc_zmm_mrp_rcv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_mrp_rcv IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-_header IS NOT INITIAL.
      IF zbp_mm_mrp_rcv=>gt_crdata IS NOT INITIAL.
        DATA(lt_hrdata) = zbp_mm_mrp_rcv=>gt_crdata.
        MODIFY zmm_mrp_tb1 FROM TABLE @lt_hrdata.
      ENDIF.
    ENDIF.
**********************************************************************
    IF zbp_mm_mrp_rcv=>gt_crtdata IS NOT INITIAL.
      DATA(lt_item) = zbp_mm_mrp_rcv=>gt_crtdata.
      MODIFY zmm_mrp_tb2 FROM TABLE @lt_item.
    ENDIF.
**********************************************************************
    IF update-_header IS NOT INITIAL.
      IF zbp_mm_mrp_rcv=>gt_crdata IS NOT INITIAL.
        DATA(lt_hrdata2) = zbp_mm_mrp_rcv=>gt_crdata.
        MODIFY zmm_mrp_tb1 FROM TABLE @lt_hrdata2.
      ENDIF.
    ENDIF.

*    if  zbp_mm_mrp_rcv=>gt_prrcupd is not INITIAL.
*     DATA(lt_item3) = zbp_mm_mrp_rcv=>gt_prrcupd.
*        MODIFY zmm_mrp_tb3 FROM TABLE @lt_item3.
*    endif.
**********************************************************************
    IF zbp_mm_mrp_rcv=>cv_pr_doc IS NOT INITIAL .
      LOOP AT zbp_mm_mrp_rcv=>cv_pr_doc-purchaserequisition ASSIGNING FIELD-SYMBOL(<fs_pr_mapped>).
        CONVERT KEY OF i_purchaserequisitiontp FROM <fs_pr_mapped>-%pid TO DATA(ls_pr_key).
        <fs_pr_mapped>-purchaserequisition = ls_pr_key-purchaserequisition.
      ENDLOOP.
**********************************************************************
      IF zbp_mm_mrp_rcv=>gt_prrcupd IS NOT INITIAL.
        DATA(lt_upd) =  zbp_mm_mrp_rcv=>gt_prrcupd.
        LOOP AT lt_upd ASSIGNING FIELD-SYMBOL(<fs_upd>).
          <fs_upd>-prnum = ls_pr_key-purchaserequisition.
        ENDLOOP.
        MODIFY zmm_mrp_tb3 FROM TABLE @lt_upd.
      ENDIF.

*      LOOP AT update-header INTO DATA(ls_hdrupd) WHERE %control-Status IS INITIAL.
*        UPDATE zmrpplan01_tb1 SET status = 'X',totprrec = @lv_lines, totprcrt = 1
*        WHERE recguid = @ls_hdrupd-Recguid.
*
*      ENDLOOP.
    ENDIF.
**********************************************************************
    IF zbp_mm_mrp_rcv=>cv_sto_doc IS NOT INITIAL.
      LOOP AT zbp_mm_mrp_rcv=>cv_sto_doc-purchaseorder ASSIGNING FIELD-SYMBOL(<fs_sto_mapped>).
        CONVERT KEY OF i_purchaseordertp_2 FROM <fs_sto_mapped>-%pid TO DATA(ls_sto_key).
        <fs_sto_mapped>-purchaseorder = ls_sto_key-purchaseorder.
      ENDLOOP.
    ENDIF.
**********************************************************************
*      IF zbp_mm_mrp_rcv=>gt_prrcupd IS NOT INITIAL.
*        DATA(lt_upd2) =  zbp_mm_mrp_rcv=>gt_prrcupd.
*        LOOP AT lt_upd2 ASSIGNING FIELD-SYMBOL(<fs_upd2>).
*          <fs_upd2>-prnum = ls_sto_key-PurchaseOrder.
*        ENDLOOP.
*        MODIFY zmm_mrp_tb3 FROM TABLE @lt_upd2.
*      ENDIF.
*    ENDIF.
***********************************************************************
*    IF zbp_mm_mrp_rcv=>gt_prrcupd IS NOT INITIAL.
*      DATA(lt_prupd) = zbp_mm_mrp_rcv=>gt_prrcupd.
*      MODIFY zmm_mrp_tb3 FROM TABLE @lt_prupd.
*    ENDIF.

**********************************************************************
*************** Delete Root entity records ***************************
    IF delete-_header IS NOT INITIAL.
      LOOP AT delete-_header INTO DATA(ls_grdel).
        DELETE FROM zmm_mrp_tb1 WHERE recguid = @ls_grdel-recguid.
      ENDLOOP.
    ENDIF.
**********************************************************************


  ENDMETHOD.
  METHOD cleanup_finalize.

  ENDMETHOD.

ENDCLASS.
CLASS lhc__header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _header RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR _header RESULT result.

    METHODS crtpo FOR MODIFY
      IMPORTING keys FOR ACTION _header~crtpo RESULT result.

    METHODS crtpr FOR MODIFY
      IMPORTING keys FOR ACTION _header~crtpr RESULT result.

    METHODS loadexcel FOR MODIFY
      IMPORTING keys FOR ACTION _header~loadexcel RESULT result.

    METHODS updpr FOR MODIFY
      IMPORTING keys FOR ACTION _header~updpr RESULT result.

    METHODS getdata2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _header~getdata2.

    METHODS getdata FOR DETERMINE ON SAVE
      IMPORTING keys FOR _header~getdata.

    METHODS ondata FOR DETERMINE ON SAVE
      IMPORTING keys FOR _header~ondata.

ENDCLASS.






CLASS lhc__header IMPLEMENTATION.

  METHOD get_instance_features.

*  READ ENTITIES OF zmm_mrp_rcv IN LOCAL MODE
*      ENTITY _Header
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_status).
*
*    result = VALUE #( FOR ls_data IN lt_status
*      ( %tky =  ls_data-%tky
*        %features-%action-Edit = COND #( WHEN ls_data-status EQ 'X'
*                                            THEN if_abap_behv=>fc-o-disabled
*                                            ELSE if_abap_behv=>fc-o-enabled
*         )
*
*        %action = VALUE #( CrtPr = COND #( WHEN ls_data-status EQ 'X'
*                                            THEN if_abap_behv=>fc-o-disabled
*                                            ELSE if_abap_behv=>fc-o-enabled
*         ) )
*
*        %features-%update = COND #( WHEN ls_data-status EQ 'X'
*                                            THEN if_abap_behv=>fc-o-disabled
*                                            ELSE if_abap_behv=>fc-o-enabled
*         )
*
*          ) ).




  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD crtpo.

    DATA: lt_prrecd TYPE TABLE OF zmm_mrp_tb3,
          ls_prrecd TYPE zmm_mrp_tb3,
          lt_prupd  TYPE TABLE OF zmm_mrp_tb1,
          ls_prupd  TYPE zmm_mrp_tb1.
    DATA: lv_lines TYPE i.

    DATA(lv_cid) = 'CID_'.
    DATA(lv_hcid) = 1.
    DATA(lv_lcid) = 'CIDL_'.

    READ ENTITIES OF zmm_mrp_rcv IN LOCAL MODE
    ENTITY _header

    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr)
    ENTITY _header BY \_items
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_litem).

    IF lt_litem IS NOT INITIAL.
      DATA(lt_stodata) = lt_litem.
      DELETE lt_stodata WHERE supplnt IS INITIAL.


      IF lt_stodata IS NOT INITIAL.
*      TYPES: tt_purorder_items_create TYPE TABLE FOR CREATE i_purchaseordertp_2\_purchaseorderitem,
*             ty_purorder_items_create TYPE LINE OF tt_purorder_items_create.
*      TYPES: tt_item_schd_line_create TYPE TABLE FOR CREATE I_PurchaseOrderItemTP_2\_PurchaseOrderScheduleLineTP,
*             ty_item_schd_line_create TYPE LINE OF tt_item_schd_line_create.

        DATA: lt_stoline TYPE TABLE OF zmm_mrp_st1,
              ls_stoline TYPE zmm_mrp_st1.
*            lt_stoitm  TYPE tt_purorder_items_create,
*            ls_stoitm  TYPE ty_purorder_items_create.

        LOOP AT lt_stodata INTO DATA(ls_line).
          MOVE-CORRESPONDING ls_line TO ls_stoline.
          ls_stoline-litem += 10.
          APPEND ls_stoline TO lt_stoline.
        ENDLOOP.

*        LOOP AT lt_stoline INTO DATA(ls_sline).
*          ls_stoitm = VALUE #(  %cid_ref = 'PO_H1'
*                                                        %target  = VALUE #( ( %cid                = 'POI' && ls_sline-sno
*                                                                             plant                = ls_sline-plant
*                                                                             orderquantity        = ls_sline-reqqty
*                                                                             BaseUnit             = ls_sline-uom
*                                                                             purchaseorderitem    = ls_sline-litem
*                                                                             Material             = ls_sline-material
*                                                                             StorageLocation      = ls_sline-sloc
*                                                                             IssuingStorageLocation = ls_sline-issloc
*                                                         %control = VALUE #( plant                = cl_abap_behv=>flag_changed
*                                                                             orderquantity        = cl_abap_behv=>flag_changed
*                                                                             purchaseorderitem    = cl_abap_behv=>flag_changed
*                                                                             Material             = cl_abap_behv=>flag_changed
*                                                                             BaseUnit             = cl_abap_behv=>flag_changed
*                                                                             StorageLocation      = cl_abap_behv=>flag_changed
*                                                                             IssuingStorageLocation = cl_abap_behv=>flag_changed
*                                                                                  ) ) ) ).
*          APPEND ls_stoitm TO lt_stoitm.
*        ENDLOOP.

        MODIFY ENTITIES OF i_purchaseordertp_2
        ENTITY purchaseorder
        CREATE FIELDS ( purchaseordertype
                                       )
        WITH VALUE #(                            ( %cid              = 'PO_H1'
                                                   purchaseordertype = 'ZITR'
*                        CompanyCode            = '5000'
                                                   supplyingplant    = VALUE #( lt_stoline[ 1 ]-supplnt )
                      ) )
       CREATE BY \_purchaseorderitem
       FIELDS ( plant orderquantity baseunit material purchaseorderitem issuingstoragelocation storagelocation )
       WITH VALUE #(                             ( %cid_ref          = 'PO_H1'
                                                   %target           = VALUE #( FOR ls_sline IN lt_stoline
                                                                                ( %cid                      = 'POI' && ls_sline-sno
                                                                                  plant                     = ls_sline-plant
                                                                                  orderquantity             = ls_sline-reqqty
                                                                                  baseunit                  = ls_sline-uom
                                                                                  purchaseorderitem         = ls_sline-litem
                                                                                  material                  = ls_sline-material
                                                                                  storagelocation           = ls_sline-sloc
*                                     IssuingStorageLocation = ls_sline-issloc
                                                                                  %control                  = VALUE #(
                                                            plant                     = cl_abap_behv=>flag_changed
                                                            orderquantity             = cl_abap_behv=>flag_changed
                                                            purchaseorderitem         = cl_abap_behv=>flag_changed
                                                            material                  = cl_abap_behv=>flag_changed
                                                            baseunit                  = cl_abap_behv=>flag_changed
                                                            storagelocation           = cl_abap_behv=>flag_changed
*                                     IssuingStorageLocation = cl_abap_behv=>flag_changed
                                                            ) ) ) ) )
       ENTITY purchaseorderitem
       CREATE BY \_purchaseorderschedulelinetp
       FIELDS ( scheduleline schedulelinedeliverydate purchaseorderitem schedulelineorderquantity )
       WITH VALUE #( FOR ls_shline IN lt_stoline ( %cid_ref          = 'POI' && ls_shline-sno
                                                   %target           = VALUE #( (
                                                                                  %cid                      = 'SHI_' && ls_shline-sno
                                                                                  schedulelineorderquantity = ls_shline-reqqty
                                                                                  schedulelinedeliverydate  = ls_shline-delvdat
                                                                                  scheduleline              = '0001'
                                                                                  purchaseorderitem         = ls_shline-litem
                                                                                  %control                  = VALUE #(
                                                            schedulelineorderquantity = cl_abap_behv=>flag_changed
                                                            schedulelinedeliverydate  = cl_abap_behv=>flag_changed
                                                            scheduleline              = cl_abap_behv=>flag_changed
                                                            purchaseorderitem         = cl_abap_behv=>flag_changed
                                                            ) ) ) ) )
       REPORTED DATA(ls_sto_reported)
       FAILED   DATA(ls_sto_failed)
       MAPPED   DATA(ls_sto_mapped).

        IF ls_sto_failed IS INITIAL.
          zbp_mm_mrp_rcv=>cv_sto_doc-purchaseorder = ls_sto_mapped-purchaseorder.
          LOOP AT lt_stodata INTO DATA(lw_stodata).
            ls_prrecd-recguid = lw_stodata-recguid.
            ls_prrecd-prnum = 1.
            ls_prrecd-pritm += 10.
            ls_prrecd-plant = lw_stodata-plant.
            ls_prrecd-delvdat = lw_stodata-delvdat.
            ls_prrecd-doctyp = 'ZITR'.
            ls_prrecd-matdesc = lw_stodata-matdesc.
            ls_prrecd-material = lw_stodata-material.
            ls_prrecd-reqqty = lw_stodata-reqqty.
            ls_prrecd-sloc = lw_stodata-sloc.
            ls_prrecd-uom = lw_stodata-uom.
            APPEND ls_prrecd TO lt_prrecd.
          ENDLOOP.
          zbp_mm_mrp_rcv=>gt_prrcupd = lt_prrecd.
          lv_lines =  lines( lt_prrecd ).
          DATA(ls_hdr2) = lt_hdr[ 1 ].
          MOVE-CORRESPONDING ls_hdr2 TO ls_prupd.
          ls_prupd-status = 'X'.
          ls_prupd-totpocrt = 1.
          ls_prupd-totporec = lv_lines.
          APPEND ls_prupd TO lt_prupd.
          zbp_mm_mrp_rcv=>gt_crdata = lt_prupd.
        ENDIF.
      ENDIF.

    ELSE.

    ENDIF.

    result = VALUE #( FOR ls_ord IN lt_hdr
                      ( %tky   = ls_ord-%tky
                        %param = ls_ord ) ).



  ENDMETHOD.

  METHOD crtpr.

    DATA: lt_prrecd TYPE TABLE OF zmm_mrp_tb3,
          ls_prrecd TYPE zmm_mrp_tb3,
          lt_prupd  TYPE TABLE OF zmm_mrp_tb1,
          ls_prupd  TYPE zmm_mrp_tb1.
    DATA: lv_lines TYPE i.

    DATA(lv_cid) = 'CID_'.
    DATA(lv_hcid) = 1.
    DATA(lv_lcid) = 'CIDL_'.
**********************************************************************
    READ ENTITIES OF zmm_mrp_rcv IN LOCAL MODE
    ENTITY _header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr)
    ENTITY _header BY \_items
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_litem).
    DATA(ls_hdr) = lt_hdr[ 1 ].
    IF lt_litem IS NOT INITIAL.
      DATA(lt_prdata) = lt_litem.
      DATA(lt_stodata) = lt_litem.
*      DELETE lt_prdata WHERE Supplnt  IS NOT INITIAL.
*    DELETE lt_stodata WHERE Supplnt IS INITIAL.
      IF lt_prdata IS NOT INITIAL.
**********************************************************************
*****          Replace Commercial UOM with SAP UOM             *******
**********************************************************************
        DATA(lt_prdata_t) = lt_prdata.
        SORT lt_prdata_t BY uom.
        DELETE ADJACENT DUPLICATES FROM lt_prdata_t COMPARING uom.

        SELECT s~uom AS suom,i~unitofmeasure AS auom,i~unitofmeasure_e AS cuom
               FROM @lt_prdata_t AS s
               INNER JOIN i_unitofmeasure AS i ON s~uom = i~unitofmeasure_e
               INTO TABLE @DATA(lt_uom)
               ##db_feature_mode[itabs_in_from_clause].
        LOOP AT lt_prdata ASSIGNING FIELD-SYMBOL(<fs_prdata>).
          TRY.
              DATA(ls_uom) = lt_uom[ cuom = <fs_prdata>-uom ].
              <fs_prdata>-uom = ls_uom-auom.

            CATCH cx_sy_itab_line_not_found.
              DATA(ls_err) = 'A'.
          ENDTRY.
        ENDLOOP.
**********************************************************************
        TRY.
            MODIFY ENTITIES OF i_purchaserequisitiontp
            PRIVILEGED
            ENTITY purchaserequisition
                 CREATE FIELDS ( purchaserequisitiontype )
                 WITH VALUE #( ( %cid                    = lv_cid && lv_hcid
                                 purchaserequisitiontype = ls_hdr-doctype
                                 sourcedetermination     = 'X' ) )         " ls_hdr-Srcdtm

                CREATE BY \_purchaserequisitionitem
                FIELDS ( plant
                         requestedquantity
                         baseunit
                         material
                         deliverydate
                         supplyingplant
                         purchaserequisitionprice
                         performanceperiodstartdate
                         performanceperiodenddate
                         accountassignmentcategory
                         taxcode
                         PurchaseOrderPriceType

                             )


                WITH VALUE #(
                               ( %cid_ref                = lv_cid && lv_hcid
                                 %target                 = VALUE #( FOR ls_litm IN lt_prdata
                                                  ( %cid                       = 'ITM_' && ls_litm-sno
                                                    plant                      = ls_litm-plant
                                                    requestedquantity          = ls_litm-reqqty
                                                    baseunit                   = ls_litm-uom
                                                    material                   = ls_litm-material
                                                    deliverydate               = ls_litm-delvdat
                                                    supplyingplant             = ls_litm-supplnt
                                                    purchaserequisitionprice   = ls_litm-price
                                                    performanceperiodstartdate = ls_litm-serstdt
                                                    performanceperiodenddate   = ls_litm-serenddt
                                                    accountassignmentcategory  = ls_litm-accasscat
                                                    taxcode                    = ls_litm-taxcd
                                                    PurchaseOrderPriceType     = 2


                                                  ) ) ) )

            ENTITY purchaserequisitionitem
            CREATE BY \_purchasereqnacctassgmt
            FIELDS (
                     glaccount
                     quantity
                     baseunit
                     WBSElementExternalID


                     )
            WITH VALUE #( FOR ls_lacct IN lt_prdata
                               (
                                 %cid_ref                = 'ITM_' && ls_lacct-sno
                                 %target                 = VALUE #(
                                                  (
                                                    %cid                       = 'ACT_' && ls_lacct-sno
                                                    glaccount                  = |{ ls_lacct-expgl ALPHA = IN }|
                                                    quantity                   = ls_lacct-reqqty
                                                    baseunit                   = ls_lacct-uom
                                                    WBSElementExternalID       = ls_lacct-Wbsid

                                             ) )

                          ) )

            REPORTED DATA(ls_reported)
              MAPPED DATA(ls_mapped)
              FAILED DATA(ls_failed).
*          COMMIT ENTITIES.
*          CATCH cl_abap_behv INTO DATA(lc_exception).
          CATCH cx_root INTO DATA(lx_exception).
            DATA(lv_msg) = '040'.
        ENDTRY.

        IF ls_failed IS INITIAL.
          zbp_mm_mrp_rcv=>cv_pr_doc-purchaserequisition = ls_mapped-purchaserequisition.
**********************************************************************
          LOOP AT lt_prdata INTO DATA(lw_prdata).

            ls_prrecd-recguid     = lw_prdata-recguid.
*  ls_prrecd-prnum       = lw_prdata-prnum.
*  ls_prrecd-pritm       = lw_prdata-pritm.
*  ls_prrecd-ptyg        = lw_prdata-ptyg.
*  ls_prrecd-aactg       = lw_prdata-aactg.
* ls_prrecd-pwbsid      = lw_prdata-Wbsid.
*            ls_prrecd-plant       = lw_prdata-plant.
*  ls_prrecd-pgroup      = lw_prdata-pgroup.
*  ls_prrecd-mserv       = lw_prdata-mserv.
            ls_prrecd-material    = lw_prdata-material.
            ls_prrecd-matdesc     = lw_prdata-matdesc.
            ls_prrecd-reqqty      = lw_prdata-reqqty.
            ls_prrecd-uom         = lw_prdata-uom.
            ls_prrecd-supplnt     = lw_prdata-supplnt.
            ls_prrecd-delvdat     = lw_prdata-delvdat.
*  ls_prrecd-sstart      = lw_prdata-sstart.
*  ls_prrecd-send        = lw_prdata-send.
*  ls_prrecd-taxcode     = lw_prdata-taxcode.
            ls_prrecd-sloc        = lw_prdata-sloc.
            ls_prrecd-issloc      = lw_prdata-issloc.
*  ls_prrecd-doctyp      = lw_prdata-doctyp.
            ls_prrecd-price       = lw_prdata-price.
*  ls_prrecd-expgl       = lw_prdata-expgl.
*  ls_prrecd-litem       = lw_prdata-litem .


            APPEND ls_prrecd TO lt_prrecd.
          ENDLOOP.
          zbp_mm_mrp_rcv=>gt_prrcupd = lt_prrecd.
          lv_lines =  lines( lt_prrecd ).
          DATA(ls_hdr1) = lt_hdr[ 1 ].
          MOVE-CORRESPONDING ls_hdr1 TO ls_prupd.
          ls_prupd-status = 'X'.
          ls_prupd-totprcrt = 1.
          ls_prupd-totprrec = lv_lines.
          ls_prupd-doctype = ls_hdr-doctype.
          ls_prupd-dtyptxt = ls_hdr-dtyptxt.
          ls_prupd-srcdtm =  ls_hdr-srcdtm.
          APPEND ls_prupd TO lt_prupd.
          zbp_mm_mrp_rcv=>gt_crdata = lt_prupd.


        ENDIF.
      ENDIF.


    ELSE.

    ENDIF.


*  ENTITY purchaserequisitionitem

*  CREATE BY \_purchasereqnacctassgmt
*         FIELDS ( costcenter
*                  glaccount
*                  quantity
*                  baseunit )
*         WITH VALUE #(
*                        ( %cid_ref = 'My%ItemCID_1'
*                          %target  = VALUE #( ( %cid        = 'My%acctCID_1'
*                                                costcenter  = 'ABC'
*                                                glaccount   = '1234567890'
*                                                quantity    = '3.00'
*                                                baseunit    = 'EA' )
*
*                                              ( %cid        = 'My%acctCID_2'
*                                                costcenter  = 'DEF'
*                                                glaccount   = '1234567890'
*                                                quantity    = '7.00'
*                                                baseunit    = 'EA' )   ) ) )
*  CREATE BY \_purchasereqndelivaddress
*         FIELDS ( businesspartnername1
*                  businesspartnername2
*                  country
*                  Region
*                  PostalCode )
*         WITH VALUE #(
*                        ( %cid_ref = 'My%ItemCID_1'
*                           %target = VALUE #( (%cid        = 'My%addrCID_1'
*                                               businesspartnername1 = 'Name1'
*                                               businesspartnername2 = 'Name2'
*                                               country = 'AA'
*                                               Region  = '11'
*                                               PostalCode = '11111' ) ) ) )
*  CREATE BY \_purchasereqnitemtext
*        FIELDS ( plainlongtext )
*        WITH VALUE #(
*                      (    %cid_ref = 'My%ItemCID_1'
*                           %target = VALUE #(
*                                            (  %cid        = 'My%textCID_1'
*                                               textobjecttype              = 'B01'
*                                               language                    = 'E'
*                                               plainlongtext               = 'item text 1'
*                                              )
*                                            (  %cid        = 'My%textCID_2'
*                                               textobjecttype              = 'B02'
*                                               language                    = 'E'
*                                               plainlongtext               = 'item text 2'
*                                              )
*
*                                            )
*                       )
*                     )

    READ ENTITIES OF zmm_mrp_rcv IN LOCAL MODE
        ENTITY _header
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_hdr2)
        ENTITY pritem
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_pritm).

    result = VALUE #( FOR ls_ord IN lt_hdr2
                      ( %tky   = ls_ord-%tky
                        %param = ls_ord ) ).

  ENDMETHOD.

  METHOD loadexcel.
    TYPES : BEGIN OF ty_excel,
              sno       TYPE string,
              plant     TYPE string,
              material  TYPE string,
              matdesc   TYPE string,
              reqqty    TYPE string,
              uom       TYPE string,
              delvdat   TYPE string,
              price     TYPE string,
              curr      TYPE string,
              accasscat TYPE string,
              wbsid     TYPE string,
              purgrp    TYPE string,
              serstdt   TYPE string,
              serenddt  TYPE string,
              taxcd     TYPE string,
              popricetp TYPE string,
              expgl     TYPE string,
              sloc      TYPE string,
              supplnt   TYPE string,
              issloc    TYPE string,

            END OF ty_excel.
    TYPES :  zchar18 TYPE c LENGTH 18.
    DATA : lt_excel       TYPE STANDARD TABLE OF ty_excel,
           lt_itd         TYPE TABLE OF zmm_mrp_tb1,
           ls_itd         TYPE  zmm_mrp_tb1,
           lo_table_desc  TYPE REF TO cl_abap_tabledescr,
           lo_struc_descr TYPE REF TO cl_abap_structdescr,
           lv_index       TYPE sy-index.

    FIELD-SYMBOLS : <lfs_col_header> TYPE any.

    READ ENTITIES OF zmm_mrp_rcv IN LOCAL MODE ENTITY _header ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_attac).

    DATA(ls_hdr) = lt_attac[ 1 ].
    DATA(lv_suid) = lt_attac[ 1 ]-recguid.
    DATA(lv_attach) = lt_attac[ 1 ]-attachment.

    IF lv_attach IS NOT INITIAL.

      DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attach )->read_access( ).
      DATA(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).
      DATA(lo_select_patrn) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).
      DATA(lo_execute) = lo_worksheet->select( lo_select_patrn )->row_stream(  )->operation->write_to( REF #( lt_excel ) ).
      lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value )->if_xco_xlsx_ra_operation~execute( ).

    ENDIF.


    TRY .
        lo_table_desc ?= cl_abap_tabledescr=>describe_by_data( p_data = lt_excel ).
        lo_struc_descr ?= lo_table_desc->get_table_line_type(  ).
        DATA(lv_no_of_cols) = lines( lo_struc_descr->components ).
      CATCH cx_sy_move_cast_error.

    ENDTRY.


    DELETE lt_excel INDEX 1.
*  delete lt_excel where sno is INITIAL.

    zbp_mm_mrp_rcv=>gt_crtdata = VALUE #( FOR ls IN lt_excel ( recguid   = lv_suid

                                                               sno       = ls-sno
                                                               plant     = ls-plant
                                                               material  = ls-material
                                                               matdesc   = ls-matdesc
                                                               reqqty    = ls-reqqty
                                                               uom       = ls-uom
                                                               delvdat   = ls-delvdat
                                                               price     = ls-price
                                                               curr      = ls-curr
                                                               accasscat = ls-accasscat
                                                               wbsid     = ls-wbsid
                                                               purgrp    = ls-purgrp
                                                               serstdt   = ls-serstdt
                                                               serenddt  = ls-serenddt
                                                               taxcd     = ls-taxcd
                                                               popricetp = ls-popricetp
                                                               expgl     = ls-expgl
                                                               sloc      = ls-sloc
                                                               supplnt   = ls-supplnt
                                                               issloc    = ls-issloc
                                                               itmcid    = 'ICID_' && ls-sno
                                                               actcid    = 'ACID_' && ls-sno


                                          ) ).

*modify ENTITIES OF zmm_mrp_icv1  entity sno plant create from

    MOVE-CORRESPONDING ls_hdr TO ls_itd.
    ls_itd-status = 'Active'.
    APPEND ls_itd TO lt_itd.
    zbp_mm_mrp_rcv=>gt_crdata = lt_itd.


    result = VALUE #( FOR ls_ord IN lt_attac
                      ( %tky   = ls_ord-%tky
                        %param = ls_ord ) ).

  ENDMETHOD.

  METHOD updpr.

    READ ENTITIES OF zmm_mrp_rcv IN LOCAL MODE
      ENTITY _header
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_hdr).
    DATA(ls_hdr) = lt_hdr[ 1 ].

    SELECT * FROM zmm_mrp_tb3
    WHERE recguid = @ls_hdr-recguid
    INTO TABLE @DATA(lt_prdata).
    IF lt_prdata IS NOT INITIAL.

    ENDIF.

**********************************************************************
    MODIFY ENTITIES OF i_purchaserequisitiontp
    PRIVILEGED
          ENTITY purchaserequisitionitem UPDATE
          SET FIELDS WITH VALUE #( FOR ls_prdata IN lt_prdata (
                                   purchaserequisition     = ls_prdata-prnum
                                   purchaserequisitionitem = ls_prdata-pritm
                                   deliverydate            = ls_prdata-delvdat


                                   ) ).


  ENDMETHOD.

  METHOD getdata2.

    DATA: lt_hdrdata TYPE TABLE OF zmm_mrp_tb1,
          ls_hdrdata TYPE zmm_mrp_tb1.
**********************************************************************
    READ ENTITIES OF zmm_mrp_rcv IN LOCAL MODE
    ENTITY _header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).
    DATA(ls_header)  = lt_header[ 1 ].

    ls_hdrdata-recguid = ls_header-recguid.
    ls_hdrdata-createdat = sy-datum.
    ls_hdrdata-createdby = sy-uname.
    ls_hdrdata-doctype = ls_header-doctype.
    ls_hdrdata-dtyptxt = ls_header-dtyptxt.
    APPEND ls_hdrdata TO lt_hdrdata.
**********************************************************************
    zbp_mm_mrp_rcv=>gt_crdata = lt_hdrdata.

  ENDMETHOD.

  METHOD getdata.

    DATA: lt_hdrdata TYPE TABLE OF zmm_mrp_tb1,
          ls_hdrdata TYPE zmm_mrp_tb1.
**********************************************************************
    READ ENTITIES OF zmm_mrp_rcv IN LOCAL MODE
    ENTITY _header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).
    DATA(ls_header)  = lt_header[ 1 ].
    TRY.
        DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
      CATCH cx_abap_context_info_error.
        DATA(ls_v) = 1.
    ENDTRY.
*
    TRY.
        DATA(lv_syuser) = cl_abap_context_info=>get_user_description( ).

      CATCH cx_abap_context_info_error.
        "handle exception
        DATA(lv_s) = 1.
    ENDTRY.

    ls_hdrdata-recguid = ls_header-recguid.
    ls_hdrdata-createdat = lv_sydate.
    ls_hdrdata-createdby = lv_syuser.
    ls_hdrdata-doctype = ls_header-doctype.
    ls_hdrdata-dtyptxt = ls_header-dtyptxt.
    ls_hdrdata-srcdtm = ls_header-srcdtm.
    APPEND ls_hdrdata TO lt_hdrdata.
**********************************************************************
    zbp_mm_mrp_rcv=>gt_crdata = lt_hdrdata.


  ENDMETHOD.

  METHOD ondata.
    DATA : gsdata TYPE zmm_mrp_tb1.
    READ ENTITIES OF zmm_mrp_rcv IN LOCAL MODE ENTITY _header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).
    DATA(ls_result) = lt_result[ 1 ].

    MOVE-CORRESPONDING ls_result TO gsdata.
    gsdata-status = 'Inactive'.

    APPEND gsdata TO zbp_mm_mrp_rcv=>gt_crdata.

  ENDMETHOD.

ENDCLASS.

**CLASS lsc_zmm_mrp_rcv DEFINITION INHERITING FROM cl_abap_behavior_saver.
**  PROTECTED SECTION.
**
**    METHODS save_modified REDEFINITION.
**
**    METHODS cleanup_finalize REDEFINITION.
**
**ENDCLASS.
*
*CLASS lsc_zmm_mrp_rcv IMPLEMENTATION.
*
*  METHOD save_modified.
*
*  IF create-header IS NOT INITIAL.
*      IF zbp_mm_mrp_rcv=>gt_hdrdata IS NOT INITIAL.
*        DATA(lt_hrdata) = zbp_mm_mrp_rcv=>gt_hdrdata.
*        MODIFY zmm_mrp_tb1 FROM TABLE @lt_hrdata.
*      ENDIF.
*    ENDIF.
***********************************************************************
*    IF update-header IS NOT INITIAL.
*      IF zbp_mm_mrp_rcv=>gt_hdrdata IS NOT INITIAL.
*        DATA(lt_hrdata2) = zbp_mm_mrp_rcv=>gt_hdrdata.
*        MODIFY zmm_mrp_tb1 FROM TABLE @lt_hrdata2.
*      ENDIF.
*    ENDIF.
***********************************************************************
*    IF zbp_mm_mrp_rcv=>cv_pr_doc IS NOT INITIAL .
*      LOOP AT zbp_mm_mrp_rcv=>cv_pr_doc-purchaserequisition ASSIGNING FIELD-SYMBOL(<fs_pr_mapped>).
*        CONVERT KEY OF i_purchaserequisitiontp FROM <fs_pr_mapped>-%pid TO DATA(ls_pr_key).
*        <fs_pr_mapped>-purchaserequisition = ls_pr_key-purchaserequisition.
*      ENDLOOP.
***********************************************************************
*      IF zbp_mm_mrp_rcv=>gt_prrcupd IS NOT INITIAL.
*        DATA(lt_upd) =  zbp_mm_mrp_rcv=>gt_prrcupd.
*        LOOP AT lt_upd ASSIGNING FIELD-SYMBOL(<fs_upd>).
*          <fs_upd>-prnum = ls_pr_key-PurchaseRequisition.
*        ENDLOOP.
*        MODIFY zmm_mrp_tb3 FROM TABLE @lt_upd.
*      ENDIF.
*
**      LOOP AT update-header INTO DATA(ls_hdrupd) WHERE %control-Status IS INITIAL.
**        UPDATE zmrpplan01_tb1 SET status = 'X',totprrec = @lv_lines, totprcrt = 1
**        WHERE recguid = @ls_hdrupd-Recguid.
**
**      ENDLOOP.
*    ENDIF.
***********************************************************************
*    IF zbp_mm_mrp_rcv=>cv_sto_doc IS NOT INITIAL.
*      LOOP AT zbp_mm_mrp_rcv=>cv_sto_doc-purchaseorder ASSIGNING FIELD-SYMBOL(<fs_sto_mapped>).
*        CONVERT KEY OF i_purchaseordertp_2 FROM <fs_sto_mapped>-%pid TO DATA(ls_sto_key).
*        <fs_sto_mapped>-PurchaseOrder = ls_sto_key-PurchaseOrder.
*      ENDLOOP.
***********************************************************************
*      IF zbp_mm_mrp_rcv=>gt_prrcupd IS NOT INITIAL.
*        DATA(lt_upd2) =  zbp_mm_mrp_rcv=>gt_prrcupd.
*        LOOP AT lt_upd2 ASSIGNING FIELD-SYMBOL(<fs_upd2>).
*          <fs_upd2>-prnum = ls_sto_key-PurchaseOrder.
*        ENDLOOP.
*        MODIFY zmm_mrp_tb3 FROM TABLE @lt_upd2.
*      ENDIF.
*    ENDIF.
***********************************************************************
*    IF zbp_mm_mrp_rcv=>gt_prupd IS NOT INITIAL.
*      DATA(lt_prupd) = zbp_mm_mrp*_rcv=>gt_prupd.
*      MODIFY zmm_mrp_tb1 FROM TABLE @lt_prupd.
*    ENDIF.
*
***********************************************************************
**************** Delete Root entity records ***************************
*    IF delete-header IS NOT INITIAL.
*      LOOP AT delete-header INTO DATA(ls_grdel).
*        DELETE FROM zmm_mrp_tb1 WHERE recguid = @ls_grdel-Recguid.
*      ENDLOOP.
*    ENDIF.
***********************************************************************
*

**
*  METHOD cleanup_finalize.
*
*
*  ENDMETHOD.

*ENDCLASS.
