@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'calculation for taxable value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define view entity  zmm_mat_cal_cons_def as select from I_MaterialDocumentItem_2 as item
{
key item.MaterialDocument as MaterialDocument,
key item.MaterialDocumentItem as Item,
key item.CompanyCode as CompanyCode,
key item.MaterialDocumentYear as FiscalYear,
item.CompanyCodeCurrency as CUR,
@Semantics.amount.currencyCode: 'CUR'
item.TotalGoodsMvtAmtInCCCrcy as AMOUNT,
@Semantics.amount.currencyCode: 'CUR'
cast( ( get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) + get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) * 35 / 100 ) as abap.dec(12,2) ) as percP,   
//@Semantics.amount.currencyCode: 'CUR'
//cast( get_numeric_value(item.TotalGoodsMvtAmtInCCCrcy ) / get_numeric_value(item.QuantityInEntryUnit) as abap.dec(12,2)) as CostP
  cast( get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) as abap.dec(15,2) ) as TotalGoodsMvtAmtInDEC,
  cast( get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) * 35 / 100 as abap.dec(12,2) ) as PercentageAmount,
  cast( ( get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) + 
          get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) * 35 / 100 ) as abap.dec(12,2) ) as TotalWithPercentage,
  cast( ( get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) + 
          get_numeric_value( item.TotalGoodsMvtAmtInCCCrcy ) * 35 / 100 ) * 25 / 100 as abap.dec(12,2) ) as DiscountAmount

}
