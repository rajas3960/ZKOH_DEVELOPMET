@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Gate Entry Child Projection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZFI_APP01_CPV as projection on ZFI_APP01_CV
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
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
    _Header : redirected to parent ZFI_APP01_RPV
    
}    
