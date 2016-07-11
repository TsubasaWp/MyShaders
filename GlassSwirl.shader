Shader "Custom/GlassSwirl"
{
	Properties
	{
		_GrabTexture("Texture", 2D) = "white" {}
		_MaskTexture("Texture", 2D) = "white" {}
		_Radius("_Radius", Range(1, 256)) = 128
		_Angle("_Angle", Range(1, 50)) = 10
		_X("X", Range(1, 256)) = 128
		_Y("Y", Range(1, 256)) = 128
	}

	SubShader
	{
		Tags{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
		"PreviewType" = "Plane"
	}
		Cull Off Lighting Off ZWrite Off Ztest Always
		Blend SrcAlpha OneMinusSrcAlpha

	Pass
	{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		sampler2D _GrabTexture;
		struct appdata_t {
			float4 vertex : POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
		};

		struct v2f {
			float4 vertex : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
			float2 texcoord1 : TEXCOORD1;
		};

		float4 _GrabTexture_ST;
		sampler2D _MaskTexture;
		half _X;
		half _Y;

		// Swirl effect parameters
		half _Radius;
		half _Angle;


		v2f vert(appdata_t v)
		{
			v2f o;
			o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
			o.color = v.color;
			o.texcoord = TRANSFORM_TEX(v.texcoord, _GrabTexture);
			o.texcoord1 = o.texcoord;

			// swirl
			half2 texSize = half2(256, 256);
			half2 center = half2(_X, _Y);
			half2 tc = o.texcoord * texSize;
			float dist = length(tc);
			tc -= center;
			float percent = (_Radius - dist) / 128;
			half theta = (percent * percent * _Angle);
			half s = sin(theta + _Time.x);
			half c = cos(theta + _Time.y);
			tc = half2(dot(tc, half2(c, -s)), dot(tc, half2(s, c)));
			tc += center;
			o.texcoord = tc / texSize;
			
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = tex2D(_GrabTexture,half2(1-i.texcoord.x,1-i.texcoord.y));
			fixed4 col2 = tex2D(_MaskTexture,half2(i.texcoord1.x, i.texcoord1.y));
			col.a = col2.a;
			return col;
		}
		ENDCG
	}
}
}
