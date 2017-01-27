grammar edu:umn:cs:melt:dcv2:abstractsyntax;

function find
Maybe<a> ::= f::(Boolean ::= a) l::[a]
{
  return if null(l) then nothing()
         else if f(head(l)) then just(head(l))
         else find(f, tail(l));
}
