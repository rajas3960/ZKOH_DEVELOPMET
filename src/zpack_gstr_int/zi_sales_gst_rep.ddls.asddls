@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales report for GST Filing'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SALES_GST_REP

  as select from                 I_BillingDocument             as BD

  /* Business Partner */
    left outer join              I_BusinessPartner             as BP        on BD.SoldToParty = BP.BusinessPartner

  /* GSTIN (Tax Number) */
    left outer join              I_Businesspartnertaxnumber    as BPTAX     on  BD.SoldToParty  = BPTAX.BusinessPartner
                                                                            and BPTAX.BPTaxType = 'IN3' // GSTIN only

    left outer join              I_Customer                    as BPAdd     on BPAdd.Customer = BD.SoldToParty

//    left outer join              ZI_STATE_MAP                  as pos       on  pos.Region      = BPAdd.Region
//                                                                            and pos.CountryCode = 'IN'

  //    left outer join              I_OperationalAcctgDocItem     as AccDoc    on  AccDoc.AssignmentReference = BD.BillingDocument
  //                                                                            and AccDoc.CompanyCode         = BD.CompanyCode

    left outer to exact one join I_BillingDocumentItem                      on I_BillingDocumentItem.BillingDocument = BD.BillingDocument
    left outer to exact one join I_IN_PlantBusinessPlaceDetail as BPlace    on I_BillingDocumentItem.Plant = BPlace.Plant
    left outer join              I_IN_BusinessPlaceTaxDetail   as bplaceTax on  bplaceTax.BusinessPlace = BPlace.BusinessPlace
                                                                            and bplaceTax.CompanyCode   = BD.CompanyCode

  association [0..*] to ZI_SALES_GST_ITEM as itemList on itemList.BillingDocument = BD.BillingDocument


