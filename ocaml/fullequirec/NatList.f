/* Implement recursive nat list */

NatList = Rec X. Unit -> <nil:Unit, cons:{Nat, X}>;
NatBody = <nil:Unit, cons:{Nat, NatList}>;
nil = lambda _:Unit. <nil=unit> as NatBody;
cons = lambda n:Nat. lambda l:NatList. lambda _:Unit. <cons={n, l}> as NatBody;
hd = lambda l:NatList. lambda _:Unit. case (l unit) of <nil=u> ==> 0 | <cons=p> ==> p.1;
tl = lambda l:NatList. lambda _:Unit. case (l unit) of <nil=u> ==> l | <cons=p> ==> p.2;

list1 = cons 0 (cons 1 nil);
list2 = fix (lambda l:NatList. cons 1 (cons 2 (lambda _:Unit. l unit)));

hd (tl list1 unit) unit;
hd (tl list2 unit) unit;

