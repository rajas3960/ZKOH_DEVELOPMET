CLASS lsc_zmrpplan01_rcv DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zmrpplan01_rcv IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-header IS NOT INITIAL.
      IF zbp_mrpplan01_rcv=>gt_hdrdata IS NOT INITIAL.
        DATA(lt_hrdata) = zbp_mrpplan01_rcv=>gt_hdrdata.
        MODIFY zmrpplan01_tb1 FROM TABLE @lt_hrdata.
      ENDIF.
    ENDIF.
**********************************************************************
    IF update-header IS NOT INITIAL.
      IF zbp_mrpplan01_rcv=>gt_hdrdata IS NOT INITIAL.
        DATA(lt_hrdata2) = zbp_mrpplan01_rcv=>gt_hdrdata.
        MODIFY zmrpplan01_tb1 FROM TABLE @lt_hrdata2.
      ENDIF.
    ENDIF.
**********************************************************************
    IF zbp_mrpplan01_rcv=>cv_pr_doc IS NOT INITIAL .
      LOOP AT zbp_mrpplan01_rcv=>cv_pr_doc-purchaserequisition ASSIGNING FIELD-SYMBOL(<fs_pr_mapped>).
        CONVERT KEY OF i_purchaserequisitiontp FROM <fs_pr_mapped>-%pid TO DATA(ls_pr_key).
        <fs_pr_mapped>-purchaserequisition = ls_pr_key-purchaserequisition.
      ENDLOOP.
**********************************************************************
      IF zbp_mrpplan01_rcv=>gt_prrcupd IS NOT INITIAL.
        DATA(lt_upd) =  zbp_mrpplan01_rcv=>gt_prrcupd.
        LOOP AT lt_upd ASSIGNING FIELD-SYMBOL(<fs_upd>).
          <fs_upd>-prnum = ls_pr_key-PurchaseRequisition.
        ENDLOOP.
        MODIFY zmrpplan01_tb3 FROM TABLE @lt_upd.
      ENDIF.

*      LOOP AT update-header INTO DATA(ls_hdrupd) WHERE %control-Status IS INITIAL.
*        UPDATE zmrpplan01_tb1 SET status = 'X',totprrec = @lv_lines, totprcrt = 1
*        WHERE recguid = @ls_hdrupd-Recguid.
*
*      ENDLOOP.
    ENDIF.
**********************************************************************
    IF zbp_mrpplan01_rcv=>cv_sto_doc IS NOT INITIAL.
      LOOP AT zbp_mrpplan01_rcv=>cv_sto_doc-purchaseorder ASSIGNING FIELD-SYMBOL(<fs_sto_mapped>).
        CONVERT KEY OF i_purchaseordertp_2 FROM <fs_sto_mapped>-%pid TO DATA(ls_sto_key).
        <fs_sto_mapped>-PurchaseOrder = ls_sto_key-PurchaseOrder.
      ENDLOOP.
**********************************************************************
      IF zbp_mrpplan01_rcv=>gt_prrcupd IS NOT INITIAL.
        DATA(lt_upd2) =  zbp_mrpplan01_rcv=>gt_prrcupd.
        LOOP AT lt_upd2 ASSIGNING FIELD-SYMBOL(<fs_upd2>).
          <fs_upd2>-prnum = ls_sto_key-PurchaseOrder.
        ENDLOOP.
        MODIFY zmrpplan01_tb3 FROM TABLE @lt_upd2.
      ENDIF.
    ENDIF.
**********************************************************************
    IF zbp_mrpplan01_rcv=>gt_prupd IS NOT INITIAL.
      DATA(lt_prupd) = zbp_mrpplan01_rcv=>gt_prupd.
      MODIFY zmrpplan01_tb1 FROM TABLE @lt_prupd.
    ENDIF.

**********************************************************************
*************** Delete Root entity records ***************************
    IF delete-header IS NOT INITIAL.
      LOOP AT delete-header INTO DATA(ls_grdel).
        DELETE FROM zmrpplan01_tb1 WHERE recguid = @ls_grdel-Recguid.
      ENDLOOP.
    ENDIF.
