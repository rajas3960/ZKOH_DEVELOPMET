@AbapCatalog.sqlViewName: 'ZPMASTER_API'
@ClientHandling.type : #INHERITED
@ClientHandling.algorithm : #SESSION_VARIABLE
@ObjectModel.usageType: {serviceQuality: #D, sizeCategory: #XL, dataClass: #TRANSACTIONAL}
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View For PMaster'
@Search.searchable: false
@Metadata.ignorePropagatedAnnotations: true
define view ZMM_PMaster_View 
as select from  I_Product                     as pro
left outer join I_ProductText                 as protxt    on protxt.Product = pro.Product 
                                                          and protxt.Language = 'E'
left outer join I_ProductTypeText             as ptYtX     on ptYtX.ProductType = pro.ProductType
                                                          and ptYtX.Language = 'E'      
left outer join I_ProductGroupText_2          as PGTX      on PGTX.ProductGroup = pro.ProductGroup
                                                          and PGTX.Language = 'E'                                                                                                             
left outer join I_ProductSalesDelivery        as PSD       on PSD.Product = pro.Product
left outer join I_ProductSalesTax             as PSTAX     on PSTAX.Product = pro.Product 
                                                          and PSTAX.Country = 'IN'
left outer join I_ProductCategoryText         as PCTXT     on PCTXT.ProductCategory = pro.ProductCategory
                                                          and PCTXT.Language = 'E'
left outer join I_ProductPlantBasic           as PPlnt     on PPlnt.Product = pro.Product 
left outer join I_Plant                       as Plt       on Plt.Plant = PPlnt.Plant   
left outer join I_ProductSales                as Psale     on Psale.Product = pro.Product
left outer join I_ProductPlantSupplyPlanning  as PPSP      on PPSP.Product = pro.Product 
left outer join I_StorageLocation             as ProSt     on ProSt.Plant = PPlnt.Plant
left outer join I_ProductValuationBasic       as PvB       on PvB.Product = pro.Product
left outer join I_ProductStorage_2            as Psto      on Psto.Product = pro.Product   
left outer join I_ProductUnitsOfMeasure       as PUM       on PUM.Product = pro.Product
                                                                                             
{
 key pro.Product                        as ProductNo,
  protxt.ProductName                    as ProductDesc,
  pro.ProductType                       as producttype,
  ptYtX.MaterialTypeName                as ProdusttypeText,
  pro.BaseUnit                          as Baseunit,
  pro.ProductGroup                      as ProductGroup,
  PGTX.ProductGroupText                 as ProductGrouptext,
  PSD.ProductSalesOrg                   as proSalesOrg,
  PSD.ProductDistributionChnl           as ProDistri,
  PSTAX.TaxClassification               as TaxClassification,
  pro.ItemCategoryGroup                 as itemCatGroup,
  PCTXT.Name                            as ItemCatGroupDec,
  pro.Division                          as Division,
  PPlnt.AvailabilityCheckType           as AvailabilityCheckType,
  PPlnt.IsNegativeStockAllowed          as IsNegativeStockAllowed,
  pro.IsBatchManagementRequired         as IsBatchManagementRequired,
  PPlnt.Plant                           as Plant,
  Plt.PlantName                         as PlantDesc,
  PPlnt.IsBatchManagementRequired       as IsBatchManagementRequiredPlant,
  Psale.TransportationGroup             as TransportationGroup,
  Psale.LoadingGroup                    as LoadingGroup,
  PPlnt.ProfitCenter                    as ProfitCenter,
  PPlnt.ConsumptionTaxCtrlCode          as ConsumptionTaxCtrlCode,
  pro.PurchaseOrderQuantityUnit         as PurchaseOrderQuantityUnit,
  pro.VarblPurOrdUnitIsActive           as VarblPurOrdUnitIsActive,
  PPlnt.PurchasingGroup                 as PurchasingGroup,
  PPlnt.MRPType                         as MRPType,
  PPlnt.MRPResponsible                  as MRPResponsible,
  PPlnt.PlannedDeliveryDurationInDays   as PlannedDeliveryDurationInDays, 
  pro.WeightUnit                        as weightunit,
  PPSP.ProcurementType                  as ProcurementType,
  pro.IsBatchManagementRequired         as BatchManagreq,
  ProSt.StorageLocation                 as StorageLocation,
  ProSt.StorageLocationName             as StorageLocationName,
  pro.IsMarkedForDeletion               as IsMarkedForDeletion,
  Psto.TemperatureConditionInd          as TemperatureConditionInd,
  PvB.ValuationClass                    as ValuationClass,
  PvB.InventoryValuationProcedure       as inventoryValuationProcedure,
  PvB.ValuationCategory                 as ValuationCategory,
  PUM.AlternativeUnit                   as AlternativeUnit,
  PUM.QuantityNumerator                 as QuantityNumerator,
  PUM.QuantityDenominator               as QuantityDenominator,
  pro.CreationDate                      as CreatedOn,
  pro.LastChangeDate                    as LastChangeDate,
  pro.YY1_Packing_PRD                   as Packing,
  pro.YY1_EmergencyDrug_PRD             as EmergencyDrug
  
}
