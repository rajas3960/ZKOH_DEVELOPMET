@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Items for GST'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_PURCHASE_GST_ITEM
  as select from    I_SuplrInvcItemPurOrdRefAPI01 as ITEM

    inner join      I_SupplierInvoiceAPI01        as INV   on INV.SupplierInvoice = ITEM.SupplierInvoice

    left outer join I_ProductPlantBasic           as PROD  on  PROD.Product = ITEM.PurchaseOrderItemMaterial
                                                           and PROD.Plant   = ITEM.Plant

    left outer join I_ProductDescription          as DESC  on  DESC.Product  = ITEM.PurchaseOrderItemMaterial
                                                           and DESC.Language = 'E'

//    left outer join ZI_UOM_MAP                    as UOM   on UOM.UomSap = ITEM.PurchaseOrderQuantityUnit


    left outer join I_TaxCodeRate                 as _IGST on  _IGST.Country          = 'IN'
                                                           and _IGST.TaxCode          = ITEM.TaxCode
                                                           and _IGST.VATConditionType = 'JIIG'

    left outer join I_TaxCodeRate                 as _CGST on  _CGST.Country          = 'IN'
                                                           and _CGST.TaxCode          = ITEM.TaxCode
                                                           and _CGST.VATConditionType = 'JICG'

    left outer join I_TaxCodeRate                 as _SGST on  _SGST.Country          = 'IN'
                                                           and _SGST.TaxCode          = ITEM.TaxCode
                                                           and _SGST.VATConditionType = 'JISG'

{
      /* ================= KEYS ================= */

  key ITEM.SupplierInvoice,
  key ITEM.FiscalYear,
  key INV.CompanyCode,
  key ITEM.SupplierInvoiceItem,
      ITEM.DocumentCurrency,
      ITEM.PurchaseOrderQuantityUnit,

      /* ================= TAX ================= */


      case
        when ITEM.DocumentCurrency <> 'INR'
        then cast(
               curr_to_decfloat_amount( ITEM.SupplierInvoiceItemAmount )
               * get_numeric_value( _IGST.ConditionRateRatio ) / 100
               * cast( INV.ExchangeRate as abap.dec(9,5) )
               * 100
               as abap.dec(23,2)
             )
        else cast(
               curr_to_decfloat_amount( ITEM.SupplierInvoiceItemAmount )
               * get_numeric_value( _IGST.ConditionRateRatio ) / 100
               as abap.dec(23,2)
             )
      end                              as igst_amount,


      case
        when ITEM.DocumentCurrency <> 'INR'
        then cast(
               curr_to_decfloat_amount( ITEM.SupplierInvoiceItemAmount )
               * get_numeric_value( _CGST.ConditionRateRatio ) / 100
               * cast( INV.ExchangeRate as abap.dec(9,5) )
               * 100
               as abap.dec(23,2)
             )
        else cast(
               curr_to_decfloat_amount( ITEM.SupplierInvoiceItemAmount )
               * get_numeric_value( _CGST.ConditionRateRatio ) / 100
               as abap.dec(23,2)
             )
      end                              as cgst_amount,


      case
        when ITEM.DocumentCurrency <> 'INR'
        then cast(
               curr_to_decfloat_amount( ITEM.SupplierInvoiceItemAmount )
               * get_numeric_value( _SGST.ConditionRateRatio ) / 100
               * cast( INV.ExchangeRate as abap.dec(9,5) )
               * 100
               as abap.dec(23,2)
             )
        else cast(
               curr_to_decfloat_amount( ITEM.SupplierInvoiceItemAmount )
               * get_numeric_value( _SGST.ConditionRateRatio ) / 100
               as abap.dec(23,2)
             )
      end                              as sgst_amount,


      case
        when ITEM.DocumentCurrency <> 'INR'
        then cast(
               curr_to_decfloat_amount( ITEM.SupplierInvoiceItemAmount  )
               * cast( INV.ExchangeRate as abap.dec(9,5) )
               * 100
               as abap.dec(23,2)
             )
        else cast(
               ITEM.SupplierInvoiceItemAmount as abap.dec(23,2)
             )
      end                              as taxable_value,

      cast( 0 as abap.dec(15,2) )      as cess_amount,

      cast(
      case
      when _IGST.ConditionRateRatio is not null
       then _IGST.ConditionRateRatio

      else coalesce( _CGST.ConditionRateRatio, 0 )
      + coalesce( _SGST.ConditionRateRatio, 0 )

      end
      as abap.dec(15,2)
      )                                as gst_rate,
      /* ================= PRODUCT ================= */

      PROD.ConsumptionTaxCtrlCode      as hsn_code,

      ITEM.PurchaseOrderItemMaterial   as product_name,

      DESC.ProductDescription          as item_description,

      /* ================= QTY ================= */

      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      ITEM.QuantityInPurchaseOrderUnit as quantity,

//      case
//      when UOM.UomGst is not null
//           and UOM.UomGst <> ''
//      then UOM.UomGst
//      else 'OTH'
//      end                              as unit_of_product,

      /* ================= ITC ================= */

      cast( '' as abap.char(5) )       as itc_elgibity,
      cast( 0 as abap.dec(15,2) )      as igst_itc,
      cast( 0 as abap.dec(15,2) )      as cgst_itc,
      cast( 0 as abap.dec(15,2) )      as sgst_itc,
      cast( 0 as abap.dec(15,2) )      as cess_itc,

      /* ================= TDS ================= */

      cast( 0 as abap.dec(15,2) )      as igst_tds,
      cast( 0 as abap.dec(15,2) )      as cgst_tds,
      cast( 0 as abap.dec(15,2) )      as sgst_tds,

      /* ================= EXTRA ================= */

      cast( '' as abap.char(5) )       as inv_itc_elgibity,
      cast( '' as abap.char(10) )      as eligibility_category

}
