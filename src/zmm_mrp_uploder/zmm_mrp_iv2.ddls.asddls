@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Uploader - MLine Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_MRP_IV2
  as select from zmm_mrp_tb3
{
  key recguid  as Recguid,
  key prnum    as Prnum,
  key pritm    as Pritm,
      ptyg     as Ptyg,
      aactg    as Aactg,
      pwbsid   as Pwbsid,
      plant    as Plant,
      pgroup   as Pgroup,
      mserv    as Mserv,
      material as Material,
      matdesc  as Matdesc,
      @Semantics.quantity.unitOfMeasure :'Uom'
      reqqty   as Reqqty,
      uom      as Uom,
      supplnt  as Supplnt,
      delvdat  as Delvdat,
      sstart   as Sstart,
      send     as Send,
      taxcode  as Taxcode,
      sloc     as Sloc,
      issloc   as Issloc,
      doctyp   as Doctyp,
      price    as Price,
      expgl    as Expgl
}
