@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'hsn upload app item2'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZMM_APP01_IRV2
  as select from zmm_app01_itb2

association to parent ZMM_APP01_IRV as _item2
  on  _item2.Suid = $projection.Suid
  and _item2.Matnr = $projection.Material
association[1..1] to ZMM_APP01_rv as _hdr on _hdr.Suid = $projection.Suid

{
    key uuid as Suid,
    key matnr as Material,
    key slno  as Slno,
    hsn as Hsn,
    tax as Tax,
    @Semantics.user.createdBy: true
    createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    createdon as Createdon,
    changetime,
    _item2,
    _hdr
}
