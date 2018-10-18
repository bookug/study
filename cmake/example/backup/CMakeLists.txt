cmake_minimum_required(VERSION 1.0)
add_definitions("-Wall -std=c99")
add_executable(run.exe 
    example_correct.c
    inc/list.c
    )
target_link_libraries(run.exe m)
