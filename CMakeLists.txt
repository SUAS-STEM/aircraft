cmake_minimum_required(VERSION 3.10)

# Enable Hot Reload for MSVC compilers if supported.
if (POLICY CMP0141)
    cmake_policy(SET CMP0141 NEW)
    set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

project(aircraft)

list(APPEND CMAKE_PREFIX_PATH "extern/mavsdk")
set(OpenCV_DIR "${CMAKE_SOURCE_DIR}/extern/opencv/build")

# set(CMAKE_MSVCIDE_RUN_PATH "${OpenCV_DIR}/x64/vc16/bin")

find_package(MAVSDK REQUIRED)
find_package(OpenCV REQUIRED)

add_compile_options(/Z7)

set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT Embedded)

file(
    GLOB_RECURSE
    SOURCES
    "src/*.cpp"
    "include/*.h"
)

add_library(aircraft STATIC ${SOURCES})
target_include_directories(aircraft PUBLIC include)
target_link_libraries(aircraft PUBLIC MAVSDK::mavsdk ${OpenCV_LIBS})
target_compile_features(aircraft PUBLIC cxx_std_20)
