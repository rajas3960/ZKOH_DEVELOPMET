@EndUserText.label: 'Root entity view  for Fixed Asset Data'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_FIXED_ASSET_ROOT 
as select from I_FixedAsset  as asset
association [1..1] to I_FixedAssetAssgmt as _assetseg on $projection.fixedasset = _assetseg.MasterFixedAsset
                                                         and asset.CompanyCode    = _assetseg.CompanyCode
association [1..1] to I_FixedAssetForLedger as _asset_led on $projection.fixedasset = _asset_led.MasterFixedAsset
                                                         and asset.CompanyCode    = _asset_led.CompanyCode 
                                                         and  _asset_led.Ledger = '0L'                                                        
//inner join I_FixedAssetAssgmt as assetseg on assetseg.MasterFixedAsset = asset.MasterFixedAsset
//                                          and assetseg.CompanyCode    = asset.CompanyCode
//inner join I_FixedAssetForLedger as asset_led on asset_led.MasterFixedAsset = asset.MasterFixedAsset   
//                                              and asset_led.CompanyCode = asset.CompanyCode        
//                                              and asset_led.Ledger = '0L'                         
{
  key asset.MasterFixedAsset   as fixedasset  ,
  key _assetseg.Plant             as plant,
  asset.FixedAssetDescription    as assetdescription,
  _asset_led.AssetCapitalizationDate  as dateofCapitalization  
}

