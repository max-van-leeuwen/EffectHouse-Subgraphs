#version 300 es
precision highp float;
precision highp int;

uniform mediump sampler2D u_FBOTexture;
uniform float radius;

in vec2 screenUV;
in vec2 orgUV;
layout(location = 0) out vec4 o_FragColor;

void main()
{
    mediump vec4 finalColor = texture(u_FBOTexture, screenUV);
    if (length(orgUV) < radius)
    {
        finalColor = mix(finalColor, vec4(0.2980000078678131103515625, 0.5759999752044677734375, 0.913999974727630615234375, 0.5), vec4(0.5));
    }
    o_FragColor = finalColor;
}

