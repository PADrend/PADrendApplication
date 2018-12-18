#
# This file is part of the open source part of the
# Platform for Algorithm Development and Rendering (PADrend).
# Web page: http://www.padrend.de/
# Copyright (C) 2012-2013 Benjamin Eikel <benjamin@eikel.org>
# 
# PADrend consists of an open source part and a proprietary part.
# The open source part of PADrend is subject to the terms of the Mozilla
# Public License, v. 2.0. You should have received a copy of the MPL along
# with this library; see the file LICENSE. If not, you can obtain one at
# http://mozilla.org/MPL/2.0/.
#
cmake_minimum_required(VERSION 3.1.0)
project(PADrend VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/resources/CMake)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(PADREND_DESCRIPTION "Platform for Algorithm Development and Rendering (PADrend)")
set(PADREND_AUTHORS "Benjamin Eikel; Claudius Jaehn; Ralf Petring")

# Set up install directories
include(GNUInstallDirs)

if(WIN32)
	set(PADREND_RESOURCE_FILE "${CMAKE_CURRENT_BINARY_DIR}/Resource.rc")
	configure_file("${CMAKE_CURRENT_SOURCE_DIR}/resources/Windows/Resource.rc.in" ${PADREND_RESOURCE_FILE} @ONLY)
endif()

add_executable(PADrend
	PADrendMain.cpp
	${PADREND_RESOURCE_FILE}
)

if(WIN32)
	set_property(TARGET PADrend APPEND PROPERTY INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/resources/Windows")
endif()

# Dependency to EScript
if(NOT TARGET EScript)
	find_package(EScript 0.6.7 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC EScript)

# Dependency to E_Geometry
if(NOT TARGET E_Geometry)
	find_package(E_Geometry 0.2.0 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC E_Geometry)

# Dependency to E_GUI
if(NOT TARGET E_GUI)
	find_package(E_GUI 0.2.0 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC E_GUI)

# Dependency to E_MinSG
if(NOT TARGET E_MinSG)
	find_package(E_MinSG 0.2.0 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC E_MinSG)

# Dependency to E_Rendering
if(NOT TARGET E_Rendering)
	find_package(E_Rendering 0.2.0 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC E_Rendering)

# Dependency to E_Util
if(NOT TARGET E_Util)
	find_package(E_Util 0.2.0 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC E_Util)

# Dependency to Geometry
if(NOT TARGET Geometry)
	find_package(Geometry 0.2.0 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC Geometry)

# Dependency to GUI
if(NOT TARGET GUI)
	find_package(GUI 0.2.0 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC GUI)

# Dependency to MinSG
if(NOT TARGET MinSG)
	find_package(MinSG 0.2.0 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC MinSG)

# Dependency to Rendering
if(NOT TARGET Rendering)
	find_package(Rendering 0.2.0 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC Rendering)

# Dependency to Util
if(NOT TARGET Util)
	find_package(Util 0.2.0 REQUIRED NO_MODULE)
endif()
target_link_libraries(PADrend LINK_PUBLIC Util)

# Optional dependency to Sound and E_Sound
if(NOT TARGET Sound)
	find_package(Sound 0.2.0 QUIET NO_MODULE)
endif()
if(NOT TARGET E_Sound)
	find_package(E_Sound 0.2.0 QUIET NO_MODULE)
endif()
if(TARGET Sound AND TARGET E_Sound)
	target_compile_definitions(PADrend PUBLIC PADREND_HAVE_LIB_E_SOUND)
	target_link_libraries(PADrend LINK_PUBLIC Sound E_Sound)
endif()

if(APPLE)
	# Dependency to SDL2
	find_package(SDL2 2.0.0 REQUIRED)
	target_include_directories(PADrend PRIVATE ${SDL2_INCLUDE_DIRS})
	target_link_libraries(PADrend LINK_PRIVATE ${SDL2_LIBRARIES})
endif()

# Install the application
install(TARGETS PADrend
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT applications
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT applications
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT applications
)

include(${CMAKE_CURRENT_SOURCE_DIR}/resources/Installer/Packaging.cmake)
