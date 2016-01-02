Shader "Custom/Gold" 
{
	Properties{
		_lightColor("lightColor Color", Color) = (1,1,1,1)
	}
		SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 200
		Pass
	{
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
#pragma vertex vert
		// The fragment shader name should match the fragment shader function name
#pragma fragment frag_light

		// Use shader model 3.0 target, to get nicer looking lighting
#pragma target 3.0

#include "UnityCG.cginc"

	float4 _lightColor;

	struct v2f
	{
		float4 position : SV_POSITION;
		float4 color    : COLOR;
		float3 normal : NORMAL;
	};

	v2f vert(appdata_base IN)
	{
		v2f o;
		o.position = mul(UNITY_MATRIX_MVP, IN.vertex);
		fixed4 c = _lightColor;
		// The reflection of RGB of Copper
		c.r *= 1;
		c.g *= 0.71;
		c.b *= 0.29;
		o.color = c;
		o.normal = IN.normal;
		return o;
	}

	struct f2v
	{
		float4 color : COLOR;
	};

	f2v frag_light(v2f IN, float3 normal:NORMAL)
	{
		f2v o;
		int _shininess = 5;

		float3 P = normalize(IN.position.xyz);

		float3 N = normalize(normal);

		float3 L = normalize(P - _WorldSpaceLightPos0);

		float diffuseLight = max(dot(N, L), 0);

		float3 refalectedColor = 0.7 * IN.color * IN.color * (1 - pow(diffuseLight, 5));
		refalectedColor = max(refalectedColor, IN.color);

		float3 diffuse = refalectedColor * diffuseLight;

		float3 V = normalize(_WorldSpaceCameraPos.xyz - P);

		float3 H = normalize(L + V);

		float specularLight = pow(max(dot(N, H), 0), _shininess);

		float3 specular = float3(1, 1, 1) * specularLight;

		float3 enviroment = IN.color * 0.35;

		o.color.xyz = enviroment + diffuse +specular;

		o.color.w = 1;

		return o;
	}
		ENDCG
	}
	}
}
