@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Uploader - C Line Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZMM_MRP_IPV1
  as projection on ZMM_MRP_ICV1
{
  key Recguid,
  key Sno,
      Plant,
      Material,
      Matdesc,
      Reqqty,
      Uom,
      Delvdat,
      Price,
      Curr,
      Accasscat,
      Wbsid,
      Purgrp,
      Serstdt,
      Serenddt,
      Taxcd,
      Popricetp,
      Expgl,
      Sloc,
      Supplnt,
      Issloc,
      Itmcid,
      Actcid,
      _header : redirected to parent ZMM_MRP_RPV
}
