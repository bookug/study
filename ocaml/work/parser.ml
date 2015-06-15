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

open Parsing;;
let _ = parse_error;;
# 2 "parser.mly"

open Expr
open Infer

module StringMap = Map.Make (String)

let unary op arg = SCall(SVar op, [arg])
let binary op left right = SCall(SVar op, [left; right])

let replace_ty_constants_with_vars var_name_list ty =
	let env = List.fold_left
		(fun env var_name -> StringMap.add var_name (new_gen_var ()) env)
		StringMap.empty var_name_list
	in
	let rec f = function
		| TConst name as ty -> begin
				try StringMap.find name env
				with Not_found -> ty
			end
		| TApp(name, arg_ty_list) -> TApp(name, List.map f arg_ty_list)
		| TArrow(param_r_ty_list, return_r_ty) ->
				let g = r_ty_map f in
				TArrow(List.map g param_r_ty_list, g return_r_ty)
		| TVar _ as ty -> ty
	in
	f ty

# 70 "parser.ml"
let yytransl_const = [|
  259 (* FUN *);
  260 (* LET *);
  261 (* REC *);
  262 (* IN *);
  263 (* FORALL *);
  264 (* SOME *);
  265 (* AND *);
  266 (* OR *);
  267 (* NOT *);
  268 (* IF *);
  269 (* THEN *);
  270 (* ELSE *);
  271 (* TRUE *);
  272 (* FALSE *);
  273 (* LPAREN *);
  274 (* RPAREN *);
  275 (* LBRACKET *);
  276 (* RBRACKET *);
  277 (* ARROW *);
  278 (* EQUALS *);
  279 (* COMMA *);
  280 (* COLON *);
  281 (* PLUS *);
  282 (* MINUS *);
  283 (* STAR *);
  284 (* SLASH *);
  285 (* PERCENT *);
  286 (* GT *);
  287 (* LT *);
  288 (* GE *);
  289 (* LE *);
  290 (* EQ *);
  291 (* NE *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  257 (* IDENT *);
  258 (* INT *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\003\000\004\000\004\000\004\000\004\000\004\000\
\004\000\007\000\007\000\007\000\007\000\010\000\010\000\011\000\
\011\000\011\000\011\000\011\000\011\000\011\000\008\000\008\000\
\008\000\008\000\008\000\008\000\008\000\013\000\013\000\012\000\
\012\000\012\000\012\000\012\000\012\000\009\000\009\000\009\000\
\009\000\009\000\014\000\014\000\016\000\016\000\016\000\015\000\
\015\000\015\000\018\000\018\000\006\000\006\000\005\000\005\000\
\005\000\020\000\020\000\020\000\020\000\021\000\021\000\024\000\
\024\000\023\000\023\000\022\000\022\000\017\000\017\000\019\000\
\019\000\019\000\025\000\025\000\000\000\000\000\000\000"

let yylen = "\002\000\
\002\000\002\000\002\000\001\000\003\000\005\000\006\000\001\000\
\006\000\001\000\002\000\003\000\003\000\001\000\003\000\001\000\
\002\000\003\000\003\000\003\000\003\000\003\000\001\000\001\000\
\001\000\001\000\003\000\004\000\003\000\001\000\003\000\001\000\
\001\000\001\000\001\000\001\000\001\000\004\000\006\000\005\000\
\008\000\007\000\001\000\003\000\001\000\003\000\005\000\001\000\
\005\000\007\000\001\000\002\000\001\000\005\000\001\000\001\000\
\005\000\004\000\003\000\005\000\007\000\001\000\003\000\001\000\
\003\000\001\000\001\000\003\000\005\000\001\000\005\000\001\000\
\004\000\003\000\001\000\003\000\002\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\023\000\024\000\000\000\000\000\
\000\000\000\000\025\000\026\000\000\000\000\000\077\000\000\000\
\004\000\000\000\008\000\000\000\000\000\000\000\000\000\000\000\
\078\000\000\000\000\000\056\000\000\000\079\000\053\000\000\000\
\000\000\000\000\000\000\000\000\011\000\000\000\000\000\000\000\
\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\033\000\032\000\035\000\034\000\036\000\037\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\002\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\027\000\029\000\000\000\000\000\000\000\
\012\000\013\000\000\000\000\000\020\000\021\000\022\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\074\000\000\000\
\000\000\000\000\062\000\059\000\000\000\038\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\028\000\000\000\
\000\000\073\000\052\000\000\000\000\000\058\000\000\000\066\000\
\067\000\000\000\000\000\000\000\000\000\000\000\040\000\000\000\
\000\000\000\000\048\000\070\000\000\000\000\000\044\000\000\000\
\000\000\031\000\006\000\076\000\057\000\000\000\060\000\000\000\
\000\000\000\000\054\000\000\000\000\000\000\000\000\000\000\000\
\039\000\000\000\007\000\009\000\069\000\065\000\000\000\047\000\
\000\000\000\000\042\000\000\000\061\000\000\000\000\000\041\000\
\000\000\071\000\000\000\049\000\000\000\050\000"

let yydgoto = "\004\000\
\015\000\025\000\030\000\078\000\099\000\032\000\017\000\018\000\
\019\000\020\000\021\000\057\000\079\000\072\000\130\000\073\000\
\131\000\092\000\027\000\028\000\100\000\121\000\064\000\123\000\
\090\000"

let yysindex = "\179\000\
\102\255\040\255\062\255\000\000\000\000\000\000\019\255\005\255\
\006\255\102\255\000\000\000\000\102\255\043\255\000\000\015\000\
\000\000\001\255\000\000\122\255\162\255\018\255\046\255\009\255\
\000\000\030\000\050\255\000\000\056\255\000\000\000\000\084\000\
\090\255\011\255\071\255\077\255\000\000\113\255\094\255\077\255\
\000\000\084\255\040\255\006\255\006\255\006\255\006\255\006\255\
\006\255\006\255\000\000\000\000\000\000\000\000\000\000\000\000\
\006\255\040\255\141\255\103\255\125\255\134\255\142\255\139\255\
\000\000\072\255\141\255\000\000\102\255\146\255\099\255\148\255\
\149\255\102\255\102\255\000\000\000\000\160\255\155\255\152\255\
\000\000\000\000\171\255\171\255\000\000\000\000\000\000\178\255\
\185\255\181\255\141\255\190\255\040\255\072\255\000\000\164\255\
\073\255\009\255\000\000\000\000\191\255\000\000\040\255\102\255\
\108\255\137\255\211\255\207\255\200\255\102\255\000\000\102\255\
\040\255\000\000\000\000\040\255\203\255\000\000\072\255\000\000\
\000\000\193\255\199\255\201\255\040\255\206\255\000\000\202\255\
\140\255\204\255\000\000\000\000\102\255\108\255\000\000\102\255\
\102\255\000\000\000\000\000\000\000\000\102\255\000\000\073\255\
\205\255\164\255\000\000\102\255\141\255\105\255\134\255\102\255\
\000\000\208\255\000\000\000\000\000\000\000\000\072\255\000\000\
\210\255\040\255\000\000\102\255\000\000\091\255\021\255\000\000\
\040\255\000\000\102\255\000\000\209\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\001\000\000\000\150\000\067\000\121\000\000\000\000\000\
\000\000\000\000\134\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\001\000\000\000\000\000\000\000\031\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\017\255\000\000\197\255\212\255\000\000\
\000\000\000\000\000\000\000\000\000\000\112\255\000\000\000\000\
\213\255\000\000\000\000\000\000\000\000\214\255\000\000\163\000\
\000\000\000\000\061\000\091\000\000\000\000\000\000\000\097\000\
\216\255\000\000\217\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\126\255\000\000\000\000\000\000\
\000\000\215\255\000\000\212\255\000\000\136\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\147\000\000\000\000\000\000\000\150\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000\000\000\003\000\040\000\000\000\000\000\005\000\
\000\000\002\000\129\000\000\000\112\000\116\000\090\000\000\000\
\000\000\189\255\156\255\000\000\165\255\234\255\168\255\094\000\
\115\000"

let yytablesize = 442
let yytable = "\101\000\
\016\000\063\000\118\000\016\000\132\000\035\000\005\000\006\000\
\122\000\060\000\037\000\070\000\038\000\036\000\041\000\039\000\
\023\000\042\000\040\000\033\000\011\000\012\000\013\000\115\000\
\043\000\024\000\061\000\143\000\071\000\065\000\017\000\014\000\
\171\000\132\000\072\000\034\000\058\000\072\000\172\000\072\000\
\022\000\026\000\031\000\005\000\006\000\081\000\082\000\023\000\
\036\000\036\000\036\000\036\000\036\000\036\000\036\000\122\000\
\024\000\011\000\012\000\013\000\018\000\036\000\022\000\062\000\
\059\000\170\000\014\000\165\000\029\000\023\000\066\000\102\000\
\022\000\060\000\067\000\124\000\108\000\109\000\024\000\023\000\
\023\000\161\000\080\000\068\000\005\000\006\000\007\000\008\000\
\098\000\024\000\019\000\022\000\074\000\042\000\009\000\010\000\
\015\000\089\000\011\000\012\000\013\000\077\000\005\000\006\000\
\007\000\008\000\127\000\169\000\022\000\014\000\069\000\076\000\
\009\000\010\000\139\000\128\000\011\000\012\000\013\000\104\000\
\072\000\058\000\105\000\058\000\129\000\075\000\093\000\014\000\
\162\000\045\000\044\000\045\000\117\000\055\000\045\000\153\000\
\120\000\062\000\155\000\156\000\150\000\091\000\126\000\068\000\
\157\000\094\000\063\000\023\000\068\000\010\000\160\000\095\000\
\089\000\046\000\163\000\141\000\024\000\133\000\046\000\096\000\
\134\000\097\000\005\000\112\000\147\000\106\000\168\000\072\000\
\151\000\103\000\072\000\107\000\111\000\173\000\083\000\084\000\
\085\000\086\000\087\000\001\000\002\000\003\000\110\000\120\000\
\119\000\088\000\046\000\047\000\048\000\049\000\050\000\051\000\
\052\000\053\000\054\000\055\000\056\000\048\000\049\000\050\000\
\114\000\167\000\046\000\047\000\048\000\049\000\050\000\113\000\
\151\000\116\000\125\000\070\000\136\000\137\000\142\000\144\000\
\145\000\148\000\146\000\066\000\149\000\138\000\135\000\154\000\
\152\000\159\000\174\000\140\000\164\000\166\000\043\000\030\000\
\064\000\000\000\067\000\075\000\051\000\158\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\016\000\000\000\
\000\000\016\000\016\000\000\000\000\000\016\000\016\000\000\000\
\000\000\000\000\016\000\000\000\000\000\000\000\000\000\016\000\
\000\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
\016\000\016\000\016\000\016\000\017\000\000\000\000\000\017\000\
\017\000\000\000\000\000\017\000\017\000\000\000\000\000\000\000\
\017\000\000\000\000\000\000\000\000\000\017\000\000\000\017\000\
\017\000\017\000\017\000\017\000\017\000\017\000\017\000\017\000\
\017\000\017\000\018\000\000\000\000\000\018\000\018\000\000\000\
\014\000\018\000\018\000\014\000\014\000\000\000\018\000\014\000\
\014\000\000\000\000\000\018\000\014\000\018\000\018\000\000\000\
\000\000\014\000\018\000\018\000\018\000\018\000\018\000\018\000\
\019\000\000\000\000\000\019\000\019\000\000\000\015\000\019\000\
\019\000\015\000\015\000\000\000\019\000\015\000\015\000\000\000\
\000\000\019\000\015\000\019\000\019\000\000\000\000\000\015\000\
\019\000\019\000\019\000\019\000\019\000\019\000\072\000\000\000\
\000\000\000\000\000\000\000\000\072\000\072\000\072\000\000\000\
\000\000\000\000\072\000\055\000\072\000\072\000\000\000\072\000\
\000\000\055\000\055\000\055\000\000\000\000\000\000\000\055\000\
\063\000\055\000\000\000\010\000\055\000\000\000\063\000\063\000\
\063\000\000\000\010\000\010\000\063\000\000\000\063\000\010\000\
\005\000\063\000\000\000\000\000\010\000\000\000\000\000\005\000\
\005\000\000\000\000\000\000\000\005\000\000\000\000\000\000\000\
\000\000\005\000"

let yycheck = "\067\000\
\000\000\024\000\094\000\001\000\105\000\001\001\001\001\002\001\
\097\000\001\001\009\000\001\001\010\000\009\000\000\000\013\000\
\008\001\017\001\014\000\001\001\015\001\016\001\017\001\091\000\
\024\001\017\001\018\001\119\000\018\001\000\000\000\000\026\001\
\012\001\134\000\018\001\017\001\019\001\021\001\018\001\023\001\
\001\001\002\000\003\000\001\001\002\001\044\000\045\000\008\001\
\044\000\045\000\046\000\047\000\048\000\049\000\050\000\144\000\
\017\001\015\001\016\001\017\001\000\000\057\000\001\001\024\000\
\019\001\166\000\000\000\159\000\007\001\008\001\021\001\069\000\
\001\001\001\001\019\001\098\000\074\000\075\000\017\001\008\001\
\008\001\149\000\043\000\000\000\001\001\002\001\003\001\004\001\
\017\001\017\001\000\000\001\001\022\001\017\001\011\001\012\001\
\000\000\058\000\015\001\016\001\017\001\018\001\001\001\002\001\
\003\001\004\001\104\000\017\001\001\001\026\001\021\001\018\001\
\011\001\012\001\112\000\008\001\015\001\016\001\017\001\021\001\
\000\000\019\001\024\001\019\001\017\001\013\001\024\001\026\001\
\024\001\018\001\009\001\010\001\093\000\000\000\023\001\133\000\
\097\000\098\000\136\000\137\000\001\001\001\001\103\000\018\001\
\142\000\021\001\000\000\008\001\023\001\000\000\148\000\018\001\
\113\000\018\001\152\000\116\000\017\001\021\001\023\001\018\001\
\024\001\023\001\000\000\012\001\125\000\018\001\164\000\018\001\
\129\000\024\001\021\001\023\001\018\001\171\000\046\000\047\000\
\048\000\049\000\050\000\001\000\002\000\003\000\023\001\144\000\
\021\001\057\000\025\001\026\001\027\001\028\001\029\001\030\001\
\031\001\032\001\033\001\034\001\035\001\027\001\028\001\029\001\
\020\001\162\000\025\001\026\001\027\001\028\001\029\001\023\001\
\169\000\020\001\020\001\001\001\006\001\014\001\012\001\023\001\
\018\001\012\001\018\001\023\001\019\001\110\000\107\000\134\000\
\021\001\021\001\018\001\113\000\021\001\020\001\018\001\018\001\
\018\001\255\255\023\001\020\001\020\001\144\000\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\006\001\255\255\
\255\255\009\001\010\001\255\255\255\255\013\001\014\001\255\255\
\255\255\255\255\018\001\255\255\255\255\255\255\255\255\023\001\
\255\255\025\001\026\001\027\001\028\001\029\001\030\001\031\001\
\032\001\033\001\034\001\035\001\006\001\255\255\255\255\009\001\
\010\001\255\255\255\255\013\001\014\001\255\255\255\255\255\255\
\018\001\255\255\255\255\255\255\255\255\023\001\255\255\025\001\
\026\001\027\001\028\001\029\001\030\001\031\001\032\001\033\001\
\034\001\035\001\006\001\255\255\255\255\009\001\010\001\255\255\
\006\001\013\001\014\001\009\001\010\001\255\255\018\001\013\001\
\014\001\255\255\255\255\023\001\018\001\025\001\026\001\255\255\
\255\255\023\001\030\001\031\001\032\001\033\001\034\001\035\001\
\006\001\255\255\255\255\009\001\010\001\255\255\006\001\013\001\
\014\001\009\001\010\001\255\255\018\001\013\001\014\001\255\255\
\255\255\023\001\018\001\025\001\026\001\255\255\255\255\023\001\
\030\001\031\001\032\001\033\001\034\001\035\001\006\001\255\255\
\255\255\255\255\255\255\255\255\012\001\013\001\014\001\255\255\
\255\255\255\255\018\001\006\001\020\001\021\001\255\255\023\001\
\255\255\012\001\013\001\014\001\255\255\255\255\255\255\018\001\
\006\001\020\001\255\255\006\001\023\001\255\255\012\001\013\001\
\014\001\255\255\013\001\014\001\018\001\255\255\020\001\018\001\
\006\001\023\001\255\255\255\255\023\001\255\255\255\255\013\001\
\014\001\255\255\255\255\255\255\018\001\255\255\255\255\255\255\
\255\255\023\001"

let yynames_const = "\
  FUN\000\
  LET\000\
  REC\000\
  IN\000\
  FORALL\000\
  SOME\000\
  AND\000\
  OR\000\
  NOT\000\
  IF\000\
  THEN\000\
  ELSE\000\
  TRUE\000\
  FALSE\000\
  LPAREN\000\
  RPAREN\000\
  LBRACKET\000\
  RBRACKET\000\
  ARROW\000\
  EQUALS\000\
  COMMA\000\
  COLON\000\
  PLUS\000\
  MINUS\000\
  STAR\000\
  SLASH\000\
  PERCENT\000\
  GT\000\
  LT\000\
  GE\000\
  LE\000\
  EQ\000\
  NE\000\
  EOF\000\
  "

let yynames_block = "\
  IDENT\000\
  INT\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 55 "parser.mly"
                   ( _1 )
# 387 "parser.ml"
               : Expr.s_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'ty) in
    Obj.repr(
# 58 "parser.mly"
                   ( _1 )
# 394 "parser.ml"
               : Expr.s_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'ty_forall) in
    Obj.repr(
# 61 "parser.mly"
                   ( _1 )
# 401 "parser.ml"
               : Expr.s_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'boolean_expr) in
    Obj.repr(
# 64 "parser.mly"
                                               ( _1 )
# 408 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ty) in
    Obj.repr(
# 65 "parser.mly"
                                               ( SCast(_1, _3, None) )
# 416 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'simple_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'ty) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 66 "parser.mly"
                                               ( SCast(_1, _3, Some _5) )
# 425 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 67 "parser.mly"
                                               ( SLet(_2, _4, _6) )
# 434 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'fun_expr) in
    Obj.repr(
# 68 "parser.mly"
                                               ( _1 )
# 441 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 69 "parser.mly"
                                               ( SIf(_2, _4, _6) )
# 450 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'relation_expr) in
    Obj.repr(
# 72 "parser.mly"
                                     ( _1 )
# 457 "parser.ml"
               : 'boolean_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'relation_expr) in
    Obj.repr(
# 73 "parser.mly"
                                     ( unary "not" _2 )
# 464 "parser.ml"
               : 'boolean_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'relation_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'relation_expr) in
    Obj.repr(
# 74 "parser.mly"
                                     ( binary "and" _1 _3 )
# 472 "parser.ml"
               : 'boolean_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'relation_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'relation_expr) in
    Obj.repr(
# 75 "parser.mly"
                                     ( binary "or" _1 _3 )
# 480 "parser.ml"
               : 'boolean_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arithmetic_expr) in
    Obj.repr(
# 78 "parser.mly"
                                                     ( _1 )
# 487 "parser.ml"
               : 'relation_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arithmetic_expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'relation_op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arithmetic_expr) in
    Obj.repr(
# 79 "parser.mly"
                                                     ( binary _2 _1 _3 )
# 496 "parser.ml"
               : 'relation_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'simple_expr) in
    Obj.repr(
# 82 "parser.mly"
                                             ( _1 )
# 503 "parser.ml"
               : 'arithmetic_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'simple_expr) in
    Obj.repr(
# 83 "parser.mly"
                                             ( unary "unary-" _2 )
# 510 "parser.ml"
               : 'arithmetic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arithmetic_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arithmetic_expr) in
    Obj.repr(
# 84 "parser.mly"
                                             ( binary "+" _1 _3 )
# 518 "parser.ml"
               : 'arithmetic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arithmetic_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arithmetic_expr) in
    Obj.repr(
# 85 "parser.mly"
                                             ( binary "-" _1 _3 )
# 526 "parser.ml"
               : 'arithmetic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arithmetic_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arithmetic_expr) in
    Obj.repr(
# 86 "parser.mly"
                                             ( binary "*" _1 _3 )
# 534 "parser.ml"
               : 'arithmetic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arithmetic_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arithmetic_expr) in
    Obj.repr(
# 87 "parser.mly"
                                             ( binary "/" _1 _3 )
# 542 "parser.ml"
               : 'arithmetic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arithmetic_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arithmetic_expr) in
    Obj.repr(
# 88 "parser.mly"
                                             ( binary "%" _1 _3 )
# 550 "parser.ml"
               : 'arithmetic_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 91 "parser.mly"
                                                     ( SVar _1 )
# 557 "parser.ml"
               : 'simple_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 92 "parser.mly"
                                                     ( SInt _1 )
# 564 "parser.ml"
               : 'simple_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 93 "parser.mly"
                                                     ( SBool true )
# 570 "parser.ml"
               : 'simple_expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 94 "parser.mly"
                                                     ( SBool false )
# 576 "parser.ml"
               : 'simple_expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 95 "parser.mly"
                                                     ( _2 )
# 583 "parser.ml"
               : 'simple_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'simple_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'expr_comma_list) in
    Obj.repr(
# 96 "parser.mly"
                                                     ( SCall(_1, _3) )
# 591 "parser.ml"
               : 'simple_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple_expr) in
    Obj.repr(
# 97 "parser.mly"
                                                     ( SCall(_1, []) )
# 598 "parser.ml"
               : 'simple_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 100 "parser.mly"
                                 ( [_1] )
# 605 "parser.ml"
               : 'expr_comma_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_comma_list) in
    Obj.repr(
# 101 "parser.mly"
                                 ( _1 :: _3 )
# 613 "parser.ml"
               : 'expr_comma_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 104 "parser.mly"
         ( "<" )
# 619 "parser.ml"
               : 'relation_op))
; (fun __caml_parser_env ->
    Obj.repr(
# 105 "parser.mly"
         ( ">" )
# 625 "parser.ml"
               : 'relation_op))
; (fun __caml_parser_env ->
    Obj.repr(
# 106 "parser.mly"
         ( "<=" )
# 631 "parser.ml"
               : 'relation_op))
; (fun __caml_parser_env ->
    Obj.repr(
# 107 "parser.mly"
         ( ">=" )
# 637 "parser.ml"
               : 'relation_op))
; (fun __caml_parser_env ->
    Obj.repr(
# 108 "parser.mly"
         ( "==" )
# 643 "parser.ml"
               : 'relation_op))
; (fun __caml_parser_env ->
    Obj.repr(
# 109 "parser.mly"
         ( "!=" )
# 649 "parser.ml"
               : 'relation_op))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 112 "parser.mly"
                                                             ( SFun([(_2, None)], None, _4) )
# 657 "parser.ml"
               : 'fun_expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'param_list) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 113 "parser.mly"
                                                             ( SFun(_3, None, _6) )
# 665 "parser.ml"
               : 'fun_expr))
; (fun __caml_parser_env ->
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 114 "parser.mly"
                                                             ( SFun([], None, _5) )
# 672 "parser.ml"
               : 'fun_expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 5 : 'param_list) in
    let _6 = (Parsing.peek_val __caml_parser_env 2 : 'return_ty) in
    let _8 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 115 "parser.mly"
                                                             ( SFun(_3, Some _6, _8) )
# 681 "parser.ml"
               : 'fun_expr))
; (fun __caml_parser_env ->
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'return_ty) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 116 "parser.mly"
                                                             ( SFun([], Some _5, _7) )
# 689 "parser.ml"
               : 'fun_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'param) in
    Obj.repr(
# 119 "parser.mly"
                           ( [_1] )
# 696 "parser.ml"
               : 'param_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'param) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'param_list) in
    Obj.repr(
# 120 "parser.mly"
                           ( _1 :: _3 )
# 704 "parser.ml"
               : 'param_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 123 "parser.mly"
                               ( (_1, None) )
# 711 "parser.ml"
               : 'param))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ty) in
    Obj.repr(
# 124 "parser.mly"
                               ( (_1, Some (_3, None)) )
# 719 "parser.ml"
               : 'param))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'ty) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 125 "parser.mly"
                               ( (_1, Some (_3, Some _5)) )
# 728 "parser.ml"
               : 'param))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'some_simple_ty) in
    Obj.repr(
# 128 "parser.mly"
                                           ( Plain _1 )
# 735 "parser.ml"
               : 'return_ty))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'ty) in
    Obj.repr(
# 129 "parser.mly"
                                           ( Named(_2, _4) )
# 743 "parser.ml"
               : 'return_ty))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'ty) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 130 "parser.mly"
                                           ( Refined(_2, _4, _6) )
# 752 "parser.ml"
               : 'return_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 133 "parser.mly"
                       ( [_1] )
# 759 "parser.ml"
               : 'ident_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ident_list) in
    Obj.repr(
# 134 "parser.mly"
                       ( _1 :: _2 )
# 767 "parser.ml"
               : 'ident_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ty) in
    Obj.repr(
# 137 "parser.mly"
                                             ( _1 )
# 774 "parser.ml"
               : 'ty_forall))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'ident_list) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'ty) in
    Obj.repr(
# 138 "parser.mly"
                                             ( replace_ty_constants_with_vars _3 _5 )
# 782 "parser.ml"
               : 'ty_forall))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'simple_ty) in
    Obj.repr(
# 141 "parser.mly"
                                                   ( _1 )
# 789 "parser.ml"
               : 'ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'function_ty) in
    Obj.repr(
# 142 "parser.mly"
                                                   ( _1 )
# 796 "parser.ml"
               : 'ty))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'ident_list) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'ty) in
    Obj.repr(
# 143 "parser.mly"
                                          (
				replace_ty_constants_with_vars _3 _5
			)
# 806 "parser.ml"
               : 'ty))
; (fun __caml_parser_env ->
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'function_ret_ty) in
    Obj.repr(
# 148 "parser.mly"
                                                                     ( TArrow([], _4) )
# 813 "parser.ml"
               : 'function_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple_ty) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'function_ret_ty) in
    Obj.repr(
# 149 "parser.mly"
                                                                     ( TArrow([Plain _1], _3) )
# 821 "parser.ml"
               : 'function_ty))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'refined_ty) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'function_ret_ty) in
    Obj.repr(
# 150 "parser.mly"
                                                                     ( TArrow([_2], _5) )
# 829 "parser.ml"
               : 'function_ty))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 'param_ty) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'param_ty_list) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'function_ret_ty) in
    Obj.repr(
# 151 "parser.mly"
                                                                     ( TArrow(_2 :: _4, _7) )
# 838 "parser.ml"
               : 'function_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ty) in
    Obj.repr(
# 154 "parser.mly"
                                 ( Plain _1 )
# 845 "parser.ml"
               : 'function_ret_ty))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'refined_ty) in
    Obj.repr(
# 155 "parser.mly"
                                 ( _2 )
# 852 "parser.ml"
               : 'function_ret_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'param_ty) in
    Obj.repr(
# 158 "parser.mly"
                                   ( [_1] )
# 859 "parser.ml"
               : 'param_ty_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'param_ty) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'param_ty_list) in
    Obj.repr(
# 159 "parser.mly"
                                   ( _1 :: _3 )
# 867 "parser.ml"
               : 'param_ty_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ty) in
    Obj.repr(
# 162 "parser.mly"
                             ( Plain _1 )
# 874 "parser.ml"
               : 'param_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'refined_ty) in
    Obj.repr(
# 163 "parser.mly"
                             ( _1 )
# 881 "parser.ml"
               : 'param_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ty) in
    Obj.repr(
# 166 "parser.mly"
                             ( Named(_1, _3) )
# 889 "parser.ml"
               : 'refined_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'ty) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 167 "parser.mly"
                             ( Refined(_1, _3, _5) )
# 898 "parser.ml"
               : 'refined_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'simple_ty) in
    Obj.repr(
# 170 "parser.mly"
                                                             ( _1 )
# 905 "parser.ml"
               : 'some_simple_ty))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'ident_list) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'simple_ty) in
    Obj.repr(
# 171 "parser.mly"
                                                             (
				replace_ty_constants_with_vars _3 _5
			)
# 915 "parser.ml"
               : 'some_simple_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 176 "parser.mly"
                                                 ( TConst _1 )
# 922 "parser.ml"
               : 'simple_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'ty_comma_list) in
    Obj.repr(
# 177 "parser.mly"
                                                 ( TApp(_1, _3) )
# 930 "parser.ml"
               : 'simple_ty))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'ty) in
    Obj.repr(
# 178 "parser.mly"
                                                 ( _2 )
# 937 "parser.ml"
               : 'simple_ty))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ty) in
    Obj.repr(
# 181 "parser.mly"
                             ( [_1] )
# 944 "parser.ml"
               : 'ty_comma_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ty) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ty_comma_list) in
    Obj.repr(
# 182 "parser.mly"
                             ( _1 :: _3 )
# 952 "parser.ml"
               : 'ty_comma_list))
(* Entry expr_eof *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry ty_eof *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry ty_forall_eof *)
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
let expr_eof (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Expr.s_expr)
let ty_eof (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 2 lexfun lexbuf : Expr.s_ty)
let ty_forall_eof (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 3 lexfun lexbuf : Expr.s_ty)
