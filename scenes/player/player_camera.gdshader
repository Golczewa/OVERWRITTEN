shader_type canvas_item;

// Ten shader daje wrażenie patrzenia na obraz wyświetlany na nowoczesnym,
// płaskim monitorze (LCD/OLED) — bez efektów CRT (brak zakrzywienia,
// skanlinii, migotania). Zamiast tego: leciutka siatka pikseli,
// wyostrzenie, delikatny refleks szkła i subtelna winieta.
//
// UŻYCIE: nałóż na ColorRect rozciągnięty na cały ekran (Anchor: Full Rect),
// umieszczony w CanvasLayer NAD resztą sceny.

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// --- Wyostrzenie obrazu (subtelny "digital crispness") ---
uniform bool enable_sharpen = true;
uniform float sharpen_amount : hint_range(0.0, 1.0) = 0.15;

// --- Leciutka siatka pikseli (imitacja struktury matrycy) ---
uniform bool enable_pixel_grid = true;
uniform float pixel_density : hint_range(1.0, 6.0) = 3.0;
uniform float pixel_grid_intensity : hint_range(0.0, 0.3) = 0.05;

// --- Delikatny refleks szklanej powierzchni ekranu ---
uniform bool enable_glare = true;
uniform float glare_angle : hint_range(0.0, 6.28) = 0.5;
uniform float glare_position : hint_range(-1.0, 1.0) = -0.35;
uniform float glare_width : hint_range(0.01, 0.5) = 0.18;
uniform float glare_intensity : hint_range(0.0, 0.3) = 0.05;

// --- Subtelna winieta (lekkie przyciemnienie brzegów) ---
uniform bool enable_vignette = true;
uniform float vignette_intensity : hint_range(0.0, 2.0) = 0.25;
uniform float vignette_smoothness : hint_range(0.0, 1.0) = 0.6;

// --- Korekcja kolorów (czystszy, "cyfrowy" obraz) ---
uniform float brightness : hint_range(0.5, 1.5) = 1.0;
uniform float contrast : hint_range(0.5, 1.5) = 1.05;
uniform float saturation : hint_range(0.0, 2.0) = 1.05;

vec3 sharpen(vec2 uv, vec2 texel) {
    vec3 center = texture(screen_texture, uv).rgb;
    vec3 neighbors =
        texture(screen_texture, uv + vec2(texel.x, 0.0)).rgb +
        texture(screen_texture, uv - vec2(texel.x, 0.0)).rgb +
        texture(screen_texture, uv + vec2(0.0, texel.y)).rgb +
        texture(screen_texture, uv - vec2(0.0, texel.y)).rgb;
    return center * (1.0 + 4.0 * sharpen_amount) - neighbors * sharpen_amount;
}

vec3 grade(vec3 color) {
    color = (color - 0.5) * contrast + 0.5;
    float luma = dot(color, vec3(0.299, 0.587, 0.114));
    color = mix(vec3(luma), color, saturation);
    color *= brightness;
    return color;
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 texel = SCREEN_PIXEL_SIZE;

    vec3 color = enable_sharpen ? sharpen(uv, texel) : texture(screen_texture, uv).rgb;

    // Siatka pikseli
    if (enable_pixel_grid) {
        vec2 res = 1.0 / texel;
        vec2 cell = fract(uv * res / pixel_density);
        float line = min(cell.x, cell.y);
        float grid = smoothstep(0.0, 0.15, line);
        color *= mix(1.0 - pixel_grid_intensity, 1.0, grid);
    }

    // Refleks szkła
    if (enable_glare) {
        vec2 dir = vec2(cos(glare_angle), sin(glare_angle));
        float d = dot(uv - vec2(0.5), dir);
        float glare = smoothstep(glare_width, 0.0, abs(d - glare_position));
        color += glare * glare_intensity;
    }

    color = grade(color);

    // Winieta
    if (enable_vignette) {
        vec2 vig_uv = uv * (1.0 - uv.yx);
        float vig = pow(vig_uv.x * vig_uv.y * 15.0, vignette_intensity);
        color *= mix(1.0 - vignette_smoothness, 1.0, clamp(vig, 0.0, 1.0));
    }

    COLOR = vec4(color, 1.0);
}