**********************************************************************
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result.

    METHODS CrtPr FOR MODIFY
      IMPORTING keys FOR ACTION Header~CrtPr RESULT result.

    METHODS GetData FOR DETERMINE ON SAVE
      IMPORTING keys FOR Header~GetData.

    METHODS CrtPo FOR MODIFY
      IMPORTING keys FOR ACTION Header~CrtPo RESULT result.

    METHODS GetData2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Header~GetData2.
    METHODS UpdPr FOR MODIFY
      IMPORTING keys FOR ACTION Header~UpdPr RESULT result.

ENDCLASS.

CLASS lhc_Header IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zmrpplan01_rcv IN LOCAL MODE
      ENTITY Header
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_status).

    result = VALUE #( FOR ls_data IN lt_status
      ( %tky =  ls_data-%tky
        %features-%action-Edit = COND #( WHEN ls_data-status EQ 'X'
                                            THEN if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-enabled
         )

        %action = VALUE #( CrtPr = COND #( WHEN ls_data-status EQ 'X'
                                            THEN if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-enabled
         ) )

        %features-%update = COND #( WHEN ls_data-status EQ 'X'
                                            THEN if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-enabled
         )

          ) ).




  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD CrtPr.

    DATA: lt_prrecd TYPE TABLE OF zmrpplan01_tb3,
          ls_prrecd TYPE zmrpplan01_tb3,
          lt_prupd  TYPE TABLE OF zmrpplan01_tb1,
          ls_prupd  TYPE zmrpplan01_tb1.
    DATA: lv_lines TYPE i.

    DATA(lv_cid) = 'CID_'.
    DATA(lv_hcid) = 1.
    DATA(lv_lcid) = 'CIDL_'.
**********************************************************************
    READ ENTITIES OF zmrpplan01_rcv IN LOCAL MODE
    ENTITY Header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr)
    ENTITY Header BY \_litem
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_litem).
    DATA(ls_hdr) = lt_hdr[ 1 ].
    IF lt_litem IS NOT INITIAL.
      DATA(lt_prdata) = lt_litem.
      DATA(lt_stodata) = lt_litem.
*      DELETE lt_prdata WHERE Supplnt  IS NOT INITIAL.
      DELETE lt_stodata WHERE Supplnt IS INITIAL.
      IF lt_prdata IS NOT INITIAL.
**********************************************************************
*****          Replace Commercial UOM with SAP UOM             *******
**********************************************************************
        DATA(lt_prdata_t) = lt_prdata.
        SORT lt_prdata_t BY Uom.
        DELETE ADJACENT DUPLICATES FROM lt_prdata_t COMPARING Uom.

        SELECT s~uom AS suom,i~unitofmeasure AS auom,i~unitofmeasure_e AS cuom
               FROM @lt_prdata_t AS s
               INNER JOIN I_UnitOfMeasure AS i ON s~uom = i~unitofmeasure_e
               INTO TABLE @DATA(lt_uom)
               ##db_feature_mode[itabs_in_from_clause].
        LOOP AT lt_prdata ASSIGNING FIELD-SYMBOL(<fs_prdata>).
          TRY.
              DATA(ls_uom) = lt_uom[ cuom = <fs_prdata>-Uom ].
              <fs_prdata>-Uom = ls_uom-auom.

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
                 WITH VALUE #(  ( %cid                    = lv_cid && lv_hcid
                                  purchaserequisitiontype = ls_hdr-Doctype
                                  SourceDetermination = 'X' ) )            " ls_hdr-Srcdtm

                CREATE BY \_purchaserequisitionitem
                FIELDS ( plant
                         requestedquantity
                         baseunit
                         material
                         DeliveryDate
                         SupplyingPlant
                         PurchaseRequisitionPrice
                             )
                WITH VALUE #(
                              (    %cid_ref = lv_cid && lv_hcid
                                   %target = VALUE #( FOR ls_litm IN lt_prdata
                                                    (  %cid                        = lv_lcid && ls_litm-sno
                                                       plant                       = ls_litm-Plant
                                                       requestedquantity           = ls_litm-Reqqty
                                                       baseunit                    = ls_litm-Uom
                                                       material                    = ls_litm-Material
                                                       DeliveryDate                = ls_litm-Delvdat
                                                       SupplyingPlant              = ls_litm-Supplnt
                                                       PurchaseRequisitionPrice    = ls_litm-Price
                                                       )
                                                    )
                               )
                             )

            REPORTED DATA(ls_reported)
              MAPPED DATA(ls_mapped)
              FAILED DATA(ls_failed).
