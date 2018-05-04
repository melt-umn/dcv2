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
  return if startsWith("edu:umn:cs:melt:ableC:concretesyntax", n) then
    just(paletteColor(0))
  else if startsWith("edu:umn:cs:melt:exts:ableC:algebraicDataTypes", n) then
    just(paletteColor(1))
  else if startsWith("edu:umn:cs:melt:exts:ableC:cilk", n) then
    just(paletteColor(2))
  else if startsWith("edu:umn:cs:melt:exts:ableC:regex", n) then
    just(paletteColor(3))
  else
    unsafeTrace(nothing(), print("unknown terminal: " ++ n ++ "\n", unsafeIO()));
}
