CLASS lhc__hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _hdr RESULT result.

    METHODS gatestatus FOR MODIFY
      IMPORTING keys FOR ACTION _hdr~gatestatus RESULT result.

    METHODS getheader FOR DETERMINE ON SAVE
      IMPORTING keys FOR _hdr~getheader.

ENDCLASS.

CLASS lhc__hdr IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************

        READ ENTITIES OF zfi_app1_rv IN LOCAL MODE
        ENTITY  _hdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_status).

        data(gs_status) = VALUE #( gt_status[ 1 ] OPTIONAL ).

**********************************************************************
        result = VALUE #( for ls_key in keys
                     ( %tky = ls_key-%tky

                     %update = COND #( WHEN gs_status-Mark = 'O' or gs_status-Mark is INITIAL
                                            THEN if_abap_behv=>fc-o-enabled
                                            ELSE if_abap_behv=>fc-o-disabled )
                      %features-%assoc-_Item = COND #( WHEN  gs_status-Workprocess = 'ASSET'
*                                                            or gs_status-Workprocess = 'PARTIAL' )
                                            then if_abap_behv=>fc-o-enabled
                                            ELSE if_abap_behv=>fc-o-disabled )
                      %features-%assoc-_Work = COND #( WHEN  gs_status-Workprocess = 'WORK ORDER'
*                                                             or gs_status-Workprocess = 'PARTIAL' )
                                            then if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-disabled )
                     %delete = cond #( WHEN gs_status-Mark = 'O' or gs_status-Mark is initial
                                            THEN if_abap_behv=>fc-o-enabled
                                            ELSE if_abap_behv=>fc-o-disabled )
                     %action = VALUE #( GateStatus = COND #( WHEN gs_status-Mark = 'O' or gs_status-Mark is INITIAL
                                            then if_abap_behv=>fc-o-enabled
                                            ELSE if_abap_behv=>fc-o-disabled )

                                        Edit = COND #( WHEN gs_status-Mark = 'O' or gs_status-Mark is INITIAL
                                            then if_abap_behv=>fc-o-enabled
                                            ELSE if_abap_behv=>fc-o-disabled ) )


                                         ) ) .




  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD gatestatus.

**********************************************************************
    DATA: it_gateoutst type table of zfi_app1_tb1,
          is_gateoutst type zfi_app1_tb1.

**********************************************************************
        READ ENTITIES OF zfi_app1_rv IN LOCAL MODE
        ENTITY _hdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_goutst).

**********************************************************************
        DATA(gs_goutst) = gt_goutst[ 1 ].

**********************************************************************
        MOVE-CORRESPONDING gs_goutst to is_gateoutst.

*    SELECT SINGLE MAX( gotno ) from zfi_app1_tb1
*        WHERE uuid is NOT INITIAL
*        INTO @data(is_gotno).
*
*        if sy-subrc = 0 AND is_gotno is NOT INITIAL.
*        is_gateoutst-gotno = is_gotno + 1.
*            ELSE.
*        is_gateoutst-gotno = '4000000000'.
*        endif.
***********************************************************************
*            GET TIME STAMP FIELD DATA(ts).
*                CONVERT TIME STAMP ts TIME ZONE 'INDIA'
*                    INTO DATE DATA(lv_date) TIME DATA(lv_time).
*
*        is_gateoutst-gotdat = lv_date.
*        is_gateoutst-gottim = lv_time.
        is_gateoutst-mark = 'X'.
        is_gateoutst-statustext = 'Transfer Completed✅'.

        APPEND is_gateoutst to it_gateoutst.
        zbp_fi_app1_rv=>gt_gateoutst = it_gateoutst.

**********************************************************************
        result = VALUE #( for ls_ord in gt_goutst
                                ( %tky = ls_ord-%tky
                                %param = ls_ord ) ).

  ENDMETHOD.

  METHOD getheader.

**********************************************************************
*** Local Internal table declaration
    DATA : gt_hdrdata TYPE TABLE of zfi_app1_tb1,
           gs_hdrdata TYPE zfi_app1_tb1.

**********************************************************************
    READ ENTITIES OF zfi_app1_rv IN LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(gt_header).

    DATA(gs_header) = gt_header[ 1 ].
