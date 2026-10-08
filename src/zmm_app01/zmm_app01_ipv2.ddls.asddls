@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'hsn upload app'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP01_IPV2 as projection on ZMM_APP01_IRV2
{
    key Suid,
    key Material,
    key Slno,
    Hsn,
    Tax,
    Createdby,
    Createdon,
    changetime,
    /* Associations */
    _item2 : redirected to parent ZMM_APP01_IPV,
    _hdr : redirected to ZMM_APP01_PV
}
