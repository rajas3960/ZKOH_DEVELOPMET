@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB/NRGB-Gate In - RPE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZFI_APP2_RPV 
provider contract transactional_query
as projection on ZFI_APP2_RV
{
    key Uuid,
    Gpnum,
    Gptype,
    Postingdate,
    Documentdate,
    Movmenttype,
    Remarks,
    Plant,
//    Personfullname,
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
    Workprocess,
    Serialno,
    Hodprocesshead,
    Wdv,
      @ObjectModel.text.element: [ 'PersonFullName' ]    
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    PersonFullName,
    Gateinstatus,
    Gateoutstatus,
    /* Associations */
    _item : redirected to composition child ZFI_APP2_CIPV,
    _work : redirected to composition child ZFI_APP2_SWPV    
}
