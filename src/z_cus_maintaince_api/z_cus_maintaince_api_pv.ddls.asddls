@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Z_CUS_MAINTAINCE_API_PV 

as projection on Z_CUS_MAINTAINCE_API
{
    key OrderID,
  //  key RoutingNumber,
    key EquipmentNO,
    EquipmentDesc,
    ScheduledStart,
    MainWorkCenter,
    MainWorkCenterPlant,
    PlannerGroup,
    PlanningPlant,
    PersonResponsible,
    MaintenancePlan,
    FinalDueDate,
    Room,
    Location,
    CreatedOn
}
