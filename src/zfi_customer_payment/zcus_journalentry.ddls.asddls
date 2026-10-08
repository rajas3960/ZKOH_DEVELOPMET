@EndUserText.label: 'Customer Journal Entry'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZCUS_JOURNALENTRY
  provider contract transactional_query
  as projection on I_JournalEntryTP
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
      LedgerGroup,
      ReferenceDocumentType,
      OriginalReferenceDocument,
      ReferenceDocumentLogicalSystem,
      BusinessTransactionType,
      AccountingDocumentType,
      TaxReportingDate,
      InvoiceReceiptDate,
      ExchangeRateDate,
      DocumentDate,
      PostingDate,
      AccountingDocCreatedByUser,
      DocumentReferenceID,
      AccountingDocumentHeaderText,
      JrnlEntryCntrySpecificRef1,
      JrnlEntryCntrySpecificDate1,
      JrnlEntryCntrySpecificRef2,
      JrnlEntryCntrySpecificDate2,
      JrnlEntryCntrySpecificRef3,
      JrnlEntryCntrySpecificDate3,
      JrnlEntryCntrySpecificRef4,
      JrnlEntryCntrySpecificDate4,
      JrnlEntryCntrySpecificRef5,
      JrnlEntryCntrySpecificDate5,
      JrnlEntryCntrySpecificBP1,
      JrnlEntryCntrySpecificBP2
}
