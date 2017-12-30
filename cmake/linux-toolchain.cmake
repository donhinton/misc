# This toolchain file is intended to support cross compiling
# clang+llvm for linux on Darwin.

# This file is a WIP, and is a preliminary step in creating a 2-stage
# workflow.  Assuming clang+llvm+lld have already been built on
# Darwin, it can be invoked like this:
#
# PATH=<prefix to prebuilt clang+llvm+lld>/bin:$PATH cmake -GNinja -DCMAKE_TOOLCHAIN_FILE=<path to this file>/linux-toolchain.cmake  ../../llvm
#
# Currently requires the following patches still under review:
#   https://reviews.llvm.org/D41621
#   https://reviews.llvm.org/D41622
#   https://reviews.llvm.org/D41623
#   https://gitlab.kitware.com/cmake/cmake/merge_requests/1620

if(NOT DEFINED TOOLCHAIN_FILE_LOADED)
  message(STATUS "Loading toolchain file: ${CMAKE_CURRENT_LIST_FILE}.")
  set(TOOLCHAIN_FILE_LOADED TRUE CACHE BOOL "")

  set(CMAKE_SYSTEM_NAME "Linux" CACHE STRING "")

  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "" FORCE)
  set(LLVM_ENABLE_PROJECTS "clang;libcxx;libcxxabi;libunwind;lld" CACHE STRING "" FORCE)

  set(CMAKE_C_COMPILER_FORCED TRUE CACHE BOOL "" FORCE)
  set(CMAKE_C_COMPILER "clang")

  set(CMAKE_CXX_COMPILER_FORCED TRUE CACHE BOOL "" FORCE)
  set(CMAKE_CXX_COMPILER "clang++")

  # The sysroot tree was created via https://github.com/donhinton/misc/blob/master/scripts/export_docker_filesystem.sh
  set(sysroot "/tmp/docker/ubuntu")
  set(triple "x86_64-unknown-linux-gnu")
  set(flags "--sysroot=${sysroot} -target ${triple}")
  set(link-flags "-fuse-ld=lld")

  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${flags}" CACHE STRING "")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${flags}" CACHE STRING "")

  set(LLVM_DEFAULT_TARGET_TRIPLE "${triple}" CACHE STRING "" FORCE)

  set(LIBCXX_TARGET_TRIPLE "${triple}" CACHE STRING "" FORCE)
  set(LIBCXX_SYSROOT "${sysroot}" CACHE STRING "" FORCE)
  set(LIBCXX_CFLAGS "${flags}" CACHE STRING "" FORCE)

  # These are needed/used for compiler tests, e.g., include files and flags.
  set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} ${flags}" CACHE STRING "" FORCE)
  set(CMAKE_REQUIRED_LIBRARIES "${CMAKE_REQUIRED_LIBRARIES} ${link-flags}" CACHE STRING "" FORCE)

  # testing...  When we start using this for a multi-stage build, these
  # can be set to point to the first stage.
  # must use full path... ;-(
  #set(CLANG_TABLEGEN "/Users/dhinton/projects/llvm_project/build/Release/bin/clang-tblgen")
  #set(LLVM_TABLEGEN "/Users/dhinton/projects/llvm_project/build/Release/bin/llvm-tblgen")
  #set(_LLVM_CONFIG_EXE "/Users/dhinton/projects/llvm_project/build/Release/bin/llvm-config")

  # Full path is required since PATH doesn't seem to propagate.
  find_program(CMAKE_RANLIB llvm-ranlib)
  find_program(CMAKE_AR llvm-ar)

  set(CMAKE_STATIC_LINKER_FLAGS "-format gnu" CACHE STRING "" FORCE)

  set(LLVM_ENABLE_LLD ON CACHE STRING "" FORCE)

  set(LLVM_ENABLE_ZLIB OFF CACHE BOOL "" FORCE)

  # Force gcc lookup at runtime -- otherwise Darwin will default to 4.2.1.
  set(GCC_INSTALL_PREFIX "/usr" CACHE STRING "" FORCE)

  # Changing an RPATH from the build tree is not supported with the
  # Ninja generator unless on an ELF-based platform.
  if(CMAKE_HOST_APPLE AND CMAKE_GENERATOR STREQUAL "Ninja")
    set(CMAKE_BUILD_WITH_INSTALL_RPATH ON CACHE BOOL "" FORCE)
  endif()


  set(CMAKE_SYSTEM_PREFIX_PATH "${sysroot}" CACHE STRING "" FORCE)
	# Here is where the target environment located.
  SET(CMAKE_FIND_ROOT_PATH "${sysroot}" CACHE STRING "" FORCE)

  # adjust the default behaviour of the FIND_XXX() commands:
  # search headers and libraries in the target environment, search 
  # programs in the host environment
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE STRING "" FORCE)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY CACHE STRING "" FORCE)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY CACHE STRING "" FORCE)
endif()
