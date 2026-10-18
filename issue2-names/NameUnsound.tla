----------------------------- MODULE NameUnsound -----------------------------
(* Minimal reproduction: tlapm names each term it abstracts for a backend,  *)
(* and each atom it hands LS4, by "h" + the first five hex digits of the    *)
(* MD5 of the term as it prints it. It does not check that two terms of one *)
(* obligation get different names, and its print shows a bound variable     *)
(* exactly as a constant of the same name. Two different terms that share a *)
(* name are one symbol to every backend, so false theorems prove.           *)
EXTENDS Naturals, TLAPS

CONSTANT D
VARIABLES x, y, w

Init == x = 1 /\ y = 3 /\ w = <<1, 1>>
Next == UNCHANGED <<x, y, w>>
Spec == Init /\ [][Next]_<<x, y, w>>

(* ---- Part A: hash collision, SMT route ----------------------------------- *)
(* []D33 prints as "[]STATE_D33_" and []E280 as "[]STATE_E280_".              *)
(* md5 of both begins 4cb21, so both are the opaque constant h4cb21.          *)
D33  == x = 1
E280 == x = 2
D34  == x = 2    \* same body as E280, but "[]STATE_D34_" hashes differently

HashSMTProp == []D33 => []E280
THEOREM HashSMT == HashSMTProp BY SMT DEF HashSMTProp         \* FALSE, proves

THEOREM Control_HashSMT == []D33 => []D34 BY SMT              \* FALSE, fails

(* ---- Part B: hash collision, PTL / LS4 route ----------------------------- *)
(* R63 prints as "STATE_R63_" and R699 as "STATE_R699_": both hash to 0823c, *)
(* so LS4 receives one atom h0823c for both.                                 *)
R63  == y = 3
R699 == y = 4
R64  == y = 4    \* same body as R699, but a different name

HashPTLProp == R63 => R699
THEOREM HashPTL == HashPTLProp BY PTL DEF HashPTLProp         \* FALSE, proves

THEOREM Control_HashPTL == R63 => R64 BY PTL                  \* FALSE, fails

(* ---- Part C: capture, no hash accident needed ---------------------------- *)
(* P(k), for a constant k, expands to \E k \in D : w = <<k, k>> where the    *)
(* inner k is bound and the outer k is the constant. It prints exactly as Q  *)
(* does, so [](P(k)) and []Q get one name, and []Q => [](P(k)) proves. It is  *)
(* false: with D = {1, 2}, k = 2 and w = <<1, 1>> forever, Q holds and P(2)  *)
(* does not. The same step with the constant named c fails, as it should.    *)
P(z) == \E k \in D : w = <<k, z>>
Q    == \E k \in D : w = <<k, k>>

THEOREM Capture == ASSUME NEW k \in D PROVE []Q => [](P(k))
BY DEF P, Q                                                   \* FALSE, proves

THEOREM Control_Capture == ASSUME NEW c \in D PROVE []Q => [](P(c))
BY DEF P, Q                                                   \* FALSE, fails

CaptureProp == \A k \in D : []Q => [](P(k))
=============================================================================
