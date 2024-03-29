#version 330 core

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 normal;
in vec2 uv;
in vec2 emissiveUV;
in vec2 overlayUV;
in vec4 lightColor;

out vec4 fragColor;

void main() {
    vec4 color;
    vec4 emissive = texture(Sampler0, emissiveUV);
    vec4 overlay = texture(Sampler0, overlayUV);
    
    if (emissive.a > 0.1) {
      color = texture(Sampler0, uv);
    }
    else if (overlay.a > 0.1) {
      color = overlay * lightColor * ColorModulator;
    }
    else {
      color = texture(Sampler0, uv) * vertexColor * ColorModulator;
    }

    if (color.a < 0.1) {
        discard;
    }

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
