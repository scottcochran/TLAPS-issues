# tlapm proves false theorems: an untranslated term under a binder is abstracted as a nullary constant

**Builds tested, both arm64-darwin, identical results:**

| Build | Source | sha256 of `bin/tlapm` | Date tested |
|---|---|---|---|
| 7824dab | `1.6.0-pre` rolling pre-release as of 2026-10-03 | e150fb793fb28592… | 2026-10-18 |
| **901ae51** | **`1.6.0-pre` rolling pre-release as of 2026-10-16 (current main)** | 940a42ab3f5b51d3… | 2026-10-18 |

Backends: Z3 4.8.9, Zenon 0.8.4, Isabelle2025, LS4.

## Summary

When tlapm hands a backend a term it does not translate, such as an unexpanded `ENABLED A(t)` or a temporal
formula `<>(x = t)`, it abstracts the term as a **nullary** opaque constant. The constant does not depend on the
variable `t` bound around it, so `\E t \in S : F(t)` and `\A t \in S : F(t)` collapse to the same proposition and

    (\E t \in S : ENABLED A(t)) => (\A t \in S : ENABLED A(t))

proves by `OBVIOUS`, `BY SMT`, `BY Zenon` and `BY Isa`. The same statement with `<>(x = t)` in place of
`ENABLED A(t)` proves under `Spec`. Both are false, and TLC refutes both at `S = {1, 2}`.
The control, the same quantifier shape over a term tlapm *does* translate (`x = t`), correctly fails on all three
backends, so this is specifically the abstraction step.

Related: #197 reports the same abstraction failing to prove *true* theorems (incompleteness); this is the soundness
side of that defect. #75 (ENABLED not coalesced) is the same mechanism for ENABLED.

## Files

| File | What |
|---|---|
| `BinderUnsound.tla` | Module: five false theorems that prove, one false control that fails |
| `BinderUnsound.cfg` | TLC: `BadEnabled` as INVARIANT at `S = {1, 2}` |
| `BinderUnsound_live.cfg` | TLC: `BadEventuallyProp` as PROPERTY at `S = {1, 2}` |
| `run.sh` | Runs the prover and both TLC checks; prints verdict per obligation |
| `results-2026.10.18.txt` | Output of `run.sh` on 7824dab |
| `results-2026.10.18-901ae51.txt` | Output of `run.sh` on 901ae51, current main |
| `smt-query-line21.smt` | The SMT query 7824dab wrote for `BadEnabled_SMT` (`--debug tempfiles`) |
| `smt-query-line21-901ae51.smt` | The same query from 901ae51; identical apart from comments |

## Result on 7824dab and on 901ae51 (identical)

```
  line 20  proved   smt        BadEnabled_OBVIOUS
  line 21  proved   smt        BadEnabled_SMT
  line 22  proved   zenon      BadEnabled_Zenon
  line 23  proved   isabelle   BadEnabled_Isa
  line 30  proved   smt        BadEventually  (Spec => BadEventuallyProp)
  line 35  failed   smt/zenon/isabelle   Control  (correct)
```

TLC, `S = {1, 2}`:

```
Error: Invariant BadEnabled is violated by the initial state:
x = 1
```
```
Error: Temporal properties were violated.
State 1: <Initial predicate>  x = 1
State 2: Stuttering
```

## Mechanism, from the SMT query

The goal tlapm sends for `BadEnabled_SMT`. `smt__TLA____Anon__OPAQUE__h32f0e` is declared with no arguments
(`(declare-fun smt__TLA____Anon__OPAQUE__h32f0e () Idv)`, line 18) and is the same term under the `exists` and the
`forall`:

```smt2
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
```

So the backend is asked whether `(\E t \in S : c) => (\A t \in S : c)` holds for a constant `c`, which it does.
The sound abstraction is a function of the bound variables, `(declare-fun h32f0e (Idv) Idv)` applied to `t`,
which is what the coalescing design calls for.

## Reproduce

```sh
TLAPS_HOME=/path/to/tlaps ./run.sh      # needs bin/tlapm and lib/tlapm/stdlib/TLAPS.tla under it; TLA2TOOLS=... for TLC
```
