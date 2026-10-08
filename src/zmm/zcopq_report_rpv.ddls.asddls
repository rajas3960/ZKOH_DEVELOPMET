@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view- COPQ'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED

}
define root view entity ZCOPQ_REPORT_RPV
  as select from ZCOPQ_REPORT_RE
{
  key Itemcode,
  key Plant,
  key    Batch,
      Vtype,
      storage_loc,
      Slotype,
      Uom,
      Itemdesc,
      Movementtype,
//      activity_type,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Qty,
      ccucy,
      @Semantics.amount.currencyCode: 'ccucy'
      MaterialV,
      
      @Semantics.amount.currencyCode: 'ccucy'
      Materialc,
      @Semantics.amount.currencyCode: 'ccucy'
      Machineval,
     @Semantics.amount.currencyCode: 'ccucy'
      labval,
    @Semantics.amount.currencyCode: 'ccucy'
      Powerval,
      @Semantics.amount.currencyCode: 'ccucy'
      Totalcost,
      @Semantics.amount.currencyCode: 'ccucy'
      Overallvalue,
      orderr,
      Startingd
}
