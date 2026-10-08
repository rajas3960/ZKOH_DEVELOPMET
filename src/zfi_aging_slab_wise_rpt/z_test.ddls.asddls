@AbapCatalog.viewEnhancementCategory: [#NONE]
 @AccessControl.authorizationCheck: #NOT_REQUIRED 
 @EndUserText.label: 'TEST' @Metadata.ignorePropagatedAnnotations: true 
 @ObjectModel.usageType:{ serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }
define view entity Z_TEST
  as select from I_JournalEntry     as JEH
    inner join   I_JournalEntryItem as JEI  on  JEI.CompanyCode        = JEH.CompanyCode
                                            and JEI.FiscalYear         = JEH.FiscalYear
                                            and JEI.AccountingDocument = JEH.AccountingDocument
                                            and JEI.Ledger             = '0L'

  //  as select from I_JournalEntryItem     as JEI
  //  inner join   I_JournalEntry as JEH  on  JEI.CompanyCode        = JEH.CompanyCode
  //                                            and JEI.FiscalYear         = JEH.FiscalYear
  //                                            and JEI.AccountingDocument = JEH.AccountingDocument
  //                                            and JEI.Ledger             = '0L'

    inner join   Z_SLAB             as SLAB on  SLAB.CompanyCode        = JEH.CompanyCode
                                            and SLAB.FiscalYear         = JEH.FiscalYear
                                            and SLAB.AccountingDocument = JEH.AccountingDocument


{
  key JEI.Customer                                                                                  as Customer,
  key JEI.CompanyCode                                                                               as CompanyCode,
  key JEI.AccountingDocument                                                                        as AccountingDocument,
  key JEI.FiscalYear                                                                                as FiscalYear,
      JEI.PostingKey                                                                                as PostingKey,
      JEI.AccountingDocumentType                                                                    as AccountType,
      JEI.LedgerGLLineItem                                                                          as GLLineItem,
      @Semantics.amount.currencyCode:  'Currency'
      JEI.AmountInCompanyCodeCurrency                                                               as Amount,
      JEI.CompanyCodeCurrency                                                                       as Currency,
      JEH.PostingDate                                                                               as PostingDate,
      JEI.ClearingJournalEntry                                                                      as ClearingJournalEntryDeprecated,
      JEI.NetDueDate,

           cast( dats_days_between(JEH.PostingDate , $session.system_date )as abap.int8 ) as maxdt1,

 //     cast(dats_days_between(JEI.NetDueDate, cast($session.system_date as abap.dats)) as abap.int8) as maxdt,



  //    SLAB.DAYSBETWEEN,


      case
           when JEI.NetDueDate <= $session.system_date
      then 'DUE'
      else 'NOT DUE'
      end                                                                                           as DUENOTDUE,


  @Semantics.amount.currencyCode:  'Currency'     
    case
    when cast( dats_days_between(JEH.PostingDate, $session.system_date ) as abap.int8 )  <= 30 //and JEI.TransactionCurrency = 'INR'
    then JEI.AmountInCompanyCodeCurrency
    else null end                as Firstt

 //     @Semantics.amount.currencyCode:  'Currency'

//      case
//      when SLAB.DAYSBETWEEN  <= 45
//       then JEI.AmountInCompanyCodeCurrency
//      //     else null
//       end                                                                                          as Firstt
//
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN >= 46
//      and SLAB.DAYSBETWEEN <= 60//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency
//      //   else null
//      end                                                                                           as Secondd,
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN >= 61
//      and SLAB.DAYSBETWEEN <= 90//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency
//      //  else null
//       end                                                                                          as Third,
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN >= 91
//      and  SLAB.DAYSBETWEEN <= 180
//      //  and cast( dats_days_between( JEH.PostingDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency
//      //   else null
//      end                                                                                           as Fourth,
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN >= 181
//      and  SLAB.DAYSBETWEEN <= 365
//      //  and cast( dats_days_between( JEH.PostingDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency
//      //   else null
//      end                                                                                           as Fifth,
//
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN >= 366
//      and  SLAB.DAYSBETWEEN <= 730
//      //  and cast( dats_days_between( JEH.PostingDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency
//      //   else null
//      end                                                                                           as Sixth,
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN >= 731
//      and  SLAB.DAYSBETWEEN <= 1095
//      //  and cast( dats_days_between( JEH.PostingDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency
//      //   else null
//      end                                                                                           as seventh,
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN >= 1096
//      //  and  SLAB.DAYSBETWEEN >= 180
//      //  and cast( dats_days_between( JEH.PostingDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency
//      //   else null
//      end                                                                                           as Eighth,
//
//      @Semantics.amount.currencyCode: 'Currency'
//      //  //  cast(sum(JEI.AmountInCompanyCodeCurrency) as abap.dec( 12, 3 ) ) as Grand
//      sum(JEI.AmountInCompanyCodeCurrency)                                                          as Grand


}
where
  (
       JEI.PostingKey             = '01'
    or JEI.PostingKey             = '11'
    or JEI.PostingKey             = '19'
    or JEI.PostingKey             = '09'
    or JEI.PostingKey             = '08'
    or JEI.PostingKey             = '15'
    or JEI.PostingKey             = '05'
    or JEI.PostingKey             = '07'
    or JEI.PostingKey             = '17'
    or JEI.PostingKey             = '18'
    or JEI.PostingKey             = '02'
    or JEI.PostingKey             = '12'
  )
  and(
       JEI.AccountingDocumentType = 'RV'
    or JEI.AccountingDocumentType = 'DZ'
    or JEI.AccountingDocumentType = 'DA'
    or JEI.AccountingDocumentType = 'SA'
    or JEI.AccountingDocumentType = 'SU'
    or JEI.AccountingDocumentType = 'KA'
    or JEI.AccountingDocumentType = 'DP'
    or JEI.AccountingDocumentType = 'DR'
    or JEI.AccountingDocumentType = 'UE'
    or JEI.AccountingDocumentType = 'DG'
    or JEI.AccountingDocumentType = 'AB'
    or JEI.AccountingDocumentType = 'D1'
  )
  and  JEI.ClearingJournalEntry   = ''
  
  group by
  JEI.Customer,
  JEI.AccountingDocument,
  JEI.CompanyCode,
  JEI.FiscalYear,
  JEH.PostingDate,
  JEI.LedgerGLLineItem,
  JEI.PostingKey,
  JEI.CompanyCodeCurrency,
  JEI.AmountInCompanyCodeCurrency,
  JEI.ClearingJournalEntry,
  JEI.AccountingDocumentType,
 // SLAB.DAYSBETWEEN,
  JEI.NetDueDate

