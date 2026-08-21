shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx, unshaded;

uniform vec4 hologram_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float dot_scale = 100.0;
uniform float dot_size = 0.15;

void fragment() {

    vec2 dot_uv = fract(UV * dot_scale) - vec2(0.5);
    float dist = length(dot_uv);

    float alpha = smoothstep(dot_size, dot_size - 0.05, dist);
    
    ALBEDO = hologram_color.rgb;
    ALPHA = alpha * hologram_color.a;
}
