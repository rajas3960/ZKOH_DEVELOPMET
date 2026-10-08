@AbapCatalog.sqlViewName: 'ZI_GSTR1_SEND_SQ'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for sending data to MI Portal'
@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
define view ZI_GSTR1_SEND_MI
  as select distinct from I_JournalEntryItem as JournalItem
  association [0..1] to I_JournalEntryItem as GetSupplier  on  JournalItem.CompanyCode          =  GetSupplier.CompanyCode
                                                           and JournalItem.FiscalYear           =  GetSupplier.FiscalYear
                                                           and JournalItem.AccountingDocument   =  GetSupplier.AccountingDocument
                                                           and GetSupplier.FinancialAccountType =  'K'
                                                           and GetSupplier.Supplier             <> ''
  association [0..1] to ZJOURNALENTRY_CDS  as JOURNAL_Spec on  $projection.AccountingDocument             = JOURNAL_Spec.AccountingDocument
                                                           and JournalItem.PurchasingDocument             = JOURNAL_Spec.PurchasingDocument
                                                           and JournalItem.CompanyCode                    = JOURNAL_Spec.CompanyCode
                                                           and JournalItem.FiscalYear                     = JOURNAL_Spec.FiscalYear
                                                           and JournalItem.LedgerGLLineItem               = JOURNAL_Spec.AccountingDocumentItem
                                                           and (
                                                              JournalItem.TransactionTypeDetermination    = 'KBS'
                                                              or JournalItem.TransactionTypeDetermination = 'WRX'
                                                            )

