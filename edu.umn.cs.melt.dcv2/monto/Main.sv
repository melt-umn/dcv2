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

global defaultStyle :: Font =
  font(nothing(),
       nothing(),
       nothing(),
       nothing(),
       nothing(),
       nothing(),
       nothing());
global styles :: [Pair<String Font>] =
  [ pair("edu:umn:cs:melt:dcv2:concretesyntax:COMMENT", font(
      just(color(0, 255, 0)),
      nothing(),
      nothing(),
      nothing(),
      nothing(),
      nothing(),
      nothing()))
  , pair("edu:umn:cs:melt:dcv2:concretesyntax:IDENTIFIER", font(
      just(color(0, 0, 255)),
      nothing(),
      nothing(),
      nothing(),
      nothing(),
      nothing(),
      nothing()))
  , pair("edu:umn:cs:melt:dcv2:concretesyntax:KEYWORD", font(
      just(color(0, 0, 255)),
      nothing(),
      nothing(),
      nothing(),
      just("bold"),
      nothing(),
      nothing()))
  , pair("edu:umn:cs:melt:dcv2:concretesyntax:LITERAL", font(
      just(color(255, 0, 0)),
      nothing(),
      nothing(),
      nothing(),
      nothing(),
      nothing(),
      nothing()))
  , pair("edu:umn:cs:melt:dcv2:concretesyntax:OPERATOR", font(
      nothing(),
      nothing(),
      nothing(),
      nothing(),
      just("bold"),
      nothing(),
      nothing()))
  ];

function highlight
Font ::= td::TerminalDescriptor
{
  -- TODO This helper is really yucky.
  local helper :: (Boolean ::= Pair<String Font>)
    = \p::Pair<String Font> -> containsBy(
      \a::String b::String -> a == b,
      p.fst, td.lexerClasses);
  return case filter(helper, styles) of
  | [] -> defaultStyle
  | l  -> head(l).snd
  end;
}

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
