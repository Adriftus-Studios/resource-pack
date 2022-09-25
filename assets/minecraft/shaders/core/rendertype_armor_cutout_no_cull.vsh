#version 330 core

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 normal;
out vec2 uv;
out vec2 emissiveUV;
out vec2 overlayUV;
out vec4 lightColor;

const vec2 oneTexel = vec2(1./128, 1./4096);
const float encoded = 1./16384;
const float yRatio = 16;
const float xRatio = 16;
const float yOffsetRatio = 32;
const float xOffsetRatio = 32;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vec4 UVshift = texture(Sampler0, vec2(encoded));
    float frame = 0.;
    uv = UV0;
    vec4 NewColor = Color;
    emissiveUV = vec2(0, 0);
    overlayUV = vec2(0, 0);
    float xFinal = 0.;
    float yFinal = 0.;

    if (UVshift.b > 0.001 && UVshift.b < 0.015) {
        if (Color.b > 0.668) {
          frame = round(Color.r * 255);

          if (frame > 6) {
            NewColor = vec4(1.0, 1.0, 1.0, 1.0);
          }
          else {
            NewColor = vec4(0.627, 0.396, 0.25, 1.0);
          }

          if (Color.g > 0.5) {
            xFinal = xRatio;
            yFinal = yRatio;
          }
          else {
            xFinal = xRatio * 2;
            yFinal = yRatio * 2;
          }
        }
        else {
          xFinal = xRatio;
          yFinal = yRatio;
        }

        uv = vec2((UV0.x * xFinal) * oneTexel.x, (oneTexel.y * (yOffsetRatio * frame)) + ((UV0.y * yFinal) * oneTexel.y));
        emissiveUV = vec2((oneTexel.x * xOffsetRatio) + ((UV0.x * xFinal) * oneTexel.x), uv.y);
        overlayUV = vec2((oneTexel.x * (xOffsetRatio * 2)) + ((UV0.x * xFinal) * oneTexel.x), uv.y);
    }
    
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, NewColor) * texelFetch(Sampler2, UV2 / 16, 0);
    lightColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(1.0, 1.0, 1.0, 1.0)) * texelFetch(Sampler2, UV2 / 16, 0);


    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
