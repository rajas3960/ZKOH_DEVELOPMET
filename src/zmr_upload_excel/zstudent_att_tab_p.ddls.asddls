@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Header Table'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSTUDENT_ATT_TAB_P
  provider contract transactional_query
  as projection on zstudent_hdr_tab_I
{

      @UI.facet: [{

            id: 'StudentData',
            purpose: #STANDARD,
            label: 'Student Data',
            type: #IDENTIFICATION_REFERENCE,
            position: 10
            },

            {
               id: 'Upload',
               purpose: #STANDARD,
               label: 'Upload Attachments',
               type: #LINEITEM_REFERENCE,
               position: 20,
               targetElement: '_Attachments'}
      ]

      @UI: {
           selectionField: [{ position: 10}],
           lineItem: [{ position: 10}],
           identification: [{ position: 10}]
         }

  key Id,
      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      Firstname,
      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      Lastname,
      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      Age,
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      Course,
      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      Courseduration,
      @UI.lineItem: [{ position: 70 }]
      @UI.identification: [{ position: 70 }]
      Status,
      @UI.lineItem: [{ position: 80 }]
      @UI.identification: [{ position: 80 }]
      Gender,
      @UI.lineItem: [{ position: 90 }]
      @UI.identification: [{ position: 90 }]
      Dob,
      Lastchangedat,
      Locallastchangedat,

      /* Associations */
      _Attachments : redirected to composition child ZSTUDENT_ATT_TABL_P 
}
