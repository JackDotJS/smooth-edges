#version 120

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
// If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/

uniform sampler2D texture;

uniform int entityId;

varying vec4 fragColor;
varying vec2 texCoord0;
varying vec3 worldPos;

#include "/lib/fog.glsl"

void main() {
    vec4 color = fragColor * texture2D(texture, texCoord0);

    color = applyFog(color, worldPos);

    gl_FragData[0] = color;
}