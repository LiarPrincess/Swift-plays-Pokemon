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
  // use this to display texcoords:
  //  float x = interpolated.texcoord.x;
  //  float y = interpolated.texcoord.y;
  //  return half4(x, y, 0.0, 1.0);

  float value = tex2D.sample(sampler2D, interpolated.texcoord).r;
  return half4(value, value, value, 1.0);
}
