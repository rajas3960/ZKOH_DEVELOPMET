@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Document Type Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_PRDOCTYP_VH
  as select from I_PurchasingDocumentTypeText 
{
  key PurchasingDocumentType     as prtype,
      @UI.hidden: true
  key PurchasingDocumentCategory,
      @UI.hidden: true
  key Language,
      PurchasingDocumentTypeName as name,
      /* Associations */
      @UI.hidden: true
      _Language,
      @UI.hidden: true
      _PurchasingDocumentCategory,
      @UI.hidden: true
      _PurchasingDocumentType
}
where
      PurchasingDocumentCategory = 'B'
  and Language                   = 'E'
