@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Asset and Journal Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity ZFI_ASSETJOURNAL
  as select distinct from I_JournalEntry     as _joh
    inner join            I_JournalEntryItem as _joi on  _joi.CompanyCode            = _joh.CompanyCode
                                                     and _joi.FiscalYear             = _joh.FiscalYear
                                                     and _joi.AccountingDocument     = _joh.AccountingDocument
                                                     and _joi.Ledger                 = '0L'
                                                     and _joi.AccountingDocumentType = 'AA'
                                                     and _joi.LedgerGLLineItem       = '000001'

    inner join            I_FixedAsset       as _Fix on  _Fix.CompanyCode      = _joi.CompanyCode
                                                     and _Fix.MasterFixedAsset = _joi.MasterFixedAsset
    inner join            I_FixedAssetAssgmt as _Fixe on _Fixe.CompanyCode = _Fix.CompanyCode
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
         _Fix.FixedAssetDescription as Assetmatdes,
         _Fixe.Plant as Fromplant,
         _Fixe.AssetLocation as Fromlocation,
         _joi.PostingDate,
         _joi.BaseUnit                            as Uom,
         cast(_joi.Quantity as abap.dec( 23, 3 )) as Qty
}
where
  _joi.MasterFixedAsset is not initial;
