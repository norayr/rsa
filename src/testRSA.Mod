MODULE testRSA;
IMPORT RSA, Out, SYSTEM, MathL;

VAR
  key: RSA.KeyPair;
  msg, encrypted, decrypted: RSA.BigInt;
  intVal: HUGEINT;

(* Function to Compute GCD *)
PROCEDURE GCD(a, b: HUGEINT): HUGEINT;
VAR temp: HUGEINT;
BEGIN
  WHILE b # 0 DO
    temp := a MOD b;
    a := b;
    b := temp;
  END;
  RETURN a;
END GCD;

BEGIN
  Out.String("Testing RSA with small primes..."); Out.Ln();

  (* Use small primes for testing *)
  key.n := RSA.ToBigInt(323);       (* n = 17 * 19 = 323 *)
  key.phi := RSA.ToBigInt(288);     (* phi = (17-1)*(19-1) = 288 *)
  key.e := RSA.ToBigInt(5);         (* e = 5, coprime with 288 *)

  (* Compute d = e^(-1) mod phi(n) *)
  key.d := RSA.ModInverse(key.e, key.phi);

  (* Verify e * d ≡ 1 (mod phi(n)) *)
  Out.String("Verification: e * d mod phi(n) = ");
  intVal := (RSA.ToInt(key.e) * RSA.ToInt(key.d)) MOD RSA.ToInt(key.phi);
  Out.Int(intVal, 0); Out.Ln();

  IF intVal # 1 THEN
    Out.String("Error: e * d mod phi(n) should be 1!"); Out.Ln();
    HALT(1);
  END;

  (* Print key information *)
  Out.String("RSA Key Pair:"); Out.Ln();
  Out.String("Public key (n, e): "); Out.Int(RSA.ToInt(key.n), 0);
  Out.String(", "); Out.Int(RSA.ToInt(key.e), 0); Out.Ln();
  Out.String("Private key (d): "); Out.Int(RSA.ToInt(key.d), 0); Out.Ln();

  (* Test with a small message *)
  msg := RSA.ToBigInt(42);
  Out.String("Original message: "); Out.Int(RSA.ToInt(msg), 0); Out.Ln();

  (* Encrypt: c = m^e mod n *)
  encrypted := RSA.ModExp(msg, key.e, key.n);
  Out.String("Encrypted message: "); Out.Int(RSA.ToInt(encrypted), 0); Out.Ln();

  (* Decrypt: m = c^d mod n *)
  decrypted := RSA.ModExp(encrypted, key.d, key.n);
  Out.String("Decrypted message: "); Out.Int(RSA.ToInt(decrypted), 0); Out.Ln();

  (* Verify decryption *)
  IF RSA.ToInt(decrypted) = RSA.ToInt(msg) THEN
    Out.String("RSA encryption/decryption SUCCESS!"); Out.Ln();
  ELSE
    Out.String("RSA encryption/decryption FAILED!"); Out.Ln();
    Out.String("Expected: "); Out.Int(RSA.ToInt(msg), 0);
    Out.String(", Got: "); Out.Int(RSA.ToInt(decrypted), 0); Out.Ln();
  END;
END testRSA.
