set(CMAKE_GENERATOR Ninja CACHE STRING "" FORCE)


#set(LLVM_USE_SANITIZER Address Undefined CACHE STRING "" FORCE)

#set(LIBCXX_HAVE_CXX_ATOMICS_WITHOUT_LIB ON CACHE BOOL "" FORCE)
#set(LIBCXX_HAS_ATOMIC_LIB ON CACHE BOOL "" FORCE)

#set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "" FORCE)
set(LLVM_TARGETS_TO_BUILD "X86" CACHE STRING "" FORCE)

set(CMAKE_BUILD_TYPE Debug CACHE STRING "" FORCE)

set(LLVM_OPTIMIZED_TABLEGEN ON CACHE BOOL "" FORCE)
#set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)

#set(LLVM_ENABLE_PLUGINS OFF CACHE BOOL "" FORCE)
#set(CLANG_ENABLE_STATIC_ANALYZER OFF CACHE BOOL "" FORCE)

set(LLVM_INCLUDE_BENCHMARKS OFF CACHE BOOL "" FORCE)

set(LLVM_APPEND_VC_REV OFF CACHE BOOL "" FORCE)

set(LLVM_EXTERNAL_PROJECTS Scratch  CACHE STRING "" FORCE)
set(LLVM_ENABLE_PROJECTS Scratch  CACHE STRING "" FORCE)

#set(LLVM_ENABLE_PROJECTS ${LLVM_ENABLE_PROJECTS} clang  CACHE STRING "" FORCE)

# need both these to build lldb
#set(LLVM_ENABLE_PROJECTS ${LLVM_ENABLE_PROJECTS} lldb  CACHE STRING "" FORCE)
#set(LLVM_ENABLE_PROJECTS ${LLVM_ENABLE_PROJECTS} libcxx libcxxabi CACHE STRING "" FORCE)

#set(LLVM_ENABLE_PROJECTS ${LLVM_ENABLE_PROJECTS} clang-tools-extra CACHE STRING "" FORCE)
#set(LLVM_ENABLE_PROJECTS clang libcxx libcxxabi compiler-rt CACHE STRING "" FORCE)

#set(LLVM_USE_SANITIZER Address CACHE STRING "")
#set(CMAKE_C_FLAGS "-fsanitize=address -fno-omit-frame-pointer ${CMAKE_C_FLAGS}" CACHE STRING "")
#set(CMAKE_CXX_FLAGS "-fsanitize=address -fno-omit-frame-pointer ${CMAKE_CXX_FLAGS}" CACHE STRING "")


#set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
#set(LLVM_USE_SPLIT_DWARF ON CACHE BOOL "" FORCE)

set(LLVM_LIT_ARGS '-vv' CACHE STRING "" FORCE)

find_program(GOLD NAMES gold ld.gold)
if(GOLD)
  set(LLVM_USE_LINKER "gold" CACHE STRING "" FORCE)
endif()

#if(POLICY CMP0017)
#  cmake_policy(SET CMP0017 OLD)
#endif()

#set(CXX_CLANG_TIDY "some commandline for clang-tidy")

set(CMAKE_C_FLAGS "-I/opt/local/include ${CMAKE_C_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "-I/opt/local/include ${CMAKE_CXX_FLAGS}" CACHE STRING "" FORCE)

# turn this off as it causes relinking
#set(CLANGD_BUILD_XPC OFF CACHE BOOL "" FORCE)
#set(LIBCXX_INCLUDE_BENCHMARKS OFF CACHE BOOL "" FORCE)
