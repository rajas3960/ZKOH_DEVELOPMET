@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity of reservation'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_RESERVATION
  as select from    I_ReservationDocumentItem   as RDI

    left outer join I_ReservationDocumentHeader as RD  on RD.Reservation = RDI.Reservation
    left outer join I_MaterialDocumentItem_2    as MDI on  MDI.Reservation     = RDI.Reservation
                                                       and MDI.ReservationItem = RDI.ReservationItem
                                                       and MDI.Material        = RDI.Product

{

  key RDI.Reservation,
  key RDI.ReservationItem,
  key RDI.RecordType,
      RDI.GoodsMovementType,
      MDI.YY1_HMSNUMBER_MMI           as HMSNUMBER,
      MDI.YY1_ReservationToPlant_MMI  as ReservationToPlant,
      MDI.YY1_ReservationFromPln_MMI  as ReservationFromPlant,
      MDI.YY1_ReservationApprove_MMI  as ReservationApprove,
      MDI.YY1_ReservationRemark_MMI   as ReservationRemark,
      RDI.Product                     as material,
      MDI.MaterialDocument,
      MDI.MaterialDocumentItem,
      MDI.MaterialDocumentYear,
      RDI.QuantityIsFixed             as Quantity,
      RD.CreationDateTime             as CreatedOn,
      RD._Customer.CreatedByUser      as CreatedBy,
      RDI.Plant,
      RDI.RealProductBatch            as Batch,
      RDI.ValuationType,
      RDI.InventorySpecialStockType,
      RDI.SpecialStockIdfgWBSElement  as WBSInternalID,
      RDI.RequirementType,
      RDI.ReservationItemCreationCode as ResevationStatus,
      RDI.MatlCompRequirementDate     as RequirementDate,
      RDI.ManufacturingOrderOperation,
      RDI.GoodsMovementIsAllowed,
      RDI.BaseUnit,
      RDI.GLAccount,
      RDI.Supplier,
      RDI.PurchaseRequisition,
      RDI.MaterialGroup

}
