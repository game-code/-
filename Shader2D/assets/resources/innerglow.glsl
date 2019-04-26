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

//_Color("Color", Color) = (1,1,1,1)
vec4 _Color = vec4(0.0,0,1,1);
// /Range(0, 10)
float _Factor = 5.;
 //_SampleInterval("Sample Interval", vector) = (1,1,0,0)
vec2 _SampleInterval = vec2(1.0);
//Range(0, 10)
float _SampleRange = 7.;
const int range = 7;

void main(void)
{
    //内发光 原理: 采样周边像素alpha取平均值，叠加发光效果
    float radiusX = _SampleInterval.x / resolution.x;
    float radiusY = _SampleInterval.y / resolution.y;
    float inner = 0.;
    float outter = 0.;
    float count = 0.;
    //[unroll(15)]
    for (int k = -range; k <= range; ++k)
    {
        for (int j = -range; j <= range; ++j)
        {
            vec4 m = texture2D(CC_Texture0, vec2(v_texCoord.x + float(k)*radiusX , v_texCoord.y + float(j)*radiusY));
            outter += 1. - m.a;
            inner += m.a;
            count += 1.;
        }
    }
    inner /= count;
    outter /= count;
    
    vec4 col = texture2D(CC_Texture0, v_texCoord);
    float out_alpha = max(col.a, inner);
    float in_alpha = min(out_alpha, outter);
    //col.rgb = _OutColor.rgb * _OutColor.a*(1-col.a) + _InnerColor.rgb*col.a*_InnerColor.a;
    //col.a = in_alpha;
    col.rgb = col.rgb + in_alpha * _Factor * _Color.a * _Color.rgb;
    gl_FragColor = col;
}
