@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase GST Root View - Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_PUR_GST_ROOT_ITEM
  as select from ZI_PURCHASE_GST_ITEM
{
  key SupplierInvoice,
  key FiscalYear,
  key CompanyCode,
  key SupplierInvoiceItem,
      DocumentCurrency,
      igst_amount,
      cgst_amount,
      sgst_amount,
      taxable_value,
      cess_amount,
      gst_rate,
      hsn_code,
      product_name,
      item_description,
      cast ( get_numeric_value(quantity) as abap.dec( 13, 3 ) ) as quantity,
//      unit_of_product,
      itc_elgibity,
      igst_itc,
      cgst_itc,
      sgst_itc,
      cess_itc,
      igst_tds,
      cgst_tds,
      sgst_tds,
      inv_itc_elgibity,
      eligibility_category
//      'MIRO'                                                    as ItemType

}


union all select from ZI_PUR_GST_FI_ITEM
{
  key AccountingDocument                      as SupplierInvoice,
  key FiscalYear,
  key CompanyCode,
  key lpad(
      cast( AccountingDocumentItem as abap.char(3) ),
      6,
      '0'
  )                                           as SupplierInvoiceItem,

      TransactionCurrency                     as DocumentCurrency,

      cast( igst_amount as abap.dec(23,2) )   as igst_amount,
      cast( cgst_amount as abap.dec(23,2) )   as cgst_amount,
      cast( sgst_amount as abap.dec(23,2) )   as sgst_amount,
      cast( taxable_value as abap.dec(23,2) ) as taxable_value,
      cast( 0 as abap.dec(15,2) )             as cess_amount,
      cast( gst_rate as abap.dec(15,2) )      as gst_rate,
      cast( '' as abap.char(16) )             as hsn_code,
      cast( product_name as abap.char(40) )   as product_name,
      cast( '' as abap.char(40) )             as item_description,
      cast( quantity as abap.dec(13,3) )      as quantity,
//      cast( unit_of_product as abap.char(4) ) as unit_of_product,
      itc_elgibity,
      igst_itc,
      cgst_itc,
      sgst_itc,
      cess_itc,
      igst_tds,
      cgst_tds,
      sgst_tds,
      inv_itc_elgibity,
      eligibility_category
//      'FB60'                                  as ItemType
}
