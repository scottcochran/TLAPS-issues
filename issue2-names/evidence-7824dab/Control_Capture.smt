;; Proof obligation:
;;	ASSUME NEW CONSTANT CONSTANT_D_,
;;	       NEW VARIABLE VARIABLE_x_,
;;	       NEW VARIABLE VARIABLE_y_,
;;	       NEW VARIABLE VARIABLE_w_,
;;	       NEW CONSTANT CONSTANT_c_ \in CONSTANT_D_
;;	PROVE  ?h4ad56 => ?h01f29
;; TLA+ Proof Manager 7824dab
;; Proof obligation #10
;; Generated from file "./NameUnsound.tla", line 54, characters 1-2

(set-logic UFNIA)

;; Sorts

(declare-sort Idv 0)

;; Hypotheses

(declare-fun smt__TLA____Anon__OPAQUE__h01f29 () Idv)

(declare-fun smt__TLA____Anon__OPAQUE__h4ad56 () Idv)

(declare-fun smt__TLA____Mem (Idv Idv) Bool)

(declare-fun smt__TLA____SetExtTrigger (Idv Idv) Bool)

(declare-fun smt__TLA____Tt__Idv () Idv)

;; Axiom: SetExt
(assert
  (!
    (forall ((smt__x Idv) (smt__y Idv))
      (!
        (=>
          (forall ((smt__z Idv))
            (= (smt__TLA____Mem smt__z smt__x)
              (smt__TLA____Mem smt__z smt__y))) (= smt__x smt__y))
        :pattern ((smt__TLA____SetExtTrigger smt__x smt__y))))
    :named |SetExt|))

; hidden fact

; hidden fact

; omitted declaration of 'CONSTANT_EnabledWrapper_' (second-order)

; omitted declaration of 'CONSTANT_CdotWrapper_' (second-order)

(declare-fun smt__CONSTANT__D__ () Idv)

(declare-fun smt__VARIABLE__x__ () Idv)

(declare-fun smt__VARIABLE__x____prime () Idv)

(declare-fun smt__VARIABLE__y__ () Idv)

(declare-fun smt__VARIABLE__y____prime () Idv)

(declare-fun smt__VARIABLE__w__ () Idv)

(declare-fun smt__VARIABLE__w____prime () Idv)

(declare-fun smt__STATE__Init__ () Idv)

(declare-fun smt__STATE__Next__ () Idv)

(declare-fun smt__TEMPORAL__Spec__ () Idv)

(declare-fun smt__STATE__D33__ () Idv)

(declare-fun smt__STATE__E280__ () Idv)

(declare-fun smt__STATE__D34__ () Idv)

(declare-fun smt__TEMPORAL__HashSMTProp__ () Idv)

; hidden fact

; hidden fact

(declare-fun smt__STATE__R63__ () Idv)

(declare-fun smt__STATE__R699__ () Idv)

(declare-fun smt__STATE__R64__ () Idv)

(declare-fun smt__STATE__HashPTLProp__ () Idv)

; hidden fact

; hidden fact

; hidden fact

(declare-fun smt__CONSTANT__c__ () Idv)

(assert (smt__TLA____Mem smt__CONSTANT__c__ smt__CONSTANT__D__))

;; Goal
(assert
  (!
    (not
      (=> (= smt__TLA____Anon__OPAQUE__h4ad56 smt__TLA____Tt__Idv)
        (= smt__TLA____Anon__OPAQUE__h01f29 smt__TLA____Tt__Idv)))
    :named |Goal|))

(check-sat)
(exit)
