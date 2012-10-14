
input       = require("../input")
g           = require("../globals")
baseObject  = require("./baseObject")

canvas = $("#canvas")

KEY_W = 87
KEY_S = 83
KEY_A = 65
KEY_D = 68

class player extends baseObject
    className: "player"
    tileSize: 10
    initialize: ->
    trace: ->
    think: ->
    render: (delta) ->
        if input.isKeyDown( KEY_W )
            @y -= delta / 10
        if input.isKeyDown( KEY_S )
            @y += delta / 10
        if input.isKeyDown( KEY_A )
            @x -= delta / 10
        if input.isKeyDown( KEY_D )
            @x += delta / 10
        canvas
            .drawRect
                fillStyle: "#0F0"
                x: Math.round(@x)
                y: Math.round(@y)
                width: @tileSize
                height: @tileSize
                fromCenter: false

module.exports = player

