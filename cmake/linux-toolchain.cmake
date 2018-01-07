# This file is intended to support cross compiling a linux toolchain
# on any host system, includind Darwin.
#
# Usage: cmake -GNinja -DCMAKE_C_COMPILER=<c compiler> -DCMAKE_SYSROOT=<path> [OPTIONS] -DCMAKE_TOOLCHAIN_FILE=linux-toolchain.cmake  ../llvm
#
#  Common options with (default):
#
#    FIXME: reorganize these and add more info.
#    CMAKE_BUILD_TYPE (Release)
#    CMAKE_AR
#    CMAKE_RANLIB
#    GCC_INSTALL_PREFIX ("/usr")
#    LLVM_DEFAULT_TARGET_TRIPLE ("x86_64-unknown-linux-gnu")
#    LLVM_ENABLE_PROJECTS
#    LLVM_ENABLE_PROJECTS_OVERRIDE -- used to override
#      LLVM_ENABLE_PROJECTS when bootstrapping, which is passed
#      automatically.
#    CLANG_TABLEGEN
#    LLVM_TABLEGEN
#    _LLVM_CONFIG_EXE
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
#  4) Stage2 configuration fails for several sub-projects, including
#     libcxx, libcxxabi, and libunwind, with the following error:
#
#       CMake Error at .../llvm_project/libunwind/src/CMakeLists.txt:110 (add_library):
#       The install of the unwind_shared target requires changing an
#       RPATH from the build tree, but this is not supported with the
#       Ninja generator unless on an ELF-based platform.  The
#       CMAKE_BUILD_WITH_INSTALL_RPATH variable may be set to avoid
#       this relinking step.
#
#  5) Passing _LLVM_CONFIG_EXE requires a patch.
#

set(CMAKE_SYSTEM_NAME Linux CACHE STRING "" FORCE)

#
# Required arguments.
#

# Cmake sets CMAKE_CXX_COMPILER sets automatically based on CMAKE_C_COMPILER.
if(NOT DEFINED CMAKE_C_COMPILER)
  message(FATAL_ERROR "Missing required option -DCMAKE_C_COMPILER=<c compiler>.")
endif()
if(NOT DEFINED CMAKE_SYSROOT)
  message(FATAL_ERROR "Missing required option -DCMAKE_SYSROOT=<sysroot path>.")
endif()

#
# Optional arguments.
#

# Set default, but allow overries.
if(NOT DEFINED CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "")
endif()

if(NOT DEFINED CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "")
endif()

if(NOT DEFINED LLVM_DEFAULT_TARGET_TRIPLE)
  set(LLVM_DEFAULT_TARGET_TRIPLE "x86_64-unknown-linux-gnu" CACHE STRING "")
endif()

set(CMAKE_C_COMPILER_TARGET "${LLVM_DEFAULT_TARGET_TRIPLE}" CACHE STRING "")
set(CMAKE_CXX_COMPILER_TARGET "${LLVM_DEFAULT_TARGET_TRIPLE}" CACHE STRING "")

# Allow overriding LLVM_ENABLE_PROJECTS.  This is useful when
# bootstrapping since clang automatically fowards the
# LLVM_ENABLE_PROJECTS used to compile the host tools.
if(DEFINED LLVM_ENABLE_PROJECTS_OVERRIDE)
  set(LLVM_ENABLE_PROJECTS "${LLVM_ENABLE_PROJECTS_OVERRIDE}" CACHE STRING "" FORCE)
endif()

# Force clang to look for gcc at runtime -- otherwise it will
# default to 4.2.1.
if(NOT DEFINED GCC_INSTALL_PREFIX)
  set(GCC_INSTALL_PREFIX "/usr" CACHE STRING "")
endif()

# If the Host is Apple, we need to use the llvm tools, since the apple
# ones don't support elf.
if(CMAKE_HOST_APPLE)
  # Need to use PROGRAM first just in case CMAKE_C_COMPILER doesn't
  # include a path.
  get_filename_component(c_compiler "${CMAKE_C_COMPILER}" PROGRAM)
  get_filename_component(base_path "${c_compiler}" DIRECTORY)
  if(NOT DEFINED CMAKE_AR)
    set(CMAKE_AR "${base_path}/llvm-ar" CACHE STRING "")
  endif()
  if(NOT DEFINED CMAKE_RANLIB)
    set(CMAKE_RANLIB "${base_path}/llvm-ranlib" CACHE STRING "")
  endif()

  # FIXME: Should these go here, or just rely on them being passed?
  if(NOT DEFINED CLANG_TABLEGEN)
    set(CLANG_TABLEGEN "${base_path}/clang-tblgen" CACHE STRING "")
  endif()
  if(NOT DEFINED LLVM_TABLEGEN)
    set(LLVM_TABLEGEN "${base_path}/llvm-tblgen" CACHE STRING "")
  endif()

  # Make sure static libs use the gnu format.
  set(CMAKE_STATIC_LINKER_FLAGS "-format gnu" CACHE STRING "")

  # Changing an RPATH from the build tree is not supported with the
  # Ninja generator unless on an ELF-based platform.  This might
  # require changes to llvm cmake files at some point.
  if(CMAKE_GENERATOR STREQUAL "Ninja")
    set(CMAKE_BUILD_WITH_INSTALL_RPATH ON CACHE BOOL "")
  endif()
endif()

# Use CMAKE_SYSROOT prefix for FIND_XXX() commands.
SET(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}" CACHE STRING "")

# Adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search
# programs in the host environment.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE STRING "")
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY CACHE STRING "")
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY CACHE STRING "")
