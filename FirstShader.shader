Shader "Learning/Environment/FirstShader"
{
    Properties // ��������������
    {
        // ��� ��������� ����� ����� ���������� � ����� ������ �������
        //����������� ��� ��������� ,������� ����� �������������� � ���� ������� _Color
        //����� ��� ��������� ��� ���������� ��������� "Main Color"
        //������ ���� ��� ��������� Color, ����� � ��������� ������������ ���������� ���� ��� �����
        //��������� �������� = (1,1,1,1) , ���� �� ������� � ��������� ������
        //2D ������� �������
        //Range(0,1) ������ ��������
        //��� ���� ���������, ������� �������� �������� �����
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        //�������� �������� ������������
        _Saturation ("Saturation", Range(0,3)) = 2.0
        _AmplitudeFactor ("Amplitude Factor", Float) = 1.0
    }
    // ��������� ���������, ������� ��������� �������� ������
    //���� �� ������ ���������� ������, ����� ����������� ������ - FallBack "Diffuse"
    //������ ���� ������� ����� ��������� ��������� ����� ��������� �����������
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        //������������ ���� shsl 
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        //������� ��������� ������, �������� ������ �� ���� ���������� � ����������� ������
        #pragma target 3.0

        sampler2D _MainTex;

        //��������� ��� ������� ������ ��� ������� ������� ����
        struct Input
        {
            float2 uv_MainTex;
            //uv ���������� ��� ��������������� ������ �� �������� ����������� ���� ��������
        };

        //float ��� ����� ������� �������� �� 32 ����: ���������� ����������, ������������ � ������������, ��������� ������������
        //half ������� �������� �� 16 ���: ������, �����������, ����� �������� ����������
        //fixed ����� � ���������� �������� �� 11���: -2 �� +2, ����������� ���� ��� �������� � ��������� ���������
        half _Glossiness;
        half _Metallic;
        half _Saturation;
        fixed4 _Color;
        float _AmplitudeFactor;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            ////c = fixed4(tex.r * _Color.r,tex.g * _Color.g,
            ////            tex.b * _Color.b, tex.a * _Color.a);
            ////����������� ����� �� �������� � �������� �� �������� �����
            //float2 uv = IN.uv_MainTex;
            ////����� ������ uv ����������, ������ ��� ������ ���� � ��������
            //uv.y += sin(uv.x * 6.5 + _Time.y);
            //fixed4 c = tex2D (_MainTex, uv) * _Color;
            ////o.Albedo = c.rgb; // fixed3(c.r,c.g,c.b);
            ////c = lerp(_Color,c,uv.x * _Saturation);
            //o.Albedo = c.rgb;
            //// Metallic and smoothness come from slider variables
            //o.Metallic = _Metallic;
            //o.Smoothness = _Glossiness;
            //o.Alpha = c.a;
            float2 uv = IN.uv_MainTex;
            float amplitude = uv.x * _AmplitudeFactor;
            uv.y += sin(uv.x * 6.5 + _Time.y) * amplitude;

            fixed4 c = tex2D(_MainTex, uv) * _Color;

            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
