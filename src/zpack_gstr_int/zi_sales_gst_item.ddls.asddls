@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Items for GST'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_SALES_GST_ITEM

  as select from    I_BillingDocumentItem as ITEM
    inner join      I_BillingDocument     as BD      on BD.BillingDocument = ITEM.BillingDocument

    left outer join ZI_SALES_PRICING      as pricing on  pricing.BillingDocument     = ITEM.BillingDocument
                                                     and pricing.BillingDocumentItem = ITEM.BillingDocumentItem

//    left outer join ZI_UOM_MAP            as UOM     on UOM.UomSap = ITEM.BaseUnit


  /* Product Plant for HSN */
    left outer join I_ProductPlantBasic   as PROD    on PROD.Product = ITEM.Product

{
      /* ================= KEY ================= */
  key ITEM.BillingDocument,
  key ITEM.CompanyCode,
  key BD.FiscalYear,
  key ITEM.BillingDocumentItem,

      ITEM.BillingQuantityUnit,
      ITEM.TransactionCurrency,
      ITEM.ProfitCenter,
      pricing.TaxableValue                as taxable_value,

      pricing.IgstAmount                  as igst_amount,

      pricing.CgstAmount                  as cgst_amount,

      pricing.SgstAmount                  as sgst_amount,

      pricing.GstRate                     as gst_rate,

      max ( PROD.ConsumptionTaxCtrlCode ) as hsn_code,

      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      ITEM.BillingQuantity                as quantity,

      /* ================= UNIT ================= */
//      case
//
//      when UOM.UomGst is not null
//           and UOM.UomGst <> ''
//      then UOM.UomGst
//
//      else 'OTH'
//      end                                 as unit_of_product,


      /* ================= OPTIONAL ================= */
      cast( '' as abap.char(100) )        as item_description,
      cast( '' as abap.char(100) )        as user_desc,
      cast( 0 as abap.dec(15,2) )         as cess_amount

}
group by
  ITEM.BillingDocument,
  ITEM.BillingDocumentItem,
  ITEM.BillingQuantityUnit,
  ITEM.TransactionCurrency,
  pricing.TaxableValue,
  pricing.IgstAmount,
  pricing.CgstAmount,
  pricing.SgstAmount,
  pricing.GstRate,
  ITEM.BillingQuantity,
//  UOM.UomGst,
  ITEM.ProfitCenter,
  ITEM.CompanyCode,
  BD.FiscalYear
