#version 120

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
// If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.

#ifdef GLSLANG
#extension GL_GOOGLE_include_directive : enable
#endif

// Get Entity id.
attribute float mc_Entity;

// Model * view matrix and its inverse.
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

// Pass vertex information to fragment shader.
varying vec2 coord0;
varying vec2 coord1;
varying vec3 worldPos;

uniform int frameCounter;
uniform float viewWidth, viewHeight;

#include "/bsl_lib/util/jitter.glsl"

void main() {
    // Calculate world space position.
    worldPos = (gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex).xyz;

    // Output position and fog to fragment shader.
    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(worldPos, 1.0);

    // Output diffuse and lightmap texture coordinates to fragment shader.
    coord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    coord1 = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    
    // Apply temporal anti-aliasing jitter.
    gl_Position.xy = TAAJitter(gl_Position.xy, gl_Position.w);
}