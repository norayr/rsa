MODULE RSA;
IMPORT Math, Random := ulmRandomGenerators, SYSTEM, Out;

CONST
  BITLEN = 1024; (* Key length in bits, can be adjusted *)

TYPE
  KeyPair* = RECORD
    n*, e*, d*: LONGINT  (* Public modulus, public exponent, private exponent *)
  END;

(* Compute (base^exp) MOD mod using modular exponentiation *)
PROCEDURE ModExp*(base, exp, mod: LONGINT): LONGINT;
VAR
  result: LONGINT;
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
PROCEDURE GCD(a, b: LONGINT): LONGINT;
VAR
  temp: LONGINT;
BEGIN
  WHILE b # 0 DO
    temp := b;
    b := a MOD b;
    a := temp;
  END;
  RETURN a;
END GCD;

(* Compute modular inverse using the Extended Euclidean algorithm *)
PROCEDURE ModInverse*(e, phi: LONGINT): LONGINT;
VAR
  t, newt, r, newr, quotient, temp: LONGINT;
BEGIN
  t := 0; newt := 1;
  r := phi; newr := e;

  WHILE newr # 0 DO
    quotient := r DIV newr;

    temp := newt;
    newt := t - quotient * newt;
    t := temp;

    temp := newr;
    newr := r - quotient * newr;
    r := temp;
  END;

  IF r > 1 THEN RETURN -1 END; (* No modular inverse exists *)
  IF t < 0 THEN t := t + phi END;
  RETURN t;
END ModInverse;

(* Generate prime numbers (naïve approach) *)
PROCEDURE GeneratePrime(): LONGINT;
VAR
  candidate, i, sqrtCandidate: LONGINT;
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
  p, q, phi: LONGINT;
BEGIN
  p := GeneratePrime();
  q := GeneratePrime();
  key.n := p * q;
  phi := (p - 1) * (q - 1);

  (* Choose public exponent e *)
  key.e := 65537; (* Common choice *)
  WHILE (GCD(key.e, phi) # 1) DO
    key.e := key.e + 2;
  END;

  (* Compute private exponent d *)
  key.d := ModInverse(key.e, phi);
  IF key.d = -1 THEN GenerateKeys(key) END; (* Retry if modular inverse fails *)
END GenerateKeys;

(* Encrypt a message *)
PROCEDURE Encrypt*(msg, e, n: LONGINT): LONGINT;
BEGIN
  RETURN ModExp(msg, e, n);
END Encrypt;

(* Decrypt a message *)
PROCEDURE Decrypt*(cipher, d, n: LONGINT): LONGINT;
BEGIN
  RETURN ModExp(cipher, d, n);
END Decrypt;

END RSA.
