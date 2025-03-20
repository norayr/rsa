MODULE RSA;
IMPORT Math, Random := ulmRandomGenerators, SYSTEM, Out;

CONST
  BITLEN = 1024; (* Key length in bits, can be adjusted *)

TYPE
  KeyPair* = RECORD
    n*, e*, d*, phi*: HUGEINT  (* Public modulus, public exponent, private exponent *)
  END;

(* Compute (base^exp) MOD mod using modular exponentiation *)
PROCEDURE ModExp*(base, exp, mod: HUGEINT): HUGEINT;
VAR
  result: HUGEINT;
BEGIN
  result := 1;
  base := base MOD mod;
  WHILE exp > 0 DO
    IF (exp MOD 2) # 0 THEN
      result := (result * base) MOD mod;
    END;
    exp := exp DIV 2;
    base := (base * base) MOD mod;
  END;
  RETURN result;
END ModExp;

(* Compute the greatest common divisor using Euclidean algorithm *)
PROCEDURE GCD(a, b: HUGEINT): HUGEINT;
VAR
  temp: HUGEINT;
BEGIN
  WHILE b # 0 DO
    temp := b;
    b := a MOD b;
    a := temp;
  END;
  RETURN a;
END GCD;

(* Compute modular inverse using the Extended Euclidean algorithm *)
(*
PROCEDURE ModInverse*(e, phi: HUGEINT): HUGEINT;
BEGIN
  RETURN ModExp(e, phi - 1, phi); (* Uses modular exponentiation *)
END ModInverse;
*)

PROCEDURE ModInverse*(e, phi: HUGEINT): HUGEINT;
VAR
  t, newt, r, newr, quotient, temp: HUGEINT;
BEGIN
  t := 0; newt := 1;
  r := phi; newr := e;

  WHILE newr # 0 DO
    quotient := r DIV newr;

    (* Swap t and newt *)
    temp := newt;
    newt := t - quotient * newt;
    t := temp;

    (* Swap r and newr *)
    temp := newr;
    newr := r - quotient * newr;
    r := temp;
  END;

  (* If gcd(e, phi) ≠ 1, no modular inverse exists *)
  IF r # 1 THEN
    Out.String("Error: No modular inverse found!"); Out.Ln();
    RETURN -1
  END;

  (* Ensure result is positive *)
  IF t < 0 THEN
    t := t + phi;
  END;

  (* Debugging output *)
  Out.String("Computed Modular Inverse: "); Out.Int(t, 0); Out.Ln();
  Out.String("(e * d) mod phi: "); Out.Int((e * t) MOD phi, 0); Out.Ln();

  RETURN t
END ModInverse;

(* Generate prime numbers (naïve approach) *)
PROCEDURE GeneratePrime(): HUGEINT;
VAR
  candidate, i, sqrtCandidate: HUGEINT;
  isPrime: BOOLEAN;
BEGIN
  REPEAT
    candidate := Random.Val(1000, 5000); (* Pick a number in range *)
    isPrime := TRUE;

    sqrtCandidate := Math.round(Math.sqrt(SYSTEM.VAL(REAL, candidate))); (* Corrected type conversion *)

    i := 2;
    WHILE i <= sqrtCandidate DO
      IF (candidate MOD i) = 0 THEN
        isPrime := FALSE;
      END;
      INC(i);
    END;

  UNTIL isPrime;
  RETURN candidate;
END GeneratePrime;

(* Generate RSA Key Pair *)
PROCEDURE GenerateKeys*(VAR key: KeyPair);
VAR
  p, q: HUGEINT;
BEGIN
  p := GeneratePrime();
  q := GeneratePrime();
  key.n := p * q;
  key.phi := (p - 1) * (q - 1);

  (* Choose public exponent e *)
  key.e := 65537; (* Common choice *)
  WHILE (GCD(key.e, key.phi) # 1) DO
    key.e := key.e + 2;
  END;

  (* Compute private exponent d *)
  key.d := ModInverse(key.e, key.phi);
  IF key.d = -1 THEN GenerateKeys(key) END; (* Retry if modular inverse fails *)
  Out.String("Checking (e * d) mod phi: ");
  Out.Int((key.e * key.d) MOD key.phi, 0); Out.Ln;

END GenerateKeys;

(* Encrypt a message *)
PROCEDURE Encrypt*(msg, e, n: HUGEINT): HUGEINT;
BEGIN
  RETURN ModExp(msg, e, n);
END Encrypt;

(* Decrypt a message *)
PROCEDURE Decrypt*(cipher, d, n: HUGEINT): HUGEINT;
BEGIN
  RETURN ModExp(cipher, d, n);
END Decrypt;

END RSA.
