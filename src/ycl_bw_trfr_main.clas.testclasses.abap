*"* use this source file for your ABAP unit test classes
CLASS ltcl_ DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA: lobj_global TYPE REF TO ycl_bw_trfr_main.

    METHODS setup.

    METHODS:
      generate_end_routine_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_ IMPLEMENTATION.

  METHOD generate_end_routine_test.

*    lobj_global->start_processing(
*      EXPORTING
*        iv_tranid  =  '0ERRA0ODM95RW0KJFYO09TR0JSOI8JQD'   " Transformation ID
*        iv_routine =  'END'
*        iv_clsshow =  abap_false   " Show class after generation?
*    ).

  ENDMETHOD.

  METHOD setup.

    lobj_global = NEW #( iv_tranid = '0ERRA0ODM95RW0KJFYO09TR0JSOI8JQD' ).

  ENDMETHOD.

ENDCLASS.
