@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Contract PV'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_PURCHASE_CONTRACT_PV provider contract transactional_query as projection on ZMM_PURCHASE_CONTRACT
{
    key Purchase_Contract,
    key Item,
    PurchaseContractItemText,
    CompanyCode,
    Plant,
    Supplier,
    Material,
    MaterialType,
    MaterialGroup,
    OrderQuantityUnit,
    OrderPriceUnit,
    curr,
     @Semantics.amount.currencyCode: 'Curr'
    ContractNetPriceAmount,
    NetPriceQuantity,
    ValidityStartDate,
    ValidityEndDate
}
