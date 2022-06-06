;; vim:     fdm=marker:et:sw=2:fdl=0:
;; title:   game title
;; author:  saud
;; desc:    short description
;; site:    website link
;; license: MIT License (change this to your license of choice)
;; version: 0.1
;; script:  fennel
;; strict:  true

; Macros & Utils {{{

(macro enum! [...]
  "Create 1-indexed enums for given array of keys.

  Usage:
    (enum! E1 E2 E3)
  Compiles down to:
    (local [E1 E2 E3] [1 2 3])"
  `(local ,[...] ,(icollect [i (ipairs [...])] i)))

(fn state-machine [states-tbl]
  "State machine.
  Use with `enum!`."
  (var current (. states-tbl 1))
  (fn [...]
    (let [next (current ...)]
      (match (type next)
        :number   (set current (. states-tbl next))
        :function (set current next)))
    next))

(fn lerp [a b mu]
  "Linear interpolation."
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

; }}}

; Globals {{{

; }}}

; Main {{{

(local draw-title
  (let [get-scroll-pos (list-loop (init-list 40) 3)]
    (fn []
      (let [scroll-pos (- (get-scroll-pos))]
         (map 0 0 35 22 scroll-pos scroll-pos 14)
         (shadow-print "Game title" 48 22 12 14 3)
         (if (< (% (time) 600) 300)
           (print "Press z to start" 72 94 12))))))

(local Player {
                :x 96
                :y 24
                :sprid (list-loop [0 2] 60)})

;(enum! TITLE INGAME)
(local scene-state
  (let [
        TITLE 1
        INGAME 2
        transition (ticker 90)]
    (state-machine
      { TITLE (fn []
                (draw-title)

                (if (btnp 4)
                  (fn []
                    (let [(done? amt) (transition)]
                      (draw-title)
                      (rect 0 0 240 (lerp 0 136 (/ amt 40)) 0)

                      (if done?
                        INGAME)))))

        INGAME (fn []
                  (print "In Game" 50 50)

                  (if (btn 0)
                    (set Player.y (- Player.y 1)))
                  (if (btn 1)
                    (set Player.y (+ Player.y 1)))
                  (if (btn 2)
                    (set Player.x (- Player.x 1)))
                  (if (btn 3)
                    (set Player.x (+ Player.x 1)))

                  (spr (Player.sprid) Player.x Player.y 14 3 0 0 2 2)

                  nil)})))

(set _G.TIC
  (fn []
    (cls)
    (scene-state)))

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

