uniform vec3 cameraPosition;

vec4 dirLightValues = vec4(
  0.6, // east-west
  0.8, // north-south
  1.0, // top
  0.5  // bottom
);

vec4 applyOldLighting(vec4 albedo, vec3 worldPos, vec3 normal) {
  vec4 newAlbedo = albedo;

  #ifdef DHTWEAK
  float worldY = worldPos.y + cameraPosition.y;

  if (worldY > (heightLimit + 192) && worldY < (heightLimit + 240)) {
    // old lighting values for clouds
    // which are different, for some reason
    dirLightValues = vec4(0.8, 0.9, 1.0, 0.7);
	}
  #endif

  float ew = normal.x * normal.x * dirLightValues[0];
  float ns = normal.z * normal.z * dirLightValues[1];
  float tb = dirLightValues[2];
  if (normal.y < 0) tb = dirLightValues[3];
  tb = normal.y * normal.y * tb;
  float lightIntensity = min(ew + ns + tb, 1.0);

  newAlbedo.rgb = newAlbedo.rgb * lightIntensity;

  return newAlbedo;
}