@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB/NRGB-Gate In & Out - SWPV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZFI_APP2_SWPV
  as projection on ZFI_APP2_SWRV
{
  key Uuid,
  key Poorder,
  key Poitem,
      Materialnumber,
      Productdes,
      Pounit,
      @Semantics.quantity.unitOfMeasure: 'Pounit'
      Poqty,
      @Semantics.quantity.unitOfMeasure: 'Pounit'
      Recqty,
      @Semantics.quantity.unitOfMeasure: 'Pounit'
      Penqty,
      Documcurrency,
      @Semantics.amount.currencyCode: 'Documcurrency'
      Pocost,
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,
      /* Associations */
      _Header : redirected to parent ZFI_APP2_RPV
}
