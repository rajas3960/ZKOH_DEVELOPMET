"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>EBPP_BD_CCP_SRV</em>
CLASS zfi_cusincpay DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      "! <p><strong>Missing Elements</strong></p>
      "! <p>Some elements are missing because they require features not supported by the client proxy-framework or have missing dependencies.<br/> These elements are shown in the following list:</p>
      "! <ul>
      "! <li><strong>BPCustomerNumberInProcessSet</strong>: Entity Set 'BPCustomerNumberInProcessSet'  skipped, Entity Type 'BPCustomerNumberInProcess' is missing
      "! <li><strong>CustomerPaymentItemSet</strong>: Entity Set 'CustomerPaymentItemSet'  skipped, Entity Type 'CustomerPaymentItem' is missing
      "! <li><strong>CustomerPaymentSet</strong>: Entity Set 'CustomerPaymentSet'  skipped, Entity Type 'CustomerPayment' is missing
      "! </ul>
      BEGIN OF gcs_entity_set,
         "! Dummy field - Structure must not be empty
         dummy TYPE int1 VALUE 0,
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the action imports</p>
      BEGIN OF gcs_action_import,
        "! ClearCache
        clear_cache_2 TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'CLEAR_CACHE_2',
      END OF gcs_action_import.

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the bound actions</p>
      BEGIN OF gcs_bound_action,
         "! Dummy field - Structure must not be empty
         dummy TYPE int1 VALUE 0,
      END OF gcs_bound_action.

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for complex types</p>
      BEGIN OF gcs_complex_type,
         "! Dummy field - Structure must not be empty
         dummy TYPE int1 VALUE 0,
      END OF gcs_complex_type.

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      "! <p><strong>Missing Elements</strong></p>
      "! <p>Some elements are missing because they require features not supported by the client proxy-framework or have missing dependencies.<br/> These elements are shown in the following list:</p>
      "! <ul>
      "! <li><strong>BPCustomerNumberInProcess</strong>: Entity Type skipped. Creation of Entity Type 'BPCustomerNumberInProcess' ended with error: Key property must not be nullable
      "! <li><strong>CustomerPayment</strong>: Entity Type skipped. Creation of Entity Type 'CustomerPayment' ended with error: Key property must not be nullable
      "! <li><strong>CustomerPaymentItem</strong>: Entity Type skipped. Creation of Entity Type 'CustomerPaymentItem' ended with error: Key property must not be nullable
      "! </ul>
      BEGIN OF gcs_entity_type,
         "! Dummy field - Structure must not be empty
         dummy TYPE int1 VALUE 0,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define ClearCache</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_clear_cache RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS ZFI_CUSINCPAY IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'EBPP_BD_CCP_SRV' ) ##NO_TEXT.

    def_clear_cache( ).

  ENDMETHOD.


  METHOD def_clear_cache.

    DATA:
      lo_action        TYPE REF TO /iwbep/if_v4_pm_action,
      lo_action_import TYPE REF TO /iwbep/if_v4_pm_action_imp,
      lo_parameter     TYPE REF TO /iwbep/if_v4_pm_act_param,
      lo_return        TYPE REF TO /iwbep/if_v4_pm_act_return.


    lo_action = mo_model->create_action( 'CLEAR_CACHE' ).
    lo_action->set_edm_name( 'ClearCache' ) ##NO_TEXT.

    lo_action_import = lo_action->create_action_import( 'CLEAR_CACHE_2' ).
    lo_action_import->set_edm_name( 'ClearCache' ) ##NO_TEXT.


  ENDMETHOD.
ENDCLASS.
