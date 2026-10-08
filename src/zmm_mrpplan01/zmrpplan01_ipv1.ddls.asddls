@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Creation - Line Item PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED 
}
define view entity ZMRPPLAN01_IPV1
  as projection on ZMRPPLAN01_ICV1
{
  key Recguid,
  key Sno,
      Plant,
      Material,
      Matdesc,
      Reqqty,
      Uom,
      Supplnt,
      Delvdat,
      Sloc,
      Issloc,
      Price,
      _hdr : redirected to parent ZMRPPLAN01_RPV
}
