@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Payment'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_JENTRY_RPV
  provider contract transactional_query
  as projection on ZI_JENTRY_RV
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
      amnt,
      glacct,
      lineitm,
      curr,
      /* Associations */
      _item
}
