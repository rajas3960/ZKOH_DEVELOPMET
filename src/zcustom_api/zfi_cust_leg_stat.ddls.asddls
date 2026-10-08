@EndUserText.label: 'CUSTOMER LED ST'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_CUST_LEG_STAT 
as select from ZFI_CUST_LEG_STAT_ROOT  as custroot
//inner join I_JournalEntryItem as jeit on jeit.Customer = custroot.custer    
//                                      and jeit.CompanyCode = custroot.cc
//                                      and jeit.DocumentItemText = custroot.text          

{
    key custroot.custer              as custer,
    custroot.cc                      as cc,
  //  custroot.doctype                 as doctype,
 //   jei.DocumentDate              as docdt,
    custroot.text                    as text,
 //   jei.InvoiceReference          as invref,
    custroot.curry                   as curry,
    @Semantics.amount.currencyCode: 'curry' 
   // case 
    sum( custroot.amount )           as amount,
  //  case
 //   when (custroot.amount < 0 ) then  'DR'
 //   else 'CR'
 //   end as DR/CR,
    custroot.custname                as custname
}


group by
    custroot.custer              ,
    custroot.cc                    ,
 //   custroot.doctype               ,
 //   jei.DocumentDate              as docdt,
    custroot.text                  ,
 //   jei.InvoiceReference          as invref,
    custroot.curry                 ,
  //  DR/CR,
    custroot.custname              

