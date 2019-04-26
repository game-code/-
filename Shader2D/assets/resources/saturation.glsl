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

//Range(-1,1)
float _SatIncrement = 0.4;

vec4 adjust()
{
    vec4 col = texture2D(texturediffuse, v_texCoord);
    float rgbmax = max(col.r, max(col.g, col.b));
    float rgbmin = min(col.r, min(col.g, col.b));
    float delta = rgbmax - rgbmin;
    if (delta == 0.)
        return col;
    
    float value = (rgbmax + rgbmin);
    float light = value / 2.;
    float cmp = step(light, 0.5);
    float sat = mix(delta/(2.-value), delta/value, cmp);
    if (_SatIncrement >= 0.)
    {
        cmp = step(1., _SatIncrement + sat);
        float a = mix(1.-_SatIncrement, sat, cmp);
        a = 1./a - 1.;
        col.r = col.r + (col.r - light) * a;
        col.g = col.g + (col.g - light) * a;
        col.b = col.b + (col.b - light) * a;
    }
    else
    {
        float a = _SatIncrement;
        col.r = light + (col.r - light) * (1.+a);
        col.g = light + (col.g - light) * (1.+a);
        col.b = light + (col.b - light) * (1.+a);
    }
    return col;
}

void main(void)
{
    //调整饱和度 原理: RGB转HSL，增加S再转回RGB 
    vec4 outCol = adjust();
    gl_FragColor = outCol;
}
