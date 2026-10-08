@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Report for GST'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PURCHASE_GST_REP

  as select from    I_SupplierInvoiceAPI01        as INV
    inner join      I_Supplier                    as SUP  on INV.InvoicingParty = SUP.Supplier
    left outer join I_SuplrInvcItemPurOrdRefAPI01 as TAX  on TAX.SupplierInvoice = INV.SupplierInvoice
    left outer join I_SupplierInvoiceTaxAPI01     as TAX1 on TAX1.SupplierInvoice = INV.SupplierInvoice
    left outer join I_BusinessPlace               as TAX3 on  TAX3.BusinessPlace = INV.BusinessPlace
                                                          and TAX3.CompanyCode   = INV.CompanyCode

  association [0..*] to ZI_PURCHASE_GST_ITEM as itemList on itemList.SupplierInvoice = INV.SupplierInvoice
{
      /* ================= BASIC ================= */

  key INV.SupplierInvoice               as document_number,
  key INV.CompanyCode,
  key INV.FiscalYear,

      INV.PostingDate                   as document_date,

      concat(
        INV.SupplierInvoice,
        INV.CompanyCode
      )                                 as original_document_number,

      INV.DocumentCurrency,
      INV.CreationDate,
      INV.CreationTime,

      INV.PostingDate                   as original_document_date,
      cast( '' as abap.char(20) )       as ref_document_number,
      cast( '00000000' as abap.dats )   as ref_document_date,

      /* ================= SUPPLY TYPE ================= */

      case
        when TAX.TaxCode = 'G0' or TAX.TaxCode = 'G1' or TAX.TaxCode = 'G2' then 'EMP'
        when TAX.TaxCode = 'NT' then 'NRT'
        else 'NOR'
      end                               as supply_type,

      'Add'                             as invoice_status,

      /* ================= CATEGORY ================= */

      case
        when SUP.Country <> 'IN' then 'IMP'
        when INV.IsInvoice = 'X' then 'TXN'
        else 'CDN'
      end                               as invoice_category,

      case
        when INV.IsInvoice = 'X' then 'R'
        when SUP.Country <> 'IN' then 'IMPG'
        else 'B2B'
      end                               as invoice_type,

      /* ================= VALUES ================= */

      case
      when INV.DocumentCurrency <> 'INR'
      then cast(
         cast( INV.InvoiceGrossAmount as abap.dec(15,2) )
         * cast( INV.ExchangeRate as abap.dec(9,5) )
         * 100
         as abap.dec(23,2)
       )
      else cast(
         INV.InvoiceGrossAmount as abap.dec(23,2)
       )
      end                               as total_invoice_value,


      case
      when INV.DocumentCurrency <> 'INR'
      then cast(
         cast( sum( TAX1.TaxBaseAmountInTransCrcy ) as abap.dec(15,2) )
         * cast( INV.ExchangeRate as abap.dec(9,5) )
         * 100
         as abap.dec(23,2)
       )
      else cast(
         sum( TAX1.TaxBaseAmountInTransCrcy ) as abap.dec(23,2)
       )
      end                               as total_taxable_value,


      cast( 0 as abap.dec(15,2) )       as txpd_taxtable_value,

      /* ================= SHIPPING ================= */

      cast( '' as abap.char(20) )       as shipping_bill_number,
      cast( '00000000' as abap.dats )   as shipping_bill_date,
      cast( '' as abap.char(50) )       as reason,
      cast( '' as abap.char(10) )       as port_code,

      /* ================= LOCATION ================= */

      cast( '' as abap.char(10) )       as location,

      cast( '' as abap.char(10) )       as gstr2_return_period,
      cast( '' as abap.char(10) )       as gstr3b_return_period,

      /* ================= REVERSE CHARGE ================= */

      case
          when TAX.TaxCode = 'J1'
            or TAX.TaxCode = 'J2'
            or TAX.TaxCode = 'J3'
            or TAX.TaxCode = 'J4'
            or TAX.TaxCode = 'J5'
            or TAX.TaxCode = 'J6'
            then 'Y'
          else 'N'
      end                               as reverse_charge,

      /* ================= AMENDMENT ================= */

      'N'                               as isamended,
      cast( '' as abap.char(5) )        as amended_pos,
      cast( '' as abap.char(10) )       as amended_period,

      /* ================= GST ================= */

      substring( SUP.TaxNumber3, 1, 2 ) as place_of_supply,
      SUP.TaxNumber3                    as supplier_gstin,
      TAX3.IN_GSTIdentificationNumber   as buyer_gstin,

      /* ================= NAME ================= */

      SUP.SupplierName                  as customer_name,

      /* ================= EXTRA ================= */

      cast( '' as abap.char(20) )       as erp_document_number,
      cast( '00000000' as abap.dats )   as erp_document_date,
      cast( '' as abap.char(20) )       as transaction_number,

      cast( '' as abap.char(1) )        as issez,
      cast( '' as abap.char(15) )       as sez_gstin,
      cast( '' as abap.char(10) )       as gl_code,

      cast( '' as abap.char(10) )       as gstr7_return_period,
      cast( '' as abap.char(10) )       as gstr7_amend_type,

      cast( '' as abap.char(15) )       as original_gstin_of_supplier,

      /* ================= PAGE 2 FIELDS ================= */

      cast( 0 as abap.dec(15,2) )       as amortised_cost,
      cast( '' as abap.char(5) )        as inv_itc_elgibity,
      cast( '' as abap.char(10) )       as payment_status,
      cast( 0 as abap.dec(15,2) )       as paid_amount,

      itemList

}
//where
//  (
//       INV.CompanyCode = '0840'
//    or INV.CompanyCode = '0215'
//    or INV.CompanyCode = '0205'
//    or INV.CompanyCode = '0700'
//    or INV.CompanyCode = '0999'
//    or INV.CompanyCode = '0100'
//    or INV.CompanyCode = '0811'
//  )
group by
  INV.SupplierInvoice,
  INV.PostingDate,
  INV.SupplierInvoiceIDByInvcgParty,
  TAX.TaxCode,
  INV.IsInvoice,
  SUP.Country,
  INV.InvoiceGrossAmount,
  SUP.TaxNumber3,
  SUP.SupplierName,
  INV.DocumentCurrency,
  INV.CreationDate,
  INV.CreationTime,
  TAX3.IN_GSTIdentificationNumber,
  INV.ExchangeRate,
  INV.CompanyCode,
  INV.FiscalYear
