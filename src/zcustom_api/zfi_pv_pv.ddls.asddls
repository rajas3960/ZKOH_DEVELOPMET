@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View Print Voucher'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }


define root view entity ZFI_PV_PV
  //with parameters
  //@Environment.systemField: #SYSTEM_DATE
  // P_CompanyCode: abap.char( 4 ),
  //P_CompanyCode           : '1000',
  //  P_from_AccountingDocument    : abap.char( 10 ),
  // p_to_AccountingDocument      : abap.char( 10 )

  // as select from zfi_pv_root(P_CompanyCode : $parameters.P_CompanyCode ,
  // P_from_AccountingDocument : $parameters.P_from_AccountingDocument,
  // p_to_AccountingDocument   : $parameters.p_to_AccountingDocument)       //data_source_name
  provider contract transactional_query
  as projection on ZFI_PV_RVE
{
  key accdoc,
  key glitem,
  key fyear,
  key compcode,
      plantcode,
      PlantName,
      StreetName,
      VillageName,
      CityName,
      DistrictName,
      PostalCode,
      RegionName,
      CountryName,
      doctyp,
      docdt,
      postdt,
      itemtext,
      InvoiceReference,
      ClearingText,
      ref,
      userid,
      Chequeno,
      username,
      BankAccount,
      BankName,
      BankNumber,
      supplier,
      customer,
      glacc,
      costcntr,                                                                    
      profitcntr,
      narration,
      @Semantics.amount.currencyCode: 'curry'
      amt,
      curry,
      dccode,
      spclglindicator,
      gllongname,
      supname,
      add2,
      add3,
      add4,
      custname,
      profitname,
      costname,                                                                         
      invno,
      Billdate,
      @Semantics.amount.currencyCode: 'curry'
      invamt,
      docno

}
