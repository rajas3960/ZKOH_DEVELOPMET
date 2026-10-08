@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'JE Customer payment - Projection Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZPE_GeneralJournalEntry
  provider contract transactional_query
  as projection on ZCE_GeneralJournalEntry
{
  key Uuid,
      Bukrs,
      Gjahr,
      Belnr,
      Waers,
      Bldat,
      Budat,
      Bktxt,
      Awkey,
      @Semantics.amount.currencyCode: 'Waers'
      Wrbtr,
      Sgtxt,
      Hkont,
      Kostl,
      Prctr,
      Hbkid,
      Hktid,
      Kunnr,
      Bbranc,
      Segment,
      Zuonr,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt
}
