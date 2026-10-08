@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection of Reservation'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_RESERVATION_PV
  provider contract transactional_query as projection on ZI_RESERVATION
{
    key Reservation,
    key ReservationItem,
    key RecordType,
    GoodsMovementType,
    HMSNUMBER,
    ReservationToPlant,
    ReservationFromPlant,
    ReservationApprove,
    ReservationRemark,
    material,
    MaterialDocument,
    MaterialDocumentItem,
    MaterialDocumentYear,
    Quantity,
    CreatedOn,
    CreatedBy,
    Plant,
    Batch,
    ValuationType,
    InventorySpecialStockType,
    WBSInternalID,
    RequirementType,
    ResevationStatus,
    RequirementDate,
    ManufacturingOrderOperation,
    GoodsMovementIsAllowed,
    BaseUnit,
    GLAccount,
    Supplier,
    PurchaseRequisition,
    MaterialGroup
}
