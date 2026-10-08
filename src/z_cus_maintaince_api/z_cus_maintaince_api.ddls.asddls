//@AbapCatalog.sqlViewName: 'ZPMASTER2_API2'
//@ClientHandling.type : #INHERITED
//@ClientHandling.algorithm : #SESSION_VARIABLE
@ObjectModel.usageType: {serviceQuality: #D, sizeCategory: #XL, dataClass: #TRANSACTIONAL}
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Z_CUS_MAINTAINCE_API'
@Search.searchable: false
@Metadata.ignorePropagatedAnnotations: true
define root view entity Z_CUS_MAINTAINCE_API
  as select from    I_MaintenanceOrderDEX  as A
  
  
    left outer join I_MaintenancePlanBasic as C on C.MaintenancePlan = A.MaintenancePlan
    left outer join I_MaintenanceOrderDEX  as D on D.MaintenanceOrder = A.MaintenanceOrder
                                                and D.MaintenancePlan = A.MaintenancePlan
  // right outer join  I_MaintenancePlanSchedule as  E on E.MaintenancePlan = A.MaintenancePlan                                          
                                                
{ 
  key A.MaintenanceOrder               as OrderID,
 // key A.MaintenanceOrder        as RoutingNumber,
  key A.Equipment                      as EquipmentNO,
      A.EquipmentName                  as EquipmentDesc,
      A.MaintOrdBasicStartDate         as ScheduledStart,
      A.MainWorkCenter                 as MainWorkCenter,
      A.MainWorkCenterPlant            as MainWorkCenterPlant,
      A.MaintenancePlannerGroup        as PlannerGroup,
      A.MaintenancePlanningPlant       as PlanningPlant,
      A.MaintOrdPersonResponsible      as PersonResponsible,
      //   A.o
      A.MaintenancePlan                as MaintenancePlan,
      A.LatestAcceptableCompletionDate as FinalDueDate,
      A.AssetRoom                      as Room,
      A.AssetLocation                  as Location,
      C.CreationDate                   as CreatedOn,
      D.MaintenanceOrderDesc           as MaintenanceItemDescribtion,
      D.MaintenanceActivityType        as Activitytype
    //  E.MaintenanceCallDate            as CallDate,
    //  E.MaintenanceCallNextPlannedDate as Planneddate
      
}
