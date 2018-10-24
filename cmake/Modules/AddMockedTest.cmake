# MIT License
#
# Copyright (c) 2018 Kamil Lorenc
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

## \function add_mocked_test
#  \brief Add unit test with mocking support
#  \param name unit test name (excluding extension and 'test_' prefix)
#  \param objects optional list of objects to include in test module
function(add_mocked_test name)
  add_cmocka_test(test_${name}
                  SOURCES test_${name}.c ${ARGN}
                  COMPILE_OPTIONS ${DEFAULT_C_COMPILE_FLAGS}
                  LINK_LIBRARIES ${CMOCKA_LIBRARIES})
  target_include_directories(test_${name} PRIVATE ${CMAKE_SOURCE_DIR}/src)
endfunction(add_mocked_test)
