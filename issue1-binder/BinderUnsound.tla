---------------------------- MODULE BinderUnsound ----------------------------
(* Minimal reproduction: tlapm abstracts a term it does not translate (an    *)
(* unexpanded ENABLED, or a temporal formula) as a nullary constant, so the  *)
(* variable bound around it is dropped and a false theorem proves.           *)
EXTENDS Naturals, TLAPS

CONSTANT S
VARIABLE x

Init == x \in S
A(t) == x = t /\ x' = t + 1
Next == \E t \in S : A(t)
Spec == Init /\ [][Next]_x

(* State predicate. With S = {1, 2} and x = 1: ENABLED A(1) holds and        *)
(* ENABLED A(2) does not, so this is FALSE. TLC refutes it in the initial    *)
(* state. tlapm proves it.                                                   *)
BadEnabled == (\E t \in S : ENABLED A(t)) => (\A t \in S : ENABLED A(t))

THEOREM BadEnabled_OBVIOUS == BadEnabled BY DEF BadEnabled
THEOREM BadEnabled_SMT     == BadEnabled BY SMT DEF BadEnabled
THEOREM BadEnabled_Zenon   == BadEnabled BY Zenon DEF BadEnabled
THEOREM BadEnabled_Isa     == BadEnabled BY Isa DEF BadEnabled

(* Same shape with a temporal body instead of ENABLED. Under Spec with       *)
(* S = {1, 2} and x = 2 initially, <>(x = 2) holds and <>(x = 1) does not.   *)
BadEventuallyProp == (\E t \in S : <>(x = t)) => (\A t \in S : <>(x = t))

THEOREM BadEventually == Spec => BadEventuallyProp
BY DEF BadEventuallyProp

(* Control: the same quantifier shape over a term tlapm does translate.      *)
(* This is equally false and must NOT prove. It does not.                    *)
THEOREM Control == (\E t \in S : x = t) => (\A t \in S : x = t)
OBVIOUS
=============================================================================
