
baseObject  = require("./baseObject")

input       = require("../input")
g           = require("../globals")
game        = require("../game")
point       = require("../point")

canvas = $("#canvas")

KEY_W = 87
KEY_S = 83
KEY_A = 65
KEY_D = 68

class player extends baseObject
    className: "player"
    tileSize: 10
    velY: 0
    initialize: ->
    trace: ->
    think: ->
    render: (delta) ->
        
        goalX = @x
        goalY = @y
        
        if input.isKeyDown( KEY_W )
            goalY -= delta / 10
            res = game.map.trace( point( @x + 5, @y + 10 ), point( @x + 5, @y + 13 ) )
            if res?
                @velY = 3
        if input.isKeyDown( KEY_S )
            goalY += delta / 10
        if input.isKeyDown( KEY_A )
            goalX -= delta / 10
        if input.isKeyDown( KEY_D )
            goalX += delta / 10

        # trace gravity
        gravity = 0
        @velY -= delta / 80
        goal = @y + gravity - @velY/20 * delta
        normal = point( 0, goal - @y ).norm()

        res = game.map.trace( point( @x + 5, @y + 5 + normal.y * 5 ), point( @x + 5, goal + 5 + normal.y * 5 ) )

        if res?
            @y = res.y - normal.y * 0.01 - 5 - normal.y * 5
            @velY = 0
        else
            @y = goal

        # trace x
        normal = point( goalX - @x, 0 ).norm()
        res = game.map.trace( point( @x + 5 + normal.x * 5, @y + 5 ), point( goalX + 5 + normal.x * 5, @y + 5 ) )

        if res?
            @x = res.x - normal.x * 0.01 - 5 - normal.x * 5
        else
            @x = goalX

        canvas
            .drawRect
                fillStyle: "#0F0"
                x: Math.round(@x)
                y: Math.round(@y)
                width: @tileSize
                height: @tileSize
                fromCenter: false

module.exports = player

