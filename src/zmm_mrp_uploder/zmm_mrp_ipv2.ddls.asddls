@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Uploader - PR Line Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZMM_MRP_IPV2 as projection on ZMM_MRP_ICV2
{
    key Recguid,
    key Prnum,
    key Pritm,
    Ptyg,
    Aactg, 
    Pwbsid,
    Plant,
    Pgroup,
    Mserv,
    Material,
    Matdesc,
    @Semantics.quantity.unitOfMeasure :'Uom'
    Reqqty,
    Uom,
    Supplnt,
    Delvdat,
    Sstart,
    Send,
    Taxcode,
    Sloc,
    Issloc,
    Doctyp,
    Price,
    Expgl,
    _header : redirected to parent ZMM_MRP_RPV
}
