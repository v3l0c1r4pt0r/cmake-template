#
# Copyright (c) 2007      Daniel Gollub <dgollub@suse.de>
# Copyright (c) 2007-2018 Andreas Schneider <asn@cryptomilk.org>
# Copyright (c) 2018      Anderson Toshiyuki Sasaki <ansasaki@redhat.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#.rst:
# AddCMockaTest
# -------------
#
# This file provides a function to add a test
#
# Functions provided
# ------------------
#
# ::
#
#   add_cmocka_test(target_name
#                   SOURCES src1 src2 ... srcN
#                   [COMPILE_OPTIONS opt1 opt2 ... optN]
#                   [LINK_LIBRARIES lib1 lib2 ... libN]
#                   [LINK_OPTIONS lopt1 lop2 .. loptN]
#                  )
#
# ``target_name``:
#   Required, expects the name of the test which will be used to define a target
#
# ``SOURCES``:
#   Required, expects one or more source files names
#
# ``COMPILE_OPTIONS``:
#   Optional, expects one or more options to be passed to the compiler
#
# ``LINK_LIBRARIES``:
#   Optional, expects one or more libraries to be linked with the test
#   executable.
#
# ``LINK_OPTIONS``:
#   Optional, expects one or more options to be passed to the linker
#
#
# Example:
#
# .. code-block:: cmake
#
#   add_cmocka_test(my_test
#                   SOURCES my_test.c other_source.c
#                   COMPILE_OPTIONS -g -Wall
#                   LINK_LIBRARIES mylib
#                   LINK_OPTIONS -Wl,--enable-syscall-fixup
#                  )
#
# Where ``my_test`` is the name of the test, ``my_test.c`` and
# ``other_source.c`` are sources for the binary, ``-g -Wall`` are compiler
# options to be used, ``mylib`` is a target of a library to be linked, and
# ``-Wl,--enable-syscall-fixup`` is an option passed to the linker.
#

enable_testing()
include(CTest)

if (CMAKE_CROSSCOMPILING)
    if (WIN32)
        find_program(WINE_EXECUTABLE
                     NAMES wine)
        set(TARGET_SYSTEM_EMULATOR ${WINE_EXECUTABLE} CACHE INTERNAL "")
    endif()
endif()

function(ADD_CMOCKA_TEST _TARGET_NAME)

    set(one_value_arguments
    )

    set(multi_value_arguments
        SOURCES
        COMPILE_OPTIONS
        LINK_LIBRARIES
        LINK_OPTIONS
    )

    cmake_parse_arguments(_add_cmocka_test
        ""
        "${one_value_arguments}"
        "${multi_value_arguments}"
        ${ARGN}
    )

    if (NOT DEFINED _add_cmocka_test_SOURCES)
        message(FATAL_ERROR "No sources provided for target ${_TARGET_NAME}")
    endif()

    add_executable(${_TARGET_NAME} ${_add_cmocka_test_SOURCES})

    if (DEFINED _add_cmocka_test_COMPILE_OPTIONS)
        target_compile_options(${_TARGET_NAME}
            PRIVATE ${_add_cmocka_test_COMPILE_OPTIONS}
        )
    endif()

    if (DEFINED _add_cmocka_test_LINK_LIBRARIES)
        target_link_libraries(${_TARGET_NAME}
            PRIVATE ${_add_cmocka_test_LINK_LIBRARIES}
        )
    endif()

    if (DEFINED _add_cmocka_test_LINK_OPTIONS)
        set_target_properties(${_TARGET_NAME}
            PROPERTIES LINK_FLAGS
            ${_add_cmocka_test_LINK_OPTIONS}
        )
    endif()

    add_test(${_TARGET_NAME}
        ${TARGET_SYSTEM_EMULATOR} ${_TARGET_NAME}
    )

endfunction (ADD_CMOCKA_TEST)
