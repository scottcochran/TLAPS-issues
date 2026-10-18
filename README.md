# TLAPS soundness reproductions

Two self-contained reproductions of false theorems that the TLA+ Proof System (`tlapm`, [tlaplus/tlapm](https://github.com/tlaplus/tlapm)) proves.
Each directory holds a module, TLC configurations that refute the same statements, a run script, the prover's own
backend inputs as evidence, and results on two builds: `7824dab` (the `1.6.0-pre` rolling pre-release as of
2026-10-03) and `901ae51` (the same tag as of 2026-10-16, current `main`). Both tested on arm64-darwin only.

| Directory | Defect |
|---|---|
| [`issue1-binder/`](issue1-binder/) | A term tlapm does not translate (an unexpanded `ENABLED`, a temporal formula) is abstracted as a **nullary** constant, dropping the variable bound around it. `(\E t \in S : ENABLED A(t)) => (\A t \in S : ENABLED A(t))` proves on SMT, Zenon and Isabelle. |
| [`issue2-names/`](issue2-names/) | Abstracted terms and LS4 atoms are named by **20 bits of an MD5** of their printed form, with no collision check, and the print shows a bound variable as a constant of its name. `[]D33 => []E280` proves by SMT, `R63 => R699` by PTL, and a variable capture proves `[]Q => [](P(k))` deterministically. |

Each module pairs every unsound theorem with a control of the same shape that the prover correctly rejects.
The README in each directory is written as the issue report.

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
