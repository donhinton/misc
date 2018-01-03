# This file is intended to support cross compiling a linux toolchain
# on any host system, includind Darwin.
#
# Usage: cmake -GNinja -DSYSROOT=<path> [OPTIONS] -C ../clang/cmake/caches/linux-toolchain.cmake  ../llvm
#
#   OPTIONS:
#     Regular options apply to stage1.
#     BOOTSTRAP_ options apply to stage2, and should use the BOOTSTRAP_ prefix.
#
# Then run "ninja stage2" to cross compile.  Bins and libs can be
# found in tools/clang/stage2-bins.
#
# Known issues:
#
#  1) This toolchain assumes a flat, mono-repo layout.
#
#  2) Several sub-projects, including libcxx, libcxxabi, and
#     libunwind, use FIND_PATH() to find the source path for headers
#     of other sub-projects on the host system, but fail because they
#     don't specify NO_CMAKE_FIND_ROOT_PATH.  The following patches are
#     reqired to build these projects:
#
#       libcxx       https://reviews.llvm.org/D41622
#       libcxxabi    https://reviews.llvm.org/D41623
#       libunwind    https://reviews.llvm.org/D41621
#
#  3) Libraries in the compiler-rt sub-project fail to link with the
#     following error:
#
#       bin/ld.lld: error:
#       projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommon.x86_64.dir/sanitizer_linux_x86_64.S.o:
#       invalid data encoding
#
#  4) FIND_PACKAGE can fail if the package file uses PkgConfig, e.g.,
#     FindLibXml2.cmake, since the pkg-config program runs on the
#     host, and the variables set by PKG_CHECK_MODULES reference the
#     host system, not the target.
#
#  5) Stage2 configuration fails for several sub-projects, including
#     libcxx, libcxxabi, and libunwind, with the following error:
#
#       CMake Error at .../llvm_project/libunwind/src/CMakeLists.txt:110 (add_library):
#       The install of the unwind_shared target requires changing an
#       RPATH from the build tree, but this is not supported with the
#       Ninja generator unless on an ELF-based platform.  The
#       CMAKE_BUILD_WITH_INSTALL_RPATH variable may be set to avoid
#       this relinking step.
#

if(NOT DEFINED SYSROOT AND NOT DEFINED CMAKE_SYSROOT)
  message(FATAL_ERROR "Missing required option -DSYSROOT=<sysroot path>.")
endif()

if(DEFINED SYSROOT)
  # Since we just want to build a bootstrap compiler, turn off as much
  # as possible.
  set(LLVM_INCLUDE_DOCS OFF CACHE BOOL "")
  set(LLVM_INCLUDE_EXAMPLES OFF CACHE BOOL "")
  set(LLVM_INCLUDE_RUNTIMES OFF CACHE BOOL "")
  set(LLVM_INCLUDE_TESTS OFF CACHE BOOL "")
  set(LLVM_INCLUDE_UTILS OFF CACHE BOOL "")
  set(CLANG_BUILD_TOOLS OFF CACHE BOOL "")
  set(CLANG_ENABLE_ARCMT OFF CACHE BOOL "")
  set(CLANG_ENABLE_STATIC_ANALYZER OFF CACHE BOOL "")

  set(LLVM_TARGETS_TO_BUILD Native CACHE STRING "")
  set(CMAKE_BUILD_TYPE RELEASE CACHE STRING "")
  set(LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")

  # Make sure at least clang and lld are included.
  list(APPEND LLVM_ENABLE_PROJECTS clang lld)
  set(LLVM_ENABLE_PROJECTS ${LLVM_ENABLE_PROJECTS} CACHE STRING "")

  # Passing -fuse-ld=lld is hard for cmake to handle correctly, so
  # make lld the default linker.
  set(CLANG_DEFAULT_LINKER lld CACHE STRING "" FORCE)

  # Since LLVM_ENABLE_PROJECTS gets passed automatically to the next
  # stage, use another variable to pass the desired projects to stage2.
  if(DEFINED BOOTSTRAP_LLVM_ENABLE_PROJECTS)
    set(BOOTSTRAP_STAGE2_PROJECTS ${BOOTSTRAP_LLVM_ENABLE_PROJECTS} CACHE STRING "" FORCE)
    unset(BOOTSTRAP_LLVM_ENABLE_PROJECTS CACHE)
  else()
    set(BOOTSTRAP_STAGE2_PROJECTS "clang;libcxx;libcxxabi;libunwind" CACHE STRING "" FORCE)
  endif()

  if(NOT DEFINED TRIPLE)
    set(TRIPLE "x86_64-unknown-linux-gnu")
  endif()

  set(BOOTSTRAP_LLVM_ENABLE_LLD ON CACHE BOOL "")

  set(CLANG_ENABLE_BOOTSTRAP ON CACHE BOOL "")
  set(CLANG_BOOTSTRAP_CMAKE_ARGS
    -DCMAKE_SYSROOT=${SYSROOT}
    -DLLVM_DEFAULT_TARGET_TRIPLE=${TRIPLE}
    -DCMAKE_C_COMPILER_TARGET=${TRIPLE}
    -DCMAKE_CXX_COMPILER_TARGET=${TRIPLE}
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_LIST_FILE}
		CACHE STRING "")
else()
  set(CMAKE_SYSTEM_NAME Linux CACHE STRING "" FORCE)

  # Set default, but allow overries.
  if(NOT DEFINED CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "")
  endif()

  # Always use STAGE2_PROJECTS Use FORCE to override passed vaiable.
  set(LLVM_ENABLE_PROJECTS ${STAGE2_PROJECTS} CACHE STRING "" FORCE)

  # Use bootstrap tools.
  get_filename_component(BASE_PATH "${CMAKE_C_COMPILER}" DIRECTORY CACHE)
  set(CMAKE_AR "${BASE_PATH}/llvm-ar" CACHE STRING "")
  set(CMAKE_RANLIB "${BASE_PATH}/llvm-ranlib" CACHE STRING "")
  set(CLANG_TABLEGEN "${BASE_PATH}/clang-tblgen" CACHE STRING "")
  set(LLVM_TABLEGEN "${BASE_PATH}/llvm-tblgen" CACHE STRING "")
  set(_LLVM_CONFIG_EXE "${BASE_PATH}/llvm-config" CACHE STRING "")
  set(CMAKE_LINKER "${BASE_PATH}/lld" CACHE STRING "")

  # Make sure static libs use the gnu format.
  set(CMAKE_STATIC_LINKER_FLAGS "-format gnu" CACHE STRING "")

  # Force clang to look for gcc at runtime -- otherwise it will
  # default to 4.2.1.
  set(GCC_INSTALL_PREFIX "/usr" CACHE STRING "")

  # Changing an RPATH from the build tree is not supported with the
  # Ninja generator unless on an ELF-based platform.  This might
  # require changes to llvm cmake files at some point.
  if(CMAKE_HOST_APPLE AND CMAKE_GENERATOR STREQUAL "Ninja")
    set(CMAKE_BUILD_WITH_INSTALL_RPATH ON CACHE BOOL "")
  endif()

  # Use CMAKE_SYSROOT prefix for FIND_XXX() commands.
  SET(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}" CACHE STRING "")

  # Adjust the default behaviour of the FIND_XXX() commands:
  # search headers and libraries in the target environment, search
  # programs in the host environment.
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE STRING "")
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY CACHE STRING "")
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY CACHE STRING "")
endif()
