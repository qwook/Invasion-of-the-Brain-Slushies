
baseObject  = require("../baseObject")
g           = require("../globals")
point       = require("../point")

canvas = $("#canvas")

class explosion extends baseObject
    radius: 250
    initialize: () ->
    think: () ->
        for e in g.objectlist
            if e.isEnemy?
                if e.getPos().distance(@getPos()) <= (g.time - @timestamp) / 10
                    z = new explosion
                    z.setPos(e.getPos())
                    e.remove()
                    g.score++
        if ( g.time - @timestamp ) > @radius
            @remove()
    render: () ->
        a = Math.round(255*(g.time - @timestamp)/@radius)
        canvas.drawArc
            strokeStyle: "rgb(255 , #{a}, #{a})"
            strokeWidth: 2
            x: @x
            y: @y
            radius: (g.time - @timestamp) / 10

module.exports = explosion

