CLASS ycl_bw_trpn_rout_start DEFINITION
  PUBLIC
  INHERITING FROM ycl_bw_trpn_rout
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS generate_start_routine
      IMPORTING !iv_tranid  TYPE rstranid
                !iv_clsname TYPE string
                !iv_intname TYPE string.

    METHODS create_start_routine.

    METHODS start_processing.

    METHODS constructor
      IMPORTING !iv_tranid TYPE rstranid.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS ycl_bw_trpn_rout_start IMPLEMENTATION.

  METHOD create_start_routine.

    TRY.
        create_class( ).
      CATCH ycx_bw_trpn.
    ENDTRY.

    generate_start_routine(
      EXPORTING
        iv_tranid  = get_ov_trfnid( )
        iv_clsname = get_ov_classna( )  "Class default name is YCL_BW_<SOURCE>_<TARGET>
        iv_intname = get_ov_ifname( )   "Interface name
    ).

  ENDMETHOD.

  METHOD generate_start_routine.

    DATA:
      l_t_routine_source     TYPE rstran_t_abapsource,
      l_t_routine_source_inv TYPE rstran_t_abapsource,
      l_t_global_source      TYPE rstran_t_abapsource,
      l_t_global_source_2    TYPE rstran_t_abapsource.

    "Get info about source and target, necessary to have auto rule copy
    SELECT SINGLE sourcename,targetname,sourcetype,targettype FROM rstran
    INTO  @DATA(ls_rstran)
    WHERE tranid = @iv_tranid AND objvers = 'A'.

    DATA: lr_tran TYPE REF TO cl_rstran_trfn.
    TRY.
        CALL METHOD cl_rstran_trfn=>factory
          EXPORTING
            i_tranid       = iv_tranid
            i_s_source     = CONV #( |{ ls_rstran-sourcetype }{ ls_rstran-sourcename } | )   " BW Repository: TLOGO Object, type and type of association
            i_s_target     = CONV #( |{ ls_rstran-targettype }{ ls_rstran-targetname } | )   " BW Repository: TLOGO Object, type and type of association
            i_new          = abap_true
            i_with_message = rs_c_true
          RECEIVING
            r_r_tran       = lr_tran.
      CATCH cx_rstran_not_found.    "
      CATCH cx_rstran_input_invalid.    "
      CATCH cx_rstran_error_with_message.    "
    ENDTRY.

    TRY.
        lr_tran->create_start_routine(
            i_amdp = rs_c_false
        ).
      CATCH cx_rstran_input_invalid.
        "handle exception
    ENDTRY.

    DATA(l_rule) = lr_tran->get_start_rule( ).
    DATA(lr_rut) = lr_tran->get_start_routine( ).

    lr_rut->get_codeid(
       IMPORTING
         e_codid     =  DATA(lv_codeid)
         e_globalid  =  DATA(lv_globid)
         e_globalid2 =  DATA(lv_globid2)
     ).

    "Global code declarations
    APPEND VALUE #( line  = | DATA lobj_routine TYPE REF TO | ) TO l_t_global_source.
    APPEND VALUE #( line  = | { iv_clsname }. | ) TO l_t_global_source.
    "Source code
    APPEND VALUE #( line = |  | ) TO l_t_routine_source.
    APPEND VALUE #( line = | IF lobj_routine IS NOT BOUND. | ) TO l_t_routine_source.
    APPEND VALUE #( line = |    lobj_routine = NEW #( ). | ) TO l_t_routine_source.
    APPEND VALUE #( line = | ENDIF. | ) TO l_t_routine_source.
    APPEND VALUE #( line = | | ) TO l_t_routine_source.
    APPEND VALUE #( line = |lobj_routine->{ iv_intname }~start( | ) TO l_t_routine_source.
    APPEND VALUE #( line = |  EXPORTING | ) TO l_t_routine_source.
    APPEND VALUE #( line = |   iv_request = request| ) TO l_t_routine_source.
    APPEND VALUE #( line = |   iv_datapackid = datapackid| ) TO l_t_routine_source.
    APPEND VALUE #( line = |   iv_segid = segid| ) TO l_t_routine_source.
    APPEND VALUE #( line = |   it_source_package = source_package| ) TO l_t_routine_source.
    APPEND VALUE #( line = |  IMPORTING| ) TO l_t_routine_source.
    APPEND VALUE #( line = |   et_monitor         = monitor| ) TO l_t_routine_source.
    APPEND VALUE #( line = |   et_source_package  = source_package ).| ) TO l_t_routine_source.
    APPEND VALUE #( line = | | ) TO l_t_routine_source.

    lr_rut->store_routine(  "TO-DO: Check could this be deleted
      EXPORTING
        i_codeid            =  lv_codeid
        i_codeid_global     =  lv_globid
        i_t_source          =  l_t_routine_source
        i_t_source_global   =  l_t_global_source
    ).
    "ADMP change, necessary to handle global code
    l_rule->set_runtime_flag( ).

    TRY.
        lr_tran->if_rso_tlogo_maintain~save( ).
      CATCH cx_rs_error_with_message.
        "handle exception
    ENDTRY.

    lr_tran->if_rso_tlogo_maintain~activate(  ).


  ENDMETHOD.

  METHOD start_processing.

    create_class( ).
*    CATCH ycx_bw_trpn.    "

    create_start_routine(  ).

  ENDMETHOD.

  METHOD constructor.

    super->constructor(
      EXPORTING
        iv_tranid = iv_tranid
    ).

    set_ov_ifname('YIF_BW_START_ROUTINE').
    set_ov_rtype( 'START' ).

  ENDMETHOD.

ENDCLASS.
