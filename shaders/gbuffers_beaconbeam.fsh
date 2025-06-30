#version 120

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
// If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/

uniform sampler2D texture;
uniform sampler2D lightmap;

uniform vec4 entityColor;

varying vec4 fragColor;
varying vec2 texCoord0;
varying vec2 texCoord1;
varying vec3 worldPos;

#include "/lib/fog.glsl"

void main() {
    vec4 color = fragColor * texture2D(lightmap, texCoord1) * texture2D(texture, texCoord0);

    color.rgb = mix(color.rgb, entityColor.rgb, entityColor.a);

    color = applyFog(color, worldPos);

    gl_FragData[0] = color;
}