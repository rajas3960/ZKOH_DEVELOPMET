@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN App Projection view Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZMM_APP02_IPV as projection on ZMM_APP02_IRV
{
    key Matnr,
    key Slno,
    Hsn,
    Tax,
    @Semantics.user.createdBy: true
    Createdby,
    @Semantics.systemDateTime.createdAt: true
    Createdon,
    /* Associations */
    _HDR : redirected to parent ZMM_APP02_hpv
}
