@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Mass PR Uploader - Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED

}
define root view entity ZMM_MRP_RPV
provider contract transactional_query
  as projection on ZMM_MRP_RCV
{
  key Recguid,
      @ObjectModel.text.element: [ 'Dtyptxt' ]
      
      Doctype,
    @EndUserText.label: 'Attachments'
      @Semantics.largeObject:{fileName: 'Filename' ,
      acceptableMimeTypes: [ 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ],
                                mimeType: 'Minetype',
                                contentDispositionPreference: #INLINE
                                 }  
      Attachment,
      Filename,
        @Semantics.mimeType: true
      Minetype,
      Srcdtm,
      Dtyptxt,
      Totprrec,
      Totprcrt,
      Itmcid,
      Actcid,
      @Semantics.user.createdBy: true
      Createdby,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
       @Semantics.user.lastChangedBy: true
      Lastchangedby,
       @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat,
      Status,
      Decs,
      _Items : redirected to composition child ZMM_MRP_IPV1,
      _Pritm : redirected to composition child ZMM_MRP_IPV2
}
