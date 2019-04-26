#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D texturediffuse;
// uniform sampler2D texturenormal;
// uniform sampler2D textureemissive;

varying vec2 v_texCoord;
varying vec4 v_fragmentColor;

// _MainTex ("Albedo (RGB)", 2D) = "white" {}
// 	_Amplitude ("振幅", Range(0, 1)) = 0.3     
//     _AngularVelocity ("角速度(圈数)", Range(0, 50)) = 10     
//     _Speed ("移动速度", Range(0, 30)) = 10  
float _AngularVelocity = 30.;
float _Amplitude = 0.01;
float _Speed = 3.0;

void main(void)
{
    //波浪效果 原理: 让顶点的Y轴按正弦或余弦变化
    vec2 uv = v_texCoord;
    uv.y += _Amplitude * sin(_AngularVelocity * uv.x + _Speed * time);
    vec4 col = texture2D(texturediffuse, uv);
    gl_FragColor = col;
}
