@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB/NRGB-Gate In & Out - SWRV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_APP2_SWRV as select from zfi_app1_tb3
  association to parent ZFI_APP2_RV as _Header on $projection.Uuid = _Header.Uuid
{
    key uuid as Uuid,
    key poorder as Poorder,
    key poitem as Poitem,
    materialnumber as Materialnumber,
    productdes as Productdes,
    pounit as Pounit,
    @Semantics.quantity.unitOfMeasure: 'Pounit'
    poqty as Poqty,
    @Semantics.quantity.unitOfMeasure: 'pounit'  
    recqty as Recqty,
    @Semantics.quantity.unitOfMeasure: 'pounit'
    penqty as Penqty,
    documcurrency as Documcurrency,
    @Semantics.amount.currencyCode: 'Documcurrency'
    pocost as Pocost,
      @Semantics.user.createdBy: true    
    createdby as Createdby,
      @Semantics.systemDateTime.createdAt: true    
    createdat as Createdat,
      @Semantics.user.lastChangedBy: true    
    lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true    
    lastchangedat as Lastchangedat,
    _Header
}
