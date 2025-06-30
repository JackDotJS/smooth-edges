#version 120

varying vec4 color;
varying vec3 worldPos;

#include "/lib/fog.glsl"

void main() {
    vec4 albedo = color;

    albedo = applyFog(albedo, worldPos);

    gl_FragData[0] = albedo;
}