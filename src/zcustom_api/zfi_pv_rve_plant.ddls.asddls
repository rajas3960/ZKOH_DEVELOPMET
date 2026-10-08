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
define root view entity ZFI_PV_RVE_PLANT
  as select  from    I_OperationalAcctgDocItem as a
inner join      I_Plant                   as b on  b.Plant = a.Plant
    left outer join I_OrganizationAddress     as c on  c.AddressID                 = b.AddressID
                                                   and c.AddressPersonID           = ''
                                                   and c.AddressRepresentationCode = ''
    left outer join I_RegionText              as d on  d.Country  = c.Country
                                                   and d.Region   = c.Region
                                                   and d.Language = 'E'
    left outer join I_CountryText             as e on  e.Country  = c.Country
                                                   and e.Language = 'E'

{
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.FiscalYear,
      a.Plant,
    // a.ProfitCenter as Plant,
//      a.CostCenter,                               //Commented on 03.02.2026 due to duplication issue
      b.PlantName,
      c.StreetName,
      c.VillageName,
      c.CityName,
      c.DistrictName,
      c.PostalCode,
      d.RegionName,
      e.CountryName
}
where
  //a.ProfitCenter is not initial
  a.Plant is not initial
group by
  a.CompanyCode,
  a.AccountingDocument,
  a.FiscalYear,
  //a.ProfitCenter,
  a.Plant,
//  a.CostCenter,                                           //Commented on 03.02.2026 due to duplication issue
  b.PlantName,
  c.StreetName,
  c.VillageName,
  c.CityName,
  c.DistrictName,
  c.PostalCode,
  d.RegionName,
  e.CountryName
