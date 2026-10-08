@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for student'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}
define root view entity ZC_STUDENT_5000
  as projection on ZI_STUDENT_5000
{
      @EndUserText.label: 'Student ID'
  key Id,
      Firstname,
      Lastname,
      Age,
      Course,
      Courseduration,
      Status,
      Gender,
      Dob,
      Lastchangedat
}
