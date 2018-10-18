cmake_minimum_required(VERSION 1.0)
add_definitions("-Wall -std=c99")
#add_executable(run.exe
    #example_correct.c
    #inc/list.c
    #)
add_subdirectory(inc)
add_executable(../bin/run.exe example_correct.c)
target_link_libraries(../bin/run.exe list m)
