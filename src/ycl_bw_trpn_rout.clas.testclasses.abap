*"* use this source file for your ABAP unit test classes
CLASS ltcl_ DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA: lobj_global TYPE REF TO ycl_bw_trpn_rout.

    METHODS setup.

    METHODS:
      constructor_test FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_ IMPLEMENTATION.

  METHOD constructor_test.

    DATA(lv_test) = lobj_global->get_ov_classna( ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_test
        exp                  = 'YCL_BW_YDS_PWI_SALES_YSALES'
        msg                  = 'Class name is correct'

    ).

  ENDMETHOD.

  METHOD setup.

    lobj_global = NEW #( iv_tranid = '0ERRA0ODM95RW0KJFYO09TR0JSOI8JQD' ). "Test class, should be automatic later.

  ENDMETHOD.

ENDCLASS.
