@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'JE Customer payment - Consumption Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZCE_GeneralJournalEntry
  as select from zcje_header
  //composition of target_data_source_name as _association_name
{
  key uuid                  as Uuid,
      bukrs                 as Bukrs,
      gjahr                 as Gjahr,
      belnr                 as Belnr,
      waers                 as Waers,
      bldat                 as Bldat,
      budat                 as Budat,
      bktxt                 as Bktxt,
      awkey                 as Awkey,
      @Semantics.amount.currencyCode: 'Waers'
      wrbtr                 as Wrbtr,
      sgtxt                 as Sgtxt,
      hkont                 as Hkont,
      kostl                 as Kostl,
      prctr                 as Prctr,
      hbkid                 as Hbkid,
      hktid                 as Hktid,
      kunnr                 as Kunnr,
      bbranc                as Bbranc,
      segment               as Segment,
      zuonr                 as Zuonr,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
      //    _association_name // Make association public
}