**********************************************************************
IF gs_header-workprocess = 'PARTIAL'.

  DATA: ls_part1 TYPE zfi_app1_tb1.
  data: wa_part type  zfi_app1_tb1.
  data: gt_part type TABLE OF zfi_app1_tb1.
  DATA: lt_part TYPE tABLE of zfi_app1_tb3.
**********************************************************************
  IF gs_header-Challanno IS NOT INITIAL.

    SELECT single *
      FROM zfi_app1_tb1
      WITH PRIVILEGED ACCESS
      WHERE gpnum = @gs_header-Challanno
      INTO  @ls_part1.

    SELECT * from   zfi_app1_tb3 WITH PRIVILEGED ACCESS
    where uuid = @ls_part1-uuid
    INTO TABLE @data(lt_POITEM).
**********************************************************************
        if ls_part1 is not INITIAL.
        movE-CORRESPONDING ls_part1 to wa_part.
        wa_part-uuid = gs_header-uuid.
**********************************************************************
        SELECT * FROM zfi_app1_tb1 WHERE uuid is NOT INITIAL
            and workprocess = @gs_header-workprocess
            INTO TABLE @DATA(gt_slno1).
            if gt_slno1 is INITIAL.
                   wa_part-Gptype = 'PAT'.
                   wa_part-sno = '7000000000'.
                   wa_part-gpnum = |{ wa_part-gptype }-{ wa_part-sno }|.

             ELSE.
                SORT gt_slno1 by sno DESCENDING.
                DATA(gs_slno1) = gt_slno1[ 1 ].
                wa_part-Gptype = 'PAT'.
                wa_part-sno = gs_slno1-sno + 1.
                wa_part-gpnum = |{ wa_part-gptype }-{ wa_part-sno }|.
            endif.
**********************************************************************
                wa_part-delmark = ''.
                wa_part-mark = ''.
                wa_part-gomark = ''.
                wa_part-statustext = ''.
                wa_part-gateinstatus = ''.
                wa_part-gateoutstatus = ''.
                wa_part-workprocess = 'PARTIAL'.
                wa_part-challan = gs_header-Challanno.
        appEND wa_part to gt_part.

        endif.
**********************************************************************
    IF lt_POITEM IS NOT INITIAL.

      lt_part = VALUE #(
        FOR ls_part IN lt_POITEM (
          uuid            = gs_header-uuid
          poorder         = ls_part-poorder
          poitem          = ls_part-poitem
          materialnumber  = ls_part-materialnumber
          productdes      = ls_part-productdes
          poqty           = ls_part-penqty
          pounit          = ls_part-pounit
        )
      ).

    ENDIF.

  ENDIF.
  zbp_fi_app1_rv=>gt_pocrt = lt_part.
  zbp_fi_app1_rv=>GT_HECRT = gt_part.

**********************************************************************
    else.

**********************************************************************
    if gs_header-Gptype is not initial.
    gs_hdrdata-uuid = gs_header-Uuid.
*    gs_hdrdata-gpnum = gs_header-gpnum.
    gs_hdrdata-gptype = gs_header-gptype.
    gs_hdrdata-postingdate = gs_header-postingdate.
    gs_hdrdata-Documentdate = gs_header-Documentdate.

    gs_hdrdata-movmenttype = gs_header-movmenttype.
    gs_hdrdata-Remarks = gs_header-Remarks.
    gs_hdrdata-plant = gs_header-plant.
*    gs_hdrdata-Personfullname = gs_header-Personfullname.
    gs_hdrdata-delmark = 'O'.

    gs_hdrdata-mark = 'O'.
    gs_hdrdata-gomark = 'O'.
    gs_hdrdata-Gateno = gs_header-Gateno.
    gs_hdrdata-gitdat = gs_header-gitdat.
    gs_hdrdata-Gittim = gs_header-Gittim.
    gs_hdrdata-gotno = gs_header-Gotno.

