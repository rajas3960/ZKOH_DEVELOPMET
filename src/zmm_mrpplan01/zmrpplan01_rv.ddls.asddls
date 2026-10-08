@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Creation - Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMRPPLAN01_RV
  as select from zmrpplan01_tb1
{
  key recguid                  as Recguid,
      doctype                  as Doctype,      
      srcdtm                   as Srcdtm,
      dtyptxt                  as Dtyptxt,
      totprrec                 as Totprrec,
      totprcrt                 as Totprcrt,
      totporec                 as Totporec,
      totpocrt                 as Totpocrt,
      @Semantics.systemDateTime.createdAt: true
      createdat                as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchngby               as Lastchngby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchngat               as Lastchngat,
      @Semantics.user.createdBy: true
      createdby                as Createdby,
      status                   as Status
}
