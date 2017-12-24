

set(CMAKE_SYSTEM_NAME "Linux")

set(sysroot "/tmp/docker/ubuntu")
set(triple x86_64-linux-gnu)
set(flags "--sysroot=${sysroot} -target ${triple}")

set(LLVM_DEFAULT_TARGET_TRIPLE "${triple}")

# These are needed/used for compiler tests, e.g., include files and flags.
set(CMAKE_REQUIRED_FLAGS ${flags})
set(CMAKE_REQUIRED_LIBRARIES "-fuse-ld=lld")

set(CMAKE_C_COMPILER "clang")
set(CMAKE_C_FLAGS ${flags})

set(CMAKE_CXX_COMPILER "clang++")
set(CMAKE_CXX_FLAGS ${flags})

# Full path is required since PATH doesn't seem to propagate.
find_program(CMAKE_RANLIB llvm-ranlib)
find_program(CMAKE_AR llvm-ar)

set(CMAKE_STATIC_LINKER_FLAGS "-format gnu" CACHE STRING "")

set(LLVM_ENABLE_LLD ON)

set(LLVM_ENABLE_ZLIB OFF)

# Force gcc lookup at runtime -- otherwise Darwin will default to 4.2.1.
set(GCC_INSTALL_PREFIX "/usr")

# here is the target environment located
SET(CMAKE_FIND_ROOT_PATH "${sysroot}")

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search 
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


