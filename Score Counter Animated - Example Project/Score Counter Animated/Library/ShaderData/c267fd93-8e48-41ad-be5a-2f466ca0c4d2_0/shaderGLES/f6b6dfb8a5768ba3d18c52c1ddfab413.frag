#version 300 es
precision highp float;
precision highp int;

uniform mediump sampler2D inputImageTexture;

layout(location = 0) out mediump vec4 o_FragColor;
in mediump vec2 textureCoordinate;

void main()
{
    o_FragColor = texture(inputImageTexture, textureCoordinate);
}

