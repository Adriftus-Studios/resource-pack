#version 330

#moj_import <fog.glsl>
#moj_import <identifiers.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;
uniform vec2 ScreenSize;
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 ColorCode;

// Constant for bouncy text
const float BouncyArray[4] = float[4]( 0, 1, 0, -1 );
const float SignBouncyArray[4] = float[4](0, 0.01, 0, -0.01);

void main() {
    
    //Vanilla Code
    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    ColorCode = Color;

    // Check for Color Codes
    if (is010(vertexColor) || is001(vertexColor)) {

        if (gl_Position.z > -10 && gl_Position.z < 9) {

          float ticker = mod((GameTime * 10000), 4) + (mod((Position.x * 10), 4));
          float final;
          if (ticker > 3) {
              final = mod(ticker, 4);
          }
          else {
              final = ticker;
        }
          gl_Position = ProjMat * ModelViewMat * vec4(Position.x, (Position.y + SignBouncyArray[int(final)]), Position.z, 1.0);
        }
        else {

          float ticker = mod((GameTime * 10000), 4) + (mod((Position.x), 512) / 64);
          float final;
          if (ticker > 3) {
              final = mod(ticker, 4);
          }
          else {
              final = ticker;
          }
          gl_Position = ProjMat * ModelViewMat * vec4(Position.x, (Position.y + BouncyArray[int(final)]), Position.z, 1.0);
        }
        
    }
    else if (is030(ColorCode)) {
        gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y, Position.z + 0.11, 1.0);
    }
    else {
        // Vanilla Code
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    }
    
    
}
