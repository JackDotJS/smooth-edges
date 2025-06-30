#version 120

// Model * view matrix and its inverse
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

// Declare viewWidth and viewHeight as uniform
uniform float viewWidth;  
uniform float viewHeight;

uniform int heightLimit;

out vec4 blockColor;
out vec2 coord0;
out vec2 coord1;
varying vec3 worldPos;

#define DHTWEAK;

#include "/bsl_lib/util/jitter.glsl"
#include "/lib/oldLighting.glsl"

void main(){
    // Calculate world space position
    worldPos = (gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex).xyz;

    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(worldPos, 1.0);

    // Calculate view space normal
    vec3 normal = normalize(gl_NormalMatrix * gl_Normal);
    normal = (gbufferModelViewInverse * vec4(normal, 0.0)).xyz;

    blockColor = applyOldLighting(gl_Color, worldPos, normal);

    coord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	coord1 = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    gl_Position.xy = TAAJitter(gl_Position.xy, gl_Position.w);
}