@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN App Projection view Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZMM_APP02_hpv provider contract transactional_query as projection on ZMM_APP02_HRV
{
    key Matnr,
    Hsn,
    Tax,
    @Semantics.user.createdBy: true
    Createdby,
    @Semantics.systemDateTime.createdAt: true
    Createdon,
    @Semantics.user.lastChangedBy: true
    Lastchngby,
    @Semantics.systemDateTime.lastChangedAt: true
    Lastchngat,
    Status,
    /* Associations */
    _ITEM : redirected to composition child ZMM_APP02_IPV
}
