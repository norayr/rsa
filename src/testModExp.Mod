MODULE testModExp;
IMPORT RSA, Out;

VAR
  base, exp, mod, result: HUGEINT;

BEGIN
  Out.String("Testing modular exponentiation..."); Out.Ln();

  base := 4;
  exp := 13;
  mod := 497;
  result := RSA.ModExp(base, exp, mod);

  Out.String("Expected: 4^13 mod 497 = 445"); Out.Ln();
  Out.String("Computed: "); Out.Int(result, 0); Out.Ln();
END testModExp.