*        GET TIME STAMP FIELD DATA(ts).
*            CONVERT TIME STAMP ts TIME ZONE 'INDIA'
*                INTO DATE DATA(lv_date) TIME DATA(lv_time).
    gs_hdrdata-gotdat = gs_header-Gotdat.
    gs_hdrdata-gottim = gs_header-Gottim.
    gs_hdrdata-Statustext = gs_header-Statustext.
    gs_hdrdata-gateinstatus = gs_header-Gateinstatus.
    gs_hdrdata-gateoutstatus = gs_header-Gateoutstatus.
    gs_hdrdata-purpose = gs_header-purpose.
    gs_hdrdata-Gate = gs_header-Gate.
    gs_hdrdata-carriedby = gs_header-carriedby.

    gs_hdrdata-lastinvno = gs_header-lastinvno.
    gs_hdrdata-Registerno = gs_header-Registerno.
    gs_hdrdata-refno = gs_header-refno.
    gs_hdrdata-Refbldate = gs_header-Refbldate.
    gs_hdrdata-location = gs_header-location.

    gs_hdrdata-goingwhere = gs_header-goingwhere.
    gs_hdrdata-Gstin = gs_header-Gstin.
    gs_hdrdata-workorderno = gs_header-workorderno.
    gs_hdrdata-Suppilername = gs_header-Suppilername.
*    gs_hdrdata-sno = gs_header-sno.
    gs_hdrdata-workprocess = gs_header-Workprocess.
    gs_hdrdata-serialno = gs_header-Serialno.
    gs_hdrdata-hodprocesshead = gs_header-Hodprocesshead.
    gs_hdrdata-wdv = gs_header-Wdv.
    gs_hdrdata-challan = gs_header-Challanno.

    gs_hdrdata-createdat = gs_header-createdat.
    gs_hdrdata-Createdby = gs_header-Createdby.
    gs_hdrdata-lastchangedat = gs_header-lastchangedat.
    gs_hdrdata-Lastchangedby = gs_header-Lastchangedby.

**********************************************************************
    SELECT * FROM zfi_app1_tb1 WHERE uuid is NOT INITIAL
            and gptype = @gs_header-Gptype
            INTO TABLE @DATA(gt_slno).
            if gt_slno is INITIAL.
                if gs_header-Gptype = 'RGP'.
                   gs_hdrdata-sno = '9000000000'.
                   gs_hdrdata-gpnum = |{ gs_hdrdata-gptype }-{ gs_hdrdata-sno }|.
                ELSE.
                    gs_hdrdata-sno = '8000000000'.
                   gs_hdrdata-gpnum = |{ gs_hdrdata-gptype }-{ gs_hdrdata-sno }|.
                ENDIF.
             ELSE.
                SORT gt_slno by sno DESCENDING.
                DATA(gs_slno) = gt_slno[ 1 ].
                gs_hdrdata-sno = gs_slno-sno + 1.
                gs_hdrdata-gpnum = |{ gs_hdrdata-gptype }-{ gs_hdrdata-sno }|.

            endif.
**********************************************************************
    if gs_hdrdata-workprocess = 'WORK ORDER'.

    DATA : LT_PUR1 TYPE TABLE OF zfi_app1_tb3,
       LS_PUR1 TYPE zfi_app1_tb3.
    IF  gs_hdrdata-workorderno IS NOT INITIAL.
    SELECT PurchaseOrder,PurchaseOrderItem ,Material,OrderQuantity ,BaseUnit,NetAmount,DocumentCurrency, PurchaseOrderItemText   FROM I_PurchaseOrderItemAPI01 WITH PRIVILEGED ACCESS
    WHERE PurchaseOrder = @gs_hdrdata-workorderno INTO TABLE @DATA(LT_PURCH).
    IF lt_purch IS NOT INITIAL.

    lt_pur1 = VALUE #(  FOR LS IN LT_PURCH ( uuid = gs_hdrdata-uuid
                                             poorder = LS-PurchaseOrder
                                             poitem = LS-PurchaseOrderItem
                                             materialnumber =  ls-Material
                                             productdes = LS-PurchaseOrderItemText
                                             poqty = LS-OrderQuantity
                                             pounit = LS-BaseUnit
                                             documcurrency = ls-DocumentCurrency
                                             pocost = ls-NetAmount
                                             createdat = gs_hdrdata-createdat
                                             createdby = gs_hdrdata-createdby
                                             lastchangedat = gs_hdrdata-lastchangedat
                                             lastchangedby = gs_hdrdata-lastchangedby  ) ).


    ENDIF.
    ENDIF.
    zbp_fi_app1_rv=>gt_pocrt = lt_pur1.
    endif.

    APPEND gs_hdrdata to gt_hdrdata.
    zbp_fi_app1_rv=>gt_header = gt_hdrdata.


    endif.
ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc__item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _item RESULT result.

    METHODS getitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~getitem.

