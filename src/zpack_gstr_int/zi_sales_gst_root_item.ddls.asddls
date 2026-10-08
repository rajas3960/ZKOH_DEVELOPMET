@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Root Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZI_SALES_GST_ROOT_ITEM
  as select from ZI_SALES_GST_ITEM

{
  key BillingDocument,
  key CompanyCode,
  key FiscalYear,
  key BillingDocumentItem,
      TransactionCurrency,
      ProfitCenter,
      taxable_value,
      igst_amount,
      cgst_amount,
      sgst_amount,
      gst_rate,
      hsn_code,
      cast( quantity as abap.dec(13, 2) ) as quantity,
//      unit_of_product,
      item_description,
      user_desc,
      cess_amount

//      'BDOC'                              as ItemType
}

union all select from ZI_SALES_GST_FI_ITEM

{
  key AccountingDocument                                       as BillingDocument,
  key CompanyCode,
  key FiscalYear,
  key lpad(
      cast( AccountingDocumentItem as abap.char(3) ), 6, '0' ) as BillingDocumentItem,

      CompanyCodeCurrency                                      as TransactionCurrency,
      ''                                                       as ProfitCenter,
      abs( cast( taxable_value as abap.dec(23,2) ) )           as taxable_value,
      abs( cast( igst_amount as abap.dec(23,2) )  )            as igst_amount,
      abs( cast( cgst_amount as abap.dec(23,2) )  )            as cgst_amount,
      abs( cast( sgst_amount as abap.dec(23,2) )  )            as sgst_amount,
      gst_rate,
      hsn_code,
      quantity,
//      unit_of_product,
      item_description,
      ''                                                       as user_desc,
      cess_amount

//      'FB70'                                                   as ItemType
}
