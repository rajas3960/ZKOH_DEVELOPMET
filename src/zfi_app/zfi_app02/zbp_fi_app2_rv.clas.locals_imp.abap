CLASS lhc__hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _hdr RESULT result.

    METHODS gateentry FOR MODIFY
      IMPORTING keys FOR ACTION _hdr~gateentry RESULT result.

    METHODS gateout FOR MODIFY
      IMPORTING keys FOR ACTION _hdr~gateout RESULT result.

    METHODS updatehd FOR DETERMINE ON SAVE
      IMPORTING keys FOR _hdr~updatehd.

ENDCLASS.

CLASS lhc__hdr IMPLEMENTATION.

  METHOD get_instance_features.

**********************************************************************
        READ ENTITIES OF zfi_app2_rv IN LOCAL MODE
        ENTITY  _hdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_Instatus).

        data(gs_Instatus) = gt_Instatus[ 1 ].

**********************************************************************
        result = VALUE #( for ls_key in keys
                     ( %tky = ls_key-%tky

                     %delete = COND #( WHEN gs_Instatus-Gomark = 'O' or gs_Instatus-Gomark is INITIAL
                                            THEN if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-disabled )
                     %update = COND #( WHEN gs_Instatus-Gomark = 'O' or gs_Instatus-Gomark is INITIAL
                                            THEN if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-enabled )

                     %action = VALUE #( GateEntry = COND #( WHEN gs_Instatus-Gomark = 'O' or gs_Instatus-Gomark is INITIAL
                                                                or gs_instatus-Delmark = 'X'
                                            then if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-enabled )
                                        GateOut = COND #( when gs_instatus-Gomark = 'O' or gs_instatus-Gomark is INITIAL
                                            THEN if_abap_behv=>fc-o-enabled
                                            ELSE if_abap_behv=>fc-o-disabled )
                                        Edit = COND #( when gs_instatus-Gomark = 'O' or gs_instatus-Gomark is INITIAL
                                                            or gs_instatus-Delmark = 'X'
                                            then if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-enabled ) )
                     ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD gateentry.

**********************************************************************
    DATA: it_gatein type table of zfi_app1_tb1,
          is_gatein type zfi_app1_tb1.

**********************************************************************
        READ ENTITIES OF zfi_app2_rv IN LOCAL MODE
        ENTITY _hdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_gatein).

**********************************************************************
        DATA(gs_gatein) = gt_gatein[ 1 ].

**********************************************************************
        MOVE-CORRESPONDING gs_gatein to is_gatein.

    SELECT SINGLE MAX( gateno ) from zfi_app1_tb1
        WHERE uuid is NOT INITIAL
        INTO @data(is_gateno).

        if sy-subrc = 0 AND is_gateno is NOT INITIAL.
        is_gatein-gateno = is_gateno + 1.
            ELSE.
        is_gatein-gateno = '5000000000'.
        endif.
**********************************************************************
            GET TIME STAMP FIELD DATA(ts).
                CONVERT TIME STAMP ts TIME ZONE 'INDIA'
                    INTO DATE DATA(lv_date) TIME DATA(lv_time).

        is_gatein-gitdat = lv_date.
        is_gatein-gittim = lv_time.
        is_gatein-delmark = 'X'.
        is_gatein-gateinstatus = 'Gate Entry ✅'.

        APPEND is_gatein to it_gatein.
        zbp_fi_app2_rv=>gt_gatein = it_gatein.

**********************************************************************
        result = VALUE #( for ls_ord in gt_gatein
                                ( %tky = ls_ord-%tky
                                %param = ls_ord ) ).


  ENDMETHOD.

  METHOD gateout.

**********************************************************************
    DATA: it_gateout type table of zfi_app1_tb1,
          is_gateout type zfi_app1_tb1.

**********************************************************************
        READ ENTITIES OF zfi_app2_rv IN LOCAL MODE
        ENTITY _hdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_gateouts).

**********************************************************************
        DATA(gs_gateouts) = gt_gateouts[ 1 ].

**********************************************************************
        MOVE-CORRESPONDING gs_gateouts to is_gateout.

    SELECT SINGLE MAX( gotno ) from zfi_app1_tb1
        WHERE uuid is NOT INITIAL
        INTO @data(is_gotno).

        if sy-subrc = 0 AND is_gotno is NOT INITIAL.
        is_gateout-gotno = is_gotno + 1.
            ELSE.
        is_gateout-gotno = '4000000000'.
        endif.
**********************************************************************
            GET TIME STAMP FIELD DATA(ts).
                CONVERT TIME STAMP ts TIME ZONE 'INDIA'
                    INTO DATE DATA(lv_date) TIME DATA(lv_time).

        is_gateout-gotdat = lv_date.
        is_gateout-gottim = lv_time.
        is_gateout-gomark = 'X'.
        is_gateout-gateoutstatus = 'Gate Out Completed ✅'.

        APPEND is_gateout to it_gateout.
        zbp_fi_app2_rv=>gt_gateout = it_gateout.

**********************************************************************
        result = VALUE #( for ls_ord in gt_gateouts
                                ( %tky = ls_ord-%tky
                                %param = ls_ord ) ).

  ENDMETHOD.

  METHOD updatehd.

**********************************************************************
    DATA: gt_uphead TYPE TABLE of zfi_app1_tb1,
          gs_uphead TYPE zfi_app1_tb1.

