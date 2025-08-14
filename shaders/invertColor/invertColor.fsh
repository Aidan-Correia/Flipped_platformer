//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 OC = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    float NCr = abs(OC.r-1.0);
    float NCg = abs(OC.g-1.0);
    float NCb = abs(OC.b-1.0);
    gl_FragColor = vec4( NCr, NCg, NCb, OC.a );
	
}
