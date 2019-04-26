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

//   _Amplitude ("振幅", Range(1, 64)) = 16
//     _WaveLength ("波长", Range(1, 256)) = 64
//     _Center ("中心", vector) = (0.5, 0.5, 0, 0)
//     _Radius ("半径", Range(1, 512)) = 128
//     _Phase ("相位", Range(0, 6.283185307)) = 0
//     _Speed ("扩散速度", Range(0, 10)) = 5
float _Amplitude = 2.;
float _WaveLength = 64.;
vec2 _Center = vec2(0.5);
float _Radius = resolution.x;
float _Phase = 0.;
float _Speed = 2.;

vec4 ripple()
{
    float dx = (v_texCoord.x - _Center.x) * resolution.x;
    float dy = (v_texCoord.y - _Center.y) * resolution.y;
    float distance2 = dx * dx + dy * dy;
    float radius2 = _Radius * _Radius;
    
    if (distance2 > radius2)
    {
        vec4 col = texture2D(CC_Texture0, v_texCoord);
        return col;
    }
    else
    {
        float distance = sqrt(distance2);
        float amount = _Amplitude * sin(distance / _WaveLength * 6.283185307 - _Phase - _Speed * time);
        amount *= (_Radius - distance) / _Radius;
        if (distance != 0.)
        {
            amount *= _WaveLength / distance;
        }
        vec2 uv = vec2(v_texCoord.x + dx * amount / resolution.x, v_texCoord.y + dy * amount / resolution.y);
        vec4 col = texture2D(CC_Texture0, uv);
        return col;
    }
}

void main(void)
{
    //水滴波动效果 原理: 正弦波，越远波长越长，振幅越小。
    vec4 outuv;
    outuv = ripple();
    gl_FragColor = outuv;
}
