#version 120

uniform sampler2D lightmap;
uniform float viewHeight;
uniform float viewWidth;

uniform float far;

uniform sampler2D depthtex0;

in vec4 blockColor;
in vec2 coord0;
in vec2 coord1;
varying vec3 worldPos;

#define DHTWEAK;

#include "/lib/fog.glsl"

void main() {
    vec4 albedo = blockColor * texture2D(lightmap, coord1);

    float transparency = albedo.a;
    if (transparency < 0.001) discard;

    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float depth = texture2D(depthtex0, texCoord).r;
    if (depth < 1.0) discard;

    if (length(worldPos) < (far * 0.75)) discard;

    albedo = applyFog(albedo, worldPos);

    gl_FragData[0] = albedo;
    // gl_FragData[0] = vec4(vec3(cyl), 1);
}