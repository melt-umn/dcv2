grammar edu:umn:cs:melt:dcv2:abstractsyntax;

import core:monad;
import silver:langutil;
import silver:langutil:pp with implode as ppImplode;

nonterminal Root with env, errors, location, pp, value;
nonterminal Expr with env, errors, location, pp, value;

inherited attribute env::[Pair<String Float>];
synthesized attribute errors::[Message];
synthesized attribute value::Float;

abstract production root
top::Root ::= bs::[Pair<String Expr>]
{
  local mainBinding::Maybe<Pair<String Expr>> = find(\p::Pair<String Expr> -> p.fst == "main", bs);
  local exprErrs::[Message] = bindList(bs, \b::Pair<String Expr> -> b.snd.errors);
  local env::[Pair<String Float>] = map(\b::Pair<String Expr> -> pair(b.fst, b.snd.value), bs);
  -- TODO How to pass env to children?
  top.errors = if mainBinding.isJust then exprErrs
               else err(builtinLoc("edu:umn:cs:melt:dcv2"), "Cannot find the main binding.") :: exprErrs;
  top.pp = ppImplode(text("\n"), map(\b::Pair<String Expr> -> concat([text(b.fst), text(" = "), b.snd.pp]), bs));
  top.value = mainBinding.fromJust.snd.value;
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
