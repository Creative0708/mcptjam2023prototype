shader_type spatial;

uniform vec3 color = vec3(0, 0, 0);
uniform float mix_fac = 0;
uniform float alpha = 1;
uniform sampler2D tex: source_color;

void fragment() {
	vec4 col = texture(tex, UV);
	ALBEDO = mix(col.rgb, color, mix_fac);
	ALPHA = col.a * alpha;
}
