set(CMAKE_C_FLAGS "-fsanitize=address -fno-omit-frame-pointer ${CMAKE_C_FLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS "-fsanitize=address -fno-omit-frame-pointer ${CMAKE_CXX_FLAGS}" CACHE STRING "")
