*&---------------------------------------------------------------------*
*& Report ybw_trfn_manage
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ybw_trfn_manage.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

PARAMETERS:
          pa_trid TYPE rstranid.

SELECTION-SCREEN END OF BLOCK b1.

END-OF-SELECTION.

  NEW ycl_bw_trfr_main( )->create_start_routine( iv_tranid = pa_trid ).
