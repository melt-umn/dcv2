grammar edu:umn:cs:melt:dcv2:abstractsyntax;

import silver:langutil;

-- Either functions

function bothE
Either<Pair<a b> [c]> ::= x::Either<a [c]> y::Either<b [c]>
{
  return case pair(x, y) of
  | pair(left(x), left(y))   -> left(pair(x, y))
  | pair(left(x), right(y))  -> right(y)
  | pair(right(x), left(y))  -> right(x)
  | pair(right(x), right(y)) -> right(x ++ y)
  end;
}

function toLeft
a ::= e::Either<a b>
{
  return case e of
  | left(a) -> a
  end;
}

function toLeftOr
a ::= e::Either<a b> o::a
{
  return case e of
  | left(a) -> a
  | right(_) -> o
  end;
}

function toRight
b ::= e::Either<a b>
{
  return case e of
  | right(b) -> b
  end;
}

function toRightOr
b ::= e::Either<a b> o::b
{
  return case e of
  | left(_) -> o
  | right(b) -> b
  end;
}

-- List functions

function find
Maybe<a> ::= f::(Boolean ::= a) l::[a]
{
  return if null(l) then nothing()
         else if f(head(l)) then just(head(l))
         else find(f, tail(l));
}

-- Value functions

function logOp
Either<Value [Message]> ::= l::Value r::Value f::(Boolean ::= Boolean Boolean) loc::Location
{
  return case bothE(valueAsBoolean(l, loc), valueAsBoolean(r, loc)) of
  | left(pair(l, r)) -> left(booleanValue(f(l, r)))
  | right(errs) -> right(errs)
  end;
}

function mathOp
Either<Value [Message]> ::= l::Value r::Value f::(Float ::= Float Float) loc::Location
{
  return case bothE(valueAsFloat(l, loc), valueAsFloat(r, loc)) of
  | left(pair(l, r)) -> left(floatValue(f(l, r)))
  | right(errs) -> right(errs)
  end;
}

function relOp
Either<Value [Message]> ::= l::Value r::Value f::(Boolean ::= Float Float) loc::Location
{
  return case bothE(valueAsFloat(l, loc), valueAsFloat(r, loc)) of
  | left(pair(l, r)) -> left(booleanValue(f(l, r)))
  | right(errs) -> right(errs)
  end;
}
