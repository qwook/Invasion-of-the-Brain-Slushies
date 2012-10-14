
g       = require("../globals")
point   = require("../point")

canvas = $("#canvas")

class baseObject
    className: baseObject
    constructor: ->
        g.objectlist.push(@)
        @timestamp = g.time
        @initialize()
    initialize: ->
    think: () ->
    render: () ->
        canvas.drawArc
            fillStyle: "black"
            x: @x
            y: @y
            radius: 4
    remove: () ->
        if g.toremove.indexOf(this) < 0
            g.toremove.push(this)
    _remove: () ->
        g.objectlist.splice(g.objectlist.indexOf(this),1)
        delete this
    x: 0
    y: 0
    setPos: (point, b) ->
        if typeof point == "object"
            @x = point.x
            @y = point.y
        else
            @x = point
            @y = b
    getPos: ->
        point(@x, @y)

module.exports = baseObject

