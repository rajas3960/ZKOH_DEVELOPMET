@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view of HR  JV Posting'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZHR_JV_POST_RV as select from zdb_hr_jv_post
composition [0..*] of ZHR_JV_POST1_RV as _Item
{
 key uuid as Uuid,
     zmonth as Zmonth,
     zyears as Zyears,
    jvname as JvName,
    companycode as Companycode,
    designationname as Designationname,
    gradename as Gradename,
    departmentname as Departmentname,
    subdepartmentname as Subdepartmentname,
    levelname as Levelname,
    regionname as Regionname,
    branchname as Branchname,
    subbranchname as Subbranchname,
    employeetypename as Employeetypename,
    employeestatusname as Employeestatusname,
    businessunitname as Businessunitname,
    employeeotherstatusname as Employeeotherstatusname,
    formattype as Formattype,
    lastchangedby as Lastchangedby,
    lastchangedat as Lastchangedat,
    locallastchanged as Locallastchanged,
    _Item
}
