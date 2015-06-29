globals [match running-sr-total suitable unsuitable running-suit running-unsuit running-single running-occ]

breed [skippers skipper]

skippers-own [sex health trait partner partnered?]
patches-own [env patch-sr occupied?]

to setup
  ca
  
  ask patches [
    set env random 20
    set pcolor scale-color 53 env -10 30
    set patch-sr 0
    set occupied? false
  ]
  
  create-skippers 200 [
    setxy random-xcor random-ycor
    set size 1
    set shape "dragonfly"
    set trait 5
    set health init-health
    set partnered? false
    set partner nobody
    ifelse random-float 1 < 0.5
        [set sex "male" set color 44]
        [set sex "female" set color 47]
  ]
  
  set suitable patch-set (patches with [(env < 7) and (env > 3)])
  set unsuitable patch-set (patches with [(env > 7) or (env < 3)])
  
  set running-sr-total 0
  set running-suit 0
  set running-unsuit 0
  set running-single 0
  set running-occ 0
  
  reset-ticks
end

to go
  
  if (count skippers with [sex = "male"] = 0) or (count skippers with [sex = "female"] = 0) [stop]
  ;if count skippers >= 4000 [ stop ]
  ;if ticks >= 2800 [stop]
  
  dispersal
  selection
  breeding
  disturbance
  
  ask skippers [
    set partnered? false
    set partner nobody]
  
  tick
end

to dispersal
  ask skippers [
    set match ( env - trait )
    set heading random 360
    
    ;; Male philopatry, only satellite males disperse
    ;let overcap ((count skippers-here with [sex = "male"]) - carrying-cap)
    ;if overcap > 0 [
    ;  ask min-n-of overcap skippers-here with [sex = "male"] [match] [fd random-poisson male-disp]
    ;  ]
    ;; If no overcap (or male is well-matched to env), males don't move
    
    ;; Female philopatry
    if sex = "female" [
      fd random-poisson fem-disp
    ]
    
    ; Males disperse just as females, without philopatry (use this OR philopatry above)
    if sex = "male" [
      fd random-poisson male-disp
    ]
  ]
end

to selection
  ask skippers [
    
    set health health - 5    ;; Some natural age-related mortality exists
    set match ( env - trait )
    if (abs match) > selection-tolerance [set health health - 20 ]
    if health <= 0 [die]
    ;; Carrying capacity now instituted with dispersal, rather than selection
    ]
  
  ;if (count skippers with [sex = "male"] = 0) or (count skippers with [sex = "female"] = 0) [stop]
  ; Apparently 'stop' only exits from the enclosing procedure, not the whole model? Interesting!
  
  ;; Calculate the overall sex ratio by keeping a running tally, and in data analysis, dividing that by the number of ticks
  ;; Final sex ratio far too skewed, small sample sizes
  if count skippers > 0 [
  let current-sr ((count skippers with [sex = "male"]) / (count skippers))
  set running-sr-total (running-sr-total + current-sr) ]
  ;; In data analysis (or earlier, in Behavior Space): sex-ratio = (running-sr-total / ticks)
  
  if count (skippers-on suitable) > 0 [
  let current-suit ((count (skippers-on suitable) with [sex = "male"]) / (count skippers-on suitable))
  set running-suit (running-suit + current-suit) ]
  
  if count (skippers-on unsuitable) > 0 [
  let current-unsuit ((count (skippers-on unsuitable) with [sex = "male"]) / (count skippers-on unsuitable))
  set running-unsuit (running-unsuit + current-unsuit) ]
  
  ask patches [
    if count skippers-here > 0 
    [set patch-sr ((count skippers-here with [sex = "male"]) / (count skippers-here))]
    ;[set patch-sr 0]
  ]
  
end

to breeding
  
  ask skippers-on suitable [
  if not partnered? [
    set partner one-of (other skippers-here) with [(sex != [sex] of myself) and ( not partnered? )]
    if partner != nobody [
      set partnered? true
      set health health - 5    ;; Extra energetic costs of reproduction
      hatch round (clutch / (count skippers-here with [sex = "female"])) [
        ;set trait [env] of patch-here
        set health init-health
        ifelse random-float 1 < 0.5
          [set sex "male" set color 44]
          [set sex "female" set color 47] 
      ]
      
      ask partner [
        set partnered? true
      ]
      
      ask patch-here [
        set occupied? true
      ]
    ]
  ]
  ]
  
  if count skippers > 0 [
  let current-single ((count skippers with [partnered? = false]) / (count skippers) )
  set running-single (running-single + current-single) ]
  
  let current-occ ( (count patches with [occupied? = true]) / (count suitable) )
  set running-occ (running-occ + current-occ)
  ask patches [set occupied? false]
end

to disturbance
  if ticks mod dist-freq = 0 [
    ask n-of dist-extent patches [
      ;ifelse random-float 1 < 0.5
      ;[set env (env + random-poisson 3)]
      ;[set env (env - random-poisson 3)]
      set env random-normal env 1.5
    ]
  ]
  ask patches [ set pcolor scale-color 53 env -10 30 ]
 
 set suitable patch-set (patches with [(env < 7) and (env > 3)])
 set unsuitable patch-set (patches with [(env > 7) or (env < 3)])
 
