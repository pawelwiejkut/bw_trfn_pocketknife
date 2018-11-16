CLASS ycl_bw_trpn_rout DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES: yif_bw_trpn_rout.

    METHODS constructor
      IMPORTING  iv_tranid TYPE rstranid.
    METHODS: get_ov_trfnid RETURNING value(r_result) TYPE rstranid,
             set_ov_trfnid IMPORTING iv_ov_trfnid TYPE rstranid.

  PROTECTED SECTION.

    ALIASES: create_class FOR yif_bw_trpn_rout~create_class,
             show_class FOR yif_bw_trpn_rout~show_class.

    METHODS: get_ov_classna RETURNING VALUE(r_result) TYPE string,
      get_ov_ifname  RETURNING VALUE(r_result) TYPE string,
      set_ov_classna IMPORTING iv_ov_classna TYPE string,
      set_ov_ifname  IMPORTING iv_ov_ifname TYPE string,
      get_ov_rtype   RETURNING VALUE(r_result) TYPE string,
      set_ov_rtype   IMPORTING iv_ov_rtype TYPE string.

  PRIVATE SECTION.

    DATA:
      ov_classna TYPE string,
      ov_ifname  TYPE string,
      ov_rtype   TYPE string,
      ov_trfnid  TYPE rstranid.

ENDCLASS.



CLASS ycl_bw_trpn_rout IMPLEMENTATION.


  METHOD create_class.

    CONSTANTS: con_cl_desc TYPE string    VALUE 'Generated class for transformation' ##NO_TEXT,
               con_lang    TYPE string    VALUE 'EN' ##NO_TEXT,
               con_autor   TYPE string    VALUE 'SAP' ##NO_TEXT,
               con_package TYPE devclass  VALUE '$TMP' ##NO_TEXT,
               con_dcode   TYPE string    VALUE '* Here insert your own code' ##NO_TEXT.

    DATA: ls_vseoclass      TYPE vseoclass,
          ls_vseoimplem     TYPE vseoimplem,
          it_exceptions     TYPE seo_exceptions,
          it_implementings  TYPE seo_implementings,
          ls_clskey         TYPE seoclskey,
          ls_method_sources TYPE seo_method_source,
          lt_method_sources TYPE seo_method_source_table.


    ls_vseoclass-clsname = ov_classna.
    ls_vseoclass-state = seoc_state_implemented.
    ls_vseoclass-exposure = seoc_exposure_public.
    ls_vseoclass-langu = con_lang.
    ls_vseoclass-descript = con_cl_desc.
    ls_vseoclass-clsccincl = abap_true.
    ls_vseoclass-unicode = abap_true.
    ls_vseoclass-author = con_autor.

    ls_vseoimplem-clsname = ov_classna.
    ls_vseoimplem-refclsname = ov_ifname .
    ls_vseoimplem-state = seoc_state_implemented.
    APPEND ls_vseoimplem TO it_implementings.

    ls_clskey-clsname = ov_classna.

    IF ov_rtype = 'START' OR ov_rtype = 'END'.

      ls_method_sources-cpdname = |{ ov_ifname  }~{ ov_rtype }|.
      APPEND con_dcode TO ls_method_sources-source.
      APPEND ls_method_sources TO lt_method_sources.

    ELSEIF ov_rtype = 'STEND'.

      ls_method_sources-cpdname = |{ ov_ifname  }~END|.
      APPEND con_dcode TO ls_method_sources-source.
      APPEND ls_method_sources TO lt_method_sources.

      CLEAR ls_method_sources.

      ls_method_sources-cpdname = |{ ov_ifname  }~START|.
      APPEND con_dcode TO ls_method_sources-source.
      APPEND ls_method_sources TO lt_method_sources.

    ENDIF.

    CALL FUNCTION 'SEO_CLASS_CREATE_COMPLETE'
      EXPORTING
        devclass                   = con_package
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
      RAISE EXCEPTION TYPE ycx_bw_trpn.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.
    CONSTANTS con_nmspc TYPE string VALUE `Y` ##NO_TEXT.

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

      CATCH cx_rstran_not_found INTO DATA(lobj_rstran_not_found).
        lobj_rstran_not_found->get_text( ).
        RETURN.
      CATCH cx_rstran_input_invalid INTO DATA(lobj_rstran_input_invalid).
        lobj_rstran_input_invalid->get_text( ).
        RETURN.
      CATCH cx_rstran_error_with_message INTO DATA(lobj_rstran_error_with_message).
        lobj_rstran_error_with_message->get_text( ).
        RETURN.
    ENDTRY.

    SPLIT ls_source-objnm AT ' ' INTO: DATA(lv_source) DATA(lv_rest).

    ov_classna = |{ con_nmspc }_CL_BW_{ lv_source }_{ ls_target-objnm }|.

    ov_trfnid = iv_tranid.

  ENDMETHOD.


  METHOD show_class.

    CONSTANTS: con_clas      VALUE 'CLAS' ##NO_TEXT,
               con_operation VALUE 'SHOW' ##NO_TEXT.

    CALL FUNCTION 'RS_TOOL_ACCESS' "FM to show created class
      EXPORTING
        operation   = con_operation
        object_type = con_clas
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

  METHOD get_ov_rtype.
    r_result = me->ov_rtype.
  ENDMETHOD.

  METHOD set_ov_rtype.
    me->ov_rtype = iv_ov_rtype.
  ENDMETHOD.

  METHOD get_ov_trfnid.
    r_result = me->ov_trfnid.
  ENDMETHOD.

  METHOD set_ov_trfnid.
    me->ov_trfnid = iv_ov_trfnid.
  ENDMETHOD.

ENDCLASS.
