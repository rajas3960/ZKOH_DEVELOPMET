@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection For Attachment'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSTUDENT_ATT_TABL_P
  as projection on zstudent_att_tab_i
{
      @UI.facet: [{

         id: 'StudentData',
         purpose: #STANDARD,
         label: 'Attachment Information',
         type: #IDENTIFICATION_REFERENCE,
         position: 10
         }]


      @UI: {
       lineItem: [{ position: 10}],
       identification: [{ position: 10}]
     }
  key AttachId,
      @UI: {
        lineItem: [{ position: 20}],
        identification: [{ position: 20}]
      }
      Id,
      @UI: {
        lineItem: [{ position: 30}],
        identification: [{ position: 30}]
      }
      Comments,
      @UI: {
        lineItem: [{ position: 40}],
        identification: [{ position: 40}]
      }
      
      Attachment,
      Mimetype,
      Filename,
      Lastchangedat,
      /* Associations */
      _Student:redirected to parent ZSTUDENT_ATT_TAB_P
}
