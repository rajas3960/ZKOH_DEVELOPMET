@EndUserText.label: 'Projection View of Customer Led Stat'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }


define root view entity ZFI_CUST_LEG_STAT_PROJECTION
provider contract transactional_query
as projection on ZFI_CUST_LEG_STAT
{
    key custer,
    cc,
   // doctype,
  //  docdt,
    text,
  //  invref,
    curry,
    @Semantics.amount.currencyCode: 'curry' 
    amount,
    custname
}
