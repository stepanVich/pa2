cmake_minimum_required(VERSION 3.0)
include("./utils.cmake")

project(p0 LANGUAGES CXX CUDA)

set(IS_CROSS_COMPILATION FALSE CACHE BOOL "Indicates cross compilation = compilation for different platform that is the current machine.")
set(MY_SELECTED_PLATFORM "windows" CACHE STRING "User defined selected platform for the compilation.")
set(MY_ROOT_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE PATH "Root")
set(MY_COMMON_DIR ${MY_ROOT_SRC_DIR}/common CACHE PATH "Commons")
set(MY_SRC_DIR ${MY_ROOT_SRC_DIR}/src CACHE PATH "SRC")
set(MY_DATA_DIR ${MY_ROOT_SRC_DIR}/data CACHE PATH "DATA")

# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${MY_ROOT_SRC_DIR}/bin)
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/debug)
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/release)

# set(CMAKE_DEBUG_POSTFIX "-d")
set(CMAKE_VERBOSE_MAKEFILE ON)
# execute_process(COMMAND "${CMAKE_COMMAND}" "-E" "environment")

include("./multiplatform.cmake")

####################################################################################################
# Compilers definitions
####################################################################################################
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-reorder -Wno-unknown-pragmas")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR})

set(CMAKE_CUDA_FLAGS)
set(CMAKE_CUDA_FLAGS_DEBUG "-g")
set(CMAKE_CUDA_FLAGS_MINSIZEREL "-O1 -DNDEBUG")
set(CMAKE_CUDA_FLAGS_RELEASE "-O3 -DNDEBUG")
set(CMAKE_CUDA_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG")
set(CMAKE_CUDA_HOST_COMPILER)


 set(CUDA_NVCC_FLAGS
     ${CUDA_NVCC_FLAGS}
     -std=c++14
     -default-stream per-thread
     # -gencode=arch=compute_60,code=sm_60 \     #PASCAL
     # -gencode=arch=compute_61,code=sm_61 \ 
     # -gencode=arch=compute_62,code=sm_62 \ 
     # -gencode=arch=compute_70,code=sm_70 \     #VOLTA
     # -gencode=arch=compute_72,code=sm_72 \
     -gencode=arch=compute_75,code=sm_75       #TURING
)

#set (CMAKE_GENERATOR_PLATFORM "x64")
if(MY_SELECTED_PLATFORM STREQUAL "linux")
    include("./app.linux.cmake")
endif()
if(MY_SELECTED_PLATFORM STREQUAL "windows")
    include("./app.windows.cmake")
endif()
print_target_properties(app)


#print_cache (".*")
# print_cache (CMAKE_CXX_FLAGS)
# print_cache (CMAKE_CXX_STANDARD)
# print_cache (CMAKE_CUDA_FLAGS)
# print_cache (CUDA_NVCC_FLAGS)
# print_cache("^\(OPENGL\)|\(OpenGL\).*")
# print_cache("^\(CUDA\)|\(Cuda\).*")
# print_cache("^\(X11.*LIB$\)|\(X11_LIBRARIES\)")
