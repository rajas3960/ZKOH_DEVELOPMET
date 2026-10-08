@EndUserText.label: '2nd root entity of Customer Led Statement'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_CUST_LEG_STAT_ROOT 
as select from I_JournalEntryItem as jei
inner join I_Customer as cust on jei.Customer = cust.Customer
{
    key jei.Customer              as custer,
    key jei.DocumentDate          as docdt,
    jei.CompanyCode               as cc,
  //  jei.AccountingDocumentType    as doctype,
 //   
    jei.DocumentItemText          as text,
 //   jei.InvoiceReference          as invref,
    jei.CompanyCodeCurrency       as curry,
    @Semantics.amount.currencyCode: 'curry' 
   // case 
    jei.AmountInCompanyCodeCurrency  as amount,
    cust.CustomerFullName           as custname
}
where jei.Ledger = '0L'  

//group by
//jei.Customer,       
//    jei.CompanyCode  ,    
//    jei.AccountingDocumentType , 
 //   jei.DocumentDate           ,
//    jei.DocumentItemText       ,
//    jei.InvoiceReference       ,
//    jei.CompanyCodeCurrency    ,
//    cust.CustomerFullName      

