@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN Upload App Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP01_IPV
  as projection on ZMM_APP01_IRV
{
  key Suid,
  key Matnr,
      Hsn,
      Tax,

      createdby,

      createdon,

      Lastchngat,

      Lastchngby,
      changetime,
      Status,
      _HDR   : redirected to parent ZMM_APP01_PV,
      _ITEM1 : redirected to composition child ZMM_APP01_IPV2
}
