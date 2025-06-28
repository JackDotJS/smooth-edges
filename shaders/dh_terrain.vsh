#version 120

// Model * view matrix and its inverse
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

// Declare viewWidth and viewHeight as uniform
uniform float viewWidth;  
uniform float viewHeight;

uniform int heightLimit;
uniform vec3 cameraPosition;

out vec4 blockColor;
out vec2 coord0;
out vec2 coord1;

#include "/bsl_lib/util/jitter.glsl"

void main(){
    // Calculate world space position
    vec4 worldPos = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;

    // Output position and fog to fragment shader
    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(worldPos.xyz, 1.0);

    float worldY = worldPos.y + cameraPosition.y;

    // Calculate view space normal
    vec3 normal = normalize(gl_NormalMatrix * gl_Normal);
    normal = (gbufferModelViewInverse * vec4(normal, 0.0)).xyz;

    // old lighting values
    // we're recreating old lighting from scratch here because 
    // oldLighting=true in shader.properties has no effect on DH geometry
    vec4 dirLightValues = vec4(
        0.6, // east-west
        0.8, // north-south
        1.0, // top
        0.5  // bottom
    );

    if (worldY > (heightLimit + 192) && worldY < (heightLimit + 240)) {
        // old lighting values for clouds
        // which use different values, for some reason
        dirLightValues = vec4(0.8, 0.9, 1.0, 0.7);
	}

    // apply old lighting
    float ew = normal.x * normal.x * dirLightValues[0];
    float ns = normal.z * normal.z * dirLightValues[1];
    float tb = dirLightValues[2];
    if (normal.y < 0) tb = dirLightValues[3];
    tb = normal.y * normal.y * tb;
    float lightIntensity = min(ew + ns + tb, 1.0);

    blockColor = vec4(gl_Color.rgb * lightIntensity, gl_Color.a);

    coord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	coord1 = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    gl_Position.xy = TAAJitter(gl_Position.xy, gl_Position.w);
}