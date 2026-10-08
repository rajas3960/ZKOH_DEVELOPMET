@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Creation - PR Item Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED 
}
define view entity ZMRPPLAN01_IV2
  as select from zmrpplan01_tb3
{
  key recguid  as Recguid,
  key prnum    as Prnum,
  key pritm    as Pritm,
      plant    as Plant,
      material as Material,
      matdesc  as Matdesc,
      @Semantics.quantity.unitOfMeasure :'Uom'
      reqqty   as Reqqty,
      uom      as Uom,
      supplnt  as Supplnt,
      delvdat  as Delvdat,
      sloc     as Sloc,
      issloc   as Issloc,
      doctyp   as Doctyp,
      price    as Price
}
