#version 300 es

uniform float u_width;
uniform float u_height;
uniform int u_ctrl_count;
uniform vec4 u_ctrl_vec[96];

layout(location = 1) in vec2 attTexcoord0;
layout(location = 0) in vec3 attPosition;
out vec2 textureCoordinate;

vec2 calc_mls()
{
    vec2 fv = attTexcoord0;
    fv.x *= u_width;
    fv.y *= u_height;
    vec2 border[4];
    border[0] = vec2(0.0);
    border[1] = vec2(0.0, u_height);
    border[2] = vec2(u_width, 0.0);
    border[3] = vec2(u_width, u_height);
    float sum_weights = 0.0;
    vec4 p_q_star = vec4(0.0);
    float weights[100];
    for (int i = 0; i < u_ctrl_count; i++)
    {
        vec4 p_q = u_ctrl_vec[i];
        vec2 q_v = p_q.zw - fv;
        q_v *= q_v;
        float w = 1.0 / (((q_v.x + q_v.y) * 0.25) + 500.0);
        sum_weights += w;
        weights[i] = w;
        p_q_star += (p_q * w);
    }
    for (int i_1 = 0; i_1 < 4; i_1++)
    {
        vec2 q_v_1 = border[i_1] - fv;
        q_v_1 *= q_v_1;
        float w_1 = 1.0 / (((q_v_1.x + q_v_1.y) * 0.25) + 500.0);
        sum_weights += w_1;
        weights[96 + i_1] = w_1;
        vec4 border_temp = vec4(border[i_1], border[i_1]);
        p_q_star += (border_temp * w_1);
    }
    p_q_star /= vec4(sum_weights);
    vec2 fv_hat = fv - p_q_star.zw;
    vec2 vr = vec2(0.0);
    float ms = 0.0;
    for (int i_2 = 0; i_2 < u_ctrl_count; i_2++)
    {
        vec4 p_q_1 = u_ctrl_vec[i_2];
        vec4 p_q_hat = p_q_1 - p_q_star;
        float w_2 = weights[i_2];
        vec2 q_hat_rev = vec2(p_q_hat.w, p_q_hat.z);
        vec2 p_hat_q_hat = p_q_hat.xy * p_q_hat.zw;
        vec2 p_hat_q_hat_rev = p_q_hat.xy * q_hat_rev;
        float pxqx_pyqy = p_hat_q_hat.x + p_hat_q_hat.y;
        float pxqy_pyqx = p_hat_q_hat_rev.x - p_hat_q_hat_rev.y;
        vec2 w_fv_hat = fv_hat * w_2;
        vec2 w_fv_hat_rev = vec2(w_fv_hat.y, w_fv_hat.x);
        vec2 pqxy = vec2(pxqy_pyqx, -pxqy_pyqx);
        w_fv_hat *= pxqx_pyqy;
        w_fv_hat_rev *= pqxy;
        vr += (w_fv_hat + w_fv_hat_rev);
        vec2 q_hat = p_q_hat.zw;
        q_hat *= q_hat;
        ms += (w_2 * (q_hat.x + q_hat.y));
    }
    for (int i_3 = 0; i_3 < 4; i_3++)
    {
        vec4 border_temp_1 = vec4(border[i_3], border[i_3]);
        vec4 p_q_hat_1 = border_temp_1 - p_q_star;
        float w_3 = weights[96 + i_3];
        vec2 q_hat_rev_1 = vec2(p_q_hat_1.w, p_q_hat_1.z);
        vec2 p_hat_q_hat_1 = p_q_hat_1.xy * p_q_hat_1.zw;
        vec2 p_hat_q_hat_rev_1 = p_q_hat_1.xy * q_hat_rev_1;
        float pxqx_pyqy_1 = p_hat_q_hat_1.x + p_hat_q_hat_1.y;
        float pxqy_pyqx_1 = p_hat_q_hat_rev_1.x - p_hat_q_hat_rev_1.y;
        vec2 w_fv_hat_1 = fv_hat * w_3;
        vec2 w_fv_hat_rev_1 = vec2(w_fv_hat_1.y, w_fv_hat_1.x);
        vec2 pqxy_1 = vec2(pxqy_pyqx_1, -pxqy_pyqx_1);
        w_fv_hat_1 *= pxqx_pyqy_1;
        w_fv_hat_rev_1 *= pqxy_1;
        vr += (w_fv_hat_1 + w_fv_hat_rev_1);
        vec2 q_hat_1 = p_q_hat_1.zw;
        q_hat_1 *= q_hat_1;
        ms += (w_3 * (q_hat_1.x + q_hat_1.y));
    }
    vec2 v = (vr / vec2(ms)) + p_q_star.xy;
    return v;
}

void main()
{
    gl_Position = vec4(attPosition, 1.0);
    if (u_ctrl_count > 0)
    {
        vec2 v = calc_mls();
        v.x /= u_width;
        v.y /= u_height;
        textureCoordinate = clamp(v, vec2(0.0), vec2(1.0));
    }
    else
    {
        textureCoordinate = clamp(attTexcoord0, vec2(0.0), vec2(1.0));
    }
}

