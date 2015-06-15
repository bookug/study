/* implement and test double class */
/* NOTICE: class name begin with upper-letter, while others lower */
/*
CounterRep = { x:Ref Nat };
counterClass = lambda r:CounterRep.
    { get = lambda _:Unit. !(r.x),
      inc = lambda _:Unit. r.x := succ(!(r.x)) };
newCounter = lambda _:Unit. let r = {x=ref 1} in
    counterClass r;



resetCounterClass = lambda r:CounterRep. let super = counterClass r in
    { get = super.get,
      inc = super.inc,
      reset = lambda _:Unit. r.x := 1 };
newResetCounter = lambda _:Unit. let r = {x=ref 1} in
    resetCounterClass r;

rc = newResetCounter unit;
rc.get unit;
rc.inc unit;
rc.reset unit;
rc.get unit;
*/





/* below is the main part */

/* DoubleRep = { s:String, p:Nat };     TODO: assign type and check */
DoubleRep = { p:Nat, l:Nat };
doubleClass = lambda r:DoubleRep.
    { get = lambda _:Unit. r };
newDefaultDoubleCounter = lambda _:Unit. let r = {p=0, l=0} in
    doubleClass r;
newDoubleCounter = lambda r:DoubleRep. doubleClass r; 
doubleAdd = lambda d1:DoubleRep. lambda d2:DoubleRep. 
    let r1 = d1.get unit in
    let r2 = d2.get unit in
    if r1.p == r2.p then let l = if r1.l > r2.l then r1.l else r2.l in
    /* TODO: better to define a new structure, can return num,reverse and subtype,dynamic */

dn = newDefaultDoubleCounter unit;
dn.get unit;
dn = let r = {p=1, l=2, s1=1, s2=1} in newDoubleCounter r;
dn.get unit;

