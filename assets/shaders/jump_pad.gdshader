shader_type particles;

float noise(vec2 sample) {
	return fract(sin(dot(sample, vec2(12.9898, 78.233))) * 43758.5453);
}

// TODO: Improve randomness
float rand() {
	return noise(vec2(sin(TIME), cos(fract(TIME) * PI)));
}

const float scale = 0.1;

void start() {
	// TODO: Add spread calculations

	VELOCITY.y = -30.0;
	
	// emit position
	TRANSFORM[3] = EMISSION_TRANSFORM[3];
	TRANSFORM[3].x += rand() * 8.0 - 4.0;
	
	TRANSFORM[0].x = scale;
	TRANSFORM[1].y = scale;
	TRANSFORM[2].z = scale;

	COLOR.r = 122.0 / 255.0;
	COLOR.g = 201.0 / 255.0;
	COLOR.b = 223.0 / 255.0;
	COLOR.a = 1.0;
}

void process() {
	COLOR.a = clamp(1.0 + (TRANSFORM[3].y - EMISSION_TRANSFORM[3].y) / USERDATA1.x, 0.0, 1.0);
}
