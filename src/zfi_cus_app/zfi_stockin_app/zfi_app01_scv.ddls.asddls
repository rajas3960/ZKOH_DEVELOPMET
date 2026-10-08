@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Work Order - SCV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_APP01_SCV as select from zfi_app01_tb3
  association to parent ZFI_APP01_RV as _Header on $projection.Uuid = _Header.Uuid  
{
    key uuid as Uuid,
    key poorder as Poorder,
    key poitem as Poitem,
    materialnumber as Materialnumber,
    productdes as Productdes,
    createdby as Createdby,
    createdat as Createdat,
    lastchangedby as Lastchangedby,
    lastchangedat as Lastchangedat,
    _Header
}
