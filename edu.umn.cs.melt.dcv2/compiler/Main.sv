grammar edu:umn:cs:melt:dcv2:compiler;

import core:monad;
import edu:umn:cs:melt:dcv2:abstractsyntax;
import edu:umn:cs:melt:dcv2:concretesyntax;
import silver:langutil;
import silver:langutil:pp;

parser parse::Root_c
{
  edu:umn:cs:melt:dcv2:concretesyntax;
}

function main
IOVal<Integer> ::= args::[String] ioIn::IO
{
  return evalIO(do (bindIO, returnIO) {
    if null(args) then {
      printM("Usage: [dcv2 invocation] [filename]\n");
      return 5;
    } else {
      fileName::String = head(args);
      src::String <- readFileM(fileName);
      result::ParseResult<Root_c> = parse(src, fileName);
      if !result.parseSuccess then {
        printM(result.parseErrors ++ "\n");
        return 2;
      } else {
        ast::Root = result.parseTree.ast_Root;
        printM("pp: " ++ ast.pp.result);
        printM("value: " ++ toString(ast.value));
        return 0;
      }
    }
  }, ioIn);
}