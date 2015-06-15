/* implement and test double class */

Counter = { get:Unit->Nat, set:Nat->Unit, inc:Unit->Unit };

newCounter = lambda _:Unit.
        let x = ref 1 in
        { get = lambda _:Unit. !x,
          set = lambda i:Nat. x := i
          inc = lambda _:Unit. x := succ(!x) };

CounterRep = { x:Ref Nat };



