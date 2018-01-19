# This file is primarily for cross compiling clang+llvm, et al, for
# Linux on Darwin, and can be invoked like this:
#
#  cmake -GNinja -DBOOTSTRAP_CMAKE_SYSROOT=<sysroot path> [OPTIONS] \
#    -C <clang root>/cmake/caches/Linux.cmake ../llvm
#
#  Use "BOOTSTRAP_" prefix to pass options to stage2, e.g.,
#  "-DBOOTSTRAP_CMAKE_BUILD_TYPE=Release", and
#  "-DSTAGE2_CACHE_FILE=<path>" to specify a stage2 cache file.
#


if(NOT DEFINED BOOTSTRAP_CMAKE_SYSROOT)
  message(FATAL_ERROR "Missing required argument -DBOOTSTRAP_CMAKE_SYSROOT=<sysroot path>.")
endif()

# FIXME: Default to Linux, but should this be required?
if(NOT DEFINED BOOTSTRAP_CMAKE_SYSTEM_NAME)
  set(BOOTSTRAP_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
endif()

# FIXME:  Should this default be based on BOOTSTRAP_CMAKE_SYSTEM_NAME?
if(NOT DEFINED BOOTSTRAP_LLVM_DEFAULT_BOOTSTRAP_TRIPLE)
  set(BOOTSTRAP_LLVM_DEFAULT_BOOTSTRAP_TRIPLE "x86_64-unknown-linux-gnu")
endif()

if(NOT DEFINED BOOTSTRAP_GCC_INSTALL_PREFIX)
  # Force clang to look for gcc at runtime -- otherwise it will
  # default to 4.2.1.
  set(BOOTSTRAP_GCC_INSTALL_PREFIX "/usr" CACHE STRING "")
endif()

# Allow user to pass a custom stage2 cache file.
if(DEFINED STAGE2_CACHE_FILE)
  if(NOT IS_ABSOLUTE ${STAGE2_CACHE_FILE})
    message(SEND_ERROR "STAGE2_CACHE_FILE [${STAGE2_CACHE_FILE}] must be an absolute path.")
  endif()
  if(NOT EXISTS ${STAGE2_CACHE_FILE})
    message(SEND_ERROR "STAGE2_CACHE_FILE [${STAGE2_CACHE_FILE}] does not exist.")
  endif()
  list(APPEND EXTRA_ARGS -C${STAGE2_CACHE_FILE})
endif()

list(APPEND EXTRA_ARGS
  -DCMAKE_C_COMPILER_TARGET=${BOOTSTRAP_LLVM_DEFAULT_BOOTSTRAP_TRIPLE}
  -DCMAKE_CXX_COMPILER_TARGET=${BOOTSTRAP_LLVM_DEFAULT_BOOTSTRAP_TRIPLE}
  -DCMAKE_ASM_COMPILER_TARGET=${BOOTSTRAP_LLVM_DEFAULT_BOOTSTRAP_TRIPLE}

  # Adjust the default behaviour of the FIND_XXX() commands to only
  # search for headers and libraries in the
  # CMAKE_SYSROOT/CMAKE_FIND_ROOT_PATH, and always search for programs
  # in the host system.  These all default to BOTH.
  -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER
  -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY
  -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
  )

set(LLVM_TARGETS_TO_BUILD Native CACHE STRING "")
set(CMAKE_BUILD_TYPE RELEASE CACHE STRING "")
set(LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")

set(LLVM_INCLUDE_DOCS OFF CACHE BOOL "")
set(LLVM_INCLUDE_EXAMPLES OFF CACHE BOOL "")
set(LLVM_INCLUDE_RUNTIMES OFF CACHE BOOL "")
set(LLVM_INCLUDE_TESTS OFF CACHE BOOL "")
set(LLVM_INCLUDE_UTILS OFF CACHE BOOL "")
set(CLANG_BUILD_TOOLS OFF CACHE BOOL "")
set(CLANG_ENABLE_ARCMT OFF CACHE BOOL "")
set(CLANG_ENABLE_STATIC_ANALYZER OFF CACHE BOOL "")

# FIXME: Is there a better way to specify this? i.e., target is elf,
# but host isn't.
if(CMAKE_HOST_APPLE)
  # Make sure at least clang and lld are included.
  set(LLVM_ENABLE_PROJECTS ${LLVM_ENABLE_PROJECTS} clang lld CACHE STRING "")

  # Passing -fuse-ld=lld is hard for cmake to handle correctly, so
  # make lld the default linker.
  set(CLANG_DEFAULT_LINKER lld CACHE STRING "")

  set(CLANG_DEFAULT_OBJCOPY llvm-objcopy CACHE STRING "")

  list(APPEND EXTRA_ARGS
    -DLLVM_ENABLE_LLD=ON
    -DCMAKE_AR=${CMAKE_BINARY_DIR}/bin/llvm-ar
    -DCMAKE_OBJCOPY=${CMAKE_BINARY_DIR}/bin/llvm-objcopy
    -DCMAKE_RANLIB=${CMAKE_BINARY_DIR}/bin/llvm-ranlib
    -DCLANG_TABLEGEN=${CMAKE_BINARY_DIR}/bin/clang-tblgen
    -DLLVM_TABLEGEN=${CMAKE_BINARY_DIR}/bin/llvm-tblgen
    -DLLVM_CONFIG_EXE=${CMAKE_BINARY_DIR}/bin/llvm-config
    )

endif()

set(CLANG_ENABLE_BOOTSTRAP ON CACHE BOOL "")
set(CLANG_BOOTSTRAP_CMAKE_ARGS ${EXTRA_ARGS} CACHE STRING "")
