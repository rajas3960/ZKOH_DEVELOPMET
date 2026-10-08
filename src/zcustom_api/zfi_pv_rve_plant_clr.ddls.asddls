//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Payment Voucher Plant'
//@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
define root view entity ZFI_PV_RVE_PLANT_CLR
  as select  from I_OperationalAcctgDocItem as a
    inner join   ZFI_PV_RVE_PLANT          as b on  b.AccountingDocument = a.AccountingDocument
                                                and b.CompanyCode        = a.CompanyCode
                                                and b.FiscalYear         = a.FiscalYear
{
  key a.CompanyCode,
  key a.ClearingJournalEntry,
  key a.ClearingJournalEntryFiscalYear,
  key a.ClearingItem,
      b.Plant,
      //      b.CostCenter,                   //Commented on 03.02.2026 due to duplication issue
      b.PlantName,
      b.StreetName,
      b.VillageName,
      b.CityName,
      b.DistrictName,
      b.PostalCode,
      b.RegionName,
      b.CountryName
}
where
  a.ClearingJournalEntry is not initial
//      added on 18.05.2026 due to duplication in PRD for document 1500000102
  and not ( a.ClearingJournalEntry = '1500000102' and a.ClearingJournalEntryFiscalYear = '2026' and a.CompanyCode = '5000' )
group by
  a.CompanyCode,
  a.ClearingJournalEntry,
  a.ClearingJournalEntryFiscalYear,
  a.ClearingItem,
  b.Plant,
  //  b.CostCenter,                     //Commented on 03.02.2026 due to duplication issue
  b.PlantName,
  b.StreetName,
  b.VillageName,
  b.CityName,
  b.DistrictName,
  b.PostalCode,
  b.RegionName,
  b.CountryName
