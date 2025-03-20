MODULE RSA;
IMPORT SYSTEM, Out, Random := ulmRandomGenerators, MathL;

CONST
  BITLEN = 32;
  SMALLPRIMES = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31};

TYPE
  BigInt* = SYSTEM.SET64; (* 64-bit unsigned integer *)
  KeyPair* = RECORD
    n*, e*, d*, phi*: BigInt;
  END;


PROCEDURE ToInt*(n: BigInt): HUGEINT;
VAR i: HUGEINT;
BEGIN
  SYSTEM.GET(SYSTEM.ADR(n), i);
  RETURN i;
  (*RETURN i MOD 2000000000;*)
END ToInt;
(*
PROCEDURE ToInt*(n: BigInt): HUGEINT;
VAR i: HUGEINT;
BEGIN
  SYSTEM.GET(SYSTEM.ADR(n), i);
  Out.String("ToInt: "); Out.Int(ToInt(n), 0); Out.String(" -> "); Out.Int(i, 0); Out.Ln();
  RETURN i;
END ToInt;
*)
(*
PROCEDURE ToBigInt*(n: HUGEINT): BigInt;
VAR b: BigInt;
BEGIN
  SYSTEM.PUT(SYSTEM.ADR(b), n);
  RETURN b;
END ToBigInt;
*)
PROCEDURE ToBigInt*(n: HUGEINT): BigInt;
VAR b: BigInt;
BEGIN
  SYSTEM.PUT(SYSTEM.ADR(b), n);
  Out.String("ToBigInt: "); Out.Int(n, 0); Out.String(" -> "); Out.Int(ToInt(b), 0); Out.Ln();
  RETURN b;
END ToBigInt;


(* Fast modular exponentiation using Exponentiation by Squaring *)
(*
PROCEDURE ModExp*(base, exp, mod: BigInt): BigInt;
VAR
  result: BigInt;
  b, e, m, res: HUGEINT;
BEGIN
  res := 1;
  b := ToInt(base);
  m := ToInt(mod);
  e := ToInt(exp);

  (* Ensure base < mod *)
  b := b MOD m;

  WHILE e > 0 DO
    IF (e MOD 2) = 1 THEN
      res := (res * b) MOD m;
    END;
    e := e DIV 2;
    b := (b * b) MOD m;
  END;

  RETURN ToBigInt(res);
END ModExp;
*)
(*PROCEDURE ModExp*(base, exp, mod: BigInt): BigInt;
VAR
  result: BigInt;
BEGIN
  result := ToBigInt(1);
  base := SYSTEM.VAL(BigInt, ToInt(base) MOD ToInt(mod)); (* Ensure base < mod *)

  WHILE exp # {} DO
    IF exp * {0} # {} THEN (* Check lowest bit *)
      result := SYSTEM.VAL(BigInt, (ToInt(result) * ToInt(base)) MOD ToInt(mod));
    END;
    exp := SYSTEM.VAL(BigInt, ToInt(exp) DIV 2);
    base := SYSTEM.VAL(BigInt, (ToInt(base) * ToInt(base)) MOD ToInt(mod));
  END;

  RETURN SYSTEM.VAL(BigInt, ToInt(result) MOD ToInt(mod)); (* Keep in range *)
END ModExp;
*)
(*
PROCEDURE ModExp*(base, exp, mod: BigInt): BigInt;
VAR
  result: BigInt;
BEGIN
  result := ToBigInt(1);
  base := SYSTEM.VAL(BigInt, ToInt(base) MOD ToInt(mod)); (* Ensure base < mod *)

  WHILE exp # {} DO
    Out.String("ModExp Step: base="); Out.Int(ToInt(base), 0);
    Out.String(" exp="); Out.Int(ToInt(exp), 0);
    Out.String(" result="); Out.Int(ToInt(result), 0); Out.Ln();

    IF exp * {0} # {} THEN (* Check lowest bit *)
      result := SYSTEM.VAL(BigInt, (ToInt(result) * ToInt(base)) MOD ToInt(mod));
    END;
    exp := SYSTEM.VAL(BigInt, ToInt(exp) DIV 2);
    base := SYSTEM.VAL(BigInt, (ToInt(base) * ToInt(base)) MOD ToInt(mod));
  END;

  RETURN SYSTEM.VAL(BigInt, ToInt(result) MOD ToInt(mod)); (* Keep in range *)
END ModExp;
*)
(*
PROCEDURE ModExp*(base, exp, mod: BigInt): BigInt;
VAR
  result: BigInt;
BEGIN
  result := ToBigInt(1);
  base := SYSTEM.VAL(BigInt, ToInt(base) MOD ToInt(mod)); (* Ensure base < mod *)

  WHILE exp # {} DO
    IF exp * {0} # {} THEN
      result := SYSTEM.VAL(BigInt, (ToInt(result) * ToInt(base)) MOD ToInt(mod));
    END;
    exp := SYSTEM.VAL(BigInt, ToInt(exp) DIV 2);
    base := SYSTEM.VAL(BigInt, (ToInt(base) * ToInt(base)) MOD ToInt(mod));
  END;

  (* Print final ModExp result *)
  Out.String("Final ModExp Result: "); Out.Int(ToInt(result), 0); Out.Ln();

  RETURN SYSTEM.VAL(BigInt, ToInt(result) MOD ToInt(mod));
END ModExp;
*)
(*
PROCEDURE ModExp*(base, exp, mod: BigInt): BigInt;
VAR
  res, b, e, m: HUGEINT;
BEGIN
  res := 1;
  b := ToInt(base);
  e := ToInt(exp);
  m := ToInt(mod);

  b := b MOD m; (* Ensure base < mod *)

  WHILE e > 0 DO
    IF (e MOD 2) = 1 THEN
      res := (res * b) MOD m;
    END;
    e := e DIV 2;
    b := (b * b) MOD m;
  END;

  RETURN ToBigInt(res);
END ModExp;
*)
(*
PROCEDURE ModExp*(base, exp, mod: BigInt): BigInt;
VAR
  res, b, e, m: HUGEINT;
BEGIN
  res := 1;
  b := ToInt(base);
  e := ToInt(exp);
  m := ToInt(mod);

  Out.String("Starting ModExp: base="); Out.Int(b, 0);
  Out.String(" exp="); Out.Int(e, 0);
  Out.String(" mod="); Out.Int(m, 0); Out.Ln();

  b := b MOD m; (* Ensure base < mod *)

  WHILE e > 0 DO
    IF (e MOD 2) = 1 THEN
      res := (res * b) MOD m;
    END;
    e := e DIV 2;
    b := (b * b) MOD m;

    (* Print debug info *)
    Out.String("ModExp Step: res="); Out.Int(res, 0);
    Out.String(" b="); Out.Int(b, 0);
    Out.String(" e="); Out.Int(e, 0); Out.Ln();
  END;

  Out.String("Final ModExp Result: "); Out.Int(res, 0); Out.Ln();
  RETURN ToBigInt(res);
END ModExp;
*)
(*
PROCEDURE ModExp*(base, exp, mod: BigInt): BigInt;
VAR
  res, b, e, m: HUGEINT;
BEGIN
  res := 1;
  b := ToInt(base) MOD ToInt(mod);  (* Ensure base < mod *)
  e := ToInt(exp);
  m := ToInt(mod);

  WHILE e > 0 DO
    IF (e MOD 2) = 1 THEN
      res := (res * b) MOD m;
    END;
    e := e DIV 2;
    b := (b * b) MOD m;
  END;

  RETURN ToBigInt(res MOD m);  (* Ensure result stays in range *)
END ModExp;
*)

