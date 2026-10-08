@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'hsn upload item'

define view entity ZMM_APP01_IRV
  as select from zmm_app01_itb1

association to parent ZMM_APP01_rv as _HDR
  on $projection.Suid = _HDR.Suid

composition [0..*] of ZMM_APP01_IRV2 as _ITEM1

{
    key suid  as Suid,
    key matnr as Matnr,
    hsn       as Hsn,
    tax       as Tax,
    @Semantics.user.createdBy: true
    createdby,
    createdon,
      lastchngby               as Lastchngby,
      lastchngat               as Lastchngat,
      changetime,
      status   as Status,
    _HDR,
    _ITEM1
}
