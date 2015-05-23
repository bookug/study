/* Implement the Instr Counter Class */

CounterRep = {x: Ref Nat};
counterClass = 
    lambda r:CounterRep. 
    { get = lambda _:Unit. !(r.x),
      inc = lambda _:Unit. r.x := succ(!(r.x)) };
newCounter = 
    lambda _:Unit. let r = {x=ref 1} in counterClass r;



resetCounterClass = 
    lambda r:CounterRep.
      let super = counterClass r in
      { get = super.get,
        inc = super.inc,
        reset = lambda _:Unit. r.x := 1 };
newResetCounter =
    lambda _:Unit. let r = {x=ref 1} in resetCounterClass r;



decCounterClass =
    lambda r:CounterRep.
      let super = resetCounterClass r in
      { get = super.get,
        inc = super.inc,
        reset = super.reset,
        dec = lambda _:Unit. r.x := pred(!(r.x)) };
newDecCounter =
    lambda _:Unit. let r = {x=ref 1} in decCounterClass r;

dc = newDecCounter unit;
dc.get unit;
dc.dec unit;
dc.get unit;



BackupCounterRep = { x:Ref Nat, b:Ref Nat };
backupCounterClass = 
    lambda r:BackupCounterRep.
        let super = resetCounterClass r in
        { get = super.get,
          inc = super.inc,
          reset = lambda _:Unit. r.x := !(r.b),
          backup = lambda _:Unit. r.b := !(r.x) };
newBackupCounter =
    lambda _:Unit. let r = { x=ref 1, b=ref 0 } in backupCounterClass r;
bc = newBackupCounter unit;
bc.get unit;
bc.backup unit;
bc.inc unit;
bc.get unit;
bc.reset unit;
bc.get unit;



Backup2CounterRep = { x:Ref Nat, b:Ref Nat, b2:Ref Nat };
backup2CounterClass = 
    lambda r:Backup2CounterRep.
        let super = backupCounterClass r in
        { get = super.get,
          inc = super.inc,
          reset = super.reset,
          backup = super.backup,
          reset2 = lambda _:Unit. r.x := !(r.b2),
          backup2 = lambda _:Unit. r.b2 := !(r.x) };
newBackup2Counter =
          lambda _:Unit. let r = { x=ref 1, b=ref 0, b2=ref 0 } in backup2CounterClass r;
b2c = newBackup2Counter unit;
b2c.get unit;
b2c.backup unit;
b2c.backup2 unit;
b2c.inc unit;
b2c.get unit;
b2c.backup unit;
b2c.get unit;
b2c.reset2 unit;
b2c.get unit;


