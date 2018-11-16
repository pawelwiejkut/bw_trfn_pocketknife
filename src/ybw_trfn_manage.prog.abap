*&---------------------------------------------------------------------*
*& Report ybw_trfn_manage
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ybw_trfn_manage.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

PARAMETERS:
  pa_trid TYPE rstranid,
  pa_strt RADIOBUTTON GROUP gr1,
  pa_end  RADIOBUTTON GROUP gr1,
  pa_sted RADIOBUTTON GROUP gr1,
  pa_scla AS CHECKBOX TYPE boolean.


SELECTION-SCREEN END OF BLOCK b1.

END-OF-SELECTION.
  CASE 'x'.
    WHEN pa_strt.
      NEW ycl_bw_trpn_rout_start( iv_tranid = pa_trid )->start_processing( ).
    WHEN pa_end.
    WHEN pa_sted.
  ENDCASE.
