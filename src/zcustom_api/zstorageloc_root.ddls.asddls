@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity Plant Desc'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZSTORAGELOC_ROOT
as select from I_StorageLocation  as SL

{
key Plant                as Plant,
key StorageLocation      as StorageLocation,
concat(SL.Plant,SL.StorageLocation) as Plant_StorageLoc,
SL.StorageLocationName   as StorageLocationName

}
where SL.Plant <>'' and SL.StorageLocation <> ''

group by SL.Plant , SL.StorageLocation , SL.StorageLocationName
