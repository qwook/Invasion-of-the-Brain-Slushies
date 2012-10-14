
point       = require("./point")
g           = require("./globals")
input       = require("./input")

canvas      = $("#canvas")

require("./math")

STAGE_LOBBY     = 0
STAGE_PLAYING   = 1

# initiate CGame class.
# this class will be used for each gamemode
class CGame
    startButton: null
    stage: STAGE_LOBBY
    missileFired: false
    player: null
    # on click
    click: ->
        if @stage == STAGE_PLAYING
            if ( !@missileFired )
                z = new missile()
                z.setTarget( point( input.mouseX, input.mouseY ) )
                z.setPos( point( 200, 350 ) )
                @missileFired = true
    # on think
    think: ->
    # on drawing
    render: (delta) ->
        canvas.clearCanvas()

        object.render(delta) for object in g.objectlist

        if @stage == STAGE_PLAYING
            canvas
                .drawText
                    fillStyle: "#000"
                    x: 200
                    y: 10
                    font: "12px Arial, sans-serif"
                    text: "Lives: " + g.lives
                .drawText
                    fillStyle: "#000"
                    x: 100
                    y: 10
                    font: "12px Arial, sans-serif"
                    text: "Score: " + g.score
                .drawRect
                    fillStyle: "#000"
                    x: 0, y: 350
                    width: 400
                    height: 50
                    fromCenter: false

            g.difficulty += g.delta/10000
            @spawnthink()

    nextspawn: 0
    spawnthink: ->
        if ( g.time > @nextspawn )
            @nextspawn = g.time + 2000 - ((g.difficulty > 7.5) ? 1500 : (g.difficulty * 200))
            e = new enemy()
            e.setTarget( point( Math.rand(0, 400), 350 ) )
            e.setOrigin( point( Math.rand(0, 400), -10 ) )

    # on initialize
    initialize: ->

        # reset all variables
        nextspawn = 0
        g.objectlist.length = 0
        g.toremove.length = 0

        g.difficulty = 0
        g.score = 0
        g.lives = 3

        @missileFired = false
        @stage = STAGE_LOBBY

        new map()

        # create our player and hold it somewhere.
        @player = new CPlayer()


# create an instance of the CGame class and export it.

game = new CGame
module.exports = game

# we require the objects at the bottom, because we need to export our game class first.

map     = require("./objects/map")

baseObject  = require("./objects/baseObject")
enemy       = require("./objects/enemy")
explosion   = require("./objects/explosion")
missile     = require("./objects/missile")
CPlayer     = require("./objects/player")

button      = require("./objects/button")
text        = require("./objects/text")

