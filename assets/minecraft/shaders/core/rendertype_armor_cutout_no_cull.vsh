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

const vec2 oneTexel = vec2(1./32, 1./256);
const float encoded = 1./1024;
const float yRatio = 16;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vec4 UVshift = texture(Sampler0, vec2(encoded));
    float frame = 0.;
    uv = UV0;
    vec4 NewColor = Color;
    emissiveUV = vec2(0, 0);

    if (UVshift.b > 0.001 && UVshift.b < 0.015) {
        if (Color.b > 0.991 && Color.b < 0.995) {
          gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y, Position.z + 0.15, 1.0);
          frame = round(Color.r * 255);
          NewColor = vec4(1.0, 1.0, 1.0, 1.0);
        }
        uv = vec2((UV0.x * 16) * oneTexel.x, (oneTexel.y * (yRatio * frame)) + ((UV0.y * yRatio) * oneTexel.y));
        emissiveUV = vec2((oneTexel.x * 16.) + ((UV0.x * 16.) * oneTexel.x), uv.y);
    }

    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, NewColor) * texelFetch(Sampler2, UV2 / 16, 0);


    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
