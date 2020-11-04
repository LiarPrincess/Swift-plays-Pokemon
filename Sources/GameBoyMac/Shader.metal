// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include <metal_stdlib>
using namespace metal;

constexpr sampler sampler2D = sampler(coord::normalized, filter::nearest);

struct VertexOut
{
  float4 position [[ position ]];
  float2 texcoord;
};

vertex VertexOut vertex_shader(const device float2* vertexArray [[ buffer(0) ]],
                               unsigned int         vid         [[ vertex_id ]])
{
  VertexOut out;
  out.position = float4(vertexArray[vid], 0.0, 1.0);
  out.texcoord = float2((vertexArray[vid] + 1) * 0.5);
  out.texcoord.y = 1.0 - out.texcoord.y; // so we start in upper left corner
  return out;
}


fragment half4 fragment_shader(VertexOut          interpolated [[ stage_in ]],
                               texture2d<ushort>  tex2D        [[ texture(0) ]])
{
  // GameBoy uses:
  // 0 - White
  // 1 - Light gray
  // 2 - Dark gray
  // 3 - Black
  // We need to 'correct' this.

  float raw = tex2D.sample(sampler2D, interpolated.texcoord).r;
  float corrected = 3 - raw;
  float rgb = corrected * 0.33; // to convert to <0, 1> space

  return half4(rgb, rgb, rgb, 1.0);
}
