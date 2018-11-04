*"* use this source file for your ABAP unit test classes
CLASS ltcl_ DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      first_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_ IMPLEMENTATION.

  METHOD first_test.
    DATA(lobj_global) = NEW ycl_bw_trfr_main( ).
    lobj_global->create_start_routine( '0ERRA0ODM95RW0KJFYO09TR0JSOI8JQD' ).
    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  ENDMETHOD.

ENDCLASS.
