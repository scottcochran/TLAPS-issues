;; Proof obligation:
;;	ASSUME NEW CONSTANT CONSTANT_D_,
;;	       NEW VARIABLE VARIABLE_x_,
;;	       NEW VARIABLE VARIABLE_y_,
;;	       NEW VARIABLE VARIABLE_w_
;;	PROVE  ?h4cb21 => ?h43490
;; TLA+ Proof Manager 901ae51
;; Proof obligation #3
;; Generated from file "./NameUnsound.tla", line 27, characters 43-44

(set-logic UFNIA)

;; Sorts

(declare-sort Idv 0)

;; Hypotheses

(declare-fun smt__TLA____Anon__OPAQUE__h43490 () Idv)

(declare-fun smt__TLA____Anon__OPAQUE__h4cb21 () Idv)

(declare-fun smt__TLA____Tt__Idv () Idv)

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

;; Goal
(assert
  (!
    (not
      (=> (= smt__TLA____Anon__OPAQUE__h4cb21 smt__TLA____Tt__Idv)
        (= smt__TLA____Anon__OPAQUE__h43490 smt__TLA____Tt__Idv)))
    :named |Goal|))

(check-sat)
(exit)