PROCEDURE ModExp*(base, exp, mod: BigInt): BigInt;
VAR
  res, b, e, m: HUGEINT;
BEGIN
  res := 1;
  b := ToInt(base) MOD ToInt(mod);  (* Ensure base < mod *)
  e := ToInt(exp);
  m := ToInt(mod);

  (* Debug output *)
  Out.String("Starting ModExp: base="); Out.Int(b, 0);
  Out.String(" exp="); Out.Int(e, 0);
  Out.String(" mod="); Out.Int(m, 0); Out.Ln();

  WHILE e > 0 DO
    IF (e MOD 2) = 1 THEN
      (* Use separate temporary variables to avoid overflow *)
      res := (res * b) MOD m;
    END;
    e := e DIV 2;
    b := (b * b) MOD m;

    (* Debug output - keep track of values *)
    Out.String("ModExp Step: res="); Out.Int(res, 0);
    Out.String(" b="); Out.Int(b, 0);
    Out.String(" e="); Out.Int(e, 0); Out.Ln();
  END;

  Out.String("Final Result: "); Out.Int(res, 0); Out.Ln();
  RETURN ToBigInt(res);
END ModExp;

(*
PROCEDURE ModInverse*(e, phi: BigInt): BigInt;
VAR
  t, newt, r, newr, quotient, temp: HUGEINT;
BEGIN
  t := 0;
  newt := 1;
  r := ToInt(phi);
  newr := ToInt(e);

  WHILE newr # 0 DO
    quotient := r DIV newr;

    (* Update values *)
    temp := newt;
    newt := t - quotient * newt;
    t := temp;

    temp := newr;
    newr := r - quotient * newr;
    r := temp;
  END;

  IF r > 1 THEN RETURN ToBigInt(0) END; (* No modular inverse exists *)
  IF t < 0 THEN t := t + ToInt(phi) END;

  RETURN ToBigInt(t);
END ModInverse;
*)
(*
PROCEDURE ModInverse*(a, phi: BigInt): BigInt;
VAR
  t, newt, r, newr, quotient, temp: BigInt;
BEGIN
  t := ToBigInt(0); newt := ToBigInt(1);
  r := phi; newr := a;

  WHILE newr # {} DO
    quotient := SYSTEM.VAL(BigInt, ToInt(r) DIV ToInt(newr));

    (* Debugging *)
    Out.String("ModInverse Step: r="); Out.Int(ToInt(r), 0);
    Out.String(" newr="); Out.Int(ToInt(newr), 0);
    Out.String(" quotient="); Out.Int(ToInt(quotient), 0); Out.Ln();

    temp := newt;
    newt := SYSTEM.VAL(BigInt, ToInt(t) - ToInt(quotient) * ToInt(newt));
    t := temp;

    temp := newr;
    newr := SYSTEM.VAL(BigInt, ToInt(r) - ToInt(quotient) * ToInt(newr));
    r := temp;
  END;

  IF ToInt(r) # 1 THEN RETURN ToBigInt(0) END; (* No modular inverse *)

  IF ToInt(t) < 0 THEN
    t := SYSTEM.VAL(BigInt, ToInt(t) + ToInt(phi));
  END;

  RETURN t;
END ModInverse;
*)
(*
PROCEDURE ModInverse*(e, phi: BigInt): BigInt;
VAR
  t, newt, r, newr, quotient, temp: HUGEINT;
BEGIN
  t := 0; newt := 1;
  r := ToInt(phi);
  newr := ToInt(e);

  WHILE newr # 0 DO
    quotient := r DIV newr;

    temp := newt;
    newt := t - quotient * newt;
    t := temp;

    temp := newr;
    newr := r - quotient * newr;
    r := temp;
  END;

  IF r > 1 THEN RETURN ToBigInt(0) END; (* No modular inverse *)

  IF t < 0 THEN t := t + ToInt(phi) END;

  RETURN ToBigInt(t);
END ModInverse;
*)
(*
PROCEDURE ModInverse*(e, phi: BigInt): BigInt;
VAR
  t, newt, r, newr, quotient, temp: HUGEINT;
BEGIN
  t := 0; newt := 1;
  r := ToInt(phi);
  newr := ToInt(e);

  WHILE newr # 0 DO
    quotient := r DIV newr;

    temp := newt;
    newt := t - quotient * newt;
    t := temp;

    temp := newr;
    newr := r - quotient * newr;
    r := temp;
  END;

  IF r > 1 THEN RETURN ToBigInt(0) END; (* No modular inverse *)

  (* Ensure result is positive *)
  IF t < 0 THEN t := t + ToInt(phi) END;

  RETURN ToBigInt(t MOD ToInt(phi));  (* Keep result in range *)
END ModInverse;
*)
PROCEDURE ModInverse*(e, phi: BigInt): BigInt;
VAR
  t, newt, r, newr, quotient, temp: HUGEINT;
