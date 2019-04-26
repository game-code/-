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

//  _MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
//         _Color("Color", Color) = (1,1,1,1)
//         _Angle("angle", Range(0, 360)) = 75
//         _Width("width", Range(0, 1)) = 0.2
//         _FlashTime("flash time", Range(0, 100)) = 1
//         _DelayTime("delay time", Range(0, 100)) = 0.2
//         _LoopInterval("interval time", Range(0, 100)) = 2
vec4 _Color = vec4(0,0.8,0.5,1);
float _Angle = -75.;
float _Width = 0.3;
float _FlashTime = 0.4;
float _DelayTime = 0.2;
float _LoopInterval = 1.;

// @计算亮度
// @param uv 角度 宽度(x方向) 运行时间 开始时间 循环间隔
float flash(vec2 uv, float angle, float w, float runtime, float delay, float interval)
{
    float brightness = 0.;
    float radian = 0.0174444 * angle;
    float curtime = time; //当前时间
    float starttime = floor(curtime/interval) * interval; // 本次flash开始时间
    float passtime = curtime - starttime;//本次flash流逝时间
    if (passtime > delay)
    {
        float projx = uv.y / tan(radian); // y的x投影长度
        float br = (passtime - delay) / runtime; //底部右边界
        float bl = br - w; // 底部左边界
        float posr = br + projx; // 此点所在行右边界
        float posl = bl + projx; // 此点所在行左边界
        if (uv.x > posl && uv.x < posr)
        {
            float mid = (posl + posr) * 0.5; // flash中心点
            brightness = 1. - abs(uv.x - mid)/(w*0.5);
        }
    }
    return brightness;
}

void main(void)
{
    //闪光特效 原理: 叠加平行四边形亮光带，随时间运动划过图片，就像一束光带飘过 
    vec4 col = texture2D(texturediffuse, v_texCoord);
    float bright = flash(v_texCoord, _Angle, _Width, _FlashTime, _DelayTime, _LoopInterval);
    vec4 outcol = col + _Color*bright * col.a;// * step(0.5, col.a);
    gl_FragColor = outcol;
}
