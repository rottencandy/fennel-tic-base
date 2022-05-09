;; vim: fdm=marker:et:sw=2:
;; title: test
;; desc: test
;; script: fennel

; Globals {{{

(var x 96)
(var y 24)

; }}}

; Macros {{{

(macro enum [...]
  "Create 1-indexed enums for given array of keys.

  Usage:
    (enum E1 E2 E3)
  Compiles down to:
    (local [E1 E2 E3] [1 2 3])"
  `(local ,[...] ,(icollect [i (ipairs [...])] i)))

; }}}

; Utils {{{

(fn state-machine [states-tbl]
  "State machine.
  Use with `enum`."
  (var state 1)
  (fn [...]
    (let [next ((. states-tbl state) ...)]
      (if next (set state next)))
    state))

(fn lerp [a b mu]
  "Linear interpolation."
  (+ (* a (- 1 mu)) (* b mu)))

; }}}

; Main {{{

(enum SPR1 SPR2)
(local spr-state
  (state-machine
    { SPR1 (fn [is-btn-pressed?]
            (spr 2 x y 14 3 0 0 2 2)
            (if is-btn-pressed? SPR2))
      SPR2 (fn [is-btn-pressed?]
            (spr 0 x y 14 3 0 0 2 2)
            (if is-btn-pressed? SPR1))}))


(set _G.TIC
  (fn []
    (cls 13)

    (if (btn 0)
      (set y (- y 1)))
    (if (btn 1)
      (set y (+ y 1)))
    (if (btn 2)
      (set x (- x 1)))
    (if (btn 3)
      (set x (+ x 1)))

    (spr-state (btnp 4))))

; }}}

; Metadata {{{

;; <TILES>
;; 000:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
;; 001:ccccceee8888cceeaaaa0cee888a0ceeccca0ceeccca0cee0cca0cee0cca0cce
;; 002:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
;; 003:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
;; 016:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
;; 017:ccca00ccaaaa0c0ccaaa0c0caaaa0c0caaaa0ccc8888ccee000cceeecccceeee
;; 018:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
;; 019:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
;; </TILES>

;; <WAVES>
;; 000:00000000ffffffff00000000ffffffff
;; 001:0123456789abcdeffedcba9876543210
;; 002:0123456789abcdef0123456789abcdef
;; </WAVES>

;; <SFX>
;; 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
;; </SFX>

;; <PALETTE>
;; 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
;; </PALETTE>

