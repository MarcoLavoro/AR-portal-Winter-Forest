Shader "Tree_Shader"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_HalfTonePattern("HalfTonePattern", 2D) = "white" {}
		_Ombre("Ombre", Color) = (0,0.2198356,0.754717,0)
		_RemapInputMinValue("Remap Input Min Value", Range( 0 , 1)) = 0
		_RemapInputmaxValue("Remap Input max Value", Range( 0 , 1)) = 1
		_RemapOutputminValue("Remap Output min Value", Range( 0 , 1)) = 0
		_RemapOutputmaxValue("Remap Output max Value", Range( 0 , 1)) = 1
		_Progression("Progression", Range( 0 , 1.3)) = 0.3159638
		_GradientValue("Gradient Value", Range( 0 , 5)) = 2.297216
		_Gradient_A("Gradient_A", Color) = (0.7745483,1,0,0)
		_Gradient_B("Gradient_B", Color) = (0.5283019,0,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#include "TerrainEngine.cginc"
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Gradient_A;
		uniform float4 _Gradient_B;
		uniform float _Progression;
		uniform float _GradientValue;
		uniform sampler2D _HalfTonePattern;
		uniform float4 _HalfTonePattern_ST;
		uniform float _RemapInputMinValue;
		uniform float _RemapInputmaxValue;
		uniform float _RemapOutputminValue;
		uniform float _RemapOutputmaxValue;
		uniform float4 _Ombre;
		uniform float _Cutoff = 0.5;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode136 = tex2D( _Albedo, uv_Albedo );
			float Alpha187 = tex2DNode136.a;
			float4 MainTex143 = tex2DNode136;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float clampResult198 = clamp( ( _Progression + ( ( _Progression - ase_vertex3Pos.y ) / _GradientValue ) ) , 0.0 , 1.0 );
			float4 lerpResult201 = lerp( _Gradient_A , _Gradient_B , clampResult198);
			float4 blendOpSrc151 = MainTex143;
			float4 blendOpDest151 = lerpResult201;
			float4 lerpBlendMode151 = lerp(blendOpDest151,( blendOpSrc151 + blendOpDest151 - 1.0 ),Alpha187);
			float4 Gradient205 = ( saturate( lerpBlendMode151 ));
			float2 uv_HalfTonePattern = i.uv_texcoord * _HalfTonePattern_ST.xy + _HalfTonePattern_ST.zw;
			float temp_output_110_0 = (_RemapOutputminValue + (tex2D( _HalfTonePattern, uv_HalfTonePattern, float2( 0,0 ), float2( 0,0 ) ).r - _RemapInputMinValue) * (_RemapOutputmaxValue - _RemapOutputminValue) / (_RemapInputmaxValue - _RemapInputMinValue));
			float HalfToneValue98 = temp_output_110_0;
			float HalfToneChange97 = ( fwidth( temp_output_110_0 ) * 0.5 );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult16 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_17_0 = (0.0 + (dotResult16 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float TowardsLight130 = temp_output_17_0;
			float smoothstepResult90 = smoothstep( ( HalfToneValue98 - HalfToneChange97 ) , ( HalfToneValue98 + HalfToneChange97 ) , TowardsLight130);
			c.rgb = ( ( Gradient205 * smoothstepResult90 ) + ( ( 1.0 - smoothstepResult90 ) * _Ombre ) ).rgb;
			c.a = 1;
			clip( Alpha187 - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}