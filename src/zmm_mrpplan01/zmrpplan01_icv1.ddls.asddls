@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Creation - Line Item CEntity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
} 
define view entity ZMRPPLAN01_ICV1
  as select from ZMRPPLAN01_IV1
 association to parent ZMRPPLAN01_RCV as _hdr on $projection.Recguid = _hdr.Recguid
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
      _hdr
}
