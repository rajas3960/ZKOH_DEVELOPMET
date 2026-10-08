@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Document Pricing'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_SALES_PRICING
  as select from    I_BillingDocumentItem          as item

    inner join      I_BillingDocument              as BD        on BD.BillingDocument = item.BillingDocument

  /* Pricing Elements (Tax + Value) */
    left outer join I_BillingDocumentItemPrcgElmnt as IGST      on  IGST.BillingDocument     = item.BillingDocument
                                                                and IGST.BillingDocumentItem = item.BillingDocumentItem
                                                                and IGST.ConditionType       = 'JOIG'
    left outer join I_BillingDocumentItemPrcgElmnt as SGST      on  SGST.BillingDocument     = item.BillingDocument
                                                                and SGST.BillingDocumentItem = item.BillingDocumentItem
                                                                and SGST.ConditionType       = 'JOSG'
    left outer join I_BillingDocumentItemPrcgElmnt as CGST      on  CGST.BillingDocument     = item.BillingDocument
                                                                and CGST.BillingDocumentItem = item.BillingDocumentItem
                                                                and CGST.ConditionType       = 'JOCG'

    left outer join I_BillingDocumentItemPrcgElmnt as NetCond1  on  NetCond1.BillingDocument     = item.BillingDocument
                                                                and NetCond1.BillingDocumentItem = item.BillingDocumentItem
                                                                and NetCond1.ConditionType       = 'PPR0'
    
//    left outer join I_BillingDocumentItemPrcgElmnt as NetCond2  on  NetCond2.BillingDocument     = item.BillingDocument
//                                                                and NetCond2.BillingDocumentItem = item.BillingDocumentItem
//                                                                and NetCond2.ConditionType       = 'ZFOB'

    left outer join I_BillingDocumentItemPrcgElmnt as Discount1 on  Discount1.BillingDocument     = item.BillingDocument
                                                                and Discount1.BillingDocumentItem = item.BillingDocumentItem
                                                                and Discount1.ConditionType       = 'ZDIS'

//    left outer join I_BillingDocumentItemPrcgElmnt as Discount2 on  Discount2.BillingDocument     = item.BillingDocument
//                                                                and Discount2.BillingDocumentItem = item.BillingDocumentItem
//                                                                and Discount2.ConditionType       = 'ZDIS'

{


  key item.BillingDocument,
  key item.BillingDocumentItem,

      cast( item.NetAmount as abap.dec(15,2) ) as NetAmount,

      case
        when item.TransactionCurrency <> 'INR'
        then cast(
               (
                 cast( NetCond1.ConditionAmount as abap.dec(15,2) )
                 + coalesce(
                     cast( Discount1.ConditionAmount as abap.dec(15,2) ),
                     cast( 0 as abap.dec(15,2) )
                   )
               )
               * cast( BD.AccountingExchangeRate as abap.dec(9,5) )
               * 100
               as abap.dec(23,2)
             )
        else cast(
               cast( NetCond1.ConditionAmount as abap.dec(15,2) )
               + coalesce(
                   cast( Discount1.ConditionAmount as abap.dec(15,2) ),
                   cast( 0 as abap.dec(15,2) )
                 )
               as abap.dec(23,2)
             )
      end                                      as TaxableValue,

      case
        when item.TransactionCurrency <> 'INR'
        then cast(
               cast( IGST.ConditionAmount as abap.dec(15,2) )
               * cast( BD.AccountingExchangeRate as abap.dec(9,5) )
               * 100
               as abap.dec(23,2)
             )
        else cast( IGST.ConditionAmount as abap.dec(23,2) )
      end                                      as IgstAmount,

      case
        when item.TransactionCurrency <> 'INR'
        then cast(
               cast( CGST.ConditionAmount as abap.dec(15,2) )
               * cast( BD.AccountingExchangeRate as abap.dec(9,5) )
               * 100
               as abap.dec(23,2)
             )
        else cast( CGST.ConditionAmount as abap.dec(23,2) )
      end                                      as CgstAmount,

      case
        when item.TransactionCurrency <> 'INR'
        then cast(
               cast( SGST.ConditionAmount as abap.dec(15,2) )
               * cast( BD.AccountingExchangeRate as abap.dec(9,5) )
               * 100
               as abap.dec(23,2)
             )
        else cast( SGST.ConditionAmount as abap.dec(23,2) )
      end                                      as SgstAmount,

      case
      when IGST.ConditionRateValue is not null
      then IGST.ConditionRateValue

      else
      coalesce( CGST.ConditionRateValue, 0 )
      + coalesce( SGST.ConditionRateValue, 0 )

      end                                      as GstRate

}