ENDCLASS.

CLASS lhc__item IMPLEMENTATION.

  METHOD get_instance_features.

  ENDMETHOD.

  METHOD getitem.
**********************************************************************
    DATA: gt_item TYPE TABLE of zfi_app1_tb2,
          gs_item type zfi_app1_tb2.

**********************************************************************
    READ ENTITIES OF zfi_app1_rv in LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(gt_hd)
    ENTITY _hdr BY \_Item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_item).

**********************************************************************
    DATA(is_hd) = gt_hd[ 1 ].
    DATA(is_item) = it_item[ 1 ].

    SELECT SINGLE MAX( itemno ) from zfi_app1_tb2
        WHERE uuid = @is_item-Uuid
        INTO @data(is_itemno).

        if sy-subrc = 0 AND is_itemno is NOT INITIAL.
        gs_item-itemno = is_itemno + 10.
            ELSE.
        gs_item-itemno = 10.
        endif.

        gs_item-uuid = is_item-Uuid.
        gs_item-transposno = is_item-Transposno.

        gs_item-Assetmat = is_item-Assetmat.
        gs_item-assetmatdes = is_item-assetmatdes.
        gs_item-uom = is_item-Uom.
        gs_item-qty = is_item-Qty.
        gs_item-Batch = is_item-Batch.
        gs_item-fromplant = is_item-fromplant.
        gs_item-Fromlocation = is_item-Fromlocation.
        gs_item-toplant = is_item-toplant.
        gs_item-Tolocation = is_item-Tolocation.
        gs_item-inventoryno = is_item-Inventoryno.
        gs_item-serialnumber = is_item-Serialnumber.
        gs_item-recivedqty = is_item-recivedqty.
        gs_item-createdat = is_item-createdat.
        gs_item-Createdby = is_item-Createdby.
        gs_item-lastchangedat = is_item-lastchangedat.
        gs_item-Lastchangedby = is_item-Lastchangedby.

        APPEND gs_item to gt_item.
        zbp_fi_app1_rv=>gt_item = gt_item.

  ENDMETHOD.

ENDCLASS.

CLASS lhc__work DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _work RESULT result.

    METHODS getwork FOR DETERMINE ON SAVE
      IMPORTING keys FOR _work~getwork.
    METHODS updatework FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _work~updatework.

ENDCLASS.

CLASS lhc__work IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD getwork.

**********************************************************************
    DATA: it_work TYPE TABLE of zfi_app1_tb3,
          is_work type zfi_app1_tb3.

**********************************************************************
    READ ENTITIES OF zfi_app1_rv in LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(gt_hd)
    ENTITY _hdr BY \_Item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_item)
    ENTITY _hdr by \_Work
    ALL FIELDS WITH CORRESPONDING #( keys )
    REsult data(lt_work).

**********************************************************************
    LOOP AT lt_work INTO DATA(ls_work).

        is_work-uuid = ls_work-Uuid.
        is_work-poorder = ls_work-Poorder.
        is_work-poitem = ls_work-poitem.
        is_work-Materialnumber = ls_work-Materialnumber.
        is_work-productdes = ls_work-productdes.
        is_work-pounit = ls_work-Pounit.
        is_work-poqty = ls_work-Poqty.
        is_work-documcurrency = ls_work-Documcurrency.
        is_work-pocost = ls_work-Pocost.
        is_work-Createdby = ls_work-Createdby.
        is_work-Createdat = ls_work-Createdat.
        is_work-Lastchangedat = ls_work-Lastchangedat.
        is_work-Lastchangedby = ls_work-Lastchangedby.

        APPEND is_work to it_work.

    ENDLOOP.

        zbp_fi_app1_rv=>gt_work = it_work.

  ENDMETHOD.

  METHOD updatework.

    DATA: it_updatepo type table of zfi_app1_tb3,
          is_updatepo type zfi_app1_tb3.
