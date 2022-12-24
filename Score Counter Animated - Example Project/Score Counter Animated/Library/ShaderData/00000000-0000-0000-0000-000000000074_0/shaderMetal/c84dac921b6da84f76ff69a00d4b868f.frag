#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct buffer_t
{
    float radius;
};

struct main0_out
{
    float4 o_FragColor [[color(0)]];
};

struct main0_in
{
    float2 screenUV;
    float2 orgUV;
};

fragment main0_out main0(main0_in in [[stage_in]], constant buffer_t& buffer, texture2d<float> u_FBOTexture [[texture(0)]], sampler u_FBOTextureSmplr [[sampler(0)]])
{
    main0_out out = {};
    float4 finalColor = u_FBOTexture.sample(u_FBOTextureSmplr, in.screenUV);
    if (length(in.orgUV) < buffer.radius)
    {
        finalColor = mix(finalColor, float4(0.2980000078678131103515625, 0.5759999752044677734375, 0.913999974727630615234375, 0.5), float4(0.5));
    }
    out.o_FragColor = finalColor;
    return out;
}

