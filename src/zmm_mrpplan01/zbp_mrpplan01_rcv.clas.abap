CLASS zbp_mrpplan01_rcv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zmrpplan01_rcv.
  PUBLIC SECTION.
    CLASS-DATA: gt_prrcupd TYPE TABLE OF zmrpplan01_tb3,
                gt_hdrdata TYPE TABLE OF zmrpplan01_tb1,
                gt_prupd   TYPE TABLE OF zmrpplan01_tb1.
    CLASS-DATA: cv_pr_doc  TYPE RESPONSE FOR MAPPED  i_purchaserequisitiontp,
                cv_sto_doc TYPE RESPONSE FOR MAPPED I_PurchaseOrderTP_2.

ENDCLASS.



CLASS ZBP_MRPPLAN01_RCV IMPLEMENTATION.
ENDCLASS.