*          COMMIT ENTITIES.
*          CATCH cl_abap_behv INTO DATA(lc_exception).
          CATCH cx_root INTO DATA(lx_exception).
            DATA(lv_msg) = '040'.
        ENDTRY.

        IF ls_failed IS INITIAL.
          zbp_mrpplan01_rcv=>cv_pr_doc-purchaserequisition = ls_mapped-purchaserequisition.
**********************************************************************
          LOOP AT lt_prdata INTO DATA(lw_prdata).
            ls_prrecd-recguid = lw_prdata-Recguid.
            ls_prrecd-prnum = 1.
            ls_prrecd-pritm += 10.
            ls_prrecd-plant = lw_prdata-Plant.
            ls_prrecd-delvdat = lw_prdata-Delvdat.
            ls_prrecd-doctyp = ls_hdr-Doctype.
            ls_prrecd-matdesc = lw_prdata-Matdesc.
            ls_prrecd-material = lw_prdata-Material.
            ls_prrecd-reqqty = lw_prdata-Reqqty.
            ls_prrecd-sloc = lw_prdata-Sloc.
            ls_prrecd-uom = lw_prdata-Uom.
            ls_prrecd-supplnt = lw_prdata-Supplnt.
            ls_prrecd-price = lw_prdata-Price.
            APPEND ls_prrecd TO lt_prrecd.
          ENDLOOP.
          zbp_mrpplan01_rcv=>gt_prrcupd = lt_prrecd.
          lv_lines =  lines( lt_prrecd ) .
          DATA(ls_hdr1) = lt_hdr[ 1 ].
          MOVE-CORRESPONDING ls_hdr1 TO ls_prupd.
          ls_prupd-status = 'X'.
          ls_prupd-totprcrt = 1.
          ls_prupd-totprrec = lv_lines.
          ls_prupd-doctype = ls_hdr-Doctype.
          ls_prupd-dtyptxt = ls_hdr-Dtyptxt.
          ls_prupd-srcdtm =  ls_hdr-Srcdtm.
          APPEND ls_prupd TO lt_prupd.
          zbp_mrpplan01_rcv=>gt_prupd = lt_prupd.


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

    READ ENTITIES OF zmrpplan01_rcv IN LOCAL MODE
        ENTITY Header
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_hdr2)
        ENTITY Pritm
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_pritm).

    result = VALUE #( FOR ls_ord IN lt_hdr2
                   ( %tky   = ls_ord-%tky
                     %param = ls_ord ) ).

  ENDMETHOD.

  METHOD GetData.
    DATA: lt_hdrdata TYPE TABLE OF zmrpplan01_tb1,
          ls_hdrdata TYPE zmrpplan01_tb1.
**********************************************************************
    READ ENTITIES OF zmrpplan01_rcv IN LOCAL MODE
    ENTITY Header
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

    ls_hdrdata-recguid = ls_header-Recguid.
    ls_hdrdata-createdat = lv_sydate.
    ls_hdrdata-createdby = lv_syuser.
    ls_hdrdata-doctype = ls_header-Doctype.
    ls_hdrdata-dtyptxt = ls_header-Dtyptxt.
    ls_hdrdata-srcdtm = ls_header-Srcdtm.
    APPEND ls_hdrdata TO lt_hdrdata.
