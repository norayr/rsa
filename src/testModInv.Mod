MODULE testModInv;
IMPORT Out, RSA;

VAR result: LONGINT;

BEGIN
  Out.String("Testing modular inverse..."); Out.Ln;
  Out.String("Expected: ModInverse(3, 26) = 9"); Out.Ln;
  result := RSA.ModInverse(3, 26);
  Out.String("Computed: "); Out.Int(result, 0); Out.Ln;
END testModInv.