end
@#$#@#$#@
GRAPHICS-WINDOW
227
37
567
398
-1
-1
30.0
1
10
1
1
1
0
1
1
1
0
10
0
10
0
0
1
ticks
30.0

BUTTON
30
36
96
69
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
122
37
185
70
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
31
301
203
334
dist-freq
dist-freq
0
25
5
5
1
NIL
HORIZONTAL

SLIDER
31
342
203
375
dist-extent
dist-extent
0
100
40
10
1
NIL
HORIZONTAL

SLIDER
31
404
203
437
male-disp
male-disp
0.01
2
2.1
0.01
1
NIL
HORIZONTAL

SLIDER
31
442
203
475
fem-disp
fem-disp
0.01
2
2.1
0.01
1
NIL
HORIZONTAL

TEXTBOX
53
278
203
296
Parameters of interest
11
0.0
1

SLIDER
27
145
200
178
selection-tolerance
selection-tolerance
0
5
2
1
1
NIL
HORIZONTAL

SLIDER
28
188
200
221
clutch
clutch
0
30
6
1
1
NIL
HORIZONTAL

SLIDER
29
104
201
137
init-health
init-health
0
100
40
5
1
NIL
HORIZONTAL

TEXTBOX
52
79
202
97
To get model working
11
0.0
1

PLOT
586
41
788
206
Population Size
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count skippers"

SLIDER
27
229
199
262
carrying-cap
carrying-cap
0
10
5
1
1
NIL
HORIZONTAL