**********************************************************************
    zbp_mrpplan01_rcv=>gt_hdrdata = lt_hdrdata.


  ENDMETHOD.

  METHOD CrtPo.

    DATA: lt_prrecd TYPE TABLE OF zmrpplan01_tb3,
          ls_prrecd TYPE zmrpplan01_tb3,
          lt_prupd  TYPE TABLE OF zmrpplan01_tb1,
          ls_prupd  TYPE zmrpplan01_tb1.
    DATA: lv_lines TYPE i.

    DATA(lv_cid) = 'CID_'.
    DATA(lv_hcid) = 1.
    DATA(lv_lcid) = 'CIDL_'.

    READ ENTITIES OF zmrpplan01_rcv IN LOCAL MODE
    ENTITY Header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr)
    ENTITY Header BY \_litem
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_litem).

    IF lt_litem IS NOT INITIAL.
      DATA(lt_stodata) = lt_litem.
      DELETE lt_stodata WHERE Supplnt IS INITIAL.


      IF lt_stodata IS NOT INITIAL.
*      TYPES: tt_purorder_items_create TYPE TABLE FOR CREATE i_purchaseordertp_2\_purchaseorderitem,
*             ty_purorder_items_create TYPE LINE OF tt_purorder_items_create.
*      TYPES: tt_item_schd_line_create TYPE TABLE FOR CREATE I_PurchaseOrderItemTP_2\_PurchaseOrderScheduleLineTP,
*             ty_item_schd_line_create TYPE LINE OF tt_item_schd_line_create.

        DATA: lt_stoline TYPE TABLE OF zmrpplan01_st1,
              ls_stoline TYPE zmrpplan01_st1.
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

        MODIFY ENTITIES OF I_PurchaseOrderTP_2
        ENTITY purchaseorder
        CREATE FIELDS ( purchaseordertype
                                       )
        WITH VALUE #( ( %cid                   = 'PO_H1'
                        purchaseordertype      = 'ZITR'
