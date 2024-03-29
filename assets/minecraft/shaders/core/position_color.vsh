#version 330

in vec3 Position;
in vec4 Color;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 vertexColor;
out float dis;
out vec4 position;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    position = gl_Position;

    // Based on the work by: lolgeny
    // Link: https://github.com/lolgeny/item-tooltip-remover
    dis = 0.0;
    
    if (position.x < -0.95 && position.x > -1) dis = 100.0;
    if (position.x > 0.7 && position.x < 1) dis = 100.0;
    if (position.y > 2 || position.x < -2 && (position.z > -0.4 && position.z < -0.399) ) dis = 100000000.0;
    

    vertexColor = Color;

}
