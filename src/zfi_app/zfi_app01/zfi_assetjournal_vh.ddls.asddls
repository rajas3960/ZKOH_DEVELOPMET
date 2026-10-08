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
define view entity ZFI_ASSETJOURNAL_VH
  as select distinct from I_JournalEntry     as _joh
    inner join            I_JournalEntryItem as _joi  on  _joi.CompanyCode            = _joh.CompanyCode
                                                      and _joi.FiscalYear             = _joh.FiscalYear
                                                      and _joi.AccountingDocument     = _joh.AccountingDocument
                                                      and _joi.Ledger                 = '0L'
                                                      and _joi.AccountingDocumentType = 'AA'
//                                                      and _joi.LedgerGLLineItem       = '000001'
                                                      and _joi.FinancialTransactionType = '920'
                                                      and _joi.AssetTransactionType = '330'

    inner join            I_FixedAsset       as _Fix  on  _Fix.CompanyCode      = _joi.CompanyCode
                                                      and _Fix.MasterFixedAsset = _joi.MasterFixedAsset
    inner join            I_FixedAssetAssgmt as _Fixe on  _Fixe.CompanyCode      = _Fix.CompanyCode
                                                      and _Fixe.MasterFixedAsset = _Fix.MasterFixedAsset

{
         @Search.defaultSearchElement: true
  key    _joi.CompanyCode,
  key    _joi.AccountingDocument,
  key    _joi.FiscalYear,
         _joi.LedgerGLLineItem,
         _joi.AccountingDocumentType,
         @Search.defaultSearchElement: true
         _joi.MasterFixedAsset,
         _joi.FixedAsset,
         _Fix.FixedAssetDescription               as Assetmatdes,
         _Fixe.Plant                              as Toplant,
         _Fixe.AssetLocation                      as Tolocation,
         _Fix.Inventory as Inventoryno,
         _joi.PostingDate,
         _joi.BaseUnit                            as Uom,
         cast(_joi.Quantity as abap.dec( 23, 3 )) as Qty,
         _joi.FinancialTransactionType,
         _joi.AssetTransactionType,
         _joi.PartnerMasterFixedAsset
}
where
  _joi.MasterFixedAsset is not initial