*                        CompanyCode            = '5000'
                        SupplyingPlant         = VALUE #( lt_stoline[ 1 ]-supplnt )
                    ) )
       CREATE BY \_purchaseorderitem
       FIELDS ( Plant OrderQuantity BaseUnit Material PurchaseOrderItem IssuingStorageLocation StorageLocation )
       WITH VALUE #( ( %cid_ref = 'PO_H1'
                       %target = VALUE #(  FOR ls_sline IN lt_stoline
                                    (  %cid                = 'POI' && ls_sline-sno
                                       plant                = ls_sline-plant
                                       orderquantity        = ls_sline-reqqty
                                       BaseUnit             = ls_sline-uom
                                       purchaseorderitem    = ls_sline-litem
                                       Material             = ls_sline-material
                                       StorageLocation      = ls_sline-sloc
*                                     IssuingStorageLocation = ls_sline-issloc
                                       %control = VALUE #(
                                       plant                = cl_abap_behv=>flag_changed
                                       orderquantity        = cl_abap_behv=>flag_changed
                                       purchaseorderitem    = cl_abap_behv=>flag_changed
                                       Material             = cl_abap_behv=>flag_changed
                                       BaseUnit             = cl_abap_behv=>flag_changed
                                       StorageLocation      = cl_abap_behv=>flag_changed
*                                     IssuingStorageLocation = cl_abap_behv=>flag_changed
                                      )          ) ) ) )
       ENTITY PurchaseOrderItem
       CREATE BY \_PurchaseOrderScheduleLineTP
       FIELDS ( ScheduleLine ScheduleLineDeliveryDate PurchaseOrderItem ScheduleLineOrderQuantity )
       WITH VALUE #( FOR ls_shline IN lt_stoline ( %cid_ref = 'POI' && ls_shline-sno
                        %target  = VALUE #( (
                        %cid        =  'SHI_' && ls_shline-sno
                        schedulelineorderquantity = ls_shline-reqqty
                        schedulelinedeliverydate = ls_shline-delvdat
                        scheduleline = '0001'
                        purchaseorderitem = ls_shline-litem
                    %control = VALUE #(
                    schedulelineorderquantity = cl_abap_behv=>flag_changed
                    schedulelinedeliverydate = cl_abap_behv=>flag_changed
                    scheduleline = cl_abap_behv=>flag_changed
                    purchaseorderitem = cl_abap_behv=>flag_changed
                        ) )  )  ) )
       REPORTED DATA(ls_sto_reported)
       FAILED   DATA(ls_sto_failed)
       MAPPED   DATA(ls_sto_mapped).

        IF ls_sto_failed IS INITIAL.
          zbp_mrpplan01_rcv=>cv_sto_doc-purchaseorder = ls_sto_mapped-purchaseorder.
          LOOP AT lt_stodata INTO DATA(lw_stodata).
            ls_prrecd-recguid = lw_stodata-Recguid.
            ls_prrecd-prnum = 1.
            ls_prrecd-pritm += 10.
            ls_prrecd-plant = lw_stodata-Plant.
            ls_prrecd-delvdat = lw_stodata-Delvdat.
            ls_prrecd-doctyp = 'ZITR'.
            ls_prrecd-matdesc = lw_stodata-Matdesc.
            ls_prrecd-material = lw_stodata-Material.
            ls_prrecd-reqqty = lw_stodata-Reqqty.
            ls_prrecd-sloc = lw_stodata-Sloc.
            ls_prrecd-uom = lw_stodata-Uom.
            APPEND ls_prrecd TO lt_prrecd.
          ENDLOOP.
          zbp_mrpplan01_rcv=>gt_prrcupd = lt_prrecd.
          lv_lines =  lines( lt_prrecd ) .
          DATA(ls_hdr2) = lt_hdr[ 1 ].
          MOVE-CORRESPONDING ls_hdr2 TO ls_prupd.
          ls_prupd-status = 'X'.
          ls_prupd-totpocrt = 1.
          ls_prupd-totporec = lv_lines.
          APPEND ls_prupd TO lt_prupd.
          zbp_mrpplan01_rcv=>gt_prupd = lt_prupd.
        ENDIF.
      ENDIF.

    ELSE.

    ENDIF.

    result = VALUE #( FOR ls_ord IN lt_hdr
                   ( %tky   = ls_ord-%tky
                     %param = ls_ord ) ).


  ENDMETHOD.

  METHOD GetData2.
    DATA: lt_hdrdata TYPE TABLE OF zmrpplan01_tb1,
          ls_hdrdata TYPE zmrpplan01_tb1.
**********************************************************************
    READ ENTITIES OF zmrpplan01_rcv IN LOCAL MODE
    ENTITY Header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).
    DATA(ls_header)  = lt_header[ 1 ].

    ls_hdrdata-recguid = ls_header-Recguid.
*    ls_hdrdata-createdat = lv_sydate.
*    ls_hdrdata-createdby = lv_syuser.
    ls_hdrdata-doctype = ls_header-Doctype.
    ls_hdrdata-dtyptxt = ls_header-Dtyptxt.
    APPEND ls_hdrdata TO lt_hdrdata.
**********************************************************************
    zbp_mrpplan01_rcv=>gt_hdrdata = lt_hdrdata.
  ENDMETHOD.

  METHOD UpdPr.
**********************************************************************
    READ ENTITIES OF zmrpplan01_rcv IN LOCAL MODE
    ENTITY Header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr).
    DATA(ls_hdr) = lt_hdr[ 1 ].

    SELECT * FROM zmrpplan01_tb3
    WHERE recguid = @ls_hdr-Recguid
    INTO TABLE @DATA(lt_prdata).
    IF lt_prdata IS NOT INITIAL.

    ENDIF.

**********************************************************************
    MODIFY ENTITIES OF i_purchaserequisitiontp
    PRIVILEGED
          ENTITY purchaserequisitionitem UPDATE
          SET FIELDS WITH VALUE #( FOR ls_prdata IN lt_prdata ( purchaserequisition = ls_prdata-prnum
                                   purchaserequisitionitem = ls_prdata-pritm
                                   DeliveryDate = ls_prdata-delvdat

                                    ) ) .


  ENDMETHOD.

ENDCLASS.
