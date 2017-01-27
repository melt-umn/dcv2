grammar edu:umn:cs:melt:dcv2:concretesyntax;

lexer class COMMENT dominates OPERATOR;
lexer class IDENTIFIER;
lexer class KEYWORD dominates IDENTIFIER;
lexer class LITERAL;
lexer class OPERATOR;

terminal Plus_t     '+' precedence = 3, association = left, lexer classes {OPERATOR};
terminal Minus_t    '-' precedence = 3, association = left, lexer classes {OPERATOR};
terminal Multiply_t '*' precedence = 4, association = left, lexer classes {OPERATOR};
terminal Divide_t   '/' precedence = 4, association = left, lexer classes {OPERATOR};

terminal LParen_t '(';
terminal RParen_t ')';

terminal Let_t 'let' lexer classes {KEYWORD};
terminal Bind_t '='  lexer classes {OPERATOR};
terminal In_t 'in'   precedence = 2, association = left, lexer classes {KEYWORD};

-- TODO Should semicolons have higher or lower precedence than let?
terminal Semicolon_t ';' precedence = 1, association = left;

terminal Identifier_t /[A-Za-z][A-Za-z0-9]*/     lexer classes {IDENTIFIER};
terminal Literal_t    /[\-]?[0-9]+([\.][0-9]*)?/ lexer classes {LITERAL};

ignore terminal Whitespace_t   /[\n\r\t\ ]+/;
ignore terminal LineComment_t  /[\-][\-].*/ lexer classes {COMMENT};
