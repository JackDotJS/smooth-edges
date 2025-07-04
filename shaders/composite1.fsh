#version 120

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.

#extension GL_ARB_shader_texture_lod : enable

#ifdef GLSLANG
#extension GL_GOOGLE_include_directive : enable
#endif

uniform sampler2D texture;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex1;

uniform float viewWidth, viewHeight, aspectRatio;

uniform vec3 cameraPosition, previousCameraPosition;

uniform mat4 gbufferPreviousProjection, gbufferProjectionInverse;
uniform mat4 gbufferPreviousModelView, gbufferModelViewInverse;

varying vec4 color;
varying vec2 texCoord;

#include "/bsl_lib/antialiasing/taa.glsl"

void main()
{
    vec3 sampledColor = texture2DLod(colortex1, texCoord, 0.0).rgb;
    float prevAlpha = texture2DLod(colortex2, texCoord, 0.0).a;

    vec4 prev = TemporalAA(sampledColor, prevAlpha); // Combine operations

    /*DRAWBUFFERS:12*/
    gl_FragData[0] = vec4(sampledColor, 1.0);
    gl_FragData[1] = prev; // No need to create a new vec4, use prev directly
}