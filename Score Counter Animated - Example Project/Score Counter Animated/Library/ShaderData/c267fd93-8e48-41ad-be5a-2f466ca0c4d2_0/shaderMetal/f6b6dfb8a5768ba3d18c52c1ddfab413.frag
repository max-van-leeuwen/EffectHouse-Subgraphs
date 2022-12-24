#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct main0_out
{
    float4 o_FragColor [[color(0)]];
};

struct main0_in
{
    float2 textureCoordinate;
};

fragment main0_out main0(main0_in in [[stage_in]], texture2d<float> inputImageTexture [[texture(0)]], sampler inputImageTextureSmplr [[sampler(0)]])
{
    main0_out out = {};
    out.o_FragColor = inputImageTexture.sample(inputImageTextureSmplr, in.textureCoordinate);
    return out;
}

