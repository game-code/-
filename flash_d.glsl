#ifdef GL_ES
precision lowp float;
#endif

uniform int condition;
uniform float time;
uniform vec2 resolution;

varying vec2 v_texCoord;
varying vec4 v_fragmentColor;

void main(void)
{
    vec4 outCol = texture2D(CC_Texture0, v_texCoord);
    if(condition == 0)
    {
        gl_FragColor = outCol*v_fragmentColor;
    }
    else
    {
        if(outCol.g > .2){
            gl_FragColor = mix(outCol*v_fragmentColor,vec4(0.,1.,0.,1.0),step(0.,sin(10.*time)));
        }else{
            gl_FragColor = outCol*v_fragmentColor;
        }
    }

}
