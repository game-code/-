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

void main(void)
{
    //模糊 原理: 采样附近上下左右四个相邻像素的颜色，与当前像素颜色按比例混合（简单滤波） 
    float uvOffset = 0.01;
    vec4 s1 = texture2D(CC_Texture0, v_texCoord + vec2(uvOffset,0.00));
    vec4 s2 = texture2D(CC_Texture0, v_texCoord + vec2(-uvOffset,0.00));
    vec4 s3 = texture2D(CC_Texture0, v_texCoord + vec2(0.00,uvOffset));
    vec4 s4 = texture2D(CC_Texture0, v_texCoord + vec2(0.00,-uvOffset));
    
    vec4 texCol = texture2D(CC_Texture0, v_texCoord);
    vec4 outp;
    float pct = 0.2;
    outp = texCol * (1.- pct*4.) + s1* pct + s2* pct+ s3* pct + s4* pct;
    gl_FragColor = outp;
}
