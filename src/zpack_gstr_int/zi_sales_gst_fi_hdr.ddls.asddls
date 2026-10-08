@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 - FB70 Invoices - Header'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_SALES_GST_FI_HDR
  as select from    I_JournalEntry              as ACC

    left outer join I_OperationalAcctgDocItem   as Item    on  Item.AccountingDocument   = ACC.AccountingDocument
                                                           and Item.FiscalYear           = ACC.FiscalYear
                                                           and Item.CompanyCode          = ACC.CompanyCode
                                                           and Item.FinancialAccountType = 'D'
    left outer join I_Customer                  as cust    on cust.Customer = Item.Customer
    left outer join I_OperationalAcctgDocItem   as taxLine on  taxLine.AccountingDocument    = ACC.AccountingDocument
                                                           and taxLine.FiscalYear            = ACC.FiscalYear
                                                           and taxLine.CompanyCode           = ACC.CompanyCode
                                                           and taxLine.ProfitLossAccountType = 'X'
    left outer join I_IN_BusinessPlaceTaxDetail as gstin   on  gstin.CompanyCode   = Item.CompanyCode
                                                           and gstin.BusinessPlace = Item.BusinessPlace

  association [0..*] to ZI_SALES_GST_FI_ITEM as itemList on  itemList.AccountingDocument = ACC.AccountingDocument
                                                         and itemList.CompanyCode        = ACC.CompanyCode
                                                         and itemList.FiscalYear         = ACC.FiscalYear

{
  key ACC.AccountingDocument,
  key ACC.CompanyCode,
  key ACC.FiscalYear,
      ACC.AccountingDocument                                                  as document_number,
      ACC.PostingDate                                                         as document_date,
      Item.BusinessPlace,
      concat(
        ACC.AccountingDocument,
        ACC.CompanyCode
      )                                                                       as original_document_number,
      ACC.AccountingDocumentType,
      ACC.TransactionCurrency,
      ACC.DocumentDate,
      ACC.CreationTime,

      ACC.PostingDate                                                         as original_document_date,
      cast( '' as abap.char(20) )                                             as ref_document_number,
      cast( '00000000' as abap.dats )                                         as ref_document_date,
      
      max ( taxLine.ProfitCenter )                                            as ProfitCenter,


      'Add'                                                                   as invoice_status,


      case
        when Item.TaxCode = 'F0' or Item.TaxCode = 'F1' or Item.TaxCode = 'F2' then 'EMP'
        when Item.TaxCode = 'NT' then 'NRT'
        else 'NOR'
      end                                                                     as supply_type,

      case
          when cust.Country = 'IN' then
            case
                when ACC.AccountingDocumentType = 'DR' then 'TXN'
                when ACC.AccountingDocumentType = 'DG' then 'CDN'
                else ''
            end
          else 'EXP'
      end                                                                     as invoice_category,

      case
          when cust.Country = 'IN' then
                case
                  when ACC.AccountingDocumentType = 'DR' then 'R'
                  when ACC.AccountingDocumentType = 'DG' then 'B2B'
                  else ''
                end
             else
                 case
                  when Item.TaxCode = 'E0' then 'WOPAY'
                  when Item.TaxCode = 'E1' or Item.TaxCode = 'E2' or Item.TaxCode = 'E3' then 'WPAY'
                  else ''
                end

            end                                                               as invoice_type,

      cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2))               as total_invoice_value,

      cast( sum( ( taxLine.AmountInCompanyCodeCurrency ) ) as abap.dec(23,2)) as total_taxable_value,


      cast( 0 as abap.dec(15,2) )                                             as txpd_taxtable_value,

      /* ================= SHIPPING ================= */

      cast( '' as abap.char(20) )                                             as shipping_bill_number,
      cast( '00000000' as abap.dats )                                         as shipping_bill_date,
      cast( '' as abap.char(50) )                                             as reason,
      cast( '' as abap.char(10) )                                             as port_code,

      /* ================= LOCATION ================= */

      cast( '' as abap.char(10) )                                             as location,

      cast( '' as abap.char(6) )                                              as gstr1_return_period,
      cast( '' as abap.char(6) )                                              as gstr3b_return_period,

      /* ================= REVERSE CHARGE ================= */

      case
          when Item.TaxCode = 'J1'
            or Item.TaxCode = 'J2'
            or Item.TaxCode = 'J3'
            or Item.TaxCode = 'J4'
            or Item.TaxCode = 'J5'
            or Item.TaxCode = 'J6'
            or Item.TaxCode = 'RS'
            or Item.TaxCode = 'RN'
            or Item.TaxCode = 'J7'
            or Item.TaxCode = 'JA'
            or Item.TaxCode = 'J8'
            or Item.TaxCode = 'JB'
            or Item.TaxCode = 'RM'
            then 'Y'

          else 'N'

      end                                                                     as reverse_charge,

      /* ================= AMENDMENT ================= */

      'N'                                                                     as isamended,

      /* ================= GST ================= */

      substring( cust.TaxNumber3, 1, 2 )                                      as place_of_supply,
      gstin.IN_GSTIdentificationNumber                                        as supplier_gstin,

      cust.TaxNumber3                                                         as buyer_gstin,

      /* ================= NAME ================= */

      cust.CustomerName                                                       as customer_name,

      /* ================= E-COM ================= */
      cast( '' as abap.char(1) )                                              as sale_ecom_op,
      cast( '' as abap.char(20) )                                             as etin,

      /* ================= DATES ================= */
      ''                                                                      as original_month,

      /* ================= ADDITIONAL ================= */
      cast( '' as abap.char(6) )                                              as amended_period,
      cast( 0 as abap.dec(15,2) )                                             as amortised_cost,
      cast( '' as abap.char(20) )                                             as ecom_supplier_gstin,
      cast( '' as abap.char(20) )                                             as ostin,
      cast( '' as abap.char(10) )                                             as gl_code,
      cast( '' as abap.char(10) )                                             as amended_pos,
      cast( '' as abap.char(20) )                                             as taxpayer,
      cast( '' as abap.char(10) )                                             as opos,

      itemList

}
where
  (
       ACC.AccountingDocumentType = 'DR'
    or ACC.AccountingDocumentType = 'DG'
  )

group by
  ACC.AccountingDocument,
  ACC.CompanyCode,
  ACC.FiscalYear,
  ACC.PostingDate,
  ACC.TransactionCurrency,
  ACC.DocumentDate,
  ACC.CreationTime,
  Item.TaxCode,
  ACC.AccountingDocumentType,
  cust.TaxNumber3,
  gstin.IN_GSTIdentificationNumber,
  cust.CustomerName,
  cust.Country,
  Item.BusinessPlace,
  Item.AmountInCompanyCodeCurrency
