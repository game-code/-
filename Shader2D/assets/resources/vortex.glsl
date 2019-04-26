#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D texturediffuse;
uniform sampler2D texturenormal;
uniform sampler2D textureemissive;

varying vec2 v_texCoord;
varying vec4 v_fragmentColor;

//   _Center ("Center Point", vector) = (0.5, 0.5, 0, 0)
//   _Radius ("Twirl Radius", Range(0,256)) = 0.5
//  _Angle  ("Vortex Angel", Range(-45, 45)) = 45.0
vec4 _Center = vec4(0.5, 0.5, 0, 0);
float _Radius = 0.2;
float _Angle = 45.0;

const float PI = 3.14159265;
 
const float uD = 80.0; //旋转角度
const float uR = 0.5; //旋转半径

void main(void)
{
    //旋涡效果 原理: 旋转纹理UV坐标。相比Twirl，离中心越远，旋转角度越大。
    float radius = floor(max(resolution.x, resolution.y) / 2.);
    vec2 center = vec2((resolution.x+1.)/2., (resolution.y+1.)/2.);
    vec2 offset = vec2(v_texCoord.x * resolution.x - center.x, v_texCoord.y * resolution.y - center.y);
    float dist = sqrt(offset.x * offset.x + offset.y * offset.y);
    float a = atan(offset.x, offset.y); // 本来的弧度
    a += dist / _Angle; // 距离越远，旋转越多
    vec2 outuv = center + vec2(dist*cos(a), dist*sin(a));
    outuv.x /= resolution.x;
    outuv.y /= resolution.y;
    gl_FragColor = texture2D(CC_Texture0, outuv);
}
