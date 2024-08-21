cmake_minimum_required(VERSION 3.14)

project(VideoTx LANGUAGES CXX)

#set(CMAKE_AUTOUIC ON)
#set(CMAKE_AUTOMOC ON)
#set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

add_executable(VideoTx
  source/tx.hpp
  source/tx.cpp
  source/wifibroadcast.cpp
  source/wifibroadcast.hpp
  source/fec.h
  source/fec.c
)

target_link_libraries(VideoTx
    pcap
    sodium
)

install(TARGETS VideoTx
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

project(KeyGen LANGUAGES C)

add_executable(KeyGen
    source/keygen.c
)

target_link_libraries(KeyGen
    sodium
)

install(TARGETS KeyGen
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

project(VideoRx LANGUAGES CXX)

add_executable(VideoRx
    source/rx.hpp
    source/rx.cpp
    source/ieee80211_radiotap.h
    source/wifibroadcast.cpp
    source/wifibroadcast.hpp
    source/radiotap.c
    source/fec.h
    source/fec.c
)

target_link_libraries(VideoRx
    pcap
    sodium
)

install(TARGETS VideoRx
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
