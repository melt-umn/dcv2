grammar edu:umn:cs:melt:dcv2:concretesyntax;

import edu:umn:cs:melt:dcv2:abstractsyntax;
import silver:langutil;
import silver:langutil:pp with implode as ppImplode;

nonterminal Root_c with ast_Root, location, pp;

synthesized attribute ast_Root::Root;

concrete production root_c
top::Root_c ::= e::Expr_c
{
  top.pp = e.pp;
  top.ast_Root = root(e.ast_Expr, location=top.location);
}

synthesized attribute ast_Expr::Expr;

nonterminal Expr_c with ast_Expr, location, pp;
nonterminal Term_c with ast_Expr, location, pp;
nonterminal Factor_c with ast_Expr, location, pp;

-- Conversion productions.

concrete production exprTerm_c
top::Expr_c ::= t::Term_c
{
  top.pp = t.pp;
  top.ast_Expr = t.ast_Expr;
}

concrete production termFactor_c
top::Term_c ::= f::Factor_c
{
  top.pp = f.pp;
  top.ast_Expr = f.ast_Expr;
}

-- Concrete productions for all the mathematical operators.

concrete production add_c
top::Expr_c ::= e::Expr_c '+' t::Term_c
{
  top.pp = parens(ppImplode(text(" + "), [e.pp, t.pp]));
  top.ast_Expr = add(e.ast_Expr, t.ast_Expr, location=top.location);
}

concrete production sub_c
top::Expr_c ::= e::Expr_c '-' t::Term_c
{
  top.pp = parens(ppImplode(text(" - "), [e.pp, t.pp]));
  top.ast_Expr = sub(e.ast_Expr, t.ast_Expr, location=top.location);
}

concrete production mul_c
top::Term_c ::= t::Term_c '*' f::Factor_c
{
  top.pp = parens(ppImplode(text(" * "), [t.pp, f.pp]));
  top.ast_Expr = mul(t.ast_Expr, f.ast_Expr, location=top.location);
}

concrete production div_c
top::Term_c ::= t::Term_c '/' f::Factor_c
{
  top.pp = parens(ppImplode(text(" / "), [t.pp, f.pp]));
  top.ast_Expr = div(t.ast_Expr, f.ast_Expr, location=top.location);
}

-- Concrete production for let expressions.

concrete production let_c
top::Expr_c ::= 'let' i::Identifier_t '=' value::Expr_c 'in' body::Expr_c 'end'
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
top::Factor_c ::= i::Identifier_t
{
  top.pp = text(i.lexeme);
  top.ast_Expr = identifier(i.lexeme, location=i.location);
}

concrete production literal_c
top::Factor_c ::= l::Literal_t
{
  top.pp = text(l.lexeme);
  top.ast_Expr = literal(l.lexeme, location=l.location);
}
