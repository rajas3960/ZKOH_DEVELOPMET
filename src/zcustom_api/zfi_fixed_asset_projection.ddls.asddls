@EndUserText.label: 'Projection View Fixed Asset'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }


define root view entity ZFI_FIXED_ASSET_PROJECTION 
provider contract transactional_query
as projection on ZFI_FIXED_ASSET_ROOT
{
  key fixedasset,
  key plant,
  assetdescription,
  dateofCapitalization  
}
