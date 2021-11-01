;; vim: fdm=marker:et:sw=2:
;; title: test
;; desc: test
;; script: fennel

(var t 0)
(var x 96)
(var y 24)

; Macros {{{

(macro enum [...]
  "Create 1-indexed enums for given array of keys

  Usage:
    (enum E1 E2 E3)
  Compiles down to:
    (local [E1 E2 E3] [1 2 3])"
  `(local ,[...] ,(icollect [i (ipairs [...])] i)))

; }}}

; Utils {{{


; }}}

; Main {{{

(global TIC
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

    (spr (+ 1 (* 2 (// (% t 60) 30))) x y 14 3 0 0 2 2)
    (print "HELLO WORLD" 84 84)

    (set t (+ t 1))))

; }}}

; Metadata {{{

;; <TILES>
;; 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
;; 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
;; 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
;; 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
;; 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
;; 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
;; 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
;; 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
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

