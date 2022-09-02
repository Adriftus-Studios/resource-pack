#version 330

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
in vec4 ColorCode;

out vec4 fragColor;

const float oneTexel = 1./256;

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
    vec4 encoded = texture(Sampler0, vec2(oneTexel));
    if ((encoded.r == 1 && encoded.g == 1 && encoded.b == 1) && (vertexColor.r != 0 && vertexColor.g != 0 && vertexColor.b != 0 && vertexColor.r <= 0.248 && vertexColor.g <= 0.248 && vertexColor.b <= 0.248)) discard;

    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    vec4 UVcolor = texture(Sampler0, texCoord0);

    if (color.a < 0.1) discard;

    if (is300(ColorCode) || is030(ColorCode)) {
        float final = mod((GameTime * 100000), 256);
        float final1 = mod((gl_FragCoord.x * 1000), 256);
        color = texture(Sampler0, vec2(texCoord0.x + (oneTexel * final), texCoord0.y));
    }
    

    if (is200(ColorCode) || is020(ColorCode) || is002(ColorCode)){
        float final;
        
        if (is020(ColorCode)) {
          float final1 = mod((GameTime * 100000), 51);

          if (final1 > 25) {
              final = (50 - final1) * 4;
          }
          else {
              final = final1 * 4;
          }
              color = mix(vec4(0.8, 0.0, 0, 1.0), vec4(0.5, 0.0, 0, 0.9), final/100);

        }

        else if (is002(ColorCode)) {
                if (UVcolor.r < 0.1 && UVcolor.g > 0.33 && UVcolor.g < 0.35 && UVcolor.b > 0.79 && UVcolor.b < 0.81) {
                  color = vec4(UVcolor.rgb, final/100);
                }
                else {
                    color = UVcolor;
                }
        }
        else {
          float final1 = mod((GameTime * 10000), 51);

          if (final1 > 25) {
              final = (50 - final1) * 4;
          }
          else {
              final = final1 * 4;
          }
              color = vec4(1.0, 1.0, 1.0, final/100);
        }
    }

    if (is003(ColorCode)) {
        if ((UVcolor.b > 0.019) && (UVcolor.b < 0.024) && (UVcolor.r == 0) && (UVcolor.g == 0)) {

            float final;
            float final1;
            vec4 UVup = texture(Sampler0, vec2(texCoord0.x + oneTexel, texCoord0.y));

            if ((UVcolor.b > 0.019) && (UVcolor.b < 0.022)) {
              final1 = mod((GameTime * 10000), 17);
            }
            else {
              final1 = mod((GameTime * 10020), 17);
            }

            if (final1 > 8) {
                final =  (8 - (final1 - 8)) * 10;
            }
            else {
                final = final1 * 10;
            }
            
            color = mix(UVup, vec4(1.0, 1.0, 1.0, 1.0), (final+20)/100);
        }
        else {
            color = UVcolor;
        }
    }


    if (is010(ColorCode)){
        color = vec4(1.0, 1.0, 1.0, 1.0);
    }
    
    if (is240240240(ColorCode)) {

        float final = mod((GameTime * 10000), 8);
        

        if (UVcolor.r < 0.1 && UVcolor.g > 0.33 && UVcolor.g < 0.35 && UVcolor.b > 0.79 && UVcolor.b < 0.81) {
            color = mix(UVcolor, vec4(RainbowArray[int(final)].rgb, 1.0), 0.8);
        }
        else {
            color = UVcolor;
        }
    }

    if (is100(ColorCode) || is001(ColorCode)) {

        float final = mod((GameTime * 10000), 8);

        color = vec4(RainbowArray[int(final)].rgb, 1.0);

    }


    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    
    if((isScoreboard(fragColor)) && ((ScreenSize.x - gl_FragCoord.x) < 32)) discard;
    
}
