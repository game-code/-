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

//   _Center ("Center Point", vector) = (0.5, 0.5, 0, 0)
//   _Radius ("Twirl Radius", Range(0,256)) = 0.5
//   _Angle  ("Twirl Angel", Range(-90, 90)) = 90.0
vec4 _Center = vec4(0.5, 0.5, 0, 0);
float _Radius = 0.2;
float _Angle = 30.0;

const float PI = 3.14159265;
 
const float uD = 80.0; //旋转角度
const float uR = 0.5; //旋转半径

void main(void)
{
    //旋转效果 原理: 旋转纹理UV坐标。相比上一个，这个没有根据距离调整角度，并且演示了屏幕后处理特效
    vec2 offset = v_texCoord.xy - 0.5;
    vec2 distortedOffset = MultiplyUV (_RotationMatrix, offset.xy);
    vec2 tmp = offset / _CenterRadius.zw;
    float len = length(tmp);
    float cmp = step(1, len);
    vec2 finalUV = mix(mix(distortedOffset, offset, len), offset, cmp);
    
    // back to normal uv coordinate
    finalUV += _CenterRadius.xy;
    return tex2D(_MainTex, finalUV);
    gl_FragColor = vec4( irgb, 1.0 );
}
