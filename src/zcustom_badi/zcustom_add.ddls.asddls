@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity of reservation'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCUSTOM_Add as select from I_Address_2 as ADD
left outer join I_Customer as cus   on cus.AddressID = ADD.AddressID
{
   key ADD.AddressID,
   key ADD.AddressPersonID,
   key ADD.AddressRepresentationCode,
   ADD.AddressObjectType,
   ADD.CorrespondenceLanguage,
   ADD.PrfrdCommMediumType,
   ADD.AddresseeFullName,
   ADD.PersonGivenName,
   ADD.PersonFamilyName,
   ADD.OrganizationName1,
   ADD.OrganizationName2,
   ADD.OrganizationName3,
   ADD.OrganizationName4,
   ADD.AddressSearchTerm1,
   ADD.AddressSearchTerm2,
   ADD.CityNumber,
   ADD.CityName,
   ADD.DistrictName,
   ADD.VillageName,
   ADD.PostalCode,
   ADD.CompanyPostalCode,
   ADD.Street,
   ADD.StreetName,
   ADD.StreetAddrNonDeliverableReason,
   ADD.StreetPrefixName1,
   ADD.StreetPrefixName2,
   ADD.StreetSuffixName1,
   ADD.StreetSuffixName2,
   ADD.HouseNumber,
   ADD.HouseNumberSupplementText,
   ADD.Building,
   ADD.Floor,
   ADD.RoomNumber,
   ADD.Country,
   ADD.Region,
   ADD.FormOfAddress,
   ADD.TaxJurisdiction,
   ADD.TransportZone,
   ADD.POBox,
   ADD.POBoxAddrNonDeliverableReason,
   ADD.POBoxIsWithoutNumber,
   ADD.POBoxPostalCode,
   ADD.POBoxLobbyName,
   ADD.POBoxDeviatingCityName,
   ADD.POBoxDeviatingCityCode,
   ADD.POBoxDeviatingRegion,
   ADD.POBoxDeviatingCountry,
   ADD.CareOfName,
   ADD.DeliveryServiceTypeCode,
   ADD.DeliveryServiceNumber,
   ADD.AddressTimeZone,
   ADD.SecondaryRegion,
   ADD.SecondaryRegionName,
   ADD.TertiaryRegion,
   ADD.TertiaryRegionName,
   ADD.RegionalStructureCheckStatus,
   ADD.AddressGroup,
   ADD.DistrictNumber,
   ADD.Village,
   ADD.RegionalStructureGroup,
   ADD.AddressCreatedByUser,
   ADD.AddressCreatedOnDateTime,
   ADD.AddressChangedByUser,
   ADD.AddressChangedOnDateTime,
   cus.TaxNumber3,
   case 
   when ADD.Region = 'JK'
   then '01'
   when ADD.Region = 'HP'
   then '02'
   when ADD.Region = 'PB'
   then '03'
   when ADD.Region = 'CH'
   then '04'
   when ADD.Region = 'UK'
   then '05'
   when ADD.Region = 'HR'
   then '06'
   when ADD.Region = 'DL'
   then '07'
   when ADD.Region = 'RJ'
   then '08'
   when ADD.Region = 'UP'
   then '09'
   when ADD.Region = 'BR'
   then '10'
   when ADD.Region = 'SK'
   then '11'
   when ADD.Region = 'AR'
   then '12'
   when ADD.Region = 'NL'
   then '13'
   when ADD.Region = 'MN'
   then '14'
   when ADD.Region = 'MZ'
   then '15'
   when ADD.Region = 'TR'
   then '16'
   when ADD.Region = 'ML'
   then '17'
   when ADD.Region = 'AS'
   then '18'
   when ADD.Region = 'WB'
   then '19'
   when ADD.Region = 'JH'
   then '20'
   when ADD.Region = 'OD'
   then '21'
   when ADD.Region = 'CG'
   then '22'
   when ADD.Region = 'MP'
   then '23'
   when ADD.Region = 'GJ'
   then '24'
   when ADD.Region = 'DH'
   then '25'
//   when ADD.Region = ''
//   then '26'
   when ADD.Region = 'MH'
   then '27'
//   when ADD.Region = 'AP'
//   then '28'
   when ADD.Region = 'KA'
   then '29'
   when ADD.Region = 'GA'
   then '30'
   when ADD.Region = 'LD'
   then '31'
   when ADD.Region = 'KL'
   then '32'
   when ADD.Region = 'TN'
   then '33'
   when ADD.Region = 'PY'
   then '34'
   when ADD.Region = 'AN'
   then '35'
   when ADD.Region = 'TS'
   then '36'
   when ADD.Region = 'AP'
   then '37'
   when ADD.Region = 'LA'
   then '38'
   
   
   
   else null end  as Statecode
   
   
}
