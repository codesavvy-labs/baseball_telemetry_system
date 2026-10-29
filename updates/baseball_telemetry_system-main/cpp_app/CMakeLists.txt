cmake_minimum_required(VERSION 3.20)

project(baseball_telemetry_cpp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(baseball_telemetry_cpp
    src/main.cpp
)

enable_testing()

add_executable(cpp_smoke_test
    tests/test_smoke.cpp
)

add_test(NAME cpp_smoke_test COMMAND cpp_smoke_test)