set(CMAKE_BUILD_TYPE Debug CACHE STRING "")

set(LLVM_TARGETS_TO_BUILD "X86" CACHE STRING "")

set(BUILD_SHARED_LIBS ON CACHE BOOL "")
set(LLVM_USE_SPLIT_DWARF ON CACHE BOOL "")

find_program(GOLD_PATH gold)
if(GOLD_PATH)
  set(LLVM_USE_LINKER "gold" CACHE STRING "")
endif()
