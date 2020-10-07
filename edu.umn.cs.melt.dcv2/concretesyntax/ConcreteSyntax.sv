grammar edu:umn:cs:melt:dcv2:concretesyntax;

import edu:umn:cs:melt:dcv2:abstractsyntax;
import silver:langutil;
import silver:langutil:pp;

-- The root nonterminal and associated attributes.

nonterminal Root_c with ast<Root>, location, pp;

concrete production root_c
top::Root_c ::= e::Expr_c
{
  top.pp = e.pp;
  top.ast = root(e.ast, location=top.location);
}

-- The expression nonterminal.

nonterminal Expr_c with ast<Expr>, location, pp;

-- Concrete productions for all the infix operators.

concrete production add_c
top::Expr_c ::= l::Expr_c '+' r::Expr_c
{
  top.pp = parens(ppImplode(text(" + "), [l.pp, r.pp]));
  top.ast = add(l.ast, r.ast, location=top.location);
}

concrete production sub_c
top::Expr_c ::= l::Expr_c '-' r::Expr_c
{
  top.pp = parens(ppImplode(text(" - "), [l.pp, r.pp]));
  top.ast = sub(l.ast, r.ast, location=top.location);
}

concrete production mul_c
top::Expr_c ::= l::Expr_c '*' r::Expr_c
{
  top.pp = parens(ppImplode(text(" * "), [l.pp, r.pp]));
  top.ast = mul(l.ast, r.ast, location=top.location);
}

concrete production div_c
top::Expr_c ::= l::Expr_c '/' r::Expr_c
{
  top.pp = parens(ppImplode(text(" / "), [l.pp, r.pp]));
  top.ast = div(l.ast, r.ast, location=top.location);
}

concrete production parentheses_c
top::Expr_c ::= '(' e::Expr_c ')'
{
  top.pp = parens(e.pp);
  top.ast = e.ast;
}

concrete production equal_c
top::Expr_c ::= l::Expr_c '==' r::Expr_c
{
  top.pp = parens(ppImplode(text(" == "), [l.pp, r.pp]));
  top.ast = equalExpr(l.ast, r.ast, location=top.location);
}

concrete production notEqual_c
top::Expr_c ::= l::Expr_c '!=' r::Expr_c
{
  top.pp = parens(ppImplode(text(" != "), [l.pp, r.pp]));
  top.ast = notEqualExpr(l.ast, r.ast, location=top.location);
}

concrete production greaterThan_c
top::Expr_c ::= l::Expr_c '>' r::Expr_c
{
  top.pp = parens(ppImplode(text(" > "), [l.pp, r.pp]));
  top.ast = greaterThanExpr(l.ast, r.ast, location=top.location);
}

concrete production greaterThanEqual_c
top::Expr_c ::= l::Expr_c '>=' r::Expr_c
{
  top.pp = parens(ppImplode(text(" >= "), [l.pp, r.pp]));
  top.ast = greaterThanEqualExpr(l.ast, r.ast, location=top.location);
}

concrete production lessThan_c
top::Expr_c ::= l::Expr_c '<' r::Expr_c
{
  top.pp = parens(ppImplode(text(" < "), [l.pp, r.pp]));
  top.ast = lessThanExpr(l.ast, r.ast, location=top.location);
}

concrete production lessThanEqual_c
top::Expr_c ::= l::Expr_c '<=' r::Expr_c
{
  top.pp = parens(ppImplode(text(" <= "), [l.pp, r.pp]));
  top.ast = lessThanEqualExpr(l.ast, r.ast, location=top.location);
}

concrete production and_c
top::Expr_c ::= l::Expr_c '&&' r::Expr_c
{
  top.pp = parens(ppImplode(text(" && "), [l.pp, r.pp]));
  top.ast = andExpr(l.ast, r.ast, location=top.location);
}

concrete production or_c
top::Expr_c ::= l::Expr_c '||' r::Expr_c
{
  top.pp = parens(ppImplode(text(" || "), [l.pp, r.pp]));
  top.ast = orExpr(l.ast, r.ast, location=top.location);
}

concrete production not_c
top::Expr_c ::= '!' e::Expr_c 
{
  top.pp = parens(cat(text("!"), e.pp));
  top.ast = notExpr(e.ast, location=top.location);
}

-- Concrete production for let and if-then-else expressions.

concrete production let_c
top::Expr_c ::= 'let' i::Identifier_t '=' value::Expr_c 'in' body::Expr_c
{
  local ident::String = i.lexeme;
  top.pp = parens(ppConcat([
    text("let "),
    text(ident),
    text(" = "),
    value.pp,
    text(" in "),
    body.pp]));
  top.ast = letExpr(ident, value.ast, body.ast, location=top.location);
}

concrete production if_c
top::Expr_c ::= 'if' c::Expr_c 'then' t::Expr_c 'else' e::Expr_c 'end'
{
  top.pp = parens(ppConcat([
    text("if "),
    c.pp,
    text(" then "),
    t.pp,
    text(" else "),
    e.pp,
    text(" end")]));
  top.ast = ifExpr(c.ast, t.ast, e.ast, location=top.location);
}

-- Literal and Identifier productions.

concrete production identifier_c
top::Expr_c ::= i::Identifier_t
{
  top.pp = text(i.lexeme);
  top.ast = identifierExpr(i.lexeme, location=i.location);
}

concrete production true_c
top::Expr_c ::= l::'true'
{
  top.pp = text(l.lexeme);
  top.ast = literalExpr(booleanValue(true), location=l.location);
}

concrete production false_c
top::Expr_c ::= l::'false'
{
  top.pp = text(l.lexeme);
  top.ast = literalExpr(booleanValue(false), location=l.location);
}

concrete production float_literal_c
top::Expr_c ::= l::Float_Literal_t
{
  top.pp = text(l.lexeme);
  top.ast = literalExpr(floatValue(toFloat(l.lexeme)), location=l.location);
}
