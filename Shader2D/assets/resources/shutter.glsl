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

//  texturediffuse ("Old Texture", 2D) = "white" {}
//         _NewTex ("New Texture", 2D) = "white" {}
//         _TexSize ("Texture Size", vector) = (256, 256, 0, 0)
//         _FenceWidth ("Fence Width", Range(10, 50)) = 30.0
//         _AnimTime("Animation Time", Range(0.01, 5)) = 1
//         _DelayTime("delay time", Range(0, 10)) = 0.2
//         _LoopInterval("Interval time", Range(1, 10)) = 2
float _FenceWidth = 30.;
float _AnimTime = 1.2;
float _DelayTime = 0.3;
float _LoopInterval = 2.;

void main(void)
{
    //百叶窗 原理: 划定窗页宽度，2张纹理间隔采样 
    vec4 col;
    float curtime = time; //当前时间
    float looptimes = floor(curtime / _LoopInterval);
    
    float starttime = looptimes * _LoopInterval; // 本次动画开始时间
    float passtime = curtime - starttime;//本次动画流逝时间
    if (passtime <= _DelayTime)
    {
        if (mod(looptimes, 2.) == 0.)
            col = texture2D(texturediffuse, v_texCoord);
        else
            col = texture2D(texturenormal, v_texCoord);
    }
    
    float progress = (passtime - _DelayTime) / _AnimTime; //底部右边界
    float fence_rate = mod(v_texCoord.x * resolution.x, _FenceWidth) / _FenceWidth;
    if (progress < fence_rate)
        col = texture2D(texturediffuse, v_texCoord);
    else
        col = texture2D(texturenormal, v_texCoord);
    gl_FragColor = col;
}
