@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN Excel Upload Root View Entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_APP03_RV as select from zmm_app03_tb
composition[1..*] of ZMM_APP03_IRV as _item
{
    key uuid as Uuid,
     matnr as Matnr,
    hsn as Hsn,
    tax as Tax,
    createdby as Createdby,
    createdon as Createdon,
    lastchngby as Lastchngby,
    lastchngat as Lastchngat,
    status as Status,
    _item
}
