@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RootEntityView PRODIUCTMASTER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZPRODIUCTMASTER_API
  as select from    I_Product           as pro
    left outer join I_ProductText       as protxt on  protxt.Product  = pro.Product
                                                  and protxt.Language = 'E'
    left outer join I_ProductPlantBasic as PPlnt  on PPlnt.Product = pro.Product

{
  key pro.Product                       as ProductNo,
      protxt.ProductName                as ProductDesc,
      PPlnt.Plant                       as Plant,
    //  pro.CreationDate                  as CreatedOn,
     // pro.LastChangeDate                as LastChangeDate,

      case when ( pro.LastChangeDate = '00000000' or pro.LastChangeDate is initial ) then pro.CreationDate
            when pro.CreationDate > pro.LastChangeDate then pro.CreationDate    //Need to give greater date between GRN date & Invoice Date
            else pro.LastChangeDate end as Latest_Date
}
