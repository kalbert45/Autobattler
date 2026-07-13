shader_type canvas_item;
render_mode unshaded;

const mat4 bayer_matrix = mat4(
    vec4(00.0 / 16.0, 12.0 / 16.0, 03.0 / 16.0, 15.0 / 16.0),
    vec4(08.0 / 16.0, 04.0 / 16.0, 11.0 / 16.0, 07.0 / 16.0),
    vec4(02.0 / 16.0, 14.0 / 16.0, 01.0 / 16.0, 13.0 / 16.0),
    vec4(10.0 / 16.0, 06.0 / 16.0, 09.0 / 16.0, 05.0 / 16.0));

// Get the dither value from a 4x4 Bayer Matrix
float get_dither_value(vec2 pixel) {
    int x = int(pixel.x - 4.0 * floor(pixel.x / 4.0));
    int y = int(pixel.y - 4.0 * floor(pixel.y / 4.0));
    return bayer_matrix[x][y];
}

// Pixel size used in dithering
uniform float dither_pixel_size = 1.0;
// The pixel offset used for dithering
uniform vec2 dither_pixel_offset = vec2(0.0);

// Albedo color
uniform vec4 albedo : source_color = vec4(1.0);
// Albedo multiplier
uniform float albedo_strength = 1.0;

// OUTLINE VARIABLES

uniform vec4 clr : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int type : hint_range(0, 2) = 2;
uniform float thickness = 1.0;

const vec2[8] DIRECTIONS = {
	vec2(1.0, 0.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(0.0, -1.0),
	vec2(1.0, 1.0),
	vec2(-1.0, 1.0),
	vec2(-1.0, -1.0),
	vec2(1.0, -1.0)
};

float gtz(float input) { return max(0, sign(input)); }
// returns 1 if input > 0, else 0

float check(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
	for (int i = 0; i < 4 * type; i++) {
		result += texture(tex, from + DIRECTIONS[i] * size * thickness).a;
	}
	return gtz(result);
}

vec4 get_albedo(sampler2D texture_albedo, vec2 uv) {
    return texture(texture_albedo, uv) * albedo * vec4(vec3(albedo_strength), 1.0);
}

vec2 get_pixel_center(sampler2D texture_albedo, vec2 uv) {
    return floor(uv * vec2(textureSize(texture_albedo, 0)) / dither_pixel_size + dither_pixel_offset) + 0.5;
}

// The dither palette texture
uniform sampler2D dither_palette : source_color, filter_nearest;

// Return the dither value for a color based on only the dither value
vec4 get_dither_color(float dither_value, vec4 color) {
    // Each color tile in the palette is 16x16, so color count = rows = Y / 16
    vec2 palette_size = vec2(textureSize(dither_palette, 0));
    float color_count = floor((palette_size.y + 1.0) / 16.0);

    // The dither value determines which color index (tile row) to use.
    // The green color component determines the vertical color within the targetted 16x16 tile.
    float y = (clamp(color.g * 16.0, 0.5, 15.5) + floor(dither_value * color_count) * 16.0) / palette_size.y;

    // The red color component determines which tile column to use.
    // Finally, the blue color component determines the horizontal color within the targetted 16x16 tile.
    float x = clamp(floor(color.r * 16.0), 0.0, 15.0) / 16.0 + clamp(color.b * 16.0, 0.5, 15.5) / 256.0;

    return vec4(texture(dither_palette, vec2(x, y)).rgb, 1.0);
}

// Pixel offset used only for alpha dithering
uniform vec2 alpha_dither_pixel_offset = vec2(0.0);

void fragment() {
	vec4 color = get_albedo(TEXTURE, UV);
	color = mix( color, clr, check(TEXTURE, UV, TEXTURE_PIXEL_SIZE) * (1.0 - gtz(color.a)) );
    COLOR = color;
	
    //vec2 pixel = get_pixel_center(TEXTURE, UV);
    //float dither_value_alpha = get_dither_value(pixel + alpha_dither_pixel_offset);
    //if (color.a <= dither_value_alpha) {
        //discard;
    //}
    //float dither_value = get_dither_value(pixel);
	//COLOR = get_dither_color(dither_value, color);
}