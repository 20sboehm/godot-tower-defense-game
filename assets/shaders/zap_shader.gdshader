shader_type canvas_item;

uniform vec4 base_color: source_color;
uniform vec4 secondary_color: source_color;

uniform float sprite_width = 16.0; // Will be overriden in code

// Returns the modulo of two floats
float f_mod(float a, float b) {
	return a - b * floor(a/b);
}

float generate_wave(float x, float amp, float offset, float scale_factor) {
	float wave;
	
	if (x >= 7. * PI / 4.) {
		wave = 0.5 + amp * scale_factor * sin(x);
	}
	else if (x >= 5. * PI / 4.) {
		wave = 0.5 + amp * scale_factor * sin(x - PI / 2.);
	}
	else if (x >= 3. * PI / 4.) {
		wave = 0.5 + amp * scale_factor * sin(x - PI);
	}
	else if (x >= PI / 4.) {
		wave = 0.5 + amp * scale_factor * sin(x - 3. * PI / 2.);
	}
	else if (x >= 0.) {
		wave = 0.5 + amp * scale_factor * sin(x);
	}
	
	return wave;
}

void fragment() {
	float amplitude = 0.5;
	float frequency = sprite_width / 4.0;
	float line_width = 0.1;
	
	float wave_y_1;
	float wave_y_2;
	
	float scaled_x_1 = UV.x * frequency - (TIME * 10.0 - f_mod(TIME * 10.0, 1.0));
	float scaled_x_2 = UV.x * frequency + 1.0 - (TIME * 10.0 - f_mod(TIME * 10.0, 1.0));
	float mod_x_1 = f_mod(scaled_x_1, 2.0 * PI);
	float mod_x_2 = f_mod(scaled_x_2, 2.0 * PI);
	
	// smoothstep is used to interpolate the amplitude smoothly from 
	// full strength in the middle to reduced strength near the ends.
	float min_scale = 0.4;
	float scale_factor = mix(min_scale, 1.0, smoothstep(0.0, 0.4, UV.x) * smoothstep(1.0, 0.6, UV.x));
	
	wave_y_1 = generate_wave(mod_x_1, amplitude, 0.5, scale_factor);
	wave_y_2 = generate_wave(mod_x_2, amplitude * 0.8, 0.5, scale_factor);
	
	float distance_to_line_1 = abs(UV.y - wave_y_1);
	float distance_to_line_2 = abs(UV.y - wave_y_2);
	
	if (distance_to_line_1 < line_width / 2.0) {
		COLOR = base_color;
	}
	else if (distance_to_line_2 < line_width / 4.0) {
		COLOR = secondary_color;
	}

	else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}