BEGIN
  t := 0; newt := 1;
  r := ToInt(phi);
  newr := ToInt(e);

  WHILE newr # 0 DO
    quotient := r DIV newr;

    temp := newt;
    newt := t - quotient * newt;
    t := temp;

    temp := newr;
    newr := r - quotient * newr;
    r := temp;
  END;

  (* If r ≠ 1, `e` has no modular inverse mod phi(n) *)
  IF r # 1 THEN
    Out.String("Error: `e` has no modular inverse mod phi(n)"); Out.Ln();
    RETURN ToBigInt(0);
  END;

  (* Ensure result is positive *)
  IF t < 0 THEN t := t + ToInt(phi) END;

  RETURN ToBigInt(t MOD ToInt(phi)); (* Keep result within range *)
END ModInverse;



(* Check if a number is prime using SMALLPRIMES and trial division *)
PROCEDURE IsPrime*(n: BigInt): BOOLEAN;
VAR
  i, sqrtN, ni: INTEGER;
  sqrtLong: LONGREAL;
BEGIN
  SYSTEM.GET(SYSTEM.ADR(n), ni);
  IF ni < 2 THEN RETURN FALSE END;
  IF ni IN SMALLPRIMES THEN RETURN TRUE END;
  IF (ni MOD 2) = 0 THEN RETURN FALSE END; (* Even numbers >2 are composite *)

  (* Convert ni to LONGREAL safely *)
  SYSTEM.GET(SYSTEM.ADR(ni), sqrtLong);
  sqrtLong := MathL.sqrt(sqrtLong);

  (* Convert to INTEGER safely *)
  sqrtN := SYSTEM.VAL(INTEGER, MathL.round(sqrtLong));

  i := 3;
  WHILE i <= sqrtN DO
    IF (ni MOD i) = 0 THEN RETURN FALSE END;
    i := i + 2;
  END;

  RETURN TRUE;
END IsPrime;

(* Generate a random prime number *)
PROCEDURE GeneratePrime*(): BigInt;
VAR
  candidate: INTEGER;
  prime: BigInt;
BEGIN
  REPEAT
    (*candidate := SYSTEM.VAL(INTEGER, Random.Val(1000, 5000));*)
    (*candidate := SYSTEM.VAL(INTEGER, Random.Val(30000, 65000));*)
    candidate := SYSTEM.VAL(INTEGER, Random.Val(30000, 65000));
    IF candidate < 0 THEN candidate := -candidate END;  (* Ensure it's positive *)


    prime := ToBigInt(candidate);
  UNTIL IsPrime(prime);
  RETURN prime;
END GeneratePrime;

END RSA.
