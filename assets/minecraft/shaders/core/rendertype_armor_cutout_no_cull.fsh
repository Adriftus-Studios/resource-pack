#version 330

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec4 normal;
in vec4 ColorCode;

out vec4 fragColor;

const float oneTexel = 1./128;
const float encoded = 1./512;
const float yRatio = 16;


void main() {

    vec4 UVshift = texture(Sampler0, vec2(encoded));
    
    vec2 uv = texCoord0;
    vec4 color;
    float frame = 0.;
    if (UVshift.b > 0.001 && UVshift.b < 0.015) {
      if (ColorCode.b > 0.991 && ColorCode.b < 0.995) {
        frame = round(ColorCode.r * 255);
      }
      uv = vec2(texCoord0.x, (oneTexel * (yRatio * frame)) + ((texCoord0.y * yRatio) * oneTexel));
      if (ColorCode.b > 0.991 && ColorCode.b < 0.995) {
          color = texture(Sampler0, uv);
        }
        else {
          color = texture(Sampler0, uv) * vertexColor * ColorModulator;
        }
    }
    else {
      color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    }

    if (color.a < 0.1) {
        discard;
    }
    
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
