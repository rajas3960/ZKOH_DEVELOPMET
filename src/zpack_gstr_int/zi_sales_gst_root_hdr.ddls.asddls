@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Root Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SALES_GST_ROOT_HDR
  as select from ZI_SALES_GST_REP

  association [0..*] to ZI_SALES_GST_ROOT_ITEM as itemList on  itemList.BillingDocument = ZI_SALES_GST_REP.BillingDocument
                                                           and itemList.CompanyCode     = ZI_SALES_GST_REP.CompanyCode
                                                           and itemList.FiscalYear      = ZI_SALES_GST_REP.FiscalYear
{
  key BillingDocument,
  key CompanyCode,
  key FiscalYear,
      document_number,
      document_date,
      BillingDocumentType,
      BillingDocumentDate,
      CreationDate,
      CreationTime,
      BusinessPlace,
      original_document_number,
      original_document_date,
      ProfitCenter,
      ref_document_number,
      ref_document_date,
      TransactionCurrency,
      supply_type,
      invoice_status,
      invoice_category,
      invoice_type,
      abs( total_invoice_value ) as total_invoice_value,
      abs( total_taxable_value ) as total_taxable_value,
      txpd_taxtable_value,
      shipping_bill_number,
      shipping_bill_date,
      reason,
      port_code,
      location,
      gstr1_return_period,
      gstr3b_return_period,
      reverse_charge,
      isamended,
      supplier_gstin,
      buyer_gstin,
      place_of_supply,
      customer_name,
      sale_ecom_op,
      etin,
      original_month,
      amended_period,
      amortised_cost,
      ecom_supplier_gstin,
      ostin,
      gl_code,
      amended_pos,
      taxpayer,
      opos,

      'BDOC' as InvType,

      itemList
}
union all select from ZI_SALES_GST_FI_HDR

association [0..*] to ZI_SALES_GST_ROOT_ITEM as itemList on  itemList.BillingDocument = ZI_SALES_GST_FI_HDR.AccountingDocument
                                                         and itemList.CompanyCode     = ZI_SALES_GST_FI_HDR.CompanyCode
                                                         and itemList.FiscalYear      = ZI_SALES_GST_FI_HDR.FiscalYear
{
  key AccountingDocument     as BillingDocument,
  key CompanyCode,
  key FiscalYear,

      document_number,
      document_date,
      AccountingDocumentType as BillingDocumentType,
      document_date          as BillingDocumentDate,
      '00000000'             as CreationDate,
      ''                     as CreationTime,
      BusinessPlace,
      original_document_number,
      original_document_date,
      ProfitCenter,
      ref_document_number,
      ref_document_date,
      TransactionCurrency,
      supply_type,
      invoice_status,
      invoice_category,
      invoice_type,
      abs( total_invoice_value ) as total_invoice_value,
      abs( total_taxable_value ) as total_taxable_value,
      txpd_taxtable_value,
      shipping_bill_number,
      shipping_bill_date,
      reason,
      port_code,
      location,
      gstr1_return_period,
      gstr3b_return_period,
      reverse_charge,
      isamended,
      supplier_gstin,
      buyer_gstin,
      place_of_supply,
      customer_name,
      sale_ecom_op,
      etin,
      original_month,
      amended_period,
      amortised_cost,
      ecom_supplier_gstin,
      ostin,
      gl_code,
      amended_pos,
      taxpayer,
      opos,

      'FB70'                 as InvType,

      itemList
}
