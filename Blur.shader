Shader "Custom/Blur" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,0.5)
        _MainTex ("Texture", 2D) = "white" { }
		_BlurAmount("Blur Amount", Range(0,100)) = 10
    }
    SubShader {
        Pass {

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        fixed4 _Color;
        sampler2D _MainTex;
		float _BlurAmount;

        struct v2f {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
        };

        float4 _MainTex_ST;

        v2f vert (appdata_base v)
        {
            v2f o;
            o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
            o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
		         float blurAmount = _BlurAmount / 1000;
                 float4 sum = float4(0,0,0,0);
 
                 sum += tex2D(_MainTex, float2(i.uv.x - 5.0 * blurAmount, i.uv.y)) * 0.025/2;
                 sum += tex2D(_MainTex, float2(i.uv.x - 4.0 * blurAmount, i.uv.y)) * 0.05/2;
                 sum += tex2D(_MainTex, float2(i.uv.x - 3.0 * blurAmount, i.uv.y)) * 0.09/2;
                 sum += tex2D(_MainTex, float2(i.uv.x - 2.0 * blurAmount, i.uv.y)) * 0.12/2;
                 sum += tex2D(_MainTex, float2(i.uv.x - blurAmount, i.uv.y)) * 0.15/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y)) * 0.16/2;
                 sum += tex2D(_MainTex, float2(i.uv.x + blurAmount, i.uv.y)) * 0.15/2;
                 sum += tex2D(_MainTex, float2(i.uv.x + 2.0 * blurAmount, i.uv.y)) * 0.12/2;
                 sum += tex2D(_MainTex, float2(i.uv.x + 3.0 * blurAmount, i.uv.y)) * 0.09/2;
                 sum += tex2D(_MainTex, float2(i.uv.x + 4.0 * blurAmount, i.uv.y)) * 0.05/2;
                 sum += tex2D(_MainTex, float2(i.uv.x + 5.0 * blurAmount, i.uv.y)) * 0.025/2;

				 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y - 5.0 * blurAmount)) * 0.025/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y - 4.0 * blurAmount)) * 0.05/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y - 3.0 * blurAmount)) * 0.09/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y - 2.0 * blurAmount)) * 0.12/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y - blurAmount)) * 0.15/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y)) * 0.16/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y + blurAmount)) * 0.15/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y + 2.0 * blurAmount)) * 0.12/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y + 3.0 * blurAmount)) * 0.09/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y + 4.0 * blurAmount)) * 0.05/2;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y + 5.0 * blurAmount)) * 0.025/2;
 
                 return sum;
        }
        ENDCG

        }
    }
}