{
            /* ================= KEY FIELDS ================= */
  key       BD.BillingDocument,
  key       BD.CompanyCode,
  key       BD.FiscalYear,
            BD.DocumentReferenceID               as document_number,
            BD.BillingDocumentDate               as document_date,
            BD.BillingDocumentType,
            BD.BillingDocumentDate,
            BD.CreationDate,
            BD.CreationTime,

            BPlace.BusinessPlace,
            concat(
                BD.BillingDocument,
                BD.CompanyCode
            )                                    as original_document_number,
            BD.BillingDocumentDate               as original_document_date,
            max(itemList.ProfitCenter)           as ProfitCenter,
            BD.AssignmentReference               as ref_document_number,
            cast( '00000000'  as abap.dats )     as ref_document_date,
            BD.TransactionCurrency,

            /* ================= SUPPLY / STATUS ================= */
            'NOR'                                as supply_type,
            'Add'                                as invoice_status,

            case
                when BD.TransactionCurrency <> 'INR'
                then 'EXP'

                when BD.BillingDocumentType = 'F2'
                then 'TXN'

                when BD.BillingDocumentType = 'L2'
                then 'CDN'

                when BD.BillingDocumentType = 'G2'
                then 'DDN'

                else ''
            end                                  as invoice_category,

            /* ================= INVOICE TYPE ================= */
            case
                when BD.TransactionCurrency <> 'INR'
                and BD.TotalTaxAmount > 0
                then 'WPAY'

                when BD.TransactionCurrency <> 'INR'
                and ( BD.TotalTaxAmount is null or BD.TotalTaxAmount = 0 )
                then 'WOPAY'

                when BPTAX.BPTaxNumber is not null
                then 'B2B'

                when BPTAX.BPTaxNumber is null
                and ( BD.TotalNetAmount + BD.TotalTaxAmount ) < 50000
                then 'B2CS'

                when BPTAX.BPTaxNumber is null
                and ( BD.TotalNetAmount + BD.TotalTaxAmount ) > 100000
                then 'B2CL'

                else 'B2C'
            end                                  as invoice_type,

            /* ================= AMOUNTS ================= */

            case
            when BD.TransactionCurrency <> 'INR'
            then cast(
               (
                 cast( BD.TotalNetAmount as abap.dec(13,2) )
                 +
                 cast( BD.TotalTaxAmount as abap.dec(13,2) )
               )
               *
               cast( BD.AccountingExchangeRate as abap.dec(9,5) )
               * 100
               as abap.dec(23,2)
             )
            else cast(
               cast( BD.TotalNetAmount as abap.dec(13,2) )
               +
               cast( BD.TotalTaxAmount as abap.dec(13,2) )
               as abap.dec(23,2)
             )
            end                                  as total_invoice_value,



            case
            when BD.TransactionCurrency <> 'INR'
            then cast(
               cast( BD.TotalNetAmount as abap.dec(15,2) )
               * cast( BD.AccountingExchangeRate as abap.dec(9,5) )
               * 100
               as abap.dec(23,2)
             )
            else cast(
               BD.TotalNetAmount as abap.dec(23,2)
             )
            end                                  as total_taxable_value,



            cast( 0 as abap.dec(15,2) )          as txpd_taxtable_value,

            /* ================= SHIPPING ================= */
            cast( '' as abap.char(20) )          as shipping_bill_number,
            cast( '00000000' as abap.dats )      as shipping_bill_date,

            /* ================= OTHER INFO ================= */
            cast( '' as abap.char(50) )          as reason,
            cast( '' as abap.char(10) )          as port_code,
            cast( '' as abap.char(50) )          as location,

            /* ================= RETURN PERIOD ================= */
            cast( '' as abap.char(6) )           as gstr1_return_period,
            cast( '' as abap.char(6) )           as gstr3b_return_period,

            /* ================= FLAGS ================= */
            cast( '' as abap.char(1) )           as reverse_charge,
            'N'                                  as isamended,


            /* ================= GST DETAILS ================= */
            bplaceTax.IN_GSTIdentificationNumber as supplier_gstin,
            BPTAX.BPTaxNumber                    as buyer_gstin,

            /* ================= PLACE OF SUPPLY ================= */
            case
                when BPTAX.BPTaxNumber is not null
                and BPTAX.BPTaxNumber <> ''
                  then substring( BPTAX.BPTaxNumber, 1, 2 )

//              else pos.GstStateCode
            end                                  as place_of_supply,


            /* ================= CUSTOMER ================= */
            BP.OrganizationBPName1               as customer_name,

            /* ================= E-COM ================= */
            cast( '' as abap.char(1) )           as sale_ecom_op,
            cast( '' as abap.char(20) )          as etin,

            /* ================= DATES ================= */
            BD.BillingDocumentDate               as original_month,

            /* ================= ADDITIONAL ================= */
            cast( '' as abap.char(6) )           as amended_period,
            cast( 0 as abap.dec(15,2) )          as amortised_cost,
            cast( '' as abap.char(20) )          as ecom_supplier_gstin,
            cast( '' as abap.char(20) )          as ostin,
            cast( '' as abap.char(10) )          as gl_code,
            cast( '' as abap.char(10) )          as amended_pos,
            cast( '' as abap.char(20) )          as taxpayer,
            cast( '' as abap.char(10) )          as opos,

            itemList

}
where
  (
       BD.BillingDocumentType = 'G2'
    or BD.BillingDocumentType = 'L2'
    or BD.BillingDocumentType = 'F2'
    or BD.BillingDocumentType = 'JSN'
    or BD.BillingDocumentType = 'CBRE'

  )
//  and(
//       BD.CompanyCode         = '0840'
//    or BD.CompanyCode         = '0215'
//    or BD.CompanyCode         = '0205'
//    or BD.CompanyCode         = '0700'
//    or BD.CompanyCode         = '0999'
//    or BD.CompanyCode         = '0100'
//    or BD.CompanyCode         = '0811'
//  )
group by
  BD.BillingDocument,
  BD.BillingDocumentDate,
  BD.DocumentReferenceID,
  BD.AssignmentReference,
  BD.TransactionCurrency,
  BPTAX.BPTaxNumber,
  BD.TotalNetAmount,
  BD.TotalTaxAmount,
  BP.OrganizationBPName1,
  BD.BillingDocumentType,
  BD.CreationDate,
  BD.CreationTime,
  //  AccDoc.BusinessPlace,
  bplaceTax.IN_GSTIdentificationNumber,
  BD.AccountingExchangeRate,
//  pos.GstStateCode,
  BD.CompanyCode,
  BPlace.BusinessPlace,
  BD.FiscalYear
//  I_BillingDocumentItem.ProfitCenter
