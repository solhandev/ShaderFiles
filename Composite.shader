Shader "Unlit/Composite"
{
    Properties
    {
        _Gloss ("Gloss", Float) = 25.7
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
                //float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                //float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal: TEXCOORD1;
                float3 worldPosition : TEXCOORD2;
            };

            float _Gloss;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal( v.normal );
                o.worldPosition = mul ( unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.normal);
                float3 light = _WorldSpaceLightPos0.xyz;
                float3 viewVector = normalize(_WorldSpaceCameraPos - i.worldPosition);
                float3 halfVector = normalize(light + viewVector);
                float diffuseLight = saturate(dot(normal, light));
                float3 specularLight = saturate(dot(halfVector, normal)) * (diffuseLight > 0);
                specularLight = pow (specularLight, _Gloss);
                return float4 (diffuseLight + specularLight, 1);
            }
            ENDCG
        }
    }
}