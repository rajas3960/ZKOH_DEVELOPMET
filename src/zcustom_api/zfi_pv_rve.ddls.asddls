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
   
define root view entity ZFI_PV_RVE
  as select distinct from    I_OperationalAcctgDocItem as oadi
    inner join      I_OperationalAcctgDocItem as inv
      on  inv.ClearingJournalEntry           = oadi.AccountingDocument
      and inv.ClearingJournalEntryFiscalYear = oadi.FiscalYear
      and inv.CompanyCode                    = oadi.CompanyCode
      and inv.ClearingItem                   = oadi.ClearingItem

    left outer join ZFI_PV_RVE_PLANT as plant
      on  plant.AccountingDocument = inv.AccountingDocument
      and plant.CompanyCode        = inv.CompanyCode
      and plant.FiscalYear         = inv.FiscalYear
 
    left outer join ZFI_PV_RVE_PLANT_CLR as plant_clr
      on  plant_clr.ClearingJournalEntry           = oadi.ClearingJournalEntry
      and plant_clr.CompanyCode                    = oadi.CompanyCode
      and plant_clr.ClearingJournalEntryFiscalYear = oadi.ClearingJournalEntryFiscalYear
      and plant_clr.ClearingItem                   = oadi.ClearingItem
      
//DP
    left outer join I_OperationalAcctgDocItem as oadi2
      on  oadi2.AccountingDocument   = oadi.AccountingDocument
      and oadi2.FiscalYear           = oadi.FiscalYear
      and oadi2.CompanyCode          = oadi.CompanyCode
      and oadi2.ClearingJournalEntry is initial
      and oadi2.HouseBank is not initial          //DP

    left outer join I_HouseBankAccountLinkage as HB
      on  HB.CompanyCode      = oadi2.CompanyCode
      and HB.HouseBank        = oadi2.HouseBank
      and HB.HouseBankAccount = oadi2.HouseBankAccount
//DP
    left outer join I_JournalEntry as jeh
      on  jeh.AccountingDocument = inv.AccountingDocument
      and jeh.FiscalYear         = inv.FiscalYear
      and jeh.CompanyCode        = inv.CompanyCode

    left outer join I_GLAccountText as glname
      on  glname.GLAccount = oadi.GLAccount
      and glname.Language  = 'E'

    left outer join I_Supplier as sup
      on sup.Supplier = oadi.Supplier

    left outer join I_BusinessPartner as bp
      on bp.BusinessPartner = sup.Supplier

    left outer join I_Customer as cust
      on cust.Customer = oadi.Customer

    left outer join I_ProfitCenterText as prodesc
      on  prodesc.ProfitCenter      = oadi2.ProfitCenter
      and prodesc.ControllingArea   = oadi2.ControllingArea
      and prodesc.Language          = 'E'
      and prodesc.ValidityEndDate   >= oadi2.DocumentDate
      and prodesc.ValidityStartDate <= oadi2.DocumentDate

    left outer join I_CostCenterText as costdesc
      on  costdesc.CostCenter        = oadi.CostCenter
      and costdesc.ControllingArea   = oadi.ControllingArea
      and costdesc.Language          = 'E'
      and costdesc.ValidityEndDate   >= oadi.DocumentDate
      and costdesc.ValidityStartDate <= oadi.DocumentDate

    left outer join I_OutgoingCheck as check
      on  check.PaymentDocument    = oadi.AccountingDocument
      and check.ChequeVoidReason   = '00'
      and check.FiscalYear         = jeh.FiscalYear
      and check.PaymentCompanyCode = jeh.CompanyCode

    left outer join I_BusinessUserBasic as user
      on user.UserID = jeh.AccountingDocCreatedByUser

