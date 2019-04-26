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
    //老照片 原理: r = 0.393*r + 0.769*g + 0.189*b; g = 0.349*r + 0.686*g + 0.168*b; b = 0.272*r + 0.534*g + 0.131*b;
    vec4 outCol = texture2D(texturediffuse, v_texCoord);
    float r = 0.393*outCol.r + 0.769*outCol.g + 0.189*outCol.b;
    float g = 0.349*outCol.r + 0.686*outCol.g + 0.168*outCol.b;
    float b = 0.272*outCol.r + 0.534*outCol.g + 0.131*outCol.b;
    outCol.r = r;
    outCol.g = g;
    outCol.b = b;
    gl_FragColor = outCol;
}
