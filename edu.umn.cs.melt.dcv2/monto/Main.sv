grammar edu:umn:cs:melt:dcv2:monto;

import edu:umn:cs:melt:dcv2:abstractsyntax;
import edu:umn:cs:melt:dcv2:compiler;
import edu:umn:cs:melt:dcv2:concretesyntax;
import lib:json;
import silver:support:monto; 
import silver:support:monto:negotiation; 
import lib:monto:helpers;

function main
IOVal<Integer> ::= args::[String] ioIn::IO
{
  local sn :: ServiceNegotiation =
    serviceNegotiation(
      protocolVersion(3, 0, 0),
      softwareVersion(
        "edu.umn.cs.melt.dcv2.monto",
        nothing(),
        nothing(),
        nothing(),
        nothing(),
        nothing()),
      [],
      []);
  local svc :: Service =
    service(sn, [{- TODO -}]);
  local port :: Integer =
    if listLength(args) == 1 then
      toInt(head(args))
    else
      error("Usage: java -jar edu.umn.cs.melt.dcv2.monto <port>");
  return ioval(runService(svc, port, ioIn), 0);
}
