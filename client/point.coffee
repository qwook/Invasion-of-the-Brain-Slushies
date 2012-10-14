
# 2D vector class.

class Point
    constructor: (@x, @y) ->
    add: (b) ->
        new Point(@x + b.x, @y + b.y)
    sub: (b) ->
        new Point(@x - b.x, @y - b.y)
    mul: (b) ->
        if typeof b == "number"
            new Point(@x * b, @y * b)
        else
            new Point(@x * b.x, @y * b.y)
    div: (b) ->
        if typeof b == "number"
            new Point(@x / b, @y / b)
        else
            new Point(@x / b.x, @y / b.y)
    distance: (b) ->
        Math.sqrt(Math.pow(b.x - @x,2) + Math.pow(b.y - @y,2))
    norm: ->
        @div(@distance(origin))

point = (x, y) ->
    new Point(x, y)

origin = point(0,0)

module.exports = point

