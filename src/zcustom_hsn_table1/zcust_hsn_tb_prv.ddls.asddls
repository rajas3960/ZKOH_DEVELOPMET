@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view of PV'
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo:{title: {
    type: #STANDARD,
    label: 'Table',
    value: 'HSN'
},
typeName: 'HSN Table',
typeNamePlural: 'HSN Table'
}
define root view entity ZCUST_HSN_TB_PRV 
provider contract transactional_query
as projection on ZCUST_HSN_TB_PV
{
 @UI.facet: [{

                purpose: #STANDARD,
                position: 10,
            //       label: '',
                type:#LINEITEM_REFERENCE
            //       targetElement: '',
            //       targetQualifier: '',
            //       url: ''
            }]
    @UI.lineItem: [{ position: 10 , label: 'HSN' }]
    @EndUserText.label: 'HSN'        
    key Hsn,
    @UI.lineItem: [{ position: 20 , label: 'GstRate' }]
    @EndUserText.label: 'GstRate'
    key Gstrate
}
