@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB/NRGB-Gate In - RE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_APP2_RV
  as select from zfi_app1_tb1
  composition [0..*] of ZFI_APP2_CIV         as _item
  composition [0..*] of ZFI_APP2_SWRV        as _work
  association [1..1] to I_BusinessUserBasic  as _uname    on $projection.Createdby = _uname.UserID
  association [1..1] to ZFI_GATEIN_STATUSVH  as _status   on $projection.Delmark = _status.value_low
  association [1..1] to ZFI_GATEOUT_STATUSVH as _gostatus on $projection.Gomark = _gostatus.value_low
{
  key uuid                  as Uuid,
      gpnum                 as Gpnum,
      gptype                as Gptype,
      postingdate           as Postingdate,
      documentdate          as Documentdate,
      movmenttype           as Movmenttype,
      remarks               as Remarks,
      plant                 as Plant,
      //      personfullname as Personfullname,
      delmark               as Delmark,
      mark                  as Mark,
      gomark                as Gomark,
      gateno                as Gateno,
      gitdat                as Gitdat,
      gittim                as Gittim,
      gotno                 as Gotno,
      gotdat                as Gotdat,
      gottim                as Gottim,
      statustext            as Statustext,
      purpose               as Purpose,
      gate                  as Gate,
      carriedby             as Carriedby,
      lastinvno             as Lastinvno,
      registerno            as Registerno,
      refno                 as Refno,
      refbldate             as Refbldate,
      location              as Location,
      goingwhere            as Goingwhere,
      gstin                 as Gstin,
      workorderno           as Workorderno,
      suppilername          as Suppilername,
      sno                   as Sno,
      workprocess           as Workprocess,
      serialno              as Serialno,
      hodprocesshead        as Hodprocesshead,
      wdv                   as Wdv,
      @Semantics.user.createdBy: true
      createdby             as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat             as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby         as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat         as Lastchangedat,
      _status.text          as Gateinstatus,
      _gostatus.text        as Gateoutstatus,
      _uname.PersonFullName as PersonFullName,
      _status,
      _gostatus,
      _item,
      _work
}
where
  mark = 'X'