MONITOR
240
419
307
464
sex ratio
(count skippers with [sex = \"male\"]) / (count skippers)
2
1
11

PLOT
586
215
786
365
sex ratio
NIL
NIL
0.0
10.0
0.0
1.1
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot (count skippers with [sex = \"male\"]) / (count skippers)"
"pen-1" 1.0 0 -2674135 true "" "plot 0.5"
"pen-2" 1.0 0 -7500403 true "" "if any? skippers-on suitable [\nplot (count (skippers-on suitable) with [sex = \"male\"]) / (count skippers-on suitable)\n]"
"pen-3" 1.0 0 -955883 true "" "if any? skippers-on unsuitable [\nplot (count (skippers-on unsuitable) with [sex = \"male\"]) / (count skippers-on unsuitable)\n]"

MONITOR
330
419
443
464
suitable patches
count suitable
0
1
11

PLOT
587
379
787
529
patch-dom
NIL
NIL
0.0
1.1
0.0
20.0
false
false
"set-plot-pen-mode 1\nset-histogram-num-bars 10" ""
PENS
"default" 0.1 1 -16777216 true "" "histogram [patch-sr] of patches"

MONITOR
241
472
314
517
suitable-sr
(count (skippers-on suitable) with [sex = \"male\"]) / (count skippers-on suitable)
2
1
11

MONITOR
330
473
427
518
unsuitable-sr
(count (skippers-on unsuitable) with [sex = \"male\"]) / (count skippers-on unsuitable)
2
1
11

@#$#@#$#@
# Sex-biased dispersal and population persistence in changing landscapes


### Purpose

Most ecological theory assumes that all individuals are identical, or that their differences average out. However, this assumption is clearly violated in many or even most ecological systems, and the consequences of considering these differences remain largely unexplored. One particularly common form of variation between individuals are sex differences, and one ecologically important example of this could be sex-biased dispersal, in which males and females differ in their dispersal behavior. While sex-biased dispersal is extremely common in nature, and the theory behind its repeated evolution is relatively well-understood, the ecological consequences of this process have not been well-studied.

This model was designed to explore the ecological consequences of sex-biased dispersal, particularly in changing environments. How do these sex differences affect the persistence of populations over time? If environments change, how do these sex differences affect the ability of population to recover?

###Entities, state variables, and scales

There will be two kinds of entities in this model: butterflies, and patches of land which form a heterogeneous, discrete environment. Each patch of land has an environmental value assigned to it, which I will arbitrary call ‘rainfall’. Each butterfly is either a male or female, possesses a ‘health’ value, and also a trait value which I will arbitrary call ‘nectar-need’. Each butterfly also has a location, which is the patch they are currently on.

Patch size and the length of one time step are not specified. Simulations will run until the population dynamics have stabilized. Trial runs may later be used to set a fixed simulation length.

###Process overview and scheduling

At each time step, butterflies will disperse to a different patch, at a distance according to their sex (whether it is males or females that disperse further will be the subject of sub-models). Once the dispersal phase has completed, natural selection will occur, in that the nectar-need of each butterfly will be compared with the rainfall of the patch they are in. If this difference lies outside of an acceptable limit, the butterfly will lose health, otherwise health will remain stable.

If individuals of both sexes are present in a patch, then randomly-mated pairs will produce 10 offspring, who will each be randomly assigned a sex, and whose nectar-need will be drawn randomly from within a range set by its parents' trait values. Rare mutations may occur to produce individuals with extreme trait values, in order to prevent the population from converging upon a mean trait value.

The above process of dispersal, selection, and reproduction repeats in each timestep.

A small number of randomly-chosen patches will change in rainfall at the beginning of each timestep. The magnitude of this change, and the exact number of patches that will change at each step, will be varied. This strongly affects the selection process described above, and therefore the persistence of the whole population in the landscape.

###Design concepts

The *basic principle* behind this model is that sex-biased dispersal affects the opportunities for reproduction in different patches in a landscape. It also affects the mixing of traits within and across these patches. Both of these are hypothesized to differ from systems in which dispersal is equal across all individuals, regardless of sex. These effects may be particularly evident when environments change, as previous strongholds for the population may be disrupted, with most survivors being of the more dispersive sex.

But how would these sub-models differ? *Emergently*, these processes would affect populations' ability to bounce back from environmental change, and their long-term stability and resilience.

Though passive natural selection occurs on the traits of individuals, this does not influence the behavior of the individuals. There is no active *adaptation, learning, or sensing* involved in the model. Natural selection should produce similar results to those processes, but with simpler mechanics.

The only *interaction* between individuals is reproduction, which produces new individuals with intermediate traits. There is no competition for resources in this model.

*Stochasticity* plays a large role in the model. It determines the initial traits and locations of individuals, and the makeup of the entire landscape. Once the simulation is running, environmental change is forced on a random selection of patches. The traits of butterfly offspring are randomly determined, though within the bounds of their parents' traits. Rare mutational events may be required, in order to maintain high genetic variation.

Finally, the required *observations* for producing the model's results will come from plotting population size over time. The average population persistence time will be tracked.

###Initialization

###Input Data

###Submodels
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

butterfly 2
true
0
Polygon -16777216 true false 151 76 138 91 138 284 150 296 162 286 162 91
Polygon -7500403 true true 164 106 184 79 205 61 236 48 259 53 279 86 287 119 289 158 278 177 256 182 164 181
Polygon -7500403 true true 136 110 119 82 110 71 85 61 59 48 36 56 17 88 6 115 2 147 15 178 134 178
Polygon -7500403 true true 46 181 28 227 50 255 77 273 112 283 135 274 135 180
Polygon -7500403 true true 165 185 254 184 272 224 255 251 236 267 191 283 164 276
Line -7500403 true 167 47 159 82
Line -7500403 true 136 47 145 81
Circle -7500403 true true 165 45 8
Circle -7500403 true true 134 45 6
Circle -7500403 true true 133 44 7
Circle -7500403 true true 133 43 8

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

dragonfly
true
0
Polygon -13791810 true false 150 60 135 75 138 284 150 296 162 286 165 75
Polygon -7500403 true true 136 95 120 90 105 90 90 90 75 90 30 90 15 105 15 120 45 120 75 120 135 120
Polygon -7500403 true true 30 135 15 165 60 180 90 180 120 180 135 165 135 135
Polygon -7500403 true true 164 95 180 90 195 90 210 90 225 90 270 90 285 105 285 120 255 120 225 120 165 120
Rectangle -7500403 true true 120 60 180 75
Polygon -7500403 true true 270 135 285 165 240 180 210 180 180 180 165 165 165 135

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="disturbance" repetitions="50" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>ticks</metric>
    <metric>count skippers</metric>
    <metric>count skippers with [sex = "male"]</metric>
    <metric>count skippers with [sex = "female"]</metric>
    <steppedValueSet variable="dist-extent" first="0" step="20" last="80"/>
    <steppedValueSet variable="dist-freq" first="5" step="5" last="20"/>
  </experiment>
  <experiment name="dispersal" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>ticks</metric>
    <steppedValueSet variable="male-disp" first="0.2" step="0.4" last="3"/>
    <steppedValueSet variable="fem-disp" first="0.01" step="0.05" last="0.36"/>
  </experiment>
  <experiment name="grandexperiment" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>ticks</metric>
    <metric>count skippers</metric>
    <metric>count skippers with [sex = "male"]</metric>
    <metric>count skippers with [sex = "female"]</metric>
    <steppedValueSet variable="male-disp" first="0.5" step="2" last="8.5"/>
    <steppedValueSet variable="fem-disp" first="0.05" step="0.05" last="0.3"/>
    <steppedValueSet variable="dist-extent" first="10" step="20" last="90"/>
    <steppedValueSet variable="dist-freq" first="5" step="10" last="25"/>
  </experiment>
  <experiment name="dispersalratios" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>(running-sr-total / ticks)</metric>
    <metric>(running-suit / ticks)</metric>
    <metric>(running-unsuit / ticks)</metric>
    <metric>(running-single / ticks)</metric>
    <metric>(running-occ / ticks)</metric>
    <enumeratedValueSet variable="male-disp">
      <value value="0.1"/>
      <value value="0.6"/>
      <value value="1.1"/>
      <value value="1.6"/>
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fem-disp">
      <value value="0.1"/>
      <value value="0.3"/>
      <value value="0.5"/>
      <value value="0.7"/>
      <value value="0.9"/>
      <value value="1.1"/>
      <value value="1.3"/>
      <value value="1.5"/>
      <value value="1.7"/>
      <value value="1.9"/>
      <value value="2.1"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
