@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Transfer Gate Entry Projection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZFI_APP01_RPV 
provider contract transactional_query
as projection on ZFI_APP01_RV
{
    key Uuid,
    Gpnum,
    Gptype,
    Postingdate,
    Documentdate,
    Movmenttype,
    Remarks,
    Plant,
    Personfullname,
    Delmark,
    Mark,
    Gomark,
    Gateno,
    Gitdat,
    Gittim,
    Gotno,
    Gotdat,
    Gottim,
    Statustext,
    Purpose,
    Gate,
    Carriedby,
    Lastinvno,
    Registerno,
    Refno,
    Refbldate,
    Location,
    Goingwhere,
    Gstin,
    Workorderno,
    Suppilername,
    Sno,
    Gateinstatus,
    Gateoutstatus,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
      _Item : redirected to composition child ZFI_APP01_CPV,
      _Work : redirected to composition child ZFI_APP01_PSCV
}
