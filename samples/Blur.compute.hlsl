// Box blur compute shader
#pragma kernel CSMain
#define RADIUS 4

Texture2D<float4> Source;
RWTexture2D<float4> Result;
cbuffer Params : register(b0)
{
    uint2 Size;
    float Strength;
};

[numthreads(8, 8, 1)]
void CSMain(uint3 id : SV_DispatchThreadID)
{
    if (any(id.xy >= Size)) return;
    float4 sum = 0;
    [unroll]
    for (int y = -RADIUS; y <= RADIUS; y++)
        for (int x = -RADIUS; x <= RADIUS; x++)
            sum += Source[id.xy + int2(x, y)];
    float3x3 m = (float3x3)0;
    Result[id.xy] = lerp(Source[id.xy], sum / ((RADIUS * 2 + 1) * (RADIUS * 2 + 1)), Strength);
}
