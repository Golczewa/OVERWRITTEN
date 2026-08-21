shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 100.0) = 1.0;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec2 size = vec2(textureSize(TEXTURE, 0));
    vec2 pixelated_uv = floor(UV * size / pixel_size) * pixel_size / size;
    vec4 color = texture(TEXTURE, pixelated_uv);
    color.a *= alpha;
    COLOR = color;
}