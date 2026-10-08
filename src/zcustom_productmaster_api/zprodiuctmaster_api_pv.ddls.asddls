@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZPRODIUCTMASTER_API_PV
  as projection on ZPRODIUCTMASTER_API
{
  key ProductNo,
      ProductDesc,
      Plant,
    //  CreatedOn,
    //  LastChangeDate,
      Latest_Date
}
