@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view of RE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZCUST_HSN_TB_PV as select from ZCUST_HSN_TB_RE
{
    key Hsn,
    key Gstrate
}
