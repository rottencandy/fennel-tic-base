;; vim:     fdm=marker:et:sw=2:fdl=0:
;; title:   game title
;; author:  saud
;; desc:    short description
;; site:    website link
;; license: MIT License (change this to your license of choice)
;; version: 0.1
;; script:  fennel
;; strict:  true

; Globals & consts {{{

(local UP  0)
(local DWN 1)
(local LFT 2)
(local RGT 3)
(local A   4)
(local B   5)
(local X   6)
(local Y   7)

; }}}

; Macros & Utils {{{

(macro enum! [...]
  "Create 1-indexed enums for given array of keys.

  Usage:
    (enum! E1 E2 E3)
  Compiles down to:
    (local [E1 E2 E3] [1 2 3])"
  `(local ,[...] ,(icollect [i (ipairs [...])] i)))

(macro --! [val]
  "Like x--, only works with table fields and vars."
  `(set ,val (- ,val 1)))

(macro ++! [val]
  "Like x++, only works with table fields and vars."
  `(set ,val (+ ,val 1)))

(macro state-machine! [states-tbl initial]
  "State machine.

  Usage:
    (state-machine! {S0 (fn [] S1)
                     S1 (fn [] S0)}
                    S0)
  "
  (assert-compile (table? states-tbl) "expected table for states-tbl" states-tbl)
  (assert-compile (sym? initial) "expected symbol for initial value" initial)

  (let [keys# (icollect [k (pairs states-tbl)] k)
        nums# (icollect [i (ipairs keys#)] i)]

    `(let [,keys#  ,nums#
           states# ,states-tbl]
      (var current# (. states# ,initial))
      (fn [...]
        (let [next# (current# ...)]
          (match (type next#)
            :number   (set current# (. states# next#))
            :function (set current# next#))
          next#)))))

(fn lerp [a b mu]
  "Classic linear interpolation."
  (+ (* a (- 1 mu)) (* b mu)))

(fn init-list [max]
  "Creates a sequential list of numbers from 1 to `max`."
  (let [list []]
    (for [i 1 max]
      (table.insert list i))
    list))

(fn ticker [interval]
  "Returns true every time `interval` ticks have passed"
  (var ticks 0)
  (fn []
    (set ticks (+ ticks 1))
    (if (> ticks interval)
      (do
        (set ticks 0)
        (values true ticks))
      (values false ticks))))

(fn oscillator [full ondur]
  "Oscillates (flips?) between true and false given duration and on duration.
  This uses `time`, so only works when called every frame.
  TODO find out what this is called in gamedev jargon."
  (< (% (time) full) ondur))

(fn lerp-ticker [interval]
  "Same as ticker but returns lerped value 0 -> 1, and then always returns true."
  (var ticks 0)
  (fn []
    (if (> ticks interval)
      (values true 1.0)
      (do
        (set ticks (+ ticks 1))
        (values false (/ ticks interval))))))

(fn generator [list]
  "Loops over items of list."
  (var idx 1)
  (fn []
    (let [reset? (>= idx (# list))]
      (if reset?
        (set idx 1)
        (set idx (+ idx 1)))
      (values (. list idx) reset?))))

(fn list-loop [list ?interval]
  "Loops over list item every time `interval`(default 1) ticks have passed."
  (var cur-item (. list 1))
  (let [is-time? (ticker (or ?interval 1))
        next-item (generator list)]
    (fn []
      (if (is-time?)
        (let [next (next-item)]
          (set cur-item next)))
      cur-item)))

(fn shadow-print [text x y colfg colbg scale]
  "Print text with shadow."
  (print text (+ x 2) (+ y 2) colbg false scale)
  (print text x       y       colfg false scale))

(fn read-arrows []
  "Returns direction if any arrow key has just been pressed, else nil."
  (if (btnp UP)  UP
      (btnp DWN) DWN
      (btnp LFT) LFT
      (btnp RGT) RGT
      nil))

(fn make-screen-shake [duration intensity]
  "Shake screen using RAM display xy offset method."
  (let [tick (ticker duration)]
    (fn []
      (let [done? (tick)]
        (if done?
          (do
            (memset 0x3FF9 0 2)
            true)
          (do
            (poke 0x3FF9 (math.random (- intensity) intensity))
            (poke (+ 0x3FF9 1) (math.random (- intensity) intensity))
            false))))))

(fn make-spr-shake [duration intensity]
  (let [tick (ticker duration)]
    (fn []
      (let [done? (tick)]
        (if done?
          (values true 0 0)
          (values
            false
            (math.random (- intensity) intensity)
            (math.random (- intensity) intensity)))))))

; }}}

; Main {{{

(var x 20)
(var y 20)
(var t 0)

(local player-st
  (state-machine! {S0 (fn [change?]
                        (spr 1 x y 14 3 0 0 2 2)
                        (if change?
                          S1))
                   S1 (fn [change?]
                        (spr 3 x y 14 3 0 0 2 2)
                        (if change?
                          S0))}
                  S0))

(fn _G.TIC []
  (when (btn UP)  (set y (- y 1)))
  (when (btn DWN) (set y (+ y 1)))
  (when (btn LFT) (set x (- x 1)))
  (when (btn RGT) (set x (+ x 1)))
  (cls 0)
  (player-st (btnp 4))
  (set t (+ t 1)))

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

;; <TRACKS>
;; 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; </TRACKS>

;; <PALETTE>
;; 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
;; </PALETTE>

