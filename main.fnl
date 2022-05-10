;; vim: fdm=marker:et:sw=2:fdl=0:
;; title: Untitled Game
;; desc: Test
;; script: fennel

; Globals {{{

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

(fn ticker [interval]
  "Returns true every time `interval` ticks have passed"
  (var ticks 0)
  (fn []
    (set ticks (+ ticks 1))
    (if (> ticks interval)
      (do
        (set ticks 0)
        true)
      false)))

(fn generator [list]
  "Loops over items of list."
  (var idx 1)
  (fn []
    (if (>= idx (# list))
      (set idx 1)
      (set idx (+ idx 1)))
    (. list idx)))

(fn spr-loop [sprs interval]
  "Return next sprite id every time `interval` ticks have passed."
  (var cur-spr (. sprs 1))
  (let [is-time? (ticker interval)
        next-spr (generator sprs)]
    (fn []
      (if (is-time?)
        (set cur-spr (next-spr)))
      cur-spr)))

; }}}

; Main {{{

(var x 96)
(var y 24)

(local PLAYER-SPRS [0 2])

(enum SPR1 SPR2)
(local spr-state
  (state-machine
    { SPR1 (fn [is-pressed?]
            (spr 2 x y 14 3 0 0 2 2)
            (if is-pressed? SPR2))
      SPR2 (fn [is-pressed?]
            (spr 0 x y 14 3 0 0 2 2)
            (if is-pressed? SPR1))}))

(local spr2id (spr-loop PLAYER-SPRS 60))

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

    (spr-state (btnp 4))

    (spr (spr2id) 0 0 14 3 0 0 2 2)))

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

