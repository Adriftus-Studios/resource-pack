#version 440

#define BOTTOM_Y -1

#define TOOLTIP_Z_MIN -0.4
#define TOOLTIP_Z_MAX -0.399

in vec3 Position;
in vec4 Color;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 vertexColor;
out float dis;
out vec4 position;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    // Based on the work by:
    // Credit: lolgeny
    // Link: https://github.com/lolgeny/item-tooltip-remover
    position = gl_Position;
    dis = 0.0;
    if (
        ( (position.y > 2 || position.y < -2) || position.x < -2) &&
        position.z > TOOLTIP_Z_MIN && position.z < TOOLTIP_Z_MAX) dis = 100000000.0;

    vertexColor = Color;

}
