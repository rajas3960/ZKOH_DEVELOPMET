@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity Journal Entry Header'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_PV_RVE_JE
  as select from I_JournalEntry as jeh
{
  key jeh.AccountingDocument,
  key jeh.FiscalYear,
  key jeh.CompanyCode,

      max( jeh.DocumentReferenceID ) as DocumentReferenceID,
      max( jeh.AccountingDocumentCreationDate ) as AccountingDocumentCreationDate,
      max( jeh.AccountingDocCreatedByUser ) as AccountingDocCreatedByUser
}
group by
  jeh.AccountingDocument,
  jeh.FiscalYear,
  jeh.CompanyCode
