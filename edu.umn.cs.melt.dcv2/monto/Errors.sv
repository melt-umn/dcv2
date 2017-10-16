grammar edu:umn:cs:melt:dcv2:monto;

import edu:umn:cs:melt:dcv2:abstractsyntax;
import edu:umn:cs:melt:dcv2:compiler;
import edu:umn:cs:melt:dcv2:concretesyntax;
import silver:json;
import silver:support:monto;
import silver:support:monto:products;
import silver:support:monto:utils;

function mkErrorProvider
ServiceProvider ::=
{
  local desc :: ProductDescriptor = productDescriptor("errors", "dcv2");
  return serviceProvider(desc, processErrorProduct);
}

function processErrorProduct
Pair<Either<[ServiceError] Product> [ServiceNotice]> ::= path::String deps::[Product]
{
  local srcIdent :: ProductIdentifier = productIdentifier("source", "dcv2", path);
  return case mapMaybe((.json), mapMaybe((.productValue), getProduct(srcIdent, deps))) of
    | just(jsonString(src)) -> let
        result :: ParseResult<Root_c> = parse(src, path)
      in if !result.parseSuccess then
        case result.parseError of
          | syntaxError(s, l, _, _) -> let
            err :: Error = byteRangeError(
              l.index,
              l.endIndex,
              s, severityError())
          in
            pair(right(product(errorsProduct([err]), [], "dcv2", path)), [])
          end
          | _ -> error("TODO")
        end
      else let
        errs :: [Error] = map(messageError, result.parseTree.ast_Root.errors)
      in
        pair(right(product(errorsProduct(errs), [], "dcv2", path)), [])
      end end
    | _ -> pair(left([errorUnmetDependency(srcIdent)]), [])
  end;
}
