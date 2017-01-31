grammar edu:umn:cs:melt:dcv2:concretesyntax;

import edu:umn:cs:melt:dcv2:abstractsyntax;
import silver:langutil;
import silver:langutil:pp with implode as ppImplode;

-- The root nonterminal and associated attributes.

nonterminal Root_c with ast_Root, location, pp;

synthesized attribute ast_Root::Root;

concrete production root_c
top::Root_c ::= e::Expr_c
{
  top.pp = e.pp;
  top.ast_Root = root(e.ast_Expr, location=top.location);
}

-- The expression nonterminal.

nonterminal Expr_c with ast_Expr, location, pp;

synthesized attribute ast_Expr::Expr;

-- Concrete productions for all the infix operators.

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

concrete production parentheses_c
top::Expr_c ::= '(' e::Expr_c ')'
{
  top.pp = parens(e.pp);
  top.ast_Expr = e.ast_Expr;
}

concrete production equal_c
top::Expr_c ::= l::Expr_c '==' r::Expr_c
{
  top.pp = parens(ppImplode(text(" == "), [l.pp, r.pp]));
  top.ast_Expr = equalExpr(l.ast_Expr, r.ast_Expr, location=top.location);
}

concrete production notEqual_c
top::Expr_c ::= l::Expr_c '!=' r::Expr_c
{
  top.pp = parens(ppImplode(text(" != "), [l.pp, r.pp]));
  top.ast_Expr = notEqualExpr(l.ast_Expr, r.ast_Expr, location=top.location);
}

concrete production greaterThan_c
top::Expr_c ::= l::Expr_c '>' r::Expr_c
{
  top.pp = parens(ppImplode(text(" > "), [l.pp, r.pp]));
  top.ast_Expr = greaterThanExpr(l.ast_Expr, r.ast_Expr, location=top.location);
}

concrete production greaterThanEqual_c
top::Expr_c ::= l::Expr_c '>=' r::Expr_c
{
  top.pp = parens(ppImplode(text(" >= "), [l.pp, r.pp]));
  top.ast_Expr = greaterThanEqualExpr(l.ast_Expr, r.ast_Expr, location=top.location);
}

concrete production lessThan_c
top::Expr_c ::= l::Expr_c '<' r::Expr_c
{
  top.pp = parens(ppImplode(text(" < "), [l.pp, r.pp]));
  top.ast_Expr = lessThanExpr(l.ast_Expr, r.ast_Expr, location=top.location);
}

concrete production lessThanEqual_c
top::Expr_c ::= l::Expr_c '<=' r::Expr_c
{
  top.pp = parens(ppImplode(text(" <= "), [l.pp, r.pp]));
  top.ast_Expr = lessThanEqualExpr(l.ast_Expr, r.ast_Expr, location=top.location);
}

-- Concrete production for let and if-then-else expressions.

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
  top.ast_Expr = letExpr(ident, value.ast_Expr, body.ast_Expr, location=top.location);
}

concrete production if_c
top::Expr_c ::= 'if' c::Expr_c 'then' t::Expr_c 'else' e::Expr_c 'end'
{
  top.pp = parens(concat([
    text("if "),
    c.pp,
    text(" then "),
    t.pp,
    text(" else "),
    e.pp,
    text(" end")]));
  top.ast_Expr = ifExpr(c.ast_Expr, t.ast_Expr, e.ast_Expr, location=top.location);
}

-- Literal and Identifier productions.

concrete production identifier_c
top::Expr_c ::= i::Identifier_t
{
  top.pp = text(i.lexeme);
  top.ast_Expr = identifier(i.lexeme, location=i.location);
}

concrete production float_literal_c
top::Expr_c ::= l::Float_Literal_t
{
  top.pp = text(l.lexeme);
  top.ast_Expr = floatLiteralExpr(l.lexeme, location=l.location);
}
