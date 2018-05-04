grammar edu:umn:cs:melt:dcv2:monto;

import edu:umn:cs:melt:dcv2:compiler;
import edu:umn:cs:melt:dcv2:concretesyntax;
import silver:json;
import silver:langutil;
import silver:support:monto;
import silver:support:monto:products;
import silver:support:monto:utils;

function mkHighlightingProvider
ServiceProvider ::= colorize::(Maybe<Color> ::= TerminalDescriptor)
{
  local desc :: ProductDescriptor = productDescriptor("highlighting", "dcv2");
  return serviceProvider(desc, processHighlightingProduct(colorize, _, _));
}

function processHighlightingProduct
Pair<Either<[ServiceError] Product> [ServiceNotice]> ::= colorize::(Maybe<Color> ::= TerminalDescriptor) path::String deps::[Product]
{
  local srcIdent :: ProductIdentifier = productIdentifier("source", "dcv2", path);

  local r :: Either<[ServiceError] Product> =
    case mapMaybe((.json), mapMaybe((.productValue), getProduct(srcIdent, deps))) of
    | just(jsonString(src)) -> right(extractHighlightingTokens(colorize, src, path))
    | _ -> left([errorUnmetDependency(srcIdent)])
    end;

  return pair(r, []);
}

function extractHighlightingTokens
Product ::= colorize::(Maybe<Color> ::= TerminalDescriptor) src::String path::String
{
  local terminals :: [TerminalDescriptor] = parse(src, path).parseTerminals;
  local toks :: [HighlightToken] =
    catMaybes(map(makeHighlightingToken(_, colorize), terminals));

  return product(highlightingProduct(toks), [], "dcv2", path);
}

function makeHighlightingToken
Maybe<HighlightToken> ::= td::TerminalDescriptor colorize::(Maybe<Color> ::= TerminalDescriptor)
{
  return case colorize(td) of
  | just(color) -> just(highlightToken(td.terminalLocation.index,
                     td.terminalLocation.endIndex, color))
  | nothing() -> nothing()
  end;
}
