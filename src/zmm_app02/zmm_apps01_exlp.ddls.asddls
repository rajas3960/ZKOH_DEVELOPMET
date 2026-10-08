@EndUserText.label: 'Excel Upload Abstract Root Entity EXTEND'
define root abstract entity ZMM_APPS01_EXLP
//  with parameters parameter_name : parameter_type
{
   @UI.hidden: true
    DUMMY : abap_boolean;
    _StreamProperties : association[1] to ZMM_APPS01_EXLUP on 1 = 1;
    
}
