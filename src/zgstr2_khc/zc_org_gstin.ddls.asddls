@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for ORG GSTIN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_ORG_GSTIN
  provider contract transactional_query
  as projection on ZI_ORG_GSTIN
{
      @EndUserText.label: 'Company_Code'
  key CompCode,
      @EndUserText.label: 'Plant'
  key Plant,
  @EndUserText.label: 'Business Place'
  key BusinessPlace,
      @EndUserText.label: 'GSTIN'
      Gstin,
      @EndUserText.label: 'GST RETENTION START DATE'
      gstretenstdt,
      @EndUserText.label: 'E_Invoice'
      e_invoice
}
