#version 120
#extension GL_ARB_geometry_shader4 : enable

/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2010 Benjamin Eikel <benjamin@eikel.org>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

uniform float aspectRatio;

varying out vec2 texCoord;

void main(void) {
	for(int i = 0; i < gl_VerticesIn; ++i) {
		texCoord = vec2(0.0, 0.0);
		gl_Position = gl_PositionIn[i];
		EmitVertex();

		texCoord = vec2(1.0, 0.0);
		gl_Position = gl_PositionIn[i] + vec4(1.0, 0.0, 0.0, 0.0);
		EmitVertex();

		texCoord = vec2(0.0, 1.0);
		gl_Position = gl_PositionIn[i] + vec4(0.0, aspectRatio, 0.0, 0.0);
		EmitVertex();

		texCoord = vec2(1.0, 1.0);
		gl_Position = gl_PositionIn[i] + vec4(1.0, aspectRatio, 0.0, 0.0);
		EmitVertex();

		EndPrimitive();
	}
}
