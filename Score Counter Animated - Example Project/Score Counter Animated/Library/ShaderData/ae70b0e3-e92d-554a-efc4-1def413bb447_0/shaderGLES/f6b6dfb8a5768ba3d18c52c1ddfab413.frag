#version 300 es
precision highp float;
precision highp int;

uniform mediump sampler2D _MainTex;
uniform float _Exposure;
uniform float _Brightness;
uniform float _Temperature;
uniform float _Tint;
uniform float _Contrast;
uniform float _Saturation;

in vec2 uv0;
layout(location = 0) out vec4 o_FragColor;

vec3 LinearToLMS(vec3 x)
{
    return mat3(vec3(0.390404999256134033203125, 0.549941003322601318359375, 0.008926319889724254608154296875), vec3(0.070841602981090545654296875, 0.963172018527984619140625, 0.001357750035822391510009765625), vec3(0.02310819923877716064453125, 0.1280210018157958984375, 0.936245024204254150390625)) * x;
}

float StandardIlluminantY(float x)
{
    return ((2.86999988555908203125 * x) - ((3.0 * x) * x)) - 0.2750950753688812255859375;
}

vec3 CIExyToLMS(float x, float y)
{
    float Y = 1.0;
    float X = (Y * x) / y;
    float Z = (Y * ((1.0 - x) - y)) / y;
    float L = ((0.732800006866455078125 * X) + (0.4296000003814697265625 * Y)) - (0.1624000072479248046875 * Z);
    float M = (((-0.703599989414215087890625) * X) + (1.6974999904632568359375 * Y)) + (0.006099999882280826568603515625 * Z);
    float S = ((0.0030000000260770320892333984375 * X) + (0.013600000180304050445556640625 * Y)) + (0.98339998722076416015625 * Z);
    return vec3(L, M, S);
}

vec3 WhiteBalanceToLMSCoeffs(float temperature, float tint)
{
    float t1 = temperature * 1.5384614467620849609375;
    float t2 = tint * 1.5384614467620849609375;
    float x = 0.312709987163543701171875 - (t1 * ((t1 < 0.0) ? 0.100000001490116119384765625 : 0.0500000007450580596923828125));
    float param = x;
    float y = StandardIlluminantY(param) + (t2 * 0.0500000007450580596923828125);
    vec3 w1 = vec3(0.94923698902130126953125, 1.035419940948486328125, 1.0872800350189208984375);
    float param_1 = x;
    float param_2 = y;
    vec3 w2 = CIExyToLMS(param_1, param_2);
    return vec3(w1.x / w2.x, w1.y / w2.y, w1.z / w2.z);
}

vec3 LMSToLinear(vec3 x)
{
    return mat3(vec3(2.85846996307373046875, -1.62879002094268798828125, -0.0248910002410411834716796875), vec3(-0.21018199622631072998046875, 1.1582000255584716796875, 0.0003242809907533228397369384765625), vec3(-0.0418119989335536956787109375, -0.118169002234935760498046875, 1.0686700344085693359375)) * x;
}

void main()
{
    vec4 result = texture(_MainTex, uv0);
    vec3 _216 = result.xyz * pow(2.0, _Exposure);
    result = vec4(_216.x, _216.y, _216.z, result.w);
    vec3 _224 = result.xyz + vec3(_Brightness);
    result = vec4(_224.x, _224.y, _224.z, result.w);
    vec3 param = result.xyz;
    vec3 colorLMS = LinearToLMS(param);
    float param_1 = _Temperature;
    float param_2 = _Tint;
    colorLMS *= WhiteBalanceToLMSCoeffs(param_1, param_2);
    vec3 param_3 = colorLMS;
    vec3 _243 = LMSToLinear(param_3);
    result = vec4(_243.x, _243.y, _243.z, result.w);
    float midpoint = 0.21763764321804046630859375;
    vec3 _258 = ((result.xyz - vec3(midpoint)) * _Contrast) + vec3(midpoint);
    result = vec4(_258.x, _258.y, _258.z, result.w);
    vec3 grayscale = vec3(dot(result.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)));
    vec3 _277 = mix(grayscale, result.xyz, vec3(1.0 + _Saturation));
    result = vec4(_277.x, _277.y, _277.z, result.w);
    o_FragColor = result;
}

