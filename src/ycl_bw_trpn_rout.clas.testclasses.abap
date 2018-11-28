*"* use this source file for your ABAP unit test classes
CLASS ltcl_ DEFINITION FINAL FOR TESTING
INHERITING FROM ycl_bw_trpn_rout
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA: lobj_global TYPE REF TO ycl_bw_trpn_rout.

    METHODS setup.

    METHODS:
      constructor_test FOR TESTING RAISING cx_static_check,
      create_class_test FOR TESTING RAISING cx_static_check.

    CONSTANTS:
      con_tabna TYPE string VALUE 'YBW_CTRPN'.

ENDCLASS.


CLASS ltcl_ IMPLEMENTATION.


  METHOD setup.

    lobj_global = NEW #( iv_tranid = '0ERRA0ODM95RW0KJFYO09TR0JSOI8JQD' iv_tabna = con_tabna ). "Test trfn, should be automatic later.

  ENDMETHOD.

  METHOD constructor_test.

    DATA(lv_test) = lobj_global->get_ov_classna( ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_test
        exp                  = 'YCL_BW_YDS_PWI_SALES_YSALES'
        msg                  = 'Class name is correct'

    ).

  ENDMETHOD.

  METHOD create_class_test.

    lobj_global->set_ov_ifname( iv_ov_ifname = 'YIF_BW_START_ROUTINE' ).
    lobj_global->set_ov_rtype( iv_ov_rtype = 'START' ).

    lobj_global->create_class(  ).

    DATA(lv_clsname) = lobj_global->get_ov_classna( ).

    SELECT SINGLE clsname
    FROM seoclass
    INTO @DATA(lv_seo_cl_name)
    WHERE clsname = @lv_clsname.

    cl_abap_unit_assert=>assert_equals(
         EXPORTING
           act                  = lv_seo_cl_name
           exp                  = lv_clsname
           msg                  = 'Class created correctly'

       ).


  ENDMETHOD.

ENDCLASS.
