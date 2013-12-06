/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2010 Sascha Brandt
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */
//uniform sampler2D TGT_TEX;
uniform sampler2D SRC_TEX;

uniform vec2 textureSize; 

const int kernel = 2;

void main(void)
{

	vec2 texturePosition = gl_TexCoord[0].st;   
	float sum = 0.0;

	for(int y=0; y<kernel; y++) {
		for(int x=0; x<kernel; x++) {
			vec2 v = vec2(textureSize.x * texturePosition.s,textureSize.y * texturePosition.y);
			vec2 offset = vec2((float(x) -mod(v.x,float(kernel)))/ textureSize.x , (float(y)  - mod(v.y,float(kernel)))/ textureSize.y);
			vec4 color = texture2D(SRC_TEX, texturePosition + offset);
			sum += color.b;
		}
	}

	float mid = sum / float(kernel*kernel);

	//gl_FragData[0] = texture2D(SRC_TEX, texturePosition);   
	//gl_FragData[1] = vec4(mid,mid,mid,0);
	gl_FragData[0] = vec4(mid,mid,mid,0);
}