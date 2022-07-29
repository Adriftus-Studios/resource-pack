#version 440 core

in vec3 Position;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;
out float dis;
out vec4 position;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    texCoord0 = UV0;
    position = gl_Position;
    dis = 0.0;
    if (position.z < -0.75) dis = 1000.0;
} 
