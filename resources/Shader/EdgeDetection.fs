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
uniform sampler2D NORMAL_MAP;
uniform sampler2D DEPTH_MAP;

uniform vec2 textureSize; 

uniform float depthThreshold;
uniform float normalThreshold;

void main()
{
   vec2 texturePosition = gl_TexCoord[0].st;
   
   float sumDepthMask = 0.0;
   
   // Column-major form decoding of the depth map 3 by 3 area
   for (int y = -2; y <= 2; y++)
   {
      for (int x = -2; x <= 2; x++)
      {
         vec2 offset = vec2(float(x) / textureSize.x, float(y) / textureSize.y);
         vec4 depthColor = texture2D(DEPTH_MAP, texturePosition + offset);
         sumDepthMask += depthColor.b  * (y==0?(x==0?24.0:-1.0):-1.0);
      }
   }
   // Invert depth gradient
   float depthGradient = 1.0 - sumDepthMask;
   
   vec3 baseNormal = texture2D(NORMAL_MAP, texturePosition).xyz;
   float sumNormalMask = 0.0;
   
   // Column-major form decoding of the normal map 3 by 3 area
   for (int y = -2; y <= 2; y++)
   {
      for (int x = -2; x <= 2; x++)
      {
         vec2 offset = vec2(float(x) / textureSize.x, float(y) / textureSize.y);
         vec2 lookupPosition = texturePosition + offset;
         vec3 normal = texture2D(NORMAL_MAP, lookupPosition).xyz;
         sumNormalMask += dot(baseNormal, normal) * (y==0?(x==0?24.0:-1.0):-1.0);
      }
   }
   // Invert normal gradient
   float normalGradient = 1.0 - sumNormalMask;
   
   
   // Render gray "background" if the normal buffer has nothing to show (must be empty space)
   if (baseNormal.xyz == vec3(0,0,0))
   {
      gl_FragColor = vec4(1, 1, 1, 0);
   }
   else if (depthGradient < depthThreshold || normalGradient < normalThreshold)// 
   {
      gl_FragColor = vec4(0, 0, 0, 0);
   }
   else
   {
      //gl_FragColor = vec4(depthGradient, depthGradient, depthGradient, 0);
      //gl_FragColor = vec4(normalGradient, normalGradient, normalGradient, 0);
      gl_FragColor = vec4(1, 1, 1, 0);
   }
   //gl_FragColor = vec4(depthGradient, depthGradient, depthGradient, 0);
   //gl_FragColor = vec4(normalGradient, normalGradient, normalGradient, 0);
}