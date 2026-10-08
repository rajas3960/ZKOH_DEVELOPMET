@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 - Journal Entry header'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PUR_GST_FI_HDR
  as select from    I_JournalEntry              as ACC

    left outer join I_OperationalAcctgDocItem   as Item    on  Item.AccountingDocument   = ACC.AccountingDocument
                                                           and Item.FiscalYear           = ACC.FiscalYear
                                                           and Item.CompanyCode          = ACC.CompanyCode
                                                           and Item.FinancialAccountType = 'K'
    left outer join I_Supplier                  as sup     on sup.Supplier = Item.Supplier
    left outer join I_OperationalAcctgDocItem   as taxLine on  taxLine.AccountingDocument    = ACC.AccountingDocument
                                                           and taxLine.FiscalYear            = ACC.FiscalYear
                                                           and taxLine.CompanyCode           = ACC.CompanyCode
                                                           and taxLine.ProfitLossAccountType = 'X'
    left outer join I_IN_BusinessPlaceTaxDetail as gstin   on  gstin.CompanyCode   = Item.CompanyCode
                                                           and gstin.BusinessPlace = Item.BusinessPlace

  association [0..*] to ZI_PUR_GST_FI_ITEM as itemList on  itemList.AccountingDocument = ACC.AccountingDocument
                                                       and itemList.CompanyCode        = ACC.CompanyCode
                                                       and itemList.FiscalYear         = ACC.FiscalYear

{
  key ACC.AccountingDocument                                                as document_number,
  key ACC.CompanyCode,
  key ACC.FiscalYear,

      ACC.PostingDate                                                       as document_date,

      concat(
        ACC.AccountingDocument,
        ACC.CompanyCode
      )                                                                     as original_document_number,

      ACC.TransactionCurrency,
      ACC.DocumentDate,
      ACC.CreationTime,

      ACC.PostingDate                                                       as original_document_date,
      cast( '' as abap.char(20) )                                           as ref_document_number,
      cast( '00000000' as abap.dats )                                       as ref_document_date,


      'Add'                                                                 as invoice_status,

      case
        when taxLine.TaxCode = 'G0' or taxLine.TaxCode = 'G1' or taxLine.TaxCode = 'G2' then 'EMP'
        when taxLine.TaxCode = 'NT' then 'NRT'
        else 'NOR'
      end                                                                    as supply_type,

      case
        when ACC.AccountingDocumentType = 'KR' then 'TXN'
        when ACC.AccountingDocumentType = 'KG' then 'CDN'
        else ''
      end                                                                   as invoice_category,

      case
        when ACC.AccountingDocumentType = 'KR' then 'R'
        when ACC.AccountingDocumentType = 'KG' then 'B2B'
        else ''
      end                                                                   as invoice_type,

      cast( Item.AbsltAmtInAdditionalCurrency1 as abap.dec(23,2))           as total_invoice_value,

      cast( sum( taxLine.AbsltAmtInAdditionalCurrency1 ) as abap.dec(23,2)) as total_taxable_value,


      cast( 0 as abap.dec(15,2) )                                           as txpd_taxtable_value,

      /* ================= SHIPPING ================= */

      cast( '' as abap.char(20) )                                           as shipping_bill_number,
      cast( '00000000' as abap.dats )                                       as shipping_bill_date,
      cast( '' as abap.char(50) )                                           as reason,
      cast( '' as abap.char(10) )                                           as port_code,

      /* ================= LOCATION ================= */

      cast( '' as abap.char(10) )                                           as location,

      cast( '' as abap.char(10) )                                           as gstr2_return_period,
      cast( '' as abap.char(10) )                                           as gstr3b_return_period,

      /* ================= REVERSE CHARGE ================= */

      case
          when taxLine.TaxCode = 'J1'
            or taxLine.TaxCode = 'J2'
            or taxLine.TaxCode = 'J3'
            or taxLine.TaxCode = 'J4'
            or taxLine.TaxCode = 'J5'
            or taxLine.TaxCode = 'J6'
            then 'Y'
          else 'N'
      end                                                                   as reverse_charge,

      /* ================= AMENDMENT ================= */

      'N'                                                                   as isamended,
      cast( '' as abap.char(5) )                                            as amended_pos,
      cast( '' as abap.char(10) )                                           as amended_period,

      /* ================= GST ================= */

      substring( sup.TaxNumber3, 1, 2 )                                     as place_of_supply,
      sup.TaxNumber3                                                        as supplier_gstin,

      gstin.IN_GSTIdentificationNumber                                      as buyer_gstin,

      /* ================= NAME ================= */

      sup.SupplierName                                                      as customer_name,

      /* ================= EXTRA ================= */

      cast( '' as abap.char(20) )                                           as erp_document_number,
      cast( '00000000' as abap.dats )                                       as erp_document_date,
      cast( '' as abap.char(20) )                                           as transaction_number,

      cast( '' as abap.char(1) )                                            as issez,
      cast( '' as abap.char(15) )                                           as sez_gstin,
      cast( '' as abap.char(10) )                                           as gl_code,

      cast( '' as abap.char(10) )                                           as gstr7_return_period,
      cast( '' as abap.char(10) )                                           as gstr7_amend_type,

      cast( '' as abap.char(15) )                                           as original_gstin_of_supplier,

      /* ================= PAGE 2 FIELDS ================= */

      cast( 0 as abap.dec(15,2) )                                           as amortised_cost,
      cast( '' as abap.char(5) )                                            as inv_itc_elgibity,
      cast( '' as abap.char(10) )                                           as payment_status,
      cast( 0 as abap.dec(15,2) )                                           as paid_amount,

      itemList

}
where
  (
       ACC.AccountingDocumentType = 'KR'
    or ACC.AccountingDocumentType = 'KG'
  )

group by
  ACC.AccountingDocument,
  ACC.CompanyCode,
  ACC.FiscalYear,
  ACC.PostingDate,
  ACC.TransactionCurrency,
  ACC.DocumentDate,
  ACC.CreationTime,
  taxLine.TaxCode,
  ACC.AccountingDocumentType,
  sup.TaxNumber3,
  gstin.IN_GSTIdentificationNumber,
  sup.SupplierName,
  Item.AbsltAmtInAdditionalCurrency1
