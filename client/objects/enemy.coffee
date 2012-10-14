
baseObject  = require("./baseObject")
explosion   = require("./explosion")

g           = require("../globals")
point       = require("../point")
game        = require("../game")

canvas = $("#canvas")

class enemy extends baseObject
    speed: 0.05
    initialize: ->
        @speed = 0.05 + g.difficulty/100
    isEnemy: true
    setOrigin: (origin) ->
        @origin = origin
        @setPos(origin)
    setTarget: (target) ->
        @target = target
    think: () ->
        if @target?
            pos = @getPos() .add (@target .sub @getPos()).norm().mul(g.delta*@speed)
            @setPos( pos )
            if g.delta*@speed > @getPos() .distance @target
                z = new explosion
                z.setPos(@getPos())
                @remove()
                g.lives--
                if g.lives < 1
                    g.lastScore = g.score
                    game.initialize()
    render: () ->
        canvas.drawLine
            strokeStyle: "silver"
            strokeWidth: 1
            x1: @x, y1: @y
            x2: @origin.x, y2: @origin.y
        super

module.exports = enemy

