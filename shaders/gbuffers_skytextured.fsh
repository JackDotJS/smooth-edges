#version 120
uniform sampler2D texture;

varying vec4 color;
varying vec2 coord0;
varying vec3 worldPos;

#define SKY

#include "/lib/fog.glsl"

void main()
{
    vec4 col = color * texture2D(texture, coord0);
    col = applyFog(col, worldPos);

    //Output the result.
    /*DRAWBUFFERS:0*/
    gl_FragData[0] = col;
}
