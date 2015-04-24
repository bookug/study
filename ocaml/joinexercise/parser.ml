type token =
  | TTOP of (Support.Error.info)
  | LAMBDA of (Support.Error.info)
  | IF of (Support.Error.info)
  | THEN of (Support.Error.info)
  | ELSE of (Support.Error.info)
  | TRUE of (Support.Error.info)
  | FALSE of (Support.Error.info)
  | BOOL of (Support.Error.info)
  | UCID of (string Support.Error.withinfo)
  | LCID of (string Support.Error.withinfo)
  | INTV of (int Support.Error.withinfo)
  | FLOATV of (float Support.Error.withinfo)
  | STRINGV of (string Support.Error.withinfo)
  | APOSTROPHE of (Support.Error.info)
  | DQUOTE of (Support.Error.info)
  | ARROW of (Support.Error.info)
  | BANG of (Support.Error.info)
  | BARGT of (Support.Error.info)
  | BARRCURLY of (Support.Error.info)
  | BARRSQUARE of (Support.Error.info)
  | COLON of (Support.Error.info)
  | COLONCOLON of (Support.Error.info)
  | COLONEQ of (Support.Error.info)
  | COLONHASH of (Support.Error.info)
  | COMMA of (Support.Error.info)
  | DARROW of (Support.Error.info)
  | DDARROW of (Support.Error.info)
  | DOT of (Support.Error.info)
  | EOF of (Support.Error.info)
  | EQ of (Support.Error.info)
  | EQEQ of (Support.Error.info)
  | EXISTS of (Support.Error.info)
  | GT of (Support.Error.info)
  | HASH of (Support.Error.info)
  | LCURLY of (Support.Error.info)
  | LCURLYBAR of (Support.Error.info)
  | LEFTARROW of (Support.Error.info)
  | LPAREN of (Support.Error.info)
  | LSQUARE of (Support.Error.info)
  | LSQUAREBAR of (Support.Error.info)
  | LT of (Support.Error.info)
  | RCURLY of (Support.Error.info)
  | RPAREN of (Support.Error.info)
  | RSQUARE of (Support.Error.info)
  | SEMI of (Support.Error.info)
  | SLASH of (Support.Error.info)
  | STAR of (Support.Error.info)
  | TRIANGLE of (Support.Error.info)
  | USCORE of (Support.Error.info)
  | VBAR of (Support.Error.info)

open Parsing;;
let _ = parse_error;;
# 7 "parser.mly"
open Support.Error
open Support.Pervasive
open Syntax
# 60 "parser.ml"
let yytransl_const = [|
    0|]

