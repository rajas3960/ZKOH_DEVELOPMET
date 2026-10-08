CLASS zcl_resrvation_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RESRVATION_API IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

DATA:
  ls_entity_key    TYPE zmm_reservation_sc=>tys_main_type,
  ls_business_data TYPE zmm_reservation_sc=>tys_main_type,
  lo_http_client   TYPE REF TO if_web_http_client,
  lo_resource      TYPE REF TO /iwbep/if_cp_resource_entity,
  lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
  lo_request       TYPE REF TO /iwbep/if_cp_request_read,
  lo_response      TYPE REF TO /iwbep/if_cp_response_read.



     TRY.
     " Create http client
DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                             comm_scenario  = 'ZCS_RESERVATION'
                                             comm_system_id = 'S4HCLOUD100'
                                             service_id     = 'ZOS_RESERVATION_REST' ).
lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
     lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
       EXPORTING
          is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                              proxy_model_id      = 'ZMM_RESERVATION_SC'
                                              proxy_model_version = '0001' )
         io_http_client             = lo_http_client
         iv_relative_service_root   = 'sap/opu/odata/sap/ZUI_RESERVATION' ).

     ASSERT lo_http_client IS BOUND.


*     " Create request (NO KEY → multiple records)
*        lo_request = lo_client_proxy
*                        ->create_resource_for_entity_set( 'Main' )
*                        ->create_request_for_read( ).


" Set entity key
ls_entity_key = VALUE #(
          reservation       = ls_business_data-reservation
          reservation_item  =     ls_business_data-reservation_item
*       //   record_type       = 'RecordType' ).
            record_type  = ls_business_data-record_type ).
" Navigate to the resource
lo_resource = lo_client_proxy->create_resource_for_entity_set( 'Main' )->navigate_with_key( ls_entity_key ).

*" Optional: limit records (recommended)
*        lo_request->set_top( 20 ).

" Execute the request and retrieve the business data
lo_response = lo_resource->create_request_for_read( )->execute( ).
lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).


  " Output
 out->write( ls_business_data ).

  CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
   out->write( lx_remote->get_text( ) ).
" Handle remote Exception
" It contains details about the problems of your http(s) connection

CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
out->write( lx_gateway->get_text( ) ).
" Handle Exception

CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
 out->write( lx_web_http_client_error->get_text( ) ).
" Handle Exception
 RAISE SHORTDUMP lx_web_http_client_error.


ENDTRY.

  ENDMETHOD.
ENDCLASS.
