@EndUserText.label: 'Purchase Contract'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_PURCHASE_CONTRACT
as select from I_PurchaseContractItemAPI01 as item
inner join I_PurchaseContractAPI01 as hdr on hdr.PurchaseContract = item.PurchaseContract
{
  key item.PurchaseContract as Purchase_Contract,
  key   item.PurchaseContractItem as Item,
  item.PurchaseContractItemText,
  hdr.CompanyCode,
  item.Plant,
  hdr.Supplier,
  item.Material,
  item.MaterialType,
  item.MaterialGroup,
  item.OrderQuantityUnit,
  item.OrderPriceUnit,
  item.DocumentCurrency as curr,
  @Semantics.amount.currencyCode: 'Curr'
  item.ContractNetPriceAmount,
  item.NetPriceQuantity,
  hdr.ValidityStartDate,
  hdr.ValidityEndDate
  
}
