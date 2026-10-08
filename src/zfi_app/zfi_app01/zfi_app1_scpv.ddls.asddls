@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB/NRGB-Gate In & Out - WRPV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZFI_APP1_SCPV
  as projection on ZFI_APP1_SCV
{
  key Uuid,
  key Poorder,
  key Poitem,
      Materialnumber,
      Productdes,
      Pounit,
      @Semantics.quantity.unitOfMeasure: 'pounit'      
      Poqty,
//      @Semantics.quantity.unitOfMeasure: 'pounit'
//      Recqty,
      Documcurrency,
      @Semantics.amount.currencyCode: 'Documcurrency'
      Pocost,
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,
      /* Associations */
      _Header : redirected to parent ZFI_APP1_RPV
}
