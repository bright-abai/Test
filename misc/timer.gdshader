shader_type canvas_item;

// Timer progress from 0.0 (empty) to 1.0 (full)
uniform float progress : hint_range(0.0, 1.0) = 1.0;

// Circle appearance
uniform vec4 fill_color : source_color = vec4(0.2, 0.6, 1.0, 1.0);
uniform vec4 bg_color : source_color = vec4(0.1, 0.1, 0.1, 0.3);
uniform float thickness : hint_range(0.0, 0.5) = 0.1;
uniform float smoothness : hint_range(0.001, 0.1) = 0.01;

// Starting angle (0 = top, PI/2 = right, PI = bottom, etc.)
uniform float start_angle : hint_range(0.0, 6.28319) = 0.0;

void fragment() {
    // Center coordinates
    vec2 center = vec2(0.5, 0.5);
    vec2 pos = UV - center;
      
    // Calculate angle (-PI to PI, with 0 at right)
    float angle = atan(pos.y, pos.x);
    
    // Rotate to start from top (subtract PI/2 to make top = 0)
    angle = angle + PI * 0.5 - start_angle;
    
    // Normalize angle to 0 to 2*PI range
    angle = mod(angle + PI, PI * 2.0);
    
    // Calculate progress angle (clockwise)
    float progress_angle = 2.0 * PI - progress * PI * 2.0;
    
    // Check if we're in the filled arc (timer portion)
    float arc_mask = step(progress_angle, angle);

    // Outer and inner radius for the ring
    float outer_radius = 0.5;
    float inner_radius = outer_radius - thickness;
    
	// Distance from center
    float dist = length(pos);
    // Check if we're within the ring
    float ring_mask = smoothstep(inner_radius - smoothness, inner_radius, dist) * 
                      smoothstep(outer_radius + smoothness, outer_radius, dist);
    
    // Blend between background and fill color
    vec4 final_color = mix(bg_color, fill_color, arc_mask);
    
    // Apply ring mask
    COLOR = vec4(final_color.rgb, final_color.a * ring_mask);
}