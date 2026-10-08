@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB/NRGB-Gate In & Out - CIV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZFI_APP1_CIV
  as select from zfi_app1_tb2
  association to parent ZFI_APP1_RV as _Header on $projection.Uuid = _Header.Uuid
  association to I_PlantStdVH as _top on $projection.Toplant = _top.Plant
  association to I_PlantStdVH as _fromp on $projection.Fromplant = _fromp.Plant
{
  key uuid          as Uuid,
  key transposno    as Transposno,
  key itemno        as Itemno,
      assetmat      as Assetmat,
      assetmatdes   as Assetmatdes,
      uom           as Uom,
      qty           as Qty,
      batch         as Batch,
      fromplant     as Fromplant,
      fromlocation  as Fromlocation,
      toplant       as Toplant,
      tolocation    as Tolocation,
      inventoryno as Inventoryno,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      recivedqty as recivedqty,
      overallstatus as Overallstatus,
      serialnumber as Serialnumber,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat,
      _top.PlantName as toplantname,
      _fromp.PlantName as fromplantname,
      _Header
}
