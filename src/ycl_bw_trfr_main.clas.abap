CLASS ycl_bw_trfr_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.

    METHODS create_start_routine
      IMPORTING !iv_tranid TYPE rstranid.

    METHODS generate_start_routine
      IMPORTING !iv_tranid  TYPE rstranid
                !iv_clsname TYPE string
                !iv_intname TYPE string.

    METHODS create_class
      IMPORTING !iv_clsname TYPE string
                !iv_intname TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_bw_trfr_main IMPLEMENTATION.

  METHOD create_start_routine.
    TRY.
        CALL METHOD cl_rstran_trfn=>factory
          EXPORTING
            i_tranid = iv_tranid
          RECEIVING
            r_r_tran = DATA(lr_tran).

        lr_tran->get_source(
          IMPORTING
           e_s_source =  DATA(ls_source)
        ).

        lr_tran->get_target(
          IMPORTING
            e_s_target =  DATA(ls_target)
        ).
      CATCH cx_rstran_not_found.    "
      CATCH cx_rstran_input_invalid.    "
      CATCH cx_rstran_error_with_message.
    ENDTRY.

    SPLIT ls_source-objnm AT ' ' INTO: DATA(lv_source) DATA(lv_rest).

    create_class(
      EXPORTING
        iv_clsname = |YCL_BW_{ lv_source }_{ ls_target-objnm }|
        iv_intname = 'YIF_BW_START_ROUTINE'
     ).

    generate_start_routine(
      EXPORTING
        iv_tranid  = iv_tranid
        iv_clsname = |YCL_BW_{ lv_source }_{ ls_target-objnm }|
        iv_intname = 'YIF_BW_START_ROUTINE'
    ).

  ENDMETHOD.

  METHOD generate_start_routine.

    DATA: lr_tran TYPE REF TO cl_rstran_trfn.
    TRY.
        CALL METHOD cl_rstran_trfn=>factory
          EXPORTING
            i_tranid       = iv_tranid  " Transformation ID
            i_new          = abap_true   " Recreate Transformation
            i_with_message = rs_c_true    " Boolean
          RECEIVING
            r_r_tran       = lr_tran.   " Transformation
      CATCH cx_rstran_not_found.    "
      CATCH cx_rstran_input_invalid.    "
      CATCH cx_rstran_error_with_message.    "
    ENDTRY.

    lr_tran->create_start_routine(
        i_amdp = abap_true ).

    DATA(lr_rut) = lr_tran->get_start_routine( ).

    lr_rut->get_codeid(
      IMPORTING
        e_codid     =  DATA(lv_codeid)   " ID for ABAP code
        e_globalid  =  DATA(lv_globid)   " ID for ABAP code
        e_globalid2 =  DATA(lv_globid2)   " ID for ABAP code
    ).

    DATA:
      l_t_routine_source     TYPE rstran_t_abapsource,
      l_t_routine_source_inv TYPE rstran_t_abapsource,
      l_t_global_source      TYPE rstran_t_abapsource,
      l_t_global_source_2    TYPE rstran_t_abapsource.

*    APPEND VALUE #( line = CONV #('DATA lobj_routine TYPE REF TO') ) TO l_t_global_source.
*    APPEND VALUE #( line = CONV #( iv_clsname ) ) TO l_t_global_source.


        APPEND VALUE #( line = CONV #('*dsfdsfdsfds') ) to l_t_routine_source.
        APPEND VALUE #( line = CONV #('*dsfdsfdsfds') ) to l_t_routine_source_inv.
        APPEND VALUE #( line = CONV #('*dsfdsfdsfds') ) to l_t_global_source.
        APPEND VALUE #( line = CONV #('*dsfdsfdsfds') ) to l_t_global_source_2.

lr_rut->store_routine(
  EXPORTING
    i_codeid            =  lv_codeid  " ID for ABAP code
    i_codeid_global     =  lv_globid   " ID for ABAP code
*    i_routinetxtlg      =
    i_codeid_global2    =  lv_globid2   " ID for ABAP code
    i_t_source          =  l_t_routine_source   " ABAP_SOURCE
    i_t_source_global   =  l_t_global_source   " ABAP_SOURCE
    i_t_source_inverse  = l_t_routine_source_inv    " ABAP_SOURCE
    i_t_source_global_2 =  l_t_global_source_2    " ABAP_SOURCE
).

   lr_rut->save_global_routine( ).
**  CATCH cx_rstran_no_save.    "
**  CATCH cx_rstran_no_code_save.    "
*

