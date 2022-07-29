#version 440

#moj_import <fog.glsl>
#moj_import <identifiers.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec2 ScreenSize;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

// Constant for the rainbow array
const vec3 RainbowArray[8] = vec3[8](
    vec3( 1.0, 0.0, 0.0 ),
    vec3( 1.0, 0.5, 0.0 ),
    vec3( 1.0, 1.0, 0.0 ),
    vec3( 0.0, 0.5, 0.0 ),
    vec3( 0.0, 0.0, 1.0 ),
    vec3( 0.25, 0.0, 0.5 ),
    vec3( 0.9, 0.5, 0.9 ),
    vec3( 1.0, 1.0, 1.0 )
    );

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    
    vec4 UVcolor = texture(Sampler0, texCoord0);

    if (is200(vertexColor) || is020(vertexColor) || is002(vertexColor)){
        float final;
        float final1 = mod((GameTime * 10000), 51);

        if (final1 > 25) {
            final = (50 - final1) * 4;
        }
        else {
            final = final1 * 4;
        }
        if (is020(vertexColor)) {
            color = mix(vec4(1, 0.6, 0, 1.0), vec4(0.8, 0.8, 0, 0.9), final/100);
        }
        else if (is002(vertexColor)) {
                if (UVcolor.r < 0.1 && UVcolor.g > 0.33 && UVcolor.g < 0.35 && UVcolor.b > 0.79 && UVcolor.b < 0.81) {
                  color = vec4(UVcolor.rgb, final/100);
                }
                else {
                    color = UVcolor;
                }
        }
        else {
            color = vec4(1.0, 1.0, 1.0, final/100);
        }
    }


    if (is010(vertexColor)){
        color = vec4(1.0, 1.0, 1.0, 1.0);
    }
    
    if (is240240240(vertexColor)) {

        float final = mod((GameTime * 10000), 8);
        

        if (UVcolor.r < 0.1 && UVcolor.g > 0.33 && UVcolor.g < 0.35 && UVcolor.b > 0.79 && UVcolor.b < 0.81) {
            color = mix(UVcolor, vec4(RainbowArray[int(final)].rgb, 1.0), 0.8);
        }
        else {
            color = UVcolor;
        }
    }

    if (is100(vertexColor) || is001(vertexColor)) {

        float final = mod((GameTime * 10000), 8);

        color = vec4(RainbowArray[int(final)].rgb, 1.0);

    }

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    
    if((isScoreboard(fragColor)) && ((ScreenSize.x - gl_FragCoord.x) < 32)) discard;
    
}
