Shader "Custom/MetalSpecular" {
	Properties {
		_Speed("Speed", Range(0.1, 1)) = 0.5
		_SpecTexture("Texture (RGB)", 2D) = "white" {}
	}
		SubShader{
		Tags{
		"Queue" = "Transparent"
		"RenderType" = "Transparent"
		}
		//Cull Off Lighting Off ZWrite On Ztest Always
		Blend One One

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _SpecTexture;
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			float4 _SpecTexture_ST;
			float _Speed;
			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(float2(v.texcoord.x, v.texcoord.y + _Speed*_Time.y), _SpecTexture);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return tex2D(_SpecTexture, i.texcoord) * i.color / 2;
			}
			ENDCG
		}
	}
}
