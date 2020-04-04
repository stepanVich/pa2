# set(MY_SELECTED_PLATFORM "jetson" CACHE STRING "User defined selected platform for the compilation.")
# # set(MY_SELECTED_PLATFORM_VALUES "linux;windows;jetson" CACHE INTERNAL "List of possible values for the SelectedPlatform.")
# # set_property(CACHE MY_SELECTED_PLATFORM PROPERTY STRINGS ${MY_SELECTED_PLATFORM_VALUES})
# message(STATUS "MY_SELECTED_PLATFORM='${MY_SELECTED_PLATFORM}'")

if(MY_SELECTED_PLATFORM STREQUAL "linux")
    
    set(CMAKE_SYSTEM_NAME Linux)

    set(CMAKE_C_COMPILER /usr/bin/gcc-6)
    set(CMAKE_CXX_COMPILER /usr/bin/g++-6)
    set(CMAKE_CUDA_COMPILER /usr/bin/nvcc)

elseif(MY_SELECTED_PLATFORM STREQUAL "jetson")
    
    set(CMAKE_SYSTEM_NAME Linux)
    set(CMAKE_SYSTEM_PROCESSOR aarch64)

    if (NOT IS_CROSS_COMPILATION)

        set(CMAKE_C_COMPILER /usr/bin/gcc-6)
        set(CMAKE_CXX_COMPILER /usr/bin/g++-6)
        set(CMAKE_CUDA_COMPILER /usr/local/cuda-9.0/bin/nvcc)

    else()
    
        set(CMAKE_CROSSCOMPILING TRUE)

        set(MY_AARCH64_DIR "/home/gajdi/apps/jetson/3-2/64_TX2" CACHE PATH "aarch64")
        set(MY_AARCH64_COMPILER_DIR ${MY_AARCH64_DIR}/gcc-linaro-6.4.1-2017.11-x86_64_aarch64-linux-gnu CACHE PATH "Custom compiler for aarch64")
        set(MY_AARCH64_ROOTFS_DIR ${MY_AARCH64_DIR}/Linux_for_Tegra/rootfs CACHE PATH "aarch64 rootfs")
        set(MY_AARCH64_CUDA_DIR ${MY_AARCH64_ROOTFS_DIR}/usr/local/cuda CACHE PATH "Cuda aarch64")
        
        # set(CMAKE_SYSROOT ${MY_AARCH64_ROOTFS_DIR})

        # Where to look for the target environment. (More paths can be added here). It s used (as base path) to search for the cross compiler toolchain paths.
        set(CMAKE_FIND_ROOT_PATH 
            ${MY_AARCH64_ROOTFS_DIR}
            ${MY_AARCH64_ROOTFS_DIR}/usr 
            ${MY_AARCH64_ROOTFS_DIR}/usr/lib  
            ${MY_AARCH64_ROOTFS_DIR}/usr/lib/aarch64-linux-gnu 
            ${MY_AARCH64_ROOTFS_DIR}/usr/lib/aarch64-linux-gnu/tegra
            ${MY_AARCH64_ROOTFS_DIR}/usr/local/cuda
            )

        # Adjust the default behavior of the FIND_XXX() commands: search programs in the host environment only.
        set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)    #... affects on find_program() call.
    
        # Search headers and libraries in the target environment only.
        set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)     #... affects on find_library() calls
        set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)     #... affects on find_pach() and find_file() calls
        set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)     #... affects on find_package() 

        project(demo)
        
        # This is for 'autotools' based projects
        set(CROSSCOMPILE_TOOLCHAIN_MACHINE_NAME "aarch64-linux-gnu")
        set(CROSSCOMPILE_TOOLCHAIN_PATH_PREFIX "aarch64-linux-gnu")

        # This assumes that pthread will be available on the target system (this emulates that the return of the TRY_RUN is a return code "0"
        set(THREADS_PTHREAD_ARG "0" CACHE STRING "Result from TRY_RUN" FORCE)

        set(CMAKE_C_COMPILER ${MY_AARCH64_COMPILER_DIR}/bin/aarch64-linux-gnu-gcc)
        set(CMAKE_CXX_COMPILER ${MY_AARCH64_COMPILER_DIR}/bin/aarch64-linux-gnu-g++)

        set(CMAKE_CUDA_COMPILER /usr/bin/nvcc)

        set(CUDA_HOST_COMPILER ${CMAKE_CXX_COMPILER})
        set(CUDA_BIN_PATH ${MY_AARCH64_ROOTFS_DIR})
        # This set the target for 'nvcc' that used by CUDA_TOOLKIT
        set(CUDA_TARGET_CPU_ARCH ${CMAKE_SYSTEM_PROCESSOR})
        # set(CUDA_TARGET_OS_VARIANT "linux")
        # set(CUDA_TOOLKIT_TARGET_DIR ${MY_AARCH64_CUDA_DIR}) 

        set(CUDA_TOOLKIT_ROOT_DIR ${MY_AARCH64_CUDA_DIR}) 
        set(CUDA_INCLUDE_DIR ${MY_AARCH64_CUDA_DIR}/include) 
        set(CUDA_LIBRARIES ${MY_AARCH64_CUDA_DIR}/lib64/libcudart.so ${MY_AARCH64_CUDA_DIR}/lib64/libcudart_static.a)
        # set(CUDA_TOOLKIT_ROOT_DIR "/usr/bin/nvcc") 

        include("./findX11onJetson.cmake")

    endif()

elseif (MY_SELECTED_PLATFORM STREQUAL "windows")
    
    set(CMAKE_SYSTEM_NAME Windows)

endif()