let yytransl_block = [|
  257 (* TTOP *);
  258 (* LAMBDA *);
  259 (* IF *);
  260 (* THEN *);
  261 (* ELSE *);
  262 (* TRUE *);
  263 (* FALSE *);
  264 (* BOOL *);
  265 (* UCID *);
  266 (* LCID *);
  267 (* INTV *);
  268 (* FLOATV *);
  269 (* STRINGV *);
  270 (* APOSTROPHE *);
  271 (* DQUOTE *);
  272 (* ARROW *);
  273 (* BANG *);
  274 (* BARGT *);
  275 (* BARRCURLY *);
  276 (* BARRSQUARE *);
  277 (* COLON *);
  278 (* COLONCOLON *);
  279 (* COLONEQ *);
  280 (* COLONHASH *);
  281 (* COMMA *);
  282 (* DARROW *);
  283 (* DDARROW *);
  284 (* DOT *);
    0 (* EOF *);
  285 (* EQ *);
  286 (* EQEQ *);
  287 (* EXISTS *);
  288 (* GT *);
  289 (* HASH *);
  290 (* LCURLY *);
  291 (* LCURLYBAR *);
  292 (* LEFTARROW *);
  293 (* LPAREN *);
  294 (* LSQUARE *);
  295 (* LSQUAREBAR *);
  296 (* LT *);
  297 (* RCURLY *);
  298 (* RPAREN *);
  299 (* RSQUARE *);
  300 (* SEMI *);
  301 (* SLASH *);
  302 (* STAR *);
  303 (* TRIANGLE *);
  304 (* USCORE *);
  305 (* VBAR *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\002\000\002\000\004\000\005\000\007\000\007\000\
\007\000\007\000\006\000\006\000\003\000\003\000\003\000\003\000\
\009\000\009\000\010\000\010\000\010\000\011\000\011\000\011\000\
\011\000\011\000\012\000\012\000\013\000\013\000\014\000\014\000\
\008\000\008\000\015\000\015\000\016\000\016\000\000\000"

let yylen = "\002\000\
\001\000\003\000\001\000\002\000\002\000\001\000\003\000\001\000\
\003\000\001\000\003\000\001\000\001\000\006\000\006\000\006\000\
\001\000\002\000\003\000\003\000\001\000\003\000\001\000\003\000\
\001\000\001\000\000\000\001\000\001\000\003\000\003\000\001\000\
\000\000\001\000\001\000\003\000\003\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\025\000\026\000\000\000\001\000\
\000\000\000\000\039\000\000\000\003\000\000\000\000\000\021\000\
\000\000\000\000\023\000\000\000\000\000\004\000\000\000\032\000\
\000\000\028\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\008\000\010\000\000\000\000\000\005\000\006\000\
\000\000\000\000\024\000\000\000\022\000\002\000\019\000\020\000\
\000\000\000\000\000\000\000\000\038\000\000\000\034\000\000\000\
\000\000\000\000\031\000\030\000\000\000\000\000\000\000\000\000\
\009\000\000\000\007\000\011\000\014\000\015\000\016\000\037\000\
\036\000"

let yydgoto = "\002\000\
\011\000\012\000\013\000\022\000\053\000\040\000\041\000\054\000\
\014\000\015\000\016\000\025\000\026\000\027\000\055\000\056\000"

let yysindex = "\003\000\
\001\000\000\000\249\254\005\255\000\000\000\000\251\254\000\000\
\075\255\005\255\000\000\229\254\000\000\100\255\246\254\000\000\
\000\255\001\255\000\000\016\255\067\255\000\000\254\254\000\000\
\243\254\000\000\006\255\250\254\001\000\246\254\255\254\067\255\
\067\255\005\255\000\000\000\000\054\255\067\255\000\000\000\000\
\021\255\005\255\000\000\075\255\000\000\000\000\000\000\000\000\
\004\255\007\255\038\255\030\255\000\000\009\255\000\000\047\255\
\032\255\067\255\000\000\000\000\005\255\005\255\005\255\067\255\
\000\000\054\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\059\255\000\000\
\039\255\000\000\000\000\000\000\000\000\029\255\019\255\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\088\255\000\000\
\000\000\000\000\048\255\000\000\000\000\042\255\000\000\000\000\
\000\000\000\000\000\000\000\000\049\255\000\000\000\000\000\000\
\077\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\051\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000"

let yygindex = "\000\000\
\068\000\000\000\252\255\000\000\237\255\041\000\000\000\000\000\
\000\000\086\000\000\000\000\000\064\000\000\000\045\000\000\000"

let yytablesize = 294
let yytable = "\020\000\
\008\000\039\000\017\000\001\000\024\000\028\000\003\000\004\000\
\047\000\048\000\005\000\006\000\049\000\050\000\019\000\021\000\
\029\000\031\000\057\000\034\000\032\000\033\000\017\000\017\000\
\017\000\017\000\042\000\043\000\017\000\051\000\044\000\061\000\
\013\000\013\000\062\000\045\000\058\000\059\000\009\000\024\000\
\018\000\010\000\063\000\017\000\072\000\018\000\018\000\018\000\
\018\000\065\000\064\000\018\000\017\000\013\000\035\000\017\000\
\069\000\070\000\071\000\017\000\017\000\036\000\017\000\052\000\
\023\000\023\000\018\000\035\000\023\000\013\000\013\000\066\000\
\013\000\067\000\036\000\018\000\003\000\004\000\018\000\027\000\
\005\000\006\000\018\000\018\000\023\000\018\000\023\000\037\000\
\029\000\033\000\038\000\035\000\023\000\023\000\023\000\023\000\
\046\000\023\000\068\000\030\000\037\000\012\000\023\000\038\000\
\012\000\005\000\006\000\060\000\009\000\019\000\073\000\010\000\
\023\000\000\000\000\000\023\000\000\000\012\000\012\000\000\000\
\012\000\023\000\000\000\000\000\023\000\000\000\000\000\000\000\
\023\000\000\000\000\000\000\000\000\000\009\000\000\000\000\000\
\010\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\003\000\004\000\000\000\000\000\005\000\006\000\
\000\000\000\000\007\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\009\000\000\000\000\000\010\000"

let yycheck = "\004\000\
\000\000\021\000\010\001\001\000\009\000\010\000\002\001\003\001\
\010\001\011\001\006\001\007\001\032\000\033\000\010\001\021\001\
\044\001\028\001\038\000\004\001\021\001\021\001\004\001\005\001\
\006\001\007\001\029\001\041\001\010\001\034\000\025\001\028\001\
\004\001\005\001\028\001\042\001\016\001\042\000\034\001\044\000\
\048\001\037\001\005\001\025\001\064\000\004\001\005\001\006\001\
\007\001\041\001\021\001\010\001\034\001\025\001\001\001\037\001\
\061\000\062\000\063\000\041\001\042\001\008\001\044\001\010\001\
\006\001\007\001\025\001\001\001\010\001\041\001\042\001\025\001\
\044\001\042\001\008\001\034\001\002\001\003\001\037\001\041\001\
\006\001\007\001\041\001\042\001\010\001\044\001\028\001\034\001\
\041\001\041\001\037\001\041\001\034\001\006\001\007\001\037\001\
\029\000\010\001\058\000\014\000\034\001\025\001\044\001\037\001\
\028\001\006\001\007\001\044\000\034\001\010\001\066\000\037\001\
\025\001\255\255\255\255\028\001\255\255\041\001\042\001\255\255\
\044\001\034\001\255\255\255\255\037\001\255\255\255\255\255\255\
\041\001\255\255\255\255\255\255\255\255\034\001\255\255\255\255\
\037\001\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\002\001\003\001\255\255\255\255\006\001\007\001\
\255\255\255\255\010\001\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\034\001\255\255\255\255\037\001"

let yynames_const = "\
  "

let yynames_block = "\
  TTOP\000\
  LAMBDA\000\
  IF\000\
  THEN\000\
  ELSE\000\
  TRUE\000\
  FALSE\000\
  BOOL\000\
  UCID\000\
  LCID\000\
  INTV\000\
  FLOATV\000\
  STRINGV\000\
  APOSTROPHE\000\
  DQUOTE\000\
  ARROW\000\
  BANG\000\
  BARGT\000\
  BARRCURLY\000\
  BARRSQUARE\000\
  COLON\000\
  COLONCOLON\000\
  COLONEQ\000\
  COLONHASH\000\
  COMMA\000\
  DARROW\000\
  DDARROW\000\
  DOT\000\
  EOF\000\
  EQ\000\
  EQEQ\000\
  EXISTS\000\
  GT\000\
  HASH\000\
  LCURLY\000\
  LCURLYBAR\000\
  LEFTARROW\000\
  LPAREN\000\
  LSQUARE\000\
  LSQUAREBAR\000\
  LT\000\
  RCURLY\000\
  RPAREN\000\
  RSQUARE\000\
  SEMI\000\
  SLASH\000\
  STAR\000\
  TRIANGLE\000\
  USCORE\000\
  VBAR\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 107 "parser.mly"
      ( fun ctx -> [],ctx )
# 317 "parser.ml"
               :  Syntax.context -> (Syntax.command list * Syntax.context) ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Command) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 :  Syntax.context -> (Syntax.command list * Syntax.context) ) in
    Obj.repr(
# 109 "parser.mly"
      ( fun ctx ->
          let cmd,ctx = _1 ctx in
          let cmds,ctx = _3 ctx in
          cmd::cmds,ctx )
# 329 "parser.ml"
               :  Syntax.context -> (Syntax.command list * Syntax.context) ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 117 "parser.mly"
      ( fun ctx -> (let t = _1 ctx in Eval(tmInfo t,t)),ctx )
# 336 "parser.ml"
               : 'Command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Binder) in
    Obj.repr(
# 119 "parser.mly"
      ( fun ctx -> ((Bind(_1.i,_1.v,_2 ctx)), addname ctx _1.v) )
# 344 "parser.ml"
               : 'Command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 124 "parser.mly"
      ( fun ctx -> VarBind (_2 ctx))
# 352 "parser.ml"
               : 'Binder))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ArrowType) in
    Obj.repr(
# 129 "parser.mly"
                ( _1 )
# 359 "parser.ml"
               : 'Type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'Type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 134 "parser.mly"
           ( _2 )
# 368 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 136 "parser.mly"
      ( fun ctx -> TyTop )
# 375 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'FieldTypes) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 138 "parser.mly"
      ( fun ctx ->
          TyRecord(_2 ctx 1) )
# 385 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 141 "parser.mly"
      ( fun ctx -> TyBool )
# 392 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'AType) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ArrowType) in
    Obj.repr(
# 147 "parser.mly"
     ( fun ctx -> TyArr(_1 ctx, _3 ctx) )
# 401 "parser.ml"
               : 'ArrowType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'AType) in
    Obj.repr(
# 149 "parser.mly"
            ( _1 )
# 408 "parser.ml"
               : 'ArrowType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'AppTerm) in
    Obj.repr(
# 153 "parser.mly"
      ( _1 )
# 415 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string Support.Error.withinfo) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Type) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 155 "parser.mly"
      ( fun ctx ->
          let ctx1 = addname ctx _2.v in
          TmAbs(_1, _2.v, _4 ctx, _6 ctx1) )
# 429 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Type) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 159 "parser.mly"
      ( fun ctx ->
          let ctx1 = addname ctx "_" in
          TmAbs(_1, "_", _4 ctx, _6 ctx1) )
# 443 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'Term) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 163 "parser.mly"
      ( fun ctx -> TmIf(_1, _2 ctx, _4 ctx, _6 ctx) )
# 455 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 167 "parser.mly"
      ( _1 )
# 462 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'AppTerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 169 "parser.mly"
      ( fun ctx ->
          let e1 = _1 ctx in
          let e2 = _2 ctx in
          TmApp(tmInfo e1,e1,e2) )
# 473 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'PathTerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string Support.Error.withinfo) in
    Obj.repr(
# 176 "parser.mly"
      ( fun ctx ->
          TmProj(_2, _1 ctx, _3.v) )
# 483 "parser.ml"
               : 'PathTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'PathTerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int Support.Error.withinfo) in
    Obj.repr(
# 179 "parser.mly"
      ( fun ctx ->
          TmProj(_2, _1 ctx, string_of_int _3.v) )
# 493 "parser.ml"
               : 'PathTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ATerm) in
    Obj.repr(
# 182 "parser.mly"
      ( _1 )
# 500 "parser.ml"
               : 'PathTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'Term) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 187 "parser.mly"
      ( _2 )
# 509 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string Support.Error.withinfo) in
    Obj.repr(
# 189 "parser.mly"
      ( fun ctx ->
          TmVar(_1.i, name2index _1.i ctx _1.v, ctxlength ctx) )
# 517 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'Fields) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 192 "parser.mly"
      ( fun ctx ->
          TmRecord(_1, _2 ctx 1) )
# 527 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 195 "parser.mly"
      ( fun ctx -> TmTrue(_1) )
# 534 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 197 "parser.mly"
      ( fun ctx -> TmFalse(_1) )
# 541 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    Obj.repr(
# 201 "parser.mly"
      ( fun ctx i -> [] )
# 547 "parser.ml"
               : 'Fields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'NEFields) in
    Obj.repr(
# 203 "parser.mly"
      ( _1 )
# 554 "parser.ml"
               : 'Fields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Field) in
    Obj.repr(
# 207 "parser.mly"
      ( fun ctx i -> [_1 ctx i] )
# 561 "parser.ml"
               : 'NEFields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Field) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'NEFields) in
    Obj.repr(
# 209 "parser.mly"
      ( fun ctx i -> (_1 ctx i) :: (_3 ctx (i+1)) )
# 570 "parser.ml"
               : 'NEFields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 213 "parser.mly"
      ( fun ctx i -> (_1.v, _3 ctx) )
# 579 "parser.ml"
               : 'Field))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 215 "parser.mly"
      ( fun ctx i -> (string_of_int i, _1 ctx) )
# 586 "parser.ml"
               : 'Field))
; (fun __caml_parser_env ->
    Obj.repr(
# 219 "parser.mly"
      ( fun ctx i -> [] )
# 592 "parser.ml"
               : 'FieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'NEFieldTypes) in
    Obj.repr(
# 221 "parser.mly"
      ( _1 )
# 599 "parser.ml"
               : 'FieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'FieldType) in
    Obj.repr(
# 225 "parser.mly"
      ( fun ctx i -> [_1 ctx i] )
# 606 "parser.ml"
               : 'NEFieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'FieldType) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'NEFieldTypes) in
    Obj.repr(
# 227 "parser.mly"
      ( fun ctx i -> (_1 ctx i) :: (_3 ctx (i+1)) )
# 615 "parser.ml"
               : 'NEFieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 231 "parser.mly"
      ( fun ctx i -> (_1.v, _3 ctx) )
# 624 "parser.ml"
               : 'FieldType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 233 "parser.mly"
      ( fun ctx i -> (string_of_int i, _1 ctx) )
# 631 "parser.ml"
               : 'FieldType))
(* Entry toplevel *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let toplevel (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf :  Syntax.context -> (Syntax.command list * Syntax.context) )
