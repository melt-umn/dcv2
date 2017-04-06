grammar edu:umn:cs:melt:dcv2:monto;

import lib:monto:helpers;

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