**********************************************************************
    READ ENTITIES OF zfi_app2_rv IN LOCAL MODE
        ENTITY _hdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_hdr).

    DATA(gs_hdr) = gt_hdr[ 1 ].

**********************************************************************
    MOVE-CORRESPONDING gs_hdr to gs_uphead.

*        gs_uphead-delmark = 'O'.
*        gs_uphead-gomark = 'O'.

        APPEND gs_uphead to gt_uphead.
    zbp_fi_app2_rv=>gt_updatehd = gt_uphead.

  ENDMETHOD.

ENDCLASS.

CLASS lhc__item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _item RESULT result.

    METHODS updateitem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _item~updateitem.

ENDCLASS.

CLASS lhc__item IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD updateitem.
**********************************************************************
    DATA: gt_upitem TYPE TABLE of zfi_app1_tb2,
          gs_upitem TYPE   zfi_app1_tb2.

**********************************************************************
    READ ENTITIES OF zfi_app2_rv IN LOCAL MODE
        ENTITY _Item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_item).

***************************************************************
    LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<gs_item>).


    MOVE-CORRESPONDING <gs_item> to gs_upitem.

*        case
*            when  gs_upitem-qty = gs_upitem-recivedqty then.


        gs_upitem-overallstatus = cond #(  when gs_upitem-qty = gs_upitem-recivedqty then 'Completed'
                                           when gs_upitem-qty < gs_upitem-recivedqty then 'Extra Quantity Recived'
                                           else 'Partially' ).

    APPEND gs_upitem to gt_upitem.
    ENDLOOP.
    zbp_fi_app2_rv=>gt_updateitem = gt_upitem.

  ENDMETHOD.

ENDCLASS.
************************Manoj*******************************
CLASS lhc__work DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _work RESULT result.

    METHODS updateitem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _work~updateitem.
    METHODS validqty FOR VALIDATE ON SAVE
      IMPORTING keys FOR _work~validqty.

ENDCLASS.

CLASS lhc__work IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD UpdateItem.
**************************************************************************
 DATA: gt_upitem TYPE TABLE of zfi_app1_tb3,
          gs_upitem TYPE   zfi_app1_tb3.

**************************************************************************
 READ ENTITIES OF ZFI_APP2_RV IN LOCAL MODE
        ENTITY _Work
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_item).

***************************************************************************
LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<gs_item>).

 MOVE-CORRESPONDING <gs_item> to gs_upitem.
 gs_upitem-penqty = gs_upitem-poqty - gs_upitem-recqty.

 APPEND gs_upitem to gt_upitem.
    ENDLOOP.
    zbp_fi_app2_rv=>update_po = gt_upitem.

  ENDMETHOD.

  METHOD Validqty.
**************************************************************************
     READ ENTITIES OF zfi_app2_rv IN LOCAL MODE

    ENTITY _Work
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(gt_work)

    ENTITY _Hdr BY \_Work
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(gt_hdr)

    FAILED DATA(data_failed).
**********************************************************************
          DATA(gs_work) = gt_work[ 1 ].

  LOOP AT gt_hdr INTO DATA(gs_hdr).

    SELECT SINGLE Poqty
      FROM zfi_app2_swrv
      WHERE Poorder = @gs_hdr-Poorder
        AND Poitem  = @gs_hdr-Poitem
        AND uuid     = @gs_hdr-uuid
      INTO @DATA(lv_poqty).

    IF lv_poqty < gs_work-Recqty.

      APPEND VALUE #(
          %tky = gs_work-%tky
      ) TO failed-_Work.

      APPEND VALUE #(
          %tky = gs_work-%tky
          %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-error
                    text     = 'Receiving Qty is more than PO Qty'
                 )
      ) TO reported-_Work.
   ENDIF.
   ENDLOOP.
  ENDMETHOD.

ENDCLASS.
***************************************************************************
CLASS lsc_zfi_app2_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zfi_app2_rv IMPLEMENTATION.

  METHOD save_modified.

**********************************************************************
      if zbp_fi_app2_rv=>gt_updatehd is NOT INITIAL.
        DATA(gt_uhead) = zbp_fi_app2_rv=>gt_updatehd.
        MODIFY zfi_app1_tb1 FROM TABLE @gt_uhead.
       ENDIF.

****----Gate entry ---***************
     if zbp_fi_app2_rv=>gt_gatein is not INITIAL.
     DATA(lt_gatein) = zbp_fi_app2_rv=>gt_gatein.
      MODIFY zfi_app1_tb1 FROM TABLE @lt_gatein.
     endif.

****----Gate Out ---***************
     if zbp_fi_app2_rv=>gt_gateout is not INITIAL.
     DATA(lt_gateout) = zbp_fi_app2_rv=>gt_gateout.
      MODIFY zfi_app1_tb1 FROM TABLE @lt_gateout.
     endif.


**********************************************************************
      if zbp_fi_app2_rv=>gt_updateitem is NOT INITIAL.
        DATA(gt_upitem) = zbp_fi_app2_rv=>gt_updateitem.
        MODIFY zfi_app1_tb2 FROM TABLE @gt_upitem.
       ENDIF.
*****---Update PO ---***************
      if zbp_fi_app2_rv=>update_po is NOT INITIAL.
        MODIFY zfi_app1_tb3 FROM TABLE @zbp_fi_app2_rv=>update_po.
       ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
