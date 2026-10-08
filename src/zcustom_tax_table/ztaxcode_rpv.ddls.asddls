@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Taxcode root Projection View'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Ztaxcode_RPV
  provider contract transactional_query
  as projection on Ztaxcode_PV
{
  key Cntyregkey,
  key Taxcode,
  key Zprocedure,
  key Contype,
      Taxate,
      Taxtype,
      grmrp
      
      
}
 