INTERFACE zif_bw_start_routine
  PUBLIC .

  "! <p class="shorttext synchronized" lang="en">Start routine interface</p>
  "!
  "! @parameter iv_request | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter iv_datapackid | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter iv_segid | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter it_source_package | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter et_monitor | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter et_source_package | <p class="shorttext synchronized" lang="en"></p>
  "! @raising cx_rsrout_abort | <p class="shorttext synchronized" lang="en"></p>
  "! @raising cx_rsbk_errorcount | <p class="shorttext synchronized" lang="en"></p>
  METHODS
    start
      IMPORTING
        iv_request        TYPE rsrequest
        iv_datapackid     TYPE rsdatapid
        iv_segid          TYPE rsbk_segid
        it_source_package TYPE ANY TABLE
      EXPORTING
        et_monitor        TYPE rstr_ty_t_monitors
        et_source_package TYPE ANY TABLE
      RAISING
        cx_rsrout_abort
        cx_rsbk_errorcount.

ENDINTERFACE.
