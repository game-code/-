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

//    _MainTex ("Base (RGB)", 2D) = "white" {}
//         _Color ("Color", Color) = (1,1,1,1)
//         _Rows ("rows", Float) = 3
//         _Cols ("cols", Float) = 4
//         _FrameCount ("frame count", Float) = 12
//         _Speed ("speed", Float) = 100
float _Rows = 4.;
float _Cols = 4.;
float _FrameCount = 12.;
float _Speed = 24.0;

void main(void)
{
    //序列帧动画 原理: 从mxn的动画图片中扣出当前帧动作图
    float index = floor(time * _Speed);
    index = floor(mod(index,_FrameCount));
    float indexY = floor(index / _Cols);
    float indexX = floor(index - indexY * _Cols);
    
    vec2 uv = vec2(v_texCoord.x /_Cols, v_texCoord.y /_Rows);
    uv.x += indexX / _Cols;
    uv.y += indexY / _Rows;
    
    vec4 col = texture2D(texturenormal, uv);
    gl_FragColor = col;
}
