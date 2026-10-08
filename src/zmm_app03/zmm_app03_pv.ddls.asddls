@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN Excel Upload Projection View Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZMM_APP03_PV provider contract transactional_query as projection on ZMM_APP03_RV
{
    key Uuid,
    Matnr,
    Hsn,
    Tax,
    Createdby,
    Createdon,
    Lastchngby,
    Lastchngat,
    Status,
    _item : redirected to composition child ZMM_APP03_IPV
}
