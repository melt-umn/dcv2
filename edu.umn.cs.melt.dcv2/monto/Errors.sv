grammar edu:umn:cs:melt:dcv2:monto;

import edu:umn:cs:melt:dcv2:abstractsyntax;
import edu:umn:cs:melt:dcv2:compiler;
import edu:umn:cs:melt:dcv2:concretesyntax;
import lib:json;
import lib:monto:helpers;

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
    else map(messageToError, result.parseTree.ast_Root.errors));
}
