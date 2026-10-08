CLASS zbp_fi_app2_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zfi_app2_rv.

    CLASS-DATA: gt_updatehd TYPE table of zfi_app1_tb1,
               gt_updateitem TYPE TABLE of zfi_app1_tb2,

***----gate entry process-----********************
               gt_gatein TYPE TABLE of zfi_app1_tb1,
***----Gate out Process-----***********************
               gt_gateout TYPE TABLE of zfi_app1_tb1,
***----purchase order process-----***********************
               update_po TYPE TABLE of ZFI_APP1_TB3.


ENDCLASS.



CLASS ZBP_FI_APP2_RV IMPLEMENTATION.
ENDCLASS.
