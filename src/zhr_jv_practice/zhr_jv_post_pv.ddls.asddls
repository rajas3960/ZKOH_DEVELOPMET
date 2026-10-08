@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZHR_JV_POST_PV provider contract transactional_query as projection on ZHR_JV_POST_RV
{
    key Uuid,
    Zmonth,
    Zyears,
    JvName,
    Companycode,
    Designationname,
    Gradename,
    Departmentname,
    Subdepartmentname,
    Levelname,
    Regionname,
    Branchname,
    Subbranchname,
    Employeetypename,
    Employeestatusname,
    Businessunitname,
    Employeeotherstatusname,
    Formattype,
    Lastchangedby,
    Lastchangedat,
    Locallastchanged,
    /* Associations */
    _Item : redirected to composition child ZHR_JV_POST1_PV
}
