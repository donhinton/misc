# This file is primarily for cross compiling clang+llvm, et al, for
# Linux on Darwin, and can be invoked like this:
#
#  cmake -GNinja -DBOOTSTRAP_CMAKE_SYSROOT=<path> [OPTIONS] \
#    -DBOOTSTRAP_CMAKE_TOOLCHAIN_FILE=<llvm root>/cmake/platforms/linux-toolchain.cmake \
#    -C <clang root>/cmake/caches/Linux.cmake ../llvm

if(NOT DEFINED BOOTSTRAP_CMAKE_SYSROOT)
  message(SEND_ERROR "Missing required argument -DBOOTSTRAP_CMAKE_SYSROOT=<sysroot path>.")
endif()
if(NOT DEFINED BOOTSTRAP_CMAKE_TOOLCHAIN_FILE)
  message(SEND_ERROR "Missing required argument -DBOOTSTRAP_CMAKE_TOOLCHAIN_FILE=<file>.")
endif()

set(LLVM_TARGETS_TO_BUILD Native CACHE STRING "")
set(CMAKE_BUILD_TYPE RELEASE CACHE STRING "")
set(LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")

set(CLANG_ENABLE_BOOTSTRAP ON CACHE BOOL "")

if(NOT DEFINED BOOTSTRAP_LLVM_DEFAULT_TARGET_TRIPLE)
  set(BOOTSTRAP_LLVM_DEFAULT_TARGET_TRIPLE "x86_64-unknown-linux-gnu")
endif()

# Since LLVM_ENABLE_PROJECTS gets passed automatically to the next
# stage, use another variable to pass the desired projects to stage2.
if(DEFINED BOOTSTRAP_LLVM_ENABLE_PROJECTS)
  set(BOOTSTRAP_LLVM_ENABLE_PROJECTS_OVERRIDE ${BOOTSTRAP_LLVM_ENABLE_PROJECTS} CACHE STRING "" FORCE)
  unset(BOOTSTRAP_LLVM_ENABLE_PROJECTS CACHE)
else()
  set(BOOTSTRAP_LLVM_ENABLE_PROJECTS_OVERRIDE "clang;libcxx;libcxxabi;libunwind" CACHE STRING "" FORCE)
endif()

if(CMAKE_HOST_APPLE)
  # Make sure at least clang and lld are included.
  list(APPEND LLVM_ENABLE_PROJECTS clang lld)
  set(LLVM_ENABLE_PROJECTS ${LLVM_ENABLE_PROJECTS} CACHE STRING "")

  # Passing -fuse-ld=lld is hard for cmake to handle correctly, so
  # make lld the default linker.
  set(CLANG_DEFAULT_LINKER lld CACHE STRING "" FORCE)
  set(BOOTSTRAP_LLVM_ENABLE_LLD ON CACHE BOOL "")

  set(BOOTSTRAP_CMAKE_AR ${CMAKE_BINARY_DIR}/bin/llvm-ar CACHE STRING "")
  set(BOOTSTRAP_CMAKE_RANLIB ${CMAKE_BINARY_DIR}/bin/llvm-ranlib CACHE STRING "")
  set(BOOTSTRAP_CLANG_TABLEGEN ${CMAKE_BINARY_DIR}/bin/clang-tblgen CACHE STRING "")
  set(BOOTSTRAP_LLVM_TABLEGEN ${CMAKE_BINARY_DIR}/bin/llvm-tblgen CACHE STRING "")
endif()

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
