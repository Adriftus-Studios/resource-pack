#version 400

bool isScoreboard(vec4 a) {
    return (a.r >= 0.95 && a.r <= 9.9) && (a.g >= 0.31 && a.g <= 0.34) && (a.b >= 0.31 && a.b <= 3.4 ) && a.a == 1.0;
}

bool is100(vec4 a) {
    return (a.r > 0.0 && a.r < 0.005) && a.g == 0.0 && a.b == 0.0;
}

bool is001(vec4 a) {
    return (a.b > 0.0 && a.b < 0.005) && a.r == 0.0 && a.g == 0.0;
}

bool is010(vec4 a) {
    return (a.g > 0.0 && a.g < 0.005) && a.r == 0.0 && a.b == 0.0;
}

bool is200(vec4 a) {
    return (a.r < 0.01 && a.r > 0.005) && a.g == 0.0 && a.b == 0.0;
}

bool is020(vec4 a) {
    return (a.g < 0.01 && a.g > 0.005) && a.r == 0.0 && a.b == 0.0;
}

bool is002(vec4 a) {
    return (a.b < 0.01 && a.b > 0.005) && a.r == 0.0 && a.g == 0.0;
}

bool is003(vec4 a) {
    return (a.b < 0.013 && a.b > 0.01 && a.r == 0.0 && a.g == 0.0);
}

bool is300(vec4 a) {
    return (a.r < 0.013 && a.r > 0.01 && a.b == 0.0 && a.g == 0.0);
}

bool is030(vec4 a) {
    return (a.g < 0.013 && a.g > 0.01 && a.b == 0.0 && a.r == 0.0);
}

bool is004(vec4 a) {
    return (a.b < 0.016 && a.b > 0.014 && a.r == 0.0 && a.g == 0.0);
}

bool is400(vec4 a) {
    return (a.r < 0.016 && a.r > 0.014 && a.b == 0.0 && a.g == 0.0);
}

bool is040(vec4 a) {
    return (a.g < 0.016 && a.g > 0.014 && a.b == 0.0 && a.r == 0.0);
}

bool is240240240(vec4 a) {
    return (a.g > 0.93 && a.g < 0.931) && (a.r > 0.93 && a.r < 0.931) && (a.b > 0.93 && a.b < 0.931);
}

// Courtesy of Onnowhere
// (https://github.com/onnowhere)
bool isGUI(mat4 ProjMat) {
    return ProjMat[3][2] == -2.0;
}
