*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 25.11.2018 at 19:55:10
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: YBW_CTRPN.......................................*
DATA:  BEGIN OF STATUS_YBW_CTRPN                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_YBW_CTRPN                     .
CONTROLS: TCTRL_YBW_CTRPN
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *YBW_CTRPN                     .
TABLES: YBW_CTRPN                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
