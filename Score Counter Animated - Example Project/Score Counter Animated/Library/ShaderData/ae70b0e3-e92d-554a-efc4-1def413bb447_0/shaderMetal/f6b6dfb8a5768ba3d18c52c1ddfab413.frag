#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct buffer_t
{
    float _Exposure;
    float _Brightness;
    float _Temperature;
    float _Tint;
    float _Contrast;
    float _Saturation;
};

struct main0_out
{
    float4 o_FragColor [[color(0)]];
};

struct main0_in
{
    float2 uv0;
};

static inline __attribute__((always_inline))
float3 LinearToLMS(thread const float3& x)
{
    return float3x3(float3(0.390404999256134033203125, 0.549941003322601318359375, 0.008926319889724254608154296875), float3(0.070841602981090545654296875, 0.963172018527984619140625, 0.001357750035822391510009765625), float3(0.02310819923877716064453125, 0.1280210018157958984375, 0.936245024204254150390625)) * x;
}

static inline __attribute__((always_inline))
float StandardIlluminantY(thread const float& x)
{
    return ((2.86999988555908203125 * x) - ((3.0 * x) * x)) - 0.2750950753688812255859375;
}

static inline __attribute__((always_inline))
float3 CIExyToLMS(thread const float& x, thread const float& y)
{
    float Y = 1.0;
    float X = (Y * x) / y;
    float Z = (Y * ((1.0 - x) - y)) / y;
    float L = ((0.732800006866455078125 * X) + (0.4296000003814697265625 * Y)) - (0.1624000072479248046875 * Z);
    float M = (((-0.703599989414215087890625) * X) + (1.6974999904632568359375 * Y)) + (0.006099999882280826568603515625 * Z);
    float S = ((0.0030000000260770320892333984375 * X) + (0.013600000180304050445556640625 * Y)) + (0.98339998722076416015625 * Z);
    return float3(L, M, S);
}

static inline __attribute__((always_inline))
float3 WhiteBalanceToLMSCoeffs(thread const float& temperature, thread const float& tint)
{
    float t1 = temperature * 1.5384614467620849609375;
    float t2 = tint * 1.5384614467620849609375;
    float x = 0.312709987163543701171875 - (t1 * ((t1 < 0.0) ? 0.100000001490116119384765625 : 0.0500000007450580596923828125));
    float param = x;
    float y = StandardIlluminantY(param) + (t2 * 0.0500000007450580596923828125);
    float3 w1 = float3(0.94923698902130126953125, 1.035419940948486328125, 1.0872800350189208984375);
    float param_1 = x;
    float param_2 = y;
    float3 w2 = CIExyToLMS(param_1, param_2);
    return float3(w1.x / w2.x, w1.y / w2.y, w1.z / w2.z);
}

static inline __attribute__((always_inline))
float3 LMSToLinear(thread const float3& x)
{
    return float3x3(float3(2.85846996307373046875, -1.62879002094268798828125, -0.0248910002410411834716796875), float3(-0.21018199622631072998046875, 1.1582000255584716796875, 0.0003242809907533228397369384765625), float3(-0.0418119989335536956787109375, -0.118169002234935760498046875, 1.0686700344085693359375)) * x;
}

fragment main0_out main0(main0_in in [[stage_in]], constant buffer_t& buffer, texture2d<float> _MainTex [[texture(0)]], sampler _MainTexSmplr [[sampler(0)]])
{
    main0_out out = {};
    float4 result = _MainTex.sample(_MainTexSmplr, in.uv0);
    float3 _216 = result.xyz * pow(2.0, buffer._Exposure);
    result = float4(_216.x, _216.y, _216.z, result.w);
    float3 _224 = result.xyz + float3(buffer._Brightness);
    result = float4(_224.x, _224.y, _224.z, result.w);
    float3 param = result.xyz;
    float3 colorLMS = LinearToLMS(param);
    float param_1 = buffer._Temperature;
    float param_2 = buffer._Tint;
    colorLMS *= WhiteBalanceToLMSCoeffs(param_1, param_2);
    float3 param_3 = colorLMS;
    float3 _243 = LMSToLinear(param_3);
    result = float4(_243.x, _243.y, _243.z, result.w);
    float midpoint = 0.21763764321804046630859375;
    float3 _258 = ((result.xyz - float3(midpoint)) * buffer._Contrast) + float3(midpoint);
    result = float4(_258.x, _258.y, _258.z, result.w);
    float3 grayscale = float3(dot(result.xyz, float3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)));
    float3 _277 = mix(grayscale, result.xyz, float3(1.0 + buffer._Saturation));
    result = float4(_277.x, _277.y, _277.z, result.w);
    out.o_FragColor = result;
    return out;
}

