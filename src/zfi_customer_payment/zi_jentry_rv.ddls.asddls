@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_JENTRY_RV
  as select from I_JournalEntry
  association [0..*] to I_JournalEntryItem as _item on $projection.AccountingDocument = _item.AccountingDocument
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
      AccountingDocumentType,
      DocumentDate,
      PostingDate,
      AccountingDocCreatedByUser,
      DocumentReferenceID,
      AccountingDocumentHeaderText,
      BusinessTransactionType,
      @Semantics.amount.currencyCode: 'curr'
      _item.AmountInCompanyCodeCurrency   as amnt,
      _item.GLAccount                     as glacct,
      _item.LedgerGLLineItem              as lineitm,
      _item._CompanyCodeCurrency.Currency as curr,
      _item


}
