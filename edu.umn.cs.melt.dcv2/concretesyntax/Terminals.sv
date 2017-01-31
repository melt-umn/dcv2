grammar edu:umn:cs:melt:dcv2:concretesyntax;

lexer class COMMENT dominates OPERATOR;
lexer class IDENTIFIER;
lexer class KEYWORD dominates IDENTIFIER;
lexer class LITERAL;
lexer class OPERATOR;

terminal Plus_t             '+'  precedence = 3, association = left, lexer classes {OPERATOR};
terminal Minus_t            '-'  precedence = 3, association = left, lexer classes {OPERATOR};
terminal Multiply_t         '*'  precedence = 4, association = left, lexer classes {OPERATOR};
terminal Divide_t           '/'  precedence = 4, association = left, lexer classes {OPERATOR};
terminal Equal_t            '==' precedence = 2, association = left, lexer classes {OPERATOR};
terminal NotEqual_t         '!=' precedence = 2, association = left, lexer classes {OPERATOR};
terminal Greater_t          '>'  precedence = 2, association = left, lexer classes {OPERATOR};
terminal GreaterThanEqual_t '>=' precedence = 2, association = left, lexer classes {OPERATOR};
terminal LessThan_t         '<'  precedence = 2, association = left, lexer classes {OPERATOR};
terminal LessThanEqual_t    '<=' precedence = 2, association = left, lexer classes {OPERATOR};
terminal And_t              '&&' precedence = 1, association = left, lexer classes {OPERATOR};
terminal Or_t               '||' precedence = 1, association = left, lexer classes {OPERATOR};
terminal Not_t              '!'  precedence = 1, association = left, lexer classes {OPERATOR};

terminal LParen_t '(';
terminal RParen_t ')';

terminal Let_t  'let'                                      lexer classes {KEYWORD};
terminal Bind_t '='                                        lexer classes {OPERATOR};
terminal In_t   'in'   precedence = 0, association = left, lexer classes {KEYWORD};
terminal If_t   'if'                                       lexer classes {KEYWORD};
terminal Then_t 'then'                                     lexer classes {KEYWORD};
terminal Else_t 'else'                                     lexer classes {KEYWORD};
terminal End_t  'end'                                      lexer classes {KEYWORD};

terminal Identifier_t    /[A-Za-z][A-Za-z0-9]*/     lexer classes {IDENTIFIER};
terminal Float_Literal_t /[\-]?[0-9]+([\.][0-9]*)?/ lexer classes {LITERAL};
terminal False_t 'false' lexer classes {KEYWORD, LITERAL};
terminal True_t 'true'   lexer classes {KEYWORD, LITERAL};

ignore terminal Whitespace_t   /[\n\r\t\ ]+/;
ignore terminal LineComment_t  /[\-][\-].*/ lexer classes {COMMENT};
