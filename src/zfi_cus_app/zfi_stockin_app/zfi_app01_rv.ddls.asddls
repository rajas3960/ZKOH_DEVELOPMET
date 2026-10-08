@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Transfer Gate Entry RV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_APP01_RV
  as select from zfi_app01_tb1
  composition [0..*] of ZFI_APP01_CV as _Item
  composition [0..*] of  ZFI_APP01_SCV as _Work 
{
  key uuid           as Uuid,
      gpnum          as Gpnum,
      gptype         as Gptype,
      postingdate    as Postingdate,
      documentdate   as Documentdate,
      movmenttype    as Movmenttype,
      remarks        as Remarks,
      plant          as Plant,
      personfullname as Personfullname,
      delmark        as Delmark,
      mark           as Mark,
      gomark         as Gomark,
      gateno         as Gateno,
      gitdat         as Gitdat,
      gittim         as Gittim,
      gotno          as Gotno,
      gotdat         as Gotdat,
      gottim         as Gottim,
      statustext     as Statustext,
      purpose        as Purpose,
      gate           as Gate,
      carriedby      as Carriedby,
      lastinvno      as Lastinvno,
      registerno     as Registerno,
      refno          as Refno,
      refbldate      as Refbldate,
      location       as Location,
      goingwhere     as Goingwhere,
      gstin          as Gstin,
      workorderno    as Workorderno,
      suppilername   as Suppilername,
      sno            as Sno,
      gateinstatus   as Gateinstatus,
      gateoutstatus  as Gateoutstatus,
      @Semantics.user.createdBy: true
      createdby      as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat      as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby  as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat  as Lastchangedat,
      _Item,
      _Work

}