{
  key JournalItem.AccountingDocument                       as AccountingDocument,
  key JournalItem.LedgerGLLineItem                         as AccountingDocumentItem,
  key JournalItem.PurchasingDocument                       as PurchasingDocument,
  key JournalItem.FiscalYear                               as FiscalYear,
  key JournalItem.CompanyCode                              as Companycode,
      JournalItem.AccountingDocumentItem                   as JournalEntryItem,
      JournalItem.PostingDate                              as PostingDate,
      JournalItem.Plant                                    as Plant,
      JournalItem.DocumentDate                             as Doc_date,
      substring( JournalItem.AccountingDocument , 1 ,  2 ) as DocNum,
      JournalItem.PurchasingDocumentItem                   as PurchasingDocumentItem,
      JournalItem.DebitCreditCode                          as DebitCreditCode,
      JournalItem.ReferenceDocument                        as ReferenceDocumentMIRO,
      JournalItem.ReferenceDocumentItem                    as ReferenceDocumentItem,
      JournalItem.TaxCode                                  as TaxCode,
      JournalItem.TransactionTypeDetermination             as TransactionTypeDetermination,
      @Semantics.amount.currencyCode: 'Compcurr'
      case when JournalItem.TransactionTypeDetermination = ' ' then
      JournalItem.AmountInCompanyCodeCurrency
      else
      case when  JournalItem.TransactionTypeDetermination = 'KBS' or
                 JournalItem.TransactionTypeDetermination = 'WRX' then
      JOURNAL_Spec.amcomp
      else
      JournalItem.AmountInCompanyCodeCurrency end end      as AMCOMP,
      JOURNAL_Spec.amcomp                                  as AMCOMP_SPEC,
      JournalItem.AccountingDocumentItem                   as AccItem,
      JournalItem.FinancialAccountType                     as Acctype,
      JournalItem.GLAccount                                as GLCode,
      JournalItem.CompanyCodeCurrency                      as Compcurr,
      JournalItem.PostingDate                              as PostData,
      GetSupplier.Supplier                                 as Supplier,
      JournalItem.AccountingDocumentType                   as AccountingDocumentType

}
where
        JournalItem.Ledger                       =  '0L'
  and   JournalItem.OffsettingAccount            <> ''
  and(
        JournalItem.AccountingDocumentType       =  'KR'
    or  JournalItem.AccountingDocumentType       =  'KG'
    or  JournalItem.AccountingDocumentType       =  'RE'
    or  JournalItem.AccountingDocumentType       =  'KZ' // +Add 02/09/24 krishna
  )
  and   JournalItem.AmountInCompanyCodeCurrency  <> 0
  and   JournalItem.TransactionTypeDetermination <> 'JII'
  and   JournalItem.TransactionTypeDetermination <> 'JIC'
  and   JournalItem.TransactionTypeDetermination <> 'JIS'
  and   JournalItem.TransactionTypeDetermination <> 'JRC'
  and   JournalItem.TransactionTypeDetermination <> 'JRS'
  and   JournalItem.TransactionTypeDetermination <> 'JRI'
  and   JournalItem.TaxCode                      <> 'G0'

  and   JournalItem.FinancialAccountType         =  'S'
  and   JournalItem.TransactionTypeDetermination <> 'WIT'
  and(
        JournalItem.GLAccount                    <> '0000500004'
    and JournalItem.GLAccount                    <> '0000500005'
    and JournalItem.GLAccount                    <> '0000500006'
    and JournalItem.GLAccount                    <> '0000500008'
    and JournalItem.GLAccount                    <> '0000500010'
    and JournalItem.GLAccount                    <> '0000500011'
    and JournalItem.GLAccount                    <> '0000500012'
    and JournalItem.GLAccount                    <> '0000500013'
    and JournalItem.GLAccount                    <> '0000501500'
    and JournalItem.GLAccount                    <> '0000501600'
    and JournalItem.GLAccount                    <> '0000501700'
    and JournalItem.GLAccount                    <> '0000503000'
    and JournalItem.GLAccount                    <> '0000503001'
    and JournalItem.GLAccount                    <> '0000503002'
    and JournalItem.GLAccount                    <> '0000503003'
    and JournalItem.GLAccount                    <> '0000503004'
    and JournalItem.GLAccount                    <> '0000503005'
    and JournalItem.GLAccount                    <> '0000503006'
    and JournalItem.GLAccount                    <> '0000503007'
    and JournalItem.GLAccount                    <> '0000503008'
    and JournalItem.GLAccount                    <> '0000503009'
    and JournalItem.GLAccount                    <> '0000503010'
    and JournalItem.GLAccount                    <> '0000503011'
    and JournalItem.GLAccount                    <> '0000504000'
    and JournalItem.GLAccount                    <> '0000504001'
    and JournalItem.GLAccount                    <> '0000504100'
    and JournalItem.GLAccount                    <> '0000505000'
    and JournalItem.GLAccount                    <> '0000506000'
    and JournalItem.GLAccount                    <> '0000506010'
    and JournalItem.GLAccount                    <> '0000506020'
    and JournalItem.GLAccount                    <> '0000508000'
    and JournalItem.GLAccount                    <> '0000508500'
    and JournalItem.GLAccount                    <> '0000509100'
    and JournalItem.GLAccount                    <> '0000600001'
    and JournalItem.GLAccount                    <> '0000600002'
    and JournalItem.GLAccount                    <> '0000600003'
    and JournalItem.GLAccount                    <> '0000600004'
    and JournalItem.GLAccount                    <> '0000600005'
    and JournalItem.GLAccount                    <> '0000600006'
    and JournalItem.GLAccount                    <> '0000600007'
    and JournalItem.GLAccount                    <> '0000600008'
    and JournalItem.GLAccount                    <> '0000600009'
    and JournalItem.GLAccount                    <> '0000600010'
    and JournalItem.GLAccount                    <> '0000600011'
    and JournalItem.GLAccount                    <> '0000600100'
    and JournalItem.GLAccount                    <> '0000600200'
    and JournalItem.GLAccount                    <> '0000600210'
    and JournalItem.GLAccount                    <> '0000600300'
    and JournalItem.GLAccount                    <> '0000600400'
    and JournalItem.GLAccount                    <> '0000600500'
    and JournalItem.GLAccount                    <> '0000600510'
    and JournalItem.GLAccount                    <> '0000600520'
    and JournalItem.GLAccount                    <> '0000600600'
    and JournalItem.GLAccount                    <> '0000600700'
    and JournalItem.GLAccount                    <> '0000601000'
    and JournalItem.GLAccount                    <> '0000601010'
    and JournalItem.GLAccount                    <> '0000601100'
    and JournalItem.GLAccount                    <> '0000601200'
    and JournalItem.GLAccount                    <> '0000602000'
    and JournalItem.GLAccount                    <> '0000603000'
    and JournalItem.GLAccount                    <> '0000603010'
    and JournalItem.GLAccount                    <> '0000603020'
    and JournalItem.GLAccount                    <> '0000603040'
    and JournalItem.GLAccount                    <> '0000605010'
    and JournalItem.GLAccount                    <> '0000605020'
    and JournalItem.GLAccount                    <> '0000605025'
    and JournalItem.GLAccount                    <> '0000605030'
    and JournalItem.GLAccount                    <> '0000605060'
    and JournalItem.GLAccount                    <> '0000605061'
    and JournalItem.GLAccount                    <> '0000605062'
    and JournalItem.GLAccount                    <> '0000605090'
    and JournalItem.GLAccount                    <> '0000605091'
    and JournalItem.GLAccount                    <> '0000605092'
    and JournalItem.GLAccount                    <> '0000605100'
    and JournalItem.GLAccount                    <> '0000605101'
    and JournalItem.GLAccount                    <> '0000605110'
    and JournalItem.GLAccount                    <> '0000605111'
    and JournalItem.GLAccount                    <> '0000605112'
    and JournalItem.GLAccount                    <> '0000605124'
    and JournalItem.GLAccount                    <> '0000605125'
    and JournalItem.GLAccount                    <> '0000605126'
    and JournalItem.GLAccount                    <> '0000605127'
    and JournalItem.GLAccount                    <> '0000605170'
    and JournalItem.GLAccount                    <> '0000605181'
    and JournalItem.GLAccount                    <> '0000606020'
    and JournalItem.GLAccount                    <> '0000606060'
    and JournalItem.GLAccount                    <> '0000606090'
    and JournalItem.GLAccount                    <> '0000606260'
    and JournalItem.GLAccount                    <> '0000606270'
    and JournalItem.GLAccount                    <> '0000606280'
    and JournalItem.GLAccount                    <> '0000606290'
    and JournalItem.GLAccount                    <> '0000606300'
    and JournalItem.GLAccount                    <> '0000606310'
    and JournalItem.GLAccount                    <> '0000606320'
    and JournalItem.GLAccount                    <> '0000606330'
    and JournalItem.GLAccount                    <> '0000606340'
    and JournalItem.GLAccount                    <> '0000606350'
    and JournalItem.GLAccount                    <> '0000606360'
    and JournalItem.GLAccount                    <> '0000606371'
    and JournalItem.GLAccount                    <> '0000606390'
    and JournalItem.GLAccount                    <> '0000606400'
    and JournalItem.GLAccount                    <> '0000606410'
    and JournalItem.GLAccount                    <> '0000606420'
    and JournalItem.GLAccount                    <> '0000606430'
    and JournalItem.GLAccount                    <> '0000606440'
    and JournalItem.GLAccount                    <> '0000606450'
    and JournalItem.GLAccount                    <> '0000606460'
    and JournalItem.GLAccount                    <> '0000606510'
    and JournalItem.GLAccount                    <> '0000606530'
    and JournalItem.GLAccount                    <> '0000606600'
    and JournalItem.GLAccount                    <> '0000606601'
    and JournalItem.GLAccount                    <> '0000606610'
    and JournalItem.GLAccount                    <> '0000606630'
    and JournalItem.GLAccount                    <> '0000606640'
    and JournalItem.GLAccount                    <> '0000607000'
    and JournalItem.GLAccount                    <> '0000607010'
    and JournalItem.GLAccount                    <> '0000607020'
    and JournalItem.GLAccount                    <> '0000607030'
    and JournalItem.GLAccount                    <> '0000607040'
    and JournalItem.GLAccount                    <> '0000607050'
    and JournalItem.GLAccount                    <> '0000607060'
    and JournalItem.GLAccount                    <> '0000944000'
    and JournalItem.GLAccount                    <> '0000944010'
    and JournalItem.GLAccount                    <> '0000944020'
    and JournalItem.GLAccount                    <> '0000690010'
    and JournalItem.GLAccount                    <> '0000690020'
    and JournalItem.GLAccount                    <> '0000690030'
    and JournalItem.GLAccount                    <> '0000690040'
    and JournalItem.GLAccount                    <> '0000690050'
    and JournalItem.GLAccount                    <> '0000690060'
    and JournalItem.GLAccount                    <> '0000690070'
    and JournalItem.GLAccount                    <> '0000690080'
    and JournalItem.GLAccount                    <> '0000690090'
    and JournalItem.GLAccount                    <> '0000615000'
    and JournalItem.GLAccount                    <> '0000615010'
    and JournalItem.GLAccount                    <> '0000615020'
    and JournalItem.GLAccount                    <> '0000615030'
    and JournalItem.GLAccount                    <> '0000620000'
    and JournalItem.GLAccount                    <> '0000623010'
    and JournalItem.GLAccount                    <> '0000623020'
    and JournalItem.GLAccount                    <> '0000625010'
    and JournalItem.GLAccount                    <> '0000625020'
    and JournalItem.GLAccount                    <> '0000625030'
    and JournalItem.GLAccount                    <> '0000625040'
    and JournalItem.GLAccount                    <> '0000700000'
    and JournalItem.GLAccount                    <> '0000700010'
    and JournalItem.GLAccount                    <> '0000700020'
  )
group by
  JournalItem.AccountingDocument,
  JournalItem.PurchasingDocument,
  JournalItem.FiscalYear,
  JournalItem.PostingDate,
  JournalItem.CompanyCode,
  JournalItem.Plant,
  JournalItem.DocumentDate,
  JournalItem.OffsettingAccount,
  JournalItem.PurchasingDocumentItem,
  JournalItem.DebitCreditCode,
  JournalItem.ReferenceDocument,
  JournalItem.ReferenceDocumentItem,
  JournalItem.TaxCode,
  JournalItem.TransactionTypeDetermination,
  JournalItem.AmountInCompanyCodeCurrency,
  JOURNAL_Spec.amcomp,
  JournalItem.AccountingDocumentItem,
  JournalItem.FinancialAccountType,
  JournalItem.GLAccount,
  JournalItem.PostingDate,
  JournalItem.CreditAmountInCoCodeCrcy,
  JournalItem.DebitAmountInCoCodeCrcy,
  JournalItem.CompanyCodeCurrency,
  GetSupplier.Supplier,
  JournalItem.AccountingDocumentType,
  JournalItem.LedgerGLLineItem
