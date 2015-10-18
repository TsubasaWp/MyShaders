Shader "Custom/Illumation"
{
	Properties{
		_IlluminCol("Self-Illumination color (RGB)", Color) = (1,1,1,1)
		_MainTex("Base (RGB) Self-Illumination (A)", 2D) = "white" {}
	}
		SubShader{ 
		Pass{
		// Set up basic white vertex lighting

		Lighting Off

		// Use texture alpha to blend up to white (= full illumination)
		SetTexture[_MainTex]{
		// Pull the color property into this blender
		constantColor[_IlluminCol]
		// And use the texture's alpha to blend between it and
		// vertex color
		combine constant lerp(texture) previous
		}
		// Multiply in texture
		SetTexture[_MainTex]{
		combine previous * texture
		}

		// 这奇怪的语法...其实翻译成frag shader之后看起来更逻辑更加清晰:
		/*
		// SetTexture #0
		tex = tex2D(_MainTex, IN.uv0.xy);
		col = lerp(IN.color, _IlluminCol, tex.a);
		// SetTexture #1
		tex = tex2D(_MainTex, IN.uv1.xy);
		col = col * tex;
		*/

	}
	}
}
