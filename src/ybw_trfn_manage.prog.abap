*&---------------------------------------------------------------------*
*& Report ybw_trfn_manage
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ybw_trfn_manage.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

PARAMETERS:
          pa_trid TYPE rstranid,
          pa_scla AS CHECKBOX TYPE boolean.

SELECTION-SCREEN END OF BLOCK b1.

END-OF-SELECTION.

NEW ycl_bw_trfr_main( )->start_processing(
  EXPORTING
    iv_tranid  =  pa_trid   " Transformation ID
    iv_clsshow =  pa_scla   " Show class after generation?
).
