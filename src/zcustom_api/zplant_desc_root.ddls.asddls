@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity Plant Desc'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZPLANT_DESC_ROOT
as select from I_MaterialStock_2  as MPS

// association [1..1] to I_Product                   as _Material                      on  $projection.Material = _Material.Product
{
//   @ObjectModel.foreignKey.association: '_Material'
   //key MPS.Material                                   as Material, 
   key MPS.Material                                       as Material,
   key MPS.Plant                                          as Plant, 
   key MPS.StorageLocation                                as StorageLocation,
   //MPS.Supplier                                       as Supplier,
   //MPS.Batch                                      as Batch,
   MPS._Material._Text.ProductName                as MaterialName,
   //MPS._Customer                                  as Customers,
   
 //MPSS._Material._Text.ProductName                    as MaterialName,
   MPS._Plant.PlantName                               as PlantName,
   MPS._StorageLocation.StorageLocationName           as StorageLocationName
  
   //MPS.MaterialBaseUnit                               as QtyUnit
   //@Semantics.quantity.unitOfMeasure: 'QtyUnit'
   //MPS.MatlWrhsStkQtyInMatlBaseUnit                   as MatlWrhsStkQtyInMatlBaseUnit
   //_Material
}
//._MaterialText.ProductDescription
 where  MPS.Plant <> '' and MPS.Material <> '' //and MPS.StorageLocation <> '', 
 group by MPS.Material,MPS.Plant,MPS.StorageLocation,MPS._Material._Text.ProductName, MPS._Plant.PlantName , MPS._StorageLocation.StorageLocationName
   //, MPS.Batch   
    

//key    
