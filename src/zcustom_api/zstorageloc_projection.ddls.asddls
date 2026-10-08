@EndUserText.label: 'Projection View For Plant Desc'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }

define root view entity ZSTORAGELOC_PROJECTION 
provider contract transactional_query
as projection on ZSTORAGELOC_ROOT

{
key Plant,
key StorageLocation,
Plant_StorageLoc,
StorageLocationName


}
