@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Uploader - Line Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_MRP_IV1
  as select from zmm_mrp_tb2
{
  key recguid   as Recguid,
  key sno       as Sno,
      plant     as Plant,
      material  as Material,
      matdesc   as Matdesc,
      reqqty    as Reqqty,
      uom       as Uom,
      delvdat   as Delvdat,
      price     as Price,
      curr      as Curr,
      accasscat as Accasscat,
      wbsid     as Wbsid,
      purgrp    as Purgrp,
      serstdt   as Serstdt,
      serenddt  as Serenddt,
      taxcd     as Taxcd,
      popricetp as Popricetp,
      expgl     as Expgl,
      sloc      as Sloc,
      supplnt   as Supplnt,
      issloc    as Issloc,
      itmcid    as Itmcid,
      actcid    as Actcid
}
