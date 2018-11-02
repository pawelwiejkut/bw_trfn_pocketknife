CLASS ycl_trfr_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.

    METHODS: maintain_start_routine
      IMPORTING iv_tranid TYPE string.
    METHODS: create_start_routine.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_trfr_main IMPLEMENTATION.


  METHOD create_start_routine.

    DATA:
      lv_tranid            TYPE rstranid,
      lv_objvers           TYPE rsobjvers,
      lr_vers              TYPE REF TO cl_rstran_trfn_vers,
      lss_source           TYPE rstran_s_tlogo,
      ls_target            TYPE rstran_s_tlogo,
      ls_expert            TYPE rs_bool,
      lr_source            TYPE REF TO if_rstran_source,
      lv_new               TYPE rs_bool,
      lv_with_new_check    TYPE rs_bool,
      lv_shadow            TYPE rs_bool,
      lv_with_message      TYPE rs_bool,
      lv_owned_by          TYPE rso_s_tlogo_owned_by,
      lv_currunit_allowed  TYPE rs_bool,
      lv_with_proposal     TYPE rs_bool,
      lv_for_compatibility TYPE rs_bool,
      lr_trfn_tlogo        TYPE REF TO cl_rstran_trfn,
      ls_info              TYPE rstran.

    lv_tranid = '0ERRA0ODM95RW0KJFYO09TR0JSOI8JQD'.
    lv_objvers = 'N'.

    SELECT SINGLE sourcename,targetname,sourcetype,targettype FROM rstran
    INTO  @DATA(ls_rstran)
    WHERE tranid = @lv_tranid AND objvers = 'A'.

    DATA: lr_tran TYPE REF TO cl_rstran_trfn.
    TRY.
        CALL METHOD cl_rstran_trfn=>factory
          EXPORTING
            i_tranid       = lv_tranid  " Transformation ID
            i_s_source     = CONV #( |{ ls_rstran-sourcetype }{ ls_rstran-sourcename } | )   " BW Repository: TLOGO Object, type and type of association
            i_s_target     = CONV #( |{ ls_rstran-targettype }{ ls_rstran-targetname } | )   " BW Repository: TLOGO Object, type and type of association
*           i_expert       = RS_C_FALSE    " Boolean
            i_new          = abap_true   " Recreate Transformation
            i_with_message = rs_c_true    " Boolean
*           i_s_owned_by   =     " Parent TLOGO Object (which current object belongs to)
*           i_currunit_allowed           = RS_C_FALSE    " Boolean
*           i_with_proposal              = RS_C_TRUE    " Boolean
*           i_for_delete   = RS_C_FALSE    " Boolean
          RECEIVING
            r_r_tran       = lr_tran.   " Transformation
      CATCH cx_rstran_not_found.    "
      CATCH cx_rstran_input_invalid.    "
      CATCH cx_rstran_error_with_message.    "
    ENDTRY.


    lr_tran->create_start_routine(
        i_amdp = abap_true
).

*    DATA(lt_test) = lr_tran->get_start_rule( ).
*    lt_test->save_global_routine( ).
**  CATCH cx_rstran_no_save.    "
**  CATCH cx_rstran_no_code_save.    "
*
*    lt_test->save_text( ).
**  CATCH cx_rstran_no_save.    "
*
*    lt_test->save_rulesteps(
**  EXPORTING
**    i_with_cto        = RS_C_FALSE    " Boolean
**  CHANGING
**    c_s_append_data   =     " Metadata for InfoSource Appends
*    ).


    lr_tran->if_rso_tlogo_maintain~save(
*  EXPORTING
*    i_with_cto               = RS_C_TRUE    " = 'X': with CTO Insert
*    i_force_save             = RS_C_FALSE    " = 'X': Also Save if Object was Already Saved
*  IMPORTING
*    e_subrc                  =     " Return Value, Return Value After ABAP Statements
    ).

lr_tran->if_rso_tlogo_maintain~activate(
*  EXPORTING
*    i_objvers             = RS_C_OBJVERS-MODIFIED    " Object Version (A / M)
*    i_th_tlogo            =     " Other TLOGO objects that are processed at the same time
*    i_force_activation    = RS_C_FALSE    " = 'X': activate in case the object is already active
*    i_show_check_protocol = RS_C_FALSE    " = 'X': Display Consistency Log as Popup if Warnings Arise
*    i_with_cto            = RS_C_TRUE    " = 'X': With Transport System
*  IMPORTING
*    e_t_tablnm_cnv        =     " Tables Requiring Conversion
*    e_subrc               =     " Return Value (0: OK; 4: Errors; 6: Terminated by User)
).

  ENDMETHOD.

  METHOD maintain_start_routine.
    DATA p_r_tran_maintain TYPE REF TO cl_rstran_maintain .

    CREATE OBJECT p_r_tran_maintain
      EXPORTING
        i_tranid   = CONV #( iv_tranid ).
*        i_s_source = CONV #( |{ ls_rstran-sourcetype }{ ls_rstran-sourcename } | )
*        i_s_target = CONV #( |{ ls_rstran-targettype }{ ls_rstran-targetname } | ).
*

    p_r_tran_maintain->maintain_start(
      EXPORTING
        i_with_gui  = rs_c_true    " Boolean
        i_modus     = CONV #( 1 )
*  RECEIVING
*    r_r_routine =     " Rule Step of a Transformation (Superior Class)
    ).

    p_r_tran_maintain->set_objvers(
*    i_objvers =
    ).
  ENDMETHOD.

ENDCLASS.
