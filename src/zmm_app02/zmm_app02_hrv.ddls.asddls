@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN App Root view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP02_HRV as select from zmm_app02_tb
composition[0..*] of ZMM_APP02_IRV as _ITEM
{
    key matnr as Matnr,
    hsn as Hsn,
    tax as Tax,
    @Semantics.user.createdBy: true
    createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    createdon as Createdon,
    @Semantics.user.lastChangedBy: true
    lastchngby as Lastchngby,
    @Semantics.systemDateTime.lastChangedAt: true
    lastchngat as Lastchngat,
    status as Status,
    _ITEM
}
