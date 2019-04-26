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

//Range(-5, 5)
float _percent = 1.;
//Range(0,0.25)
float _corner = 0.1;

void main(void)
{
    vec4 col = texture2D(CC_Texture0, v_texCoord);
				
    // 计算圆角，巧妙的算法
    vec2 uv = v_texCoord - vec2(0.5,0.5);
    float centerDist = 0.5 - _corner;
    // glsl中的mod会产生负数
    float rx = mod(abs(uv.x), centerDist);
    float ry = mod(abs(uv.y), centerDist);
    
    float mx = step(centerDist, abs(uv.x));
    float my = step(centerDist, abs(uv.y));
    float alpha = 1. - mx*my*step(_corner, length(vec2(rx,ry)));
    
    // 高亮效果
    // mat2 rotMat = mat2(0.866, 0.5, -0.5 , 0.866);
    // uv = v_texCoord - vec2(0.5, 0.5);
    // uv = (v_texCoord + vec2(_percent, _percent)) * 2.;
    // uv = mul(rotMat, uv);
    
    // float v = saturate(mix(float(1.), float(0.), abs(uv.y)))*0.3;
    // col += vec4(v,v,v,v);
    
    col.a *= alpha;
    gl_FragColor = col;
}
