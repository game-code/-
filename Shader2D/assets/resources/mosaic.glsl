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

float _SquareWidth = 30.;

void main(void)
{
    //马赛克 原理: n x n方块内取同一颜色
    float pixelX = floor(v_texCoord.x * resolution.x / _SquareWidth) * _SquareWidth;
    float pixelY = floor(v_texCoord.y * resolution.y / _SquareWidth) * _SquareWidth;
    vec2 uv = vec2(pixelX / resolution.x, pixelY / resolution.y);
    vec4 outCol = texture2D(texturediffuse, uv);
    gl_FragColor = outCol;
}
