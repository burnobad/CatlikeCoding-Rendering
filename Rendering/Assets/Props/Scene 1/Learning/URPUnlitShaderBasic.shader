// This shader fills the mesh shape with a color predefined in the code.
Shader "ShadersMadeByVlad/1)URPUnlitShaderBasic"
{
    // The properties block of the Unity shader. In this example this block is empty
    // because the output color is predefined in the fragment shader code.
    Properties
    { 
        [MainColor] _Albedo ("Albedo", Color) = (0.5,0,0, 1)
        [MainTexture] _MainTexture ("Main Texture",  2D) = "" {}
        [Normal] _Normal ("Normal Map", 2D) = "" {}
    }

    // The SubShader block containing the Shader code.
    SubShader
    {
        // SubShader Tags define when and under which conditions a SubShader block or
        // a pass is executed.
        Tags {
        "RenderType" = "Opaque"
        "RenderPipeline" = "UniversalPipeline" 
        }

        Pass
        {
            // The HLSL code block. Unity SRP uses the HLSL language.
            HLSLPROGRAM
            // This line defines the name of the vertex shader.
            #pragma vertex vert
            // This line defines the name of the fragment shader.
            #pragma fragment fragShader

            // The Core.hlsl file contains definitions of frequently used HLSL
            // macros and functions, and also contains #include references to other
            // HLSL files (for example, Common.hlsl, SpaceTransforms.hlsl, etc.).
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

             //#include "UnityCG.cginc"

            // The structure definition defines which variables it contains.
            // This example uses the Attributes structure as an input structure in
            // the vertex shader.
            struct Attributes
            {
                // The positionOS variable contains the vertex positions in object
                // space.
                float4 positionOS   : POSITION;

                float2 uv           : TEXCOORD0;
                half3 normal        : NORMAL;
            };

            struct Varyings
            {
                // The positions in this struct must have the SV_POSITION semantic.
                float4 positionHCS  : SV_POSITION;

                float2 uv           : TEXCOORD0;
                half3 normal        : TEXCOORD1;
            };

            TEXTURE2D(_MainTexture);
            SAMPLER(sampler_MainTexture);

            CBUFFER_START(UnityPerMaterial)
                half4 _Albedo;
                float4 _MainTexture_ST;
            CBUFFER_END

            // The vertex shader definition with properties defined in the Varyings
            // structure. The type of the vert function must match the type (struct)
            // that it returns.
            Varyings vert(Attributes IN)
            {
                // Declaring the output object (OUT) with the Varyings struct.
                Varyings OUT;


                // The TransformObjectToHClip function transforms vertex positions
                // from object space to homogenous clip space.
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                OUT.normal = TransformObjectToWorldNormal(IN.normal);

                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTexture);

                // Returning the output.
                return OUT;
            }

            // The fragment shader definition.
            half4 fragShader(Varyings IN) : SV_Target
            {
                // Defining the color variable and returning it.
                half4 finalColor;


                finalColor = SAMPLE_TEXTURE2D(_MainTexture, sampler_MainTexture, IN.uv);
                finalColor *= _Albedo;

                //finalColor.rgb = IN.normal * 0.5 + 0.5;

                return finalColor;
            }
            ENDHLSL
        }
    }
}