grammar edu:umn:cs:melt:dcv2:monto;

import edu:umn:cs:melt:dcv2:abstractsyntax;
import edu:umn:cs:melt:dcv2:compiler;
import edu:umn:cs:melt:dcv2:concretesyntax;
import silver:json;
import silver:support:monto; 
import silver:support:monto:negotiation; 
import silver:support:monto:products; 

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
      [ productDescriptor("errors", "dcv2")
      ]);
  local svc :: Service =
    service(sn, [mkErrorProvider()]);
  local port :: Integer =
    if listLength(args) == 1 then
      toInt(head(args))
    else
      error("Usage: java -jar edu.umn.cs.melt.dcv2.monto <port>");
  return ioval(runService(svc, port, ioIn), 0);
}
