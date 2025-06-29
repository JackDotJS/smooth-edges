#version 120

uniform sampler2D lightmap;
uniform float viewHeight;
uniform float viewWidth;

uniform vec3 fogColor;
uniform float fogStart;
uniform float fogEnd;

uniform vec3 skyColor;

uniform int dhRenderDistance;

uniform int isEyeInWater;

uniform sampler2D depthtex0;

in vec4 blockColor;
in vec2 coord0;
in vec2 coord1;
in vec4 pos;

void main() {
    vec4 albedo = blockColor * texture2D(lightmap, coord1);

    float transparency = albedo.a;
    if (transparency < 0.001) discard;

    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float depth = texture(depthtex0, texCoord).r;

    if (depth < 1.0) {
        discard;
    }

    vec3 finalFogColor;
    float fogFactor;

    // for some reason gl_FogFragCoord doesn't work
    // in dh_* programs so we have to do this calculation
    float worldFragCoord = ((pos.x * pos.x) + (pos.y * pos.y) + (pos.z * pos.z));

    if (isEyeInWater == 0) {
        fogFactor = smoothstep(0, dhRenderDistance * 4096, worldFragCoord);
        finalFogColor = mix(fogColor, skyColor, 0.2);
    } else {
        fogFactor = smoothstep(fogStart, fogEnd, worldFragCoord);
        finalFogColor = fogColor;
    }

    albedo.rgb = mix(albedo.rgb, finalFogColor, fogFactor);

    gl_FragData[0] = albedo;
}