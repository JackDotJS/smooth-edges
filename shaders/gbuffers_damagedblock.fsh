#version 120

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
// If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Diffuse (color) texture.
uniform sampler2D texture;
// Lighting from day/night + shadows + light sources.
uniform sampler2D lightmap;

// Diffuse and lightmap texture coordinates.
varying vec2 coord0;
varying vec2 coord1;
varying vec3 worldPos;

#include "/lib/fog.glsl"

void main()
{
    // Sample texture
    vec4 col = texture2D(texture, coord0);

    // Calculate and apply fog intensity.
    col = applyFog(col, worldPos);

    // Output the result.
    /*DRAWBUFFERS:0*/
    gl_FragData[0] = col;
}