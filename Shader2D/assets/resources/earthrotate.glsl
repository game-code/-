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
    //地球旋转动画 原理: 天空盒，UV动画
    float u = v_texCoord.x + -0.01*time;
    vec2 uv = vec2(u, v_texCoord.y);
    vec4 maintex = texture2D(texturediffuse,v_texCoord);
    vec4 texcol = texture2D(textureemissive, uv);
    
    u = v_texCoord.x + -0.02*time;
    uv = vec2(u, v_texCoord.y);
    vec4 cloudtex = texture2D(texturenormal, uv);
    cloudtex = vec4(1,1,1,0) * (cloudtex.x);
    
    vec4 col = mix(cloudtex, texcol, 0.5);
    if(maintex.a > 0.001){
        gl_FragColor = col;
    }
}
