#
# This file is part of the open source part of the
# Platform for Algorithm Development and Rendering (PADrend).
# Web page: http://www.padrend.de/
# Copyright (C) 2009-2013 Benjamin Eikel <benjamin@eikel.org>
# 
# PADrend consists of an open source part and a proprietary part.
# The open source part of PADrend is subject to the terms of the Mozilla
# Public License, v. 2.0. You should have received a copy of the MPL along
# with this library; see the file LICENSE. If not, you can obtain one at
# http://mozilla.org/MPL/2.0/.
#
cmake_minimum_required(VERSION 2.8.11)

# Packaging
set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP ON)
include(InstallRequiredSystemLibraries)
if(WIN32)
	install(FILES ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS} DESTINATION bin COMPONENT runtimelibraries)
	# Search the "libgcc_s_sjlj-1.dll" file
	execute_process(
		COMMAND ${CMAKE_CXX_COMPILER} -print-file-name=libgcc_s_sjlj-1.dll
		OUTPUT_VARIABLE GCC_S_SJLJ_LIBRARY
		OUTPUT_STRIP_TRAILING_WHITESPACE
	)
	if(EXISTS ${GCC_S_SJLJ_LIBRARY})
		install(FILES ${GCC_S_SJLJ_LIBRARY} DESTINATION bin COMPONENT runtimelibraries)
	endif()
	# Search the "libstdc++-6.dll" file
	execute_process(
		COMMAND ${CMAKE_CXX_COMPILER} -print-file-name=libstdc++-6.dll
		OUTPUT_VARIABLE STDCPP_LIBRARY
		OUTPUT_STRIP_TRAILING_WHITESPACE
	)
	if(EXISTS ${STDCPP_LIBRARY})
		install(FILES ${STDCPP_LIBRARY} DESTINATION bin COMPONENT runtimelibraries)
	endif()
else()
	install(FILES ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS} DESTINATION lib COMPONENT runtimelibraries)
endif()

set(CPACK_PACKAGE_NAME "PADrend")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PADREND_DESCRIPTION})
set(CPACK_PACKAGE_VENDOR ${PADREND_AUTHORS})
set(CPACK_PACKAGE_CONTACT "Benjamin Eikel <benjamin@eikel.org>")
set(CPACK_PACKAGE_VERSION_MAJOR ${PADREND_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PADREND_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PADREND_VERSION_PATCH})
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/resources/Installer/NSIS_windows/Notice.txt")

set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "http://www.padrend.de/")

set(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_SOURCE_DIR}/resources/Installer/NSIS_windows/PADrendIcon.ico")
set(CPACK_NSIS_MUI_UNIICON "${CMAKE_CURRENT_SOURCE_DIR}/resources/Installer/NSIS_windows/PADrendIcon.ico")
set(CPACK_NSIS_INSTALLED_ICON_NAME "bin/PADrend.exe")
set(CPACK_NSIS_URL_INFO_ABOUT "http://www.padrend.de/")
set(CPACK_NSIS_MODIFY_PATH ON)
set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY ${CPACK_PACKAGE_NAME})

if(APPLE)
	set(CPACK_BUNDLE_NAME            "PADrend")
	set(CPACK_BUNDLE_ICON            "${CMAKE_CURRENT_SOURCE_DIR}/resources/Installer/Bundle_OSX/PADrendIcon.icns")
	set(CPACK_BUNDLE_PLIST           "${CMAKE_CURRENT_SOURCE_DIR}/resources/Installer/Bundle_OSX/Info.plist")
	set(CPACK_BUNDLE_STARTUP_COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/resources/Installer/Bundle_OSX/start_padrend.sh")
endif()

set(CPACK_CREATE_DESKTOP_LINKS PADrend)
set(CPACK_PACKAGE_EXECUTABLES "PADrend" "PADrend")

set(CPACK_STRIP_FILES ON)

set(CPACK_COMPONENTS_ALL applications developmentlibraries extplugins headers plugins resources runtimelibraries sources)
set(CPACK_COMPONENT_APPLICATIONS_DISPLAY_NAME "Applications")
set(CPACK_COMPONENT_APPLICATIONS_DEPENDS runtimelibraries plugins resources)
set(CPACK_COMPONENT_APPLICATIONS_GROUP "Runtime")
set(CPACK_COMPONENT_DEVELOPMENTLIBRARIES_DISPLAY_NAME "Development Libraries")
set(CPACK_COMPONENT_DEVELOPMENTLIBRARIES_DEPENDS headers)
set(CPACK_COMPONENT_DEVELOPMENTLIBRARIES_GROUP "Development")
set(CPACK_COMPONENT_EXTPLUGINS_DISPLAY_NAME "External Plug-ins")
set(CPACK_COMPONENT_EXTPLUGINS_DEPENDS plugins)
set(CPACK_COMPONENT_EXTPLUGINS_GROUP "Runtime")
set(CPACK_COMPONENT_HEADERS_DISPLAY_NAME "C++ header files")
set(CPACK_COMPONENT_HEADERS_GROUP "Development")
set(CPACK_COMPONENT_PLUGINS_DISPLAY_NAME "Core Plug-ins")
set(CPACK_COMPONENT_PLUGINS_GROUP "Runtime")
set(CPACK_COMPONENT_RESOURCES_DISPLAY_NAME "Resources")
set(CPACK_COMPONENT_RESOURCES_GROUP "Runtime")
set(CPACK_COMPONENT_RUNTIMELIBRARIES_DISPLAY_NAME "Runtime Libraries")
set(CPACK_COMPONENT_RUNTIMELIBRARIES_GROUP "Runtime")
set(CPACK_COMPONENT_SOURCES_DISPLAY_NAME "Source Files")
set(CPACK_COMPONENT_SOURCES_GROUP "Development")

set(CPACK_ALL_INSTALL_TYPES User Developer Full)
set(CPACK_COMPONENT_APPLICATIONS_INSTALL_TYPES User Full)
set(CPACK_COMPONENT_DEVELOPMENTLIBRARIES_INSTALL_TYPES Developer Full)
set(CPACK_COMPONENT_EXTPLUGINS_INSTALL_TYPES User Developer Full)
set(CPACK_COMPONENT_HEADERS_INSTALL_TYPES Developer Full)
set(CPACK_COMPONENT_PLUGINS_INSTALL_TYPES User Developer Full)
set(CPACK_COMPONENT_RESOURCES_INSTALL_TYPES User Developer Full)
set(CPACK_COMPONENT_RUNTIMELIBRARIES_INSTALL_TYPES User Full)
set(CPACK_COMPONENT_SOURCES_INSTALL_TYPES Developer Full)

include(CPack)
