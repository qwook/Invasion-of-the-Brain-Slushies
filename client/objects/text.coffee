
baseObject  = require("../baseObject")

canvas = $("#canvas")

class text extends baseObject
    lastMouseDown: false
    clicking: false
    text: 'Nothing'
    initialize: ->
    setText: (text) ->
        @text = text
    render: () ->
        canvas
            .drawText
                    fillStyle: "#000"
                    x: @x
                    y: @y
                    font: "12px Arial, sans-serif"
                    text: @text
                    fromCenter: false

module.exports = text

