CLASS zbp_fi_app1_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zfi_app1_rv.

PUBLIC SECTION.
    CLASS-DATA: gt_header TYPE TABLE OF zfi_app1_tb1,
                gt_uphead TYPE table of zfi_app1_tb1,

                gt_item TYPE TABLE of zfi_app1_tb2,
                gt_upitem TYPE table of zfi_app1_tb2,

                gt_work TYPE TABLE of zfi_app1_tb3,
                gt_upwork TYPE table of zfi_app1_tb3,

                GT_POCRT TYPE TABLE OF zfi_app1_tb3,
                GT_HECRT TYPE TABLE OF zfi_app1_tb1,

                gt_gateoutst type table of zfi_app1_tb1.


ENDCLASS.



CLASS ZBP_FI_APP1_RV IMPLEMENTATION.
ENDCLASS.
