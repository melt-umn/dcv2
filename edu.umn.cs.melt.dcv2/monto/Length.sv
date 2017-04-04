grammar edu:umn:cs:melt:dcv2:monto;

import lib:json;

function lengthCallback
Json ::= src::String fileName::String
{
  return jsonInteger(length(src));
}
