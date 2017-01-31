grammar edu:umn:cs:melt:dcv2:abstractsyntax;

import silver:langutil;

-- Either functions

function allE
Either<c b> ::= es::[Either<a b>] f::(c ::= [a])
{
  return allEHelper(es, [], f);
}

function allEHelper
Either<c b> ::= es::[Either<a b>] l::[a] f::(c ::= [a])
{
  return case es of
  | [] -> left(f(l))
  | left(x) :: rest -> allEHelper(rest, x::l, f)
  | right(e) :: _ -> right(e)
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

function mathOp
Either<Value [Message]> ::= l::[Value] f::(Float ::= Float Float) i::Float loc::Location
{
  return case allE(map(\v::Value -> valueAsFloat(v, loc), l), \l::[Float] -> foldr(f, i, l)) of
  | left(val) -> left(floatValue(val))
  | right(e) -> right(e)
  end;
}
