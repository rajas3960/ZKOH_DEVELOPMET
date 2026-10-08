CLASS zbp_mm_mrp_rcv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zmm_mrp_rcv.
CLASS-DATA:
          gt_crdata TYPE TABLE OF ZMM_MRP_TB1,
          gt_crtdata TYPE TABLE  OF ZMM_MRP_TB2,
          gt_prrcupd TYPE TABLE OF ZMM_MRP_TB3.


 CLASS-DATA: cv_pr_doc  TYPE RESPONSE FOR MAPPED  i_purchaserequisitiontp,
                cv_sto_doc TYPE RESPONSE FOR MAPPED I_PurchaseOrderTP_2.


ENDCLASS.



CLASS ZBP_MM_MRP_RCV IMPLEMENTATION.
ENDCLASS.
