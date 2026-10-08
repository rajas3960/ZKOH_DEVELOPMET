@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Consumption Def'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
  }  
define root view entity ZMM_mat_cons_def as select from I_MaterialDocumentItem_2 as item
inner join I_MaterialDocumentHeader_2 as header on header.MaterialDocument = item.MaterialDocument
inner join ZTAX_CAL_MAT_CON as CAL_TAB on CAL_TAB.MaterialDocument = item.MaterialDocument and CAL_TAB.Item = item.MaterialDocumentItem
{
key item.MaterialDocument as MaterialDocument,
key item.MaterialDocumentItem as Item,
key item.CompanyCode as CompanyCode,
key item.MaterialDocumentYear as FiscalYear,
key header.PostingDate as PostingDate,
cast( header.PostingDate as abap.char(10) )  as POST_DATE,
header.MaterialDocumentHeaderText as headertext,
item.GoodsMovementType as MovementType,
item.Material as MaterialID,
item.Plant as Plant,
item.StorageLocation as StorageLocation,
item.Batch as BatchNumber, 
item.EntryUnit as UOM,  
@Semantics.quantity.unitOfMeasure: 'UOM'
item.QuantityInEntryUnit as ConsumptionQuantity, 
item.CompanyCodeCurrency as CUR,
@Semantics.amount.currencyCode: 'CUR'
item.TotalGoodsMvtAmtInCCCrcy as Amount,
@Semantics.amount.currencyCode: 'CUR'
cast( get_numeric_value(item.TotalGoodsMvtAmtInCCCrcy ) / get_numeric_value(item.QuantityInEntryUnit) as abap.dec(12,2)) as Cost,
@Semantics.amount.currencyCode: 'CUR'
cast( ( get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) + get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) * 35 / 100 ) as abap.dec(12,2) ) as perc,
@Semantics.amount.currencyCode: 'CUR'
cast( item.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2) ) as TotalGoodsMvtAmtInDEC,
//@Semantics.amount.currencyCode: 'CUR'
 // cast( ( CAL_TAB.TotalWithPercentage - CAL_TAB.DiscountAmount ) * 
   //     get_numeric_value( item.QuantityInEntryUnit ) as abap.dec(10,2) ) as COST_TAXABLE_VAL,
   
//   cast(  ( CAL_TAB.percP * 35 )   )
//cast( ( ( cast( ( get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) + 
//                  get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) * 35 / 100 ) as abap.dec(12,2) ) - 
//          cast( ( get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) + 
//                  get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) * 35 / 100 ) as abap.dec(12,2) ) * 25 / 100 ) * 
//          get_numeric_value( item.QuantityInEntryUnit ) ) as abap.dec( 20, 6 ) ) as COST_TAXABLE_VAL,    

//perc * 100 as valt,      
@Semantics.amount.currencyCode: 'CUR'
cast( ( cast( get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) as abap.dec(15,2) ) / cast( get_numeric_value( item.QuantityInEntryUnit ) as abap.dec(15,2) ) ) * 35  as abap.dec(12,2)  ) as costperc,
item.MaterialDocumentItemText as text
}where item.GoodsMovementType = '201' or item.GoodsMovementType = '202'
