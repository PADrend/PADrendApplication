#
# This file is part of the open source part of the
# Platform for Algorithm Development and Rendering (PADrend).
# Web page: http://www.padrend.de/
# Copyright (C) 2009-2012 Benjamin Eikel <benjamin@eikel.org>
# 
# PADrend consists of an open source part and a proprietary part.
# The open source part of PADrend is subject to the terms of the Mozilla
# Public License, v. 2.0. You should have received a copy of the MPL along
# with this library; see the file LICENSE. If not, you can obtain one at
# http://mozilla.org/MPL/2.0/.
#
cmake_minimum_required(VERSION 2.8.8)

project(PADrendSingle)

add_subdirectory(src)

install(DIRECTORY plugins
	DESTINATION bin COMPONENT plugins
	PATTERN ".svn" EXCLUDE
)
install(DIRECTORY extPlugins
	DESTINATION bin COMPONENT extplugins
	PATTERN ".svn" EXCLUDE
)
install(DIRECTORY resources
	DESTINATION bin COMPONENT resources
	PATTERN ".svn" EXCLUDE
)
