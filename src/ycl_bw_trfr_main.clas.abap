CLASS ycl_bw_trfr_main DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING !iv_tranid TYPE rstranid.

    "! <p class="shorttext synchronized" lang="en">Create class</p>
    "! Create class which implements interface
    "! @parameter iv_clsname | <p class="shorttext synchronized" lang="en">Class Name</p>
    "! @parameter iv_intname | <p class="shorttext synchronized" lang="en">Interface Name</p>
    METHODS create_class
      IMPORTING !iv_clsname TYPE string
                !iv_ifname  TYPE string
                !iv_rtype   TYPE string.

    "! <p class="shorttext synchronized" lang="en">Show class after creation</p>
    "!
    METHODS show_class.

    METHODS: get_ov_classna RETURNING VALUE(r_result) TYPE string,
             get_ov_ifname RETURNING VALUE(r_result) TYPE string,
             set_ov_classna IMPORTING iv_ov_classna TYPE string,
             set_ov_ifname IMPORTING iv_ov_ifname TYPE string.


  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
      ov_classna TYPE string,
      ov_ifname  TYPE string.

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
    ls_vseoimplem-refclsname = iv_ifname.
    ls_vseoimplem-state = seoc_state_implemented.
    APPEND ls_vseoimplem TO it_implementings.

    ls_clskey-clsname = iv_clsname.

    ls_method_sources-cpdname = |{ iv_ifname }{ iv_rtype }|.
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

  ENDMETHOD.


  METHOD constructor.

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

    ov_classna = |YCL_BW_{ lv_source }_{ ls_target-objnm }|.

  ENDMETHOD.


  METHOD show_class.

    CALL FUNCTION 'RS_TOOL_ACCESS' "This can show created class
      EXPORTING
        operation   = 'SHOW'
        object_type = 'CLAS'
        object_name = ov_classna.

  ENDMETHOD.

  METHOD get_ov_classna.
    r_result = me->ov_classna.
  ENDMETHOD.

  METHOD set_ov_classna.
    me->ov_classna = iv_ov_classna.
  ENDMETHOD.

  METHOD set_ov_ifname.
    me->ov_ifname = iv_ov_ifname.
  ENDMETHOD.

  METHOD get_ov_ifname.
    r_result = me->ov_ifname.
  ENDMETHOD.

ENDCLASS.
