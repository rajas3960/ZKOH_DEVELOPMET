@EndUserText.label: 'Excel Upload Abstract Root Entity'
define root abstract entity ZMM_APPS01_EXLUP
//  with parameters parameter_name : parameter_type
{
      @EndUserText.label: 'Attachments'
      @Semantics.largeObject:{fileName: 'FileName' ,
      acceptableMimeTypes: [ 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ],
                                mimeType: 'MineType',
                                contentDispositionPreference: #INLINE
                                 }
//  @EndUserText.label: 'Select Excel file'
@UI.selectionField: [{position: 10}]
      zattachment   : abap.rawstring( 0 );
      @Semantics.mimeType: true
      @UI.hidden: true
      MineType      : abap.char( 128);
         @UI.hidden: true
      FileName      : abap.char( 128);
    
    
}
