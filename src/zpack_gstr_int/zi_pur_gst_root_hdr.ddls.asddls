@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase GST Root View - Header'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_PUR_GST_ROOT_HDR
  as select from ZI_PURCHASE_GST_REP
  association [0..*] to ZI_PUR_GST_ROOT_ITEM as itemList on  itemList.SupplierInvoice = ZI_PURCHASE_GST_REP.document_number
                                                         and itemList.CompanyCode     = ZI_PURCHASE_GST_REP.CompanyCode
                                                         and itemList.FiscalYear      = ZI_PURCHASE_GST_REP.FiscalYear
{
  key document_number,
  key CompanyCode,
  key FiscalYear,

      document_date,
      original_document_number,
      DocumentCurrency,
      CreationDate,
      CreationTime,
      original_document_date,
      ref_document_number,
      ref_document_date,

      supply_type,
      invoice_status,
      invoice_category,
      invoice_type,

      total_invoice_value,
      total_taxable_value,
      txpd_taxtable_value,

      shipping_bill_number,
      shipping_bill_date,
      reason,
      port_code,
      location,

      gstr2_return_period,
      gstr3b_return_period,

      reverse_charge,
      isamended,
      amended_pos,
      amended_period,
      place_of_supply,

      supplier_gstin,
      buyer_gstin,
      customer_name,

      erp_document_number,
      erp_document_date,
      transaction_number,

      issez,
      sez_gstin,
      gl_code,

      gstr7_return_period,
      gstr7_amend_type,
      original_gstin_of_supplier,

      amortised_cost,
      inv_itc_elgibity,

      payment_status,
      paid_amount,
      
      'MIRO' as InvType,

      /* Associations */
      itemList
}

union all

select from ZI_PUR_GST_FI_HDR

association [0..*] to ZI_PUR_GST_ROOT_ITEM as itemList on  itemList.SupplierInvoice = ZI_PUR_GST_FI_HDR.document_number
                                                       and itemList.CompanyCode     = ZI_PUR_GST_FI_HDR.CompanyCode
                                                       and itemList.FiscalYear      = ZI_PUR_GST_FI_HDR.FiscalYear
{
  key document_number,
  key CompanyCode,
  key FiscalYear,

      document_date,
      original_document_number,
      TransactionCurrency as DocumentCurrency,
      DocumentDate        as CreationDate,
      CreationTime,
      original_document_date,
      ref_document_number,
      ref_document_date,

      supply_type,
      invoice_status,
      invoice_category,
      invoice_type,

      total_invoice_value,
      total_taxable_value,
      txpd_taxtable_value,

      shipping_bill_number,
      shipping_bill_date,
      reason,
      port_code,
      location,

      gstr2_return_period,
      gstr3b_return_period,

      reverse_charge,
      isamended,
      amended_pos,
      amended_period,
      place_of_supply,

      supplier_gstin,
      buyer_gstin,
      customer_name,

      erp_document_number,
      erp_document_date,
      transaction_number,

      issez,
      sez_gstin,
      gl_code,

      gstr7_return_period,
      gstr7_amend_type,
      original_gstin_of_supplier,

      amortised_cost,
      inv_itc_elgibity,

      payment_status,
      paid_amount,
      
      'FB60' as InvType,

      itemList
}
