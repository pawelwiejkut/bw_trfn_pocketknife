CLASS ycl_bw_trpn_rout_stend DEFINITION
  PUBLIC
  INHERITING FROM ycl_bw_trpn_rout
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING iv_tranid TYPE rstranid.

    METHODS generate_start_end_routine
      IMPORTING !iv_tranid  TYPE rstranid
                !iv_clsname TYPE string
                !iv_intname TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS ycl_bw_trpn_rout_stend IMPLEMENTATION.


  METHOD constructor.

    super->constructor(
       EXPORTING
         iv_tranid = iv_tranid
     ).

    set_ov_ifname('YIF_BW_END_ROUTINE').
    set_ov_rtype( 'STEND').

  ENDMETHOD.


  METHOD generate_start_end_routine.

  ENDMETHOD.

ENDCLASS.
