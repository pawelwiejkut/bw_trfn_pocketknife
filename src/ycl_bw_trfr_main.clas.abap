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
        devclass                   = '$TMP'                "Package
        version                    = seoc_version_active
        authority_check            = seox_true
        overwrite                  = seox_true
        suppress_method_generation = seox_false
        genflag                    = seox_true             "Generated flag
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

*    CALL FUNCTION 'RS_TOOL_ACCESS' "This can show created class
*      EXPORTING
*        operation   = 'SHOW'
*        object_name = iv_clsname.

  ENDMETHOD.


  METHOD create_start_routine.
    TRY.
        CALL METHOD cl_rstran_trfn=>factory
          EXPORTING
            i_tranid = iv_tranid
          RECEIVING
            r_r_tran = DATA(lr_tran).

        lr_tran->get_source(
          IMPORTING
           e_s_source =  DATA(ls_source) ).

        lr_tran->get_target(
          IMPORTING
            e_s_target =  DATA(ls_target) ).
      CATCH cx_rstran_not_found.    "
      CATCH cx_rstran_input_invalid.    "
      CATCH cx_rstran_error_with_message.
    ENDTRY.

    SPLIT ls_source-objnm AT ' ' INTO: DATA(lv_source) DATA(lv_rest).

    create_class(
      EXPORTING
        iv_clsname = |YCL_BW_{ lv_source }_{ ls_target-objnm }| "Class default name is YCL_BW_SOURCE_TARGET
        iv_intname = 'YIF_BW_START_ROUTINE' "Interface name
     ).

    generate_start_routine(
      EXPORTING
        iv_tranid  = iv_tranid
        iv_clsname = |YCL_BW_{ lv_source }_{ ls_target-objnm }| "Class default name is YCL_BW_SOURCE_TARGET
        iv_intname = 'YIF_BW_START_ROUTINE' "Interface name
    ).

  ENDMETHOD.


  METHOD generate_start_routine.

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

    DATA:
      l_t_routine_source     TYPE rstran_t_abapsource,
      l_t_routine_source_inv TYPE rstran_t_abapsource,
      l_t_global_source      TYPE rstran_t_abapsource,
      l_t_global_source_2    TYPE rstran_t_abapsource.
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
ENDCLASS.
