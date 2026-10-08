@AbapCatalog.sqlViewName: 'ZPMASTER2_API3'
@ClientHandling.type : #INHERITED
@ClientHandling.algorithm : #SESSION_VARIABLE
@ObjectModel.usageType: {serviceQuality: #D, sizeCategory: #XL, dataClass: #TRANSACTIONAL}
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For PMaster'
@Search.searchable: false
@Metadata.ignorePropagatedAnnotations: true
define view ZTestingAP 
as select from  I_Product                     as pro
left outer join I_ProductText                 as protxt    on protxt.Product = pro.Product 
                                                          and protxt.Language = 'E'
left outer join I_ProductTypeText             as ptYtX     on ptYtX.ProductType = pro.ProductType
                                                          and ptYtX.Language = 'E'      
left outer join I_ProductGroupText_2          as PGTX      on PGTX.ProductGroup = pro.ProductGroup
                                                          and PGTX.Language = 'E'                                      
left outer join I_ProductCategoryText         as PCTXT     on PCTXT.ProductCategory = pro.ProductCategory
                                                          and PCTXT.Language = 'E'
                                                          
left outer join I_ProductPlantBasic           as PPlnt     on PPlnt.Product = pro.Product 
left outer join I_Plant                       as Plt       on Plt.Plant = PPlnt.Plant 
left outer join I_ProductSales                as Psale     on Psale.Product = pro.Product

left outer join I_ProductPlantSupplyPlanning  as PPSP      on PPSP.Product = PPlnt.Product 
                                                         and PPSP.Plant = PPlnt.Plant
left outer join  I_ProductStorageLocationBasic as ProSt   on ProSt.Product = pro.Product and ProSt.Plant = PPlnt.Plant
left outer join I_StorageLocation             as ProSt1     on ProSt1.StorageLocation = ProSt.StorageLocation and ProSt1.Plant = ProSt.Plant
left outer join I_ProductStorage_2            as Psto      on Psto.Product = pro.Product 
left outer join I_ProductUnitsOfMeasure       as PUM       on PUM.Product = pro.Product
                                                        and PUM.AlternativeUnit <> pro.BaseUnit                                                                                                                                                                                                                                                                   
{
 key pro.Product                        as ProductNo,
  protxt.ProductName                    as ProductDesc,
  pro.ProductType                       as producttype,
  pro.BaseUnit                          as Baseunit,
  pro.ProductGroup                      as ProductGroup, 
  pro.ItemCategoryGroup                 as itemCatGroup,
  pro.IsBatchManagementRequired         as IsBatchManagementRequired,
  pro.PurchaseOrderQuantityUnit         as PurchaseOrderQuantityUnit,
  pro.VarblPurOrdUnitIsActive           as VarblPurOrdUnitIsActive,
  pro.WeightUnit                        as weightunit,
  pro.IsMarkedForDeletion               as IsMarkedForDeletion,
  pro.CreationDate                      as CreatedOn,
  pro.LastChangeDate                    as LastChangeDate,
  pro.IsBatchManagementRequired         as BatchManagreq,
  ptYtX.MaterialTypeName                as ProdusttypeText, 
  PGTX.ProductGroupText                 as ProductGrouptext,
  PCTXT.Name                            as ItemCatGroupDec, 
  PPlnt.AvailabilityCheckType           as AvailabilityCheckType,
  PPlnt.IsNegativeStockAllowed          as IsNegativeStockAllowed,
  PPlnt.Plant                           as Plant,
  PPlnt.IsBatchManagementRequired       as IsBatchManagementRequiredPlant,
  PPlnt.ProfitCenter                    as ProfitCenter,
  PPlnt.ConsumptionTaxCtrlCode          as ConsumptionTaxCtrlCode,
  PPlnt.PurchasingGroup                 as PurchasingGroup,
  PPlnt.MRPType                         as MRPType,
  PPlnt.MRPResponsible                  as MRPResponsible,
  PPlnt.PlannedDeliveryDurationInDays   as PlannedDeliveryDurationInDays ,
  Plt.PlantName                         as PlantDesc,
  Psale.TransportationGroup             as TransportationGroup,
  Psale.LoadingGroup                    as LoadingGroup,
  PPSP.ProcurementType                  as ProcurementType,
  ProSt.StorageLocation                 as StorageLocation,
  ProSt1.StorageLocationName            as StorageLocationName,
  Psto.TemperatureConditionInd          as TemperatureConditionInd,
  PUM.AlternativeUnit                   as AlternativeUnit,
  PUM.QuantityNumerator                 as QuantityNumerator,
  PUM.QuantityDenominator               as QuantityDenominator,
  pro.ProductOldID                      as ProductOLDID,
  pro.YY1_SALT_PRD                      as salt,
  pro.YY1_Packing_PRD                   as Packing,
  pro.YY1_DPCOMRP_PRDC                  as Curr,
  @Semantics.amount.currencyCode: 'Curr'
  pro.YY1_DPCOMRP_PRD                   as DPCOMRP,
  pro.YY1_PharmaMaterialCate_PRD        as PharmaMaterialCategory,
  pro.YY1_PharmaMaterialSubC_PRD        as PharmaMaterialSubCat,
  pro.YY1_Generic_Name_PRD              as GenericName,
  pro.YY1_GenericName_PRD               as GenericText,
  pro.YY1_HighRiskMedication_PRD        as HighRiskMedication,
  pro.YY1_LookAlikeLA_PRD               as LookAlike,
  pro.YY1_NONPayableToECHSCG_PRD        as NONPayableToECHSCGHS,
  pro.YY1_NotPayableToGov_PRD           as NotPayableToGov,
  pro.YY1_PayableByHospital_PRD         as PayableByHospital,
  pro.YY1_ScheduleCategory_PRD          as ScheduleCategory,
  pro.YY1_ServiceCharge_PRD             as ServiceChargeApplicable,       
  pro.YY1_SoundAlikeSA_PRD              as SoundAlike,
  pro.YY1_StoragePolicy_PRD             as StoragePolicy,
  pro.YY1_TPAPayable_PRD                as TPAPayable,
  pro.YY1_VEDAnalysis_PRD               as VEDAnalysis           
  
  
}
