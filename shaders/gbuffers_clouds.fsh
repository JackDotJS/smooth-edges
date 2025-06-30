#version 120

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.

uniform sampler2D texture;

varying vec4 color;
varying vec2 coord0;
varying vec3 worldPos;

#include "/lib/fog.glsl"

void main()
{
    #ifndef DISTANT_HORIZONS

    vec4 col = color * texture2D(texture, coord0);

    col = applyFog(col, worldPos);

    gl_FragData[0] = col;

    #else
    discard;
    #endif
}