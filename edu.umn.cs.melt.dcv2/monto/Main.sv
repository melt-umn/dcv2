grammar edu:umn:cs:melt:dcv2:monto;

import edu:umn:cs:melt:dcv2:abstractsyntax;
import edu:umn:cs:melt:dcv2:compiler;
import edu:umn:cs:melt:dcv2:concretesyntax;
import lib:json;
import lib:monto; 
import lib:monto:helpers;

global callbacks :: [Pair<String (Json ::= String String)>] =
  [ pair("errors", errorCallback)
  , pair("highlighting", makeHighlightingCallback(parse, highlight))
  , pair("length", lengthCallback)
  ];

function callbackPairToName
ProductDescription ::= p::Pair<String (Json ::= String String)>
{
  return productDescription("dcv2", p.fst);
}

function main
IOVal<Integer> ::= args::[String] ioIn::IO
{
  local cfg :: Config = config(
    "127.0.0.1",
    "edu.umn.cs.melt.dcv2",
    "dcv2",
    "A simple example language.",
    [ sourceDependency("dcv2") ],
    map(callbackPairToName, callbacks));
  return ioval(runMonto(cfg, callback, ioIn), 0);
}

function callback
[MontoMessage] ::= req::Request
{
  local srcRqmt :: Requirement = head(req.requirements);
  return map(\p::Pair<String (Json ::= String String)> ->
    productMessage(product(
      srcRqmt.id,
      req.source,
      req.serviceId,
      p.fst,
      "dcv2",
      p.snd(srcRqmt.contents, srcRqmt.source.physicalName))),
    callbacks);
}
