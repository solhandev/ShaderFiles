Shader "Unlit/Lambertian"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal: TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal( v.normal );
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = i.normal;
                float3 light = _WorldSpaceLightPos0.xyz;
                float diffuseLight = saturate(dot(normal, light));
                
                return float4 (diffuseLight.xxx, 1);
            }
            ENDCG
        }
    }
}
