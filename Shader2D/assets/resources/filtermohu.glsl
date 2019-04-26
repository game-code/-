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

void main(void)
{
    // box模糊 原理: 采样周边8个相邻像素的颜色，与当前像素颜色按平均比例混合（Box滤波器）
    // box滤波矩阵
    mat3 boxFilter = 
    mat3(vec3(1.0/9., 1.0/9., 1.0/9.), 
         vec3(1.0/9., 1.0/9., 1.0/9.), 
         vec3(1.0/9., 1.0/9., 1.0/9.));

    //高斯模糊 原理: 采样周边8个相邻像素的颜色，与当前像素颜色按比例混合（高斯滤波器）
    // 高斯滤波矩阵
    mat3 gaussFilter = 
    mat3(vec3(1.0/16., 2.0/16., 1.0/16.), 
        vec3(2.0/16., 4.0/16., 2.0/16.), 
        vec3(1.0/16., 2.0/16., 1.0/16.));

    //拉普拉斯锐化 原理: 先将自身与周围的8个象素相减，表示自身与周围象素的差别，再将这个差别加上自身作为新象素的颜色 
    // 锐化滤波矩阵   
    mat3 laplaceFilter = 
    mat3(vec3(-1.), 
        vec3(-1., 9., -1.), 
        vec3(-1.));

    vec2 coord = vec2(v_texCoord.x * resolution.x, v_texCoord.y * resolution.y);
    vec4 outp = filter(laplaceFilter, texturediffuse, coord, resolution);
    gl_FragColor = outp;
}
