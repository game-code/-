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

//     _InnerRadius ("内圈半径", Range(0, 512)) = 256
//     _OutterRadius ("外圈半径", Range(0, 512)) = 384
//     _Center ("中心", vector) = (0.5, 1, 0, 0)
//     _StartAngle ("初始角度", Range(0, 180)) = 0
//     _SpreadAngle ("扩散角度", Range(0, 360)) = 180
float _InnerRadius = 256.;
float _OutterRadius = 384.;
vec2 _Center = vec2(0.5,1);
float _StartAngle = 0.;
float _SpreadAngle = 180.;

void main(void)
{
    //扇形映射 原理: 采样图片上的点，映射到一个扇形区域中

    float dx = (v_texCoord.x - _Center.x) * resolution.x;
    float dy = (v_texCoord.y - _Center.y) * resolution.y;
    float distance = sqrt(dx * dx + dy * dy);
     
    float radian = _StartAngle * 3.1415926535 / 180.0;
    float theta = atan(dx , dy) + radian;
    theta = mod(theta, 6.283185307);
    
    radian = _SpreadAngle * 3.141593 / 180.0;
    float x = 1. - theta / (radian + 0.00001);// 加0.00001防止除数为0
    float y = (distance - _InnerRadius)/(_OutterRadius - _InnerRadius + 0.00001);
    vec2 uv = vec2(x, y);
    vec4 col = texture2D(CC_Texture0, uv);
    //if (distance > _OutterRadius || distance < _InnerRadius)
    //    col.a = 0;
    float cmp = step(distance, _OutterRadius) * step(_InnerRadius, distance);
    col.a *= cmp;
    gl_FragColor = col;
}
