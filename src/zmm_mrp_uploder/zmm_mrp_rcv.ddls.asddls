@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Uploader - Root Centity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_MRP_RCV 
as select from ZMM_MRP_RV
composition [0..*] of ZMM_MRP_ICV1 as _Items
composition [0..*] of ZMM_MRP_ICV2 as _Pritm
association [0..1] to I_PurchasingDocumentTypeText as _prtyp on $projection.Doctype = _prtyp.PurchasingDocumentType
{
    key Recguid,
    @EndUserText.label: 'Attachments'
      @Semantics.largeObject:{fileName: 'Filename' ,
      acceptableMimeTypes: [ 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ],
                                mimeType: 'Minetype',
                                contentDispositionPreference: #INLINE
                                 }
    Attachment,
    Filename,
    Minetype,    
    Doctype,
    Srcdtm,
    Dtyptxt,
    Totprrec,
    Totprcrt,
    Itmcid,
    Actcid,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    Status,
    Decs,
    _Items,
    _Pritm,
    _prtyp
}
