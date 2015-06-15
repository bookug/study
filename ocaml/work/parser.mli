type token =
  | IDENT of (string)
  | INT of (int)
  | FUN
  | LET
  | REC
  | IN
  | FORALL
  | SOME
  | AND
  | OR
  | NOT
  | IF
  | THEN
  | ELSE
  | TRUE
  | FALSE
  | LPAREN
  | RPAREN
  | LBRACKET
  | RBRACKET
  | ARROW
  | EQUALS
  | COMMA
  | COLON
  | PLUS
  | MINUS
  | STAR
  | SLASH
  | PERCENT
  | GT
  | LT
  | GE
  | LE
  | EQ
  | NE
  | EOF

val expr_eof :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Expr.s_expr
val ty_eof :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Expr.s_ty
val ty_forall_eof :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Expr.s_ty
