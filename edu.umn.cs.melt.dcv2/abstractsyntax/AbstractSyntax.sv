grammar edu:umn:cs:melt:dcv2:abstractsyntax;

import silver:langutil;
import silver:langutil:pp with implode as ppImplode;

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
  local val :: Either<Value [Message]> = mathOp([l.value, r.value],
    \x::Float y::Float -> x + y,
    0.0,
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
  local val :: Either<Value [Message]> = mathOp([l.value, r.value],
    \x::Float y::Float -> x - y,
    0.0,
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
  local val :: Either<Value [Message]> = mathOp([l.value, r.value],
    \x::Float y::Float -> x * y,
    1.0,
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
  local val :: Either<Value [Message]> = mathOp([l.value, r.value],
    \x::Float y::Float -> x / y,
    1.0,
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
  -- TODO
}

abstract production notEqualExpr
top::Expr ::= l::Expr r::Expr
{
  -- TODO
}

abstract production greaterThanExpr
top::Expr ::= l::Expr r::Expr
{
  -- TODO
}

abstract production greaterThanEqualExpr
top::Expr ::= l::Expr r::Expr
{
  -- TODO
}

abstract production lessThanExpr
top::Expr ::= l::Expr r::Expr
{
  -- TODO
}

abstract production lessThanEqualExpr
top::Expr ::= l::Expr r::Expr
{
  -- TODO
}

-- Let-expression and if-then-else production.

abstract production letExpr
top::Expr ::= ident::String value::Expr body::Expr
{
  value.env = top.env;
  body.env = pair(ident, value.value) :: top.env;
  top.errors = value.errors ++ body.errors;
  top.pp = parens(concat([
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
  -- TODO
}

-- Literal and Identifier productions.

abstract production identifier
top::Expr ::= i::String
{
  local binding::Maybe<Pair<String Value>> = find(\p::Pair<String Value> -> p.fst == i, top.env);
  top.errors = if binding.isJust then []
               else [err(top.location, "Unknown binding: " ++ i)];
  top.pp = text(i);
  top.value = binding.fromJust.snd;
}

abstract production floatLiteralExpr
top::Expr ::= l::String
{
  top.errors = [];
  top.pp = text(l);
  top.value = floatValue(toFloat(l));
}
