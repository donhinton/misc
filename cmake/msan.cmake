set(CMAKE_C_FLAGS "-fsanitize=memory -fno-omit-frame-pointer ${CMAKE_C_FLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS "-fsanitize=memory -fno-omit-frame-pointer ${CMAKE_CXX_FLAGS}" CACHE STRING "")
