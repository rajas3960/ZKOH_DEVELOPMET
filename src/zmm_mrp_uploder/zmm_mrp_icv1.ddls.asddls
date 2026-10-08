@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Uploader - C Line Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_MRP_ICV1
  as select from ZMM_MRP_IV1
  association to parent ZMM_MRP_RCV as _header on $projection.Recguid = _header.Recguid
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
      _header
}
