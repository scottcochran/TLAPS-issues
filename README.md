# TLAPS soundness reproductions

Two self-contained reproductions of false theorems that the TLA+ Proof System (`tlapm`, [tlaplus/tlapm](https://github.com/tlaplus/tlapm)) proves.
Each directory holds a module, TLC configurations that refute the same statements, a run script, the prover's own
backend inputs as evidence, and results on two builds: `7824dab` (the `1.6.0-pre` rolling pre-release as of
2026-10-03) and `901ae51` (the same tag as of 2026-10-16, current `main`). Both tested on arm64-darwin only.

| Directory | Filed as | Defect |
|---|---|---|
| [`issue1-binder/`](issue1-binder/) | [tlaplus/tlapm#309](https://github.com/tlaplus/tlapm/issues/309) | A term tlapm does not translate (an unexpanded `ENABLED`, a temporal formula) is abstracted as a **nullary** constant, dropping the variable bound around it. `(\E t \in S : ENABLED A(t)) => (\A t \in S : ENABLED A(t))` proves on SMT, Zenon and Isabelle. |
| [`issue2-names/`](issue2-names/) | [tlaplus/tlapm#310](https://github.com/tlaplus/tlapm/issues/310) | Abstracted terms and LS4 atoms are named by **20 bits of an MD5** of their printed form, with no collision check, and the print shows a bound variable as a constant of its name. `[]D33 => []E280` proves by SMT, `R63 => R699` by PTL, and a variable capture proves `[]Q => [](P(k))` deterministically. |

Each module pairs every unsound theorem with a control of the same shape that the prover correctly rejects.
The README in each directory is written as the issue report.

## Related upstream issues

| Issue | State | Relation |
|---|---|---|
| [tlaplus/tlapm#197](https://github.com/tlaplus/tlapm/issues/197) Coalescing has issues with abstracting bound variables | open | Issue 1 is the soundness side of this incompleteness report; its workaround does not avoid issue 2 |
| [tlaplus/tlapm#75](https://github.com/tlaplus/tlapm/issues/75) ENABLED is not coalesced | open | Issue 1, for `ENABLED` |
| [tlaplus/tlapm#69](https://github.com/tlaplus/tlapm/issues/69) Instantiated fairness identified with fairness of instantiated action | open | A different soundness defect in `ENABLED`/fairness handling, adjacent to issue 1 |
| [tlaplus/tlapm#120](https://github.com/tlaplus/tlapm/issues/120) Variable renames in LAMBDA | open | Issue 2's capture, seen as a proof passing or failing on a bound name |

Searched 2026-10-18 for hash, md5, collision, capture, shadow, bound variable, coalesce, opaque, nullary, unsound,
false theorem. Nothing reports the hash-width naming or the missing collision check.

## Running

```sh
# tlapm: the rolling pre-release (arm64-darwin or x86_64-linux-gnu), unpacked to ./tlaps
curl -L --fail https://github.com/tlaplus/tlapm/releases/download/1.6.0-pre/tlapm-1.6.0-pre-arm64-darwin.tar.gz \
  | tar -xzf - && mv tlapm-1.6.0-pre-* tlaps
# TLC
curl -L --fail -o tla2tools.jar https://github.com/tlaplus/tlaplus/releases/latest/download/tla2tools.jar

./issue1-binder/run.sh
./issue2-names/run.sh
```

`TLAPS_HOME` and `TLA2TOOLS` override those two locations. Each script prints the prover's verdict per obligation,
then the TLC refutations. Expect each `run.sh` to take under a minute.
