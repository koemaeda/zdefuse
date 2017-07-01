*"* use this source file for your ABAP unit test classes

class test_todo definition for testing.
  private section.
  methods:
    todo for testing.
endclass.

class test_todo implementation.
  method todo.
    cl_aunit_assert=>fail( 'NOT IMPLEMENTED' ).
  endmethod.
endclass.
