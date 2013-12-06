/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2010 Benjamin Eikel <benjamin@eikel.org>
 * Copyright (C) 2009-2010 Claudius Jähn <claudius@uni-paderborn.de>
 * Copyright (C) 2009-2010 Ralf Petring <ralf@petring.net>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */
/*	Shader der PhongShading macht und die Pixel nachtraeglich umfaerben kann
	
	\note Uses addGlLight.fs
*/

uniform vec4 color; //  wenn color.a > 0 wird blending mit color durchgefuehrt, staerke entspricht color.a

uniform bool sg_useMaterials;

uniform int sg_lightCount;

uniform bool sg_textureEnabled[8];
uniform sampler2D sg_texture0;
uniform sampler2D sg_texture1;

uniform sampler2D fakeBumpMap;
uniform float fakeBumpMapScale;
uniform float fakeBumpMapAmount;

uniform sampler2D envMap;
varying vec2 envMapCoord;
uniform float envMappingStrength;
uniform float envMappingBumpStrength;

varying vec3 eyeSpaceNormal;
varying vec4 eyeSpacePosition;

varying vec2 texCoord0;
varying vec2 texCoord1;

uniform bool sg_shadowEnabled;
uniform sampler2D sg_shadowTexture;
varying vec4 shadowCoord;


// forward declaration of external function (if the function is embedded as additional shaderObject 
void addGlLight(	in int lightIndex, in vec3 eyeSpacePos, in vec3 eyeSpaceNormal, in bool useMaterials,
					inout vec4 ambient, inout vec4 diffuse, inout vec4 specular);
					
// alternative preprocessor include:
/*{{ comment include "addGlLight.fs" }}*/
					
// --------------------------------------------------------------------------------------------------
float getSingleShadowSample(in sampler2D shadowTexture, in vec3 coord, in vec2 offset) {
	const vec2 texScale = vec2(1.0 / 4096.0);
	float depth = texture2D(shadowTexture, coord.xy + (offset * texScale)).r;
	return (depth < coord.z) ? 0.2 : 1.0; 
}

float getShadowValue(in sampler2D shadowTexture, in vec4 shadowCoord){
	vec3 shadowPersp = shadowCoord.xyz / shadowCoord.w;
	float sum = 0.0;
	for(float offsetY = -0.5; offsetY <= 0.5; offsetY += 1.0) {
		for(float offsetX = -0.5; offsetX <= 0.5; offsetX += 1.0) {
			sum += getSingleShadowSample(shadowTexture, shadowPersp, vec2(offsetX, offsetY));
		}
	}
	return sum*0.25;
}

void calcLighting(in vec3 esNormal, out vec4 ambient, out vec4 diffuse, out vec4 specular){
	ambient = vec4(0.0);
	diffuse = vec4(0.0);
	specular = vec4(0.0);
	
	vec3 esPos = eyeSpacePosition.xyz / eyeSpacePosition.w;
	
	for(int i = 0; i < sg_lightCount; i++) {
		addGlLight(i, esPos, esNormal, sg_useMaterials, ambient, diffuse, specular);
	}
	
	ambient.a = diffuse.a = specular.a = 1.0;
}

void main (void) {

	vec3 esNormal = eyeSpaceNormal;
	
	vec3 bumpDisortion=vec3(0.0);
	if(fakeBumpMapAmount>0.0)
	  bumpDisortion = (texture2D(fakeBumpMap, texCoord0*fakeBumpMapScale).xyz-vec3(0.5,0.5,0.5));
	esNormal=normalize(esNormal+bumpDisortion*fakeBumpMapAmount);
	 
	// Calculate the lighting
	vec4 ambient = vec4(0.0);
	vec4 diffuse = vec4(0.0);
	vec4 specular = vec4(0.0);
	calcLighting( esNormal,ambient,diffuse,specular);
	

	
	// Apply light to material
	vec4 c = vec4(0.0);
	if (!sg_useMaterials) {
		c = (ambient + diffuse + specular) * gl_Color;
	} else {
		c = ambient * gl_FrontMaterial.ambient + diffuse * gl_FrontMaterial.diffuse + specular * gl_FrontMaterial.specular;
	}
	
	// Add textures 
	vec4 t=vec4(1.0);
	if(sg_textureEnabled[0]) {
		t = texture2D(sg_texture0, texCoord0);
	}
	
	// add environment map
	if(envMappingStrength>0.0) {
		c = c* mix( t,vec4( texture2D(envMap, envMapCoord+ bumpDisortion.xy* envMappingBumpStrength ).rgb, 0.0), envMappingStrength);
	
	}else
		c*=t;
	
	// todo: alpha!!!
	
	// Add shadow 
	if(sg_shadowEnabled) {
		c *=getShadowValue(sg_shadowTexture,shadowCoord);
	}
	
	// Add color
	if(color.a > 0.0) {
		c = clamp(c, 0.0, 1.0);
		c = (c * c.a + color * color.a) / (c.a + color.a);
	}
	
	gl_FragColor = c;
}
