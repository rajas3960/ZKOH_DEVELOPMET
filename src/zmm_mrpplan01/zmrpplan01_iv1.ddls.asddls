@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Creation - Line Item Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMRPPLAN01_IV1
  as select from zmrpplan01_tb2
{
  key recguid  as Recguid,
  key sno      as Sno,
      plant    as Plant,
      material as Material,
      matdesc  as Matdesc,
      reqqty   as Reqqty,
      uom      as Uom,
      delvdat  as Delvdat,
      issloc   as Issloc,
      supplnt  as Supplnt,
      sloc     as Sloc,
      price    as Price
}
