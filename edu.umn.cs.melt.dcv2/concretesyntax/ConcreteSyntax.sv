grammar edu:umn:cs:melt:dcv2:concretesyntax;

import edu:umn:cs:melt:dcv2:abstractsyntax;
import silver:langutil;
import silver:langutil:pp with implode as ppImplode;

-- The root nonterminal and associated attributes.

closed nonterminal Root_c with ast_Root, bindings, location, pp;

synthesized attribute ast_Root::Root;
synthesized attribute bindings::[Pair<String Expr>];

concrete productions top::Root_c
|
  { top.pp = notext();
    top.bindings = [];
    top.ast_Root = root(top.bindings, location=top.location); }
| h::TopLevel_c t::Root_c
  { top.pp = concat([h.pp, text("\n"), t.pp]);
    top.bindings = h.binding :: t.bindings;
    top.ast_Root = root(top.bindings, location=top.location); }

-- The top-level expression nonterminal and production.

nonterminal TopLevel_c with binding, location, pp;

synthesized attribute binding::Pair<String Expr>;

concrete production toplevel_c
top::TopLevel_c ::= name::Identifier_t '=' value::Expr_c
{
  top.pp = concat([text(name.lexeme), text(" = "), value.pp]);
  top.binding = pair(name.lexeme, value.ast_Expr);
}

-- The expression nonterminal.

nonterminal Expr_c with ast_Expr, location, pp;

synthesized attribute ast_Expr::Expr;

-- Concrete productions for all the mathematical operators.

concrete production add_c
top::Expr_c ::= l::Expr_c '+' r::Expr_c
{
  top.pp = parens(ppImplode(text(" + "), [l.pp, r.pp]));
  top.ast_Expr = add(l.ast_Expr, r.ast_Expr, location=top.location);
}

concrete production sub_c
top::Expr_c ::= l::Expr_c '-' r::Expr_c
{
  top.pp = parens(ppImplode(text(" - "), [l.pp, r.pp]));
  top.ast_Expr = sub(l.ast_Expr, r.ast_Expr, location=top.location);
}

concrete production mul_c
top::Expr_c ::= l::Expr_c '*' r::Expr_c
{
  top.pp = parens(ppImplode(text(" * "), [l.pp, r.pp]));
  top.ast_Expr = mul(l.ast_Expr, r.ast_Expr, location=top.location);
}

concrete production div_c
top::Expr_c ::= l::Expr_c '/' r::Expr_c
{
  top.pp = parens(ppImplode(text(" / "), [l.pp, r.pp]));
  top.ast_Expr = div(l.ast_Expr, r.ast_Expr, location=top.location);
}

-- Concrete production for let expressions.

concrete production let_c
top::Expr_c ::= 'let' i::Identifier_t '=' value::Expr_c 'in' body::Expr_c
{
  local ident::String = i.lexeme;
  top.pp = parens(concat([
    text("let "),
    text(ident),
    text(" = "),
    value.pp,
    text(" in "),
    body.pp]));
  top.ast_Expr = binding(ident, value.ast_Expr, body.ast_Expr, location=top.location);
}

-- Literal and Identifier productions.

concrete production identifier_c
top::Expr_c ::= i::Identifier_t
{
  top.pp = text(i.lexeme);
  top.ast_Expr = identifier(i.lexeme, location=i.location);
}

concrete production literal_c
top::Expr_c ::= l::Literal_t
{
  top.pp = text(l.lexeme);
  top.ast_Expr = literal(l.lexeme, location=l.location);
}
