@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB/NRGB-Gate In - CPIV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZFI_APP2_CIPV 
as projection on ZFI_APP2_CIV
{
    key Uuid,
    key Transposno,
    key Itemno,
    Assetmat,
    Assetmatdes,
    Uom,
    Qty,
    Batch,
    Fromplant,
    Fromlocation,
    Toplant,
    Tolocation,
    Inventoryno,
    Toplantname,
    Fromplantname,
      @Semantics.quantity.unitOfMeasure: 'Uom'    
    Recivedqty,
    Overallstatus,
    Serialnumber,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
    _Header : redirected to parent ZFI_APP2_RPV
}
