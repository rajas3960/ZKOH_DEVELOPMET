@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 - FB70 Invoices - Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_SALES_GST_FI_ITEM
  as select from    I_JournalEntry            as ACC

    inner join      I_OperationalAcctgDocItem as Item     on  Item.AccountingDocument   = ACC.AccountingDocument
                                                          and Item.FiscalYear           = ACC.FiscalYear
                                                          and Item.CompanyCode          = ACC.CompanyCode
                                                          and Item.FinancialAccountType = 'D'

    left outer join I_OperationalAcctgDocItem as glLine   on  glLine.AccountingDocument    = ACC.AccountingDocument
                                                          and glLine.FiscalYear            = ACC.FiscalYear
                                                          and glLine.CompanyCode           = ACC.CompanyCode
                                                          and glLine.ProfitLossAccountType = 'X'

    left outer join I_OperationalAcctgDocItem as igstLine on  igstLine.AccountingDocument           = ACC.AccountingDocument
                                                          and igstLine.FiscalYear                   = ACC.FiscalYear
                                                          and igstLine.CompanyCode                  = ACC.CompanyCode
                                                          and igstLine.TransactionTypeDetermination = 'JOI'

    left outer join I_OperationalAcctgDocItem as cgstLine on  cgstLine.AccountingDocument           = ACC.AccountingDocument
                                                          and cgstLine.FiscalYear                   = ACC.FiscalYear
                                                          and cgstLine.CompanyCode                  = ACC.CompanyCode
                                                          and cgstLine.TransactionTypeDetermination = 'JOC'

    left outer join I_OperationalAcctgDocItem as sgstLine on  sgstLine.AccountingDocument             = ACC.AccountingDocument
                                                          and sgstLine.FiscalYear                     = ACC.FiscalYear
                                                          and sgstLine.CompanyCode                    = ACC.CompanyCode
                                                          and (
                                                             sgstLine.TransactionTypeDetermination    = 'JOS'
                                                             or sgstLine.TransactionTypeDetermination = 'JOU'
                                                           )

    left outer join I_GLAccountTextRawData    as glAcc    on  glAcc.GLAccount       = glLine.GLAccount
                                                          and glAcc.ChartOfAccounts = glLine.ChartOfAccounts
                                                          and glAcc.Language        = 'E'

    left outer join I_TaxCodeRate             as taxRate  on  taxRate.TaxCode = Item.TaxCode
                                                          and taxRate.Country = 'IN'

{
  key    ACC.AccountingDocument,
  key    ACC.CompanyCode,
  key    ACC.FiscalYear,
  key    Item.AccountingDocumentItem,

         ACC.CompanyCodeCurrency,

         /* ================= TAX ================= */

         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         sum( distinct igstLine.AmountInCompanyCodeCurrency )                    as igst_amount,

         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         sum ( distinct cgstLine.AmountInCompanyCodeCurrency )                   as cgst_amount,

         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         sum ( distinct sgstLine.AmountInCompanyCodeCurrency )                   as sgst_amount,

         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         sum( distinct glLine.AmountInCompanyCodeCurrency )                      as taxable_value,

         cast( 0 as abap.dec(15,2) )                                             as cess_amount,

         cast ( sum ( distinct taxRate.ConditionRateRatio ) as abap.dec(15,2)  ) as gst_rate,
         /* ================= PRODUCT ================= */

         ''                                                                      as hsn_code,

         max ( glAcc.GLAccountName )                                             as product_name,

         max ( glAcc.GLAccountName )                                             as item_description,

         /* ================= QTY ================= */


         cast( 1 as abap.dec(13, 2))                                             as quantity,

         'OTH'                                                                   as unit_of_product
}
group by
  ACC.AccountingDocument,
  ACC.CompanyCode,
  ACC.FiscalYear,
  Item.AccountingDocumentItem,
  glAcc.GLAccountName,
  ACC.CompanyCodeCurrency
