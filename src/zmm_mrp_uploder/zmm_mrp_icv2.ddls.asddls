@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mass PR Uploader - PR Line Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_MRP_ICV2 as select from ZMM_MRP_IV2
association  to parent ZMM_MRP_RCV as _header on $projection.Recguid = _header.Recguid
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
    _header
}
