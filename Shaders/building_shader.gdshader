
shader_type canvas_item;

uniform vec2 player_screen_position = vec2(0.5, 0.5);
uniform float reveal_radius = 55.0;
uniform float edge_softness = 12.0;
uniform float transparency = 0.15;

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    float distance_to_player = distance(
        FRAGCOORD.xy,
        player_screen_position
    );

    float reveal = 1.0 - smoothstep(
        reveal_radius - edge_softness,
        reveal_radius,
        distance_to_player
    );

    color.a *= mix(1.0, transparency, reveal);

    COLOR = color;
}
