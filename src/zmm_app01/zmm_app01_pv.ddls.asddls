@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'hsn upload app'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP01_PV provider contract transactional_query as projection on ZMM_APP01_rv
{
    key Suid,
     @EndUserText.label: 'Attachments'
      @Semantics.largeObject:{fileName: 'Filename' ,
      acceptableMimeTypes: [ 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ],
                                mimeType: 'Minetype',
                                contentDispositionPreference: #INLINE
                                 }
    Attachment,
        @Semantics.mimeType: true
    Minetype,
    Filename,
    Status,
    Deletion,
    @Semantics.user.createdBy: true
    Createdby,
     @Semantics.systemDateTime.createdAt: true
    Createdon,
    _ITEM : redirected to composition child  ZMM_APP01_IPV
}
