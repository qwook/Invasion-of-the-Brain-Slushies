
game        = require("./game")
point       = require("./point")
g           = require("./globals")
input       = require("./input")

baseObject  = require("./objects/baseObject")
enemy       = require("./objects/enemy")
explosion   = require("./objects/explosion")
missile     = require("./objects/missile")
button      = require("./objects/button")

require("./math")

# create function for the request animation frame
# also check for all the different function names for different browsers.
# if this function does not exist, just use the timeout function.
window.requestAnimFrame = (() ->
    window.requestAnimationFrame       ||
        window.webkitRequestAnimationFrame ||
        window.mozRequestAnimationFrame    ||
        window.oRequestAnimationFrame      ||
        window.msRequestAnimationFrame     ||
        ( callback ) ->
            window.setTimeout(callback, 1000 / 60)
    )()

# set up FPS counter variables
a = 10
MAXSAMPLES = 100
samples = 0
tickindex = 0
ticksum = 0
ticklist = []

# FPS counter function.
calcAvgTick = (newtick) ->
    ticklist[tickindex] = ticklist[tickindex] || 0
    ticksum -= ticklist[tickindex]
    ticksum += newtick
    ticklist[tickindex] = newtick
    tickindex++
    if tickindex == MAXSAMPLES
        tickindex = 0

    if samples < MAXSAMPLES
        samples++
        return 0

    ticksum / MAXSAMPLES

canvas = $("#canvas")

lasttime = g.time
lastRenderTime = null

STAGE_LOBBY = 0
STAGE_PLAYING = 1

stage = STAGE_LOBBY

click = ->
    game.click()

think = ->
    # generate delta time and new time
    g.time = (new Date()).getTime()
    g.delta = g.time - lasttime
    lasttime = g.time

    object?.think() for object in g.objectlist

    object._remove() for object in g.toremove

    g.toremove.length = 0 # this clears the array.

    if input.mouseDown && !input.lastMouseDown
        game.click()

    game.think()
    input.think()

render = (time)->
    delta = 0

    # generate delta time
    if lastRenderTime
        delta = time - lastRenderTime
        
    game.render(delta)

    # request another frame.
    requestAnimFrame render
    lastRenderTime = time

# initialize and set up hooks
setInterval( think, 0 )
render(0)
input.setThink( think )
game.initialize()
canvas.css('cursor','none')
