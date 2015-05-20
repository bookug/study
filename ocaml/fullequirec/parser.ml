type token =
  | INERT of (Support.Error.info)
  | IF of (Support.Error.info)
  | THEN of (Support.Error.info)
  | ELSE of (Support.Error.info)
  | TRUE of (Support.Error.info)
  | FALSE of (Support.Error.info)
  | USTRING of (Support.Error.info)
  | AS of (Support.Error.info)
  | LAMBDA of (Support.Error.info)
  | TIMESFLOAT of (Support.Error.info)
  | UFLOAT of (Support.Error.info)
  | TYPE of (Support.Error.info)
  | REC of (Support.Error.info)
  | SUCC of (Support.Error.info)
  | PRED of (Support.Error.info)
  | ISZERO of (Support.Error.info)
  | BOOL of (Support.Error.info)
  | NAT of (Support.Error.info)
  | CASE of (Support.Error.info)
  | OF of (Support.Error.info)
  | LET of (Support.Error.info)
  | IN of (Support.Error.info)
  | UNIT of (Support.Error.info)
  | UUNIT of (Support.Error.info)
  | FIX of (Support.Error.info)
  | LETREC of (Support.Error.info)
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
# 78 "parser.ml"
let yytransl_const = [|
    0|]

let yytransl_block = [|
  257 (* INERT *);
  258 (* IF *);
  259 (* THEN *);
  260 (* ELSE *);
  261 (* TRUE *);
  262 (* FALSE *);
  263 (* USTRING *);
  264 (* AS *);
  265 (* LAMBDA *);
  266 (* TIMESFLOAT *);
  267 (* UFLOAT *);
  268 (* TYPE *);
  269 (* REC *);
  270 (* SUCC *);
  271 (* PRED *);
  272 (* ISZERO *);
  273 (* BOOL *);
  274 (* NAT *);
  275 (* CASE *);
  276 (* OF *);
  277 (* LET *);
  278 (* IN *);
  279 (* UNIT *);
  280 (* UUNIT *);
  281 (* FIX *);
  282 (* LETREC *);
  283 (* UCID *);
  284 (* LCID *);
  285 (* INTV *);
  286 (* FLOATV *);
  287 (* STRINGV *);
  288 (* APOSTROPHE *);
  289 (* DQUOTE *);
  290 (* ARROW *);
  291 (* BANG *);
  292 (* BARGT *);
  293 (* BARRCURLY *);
  294 (* BARRSQUARE *);
  295 (* COLON *);
  296 (* COLONCOLON *);
  297 (* COLONEQ *);
  298 (* COLONHASH *);
  299 (* COMMA *);
  300 (* DARROW *);
  301 (* DDARROW *);
  302 (* DOT *);
    0 (* EOF *);
  303 (* EQ *);
  304 (* EQEQ *);
  305 (* EXISTS *);
  306 (* GT *);
  307 (* HASH *);
  308 (* LCURLY *);
  309 (* LCURLYBAR *);
  310 (* LEFTARROW *);
  311 (* LPAREN *);
  312 (* LSQUARE *);
  313 (* LSQUAREBAR *);
  314 (* LT *);
  315 (* RCURLY *);
  316 (* RPAREN *);
  317 (* RSQUARE *);
  318 (* SEMI *);
  319 (* SLASH *);
  320 (* STAR *);
  321 (* TRIANGLE *);
  322 (* USCORE *);
  323 (* VBAR *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\002\000\002\000\002\000\004\000\004\000\006\000\
\006\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
\008\000\008\000\010\000\010\000\012\000\012\000\012\000\009\000\
\009\000\013\000\013\000\014\000\014\000\007\000\007\000\003\000\
\003\000\003\000\003\000\003\000\003\000\003\000\003\000\015\000\
\015\000\015\000\015\000\015\000\015\000\015\000\017\000\017\000\
\011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
\011\000\011\000\011\000\018\000\018\000\019\000\019\000\020\000\
\020\000\005\000\005\000\016\000\016\000\021\000\000\000"

let yylen = "\002\000\
\001\000\003\000\001\000\002\000\002\000\002\000\002\000\001\000\
\004\000\003\000\001\000\003\000\001\000\001\000\001\000\001\000\
\003\000\001\000\003\000\001\000\003\000\003\000\001\000\000\000\
\001\000\001\000\003\000\003\000\001\000\003\000\001\000\001\000\
\006\000\006\000\006\000\004\000\006\000\006\000\008\000\001\000\
\002\000\003\000\002\000\002\000\002\000\002\000\001\000\003\000\
\003\000\004\000\001\000\001\000\001\000\001\000\003\000\001\000\
\001\000\007\000\001\000\000\000\001\000\001\000\003\000\003\000\
\001\000\000\000\002\000\001\000\003\000\007\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\051\000\052\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\059\000\000\000\000\000\
\000\000\000\000\057\000\056\000\054\000\001\000\000\000\000\000\
\000\000\071\000\000\000\003\000\023\000\000\000\000\000\000\000\
\000\000\053\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\005\000\
\000\000\000\000\004\000\000\000\065\000\000\000\061\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\011\000\
\014\000\000\000\015\000\016\000\018\000\013\000\000\000\000\000\
\000\000\000\000\008\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\067\000\006\000\007\000\000\000\
\055\000\000\000\000\000\049\000\000\000\002\000\019\000\021\000\
\022\000\000\000\000\000\029\000\000\000\025\000\000\000\000\000\
\000\000\050\000\000\000\000\000\000\000\000\000\000\000\036\000\
\000\000\000\000\000\000\000\000\064\000\063\000\048\000\000\000\
\000\000\000\000\012\000\000\000\010\000\017\000\030\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\009\000\028\000\027\000\033\000\034\000\035\000\000\000\069\000\
\037\000\038\000\000\000\000\000\000\000\000\000\058\000\000\000\
\039\000\000\000\000\000"

let yydgoto = "\002\000\
\026\000\027\000\028\000\051\000\048\000\100\000\075\000\076\000\
\101\000\029\000\030\000\031\000\102\000\103\000\032\000\112\000\
\058\000\054\000\055\000\056\000\113\000"

let yysindex = "\014\000\
\001\000\000\000\221\254\153\001\000\000\000\000\235\254\251\001\
\251\001\251\001\251\001\153\001\240\254\000\000\251\001\250\254\
\234\254\233\254\000\000\000\000\000\000\000\000\208\001\153\001\
\002\255\000\000\225\254\000\000\000\000\029\255\248\254\251\001\
\058\255\000\000\036\255\001\255\003\255\005\255\248\254\248\254\
\248\254\023\255\253\254\000\255\248\254\009\255\058\255\000\000\
\058\255\153\001\000\000\006\255\000\000\246\254\000\000\011\255\
\249\254\252\254\014\255\001\000\058\255\245\254\248\254\000\000\
\000\000\035\255\000\000\000\000\000\000\000\000\038\002\058\255\
\038\002\007\255\000\000\032\255\153\001\058\255\058\255\248\254\
\012\255\153\001\153\001\058\255\000\000\000\000\000\000\153\001\
\000\000\208\001\153\001\000\000\153\001\000\000\000\000\000\000\
\000\000\021\255\033\255\000\000\015\255\000\000\034\255\020\255\
\031\255\000\000\050\002\079\255\042\255\044\255\063\255\000\000\
\025\255\072\255\077\255\056\255\000\000\000\000\000\000\054\255\
\058\255\058\255\000\000\038\002\000\000\000\000\000\000\153\001\
\153\001\153\001\059\255\012\255\153\001\153\001\153\001\097\255\
\000\000\000\000\000\000\000\000\000\000\000\000\080\255\000\000\
\000\000\000\000\085\255\058\255\061\255\153\001\000\000\064\255\
\000\000\239\001\251\001"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\057\255\062\001\000\000\000\000\000\000\000\000\068\255\000\000\
\000\000\000\000\000\000\000\000\000\000\157\255\032\000\179\255\
\000\000\000\000\000\000\000\000\000\000\000\000\073\000\114\000\
\155\000\000\000\000\000\000\000\196\000\000\000\000\000\000\000\
\000\000\000\000\000\000\098\001\000\000\000\000\000\000\073\255\
\081\255\000\000\000\000\000\000\000\000\000\000\237\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\074\255\000\000\
\087\255\000\000\000\000\092\255\000\000\000\000\000\000\022\001\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\220\254\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\051\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\114\255"

let yygindex = "\000\000\
\080\000\000\000\252\255\000\000\000\000\236\255\036\000\000\000\
\072\000\000\000\000\000\250\255\024\000\000\000\002\000\023\000\
\074\000\000\000\076\000\000\000\000\000"

let yytablesize = 876
let yytable = "\035\000\
\022\000\038\000\039\000\040\000\041\000\003\000\036\000\042\000\
\045\000\005\000\006\000\043\000\074\000\026\000\001\000\049\000\
\096\000\097\000\053\000\057\000\033\000\046\000\026\000\050\000\
\047\000\063\000\085\000\014\000\086\000\059\000\060\000\080\000\
\034\000\019\000\020\000\021\000\061\000\062\000\077\000\078\000\
\095\000\079\000\081\000\082\000\037\000\087\000\083\000\084\000\
\089\000\044\000\062\000\104\000\088\000\090\000\091\000\092\000\
\023\000\109\000\110\000\024\000\093\000\098\000\025\000\116\000\
\064\000\107\000\121\000\106\000\065\000\111\000\066\000\122\000\
\108\000\123\000\067\000\068\000\124\000\114\000\115\000\125\000\
\126\000\069\000\128\000\117\000\070\000\053\000\057\000\129\000\
\120\000\130\000\131\000\132\000\031\000\133\000\031\000\031\000\
\031\000\031\000\134\000\031\000\137\000\138\000\135\000\136\000\
\148\000\143\000\150\000\149\000\154\000\071\000\152\000\031\000\
\072\000\031\000\031\000\073\000\070\000\070\000\066\000\031\000\
\031\000\031\000\031\000\140\000\141\000\142\000\060\000\151\000\
\145\000\146\000\147\000\062\000\024\000\070\000\031\000\070\000\
\024\000\031\000\031\000\094\000\047\000\031\000\127\000\031\000\
\105\000\153\000\031\000\139\000\063\000\031\000\031\000\031\000\
\031\000\031\000\144\000\155\000\070\000\020\000\031\000\020\000\
\020\000\020\000\020\000\070\000\119\000\118\000\000\000\000\000\
\000\000\000\000\000\000\000\000\070\000\070\000\000\000\070\000\
\020\000\000\000\020\000\020\000\070\000\032\000\032\000\000\000\
\020\000\020\000\020\000\020\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\032\000\020\000\
\032\000\000\000\020\000\000\000\000\000\000\000\020\000\000\000\
\020\000\000\000\000\000\020\000\000\000\000\000\020\000\020\000\
\020\000\000\000\020\000\000\000\000\000\032\000\000\000\020\000\
\000\000\000\000\000\000\000\000\032\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\032\000\032\000\000\000\
\032\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\003\000\004\000\000\000\000\000\005\000\006\000\000\000\
\000\000\007\000\008\000\000\000\000\000\000\000\009\000\010\000\
\011\000\000\000\000\000\012\000\000\000\013\000\000\000\014\000\
\000\000\015\000\016\000\017\000\018\000\019\000\020\000\021\000\
\040\000\000\000\040\000\040\000\040\000\040\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\040\000\023\000\040\000\040\000\024\000\
\000\000\000\000\025\000\040\000\040\000\040\000\040\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\043\000\040\000\043\000\043\000\043\000\043\000\000\000\
\000\000\040\000\000\000\040\000\000\000\000\000\040\000\000\000\
\000\000\040\000\040\000\040\000\043\000\040\000\043\000\043\000\
\000\000\000\000\040\000\000\000\043\000\043\000\043\000\043\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\044\000\043\000\044\000\044\000\044\000\044\000\
\000\000\000\000\043\000\000\000\043\000\000\000\000\000\043\000\
\000\000\000\000\043\000\043\000\043\000\044\000\043\000\044\000\
\044\000\000\000\000\000\043\000\000\000\044\000\044\000\044\000\
\044\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\045\000\044\000\045\000\045\000\045\000\
\045\000\000\000\000\000\044\000\000\000\044\000\000\000\000\000\
\044\000\000\000\000\000\044\000\044\000\044\000\045\000\044\000\
\045\000\045\000\000\000\000\000\044\000\000\000\045\000\045\000\
\045\000\045\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\046\000\045\000\046\000\046\000\
\046\000\046\000\000\000\000\000\045\000\000\000\045\000\000\000\
\000\000\045\000\000\000\000\000\045\000\045\000\045\000\046\000\
\045\000\046\000\046\000\000\000\000\000\045\000\000\000\046\000\
\046\000\046\000\046\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\041\000\046\000\041\000\
\041\000\041\000\041\000\000\000\000\000\046\000\000\000\046\000\
\000\000\000\000\046\000\000\000\000\000\046\000\046\000\046\000\
\041\000\046\000\041\000\041\000\000\000\000\000\046\000\000\000\
\041\000\041\000\041\000\041\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\042\000\041\000\
\042\000\042\000\042\000\042\000\000\000\000\000\041\000\000\000\
\041\000\000\000\000\000\041\000\000\000\000\000\041\000\041\000\
\041\000\042\000\041\000\042\000\042\000\000\000\000\000\041\000\
\000\000\042\000\042\000\042\000\042\000\068\000\068\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\053\000\000\000\
\042\000\000\000\053\000\053\000\000\000\053\000\068\000\042\000\
\068\000\042\000\000\000\000\000\042\000\000\000\000\000\042\000\
\042\000\042\000\000\000\042\000\053\000\000\000\000\000\000\000\
\042\000\053\000\053\000\053\000\053\000\068\000\000\000\000\000\
\000\000\000\000\053\000\000\000\068\000\000\000\053\000\053\000\
\000\000\053\000\000\000\053\000\000\000\068\000\068\000\000\000\
\068\000\053\000\000\000\000\000\053\000\000\000\000\000\053\000\
\053\000\000\000\000\000\053\000\000\000\053\000\053\000\053\000\
\053\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\053\000\000\000\000\000\053\000\
\000\000\000\000\000\000\000\000\000\000\053\000\000\000\000\000\
\053\000\003\000\004\000\053\000\053\000\005\000\006\000\000\000\
\000\000\007\000\008\000\000\000\000\000\000\000\009\000\010\000\
\011\000\000\000\000\000\012\000\000\000\013\000\000\000\014\000\
\000\000\015\000\016\000\000\000\034\000\019\000\020\000\021\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\023\000\000\000\000\000\024\000\
\003\000\004\000\025\000\000\000\005\000\006\000\000\000\000\000\
\007\000\008\000\000\000\000\000\000\000\009\000\010\000\011\000\
\000\000\000\000\012\000\000\000\013\000\000\000\014\000\000\000\
\015\000\016\000\000\000\052\000\019\000\020\000\021\000\003\000\
\000\000\000\000\000\000\005\000\006\000\000\000\000\000\000\000\
\008\000\000\000\000\000\003\000\009\000\010\000\011\000\005\000\
\006\000\000\000\000\000\023\000\000\000\014\000\024\000\015\000\
\000\000\025\000\034\000\019\000\020\000\021\000\000\000\000\000\
\000\000\014\000\000\000\000\000\000\000\000\000\034\000\019\000\
\020\000\021\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\023\000\000\000\000\000\024\000\000\000\000\000\
\025\000\000\000\000\000\000\000\064\000\000\000\023\000\000\000\
\065\000\024\000\066\000\000\000\025\000\000\000\067\000\068\000\
\064\000\000\000\000\000\000\000\065\000\069\000\000\000\000\000\
\070\000\099\000\067\000\068\000\000\000\000\000\000\000\000\000\
\000\000\069\000\000\000\000\000\070\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\071\000\000\000\000\000\072\000\000\000\000\000\073\000\
\000\000\000\000\000\000\000\000\000\000\071\000\000\000\000\000\
\072\000\000\000\000\000\073\000"

let yycheck = "\004\000\
\000\000\008\000\009\000\010\000\011\000\001\001\028\001\012\000\
\015\000\005\001\006\001\028\001\033\000\050\001\001\000\039\001\
\028\001\029\001\023\000\024\000\056\001\028\001\059\001\047\001\
\047\001\032\000\047\000\023\001\049\000\028\001\062\001\038\000\
\028\001\029\001\030\001\031\001\008\001\046\001\003\001\039\001\
\061\000\039\001\020\001\047\001\066\001\050\000\047\001\039\001\
\059\001\066\001\046\001\072\000\047\001\043\001\062\001\060\001\
\052\001\078\000\079\000\055\001\047\001\027\001\058\001\084\000\
\007\001\034\001\046\001\061\001\011\001\058\001\013\001\039\001\
\077\000\059\001\017\001\018\001\043\001\082\000\083\000\060\001\
\050\001\024\001\004\001\088\000\027\001\090\000\091\000\046\001\
\093\000\046\001\028\001\067\001\001\001\022\001\003\001\004\001\
\005\001\006\001\022\001\008\001\121\000\122\000\047\001\050\001\
\008\001\047\001\022\001\028\001\045\001\052\001\050\001\020\001\
\055\001\022\001\023\001\058\001\003\001\004\001\062\001\028\001\
\029\001\030\001\031\001\128\000\129\000\130\000\059\001\148\000\
\133\000\134\000\135\000\059\001\059\001\020\001\043\001\022\001\
\050\001\046\001\047\001\060\000\060\001\050\001\107\000\052\001\
\073\000\150\000\055\001\124\000\155\000\058\001\059\001\060\001\
\061\001\062\001\132\000\154\000\043\001\001\001\067\001\003\001\
\004\001\005\001\006\001\050\001\091\000\090\000\255\255\255\255\
\255\255\255\255\255\255\255\255\059\001\060\001\255\255\062\001\
\020\001\255\255\022\001\023\001\067\001\003\001\004\001\255\255\
\028\001\029\001\030\001\031\001\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\020\001\043\001\
\022\001\255\255\046\001\255\255\255\255\255\255\050\001\255\255\
\052\001\255\255\255\255\055\001\255\255\255\255\058\001\059\001\
\060\001\255\255\062\001\255\255\255\255\043\001\255\255\067\001\
\255\255\255\255\255\255\255\255\050\001\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\059\001\060\001\255\255\
\062\001\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\001\001\002\001\255\255\255\255\005\001\006\001\255\255\
\255\255\009\001\010\001\255\255\255\255\255\255\014\001\015\001\
\016\001\255\255\255\255\019\001\255\255\021\001\255\255\023\001\
\255\255\025\001\026\001\027\001\028\001\029\001\030\001\031\001\
\001\001\255\255\003\001\004\001\005\001\006\001\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\020\001\052\001\022\001\023\001\055\001\
\255\255\255\255\058\001\028\001\029\001\030\001\031\001\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\001\001\043\001\003\001\004\001\005\001\006\001\255\255\
\255\255\050\001\255\255\052\001\255\255\255\255\055\001\255\255\
\255\255\058\001\059\001\060\001\020\001\062\001\022\001\023\001\
\255\255\255\255\067\001\255\255\028\001\029\001\030\001\031\001\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\001\001\043\001\003\001\004\001\005\001\006\001\
\255\255\255\255\050\001\255\255\052\001\255\255\255\255\055\001\
\255\255\255\255\058\001\059\001\060\001\020\001\062\001\022\001\
\023\001\255\255\255\255\067\001\255\255\028\001\029\001\030\001\
\031\001\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\001\001\043\001\003\001\004\001\005\001\
\006\001\255\255\255\255\050\001\255\255\052\001\255\255\255\255\
\055\001\255\255\255\255\058\001\059\001\060\001\020\001\062\001\
\022\001\023\001\255\255\255\255\067\001\255\255\028\001\029\001\
\030\001\031\001\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\001\001\043\001\003\001\004\001\
\005\001\006\001\255\255\255\255\050\001\255\255\052\001\255\255\
\255\255\055\001\255\255\255\255\058\001\059\001\060\001\020\001\
\062\001\022\001\023\001\255\255\255\255\067\001\255\255\028\001\
\029\001\030\001\031\001\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\001\001\043\001\003\001\
\004\001\005\001\006\001\255\255\255\255\050\001\255\255\052\001\
\255\255\255\255\055\001\255\255\255\255\058\001\059\001\060\001\
\020\001\062\001\022\001\023\001\255\255\255\255\067\001\255\255\
\028\001\029\001\030\001\031\001\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\001\001\043\001\
\003\001\004\001\005\001\006\001\255\255\255\255\050\001\255\255\
\052\001\255\255\255\255\055\001\255\255\255\255\058\001\059\001\
\060\001\020\001\062\001\022\001\023\001\255\255\255\255\067\001\
\255\255\028\001\029\001\030\001\031\001\003\001\004\001\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\001\001\255\255\
\043\001\255\255\005\001\006\001\255\255\008\001\020\001\050\001\
\022\001\052\001\255\255\255\255\055\001\255\255\255\255\058\001\
\059\001\060\001\255\255\062\001\023\001\255\255\255\255\255\255\
\067\001\028\001\029\001\030\001\031\001\043\001\255\255\255\255\
\255\255\255\255\001\001\255\255\050\001\255\255\005\001\006\001\
\255\255\008\001\255\255\046\001\255\255\059\001\060\001\255\255\
\062\001\052\001\255\255\255\255\055\001\255\255\255\255\058\001\
\023\001\255\255\255\255\062\001\255\255\028\001\029\001\030\001\
\031\001\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\043\001\255\255\255\255\046\001\
\255\255\255\255\255\255\255\255\255\255\052\001\255\255\255\255\
\055\001\001\001\002\001\058\001\059\001\005\001\006\001\255\255\
\255\255\009\001\010\001\255\255\255\255\255\255\014\001\015\001\
\016\001\255\255\255\255\019\001\255\255\021\001\255\255\023\001\
\255\255\025\001\026\001\255\255\028\001\029\001\030\001\031\001\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\052\001\255\255\255\255\055\001\
\001\001\002\001\058\001\255\255\005\001\006\001\255\255\255\255\
\009\001\010\001\255\255\255\255\255\255\014\001\015\001\016\001\
\255\255\255\255\019\001\255\255\021\001\255\255\023\001\255\255\
\025\001\026\001\255\255\028\001\029\001\030\001\031\001\001\001\
\255\255\255\255\255\255\005\001\006\001\255\255\255\255\255\255\
\010\001\255\255\255\255\001\001\014\001\015\001\016\001\005\001\
\006\001\255\255\255\255\052\001\255\255\023\001\055\001\025\001\
\255\255\058\001\028\001\029\001\030\001\031\001\255\255\255\255\
\255\255\023\001\255\255\255\255\255\255\255\255\028\001\029\001\
\030\001\031\001\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\052\001\255\255\255\255\055\001\255\255\255\255\
\058\001\255\255\255\255\255\255\007\001\255\255\052\001\255\255\
\011\001\055\001\013\001\255\255\058\001\255\255\017\001\018\001\
\007\001\255\255\255\255\255\255\011\001\024\001\255\255\255\255\
\027\001\028\001\017\001\018\001\255\255\255\255\255\255\255\255\
\255\255\024\001\255\255\255\255\027\001\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\052\001\255\255\255\255\055\001\255\255\255\255\058\001\
\255\255\255\255\255\255\255\255\255\255\052\001\255\255\255\255\
\055\001\255\255\255\255\058\001"

let yynames_const = "\
  "

let yynames_block = "\
  INERT\000\
  IF\000\
  THEN\000\
  ELSE\000\
  TRUE\000\
  FALSE\000\
  USTRING\000\
  AS\000\
  LAMBDA\000\
  TIMESFLOAT\000\
  UFLOAT\000\
  TYPE\000\
  REC\000\
  SUCC\000\
  PRED\000\
  ISZERO\000\
  BOOL\000\
  NAT\000\
  CASE\000\
  OF\000\
  LET\000\
  IN\000\
  UNIT\000\
  UUNIT\000\
  FIX\000\
  LETREC\000\
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
# 125 "parser.mly"
      ( fun ctx -> [],ctx )
# 557 "parser.ml"
               :  Syntax.context -> (Syntax.command list * Syntax.context) ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Command) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 :  Syntax.context -> (Syntax.command list * Syntax.context) ) in
    Obj.repr(
# 127 "parser.mly"
      ( fun ctx ->
          let cmd,ctx = _1 ctx in
          let cmds,ctx = _3 ctx in
          cmd::cmds,ctx )
# 569 "parser.ml"
               :  Syntax.context -> (Syntax.command list * Syntax.context) ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 135 "parser.mly"
      ( fun ctx -> (let t = _1 ctx in Eval(tmInfo t,t)),ctx )
# 576 "parser.ml"
               : 'Command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Binder) in
    Obj.repr(
# 137 "parser.mly"
      ( fun ctx -> ((Bind(_1.i,_1.v,_2 ctx)), addname ctx _1.v) )
# 584 "parser.ml"
               : 'Command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'TyBinder) in
    Obj.repr(
# 139 "parser.mly"
      ( fun ctx -> ((Bind(_1.i, _1.v, _2 ctx)), addname ctx _1.v) )
# 592 "parser.ml"
               : 'Command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 144 "parser.mly"
      ( fun ctx -> VarBind (_2 ctx))
# 600 "parser.ml"
               : 'Binder))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 146 "parser.mly"
      ( fun ctx -> TmAbbBind(_2 ctx, None) )
# 608 "parser.ml"
               : 'Binder))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ArrowType) in
    Obj.repr(
# 151 "parser.mly"
                ( _1 )
# 615 "parser.ml"
               : 'Type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string Support.Error.withinfo) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 153 "parser.mly"
      ( fun ctx ->
          let ctx1 = addname ctx _2.v in
          TyRec(_2.v,_4 ctx1) )
# 627 "parser.ml"
               : 'Type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'Type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 160 "parser.mly"
           ( _2 )
# 636 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 162 "parser.mly"
      ( fun ctx -> TyString )
# 643 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'FieldTypes) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 164 "parser.mly"
      ( fun ctx ->
          TyRecord(_2 ctx 1) )
# 653 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string Support.Error.withinfo) in
    Obj.repr(
# 167 "parser.mly"
      ( fun ctx ->
          if isnamebound ctx _1.v then
            TyVar(name2index _1.i ctx _1.v, ctxlength ctx)
          else 
            TyId(_1.v) )
# 664 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 173 "parser.mly"
      ( fun ctx -> TyFloat )
# 671 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 175 "parser.mly"
      ( fun ctx -> TyBool )
# 678 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 177 "parser.mly"
      ( fun ctx -> TyNat )
# 685 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'FieldTypes) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 179 "parser.mly"
      ( fun ctx ->
          TyVariant(_2 ctx 1) )
# 695 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 182 "parser.mly"
      ( fun ctx -> TyUnit )
# 702 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ATerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 186 "parser.mly"
      ( fun ctx -> TmAscribe(_2, _1 ctx, _3 ctx) )
# 711 "parser.ml"
               : 'AscribeTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ATerm) in
    Obj.repr(
# 188 "parser.mly"
      ( _1 )
# 718 "parser.ml"
               : 'AscribeTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'PathTerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string Support.Error.withinfo) in
    Obj.repr(
# 192 "parser.mly"
      ( fun ctx ->
          TmProj(_2, _1 ctx, _3.v) )
# 728 "parser.ml"
               : 'PathTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'PathTerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int Support.Error.withinfo) in
    Obj.repr(
# 195 "parser.mly"
      ( fun ctx ->
          TmProj(_2, _1 ctx, string_of_int _3.v) )
# 738 "parser.ml"
               : 'PathTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'AscribeTerm) in
    Obj.repr(
# 198 "parser.mly"
      ( _1 )
# 745 "parser.ml"
               : 'PathTerm))
; (fun __caml_parser_env ->
    Obj.repr(
# 202 "parser.mly"
      ( fun ctx i -> [] )
# 751 "parser.ml"
               : 'FieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'NEFieldTypes) in
    Obj.repr(
# 204 "parser.mly"
      ( _1 )
# 758 "parser.ml"
               : 'FieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'FieldType) in
    Obj.repr(
# 208 "parser.mly"
      ( fun ctx i -> [_1 ctx i] )
# 765 "parser.ml"
               : 'NEFieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'FieldType) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'NEFieldTypes) in
    Obj.repr(
# 210 "parser.mly"
      ( fun ctx i -> (_1 ctx i) :: (_3 ctx (i+1)) )
# 774 "parser.ml"
               : 'NEFieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 214 "parser.mly"
      ( fun ctx i -> (_1.v, _3 ctx) )
# 783 "parser.ml"
               : 'FieldType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 216 "parser.mly"
      ( fun ctx i -> (string_of_int i, _1 ctx) )
# 790 "parser.ml"
               : 'FieldType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'AType) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ArrowType) in
    Obj.repr(
# 222 "parser.mly"
     ( fun ctx -> TyArr(_1 ctx, _3 ctx) )
# 799 "parser.ml"
               : 'ArrowType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'AType) in
    Obj.repr(
# 224 "parser.mly"
            ( _1 )
# 806 "parser.ml"
               : 'ArrowType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'AppTerm) in
    Obj.repr(
# 228 "parser.mly"
      ( _1 )
# 813 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'Term) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 230 "parser.mly"
      ( fun ctx -> TmIf(_1, _2 ctx, _4 ctx, _6 ctx) )
# 825 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string Support.Error.withinfo) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Type) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 232 "parser.mly"
      ( fun ctx ->
          let ctx1 = addname ctx _2.v in
          TmAbs(_1, _2.v, _4 ctx, _6 ctx1) )
# 839 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Type) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 236 "parser.mly"
      ( fun ctx ->
          let ctx1 = addname ctx "_" in
          TmAbs(_1, "_", _4 ctx, _6 ctx1) )
# 853 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'Cases) in
    Obj.repr(
# 240 "parser.mly"
      ( fun ctx ->
          TmCase(_1, _2 ctx, _4 ctx) )
# 864 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string Support.Error.withinfo) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 243 "parser.mly"
      ( fun ctx -> TmLet(_1, _2.v, _4 ctx, _6 (addname ctx _2.v)) )
# 876 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 245 "parser.mly"
      ( fun ctx -> TmLet(_1, "_", _4 ctx, _6 (addname ctx "_")) )
# 888 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 7 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 6 : string Support.Error.withinfo) in
    let _3 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 4 : 'Type) in
    let _5 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _7 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _8 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 247 "parser.mly"
      ( fun ctx -> 
          let ctx1 = addname ctx _2.v in 
          TmLet(_1, _2.v, TmFix(_1, TmAbs(_1, _2.v, _4 ctx, _6 ctx1)),
                _8 ctx1) )
# 905 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 254 "parser.mly"
      ( _1 )
# 912 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'AppTerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 256 "parser.mly"
      ( fun ctx ->
          let e1 = _1 ctx in
          let e2 = _2 ctx in
          TmApp(tmInfo e1,e1,e2) )
# 923 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'PathTerm) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 261 "parser.mly"
      ( fun ctx -> TmTimesfloat(_1, _2 ctx, _3 ctx) )
# 932 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 263 "parser.mly"
      ( fun ctx -> TmSucc(_1, _2 ctx) )
# 940 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 265 "parser.mly"
      ( fun ctx -> TmPred(_1, _2 ctx) )
# 948 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 267 "parser.mly"
      ( fun ctx -> TmIsZero(_1, _2 ctx) )
# 956 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 269 "parser.mly"
      ( fun ctx ->
          TmFix(_1, _2 ctx) )
# 965 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 274 "parser.mly"
      ( _1 )
# 972 "parser.ml"
               : 'TermSeq))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'TermSeq) in
    Obj.repr(
# 276 "parser.mly"
      ( fun ctx ->
          TmApp(_2, TmAbs(_2, "_", TyUnit, _3 (addname ctx "_")), _1 ctx) )
# 982 "parser.ml"
               : 'TermSeq))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'TermSeq) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 282 "parser.mly"
      ( _2 )
# 991 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'Type) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 284 "parser.mly"
      ( fun ctx -> TmInert(_1, _3 ctx) )
# 1001 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 286 "parser.mly"
      ( fun ctx -> TmTrue(_1) )
# 1008 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 288 "parser.mly"
      ( fun ctx -> TmFalse(_1) )
# 1015 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string Support.Error.withinfo) in
    Obj.repr(
# 290 "parser.mly"
      ( fun ctx ->
          TmVar(_1.i, name2index _1.i ctx _1.v, ctxlength ctx) )
# 1023 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string Support.Error.withinfo) in
    Obj.repr(
# 293 "parser.mly"
      ( fun ctx -> TmString(_1.i, _1.v) )
# 1030 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'Fields) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 295 "parser.mly"
      ( fun ctx ->
          TmRecord(_1, _2 ctx 1) )
# 1040 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : float Support.Error.withinfo) in
    Obj.repr(
# 298 "parser.mly"
      ( fun ctx -> TmFloat(_1.i, _1.v) )
# 1047 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int Support.Error.withinfo) in
    Obj.repr(
# 300 "parser.mly"
      ( fun ctx ->
          let rec f n = match n with
              0 -> TmZero(_1.i)
            | n -> TmSucc(_1.i, f (n-1))
          in f _1.v )
# 1058 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 6 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string Support.Error.withinfo) in
    let _3 = (Parsing.peek_val __caml_parser_env 4 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'Term) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 306 "parser.mly"
      ( fun ctx ->
          TmTag(_1, _2.v, _4 ctx, _7 ctx) )
# 1072 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 309 "parser.mly"
      ( fun ctx -> TmUnit(_1) )
# 1079 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    Obj.repr(
# 313 "parser.mly"
      ( fun ctx i -> [] )
# 1085 "parser.ml"
               : 'Fields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'NEFields) in
    Obj.repr(
# 315 "parser.mly"
      ( _1 )
# 1092 "parser.ml"
               : 'Fields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Field) in
    Obj.repr(
# 319 "parser.mly"
      ( fun ctx i -> [_1 ctx i] )
# 1099 "parser.ml"
               : 'NEFields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Field) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'NEFields) in
    Obj.repr(
# 321 "parser.mly"
      ( fun ctx i -> (_1 ctx i) :: (_3 ctx (i+1)) )
# 1108 "parser.ml"
               : 'NEFields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 325 "parser.mly"
      ( fun ctx i -> (_1.v, _3 ctx) )
# 1117 "parser.ml"
               : 'Field))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 327 "parser.mly"
      ( fun ctx i -> (string_of_int i, _1 ctx) )
# 1124 "parser.ml"
               : 'Field))
; (fun __caml_parser_env ->
    Obj.repr(
# 331 "parser.mly"
      ( fun ctx -> TyVarBind )
# 1130 "parser.ml"
               : 'TyBinder))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 333 "parser.mly"
      ( fun ctx -> TyAbbBind(_2 ctx) )
# 1138 "parser.ml"
               : 'TyBinder))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Case) in
    Obj.repr(
# 337 "parser.mly"
      ( fun ctx -> [_1 ctx] )
# 1145 "parser.ml"
               : 'Cases))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Case) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Cases) in
    Obj.repr(
# 339 "parser.mly"
      ( fun ctx -> (_1 ctx) :: (_3 ctx) )
# 1154 "parser.ml"
               : 'Cases))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 6 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string Support.Error.withinfo) in
    let _3 = (Parsing.peek_val __caml_parser_env 4 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : string Support.Error.withinfo) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'AppTerm) in
    Obj.repr(
# 343 "parser.mly"
      ( fun ctx ->
          let ctx1 = addname ctx _4.v in
          (_2.v, (_4.v, _7 ctx1)) )
# 1169 "parser.ml"
               : 'Case))
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
