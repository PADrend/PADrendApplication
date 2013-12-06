/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2010 Benjamin Eikel <benjamin@eikel.org>
 * Copyright (C) 2010 Claudius Jähn <claudius@uni-paderborn.de>
 * Copyright (C) 2009-2010 Ralf Petring <ralf@petring.net>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */
/*
Shader der PhongShading macht und die Pixel nachtraeglich umfaerben kann
lights:         die Nummern der aktiven Lichter (0 fuer GL_LIGHT0...) bzw. -1 fuer deaktiviert
                nach der ersten -1 wird der rest ignoriert
                [2,0,-1,3] bedeutet: GL_LIGHT0 und GL_LIGHT2 aktiv, GL_LIGHT3 ist NICHT aktiv
color:          wenn color.a > 0 wird blending mit color durchgefuehrt, staerke entspricht color.a
COLOR_MATERIAL: wenn true wird GL_COLOR benutzt, ansonsten die materialeigenschaften
*/

varying vec3 eyeSpaceNormal;
varying vec4 eyeSpacePosition;


uniform bool sg_textureEnabled[8];
varying vec2 texCoord0;

uniform float envMappingStrength;
varying vec2 envMapCoord;

uniform bool sg_shadowEnabled;
uniform mat4 sg_shadowMatrix;
uniform mat4 sg_cameraInverseMatrix;
varying vec4 shadowCoord;

void main (void) {
	eyeSpaceNormal = normalize(gl_NormalMatrix * gl_Normal);
	
	// Eye-coordinate position of vertex, needed in various calculations
	eyeSpacePosition = gl_ModelViewMatrix * gl_Vertex;
	
	 // environmental mapping (hacked!)
	 // http://www.ozone3d.net/tutorials/glsl_texturing_p04.php
	if(envMappingStrength>0.0){
		vec3 u = normalize( vec3(gl_ModelViewMatrix * gl_Vertex) );
		vec3 n = normalize( gl_NormalMatrix * gl_Normal );
		vec3 r = reflect( u, n );
		float m = 2.0 * sqrt( r.x*r.x + r.y*r.y + (r.z+1.0)*(r.z+1.0) );
		envMapCoord.s = r.x/m + 0.5;
		envMapCoord.t = r.y/m + 0.5;
	}

	
	if(sg_textureEnabled[0])
		texCoord0 = gl_MultiTexCoord0.st;

	//if(sg_textureEnabled[0])
	//	texCoord1 = gl_MultiTexCoord1.st;
	
	// Calculate texture coordinates for shadow from object coordinates.
	if(sg_shadowEnabled){
		shadowCoord = sg_shadowMatrix * sg_cameraInverseMatrix * gl_ModelViewMatrix * gl_Vertex;
	}
	
	// Do fixed functionality vertex transform
	gl_Position = ftransform();
	gl_FrontColor = gl_Color;
}