**********************************************************************
    READ ENTITIES OF zfi_app1_rv in LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(gt_hd)
    ENTITY _hdr BY \_Item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_item)
    ENTITY _hdr by \_Work
    ALL FIELDS WITH CORRESPONDING #( keys )
    REsult data(lt_work).

**********************************************************************
    LOOP at lt_work INTO DATA(ls_work).
        MOVE-CORRESPONDING ls_work to is_updatepo.

        APPEND is_updatepo to it_updatepo.
   ENDLOOP.
        zbp_fi_app1_rv=>gt_upwork = it_updatepo.

**********************************************************************

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zfi_app1_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zfi_app1_rv IMPLEMENTATION.

  METHOD save_modified.

**********************************************************************
*******----Header part create----*****

    if create-_hdr is NOT INITIAL.
        if zbp_fi_app1_rv=>gt_header is not INITIAL.
            DATA(gt_hd) = zbp_fi_app1_rv=>gt_header.
            MODIFY zfi_app1_tb1 FROM TABLE @gt_hd.
        endif.
        IF zbp_fi_app1_rv=>gt_pocrt IS NOT INITIAL.
        MODIFY zfi_app1_tb3 FROM TABLE @zbp_fi_app1_rv=>gt_pocrt.
        ENDIF.
    ENDIF.

    if delete-_hdr is NOT INITIAL.
        loop at delete-_hdr into data(gs_delet).
            DELETE FROM zfi_app1_tb1 WHERE uuid = @gs_delet-Uuid.
        endloop.
    endif.
**********************************************************************
****----Gate Transfer ---***************
     if zbp_fi_app1_rv=>gt_gateoutst is not INITIAL.
     DATA(lt_gatout) = zbp_fi_app1_rv=>gt_gateoutst.
      MODIFY zfi_app1_tb1 FROM TABLE @lt_gatout.
     endif.

**********************************************************************
*****-----item part create---***************
    if create-_item is not INITIAL.
        if zbp_fi_app1_rv=>gt_item is not INITIAL.
            data(it_itm) = zbp_fi_app1_rv=>gt_item.
            MODIFY zfi_app1_tb2 FROM TABLE @it_itm.
        endif.
    endif.

    if delete-_item is not INITIAL.
        LOOP at delete-_item into data(is_delete).
            DELETE from zfi_app1_tb2 WHERE uuid = @is_delete-Uuid
                                        and transposno = @is_delete-Transposno
                                        and itemno = @is_delete-Itemno.
        endloop.
    endif.

**********************************************************************
******Work Order part Create---*******
    if  create-_work is not INITIAL.
        if zbp_fi_app1_rv=>gt_work is NOT INITIAL.
            DATA(lt_work) = zbp_fi_app1_rv=>gt_work.
            MODIFY zfi_app1_tb3 FROM TABLE @lt_work.
        ENDIF.
    endif.

**********************************************************************
*******update work order po--********
    if update-_work is NOT INITIAL.
        if zbp_fi_app1_rv=>gt_upwork is NOT INITIAL.
                MODIFY zfi_app1_tb3 FROM TABLE @zbp_fi_app1_rv=>gt_upwork.
        endif.
    endif.
**********************************************************************
    if delete-_work is NOT INITIAL.
        LOOP AT delete-_work INTO DATA(ls_delete).
            DELETE FROM zfi_app1_tb3 WHERE uuid = @ls_delete-Uuid
                                        and poorder = @ls_delete-Poorder
                                        and poitem = @ls_delete-Poitem.
        ENDLOOP.
    endif.

**********************************************************************
******___Challan field update----
        if   zbp_fi_app1_rv=>gt_pocrt is not INITIAL.
           MODIFY zfi_app1_tb3 FROM TABLE @zbp_fi_app1_rv=>gt_pocrt.
        endif.

        if zbp_fi_app1_rv=>GT_HECRT is not INITIAL.
            MODIFY zfi_app1_tb1 FROM TABLE @zbp_fi_app1_rv=>GT_HECRT.
        endif.


  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
