@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB/NRGB-Gate In & Out - CPIV'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_APP1_CPIV
  as projection on ZFI_APP1_CIV
{
  key Uuid,
  key Transposno,
  key Itemno,
      Assetmat,
      Assetmatdes,
      Uom,
      Qty,
      Batch,
      @ObjectModel.text.element: [ 'fromplantname' ]
      Fromplant,
      Fromlocation,
      @ObjectModel.text.element: [ 'toplantname' ]
      Toplant,
      Tolocation,
      Inventoryno,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      recivedqty as recivedqty, 
      Overallstatus, 
      Serialnumber,    
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,
      toplantname,
      fromplantname,
      /* Associations */
      _Header : redirected to parent ZFI_APP1_RPV
}
