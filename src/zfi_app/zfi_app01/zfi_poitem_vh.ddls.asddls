@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity ZFI_POITEM_VH
  as select from I_PurchaseOrderItemAPI01 as POI
    inner join   I_ProductDescription     as PDES on  PDES.Product  = POI.Material
                                                  and PDES.Language = $session.system_language
{
      @Search.defaultSearchElement: true
  key POI.PurchaseOrder,
      @Search.defaultSearchElement: true
  key POI.PurchaseOrderItem,
      @Search.defaultSearchElement: true
      POI.Material,
      POI.Plant,
      POI.BaseUnit as Pounit,
      cast(POI.OrderQuantity as abap.dec( 15, 3 )) as Poqty,
      PDES.ProductDescription as Productdes
}
