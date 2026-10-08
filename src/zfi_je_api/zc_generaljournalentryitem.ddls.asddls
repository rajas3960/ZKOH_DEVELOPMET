@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL Journal Item Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_GeneralJournalEntryItem
  as projection on ZR_GeneralJournalEntryItem
{
  key Uuid,
  key Buzei,
      @Semantics.amount.currencyCode: 'Waers'
      Wrbtr,
      Waers,
      sgtxt,
      hkont,
      Kostl,
      Prctr,
      @Semantics.user.createdBy: true
      Item_Created_By,
      @Semantics.systemDateTime.createdAt: true
      Item_Created_At,
      @Semantics.user.lastChangedBy: true
      Item_Last_Changed_By,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Item_Last_Changed_At,
      /* Associations */
      _Header : redirected to parent ZC_GeneralJournalEntry
}
