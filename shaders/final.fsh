#version 120

uniform sampler2D colortex1;

uniform float viewWidth;
uniform float viewHeight;

varying vec4 color;
varying vec2 coord0;

/*
const int colortex0Format = R11F_G11F_B10F; //main scene
const int colortex1Format = RGB8; //raw translucent, bloom, final scene
const int colortex2Format = RGBA16; //temporal data
*/

void main()
{
    vec3 color = texture2DLod(colortex1, coord0, 0).rgb;

    gl_FragColor = vec4(color, 1.0);
}
