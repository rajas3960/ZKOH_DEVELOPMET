@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN App Root view Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP02_IRV as select from zmm_app02_itb
association to parent ZMM_APP02_HRV as _HDR
  on $projection.Matnr = _HDR.Matnr
{
    key matnr as Matnr,
    key slno as Slno,
    hsn as Hsn,
    tax as Tax,
    @Semantics.user.createdBy: true
    createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    createdon as Createdon,
    _HDR
}
