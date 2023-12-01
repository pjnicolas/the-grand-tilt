shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;



void fragment() {
// Input:3
	vec2 n_out3p0 = UV;


	vec4 n_out5p0;
// Texture2D:5
	n_out5p0 = texture(TEXTURE, n_out3p0);
	float n_out5p1 = n_out5p0.r;
	float n_out5p4 = n_out5p0.a;


// FloatConstant:10
	float n_out10p0 = 0.500000;


// FloatOp:8
	float n_out8p0 = n_out5p1 * n_out10p0;


// FloatOp:9
	float n_out9p0 = n_out5p1 * n_out10p0;


// VectorCompose:7
	vec3 n_out7p0 = vec3(n_out5p1, n_out8p0, n_out9p0);


	vec4 n_out6p0;
// Texture2D:6
	n_out6p0 = textureLod(screen_texture, SCREEN_UV, 0.0);
	COLOR = n_out6p0 * 0.5;


// VectorOp:2
	//vec3 n_out2p0 = n_out7p0 * vec3(n_out6p0.xyz);


// Output:0
	//COLOR.rgb = n_out2p0;
	//COLOR.a = n_out5p4;


}
