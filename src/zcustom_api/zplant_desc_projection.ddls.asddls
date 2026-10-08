@EndUserText.label: 'Projection View For Plant Desc'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }

define root view entity ZPLANT_DESC_PROJECTION 
provider contract transactional_query
as projection on ZPLANT_DESC_ROOT
{
    key Material,
    key Plant,
    key StorageLocation,
   // Supplier,
    //Batch,
    //MaterialName,
    MaterialName,
    //Customers,
    PlantName,
    StorageLocationName
    
 //   QtyUnit
//   @Semantics.quantity.unitOfMeasure: 'QtyUnit'
//    MatlWrhsStkQtyInMatlBaseUnit
}



//key    
