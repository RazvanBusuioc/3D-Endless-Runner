#version 330
 
uniform sampler2D texture_1;

uniform vec3 light_direction;
uniform vec3 light_position;
uniform vec3 eye_position;

uniform float material_kd;
uniform float material_ks;
uniform int material_shininess;


uniform int is_spot;
uniform float cut_off_angle;
 
in vec2 texcoord;
in vec3 world_position;
in vec3 world_normal;



layout(location = 0) out vec4 out_color;

void main()
{
	// TODO : calculate the out_color using the texture2D() function
	vec4 object_color = texture2D(texture_1, texcoord);

	if(object_color.a < 0.5){
		discard;
	}
	

	// TODO : LVH
	vec3 L = normalize( light_position - world_position);
	vec3 V = normalize( eye_position - world_position );
	vec3 H = normalize( L + V );

	// TODO: define ambient light component
	float ambient_light = 0.6;

	// TODO: compute diffuse light component
	float diffuse_light =  material_kd * 1 * max (dot(world_normal, L), 0);

	// TODO: compute specular light component
	float specular_light = 0;

	if (diffuse_light > 0)
	{
		vec3 R = reflect (-L, world_normal);
		specular_light = material_ks * 1 * 1 * pow(max(dot(V, R), 0), material_shininess);
	}
	if(is_spot == 0){
		float atenuare = 20 / pow(distance(light_position, world_position),2);
		float intensitate = ambient_light + atenuare * ( diffuse_light + specular_light );
		out_color = vec4(object_color.xyz *  vec3(1,1,1) * intensitate , 1);
	}else
	{
		float cut_off = radians(cut_off_angle);
		float spot_light = dot(-L, light_direction);
		float spot_light_limit = cos(cut_off);
		if(spot_light > spot_light_limit)
		{
			float linear_att = (spot_light - spot_light_limit) / (1 - spot_light_limit);
			float light_att_factor = pow(linear_att, 0.2);

			float intensitate = ambient_light + 0.15 * light_att_factor * ( diffuse_light + specular_light );
			out_color = vec4(object_color.xyz *  vec3(1,1,1) * intensitate , 1);
		}else{
			out_color = vec4(object_color.xyz *  vec3(1,1,1) * ambient_light , 1);
		}
	}
	
}