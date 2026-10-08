@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 - Journal Entry Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PUR_GST_FI_ITEM
  as select from    I_JournalEntry            as ACC

    inner join      I_OperationalAcctgDocItem as Item     on  Item.AccountingDocument   = ACC.AccountingDocument
                                                          and Item.FiscalYear           = ACC.FiscalYear
                                                          and Item.CompanyCode          = ACC.CompanyCode
                                                          and Item.FinancialAccountType = 'K'

    left outer join I_OperationalAcctgDocItem as glLine   on  glLine.AccountingDocument    = ACC.AccountingDocument
                                                          and glLine.FiscalYear            = ACC.FiscalYear
                                                          and glLine.CompanyCode           = ACC.CompanyCode
                                                          and glLine.ProfitLossAccountType = 'X'

    left outer join I_OperationalAcctgDocItem as igstLine on  igstLine.AccountingDocument           = ACC.AccountingDocument
                                                          and igstLine.FiscalYear                   = ACC.FiscalYear
                                                          and igstLine.CompanyCode                  = ACC.CompanyCode
                                                          and igstLine.TransactionTypeDetermination = 'JII'

    left outer join I_OperationalAcctgDocItem as cgstLine on  cgstLine.AccountingDocument           = ACC.AccountingDocument
                                                          and cgstLine.FiscalYear                   = ACC.FiscalYear
                                                          and cgstLine.CompanyCode                  = ACC.CompanyCode
                                                          and cgstLine.TransactionTypeDetermination = 'JIC'

    left outer join I_OperationalAcctgDocItem as sgstLine on  sgstLine.AccountingDocument           = ACC.AccountingDocument
                                                          and sgstLine.FiscalYear                   = ACC.FiscalYear
                                                          and sgstLine.CompanyCode                  = ACC.CompanyCode
                                                          and sgstLine.TransactionTypeDetermination = 'JIS'

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

         ACC.TransactionCurrency,

         /* ================= TAX ================= */

         @Semantics.amount.currencyCode: 'TransactionCurrency'
         igstLine.AbsltAmtInAdditionalCurrency1                         as igst_amount,

         @Semantics.amount.currencyCode: 'TransactionCurrency'
         cgstLine.AbsltAmtInAdditionalCurrency1                         as cgst_amount,

         @Semantics.amount.currencyCode: 'TransactionCurrency'
         sgstLine.AbsltAmtInAdditionalCurrency1                         as sgst_amount,

         @Semantics.amount.currencyCode: 'TransactionCurrency'
         sum( glLine.AbsltAmtInAdditionalCurrency1 )                    as taxable_value,

         cast( 0 as abap.dec(15,2) )                                    as cess_amount,

         cast ( sum ( taxRate.ConditionRateRatio ) as abap.dec(15,2)  ) as gst_rate,
         /* ================= PRODUCT ================= */

         ''                                                             as hsn_code,

         max ( glAcc.GLAccountName )                                    as product_name,

         ''                                                             as item_description,

         /* ================= QTY ================= */


         1                                                              as quantity,

         'OTH'                                                          as unit_of_product,

         /* ================= ITC ================= */

         cast( '' as abap.char(5) )                                     as itc_elgibity,
         cast( 0 as abap.dec(15,2) )                                    as igst_itc,
         cast( 0 as abap.dec(15,2) )                                    as cgst_itc,
         cast( 0 as abap.dec(15,2) )                                    as sgst_itc,
         cast( 0 as abap.dec(15,2) )                                    as cess_itc,

         /* ================= TDS ================= */

         cast( 0 as abap.dec(15,2) )                                    as igst_tds,
         cast( 0 as abap.dec(15,2) )                                    as cgst_tds,
         cast( 0 as abap.dec(15,2) )                                    as sgst_tds,

         /* ================= EXTRA ================= */

         cast( '' as abap.char(5) )                                     as inv_itc_elgibity,
         cast( '' as abap.char(10) )                                    as eligibility_category
}
group by
  ACC.AccountingDocument,
  ACC.CompanyCode,
  ACC.FiscalYear,
  Item.AccountingDocumentItem,
  igstLine.AbsltAmtInAdditionalCurrency1,
  cgstLine.AbsltAmtInAdditionalCurrency1,
  sgstLine.AbsltAmtInAdditionalCurrency1,
  ACC.TransactionCurrency,
  glAcc.GLAccountName
