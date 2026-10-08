@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB/NRGB-Gate In & Out - RPE'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_APP1_RPV
  provider contract transactional_query
  as projection on ZFI_APP1_RV
{
  key Uuid,
      Gpnum,
      Gptype,
      Postingdate,
      Documentdate,
      Movmenttype,
      Remarks,
      Plant,
//      Personfullname,
      Delmark,
      Mark,
      Gomark,
      Gateno,
      Gitdat,
      Gittim,
      Gotno,
      Gotdat,
      Gottim,
//      Statustext,
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
      Workprocess,
      Serialno,
      Hodprocesshead,
      Wdv,
      Challanno,
      @ObjectModel.text.element: [ 'PersonFullName' ]
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,
      PersonFullName,
      /* Associations */
      statustext,
      _Item : redirected to composition child ZFI_APP1_CPIV,
      _Work : redirected to composition child ZFI_APP1_SCPV
}
