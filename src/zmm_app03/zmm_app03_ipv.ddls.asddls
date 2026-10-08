@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN Log Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZMM_APP03_IPV as projection on ZMM_APP03_IRV
{
    key Uuid,
    key Item,
    Matnr,
    Hsn,
    Tax,
    Createdby,
    Createdon,
    /* Associations */
    _hdr : redirected to parent ZMM_APP03_PV
}
