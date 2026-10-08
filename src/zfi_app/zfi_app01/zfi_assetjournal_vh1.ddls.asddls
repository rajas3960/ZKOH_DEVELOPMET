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
define view entity ZFI_ASSETJOURNAL_VH1 
as select from ZFI_ASSETJOURNAL_VH as _joi
    inner join            I_FixedAsset       as _Fix  on  _Fix.CompanyCode      = _joi.CompanyCode
                                                      and _Fix.MasterFixedAsset = _joi.PartnerMasterFixedAsset
    inner join            I_FixedAssetAssgmt as _Fixe on  _Fixe.CompanyCode      = _Fix.CompanyCode
                                                      and _Fixe.MasterFixedAsset = _Fix.MasterFixedAsset

{
         @Search.defaultSearchElement: true
    key _joi.CompanyCode,
         @Search.defaultSearchElement: true    
    key _joi.AccountingDocument,
         @Search.defaultSearchElement: true    
    key _joi.FiscalYear,
    @UI.hidden: true
    _joi.LedgerGLLineItem,
    _joi.AccountingDocumentType,
         @Search.defaultSearchElement: true    
    _joi.MasterFixedAsset,
    @UI.hidden: true
    _joi.FixedAsset,
    _joi.Assetmatdes,
    _joi.Toplant,
    _joi.Tolocation,
    _joi.Inventoryno,
    _Fixe.Plant as Fromplant,
    _Fixe.AssetLocation as Fromlocation,
    _joi.PostingDate,
    _joi.Uom,
    _joi.Qty,
    _joi.FinancialTransactionType,
    _joi.AssetTransactionType,
    _joi.PartnerMasterFixedAsset
}
