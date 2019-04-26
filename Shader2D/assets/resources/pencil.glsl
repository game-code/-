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
    int _BlurOffset = 1;
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
    //铅笔画描边 原理: 如果在图像的边缘处，灰度值肯定经过一个跳跃，我们可以计算出这个跳跃，并对这个值进行一些处理，来得到边缘浓黑的描边效果，就像铅笔画一样。
    mat3 pencilFilter = 
    mat3(vec3(-0.5, -1.0, 0.0), 
        vec3(-1.0,  0.0, 1.0), 
        vec3(0.0,  1.0, 0.5));

    vec2 coord = vec2(v_texCoord.x * resolution.x, v_texCoord.y * resolution.y);
    vec4 outp = filter(pencilFilter, texturediffuse, coord, resolution);

    float gray = 0.3 * outp.x + 0.59 * outp.y + 0.11 * outp.z;
    gray = abs(gray);
    gray = 1.0 - gray;
    gl_FragColor = vec4(gray, gray, gray, 1);
}
