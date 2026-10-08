@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Consumption Proj'
define root view entity ZMM_mat_cons_PROJ 
provider contract transactional_query 
as projection on ZMM_mat_cons_def
{
    key MaterialDocument,
    key Item,
    key CompanyCode,
    key FiscalYear,
    key PostingDate,
    POST_DATE,
    headertext,
    MovementType,
    MaterialID,
    Plant,
    StorageLocation,
    BatchNumber,
    UOM,
    @Semantics.quantity.unitOfMeasure: 'UOM'
    ConsumptionQuantity,
    CUR,
    @Semantics.amount.currencyCode: 'CUR'
    Amount,
    @Semantics.amount.currencyCode: 'CUR'
    Cost,
    @Semantics.amount.currencyCode: 'CUR'  
    perc,
    @Semantics.amount.currencyCode: 'CUR' 
    costperc,
//   @Semantics.amount.currencyCode: 'CUR'
//   COST_TAXABLE_VAL,
    text
}
