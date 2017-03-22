grammar edu:umn:cs:melt:dcv2:monto;

import edu:umn:cs:melt:dcv2:compiler;
import edu:umn:cs:melt:dcv2:concretesyntax;
import lib:json;
import lib:monto; 
import lib:monto:helpers;

function main
IOVal<Integer> ::= args::[String] ioIn::IO
{
  local cfg :: Config = config(
    "127.0.0.1",
    "edu.umn.cs.melt.dcv2",
    "dcv2",
    "A simple example language.",
    [ sourceDependency("dcv2")
    ],
    [ productDescription("dcv2", "length")
    , productDescription("dcv2", "errors")
    ]);
  return ioval(runMonto(cfg, callback, ioIn), 0);
}

global callbacks :: [Pair<String (Json ::= String String)>] =
  [ pair("errors", errorCallback)
  , pair("length", lengthCallback)
  ];

function callback
[Product] ::= req::Request
{
  local srcRqmt :: Requirement = head(req.requirements);
  return map(\p::Pair<String (Json ::= String String)> ->
    product(
      srcRqmt.id,
      req.source,
      req.serviceId,
      p.fst,
      "dcv2",
      p.snd(srcRqmt.contents, srcRqmt.source.physicalName)),
    callbacks);
}

function errorCallback
Json ::= src::String fileName::String
{
  local result :: ParseResult<Root_c> = parse(src, fileName);
  return jsonArray(if !result.parseSuccess
    then case result.parseError of
         | syntaxError(s, l, _, _) -> [errorProduct(
             l.index,
             l.endIndex - l.index,
             errorLevelError(),
             "parser",
             s)]
         | _ -> error("TODO")
         end
    else []);
}

function lengthCallback
Json ::= src::String fileName::String
{
  return jsonInteger(length(src));
}
