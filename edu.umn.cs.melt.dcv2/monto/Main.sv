grammar edu:umn:cs:melt:dcv2:monto;

import edu:umn:cs:melt:dcv2:abstractsyntax;
import edu:umn:cs:melt:dcv2:compiler;
import edu:umn:cs:melt:dcv2:concretesyntax;
import silver:json;
import silver:support:monto; 
import silver:support:monto:negotiation; 
import silver:support:monto:products; 
import silver:support:monto:utils;

function main
IOVal<Integer> ::= args::[String] ioIn::IO
{
  local port :: Integer =
    if listLength(args) == 1 then
      toInt(head(args))
    else
      error("Usage: java -jar edu.umn.cs.melt.dcv2.monto <port>");

  local version :: SoftwareVersion =
    softwareVersion(
      "edu.umn.cs.melt.dcv2.monto",
      nothing(),
      nothing(),
      nothing(),
      nothing(),
      nothing());
  local providers :: [ServiceProvider] =
    [ mkErrorProvider()
    , mkHighlightingProvider(colorize)
    ];

  local svc :: Service = simpleService(version, providers);
  return ioval(runService(svc, port, ioIn), 0);
}

function colorize
Maybe<Color> ::= td::TerminalDescriptor
{
  local n :: String = td.terminalName;
  return case td.terminalName of
  | "edu:umn:cs:melt:dcv2:concretesyntax:And_t" -> just(keywordColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Bind_t" -> just(keywordColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Else_t" -> just(keywordColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:End_t" -> just(keywordColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:False_t" -> just(literalColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Float_Literal_t" -> just(literalColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Identifier_t" -> just(identifierColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:If_t" -> just(keywordColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:In_t" -> just(keywordColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:LParen_t" -> just(punctuationColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:LessThan_t" -> just(punctuationColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Let_t" -> just(keywordColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Multiply_t" -> just(punctuationColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Not_t" -> just(keywordColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Or_t" -> just(keywordColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Plus_t" -> just(punctuationColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:RParen_t" -> just(punctuationColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Then_t" -> just(keywordColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:True_t" -> just(literalColor())
  | "edu:umn:cs:melt:dcv2:concretesyntax:Whitespace_t" -> nothing()
  | n -> unsafeTrace(nothing(), print("unknown terminal: " ++ n ++ "\n", unsafeIO()))
  end;
}