{
  key oadi.AccountingDocument as accdoc,
  key oadi.LedgerGLLineItem   as glitem,
  key oadi.FiscalYear         as fyear,
  key oadi.CompanyCode        as compcode,

      case when plant.Plant is not initial then plant.Plant else plant_clr.Plant end               as plantcode,
      case when plant.Plant is not initial then plant.PlantName else plant_clr.PlantName end       as PlantName,
      case when plant.Plant is not initial then plant.StreetName else plant_clr.StreetName end     as StreetName,
      case when plant.Plant is not initial then plant.VillageName else plant_clr.VillageName end   as VillageName,
      case when plant.Plant is not initial then plant.CityName else plant_clr.CityName end         as CityName,
      case when plant.Plant is not initial then plant.DistrictName else plant_clr.DistrictName end as DistrictName,
      case when plant.Plant is not initial then plant.PostalCode else plant_clr.PostalCode end     as PostalCode,
      case when plant.Plant is not initial then plant.RegionName else plant_clr.RegionName end     as RegionName,
      case when plant.Plant is not initial then plant.CountryName else plant_clr.CountryName end   as CountryName,

      inv.AccountingDocumentType as doctyp,
      oadi.DocumentDate          as docdt,
      oadi.PostingDate           as postdt,
      inv.DocumentItemText       as itemtext,
      inv.DocumentItemText       as InvoiceReference,
      case
        when oadi.AccountingDocument = inv.AccountingDocument
        then oadi2.DocumentItemText
        else null
      end as ClearingText,
//DP
    //jeh.DocumentReferenceID as ref,
      case when jeh.AccountingDocumentType <> 'WE'
      then  jeh.DocumentReferenceID  
      else null end       as ref,
      jeh.AccountingDocCreatedByUser as userid,
      check.OutgoingCheque           as Chequeno,
      user.PersonFullName            as username,
      HB.BankInternalID              as BankAccount,
      HB.BankName,
      HB.BankAccountNumber           as BankNumber,

      case
        when inv.AccountingDocumentType <> 'RV'
        then oadi.Supplier
        else null
      end as supplier,

      case
        when inv.AccountingDocumentType <> 'RV'
        then oadi.Customer
        else null
      end as customer,

      case
        when inv.AccountingDocumentType <> 'RV'
        then oadi.GLAccount
        else null
      end as glacc,

      case
        when inv.AccountingDocumentType <> 'RV'
        then oadi.CostCenter
        else null
      end as costcntr,

      case
        when inv.AccountingDocumentType <> 'RV'
        then oadi2.ProfitCenter
        else null
      end as profitcntr,

      case
        when inv.AccountingDocumentType <> 'RV'
        then oadi.DocumentItemText
        else null
      end as narration,

      @Semantics.amount.currencyCode: 'curry'
      case
        when inv.AccountingDocumentType <> 'RV'
         and oadi2.AccountingDocument is not initial
        then oadi2.AmountInBalanceTransacCrcy
        when inv.AccountingDocumentType <> 'RV'
        then oadi.AmountInBalanceTransacCrcy
        else null
      end as amt,

      oadi.CompanyCodeCurrency as curry,

      case
        when inv.AccountingDocumentType <> 'RV'
        then oadi.DebitCreditCode
        else null
      end as dccode,

      case
        when inv.AccountingDocumentType <> 'RV'
        then oadi.SpecialGLCode
        else null
      end as spclglindicator,

      glname.GLAccountLongName as gllongname,
      sup.SupplierName         as supname,
      sup.BusinessPartnerName2 as add2,
      sup.BusinessPartnerName3 as add3,
      sup.BusinessPartnerName4 as add4,
      cust.CustomerFullName    as custname,
      prodesc.ProfitCenterName as profitname,
      costdesc.CostCenterName  as costname,

      case
        when inv.AccountingDocumentType = 'RV'
        then inv.AccountingDocument
        else null
      end as invno,

      case
        when inv.AccountingDocumentType = 'RV'
        then jeh.AccountingDocumentCreationDate
        else null
      end as Billdate,

      @Semantics.amount.currencyCode: 'curry'
      case
        when ( inv.AccountingDocumentType = 'KR'
            or inv.AccountingDocumentType = 'RE'
            or inv.AccountingDocumentType = 'KZ'
            or inv.AccountingDocumentType = 'KG'
            or inv.AccountingDocumentType = '2Z'
            or inv.AccountingDocumentType = '4Z'
            or inv.AccountingDocumentType = '5Z'
            or inv.AccountingDocumentType = 'AB'
            or inv.AccountingDocumentType = 'SA' )
         and inv.AccountingDocument <> oadi.AccountingDocument
        then inv.AmountInBalanceTransacCrcy
        else null
      end as invamt,

      case
        when inv.AccountingDocumentType <> 'RV'
        then inv.AccountingDocument
        else null
      end as docno
}
