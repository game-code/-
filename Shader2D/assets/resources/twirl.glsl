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
//   _Angle  ("Twirl Angel", Range(-90, 90)) = 90.0
vec4 _Center = vec4(0.5, 0.5, 0, 0);
float _Radius = 0.2;
float _Angle = 30.0;

const float PI = 3.14159265;
 
const float uD = 80.0; //旋转角度
const float uR = 0.5; //旋转半径

void main(void)
{
    //旋转效果 原理: 旋转纹理UV坐标，越靠近中心旋转角度越大，越往外越小
    // vec2 offset = v_texCoord - _Center.xy;
    // vec2 coord = vec2(offset.x * resolution.x, offset.y * resolution.y);
    // float dist2 = coord.x * coord.x + coord.y * coord.y;
    // float radius2 = _Radius * _Radius;
    
    // vec2 outuv;
    // if (dist2 > radius2)
    // {
    //     outuv = v_texCoord;
    // }
    // else
    // {
    //     float dist = sqrt(dist2);
    //     float radian = _Angle * 3.141593 / 180.0;
    //     // 在glsl中对应的是x和y，在shader和hlsl中是y和x，atan2
    //     float a = atan(coord.x,coord.y); // 本来的弧度
    //     a += radian * (_Radius - dist) / _Radius; // 加上旋转的弧度，越靠外旋转越小
    //     outuv.x = _Center.x + dist * cos(a) / resolution.x;
    //     outuv.y = _Center.y + dist * sin(a) / resolution.y;
    // }
    // vec4 col = texture2D(CC_Texture0, outuv);
    // gl_FragColor = col;

    ivec2 ires = ivec2(512, 512);
    float Res = float(ires.s);
 
    vec2 st = v_texCoord;
    float Radius = Res * uR;
 
    vec2 xy = Res * st;
 
    vec2 dxy = xy - vec2(Res/2., Res/2.);
    float r = length(dxy);
 
    float beta = atan(dxy.y, dxy.x) + radians(uD) * 2.0 * (-(r/Radius)*(r/Radius) + 1.0);//(1.0 - r/Radius);
 
    vec2 xy1 = xy;
    if(r<=Radius)
    {
        xy1 = Res/2. + r*vec2(cos(beta), sin(beta));
    }
 
    st = xy1/Res;
 
    vec3 irgb = texture2D(CC_Texture0, st).rgb;
 
    gl_FragColor = vec4( irgb, 1.0 );
}
