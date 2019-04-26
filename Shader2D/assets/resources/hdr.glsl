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

//Range(1, 3)
float _Param = 1.2;

//对图像做滤波操作
vec4 filter(mat3 filter, sampler2D tex, vec2 coord, vec2 texSize)
{
    int _BlurOffset = 2;
    vec4 outCol = vec4(0,0,0,0);
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            //计算采样点，得到当前像素附近的像素的坐标
            vec2 newCoord = vec2(coord.x + float((i-1)*_BlurOffset), coord.y + float((j-1)*_BlurOffset));
            vec2 newUV = vec2(newCoord.x / texSize.x, newCoord.y / texSize.y);
            //采样并乘以滤波器权重，然后累加
            outCol += texture2D(tex, newUV) * filter[i][j];
        }
    }
    return outCol;
}


// 调整亮度，让亮的地方更亮  公式: y = x * [(2-4k)*x + 4k-1]
vec4 hdr(vec4 col, float gray, float k)
{
    float b = 4.*k - 1.;
    float a = 1. - b;
    float f = gray * ( a * gray + b);
    return f * col;
}

void main(void)
{
    //HDR效果 原理: 让亮的地方更亮，同时为了过渡更平滑柔和，亮度采用高斯模糊后的亮度（灰度值） 
    vec4 col = texture2D(CC_Texture0, v_texCoord);

    //高斯模糊 原理: 采样周边8个相邻像素的颜色，与当前像素颜色按比例混合（高斯滤波器）
    // 高斯滤波矩阵
    mat3 gaussFilter = 
    mat3(vec3(1.0/16., 2.0/16., 1.0/16.), 
        vec3(2.0/16., 4.0/16., 2.0/16.), 
        vec3(1.0/16., 2.0/16., 1.0/16.));
    vec2 coord = vec2(v_texCoord.x * resolution.x, v_texCoord.y * resolution.y);
    vec4 outp = filter(gaussFilter, CC_Texture0, coord, resolution);

    //vec4 blurCol = texture2D(CC_Texture0, v_texCoord);
    // 高斯模糊后的纹理，让过渡更柔和、平滑
    float gray = 0.3 * outp.r + 0.59 * outp.g + 0.11 * outp.b;
    vec4 outCol = hdr(col, gray, _Param);
    gl_FragColor = outCol;
}
