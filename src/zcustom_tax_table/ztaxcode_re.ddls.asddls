@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Code Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZtaxCode_RE
  as select from ztaxcodetb
{
  key cntyregkey as Cntyregkey,
  key taxcode    as Taxcode,
  key zprocedure as Zprocedure,
  key contype    as Contype,
      taxate     as Taxate,
      taxtype    as Taxtype,
      grmrp      as grmrp
      
      
      } 
