@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
@EndUserText.label: 'Slab wise'
@Search.searchable: false
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity Z_SLAB
  as select from I_JournalEntry     as JEH
    inner join   I_JournalEntryItem as JEI  on  JEI.CompanyCode        = JEH.CompanyCode
                                            and JEI.FiscalYear         = JEH.FiscalYear
                                            and JEI.AccountingDocument = JEH.AccountingDocument
                                            and JEI.Ledger             = '0L'
//                                            and JEI.PostingKey             = '31'
//                                            and JEI.PostingKey             = '29'
//                                            and JEI.Supplier   <> ''
                                            
                                            


//    inner join   Z_SLAB             as SLAB on  SLAB.CompanyCode        = JEH.CompanyCode
//                                            and SLAB.FiscalYear         = JEH.FiscalYear
//                                            and SLAB.AccountingDocument = JEH.AccountingDocument
//                                            and SLAB.Customer           = JEI.Customer
//                                            and SLAB.PostingKey         = '31'
{
  key JEI.Customer                                                                                    as Customer,
  key JEI.CompanyCode                                                                                 as CompanyCode,
  key JEI.AccountingDocument                                                                          as AccountingDocument,
  key JEI.FiscalYear                                                                                  as FiscalYear,
      JEI.PostingKey                                                                                  as PostingKey,
      JEI.AccountingDocumentType                                                                      as AccountType,
      JEI.LedgerGLLineItem                                                                            as GLLineItem,
      @Semantics.amount.currencyCode:  'Currency'
      JEI.AmountInCompanyCodeCurrency                                                                 as Amount,
      JEI.CompanyCodeCurrency                                                                         as Currency,
      JEH.PostingDate                                                                                 as PostingDate,
      JEI.ClearingJournalEntry                                                                        as ClearingJournalEntryDeprecated,
      JEI.NetDueDate,
      JEI.DocumentDate,
      JEI.DocumentItemText,

      cast( dats_days_between(JEI.NetDueDate , $session.system_date )as abap.int8 ) as maxdt,
      
    case when JEI.NetDueDate <= $session.system_date
    then 'DUE'
    else 'NOT DUE'
    end                                                                                             as DUENOTDUE,
      
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

  //    cast(dats_days_between(JEI.NetDueDate , cast($session.system_date as abap.dats)) as abap.int8) as maxdt,


//      SLAB.DAYSBETWEEN,
//      SLAB.DAYSBETWEEN1,


//      @Semantics.amount.currencyCode:  'Currency'
//      //  @Default: null
//      case
//      when SLAB.DAYSBETWEEN1  <= 45
//       then JEI.AmountInCompanyCodeCurrency*-1
//      //     else null
//       end                                                                                            as Firstt,
//
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN1 >= 46
//      and SLAB.DAYSBETWEEN <= 60//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency * -1
//      //   else null
//      end                                                                                             as Secondd,
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN1 >= 61
//      and SLAB.DAYSBETWEEN1 <= 90//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency*-1
//      //  else null
//       end                                                                                            as Third,
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN1 >= 91
//      and  SLAB.DAYSBETWEEN1 <= 180
//      //  and cast( dats_days_between( JEH.PostingDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency*-1
//      //   else null
//      end                                                                                             as Fourth,
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN1 >= 181
//      and  SLAB.DAYSBETWEEN1 <= 365
//      //  and cast( dats_days_between( JEH.PostingDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency * -1
//      //   else null
//      end                                                                                             as Fifth,
//
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN1 >= 366
//      and  SLAB.DAYSBETWEEN1 <= 730
//      //  and cast( dats_days_between( JEH.PostingDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency * -1
//      //   else null
//      end                                                                                             as Sixth,
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN1 >= 731
//      and  SLAB.DAYSBETWEEN1 <= 1095
//      //  and cast( dats_days_between( JEH.PostingDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency * -1
//      //   else null
//      end                                                                                             as seventh,
//
//      @Semantics.amount.currencyCode:  'Currency'
//      case
//      when SLAB.DAYSBETWEEN1 >= 1096
//      //  and  SLAB.DAYSBETWEEN >= 180
//      //  and cast( dats_days_between( JEH.PostingDate,  $session.system_date )as abap.int8 )  <= 180//and JEI.TransactionCurrency = 'INR'
//      then JEI.AmountInCompanyCodeCurrency * -1
//      //   else null
//      end                                                                                             as Eighth,
//
//      @Semantics.amount.currencyCode: 'Currency'
//      //  //  cast(sum(JEI.AmountInCompanyCodeCurrency) as abap.dec( 12, 3 ) ) as Grand
//      sum(JEI.AmountInCompanyCodeCurrency )                                                            as Grand

}

where
//  (
// 
//       JEI.PostingKey             = '31'
//    or JEI.PostingKey             = '29'
//    or JEI.PostingKey             = '25'
//    or JEI.PostingKey             = '22'
//    or JEI.PostingKey             = '21'
//    or JEI.PostingKey             = '37'
//    or JEI.PostingKey             = '40'
//    or JEI.PostingKey             = '50'
//    or JEI.PostingKey             = '27'
//    or JEI.PostingKey             = '32'
////    or JEI.PostingKey             = '02'
////    or JEI.PostingKey             = '12'
//  )
//  and(
//JEI.AccountingDocumentType = 'RV'
//       JEI.AccountingDocumentType = 'RV'
//    or JEI.AccountingDocumentType = 'DZ'
//    or JEI.AccountingDocumentType = 'DA'
//    or JEI.AccountingDocumentType = 'SA'
//    or JEI.AccountingDocumentType = 'SU'
//    or JEI.AccountingDocumentType = 'KA'
//    or JEI.AccountingDocumentType = 'DP'
//    or JEI.AccountingDocumentType = 'DR'
//    or JEI.AccountingDocumentType = 'UE'
//    or JEI.AccountingDocumentType = 'DG'
//    or JEI.AccountingDocumentType = 'AB'
//  )
JEI.Supplier  <> ''
//and  JEI.ClearingAccountingDocument   = ''

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
//  SLAB.DAYSBETWEEN,
  JEI.NetDueDate,
  JEI.DocumentDate,
  JEI.DocumentItemText
 // SLAB.DAYSBETWEEN1
