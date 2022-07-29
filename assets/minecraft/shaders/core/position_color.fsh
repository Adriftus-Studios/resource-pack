#version 440

in vec4 vertexColor;
in vec4 position;
in float dis;

uniform vec4 ColorModulator;
uniform float GameTime;

out vec4 fragColor;

const vec3 TooltipRainbowArray[8] = vec3[8](
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
    vec4 color = vertexColor;
    if (color.a == 0.0) {
        discard;
    }

    if (dis > 100.0) discard;

    if (dis > 1.0 && color.r > 0.62 && color.r < 0.63 && color.g > 0.62 && color.g < 0.63 && color.b > 0.62 && color.b < 0.63) discard; 

    // sidebar background
    if (((color.a >= 0.29 && color.a < 0.3 ) || ( color.a > 0.39 && color.a <= 0.40)) && (color.r < 0.1)) discard;

    fragColor = color * ColorModulator;
}
