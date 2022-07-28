#version 150

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec2 texCoord0;
in float dis;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a == 0.0) {
        discard;
    }

    // There's gotta be a better way....
    if (dis > 0.0 && 
      ( 
        (color.b > 0.52 && color.b < 0.522)
        || 
        (color.b > 0.29 && color.b < 0.30)
        ||
        (color.r < 0.01 && color.g < 0.01 && color.b < 0.01) 
        ||
        (color.r == 1 && color.g == 1 && color.b == 1)
        ||
        (color.r > 0.79 && color.r < 0.8 && color.b < 0.6 && color.g > 0.71 && color.g < 0.72)
        ||
        (color.r > 0.36 && color.r < 0.37 && color.g > 0.36 && color.g < 0.37 && color.b == 0)
      ) 
    ) discard;

    fragColor = color * ColorModulator;
}
