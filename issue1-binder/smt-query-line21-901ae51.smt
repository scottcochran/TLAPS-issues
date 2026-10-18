;; Proof obligation:
;;	ASSUME NEW CONSTANT CONSTANT_S_,
;;	       NEW VARIABLE VARIABLE_x_
;;	PROVE  (\E CONSTANT_t_ \in CONSTANT_S_ : ?h32f0e)
;;	       => (\A CONSTANT_t_ \in CONSTANT_S_ : ?h32f0e)
;; TLA+ Proof Manager 901ae51
;; Proof obligation #1
;; Generated from file "./BinderUnsound.tla", line 21, characters 42-43

(set-logic UFNIA)

;; Sorts

(declare-sort Idv 0)

;; Hypotheses

(declare-fun smt__TLA____Anon__OPAQUE__h32f0e () Idv)

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

(declare-fun smt__CONSTANT__S__ () Idv)

(declare-fun smt__VARIABLE__x__ () Idv)

(declare-fun smt__VARIABLE__x____prime () Idv)

(declare-fun smt__STATE__Init__ () Idv)

(declare-fun smt__ACTION__A__ (Idv) Idv)

(declare-fun smt__ACTION__Next__ () Idv)

(declare-fun smt__TEMPORAL__Spec__ () Idv)

; hidden fact

;; Goal
(assert
  (!
    (not
      (=>
        (exists ((smt__CONSTANT__t__ Idv))
          (and (smt__TLA____Mem smt__CONSTANT__t__ smt__CONSTANT__S__)
            (= smt__TLA____Anon__OPAQUE__h32f0e smt__TLA____Tt__Idv)))
        (forall ((smt__CONSTANT__t__ Idv))
          (=> (smt__TLA____Mem smt__CONSTANT__t__ smt__CONSTANT__S__)
            (= smt__TLA____Anon__OPAQUE__h32f0e smt__TLA____Tt__Idv)))))
    :named |Goal|))

(check-sat)
(exit)
