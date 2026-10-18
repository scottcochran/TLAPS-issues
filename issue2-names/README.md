# tlapm proves false theorems: abstracted terms are named by 20 bits of a hash, and the hashed print does not distinguish a bound variable from a constant of the same name

**Builds tested, both arm64-darwin, identical results:**

| Build | Source | sha256 of `bin/tlapm` | Date tested |
|---|---|---|---|
| 7824dab | `1.6.0-pre` rolling pre-release as of 2026-10-03 | e150fb793fb28592… | 2026-10-18 |
| **901ae51** | **`1.6.0-pre` rolling pre-release as of 2026-10-16 (current main)** | 940a42ab3f5b51d3… | 2026-10-18 |

Backends: Z3 4.8.9, Zenon 0.8.4, Isabelle2025, LS4.

## Summary

When tlapm abstracts a term for a backend (an opaque constant for SMT, Zenon and Isabelle; an atom for LS4), it names
it `h` + the first five hex digits of the MD5 of the term **as its printer renders it**. Two consequences:

1. **Collisions are not checked.** Twenty bits, and no test that the terms of one obligation got distinct names. Two
   terms that share a name are one symbol to the backend. `md5("[]STATE_D33_")` and `md5("[]STATE_E280_")` both begin
   `4cb21`, so `[]D33 => []E280` proves `BY SMT` for *any* hidden `D33` and `E280`. `md5("STATE_R63_")` and
   `md5("STATE_R699_")` both begin `0823c`, so `R63 => R699` proves `BY PTL`. A colliding pair is found offline in
   about a thousand tries; by accident an obligation with k names collides with probability about k(k-1)/2^21.
2. **The hashed print captures.** It renders a bound variable exactly as it renders a constant of the same name. So
   with `P(z) == \E k \in D : w = <<k, z>>` and `Q == \E k \in D : w = <<k, k>>`, the term `[](P(k))` for a `NEW`
   constant `k` prints as `[]Q` does and gets its name. `ASSUME NEW k \in D PROVE []Q => [](P(k))` proves
   `BY DEF P, Q`. It is false. The same step with the constant named `c` fails, as it should. This is deterministic,
   needs no hash accident, and survives every renaming that renames each identifier alike.

Each unsound theorem is paired with a control of the same shape whose names do not collide; every control fails on
every backend. TLC refutes all three false statements at `D = {1, 2}`.

Note the name of a hidden definition is a function of its *source name only*, so a proof author cannot see
or avoid a collision from the module text.

## Files

| File | What |
|---|---|
| `NameUnsound.tla` | Three false theorems that prove, three controls that fail |
| `NameUnsound_A.cfg`, `_B.cfg`, `_C.cfg` | TLC refutations: `HashSMTProp` (PROPERTY), `HashPTLProp` (INVARIANT), `CaptureProp` (PROPERTY) |
| `run.sh` | Prover verdict per obligation, the names in every backend input, then the three TLC runs |
| `results-2026.10.18.txt` | Output on 7824dab |
| `results-2026.10.18-901ae51.txt` | Output on 901ae51, current main |
| `evidence-7824dab/` | The SMT and LS4 inputs tlapm wrote (`--debug tempfiles`), one per theorem, named by theorem |
| `evidence-901ae51/` | The same from 901ae51 |

## Result on 7824dab and on 901ae51 (identical)

```
  line 25  proved   smt        HashSMT          []D33 => []E280            (names: h4cb21 only)
  line 27  failed   smt        Control_HashSMT  []D33 => []D34             (names: h4cb21, h43490)
  line 37  proved   ls4        HashPTL          R63 => R699                (atoms: h0823c -> h0823c)
  line 39  failed   ls4        Control_HashPTL  R63 => R64                 (atoms: h0823c -> hb0a71)
  line 51  proved   smt        Capture          []Q => [](P(k)), NEW k     (names: h4ad56 only)
  line 54  failed   smt/zenon/isabelle  Control_Capture  []Q => [](P(c)), NEW c  (names: h4ad56, h01f29)
```

TLC, `D = {1, 2}`, from the single state `x = 1, y = 3, w = <<1, 1>>`: `HashSMTProp` and `CaptureProp` are violated by
the stuttering behavior, `HashPTLProp` by the initial state.

## Mechanism, from the backend inputs

The LS4 input for `HashPTL` is the whole story in one line (`evidence-7824dab/HashPTL.ls4`):

```
not (((always (cc | ~ cc)) -> (h0823c -> h0823c)))
```

The control's input has two atoms, `h0823c -> hb0a71`, and LS4 correctly finds a model.

For `Capture`, the SMT query declares one opaque constant and uses it on both sides of the implication; the control's
query declares two. Compare `evidence-7824dab/Capture.smt` with `Control_Capture.smt`.

## Checking the hashes

```
python3 -c 'import hashlib; print([hashlib.md5(s.encode()).hexdigest()[:5] for s in ["[]STATE_D33_","[]STATE_E280_","STATE_R63_","STATE_R699_"]])'
# ['4cb21', '4cb21', '0823c', '0823c']
```

## Reproduce

```sh
TLAPS_HOME=/path/to/tlaps ./run.sh      # needs bin/tlapm and lib/tlapm/stdlib/TLAPS.tla under it; TLA2TOOLS=... for TLC
```

## Suggested fix

Name abstracted terms by a counter or by the full digest, and check uniqueness within an obligation; and make the
hashed print alpha-aware (print bound variables with a de Bruijn index or a fresh suffix, as the `--printallobs`
display printer already does).