*    APPEND VALUE #( line = |  | ) TO l_t_routine_source.
*    APPEND VALUE #( line = | IF lobj_routine IS NOT BOUND. | ) TO l_t_routine_source.
*    APPEND VALUE #( line = |    lobj_routine = NEW #( ). | ) TO l_t_routine_source.
*    APPEND VALUE #( line = | ENDIF. | ) TO l_t_routine_source.
*    APPEND VALUE #( line = | | ) TO l_t_routine_source.
*    APPEND VALUE #( line = |lobj_routine->{ iv_intname }~start( | ) TO l_t_routine_source.
*    APPEND VALUE #( line = |  EXPORTING | ) TO l_t_routine_source.
*    APPEND VALUE #( line = |   iv_request = request| ) TO l_t_routine_source.
*    APPEND VALUE #( line = |   iv_datapackid = datapackid| ) TO l_t_routine_source.
*    APPEND VALUE #( line = |   iv_segid = segid| ) TO l_t_routine_source.
*    APPEND VALUE #( line = |   it_source_package = source_package| ) TO l_t_routine_source.
*    APPEND VALUE #( line = |  IMPORTING| ) TO l_t_routine_source.
*    APPEND VALUE #( line = |   et_monitor         = monitor| ) TO l_t_routine_source.
*    APPEND VALUE #( line = |   et_source_package  = source_package ).| ) TO l_t_routine_source.
*    APPEND VALUE #( line = | | ) TO l_t_routine_source.
*
*    lr_rut->store_routine(
*      EXPORTING
*        i_codeid            =  lv_codeid  " ID for ABAP code
*        i_codeid_global     =  lv_globid   " ID for ABAP code
*        i_codeid_global2    =  lv_globid2   " ID for ABAP code
*        i_t_source          =  l_t_routine_source   " ABAP_SOURCE
*        i_t_source_global   =  l_t_global_source   " ABAP_SOURCE
*    ).

    lr_tran->if_rso_tlogo_maintain~save( ).

    lr_tran->if_rso_tlogo_maintain~activate( ).

  ENDMETHOD.


  METHOD create_class.

    DATA: ls_vseoclass      TYPE vseoclass,
          ls_vseoimplem     TYPE vseoimplem,
          it_exceptions     TYPE seo_exceptions,
          it_implementings  TYPE seo_implementings,
          ls_clskey         TYPE seoclskey,
          ls_method_sources TYPE seo_method_source,
          lt_method_sources TYPE seo_method_source_table.

    ls_vseoclass-clsname = iv_clsname.
    ls_vseoclass-state = seoc_state_implemented.
    ls_vseoclass-exposure = seoc_exposure_public.
    ls_vseoclass-langu = 'EN'.
    ls_vseoclass-descript = 'Generated class for transformation'. "#EC NOTEXT
    ls_vseoclass-clsccincl = 'X'.
    ls_vseoclass-unicode = 'X'.
    ls_vseoclass-author = 'SAP'.

    ls_vseoimplem-clsname = iv_clsname.
    ls_vseoimplem-refclsname = 'YIF_BW_START_ROUTINE'.
    ls_vseoimplem-state = seoc_state_implemented.
    APPEND ls_vseoimplem TO it_implementings.

    ls_clskey-clsname = iv_clsname.

    ls_method_sources-cpdname = 'YIF_BW_START_ROUTINE~START'.
    APPEND '* Here insert your own code' TO ls_method_sources-source. "#EC NOTEXT
    APPEND ls_method_sources TO lt_method_sources.

    CALL FUNCTION 'SEO_CLASS_CREATE_COMPLETE'
      EXPORTING
        devclass                   = '$TMP'
        version                    = seoc_version_active
        authority_check            = seox_true
        overwrite                  = seox_true
        suppress_method_generation = seox_false
        genflag                    = seox_true
        method_sources             = lt_method_sources
      CHANGING
        class                      = ls_vseoclass
        implementings              = it_implementings
        exceps                     = it_exceptions
      EXCEPTIONS
        existing                   = 1
        is_interface               = 2
        db_error                   = 3
        component_error            = 4
        no_access                  = 5
        other                      = 6
        OTHERS                     = 7.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      EXIT.
    ENDIF.

*    CALL FUNCTION 'RS_TOOL_ACCESS'
*      EXPORTING
*        operation   = 'SHOW'
*        object_name = iv_clsname.

  ENDMETHOD.

ENDCLASS.
