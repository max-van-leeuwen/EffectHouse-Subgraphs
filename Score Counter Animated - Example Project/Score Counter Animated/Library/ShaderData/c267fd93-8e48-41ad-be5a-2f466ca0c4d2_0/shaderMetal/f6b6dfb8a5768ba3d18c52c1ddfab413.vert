#pragma clang diagnostic ignored "-Wmissing-prototypes"
#pragma clang diagnostic ignored "-Wmissing-braces"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

template<typename T, size_t Num>
struct spvUnsafeArray
{
    T elements[Num ? Num : 1];
    
    thread T& operator [] (size_t pos) thread
    {
        return elements[pos];
    }
    constexpr const thread T& operator [] (size_t pos) const thread
    {
        return elements[pos];
    }
    
    device T& operator [] (size_t pos) device
    {
        return elements[pos];
    }
    constexpr const device T& operator [] (size_t pos) const device
    {
        return elements[pos];
    }
    
    constexpr const constant T& operator [] (size_t pos) const constant
    {
        return elements[pos];
    }
    
    threadgroup T& operator [] (size_t pos) threadgroup
    {
        return elements[pos];
    }
    constexpr const threadgroup T& operator [] (size_t pos) const threadgroup
    {
        return elements[pos];
    }
};

struct buffer_t
{
    float u_width;
    float u_height;
    int u_ctrl_count;
    spvUnsafeArray<float4, 96> u_ctrl_vec;
};

struct main0_out
{
    float2 textureCoordinate;
    float4 gl_Position [[position]];
};

struct main0_in
{
    float3 attPosition [[attribute(0)]];
    float2 attTexcoord0 [[attribute(1)]];
};

static inline __attribute__((always_inline))
float2 calc_mls(thread float2& attTexcoord0, constant float& u_width, constant float& u_height, constant int& u_ctrl_count, constant spvUnsafeArray<float4, 96>& u_ctrl_vec)
{
    float2 fv = attTexcoord0;
    fv.x *= u_width;
    fv.y *= u_height;
    spvUnsafeArray<float2, 4> border;
    border[0] = float2(0.0);
    border[1] = float2(0.0, u_height);
    border[2] = float2(u_width, 0.0);
    border[3] = float2(u_width, u_height);
    float sum_weights = 0.0;
    float4 p_q_star = float4(0.0);
    spvUnsafeArray<float, 100> weights;
    for (int i = 0; i < u_ctrl_count; i++)
    {
        float4 p_q = u_ctrl_vec[i];
        float2 q_v = p_q.zw - fv;
        q_v *= q_v;
        float w = 1.0 / (((q_v.x + q_v.y) * 0.25) + 500.0);
        sum_weights += w;
        weights[i] = w;
        p_q_star += (p_q * w);
    }
    for (int i_1 = 0; i_1 < 4; i_1++)
    {
        float2 q_v_1 = border[i_1] - fv;
        q_v_1 *= q_v_1;
        float w_1 = 1.0 / (((q_v_1.x + q_v_1.y) * 0.25) + 500.0);
        sum_weights += w_1;
        weights[96 + i_1] = w_1;
        float4 border_temp = float4(border[i_1], border[i_1]);
        p_q_star += (border_temp * w_1);
    }
    p_q_star /= float4(sum_weights);
    float2 fv_hat = fv - p_q_star.zw;
    float2 vr = float2(0.0);
    float ms = 0.0;
    for (int i_2 = 0; i_2 < u_ctrl_count; i_2++)
    {
        float4 p_q_1 = u_ctrl_vec[i_2];
        float4 p_q_hat = p_q_1 - p_q_star;
        float w_2 = weights[i_2];
        float2 q_hat_rev = float2(p_q_hat.w, p_q_hat.z);
        float2 p_hat_q_hat = p_q_hat.xy * p_q_hat.zw;
        float2 p_hat_q_hat_rev = p_q_hat.xy * q_hat_rev;
        float pxqx_pyqy = p_hat_q_hat.x + p_hat_q_hat.y;
        float pxqy_pyqx = p_hat_q_hat_rev.x - p_hat_q_hat_rev.y;
        float2 w_fv_hat = fv_hat * w_2;
        float2 w_fv_hat_rev = float2(w_fv_hat.y, w_fv_hat.x);
        float2 pqxy = float2(pxqy_pyqx, -pxqy_pyqx);
        w_fv_hat *= pxqx_pyqy;
        w_fv_hat_rev *= pqxy;
        vr += (w_fv_hat + w_fv_hat_rev);
        float2 q_hat = p_q_hat.zw;
        q_hat *= q_hat;
        ms += (w_2 * (q_hat.x + q_hat.y));
    }
    for (int i_3 = 0; i_3 < 4; i_3++)
    {
        float4 border_temp_1 = float4(border[i_3], border[i_3]);
        float4 p_q_hat_1 = border_temp_1 - p_q_star;
        float w_3 = weights[96 + i_3];
        float2 q_hat_rev_1 = float2(p_q_hat_1.w, p_q_hat_1.z);
        float2 p_hat_q_hat_1 = p_q_hat_1.xy * p_q_hat_1.zw;
        float2 p_hat_q_hat_rev_1 = p_q_hat_1.xy * q_hat_rev_1;
        float pxqx_pyqy_1 = p_hat_q_hat_1.x + p_hat_q_hat_1.y;
        float pxqy_pyqx_1 = p_hat_q_hat_rev_1.x - p_hat_q_hat_rev_1.y;
        float2 w_fv_hat_1 = fv_hat * w_3;
        float2 w_fv_hat_rev_1 = float2(w_fv_hat_1.y, w_fv_hat_1.x);
        float2 pqxy_1 = float2(pxqy_pyqx_1, -pxqy_pyqx_1);
        w_fv_hat_1 *= pxqx_pyqy_1;
        w_fv_hat_rev_1 *= pqxy_1;
        vr += (w_fv_hat_1 + w_fv_hat_rev_1);
        float2 q_hat_1 = p_q_hat_1.zw;
        q_hat_1 *= q_hat_1;
        ms += (w_3 * (q_hat_1.x + q_hat_1.y));
    }
    float2 v = (vr / float2(ms)) + p_q_star.xy;
    return v;
}

vertex main0_out main0(main0_in in [[stage_in]], constant buffer_t& buffer)
{
    main0_out out = {};
    out.gl_Position = float4(in.attPosition, 1.0);
    if (buffer.u_ctrl_count > 0)
    {
        float2 v = calc_mls(in.attTexcoord0, buffer.u_width, buffer.u_height, buffer.u_ctrl_count, buffer.u_ctrl_vec);
        v.x /= buffer.u_width;
        v.y /= buffer.u_height;
        out.textureCoordinate = fast::clamp(v, float2(0.0), float2(1.0));
    }
    else
    {
        out.textureCoordinate = fast::clamp(in.attTexcoord0, float2(0.0), float2(1.0));
    }
    out.gl_Position.z = (out.gl_Position.z + out.gl_Position.w) * 0.5;       // Adjust clip-space for Metal
    return out;
}

