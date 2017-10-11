grammar edu:umn:cs:melt:dcv2:abstractsyntax;

import silver:langutil;
import silver:langutil:pp;

nonterminal Root with env, errors, location, pp, value;
nonterminal Expr with env, errors, location, pp, value;

inherited attribute env::[Pair<String Value>];
synthesized attribute errors::[Message];
synthesized attribute value::Value;

abstract production root
top::Root ::= e::Expr
{
  e.env = [];
  top.errors = e.errors;
  top.pp = e.pp;
  top.value = e.value;
}

-- Operator productions.

abstract production add
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = mathOp(l.value, r.value,
    \x::Float y::Float -> x + y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" + "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production sub
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = mathOp(l.value, r.value,
    \x::Float y::Float -> x - y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" - "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production mul
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = mathOp(l.value, r.value,
    \x::Float y::Float -> x * y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" * "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production div
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = mathOp(l.value, r.value,
    \x::Float y::Float -> x / y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" / "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production equalExpr
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = relOp(l.value, r.value,
    \x::Float y::Float -> x == y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" == "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production notEqualExpr
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = relOp(l.value, r.value,
    \x::Float y::Float -> x != y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" != "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production greaterThanExpr
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = relOp(l.value, r.value,
    \x::Float y::Float -> x > y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" > "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production greaterThanEqualExpr
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = relOp(l.value, r.value,
    \x::Float y::Float -> x >= y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" >= "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production lessThanExpr
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = relOp(l.value, r.value,
    \x::Float y::Float -> x < y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" < "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production lessThanEqualExpr
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = relOp(l.value, r.value,
    \x::Float y::Float -> x <= y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" <= "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production andExpr
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = logOp(l.value, r.value,
    \x::Boolean y::Boolean -> x && y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" && "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production orExpr
top::Expr ::= l::Expr r::Expr
{
  local val :: Either<Value [Message]> = logOp(l.value, r.value,
    \x::Boolean y::Boolean -> x || y,
    top.location);
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors ++ toRightOr(val, []);
  top.pp = parens(ppImplode(text(" || "), [l.pp, r.pp]));
  top.value = toLeft(val);
}

abstract production notExpr
top::Expr ::= e::Expr
{
  local val :: Either<Value [Message]> =
    case valueAsBoolean(e.value, e.location) of
    | left(b) -> left(booleanValue(!b))
    | right(errs) -> right(errs)
    end;
  e.env = top.env;
  top.errors = e.errors ++ toRightOr(val, []);
  top.pp = parens(cat(text("!"), e.pp));
  top.value = toLeft(val);
}

-- Let-expression and if-then-else production.

abstract production letExpr
top::Expr ::= ident::String value::Expr body::Expr
{
  value.env = top.env;
  body.env = pair(ident, value.value) :: top.env;
  top.errors = value.errors ++ body.errors;
  top.pp = parens(ppConcat([
    text("let "),
    text(ident),
    text(" = "),
    value.pp,
    text(" in "),
    body.pp]));
  top.value = body.value;
}

abstract production ifExpr
top::Expr ::= c::Expr t::Expr e::Expr
{
  local cond :: Either<Boolean [Message]> = valueAsBoolean(c.value, c.location);

  c.env = top.env;
  t.env = top.env;
  e.env = top.env;

  local typeErrors :: [Message] = toRightOr(cond, []);
  -- TODO Enforce then and else having same type.
  top.errors = c.errors ++ t.errors ++ e.errors ++ typeErrors;

  top.pp = parens(ppConcat([
    text("if "),
    c.pp,
    text(" then "),
    t.pp,
    text(" else "),
    e.pp,
    text(" end")]));

  top.value = if toLeft(cond)
              then t.value
              else e.value;
}

-- Literal and Identifier productions.

abstract production identifierExpr
top::Expr ::= i::String
{
  local binding::Maybe<Pair<String Value>> = find(\p::Pair<String Value> -> p.fst == i, top.env);
  top.errors = if binding.isJust then []
               else [err(top.location, "Unknown binding: " ++ i)];
  top.pp = text(i);
  top.value = binding.fromJust.snd;
}

abstract production literalExpr
top::Expr ::= v::Value
{
  top.errors = [];
  top.pp = v.pp;
  top.value = v;
}
