@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Creation - Root CEntity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED 
}
define root view entity ZMRPPLAN01_RCV
  as select from ZMRPPLAN01_RV
  composition [0..*] of ZMRPPLAN01_ICV1              as _litem
  composition [0..*] of ZMRPPLAN01_ICV2              as _pritm
  association [0..1] to I_PurchasingDocumentTypeText as _prtyp on $projection.Doctype = _prtyp.PurchasingDocumentType
{
  key Recguid,
      Doctype,
      Srcdtm,
      Dtyptxt,
      Totprrec,
      Totprcrt,
      Totporec,
      Totpocrt,
      Createdat,
      Lastchngby,
      Lastchngat,
      Createdby,
      Status,
      _litem,
      _pritm,
      _prtyp
}
