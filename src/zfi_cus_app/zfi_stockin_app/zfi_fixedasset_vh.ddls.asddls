@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fixed Asset Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity ZFI_FIXEDASSET_VH as select from I_FixedAsset as _Fixed
        inner join I_FixedAssetAssgmt as _fd on _fd.CompanyCode = _Fixed.CompanyCode
                            and _fd.MasterFixedAsset = _Fixed.MasterFixedAsset
{

@Search.defaultSearchElement: true
key _Fixed.MasterFixedAsset as Transposno,
@Search.defaultSearchElement: true
key _Fixed.CompanyCode,
@UI.hidden: true
key _Fixed.FixedAsset,
_Fixed.AssetClass,
_Fixed.Inventory,
_Fixed.FixedAssetDescription,
_fd.Plant as Plant

}
