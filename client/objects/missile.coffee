
baseObject  = require("../baseObject")
explosion   = require("../explosion")
g           = require("../globals")
point       = require("../point")
game        = require("../game")

canvas = $("#canvas")

class missile extends baseObject
    speed: 0.15
    initialize: ->
        @speed = 0.15 + g.difficulty/75
    setTarget: (target) ->
        @target = target
    think: () ->
        pos = @getPos() .add (@target .sub @getPos()).norm().mul(g.delta*@speed)
        @setPos( pos )
        if g.delta*@speed > @getPos() .distance @target
            z = new explosion
            z.radius = 500
            z.setPos(@getPos())
            game.missileFired = false
            @remove()

module.exports = missile

