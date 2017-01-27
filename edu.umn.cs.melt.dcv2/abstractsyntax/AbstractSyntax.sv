grammar edu:umn:cs:melt:dcv2:abstractsyntax;

import silver:langutil;
import silver:langutil:pp with implode as ppImplode;

nonterminal Root with env, errors, location, pp, value;
nonterminal Expr with env, errors, location, pp, value;

inherited attribute env::[Pair<String Float>];
synthesized attribute errors::[Message];
synthesized attribute value::Float;

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
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors;
  top.pp = parens(ppImplode(text(" + "), [l.pp, r.pp]));
  top.value = l.value + r.value;
}

abstract production sub
top::Expr ::= l::Expr r::Expr
{
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors;
  top.pp = parens(ppImplode(text(" - "), [l.pp, r.pp]));
  top.value = l.value - r.value;
}

abstract production mul
top::Expr ::= l::Expr r::Expr
{
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors;
  top.pp = parens(ppImplode(text(" * "), [l.pp, r.pp]));
  top.value = l.value * r.value;
}

abstract production div
top::Expr ::= l::Expr r::Expr
{
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors;
  top.pp = parens(ppImplode(text(" / "), [l.pp, r.pp]));
  top.value = l.value / r.value;
}

-- Semicolon production.

-- TODO What is the point of this, actually, without having side-effects?
-- TODO How to implement side-effects? Inherited attribute that's an IoMonad<Float>?
-- TODO Name this `sequence`?
abstract production semicolon
top::Expr ::= l::Expr r::Expr
{
  l.env = top.env;
  r.env = top.env;
  top.errors = l.errors ++ r.errors;
  top.pp = parens(ppImplode(text("; "), [l.pp, r.pp]));
  top.value = r.value;
}

-- Let-expression production.

abstract production binding
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

-- Literal and Identifier productions.

abstract production identifier
top::Expr ::= i::String
{
  local binding::Maybe<Pair<String Float>> = find(\p::Pair<String Float> -> p.fst == i, top.env);
  top.errors = if binding.isJust then []
               else [err(top.location, "Unknown binding: " ++ i)];
  top.pp = text(i);
  top.value = binding.fromJust.snd;
}

abstract production literal
top::Expr ::= l::String
{
  top.errors = [];
  top.pp = text(l);
  top.value = toFloat(l);
}
