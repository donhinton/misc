# This toolchain file is intended to support cross compiling
# clang+llvm for linux on Darwin.
#
# Usage: cmake -GNinja -C <path to this file>/linux-toolchain.cmake  ../llvm
#
# Currently requires the following patches still under review:
#   https://reviews.llvm.org/D41621
#   https://reviews.llvm.org/D41622
#   https://reviews.llvm.org/D41623
#   https://gitlab.kitware.com/cmake/cmake/merge_requests/1620

# The sysroot tree was created via https://github.com/donhinton/misc/blob/master/scripts/export_docker_filesystem.sh

if(NOT DEFINED SYSROOT AND NOT DEFINED CMAKE_SYSROOT)
  message(FATAL_ERROR "Missing required option -DSYSROOT=<sysroot path>.")
endif()

if(DEFINED SYSROOT)
  set(LLVM_TARGETS_TO_BUILD X86 CACHE STRING "")

  set(CMAKE_BUILD_TYPE RELEASE CACHE STRING "")

  set(LLVM_ENABLE_PROJECTS "clang;lld" CACHE STRING "")
  set(CLANG_DEFAULT_LINKER "lld" CACHE STRING "")

  set(BOOTSTRAP_LLVM_ENABLE_LLD ON CACHE BOOL "")

  set(CLANG_ENABLE_BOOTSTRAP ON CACHE BOOL "")
  set(CLANG_BOOTSTRAP_CMAKE_ARGS
    -DCMAKE_SYSROOT=${SYSROOT}
	  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_LIST_FILE} CACHE STRING "")
else()
  get_filename_component(BASE_PATH "${CMAKE_C_COMPILER}" DIRECTORY CACHE)
  set(CMAKE_AR "${BASE_PATH}/llvm-ar" CACHE STRING "")
  set(CMAKE_RANLIB "${BASE_PATH}/llvm-ranlib" CACHE STRING "")
  set(CLANG_TABLEGEN "${BASE_PATH}/clang-tblgen" CACHE STRING "")
  set(LLVM_TABLEGEN "${BASE_PATH}/llvm-tblgen" CACHE STRING "")
  set(_LLVM_CONFIG_EXE "${BASE_PATH}/llvm-config" CACHE STRING "")
  set(CMAKE_LINKER "${BASE_PATH}/lld" CACHE STRING "")

  set(CMAKE_SYSTEM_NAME "Linux" CACHE STRING "" FORCE)

  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
  set(LLVM_ENABLE_PROJECTS "clang;libcxx;libcxxabi;libunwind;lld" CACHE STRING "")

  set(LLVM_DEFAULT_TARGET_TRIPLE "x86_64-unknown-linux-gnu" CACHE STRING "" FORCE)
  set(CMAKE_C_COMPILER_ARG1 "-target ${LLVM_DEFAULT_TARGET_TRIPLE}" CACHE STRING "" FORCE)
  set(CMAKE_CXX_COMPILER_ARG1 "-target ${LLVM_DEFAULT_TARGET_TRIPLE}" CACHE STRING "" FORCE)
  set(CMAKE_STATIC_LINKER_FLAGS "-format gnu" CACHE STRING "")

  # need to test for this
  set(LLVM_ENABLE_ZLIB OFF CACHE BOOL "")

  # Force gcc lookup at runtime -- otherwise Darwin will default to 4.2.1.
  set(GCC_INSTALL_PREFIX "/usr" CACHE STRING "")

  # Changing an RPATH from the build tree is not supported with the
  # Ninja generator unless on an ELF-based platform.  This might
  # require changes to llvm cmake files at some point.
  if(CMAKE_HOST_APPLE AND CMAKE_GENERATOR STREQUAL "Ninja")
    set(CMAKE_BUILD_WITH_INSTALL_RPATH ON CACHE BOOL "")
  endif()

  # Here is where the target environment located.
  SET(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}" CACHE STRING "")

  # Adjust the default behaviour of the FIND_XXX() commands:
  # search headers and libraries in the target environment, search
  # programs in the host environment.
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE STRING "")
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY CACHE STRING "")
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY CACHE STRING "")
endif()
