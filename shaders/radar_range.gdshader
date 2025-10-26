shader_type canvas_item;

uniform vec2 center = vec2(0.0, 0.0);
uniform float radius : hint_range(0.0, 1024.0) = 100.0;
uniform float fade : hint_range(0.0, 200.0) = 20.0;
uniform vec4 color : source_color = vec4(0.0, 1.0, 0.3, 0.3);
uniform bool active = false;

void fragment() {
    // If inactive, make it fully transparent
    if (!active) {
        COLOR = vec4(0.0);
        discard; // skip rendering this fragment
    }

    // Pixel position relative to radar center
    vec2 uv = FRAGCOORD.xy - center;

    float dist = length(uv);

    // Circle fade edge
    float alpha = smoothstep(radius, radius - fade, dist);

    // Hide everything outside radius
    if (dist > radius)
        discard;

    COLOR = vec4(color.rgb, color.a * alpha);
}

