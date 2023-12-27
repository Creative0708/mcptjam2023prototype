shader_type canvas_item;

uniform vec3 color = vec3(0, 0, 0);
uniform float mix_fac = 0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR.rgb = mix(tex.rgb, color, mix_fac);
	COLOR.a = tex.a;
}
