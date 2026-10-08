@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB/NRGB-Gate In - CIV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_APP2_CIV
  as select from zfi_app1_tb2
  association to parent ZFI_APP2_RV as _Header on $projection.Uuid = _Header.Uuid
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
      inventoryno   as Inventoryno,
      toplantname   as Toplantname,
      fromplantname as Fromplantname,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      recivedqty    as Recivedqty,
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
      _Header
}
