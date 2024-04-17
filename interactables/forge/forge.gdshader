shader_type canvas_item;

uniform float threshold;
uniform vec4 glow_color: source_color = vec4(0.5);

uniform float flicker_speed = 1.0;
uniform float flicker_amount = 0.5; 

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}


float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);
	
	vec3 yellow = vec3(1.0, 1.0, 0.0);
	
	float color_diff = distance(current_color.rgb, yellow);
	
	if (color_diff < threshold) {
		
		float noise_value = noise(vec2(TIME *  flicker_speed, 0.0));
		float flicker = noise_value * flicker_amount;
		
		COLOR = current_color + glow_color + flicker;
	}else{
		COLOR = current_color;
	}
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
