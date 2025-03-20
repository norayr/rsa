MODULE testModExp;
IMPORT Out, RSA;

BEGIN
  Out.String("Testing modular exponentiation..."); Out.Ln;
  Out.String("Expected: 4^13 mod 497 = 445"); Out.Ln;
  Out.String("Computed: "); Out.Int(RSA.ModExp(4, 13, 497), 0); Out.Ln;
END testModExp.

