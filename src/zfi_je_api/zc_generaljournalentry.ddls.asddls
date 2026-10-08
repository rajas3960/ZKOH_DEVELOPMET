@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL Journal Entry Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_GeneralJournalEntry
  provider contract transactional_query
  as projection on ZR_GeneralJournalEntry
{
  key Uuid,
      Bukrs,
      Gjahr,
      Belnr,
      Waers,
      Bldat,
      Budat,
      Bktxt,
      Created_By,
      Created_At,
      Last_Changed_By,
      Last_Changed_At,
      Local_Last_Changed_At,
      /* Associations */
      _Item : redirected to composition child ZC_GeneralJournalEntryItem 
}
