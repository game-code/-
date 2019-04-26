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

//   _MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
//         _NoiseTex ("Noise Texture", 2D) = "black" {}
//         _QuantBit ("Quant Bit", Range(1, 7)) = 2
//         _WaterPower ("Water Power", Range(5, 50)) = 10
//         _TexSize ("Texture Size", Vector) = (256,256,0,0)
float _QuantBit = 2.;
float _WaterPower = 11.;

// 对颜色的几个分量进行量化
vec4 quant(vec4 col, float k)
{
    col.r = floor(col.r * 255. / k) * k / 255.;
    col.g = floor(col.g * 255. / k) * k / 255.;
    col.b = floor(col.b * 255. / k) * k / 255.;
    return col;
}

void main(void)
{
    //水彩画 原理: 随机采样周围颜色，模拟颜色扩散；然后把RGB由原来的8位量化为更低位，这样颜色的过渡就会显得不那么的平滑，呈现色块效果
    vec4 outuv;

    // 从噪声纹理中取随机数，对纹理坐标扰动，从而形成扩散效果
    vec4 noiseCol = _WaterPower * texture2D(texturenormal, v_texCoord);
    vec2 newUV = vec2(v_texCoord.x + noiseCol.x/resolution.x, v_texCoord.y + noiseCol.y/resolution.y);
    vec4 col = texture2D(texturediffuse, newUV);
    outuv = quant(col, 255./pow(2., _QuantBit)); // 量化图像的颜色值，形成色块
    gl_FragColor = outuv;
}
