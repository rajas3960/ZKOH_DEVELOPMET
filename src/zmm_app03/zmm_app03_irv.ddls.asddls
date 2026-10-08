@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN Log Table Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_APP03_IRV as select from zmm_app03_itb
association to parent ZMM_APP03_RV as _hdr on _hdr.Uuid = $projection.Uuid
{
    key uuid as Uuid,
    key item as Item,
    matnr as Matnr,
    hsn as Hsn,
    tax as Tax,
    createdby as Createdby,
    createdon as Createdon,
    _hdr
}
