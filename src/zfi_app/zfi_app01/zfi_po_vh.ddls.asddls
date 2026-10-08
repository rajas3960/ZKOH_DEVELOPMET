@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity ZFI_PO_VH
  as select from I_PurchaseOrderAPI01 as POH
    inner join   I_Supplier               as SUP on SUP.Supplier = POH.Supplier
{
      @Search.defaultSearchElement: true
  key POH.PurchaseOrder,
      @Search.defaultSearchElement: true
      POH.Supplier,
      SUP.BPSupplierFullName
}
