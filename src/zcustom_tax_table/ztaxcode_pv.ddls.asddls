
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'taxcode Projection View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Ztaxcode_PV
  as select from ZtaxCode_RE
{
      @EndUserText.label: 'Country Key'
  key Cntyregkey,
  key Taxcode,
  key Zprocedure,
  key Contype,
      Taxate,
      Taxtype,
      grmrp 
      
      
} 
