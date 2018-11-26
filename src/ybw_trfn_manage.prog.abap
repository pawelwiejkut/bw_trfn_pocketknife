*&---------------------------------------------------------------------*
*& Report ybw_trfn_manage
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ybw_trfn_manage.

SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

PARAMETERS:
  pa_trid TYPE rstranid,
  pa_strt RADIOBUTTON GROUP gr1,
  pa_end  RADIOBUTTON GROUP gr1,
  pa_sted RADIOBUTTON GROUP gr1.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-004.

PARAMETERS:
  pa_defco RADIOBUTTON GROUP gr2 DEFAULT 'X',
  pa_owcod RADIOBUTTON GROUP gr2.

SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.

PARAMETERS:
  pa_scla AS CHECKBOX TYPE boolean,
  pa_over AS CHECKBOX TYPE boolean DEFAULT 'X', "Overwrite existing TRFN
  pa_mov  AS CHECKBOX TYPE boolean.


SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF SCREEN 101.

SELECTION-SCREEN BEGIN OF SCREEN 102 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.

PARAMETERS:
  pa_srcl TYPE string,
  pa_srme TYPE string,
  pa_ercl TYPE string,
  pa_erme TYPE string.

SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-005.

SELECTION-SCREEN COMMENT /1(50) lv_com1.

PARAMETERS:
  pa_ctab TYPE string DEFAULT 'YBW_CTRPN'.

SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN END OF SCREEN 102.

SELECTION-SCREEN BEGIN OF TABBED BLOCK t1 FOR 20 LINES.
SELECTION-SCREEN TAB (27) lv_tb1 USER-COMMAND ucomm1 DEFAULT SCREEN 101.
SELECTION-SCREEN TAB (8) lv_tb2 USER-COMMAND ucomm2 DEFAULT SCREEN 102.
SELECTION-SCREEN END OF BLOCK t1.

INITIALIZATION.

  lv_tb1  = TEXT-n01.   "Generate class for TRFN
  lv_tb2  = TEXT-n02.   "Settings
  lv_com1 = TEXT-c01.   "For more settings please check customization table

AT SELECTION-SCREEN OUTPUT.

  IF pa_over = 'X'.

    LOOP AT SCREEN.
      IF screen-name = 'PA_OVER' OR screen-name = 'PA_SRCL'
      OR screen-name = 'PA_SRME' OR screen-name = 'PA_ERCL'
      OR screen-name = 'PA_ERME' .
        screen-input = 0.
      ELSEIF screen-name = 'PA_OWCOD'.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.

END-OF-SELECTION.

  CASE 'X'.
    WHEN pa_strt.
      NEW ycl_bw_trpn_rout_start( iv_tranid = pa_trid )->start_processing( ).
    WHEN pa_end.
      NEW ycl_bw_trpn_rout_end( iv_tranid = pa_trid )->start_processing( ).
    WHEN pa_sted.
      NEW ycl_bw_trpn_rout_stend( iv_tranid = pa_trid )->start_processing( ).
  ENDCASE.
