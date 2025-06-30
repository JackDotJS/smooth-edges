#version 120

uniform sampler2D lightmap;
uniform float viewHeight;
uniform float viewWidth;

uniform sampler2D depthtex0;

in vec4 blockColor;
in vec2 coord0;
in vec2 coord1;
varying vec3 worldPos;

#define DHFOGTWEAK;

#include "/lib/fog.glsl"

void main() {
    vec4 albedo = blockColor * texture2D(lightmap, coord1);

    float transparency = albedo.a;
    if (transparency < 0.001) discard;

    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float depth = texture(depthtex0, texCoord).r;

    if (depth < 1.0) {
        discard;
    }

    albedo = applyFog(albedo, worldPos);

    gl_FragData[0] = albedo;
}