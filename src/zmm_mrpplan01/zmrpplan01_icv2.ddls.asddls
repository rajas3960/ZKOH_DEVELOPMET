@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Creation - PR Item CEntity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
} 
define view entity ZMRPPLAN01_ICV2
  as select from ZMRPPLAN01_IV2
  association to parent ZMRPPLAN01_RCV as _hdr on $projection.Recguid = _hdr.Recguid
{
  key Recguid,
  key Prnum,
  key Pritm,
      Plant,
      Material,
      Matdesc,
      @Semantics.quantity.unitOfMeasure :'Uom'
      Reqqty,
      Uom,
      Supplnt,
      Delvdat,
      Sloc,
      Issloc,
      Doctyp,
      Price,
      _hdr
}
