Shader "Learning/Environment/FirstShader"
{
    Properties // характеристики
    {
        // это связующее звено между редактором и кодом самого шейдера
        //указывается имя параметра ,которое будет использоваться в коде шейдера _Color
        //далее имя параметра для инспектора материала "Main Color"
        //следом идет тип параметра Color, чтобы в редакторе отображалась правельное поле для ввода
        //дефольное значение = (1,1,1,1) , если не выбрано в редакторе ничего
        //2D главная тектура
        //Range(0,1) размер слайдера
        //это язык шейдерлаб, который является оберткой юнити
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        //добавляю параметр насчщенности
        _Saturation ("Saturation", Range(0,3)) = 2.0
        _AmplitudeFactor ("Amplitude Factor", Float) = 1.0
    }
    // шейдерная программа, которая выполняет основную работу
    //если не найдет подходящий шейдер, будет использован другой - FallBack "Diffuse"
    //каждый файл шейдера может содержать несколько таких вложенных сабшейдеров
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        //используется язык shsl 
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        //целевая шейдерная модель, напрямую влияет на фичи видеокарты и ограничения железа
        #pragma target 3.0

        sampler2D _MainTex;

        //структура для входных данных для главной фунцкии серф
        struct Input
        {
            float2 uv_MainTex;
            //uv координаты это двухкомпонентый вектор по которому считывается цвет текстуры
        };

        //float где нужна высокая точность на 32 бита: текстурные координаты, расположения в пространстве, скалярные произведения
        //half средняя точность на 16 бит: ветора, направления, цвета высокого разрешения
        //fixed число с наименьшей точности на 11бит: -2 до +2, стандартный цыет или текстуры с небольшой точностью
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
            ////высчитываем текст из текстыру и умножаем на параметр цвета
            //float2 uv = IN.uv_MainTex;
            ////можем менять uv координаты, прежде чем читать цвет с текстуры
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
