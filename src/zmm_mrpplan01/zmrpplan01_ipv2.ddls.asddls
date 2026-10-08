@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Creation - PR Item PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED 
}
define view entity ZMRPPLAN01_IPV2
  as projection on ZMRPPLAN01_ICV2
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
      _hdr : redirected to parent ZMRPPLAN01_RPV
}
