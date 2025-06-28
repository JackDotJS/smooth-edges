#version 120

uniform sampler2D lightmap;
uniform float viewHeight;
uniform float viewWidth;

uniform int isEyeInWater;
uniform vec3 fogColor;

uniform sampler2D depthtex0;

in vec4 blockColor;
in vec2 coord0;
in vec2 coord1;

void main() {
    vec4 albedo = blockColor * texture2D(lightmap, coord1);

    float transparency = albedo.a;
    if (transparency < 0.001) discard;

    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float depth = texture(depthtex0, texCoord).r;

    if (depth < 1.0) {
        discard;
    }

    // TODO: this solution *might* be crap. it doesn't take into account
    // fog distance at all, which theoretically results in a sudden sharp
    // change in colors on the border between the DH geometry and the real
    // world geometry. however, players probably dont see the world border
    // while underwater anyway, so it might not matter? needs testing
    if (isEyeInWater == 1) {
        gl_FragData[0] = vec4(fogColor, 1);
        return;
    }

    gl_FragData[0] = albedo;
}