@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Uploader - Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_MRP_RV
  as select from zmm_mrp_tb1
{
  key recguid       as Recguid,

      @EndUserText.label: 'Attachments'
      @Semantics.largeObject:{fileName: 'Filename' ,
      acceptableMimeTypes: [ 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ],
                                mimeType: 'Minetype',
                                contentDispositionPreference: #INLINE
                                 }
      attachment    as Attachment,
      minetype      as Minetype,
      filename      as Filename,
      doctype       as Doctype,
      srcdtm        as Srcdtm,
      dtyptxt       as Dtyptxt,
      totprrec      as Totprrec,
      totprcrt      as Totprcrt,
      itmcid        as Itmcid,
      actcid        as Actcid,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat,
      status        as Status,
      decs          as Decs
}
