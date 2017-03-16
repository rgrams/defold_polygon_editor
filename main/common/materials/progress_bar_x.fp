varying mediump vec2 var_texcoord0;

uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform lowp vec4 fill;
uniform lowp vec4 fgtint;
uniform lowp vec4 bgtint;

void main()
{
	vec4 outcolor = fgtint;
	if ( var_texcoord0.x > fill.x ) outcolor = bgtint;
	gl_FragColor = texture2D(DIFFUSE_TEXTURE, var_texcoord0) * outcolor;
}
