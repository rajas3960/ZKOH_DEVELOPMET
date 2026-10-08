@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Creation - Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S, 
    dataClass: #MIXED
}
define root view entity ZMRPPLAN01_RPV
  provider contract transactional_query
  as projection on ZMRPPLAN01_RCV
{
  key Recguid,
      @ObjectModel.text.element: [ 'Dtyptxt' ]
      Doctype,
      Srcdtm,
      Dtyptxt,
      Totprrec,
      Totprcrt,
      Totporec,
      Totpocrt,
      Createdat,
      Lastchngby,
      Lastchngat,
      Createdby,
      Status,
      _litem : redirected to composition child ZMRPPLAN01_IPV1,
      _pritm : redirected to composition child ZMRPPLAN01_IPV2
//    _prtyp : redirected to 

}
