grammar edu:umn:cs:melt:dcv2:abstractsyntax;

import silver:langutil;
import silver:langutil:pp with implode as ppImplode;

nonterminal Root with pp, value;
nonterminal Expr with pp, value;

synthesized attribute value::Float;

abstract production root
top::Root ::= e::Expr
{
  top.pp = e.pp;
  top.value = e.value;
}

-- Operator productions.

abstract production add
top::Expr ::= l::Expr r::Expr
{
  top.pp = parens(ppImplode(text(" + "), [l.pp, r.pp]));
  top.value = l.value + r.value;
}

abstract production sub
top::Expr ::= l::Expr r::Expr
{
  top.pp = parens(ppImplode(text(" - "), [l.pp, r.pp]));
  top.value = l.value - r.value;
}

abstract production mul
top::Expr ::= l::Expr r::Expr
{
  top.pp = parens(ppImplode(text(" * "), [l.pp, r.pp]));
  top.value = l.value * r.value;
}

abstract production div
top::Expr ::= l::Expr r::Expr
{
  top.pp = parens(ppImplode(text(" / "), [l.pp, r.pp]));
  top.value = l.value / r.value;
}

-- Let-expression production.

abstract production binding
top::Expr ::= ident::String value::Expr body::Expr
{
  top.pp = text("LOL, TODO");
  top.value = -1.0;
}

-- Literal and Identifier productions.

abstract production identifier
top::Expr ::= i::String
{
  top.pp = text(i);
  top.value = -1.0; -- TODO
}

abstract production literal
top::Expr ::= l::String
{
  top.pp = text(l);
  top.value = toFloat(l);
}
