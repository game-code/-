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
    //浮雕 原理: 图像的前景前向凸出背景。把象素和左上方的象素进行求差运算，并加上一个灰度(背景)。 
    vec4 col = texture2D(texturediffuse, v_texCoord);
    vec2 leftUpUV = vec2(v_texCoord.x - 1./resolution.x, v_texCoord.y - 1./resolution.y);
    vec4 leftUpCol = texture2D(texturediffuse, leftUpUV);
    vec4 deffCol = col - leftUpCol;
    vec4 outCol;
    outCol.rgb = vec3(dot(deffCol.rgb, vec3(0.3, 0.59, 0.11)));
    outCol = outCol + vec4(0.5, 0.5, 0.5, 0.);
    outCol.a = col.a;
    gl_FragColor = outCol;
}
