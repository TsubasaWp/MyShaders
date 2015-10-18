Shader "Custom/Texture" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		Lighting Off
		Pass{
		SetTexture[_MainTex]{
		}
		}
	} 
	FallBack "Diffuse"
}
