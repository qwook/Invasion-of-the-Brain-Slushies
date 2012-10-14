
baseObject  = require("../baseObject")
explosion   = require("../explosion")
g           = require("../globals")
point       = require("../point")
input       = require("../input")

canvas = $("#canvas")

class button extends baseObject
    hovered: false
    width: 100
    height: 100
    lastMouseDown: false
    clicking: false
    text: 'Nothing'
    initialize: ->
    setText: (text) ->
        @text = text
    think: () ->
        @hovered = !( input.mouseX < @x || input.mouseY < @y || input.mouseX > @x + @width || input.mouseY > @y + @height )

        if @hovered
            canvas.css('cursor', 'pointer')
        else
            canvas.css('cursor', 'auto')

        if @hovered && input.mouseDown && !@lastMouseDown
            @clicking = true

        if !input.mouseDown
            if @clicking && @hovered
                @onclick()
            @clicking = false

        @lastMouseDown = input.mouseDown
    onclick: () ->
        canvas.css( 'cursor', 'auto' )

        # suck the mouse click
        # disable anything else from grabbing the click.
        input.mouseDown = false
    render: () ->
        fill = "#555555"

        if @hovered
            fill = "#888888"
            if input.mouseDown
                fill = "#333333"

        canvas
            .drawRect
                fillStyle: fill
                x: @x
                y: @y
                width: @width
                height: @height
                fromCenter: false
            .drawText
                fillStyle: "#FFF"
                x: @x + @width/2
                y: @y + @height/2
                font: "14px sans-serif"
                text: @text
                fromCenter: true

module.exports = button

