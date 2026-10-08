@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COPQ REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZCOPQ_REPORT_RE
  as select from    I_MaterialDocumentItem_2  as Pce
    left outer join I_Product                 as Pd     on Pd.Product = Pce.Material

    left outer join I_ProductCostEstimate     as HDR    on  HDR.Product         = Pce.Material
                                                        and HDR.Plant           = Pce.Plant
                                                        and HDR.ControllingArea = Pce.ControllingArea
                                                        and HDR.ProfitCenter    = Pce.ProfitCenter
                                                        
                                                        and HDR.CompanyCode     = Pce.CompanyCode




    left outer join I_StorageLocation         as ST     on  ST.Plant           = Pce.Plant
                                                        and ST.StorageLocation = Pce.StorageLocation
    left outer join I_ProductDescription      as Pdes   on  Pdes.Product  = Pce.Material
                                                        and Pdes.Language = 'E'

      left outer join I_ProductCostEstimateItem as Amt    on
                                                             
                                                            Amt.Product = HDR.Product
                                                            and Amt.CostingItemCategory = 'M'

  //
  ////  //
   inner join I_ProductCostEstimateItem as PP_MAC on  PP_MAC.CostEstimate           = HDR.CostEstimate
                                                        and PP_MAC.CostingType            = HDR.CostingType
                                                        and PP_MAC.CostingDate            = HDR.CostingDate
                                                        and PP_MAC.CostingVersion         = HDR.CostingVersion
                                                        and PP_MAC.ValuationVariant       = HDR.ValuationVariant
                                                        and PP_MAC.CostIsEnteredManually  = HDR.CostIsEnteredManually
                                                        and PP_MAC.CostingReferenceObject = HDR.CostingReferenceObject
//                                                        and PP_MAC.CostingItemCategory    = 'E'
                                                        and PP_MAC.CostCtrActivityType    = 'PP_MAC'
    inner join I_ProductCostEstimateItem as PP_LAB on  PP_LAB.CostEstimate           = HDR.CostEstimate
                                                        and PP_LAB.CostingType            = HDR.CostingType
                                                        and PP_LAB.CostingDate            = HDR.CostingDate
                                                        and PP_MAC.ValuationVariant       = HDR.ValuationVariant
                                                        and PP_LAB.CostIsEnteredManually  = HDR.CostIsEnteredManually
                                                        and PP_LAB.CostingReferenceObject = HDR.CostingReferenceObject
                                                        and PP_LAB.CostingVersion         = HDR.CostingVersion
//                                                        and PP_LAB.CostingItemCategory    = 'E'
                                                        and PP_LAB.CostCtrActivityType    = 'PP_LAB'
    inner join I_ProductCostEstimateItem as PP_POR on  PP_POR.CostEstimate        = HDR.CostEstimate
                                                        and PP_POR.CostingType         = HDR.CostingType
                                                        and PP_POR.CostingDate         = HDR.CostingDate                                                     
                                                        and PP_POR.ValuationVariant       = HDR.ValuationVariant
                                                        and PP_POR.CostIsEnteredManually  = HDR.CostIsEnteredManually
                                                        and PP_POR.CostingReferenceObject = HDR.CostingReferenceObject
                                                        and PP_POR.CostingVersion         = HDR.CostingVersion
//                                                        and PP_POR.CostingItemCategory = 'E'
                                                        and PP_POR.CostCtrActivityType = 'PP_POR'
  //
  //left outer join I_ProductCostEstimateItem as Mat on
  //                                            Mat.CostEstimate =  HDR.CostEstimate
  //                                            and Mat.CostingType = HDR.CostingType
  //                                           and Mat.CostingDate = HDR.CostingDate
  //                                          and  Mat.CostingItemCategory = 'M' //or Pce.StorageLocation = 'FG'
  //
  //

{


  key Pce.Material                   as Itemcode,
  key Pce.Plant                      as Plant,
      // HDR.CostEstimate ,
  key  Pce.Batch                      as Batch,
      Pce.GoodsMovementType          as Movementtype,
      Pd.ProductType                 as Vtype,
      ST.StorageLocation            as storage_loc,
      Pce.PostingDate                as Startingd,
      Pce.PostingDate                as edate,
      Pce.ManufacturingOrder         as orderr,
      @Semantics.amount.currencyCode: 'ccucy'
      Amt.TotalAmountInCoCodeCrcy as MaterialV,
      //      PP_MAC.BillOfMaterialItemNumber   as matc,
      //
      ST.StorageLocationName         as Slotype,
      Pdes.ProductDescription        as Itemdesc,
      //abap.char'' as Itemdesc,
      Pce.MaterialBaseUnit           as Uom,
      @Semantics.quantity.unitOfMeasure: 'uom'
      Pce.QuantityInBaseUnit         as Qty,
      Pce.CompanyCodeCurrency        as ccucy,
      @Semantics.amount.currencyCode: 'ccucy'
      Pce.TotalGoodsMvtAmtInCCCrcy   as Materialc,
      @Semantics.amount.currencyCode: 'ccucy'
      case when Pce.GoodsMovementType = '101'
      then Pce.TotalGoodsMvtAmtInCCCrcy when Pce.GoodsMovementType = '262' 
      then Pce.TotalGoodsMvtAmtInCCCrcy + PP_MAC.TotalAmountInCoCodeCrcy + PP_LAB.TotalAmountInCoCodeCrcy + PP_POR.TotalAmountInCoCodeCrcy
      else null end as Totalcost,
     @Semantics.amount.currencyCode: 'ccucy' 
     case when Amt.CostingItemCategory = 'M' then 
      cast(Pce.TotalGoodsMvtAmtInCCCrcy + PP_MAC.TotalAmountInCoCodeCrcy + PP_LAB.TotalAmountInCoCodeCrcy + PP_POR.TotalAmountInCoCodeCrcy + Amt.TotalAmountInCoCodeCrcy  as abap.dec( 15, 2 )) else
       cast(Pce.TotalGoodsMvtAmtInCCCrcy + PP_MAC.TotalAmountInCoCodeCrcy + PP_LAB.TotalAmountInCoCodeCrcy + PP_POR.TotalAmountInCoCodeCrcy as abap.dec( 15, 2 ))end as Overallvalue,
      
      
      
      
      //      HDR.CostCtrActivityType        as activity_type,
      @Semantics.amount.currencyCode: 'ccucy'
      PP_MAC.TotalAmountInCoCodeCrcy as Machineval,
      @Semantics.amount.currencyCode: 'ccucy'
      PP_LAB.TotalAmountInCoCodeCrcy as labval,
            @Semantics.amount.currencyCode: 'ccucy'
      
      PP_POR.TotalAmountInCoCodeCrcy as Powerval

}
where
//Pce.InventoryStockType = '7'
//or
////      Pce.GoodsMovementType = '262'
////  or  Pce.GoodsMovementType = '101'
//   Pce.StorageLocation   = 'IRJE'
//or  Pce.StorageLocation    =  'SRJE'
//  or Pce.StorageLocation    =  'SCRP'
//and   Pce.StorageLocation    <> 'ASY'
 Pce.ManufacturingOrder <> ' '

