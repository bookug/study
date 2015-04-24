type token =
  | TYPE of (Support.Error.info)
  | INERT of (Support.Error.info)
  | LAMBDA of (Support.Error.info)
  | TTOP of (Support.Error.info)
  | IF of (Support.Error.info)
  | THEN of (Support.Error.info)
  | ELSE of (Support.Error.info)
  | TRUE of (Support.Error.info)
  | FALSE of (Support.Error.info)
  | BOOL of (Support.Error.info)
  | LET of (Support.Error.info)
  | IN of (Support.Error.info)
  | FIX of (Support.Error.info)
  | LETREC of (Support.Error.info)
  | USTRING of (Support.Error.info)
  | UNIT of (Support.Error.info)
  | UUNIT of (Support.Error.info)
  | AS of (Support.Error.info)
  | TIMESFLOAT of (Support.Error.info)
  | UFLOAT of (Support.Error.info)
  | SUCC of (Support.Error.info)
  | PRED of (Support.Error.info)
  | ISZERO of (Support.Error.info)
  | NAT of (Support.Error.info)
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
# 76 "parser.ml"
let yytransl_const = [|
    0|]

let yytransl_block = [|
  257 (* TYPE *);
  258 (* INERT *);
  259 (* LAMBDA *);
  260 (* TTOP *);
  261 (* IF *);
  262 (* THEN *);
  263 (* ELSE *);
  264 (* TRUE *);
  265 (* FALSE *);
  266 (* BOOL *);
  267 (* LET *);
  268 (* IN *);
  269 (* FIX *);
  270 (* LETREC *);
  271 (* USTRING *);
  272 (* UNIT *);
  273 (* UUNIT *);
  274 (* AS *);
  275 (* TIMESFLOAT *);
  276 (* UFLOAT *);
  277 (* SUCC *);
  278 (* PRED *);
  279 (* ISZERO *);
  280 (* NAT *);
  281 (* UCID *);
  282 (* LCID *);
  283 (* INTV *);
  284 (* FLOATV *);
  285 (* STRINGV *);
  286 (* APOSTROPHE *);
  287 (* DQUOTE *);
  288 (* ARROW *);
  289 (* BANG *);
  290 (* BARGT *);
  291 (* BARRCURLY *);
  292 (* BARRSQUARE *);
  293 (* COLON *);
  294 (* COLONCOLON *);
  295 (* COLONEQ *);
  296 (* COLONHASH *);
  297 (* COMMA *);
  298 (* DARROW *);
  299 (* DDARROW *);
  300 (* DOT *);
    0 (* EOF *);
  301 (* EQ *);
  302 (* EQEQ *);
  303 (* EXISTS *);
  304 (* GT *);
  305 (* HASH *);
  306 (* LCURLY *);
  307 (* LCURLYBAR *);
  308 (* LEFTARROW *);
  309 (* LPAREN *);
  310 (* LSQUARE *);
  311 (* LSQUAREBAR *);
  312 (* LT *);
  313 (* RCURLY *);
  314 (* RPAREN *);
  315 (* RSQUARE *);
  316 (* SEMI *);
  317 (* SLASH *);
  318 (* STAR *);
  319 (* TRIANGLE *);
  320 (* USCORE *);
  321 (* VBAR *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\002\000\002\000\002\000\005\000\005\000\006\000\
\008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
\008\000\004\000\004\000\007\000\007\000\003\000\003\000\003\000\
\003\000\003\000\003\000\003\000\010\000\010\000\010\000\010\000\
\010\000\010\000\010\000\011\000\011\000\011\000\009\000\009\000\
\013\000\013\000\014\000\014\000\012\000\012\000\016\000\016\000\
\015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
\015\000\015\000\017\000\017\000\018\000\018\000\019\000\019\000\
\000\000"

let yylen = "\002\000\
\001\000\003\000\001\000\002\000\002\000\002\000\002\000\001\000\
\003\000\001\000\001\000\001\000\003\000\001\000\001\000\001\000\
\001\000\000\000\002\000\003\000\001\000\001\000\006\000\006\000\
\006\000\006\000\006\000\008\000\001\000\002\000\002\000\003\000\
\002\000\002\000\002\000\003\000\003\000\001\000\000\000\001\000\
\001\000\003\000\003\000\001\000\003\000\001\000\001\000\003\000\
\003\000\004\000\001\000\001\000\001\000\003\000\001\000\001\000\
\001\000\001\000\000\000\001\000\001\000\003\000\003\000\001\000\
\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\052\000\053\000\000\000\
\000\000\000\000\056\000\000\000\000\000\000\000\000\000\000\000\
\000\000\058\000\057\000\055\000\001\000\000\000\000\000\065\000\
\000\000\003\000\000\000\000\000\038\000\000\000\000\000\000\000\
\000\000\051\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\004\000\000\000\000\000\005\000\
\000\000\064\000\000\000\060\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\011\000\012\000\014\000\015\000\016\000\
\017\000\010\000\000\000\000\000\000\000\008\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\019\000\006\000\
\007\000\000\000\054\000\000\000\000\000\049\000\002\000\036\000\
\037\000\045\000\000\000\044\000\000\000\040\000\000\000\000\000\
\050\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\063\000\062\000\048\000\000\000\013\000\000\000\009\000\020\000\
\000\000\000\000\000\000\000\000\000\000\000\000\043\000\042\000\
\023\000\024\000\025\000\026\000\027\000\000\000\000\000\028\000"

let yydgoto = "\002\000\
\024\000\025\000\026\000\045\000\048\000\092\000\070\000\071\000\
\093\000\027\000\028\000\029\000\094\000\095\000\030\000\055\000\
\051\000\052\000\053\000"

let yysindex = "\004\000\
\001\000\000\000\211\254\232\254\035\001\000\000\000\000\233\254\
\121\255\243\254\000\000\121\255\121\255\121\255\121\255\225\254\
\223\254\000\000\000\000\000\000\000\000\068\001\035\001\000\000\
\218\254\000\000\121\255\227\254\000\000\009\255\203\255\247\254\
\248\254\000\000\024\255\242\254\244\254\227\254\251\254\084\001\
\227\254\227\254\227\254\203\255\000\000\203\255\035\001\000\000\
\246\254\000\000\235\254\000\000\252\254\240\254\255\254\001\000\
\227\254\237\254\203\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\224\000\203\255\236\254\000\000\014\255\203\255\
\203\255\035\001\035\001\035\001\203\255\227\254\000\000\000\000\
\000\000\035\001\000\000\068\001\035\001\000\000\000\000\000\000\
\000\000\000\000\013\255\000\000\001\255\000\000\019\255\007\255\
\000\000\203\255\022\255\023\255\061\255\060\255\066\255\036\255\
\000\000\000\000\000\000\203\255\000\000\224\000\000\000\000\000\
\035\001\035\001\035\001\035\001\035\001\035\001\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\070\255\035\001\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\025\255\
\209\000\000\000\000\000\000\000\000\000\027\255\000\000\000\000\
\000\000\000\000\004\255\152\255\000\000\112\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\188\255\000\000\000\000\
\029\000\065\000\101\000\000\000\000\000\000\000\000\000\000\000\
\238\000\000\000\000\000\000\000\029\255\031\255\000\000\000\000\
\137\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\030\255\000\000\000\000\000\000\047\255\000\000\
\000\000\000\000\000\000\000\000\000\000\173\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\033\255\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\037\000\000\000\251\255\000\000\000\000\231\255\252\255\000\000\
\000\000\000\000\011\000\000\000\241\255\000\000\000\000\013\000\
\000\000\012\000\000\000"

let yytablesize = 649
let yytable = "\035\000\
\021\000\032\000\036\000\046\000\001\000\069\000\088\000\089\000\
\031\000\022\000\022\000\047\000\039\000\044\000\058\000\022\000\
\050\000\054\000\079\000\038\000\080\000\056\000\040\000\041\000\
\042\000\043\000\059\000\072\000\073\000\074\000\075\000\077\000\
\076\000\090\000\082\000\083\000\084\000\057\000\097\000\033\000\
\037\000\081\000\096\000\085\000\022\000\098\000\099\000\100\000\
\021\000\108\000\078\000\104\000\021\000\021\000\021\000\021\000\
\086\000\109\000\021\000\110\000\022\000\022\000\021\000\022\000\
\111\000\113\000\114\000\115\000\101\000\102\000\103\000\116\000\
\021\000\021\000\021\000\021\000\105\000\117\000\050\000\054\000\
\118\000\127\000\119\000\059\000\018\000\061\000\039\000\021\000\
\047\000\041\000\021\000\021\000\087\000\112\000\120\000\106\000\
\021\000\107\000\000\000\021\000\000\000\000\000\000\000\021\000\
\021\000\021\000\021\000\121\000\122\000\123\000\124\000\125\000\
\126\000\046\000\000\000\000\000\000\000\046\000\046\000\046\000\
\046\000\128\000\003\000\046\000\000\000\000\000\000\000\046\000\
\006\000\007\000\000\000\000\000\000\000\000\000\000\000\000\000\
\011\000\046\000\046\000\046\000\046\000\000\000\000\000\000\000\
\000\000\000\000\034\000\018\000\019\000\020\000\000\000\000\000\
\046\000\029\000\000\000\046\000\000\000\029\000\029\000\029\000\
\029\000\046\000\000\000\029\000\046\000\000\000\000\000\029\000\
\046\000\046\000\022\000\046\000\000\000\023\000\000\000\000\000\
\000\000\029\000\029\000\029\000\029\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\031\000\000\000\000\000\
\029\000\031\000\031\000\031\000\031\000\000\000\000\000\031\000\
\000\000\029\000\000\000\031\000\029\000\000\000\060\000\000\000\
\029\000\029\000\000\000\029\000\061\000\031\000\031\000\031\000\
\031\000\062\000\000\000\063\000\000\000\000\000\064\000\000\000\
\000\000\000\000\065\000\066\000\031\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\031\000\000\000\000\000\
\031\000\000\000\000\000\000\000\031\000\031\000\000\000\031\000\
\000\000\000\000\000\000\000\000\067\000\000\000\000\000\068\000\
\000\000\000\000\003\000\004\000\000\000\005\000\000\000\000\000\
\006\000\007\000\000\000\008\000\000\000\009\000\010\000\000\000\
\011\000\000\000\000\000\012\000\000\000\013\000\014\000\015\000\
\000\000\016\000\017\000\018\000\019\000\020\000\033\000\000\000\
\000\000\000\000\033\000\033\000\033\000\033\000\000\000\000\000\
\033\000\000\000\000\000\000\000\033\000\000\000\000\000\000\000\
\000\000\000\000\022\000\000\000\000\000\023\000\033\000\033\000\
\033\000\033\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\034\000\000\000\000\000\033\000\034\000\034\000\
\034\000\034\000\000\000\000\000\034\000\000\000\033\000\000\000\
\034\000\033\000\000\000\000\000\000\000\033\000\033\000\000\000\
\033\000\000\000\034\000\034\000\034\000\034\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\035\000\000\000\
\000\000\034\000\035\000\035\000\035\000\035\000\000\000\000\000\
\035\000\000\000\034\000\000\000\035\000\034\000\000\000\000\000\
\000\000\034\000\034\000\000\000\034\000\000\000\035\000\035\000\
\035\000\035\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\030\000\000\000\000\000\035\000\030\000\030\000\
\030\000\030\000\000\000\000\000\030\000\000\000\035\000\000\000\
\030\000\035\000\000\000\000\000\000\000\035\000\035\000\000\000\
\035\000\000\000\030\000\030\000\030\000\030\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\032\000\000\000\
\000\000\030\000\032\000\032\000\032\000\032\000\000\000\000\000\
\032\000\000\000\030\000\000\000\032\000\030\000\000\000\000\000\
\000\000\030\000\030\000\000\000\030\000\000\000\032\000\032\000\
\032\000\032\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\051\000\000\000\000\000\032\000\000\000\000\000\
\051\000\051\000\000\000\000\000\000\000\000\000\032\000\000\000\
\051\000\032\000\051\000\060\000\000\000\032\000\032\000\000\000\
\032\000\061\000\051\000\051\000\051\000\051\000\062\000\051\000\
\063\000\000\000\000\000\064\000\000\000\051\000\051\000\065\000\
\066\000\091\000\000\000\000\000\051\000\051\000\000\000\051\000\
\000\000\000\000\051\000\000\000\000\000\051\000\000\000\051\000\
\051\000\051\000\051\000\000\000\051\000\000\000\000\000\000\000\
\000\000\067\000\000\000\000\000\068\000\000\000\051\000\000\000\
\000\000\051\000\000\000\000\000\000\000\000\000\000\000\051\000\
\000\000\000\000\051\000\000\000\003\000\004\000\051\000\005\000\
\000\000\000\000\006\000\007\000\000\000\008\000\000\000\009\000\
\010\000\000\000\011\000\000\000\000\000\012\000\000\000\013\000\
\014\000\015\000\000\000\000\000\034\000\018\000\019\000\020\000\
\000\000\000\000\000\000\000\000\000\000\003\000\004\000\000\000\
\005\000\000\000\000\000\006\000\007\000\000\000\008\000\000\000\
\009\000\010\000\000\000\011\000\022\000\003\000\012\000\023\000\
\013\000\014\000\015\000\006\000\007\000\049\000\018\000\019\000\
\020\000\000\000\000\000\011\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\034\000\018\000\019\000\
\020\000\000\000\000\000\000\000\000\000\022\000\000\000\000\000\
\023\000\000\000\000\000\000\000\000\000\000\000\000\000\058\000\
\000\000\000\000\000\000\000\000\000\000\022\000\000\000\000\000\
\023\000"

let yycheck = "\005\000\
\000\000\026\001\026\001\037\001\001\000\031\000\026\001\027\001\
\054\001\006\001\007\001\045\001\026\001\045\001\044\001\012\001\
\022\000\023\000\044\000\009\000\046\000\060\001\012\000\013\000\
\014\000\015\000\018\001\037\001\037\001\006\001\045\001\037\001\
\045\001\059\000\045\001\057\001\041\001\027\000\059\001\064\001\
\064\001\047\000\068\000\060\001\041\001\032\001\072\000\073\000\
\002\001\037\001\040\000\077\000\006\001\007\001\008\001\009\001\
\058\001\057\001\012\001\041\001\057\001\058\001\016\001\060\001\
\058\001\044\001\044\001\007\001\074\000\075\000\076\000\012\001\
\026\001\027\001\028\001\029\001\082\000\012\001\084\000\085\000\
\045\001\012\001\108\000\057\001\060\001\057\001\057\001\041\001\
\058\001\057\001\044\001\045\001\056\000\098\000\110\000\084\000\
\050\001\085\000\255\255\053\001\255\255\255\255\255\255\057\001\
\058\001\059\001\060\001\113\000\114\000\115\000\116\000\117\000\
\118\000\002\001\255\255\255\255\255\255\006\001\007\001\008\001\
\009\001\127\000\002\001\012\001\255\255\255\255\255\255\016\001\
\008\001\009\001\255\255\255\255\255\255\255\255\255\255\255\255\
\016\001\026\001\027\001\028\001\029\001\255\255\255\255\255\255\
\255\255\255\255\026\001\027\001\028\001\029\001\255\255\255\255\
\041\001\002\001\255\255\044\001\255\255\006\001\007\001\008\001\
\009\001\050\001\255\255\012\001\053\001\255\255\255\255\016\001\
\057\001\058\001\050\001\060\001\255\255\053\001\255\255\255\255\
\255\255\026\001\027\001\028\001\029\001\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\002\001\255\255\255\255\
\041\001\006\001\007\001\008\001\009\001\255\255\255\255\012\001\
\255\255\050\001\255\255\016\001\053\001\255\255\004\001\255\255\
\057\001\058\001\255\255\060\001\010\001\026\001\027\001\028\001\
\029\001\015\001\255\255\017\001\255\255\255\255\020\001\255\255\
\255\255\255\255\024\001\025\001\041\001\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\050\001\255\255\255\255\
\053\001\255\255\255\255\255\255\057\001\058\001\255\255\060\001\
\255\255\255\255\255\255\255\255\050\001\255\255\255\255\053\001\
\255\255\255\255\002\001\003\001\255\255\005\001\255\255\255\255\
\008\001\009\001\255\255\011\001\255\255\013\001\014\001\255\255\
\016\001\255\255\255\255\019\001\255\255\021\001\022\001\023\001\
\255\255\025\001\026\001\027\001\028\001\029\001\002\001\255\255\
\255\255\255\255\006\001\007\001\008\001\009\001\255\255\255\255\
\012\001\255\255\255\255\255\255\016\001\255\255\255\255\255\255\
\255\255\255\255\050\001\255\255\255\255\053\001\026\001\027\001\
\028\001\029\001\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\002\001\255\255\255\255\041\001\006\001\007\001\
\008\001\009\001\255\255\255\255\012\001\255\255\050\001\255\255\
\016\001\053\001\255\255\255\255\255\255\057\001\058\001\255\255\
\060\001\255\255\026\001\027\001\028\001\029\001\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\002\001\255\255\
\255\255\041\001\006\001\007\001\008\001\009\001\255\255\255\255\
\012\001\255\255\050\001\255\255\016\001\053\001\255\255\255\255\
\255\255\057\001\058\001\255\255\060\001\255\255\026\001\027\001\
\028\001\029\001\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\002\001\255\255\255\255\041\001\006\001\007\001\
\008\001\009\001\255\255\255\255\012\001\255\255\050\001\255\255\
\016\001\053\001\255\255\255\255\255\255\057\001\058\001\255\255\
\060\001\255\255\026\001\027\001\028\001\029\001\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\002\001\255\255\
\255\255\041\001\006\001\007\001\008\001\009\001\255\255\255\255\
\012\001\255\255\050\001\255\255\016\001\053\001\255\255\255\255\
\255\255\057\001\058\001\255\255\060\001\255\255\026\001\027\001\
\028\001\029\001\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\002\001\255\255\255\255\041\001\255\255\255\255\
\008\001\009\001\255\255\255\255\255\255\255\255\050\001\255\255\
\016\001\053\001\018\001\004\001\255\255\057\001\058\001\255\255\
\060\001\010\001\026\001\027\001\028\001\029\001\015\001\002\001\
\017\001\255\255\255\255\020\001\255\255\008\001\009\001\024\001\
\025\001\026\001\255\255\255\255\044\001\016\001\255\255\018\001\
\255\255\255\255\050\001\255\255\255\255\053\001\255\255\026\001\
\027\001\028\001\029\001\255\255\060\001\255\255\255\255\255\255\
\255\255\050\001\255\255\255\255\053\001\255\255\041\001\255\255\
\255\255\044\001\255\255\255\255\255\255\255\255\255\255\050\001\
\255\255\255\255\053\001\255\255\002\001\003\001\057\001\005\001\
\255\255\255\255\008\001\009\001\255\255\011\001\255\255\013\001\
\014\001\255\255\016\001\255\255\255\255\019\001\255\255\021\001\
\022\001\023\001\255\255\255\255\026\001\027\001\028\001\029\001\
\255\255\255\255\255\255\255\255\255\255\002\001\003\001\255\255\
\005\001\255\255\255\255\008\001\009\001\255\255\011\001\255\255\
\013\001\014\001\255\255\016\001\050\001\002\001\019\001\053\001\
\021\001\022\001\023\001\008\001\009\001\026\001\027\001\028\001\
\029\001\255\255\255\255\016\001\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\026\001\027\001\028\001\
\029\001\255\255\255\255\255\255\255\255\050\001\255\255\255\255\
\053\001\255\255\255\255\255\255\255\255\255\255\255\255\044\001\
\255\255\255\255\255\255\255\255\255\255\050\001\255\255\255\255\
\053\001"

let yynames_const = "\
  "

let yynames_block = "\
  TYPE\000\
  INERT\000\
  LAMBDA\000\
  TTOP\000\
  IF\000\
  THEN\000\
  ELSE\000\
  TRUE\000\
  FALSE\000\
  BOOL\000\
  LET\000\
  IN\000\
  FIX\000\
  LETREC\000\
  USTRING\000\
  UNIT\000\
  UUNIT\000\
  AS\000\
  TIMESFLOAT\000\
  UFLOAT\000\
  SUCC\000\
  PRED\000\
  ISZERO\000\
  NAT\000\
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
# 123 "parser.mly"
      ( fun ctx -> [],ctx )
# 483 "parser.ml"
               :  Syntax.context -> (Syntax.command list * Syntax.context) ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Command) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 :  Syntax.context -> (Syntax.command list * Syntax.context) ) in
    Obj.repr(
# 125 "parser.mly"
      ( fun ctx ->
          let cmd,ctx = _1 ctx in
          let cmds,ctx = _3 ctx in
          cmd::cmds,ctx )
# 495 "parser.ml"
               :  Syntax.context -> (Syntax.command list * Syntax.context) ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 133 "parser.mly"
      ( fun ctx -> (let t = _1 ctx in Eval(tmInfo t,t)),ctx )
# 502 "parser.ml"
               : 'Command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'TyBinder) in
    Obj.repr(
# 135 "parser.mly"
      ( fun ctx -> ((Bind(_1.i, _1.v, _2 ctx)), addname ctx _1.v) )
# 510 "parser.ml"
               : 'Command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Binder) in
    Obj.repr(
# 137 "parser.mly"
      ( fun ctx -> ((Bind(_1.i,_1.v,_2 ctx)), addname ctx _1.v) )
# 518 "parser.ml"
               : 'Command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 142 "parser.mly"
      ( fun ctx -> VarBind (_2 ctx))
# 526 "parser.ml"
               : 'Binder))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 144 "parser.mly"
      ( fun ctx -> TmAbbBind(_2 ctx, None) )
# 534 "parser.ml"
               : 'Binder))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ArrowType) in
    Obj.repr(
# 149 "parser.mly"
                ( _1 )
# 541 "parser.ml"
               : 'Type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'Type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 154 "parser.mly"
           ( _2 )
# 550 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string Support.Error.withinfo) in
    Obj.repr(
# 156 "parser.mly"
      ( fun ctx ->
          if isnamebound ctx _1.v then
            TyVar(name2index _1.i ctx _1.v, ctxlength ctx)
          else 
            TyId(_1.v) )
# 561 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 162 "parser.mly"
      ( fun ctx -> TyTop )
# 568 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 164 "parser.mly"
      ( fun ctx -> TyBool )
# 575 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'FieldTypes) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 166 "parser.mly"
      ( fun ctx ->
          TyRecord(_2 ctx 1) )
# 585 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 169 "parser.mly"
      ( fun ctx -> TyString )
# 592 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 171 "parser.mly"
      ( fun ctx -> TyUnit )
# 599 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 173 "parser.mly"
      ( fun ctx -> TyFloat )
# 606 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 175 "parser.mly"
      ( fun ctx -> TyNat )
# 613 "parser.ml"
               : 'AType))
; (fun __caml_parser_env ->
    Obj.repr(
# 179 "parser.mly"
      ( fun ctx -> TyVarBind )
# 619 "parser.ml"
               : 'TyBinder))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 181 "parser.mly"
      ( fun ctx -> TyAbbBind(_2 ctx) )
# 627 "parser.ml"
               : 'TyBinder))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'AType) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ArrowType) in
    Obj.repr(
# 187 "parser.mly"
     ( fun ctx -> TyArr(_1 ctx, _3 ctx) )
# 636 "parser.ml"
               : 'ArrowType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'AType) in
    Obj.repr(
# 189 "parser.mly"
            ( _1 )
# 643 "parser.ml"
               : 'ArrowType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'AppTerm) in
    Obj.repr(
# 193 "parser.mly"
      ( _1 )
# 650 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string Support.Error.withinfo) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Type) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 195 "parser.mly"
      ( fun ctx ->
          let ctx1 = addname ctx _2.v in
          TmAbs(_1, _2.v, _4 ctx, _6 ctx1) )
# 664 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Type) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 199 "parser.mly"
      ( fun ctx ->
          let ctx1 = addname ctx "_" in
          TmAbs(_1, "_", _4 ctx, _6 ctx1) )
# 678 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'Term) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 203 "parser.mly"
      ( fun ctx -> TmIf(_1, _2 ctx, _4 ctx, _6 ctx) )
# 690 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string Support.Error.withinfo) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 205 "parser.mly"
      ( fun ctx -> TmLet(_1, _2.v, _4 ctx, _6 (addname ctx _2.v)) )
# 702 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 207 "parser.mly"
      ( fun ctx -> TmLet(_1, "_", _4 ctx, _6 (addname ctx "_")) )
# 714 "parser.ml"
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
# 209 "parser.mly"
      ( fun ctx -> 
          let ctx1 = addname ctx _2.v in 
          TmLet(_1, _2.v, TmFix(_1, TmAbs(_1, _2.v, _4 ctx, _6 ctx1)),
                _8 ctx1) )
# 731 "parser.ml"
               : 'Term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 216 "parser.mly"
      ( _1 )
# 738 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'AppTerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 218 "parser.mly"
      ( fun ctx ->
          let e1 = _1 ctx in
          let e2 = _2 ctx in
          TmApp(tmInfo e1,e1,e2) )
# 749 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 223 "parser.mly"
      ( fun ctx ->
          TmFix(_1, _2 ctx) )
# 758 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'PathTerm) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 226 "parser.mly"
      ( fun ctx -> TmTimesfloat(_1, _2 ctx, _3 ctx) )
# 767 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 228 "parser.mly"
      ( fun ctx -> TmSucc(_1, _2 ctx) )
# 775 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 230 "parser.mly"
      ( fun ctx -> TmPred(_1, _2 ctx) )
# 783 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'PathTerm) in
    Obj.repr(
# 232 "parser.mly"
      ( fun ctx -> TmIsZero(_1, _2 ctx) )
# 791 "parser.ml"
               : 'AppTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'PathTerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string Support.Error.withinfo) in
    Obj.repr(
# 236 "parser.mly"
      ( fun ctx ->
          TmProj(_2, _1 ctx, _3.v) )
# 801 "parser.ml"
               : 'PathTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'PathTerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int Support.Error.withinfo) in
    Obj.repr(
# 239 "parser.mly"
      ( fun ctx ->
          TmProj(_2, _1 ctx, string_of_int _3.v) )
# 811 "parser.ml"
               : 'PathTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'AscribeTerm) in
    Obj.repr(
# 242 "parser.mly"
      ( _1 )
# 818 "parser.ml"
               : 'PathTerm))
; (fun __caml_parser_env ->
    Obj.repr(
# 246 "parser.mly"
      ( fun ctx i -> [] )
# 824 "parser.ml"
               : 'FieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'NEFieldTypes) in
    Obj.repr(
# 248 "parser.mly"
      ( _1 )
# 831 "parser.ml"
               : 'FieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'FieldType) in
    Obj.repr(
# 252 "parser.mly"
      ( fun ctx i -> [_1 ctx i] )
# 838 "parser.ml"
               : 'NEFieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'FieldType) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'NEFieldTypes) in
    Obj.repr(
# 254 "parser.mly"
      ( fun ctx i -> (_1 ctx i) :: (_3 ctx (i+1)) )
# 847 "parser.ml"
               : 'NEFieldTypes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 258 "parser.mly"
      ( fun ctx i -> (_1.v, _3 ctx) )
# 856 "parser.ml"
               : 'FieldType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 260 "parser.mly"
      ( fun ctx i -> (string_of_int i, _1 ctx) )
# 863 "parser.ml"
               : 'FieldType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ATerm) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 264 "parser.mly"
      ( fun ctx -> TmAscribe(_2, _1 ctx, _3 ctx) )
# 872 "parser.ml"
               : 'AscribeTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ATerm) in
    Obj.repr(
# 266 "parser.mly"
      ( _1 )
# 879 "parser.ml"
               : 'AscribeTerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 270 "parser.mly"
      ( _1 )
# 886 "parser.ml"
               : 'TermSeq))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Term) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'TermSeq) in
    Obj.repr(
# 272 "parser.mly"
      ( fun ctx ->
          TmApp(_2, TmAbs(_2, "_", TyUnit, _3 (addname ctx "_")), _1 ctx) )
# 896 "parser.ml"
               : 'TermSeq))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'TermSeq) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 278 "parser.mly"
      ( _2 )
# 905 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'Type) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 280 "parser.mly"
      ( fun ctx -> TmInert(_1, _3 ctx) )
# 915 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string Support.Error.withinfo) in
    Obj.repr(
# 282 "parser.mly"
      ( fun ctx ->
          TmVar(_1.i, name2index _1.i ctx _1.v, ctxlength ctx) )
# 923 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 285 "parser.mly"
      ( fun ctx -> TmTrue(_1) )
# 930 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 287 "parser.mly"
      ( fun ctx -> TmFalse(_1) )
# 937 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Support.Error.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'Fields) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 289 "parser.mly"
      ( fun ctx ->
          TmRecord(_1, _2 ctx 1) )
# 947 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string Support.Error.withinfo) in
    Obj.repr(
# 292 "parser.mly"
      ( fun ctx -> TmString(_1.i, _1.v) )
# 954 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Support.Error.info) in
    Obj.repr(
# 294 "parser.mly"
      ( fun ctx -> TmUnit(_1) )
# 961 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : float Support.Error.withinfo) in
    Obj.repr(
# 296 "parser.mly"
      ( fun ctx -> TmFloat(_1.i, _1.v) )
# 968 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int Support.Error.withinfo) in
    Obj.repr(
# 298 "parser.mly"
      ( fun ctx ->
          let rec f n = match n with
              0 -> TmZero(_1.i)
            | n -> TmSucc(_1.i, f (n-1))
          in f _1.v )
# 979 "parser.ml"
               : 'ATerm))
; (fun __caml_parser_env ->
    Obj.repr(
# 306 "parser.mly"
      ( fun ctx i -> [] )
# 985 "parser.ml"
               : 'Fields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'NEFields) in
    Obj.repr(
# 308 "parser.mly"
      ( _1 )
# 992 "parser.ml"
               : 'Fields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Field) in
    Obj.repr(
# 312 "parser.mly"
      ( fun ctx i -> [_1 ctx i] )
# 999 "parser.ml"
               : 'NEFields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Field) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'NEFields) in
    Obj.repr(
# 314 "parser.mly"
      ( fun ctx i -> (_1 ctx i) :: (_3 ctx (i+1)) )
# 1008 "parser.ml"
               : 'NEFields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string Support.Error.withinfo) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Support.Error.info) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 318 "parser.mly"
      ( fun ctx i -> (_1.v, _3 ctx) )
# 1017 "parser.ml"
               : 'Field))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Term) in
    Obj.repr(
# 320 "parser.mly"
      ( fun ctx i -> (string_of_int i, _1 ctx) )
# 1024 "parser.ml"
               : 'Field))
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
