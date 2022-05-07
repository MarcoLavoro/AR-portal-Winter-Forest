Shader "FX/Matte Shadow" {
Properties {
    _Color ("Shadow Color", Color) = (1,1,1,1)
    _ShadowInt ("Shadow Intensity", Range(0,1)) = 1.0
    _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}
 
 
SubShader {
    Tags {
        "Queue"="AlphaTest"
        "IgnoreProjector"="True"
        "RenderType"="TransparentCutout"
    }


    Tags { 
        "RenderType"="Opaque" 
        "Queue"="Geometry-1" 
        }
        Stencil {
            Ref 128
            Comp Always
            Pass Replace
        }
        Pass {
            Fog { Mode Off }
            Color (0,0,0,0)
            ColorMask 0
        }

    Tags { 
        "RenderType"="Cutout" 
        "Queue"="Geometry-1" 
        }
        Stencil {
            Ref 128
            Comp Always
            Pass Replace
        }
    Pass {
        Fog { Mode Off }
        Color (0,0,0,0)
        ColorMask 0
    }
        
    LOD 200
    ZWrite off
    Blend zero SrcColor
 
CGPROGRAM
#pragma surface surf ShadowOnly alphatest:_Cutoff
 
fixed4 _Color;
float _ShadowInt;
 
struct Input {
    float2 uv_MainTex;
};
 
inline fixed4 LightingShadowOnly (SurfaceOutput s, fixed3 lightDir, fixed atten)
{
    fixed4 c;
    c.rgb = lerp(s.Albedo, float3(1.0,1.0,1.0), atten);
    c.a = 1.0-atten;
    return c;
}
 
 
void surf (Input IN, inout SurfaceOutput o) {
    o.Albedo = lerp(float3(1.0,1.0,1.0), _Color.rgb, _ShadowInt);
    o.Alpha = 1.0;
}
ENDCG
}
 
Fallback "Transparent/Cutout/VertexLit"
}