MODULE testRSA;
IMPORT RSA, Out;

VAR
  key: RSA.KeyPair;
  msg, encrypted, decrypted: LONGINT;

BEGIN
  (* Step 1: Generate RSA Key Pair *)
  RSA.GenerateKeys(key);

  (* Print generated keys *)
  Out.String("Generated RSA Key Pair:"); Out.Ln();
  Out.String("Public key (n, e): "); Out.Int(key.n, 0); Out.String(", "); Out.Int(key.e, 0); Out.Ln();
  Out.String("Private key (d): "); Out.Int(key.d, 0); Out.Ln();

  (* Step 2: Choose a message to encrypt *)
  msg := 42;
  Out.String("Original Message: "); Out.Int(msg, 0); Out.Ln();

  (* Step 3: Encrypt message *)
  encrypted := RSA.Encrypt(msg, key.e, key.n);
  Out.String("Encrypted Message: "); Out.Int(encrypted, 0); Out.Ln();

  (* Step 4: Decrypt message *)
  decrypted := RSA.Decrypt(encrypted, key.d, key.n);
  Out.String("Decrypted Message: "); Out.Int(decrypted, 0); Out.Ln();

  (* Step 5: Verify correctness *)
  IF decrypted = msg THEN
    Out.String("RSA encryption/decryption SUCCESS!"); Out.Ln();
  ELSE
    Out.String("RSA encryption/decryption FAILED!"); Out.Ln();
    Out.String("Check values: "); Out.Ln;
    Out.String("n: "); Out.Int(key.n, 0); Out.String(", e: "); Out.Int(key.e, 0); Out.String(", d: "); Out.Int(key.d, 0); Out.Ln;
    Out.String("phi: "); Out.Int(key.phi, 0); Out.Ln;
    Out.String("Check (e * d) mod phi: "); Out.Int((key.e * key.d) MOD key.phi, 0); Out.Ln;
  END;
END testRSA.

