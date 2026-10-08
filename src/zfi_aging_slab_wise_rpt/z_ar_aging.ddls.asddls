//@AbapCatalog.sqlViewName: 'ZFI_AGING_DEDTOR'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
@EndUserText.label: 'Slab wise'
@Search.searchable: false
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity Z_AR_Aging
  as select from I_JournalEntry     as JEH
    inner join   I_JournalEntryItem as JEI  on  JEI.CompanyCode        = JEH.CompanyCode
                                            and JEI.FiscalYear         = JEH.FiscalYear
                                            and JEI.AccountingDocument = JEH.AccountingDocument
                                            and JEI.Ledger             = '0L'



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
      JEI.DocumentItemText,
      

 //          cast( dats_days_between(JEH.PostingDate , $session.system_date )as abap.int8 ) as maxdt1,
           
   cast( dats_days_between(JEI.NetDueDate , $session.system_date )as abap.int8 ) as maxdt,
           

 //     cast(dats_days_between(JEI.NetDueDate, cast($session.system_date as abap.dats)) as abap.int8) as maxdt,
   


 //     SLAB.DAYSBETWEEN,


      case
           when JEI.NetDueDate <= $session.system_date
      then 'DUE'
      else 'NOT DUE'
      end                                                                                           as DUENOTDUE,
      
          
     @Semantics.amount.currencyCode:  'Currency'     
    case
    when cast( dats_days_between(JEI.NetDueDate, $session.system_date ) as abap.int8 )  <= 45 //and JEI.TransactionCurrency = 'INR'
    then JEI.AmountInCompanyCodeCurrency
    else null end                as Firstt,
    
     @Semantics.amount.currencyCode:  'Currency'     
    case
    when cast( dats_days_between(JEI.NetDueDate, $session.system_date ) as abap.int8 )  >= 46 
    and cast( dats_days_between( JEI.NetDueDate,  $session.system_date )as abap.int8 )  <= 60//and JEI.TransactionCurrency = 'INR'
    then JEI.AmountInCompanyCodeCurrency
    else null end                as Secondd,
    
      @Semantics.amount.currencyCode:  'Currency'     
    case
    when cast( dats_days_between(JEI.NetDueDate, $session.system_date ) as abap.int8 )  >= 61 
    and cast( dats_days_between( JEI.NetDueDate,  $session.system_date )as abap.int8 )  <= 90//and JEI.TransactionCurrency = 'INR'
    then JEI.AmountInCompanyCodeCurrency
    else null end                as Third,
    
      @Semantics.amount.currencyCode:  'Currency'     
    case
    when cast( dats_days_between(JEI.NetDueDate, $session.system_date ) as abap.int8 )  >= 91 
    and cast( dats_days_between( JEI.NetDueDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
    then JEI.AmountInCompanyCodeCurrency
    else null end                as Fourth,
    
      @Semantics.amount.currencyCode:  'Currency'     
    case
    when cast( dats_days_between(JEI.NetDueDate, $session.system_date ) as abap.int8 )  >= 181 
    and cast( dats_days_between( JEI.NetDueDate,  $session.system_date )as abap.int8 )  <= 365//and JEI.TransactionCurrency = 'INR'
    then JEI.AmountInCompanyCodeCurrency
    else null end                as Fifth,
    
    
      @Semantics.amount.currencyCode:  'Currency'     
    case
    when cast( dats_days_between(JEI.NetDueDate, $session.system_date ) as abap.int8 )  >= 366 
    and cast( dats_days_between( JEI.NetDueDate,  $session.system_date )as abap.int8 )  <= 730//and JEI.TransactionCurrency = 'INR'
    then JEI.AmountInCompanyCodeCurrency
    else null end                as Sixth,
    
    
      @Semantics.amount.currencyCode:  'Currency'     
    case
    when cast( dats_days_between(JEI.NetDueDate, $session.system_date ) as abap.int8 )  >= 731 
    and cast( dats_days_between( JEI.NetDueDate,  $session.system_date )as abap.int8 )  <= 1095//and JEI.TransactionCurrency = 'INR'
    then JEI.AmountInCompanyCodeCurrency
    else null end                as seventh,
    
      @Semantics.amount.currencyCode:  'Currency'     
    case
    when cast( dats_days_between(JEI.NetDueDate, $session.system_date ) as abap.int8 )  >= 1096 
    then JEI.AmountInCompanyCodeCurrency
    else null end                as Eighth,
    
     @Semantics.amount.currencyCode: 'Currency' 
  //  cast(sum(JEI.AmountInCompanyCodeCurrency) as abap.dec( 12, 3 ) ) as Grand
     sum(JEI.AmountInCompanyCodeCurrency) as Grand
      
   
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
    or JEI.AccountingDocumentType = 'D2'
    or JEI.AccountingDocumentType = 'D3'
    or JEI.AccountingDocumentType = 'D4'
    or JEI.AccountingDocumentType = '1Z'
    or JEI.AccountingDocumentType = '2Z'
    or JEI.AccountingDocumentType = '3Z'
    or JEI.AccountingDocumentType = '4Z'
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
  JEI.NetDueDate,
  JEI.DocumentItemText
