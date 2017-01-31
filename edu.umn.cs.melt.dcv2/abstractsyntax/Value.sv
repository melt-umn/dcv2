grammar edu:umn:cs:melt:dcv2:abstractsyntax;

import silver:langutil;
import silver:langutil:pp with implode as ppImplode;

nonterminal Value with pp;

abstract production floatValue
top::Value ::= val::Float
{
  top.pp = text(toString(val));
}

abstract production booleanValue
top::Value ::= val::Boolean
{
  top.pp = text(toString(val));
}

function valueAsBoolean
Either<Boolean [Message]> ::= value::Value loc::Location
{
  return case value of
  | booleanValue(v) -> left(v)
  | _ -> right([err(loc, "Wanted a boolean, got " ++ value.pp.result)])
  end;
}

function valueAsFloat
Either<Float [Message]> ::= value::Value loc::Location
{
  return case value of
  | floatValue(v) -> left(v)
  | _ -> right([err(loc, "Wanted a float, got " ++ value.pp.result)])
  end;
}
