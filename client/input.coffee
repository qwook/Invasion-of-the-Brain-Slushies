
game    = require("./game")
canvas  = $("#canvas")

KEY_W = 87
KEY_S = 83
KEY_A = 65
KEY_D = 68

class CInput
    mouseX: 0
    mouseY: 0
    mouseDown: false
    lastMouseDown: false
    keysDown: []
    thinkFunction: ->
    setThink: ( thinkFunction )->
        @thinkFunction = thinkFunction
    think: ->
        @lastMouseDown = @mouseDown
    keyDown: (key) ->
        @keysDown[key] = true
        #console.log(key)
    keyUp: (key) ->
        @keysDown[key] = false
    isKeyDown: (key) ->
        return @keysDown[key]

input = new CInput

canvas
    .mousemove (e) ->
        input.mouseX = e.offsetX
        input.mouseY = e.offsetY
        input.thinkFunction()
    .mousedown (e) ->
        input.mouseX = e.offsetX
        input.mouseDown = true
        input.thinkFunction()
    .mouseup (e) ->
        input.mouseY = e.offsetY
        input.mouseDown = false
        input.thinkFunction()

window.addEventListener('keyup', (event) ->
    input.keyUp( if event.which? then event.which else event.keyCode )
    input.thinkFunction()
, false)

window.addEventListener('keydown', (event) ->
    input.keyDown( if event.which? then event.which else event.keyCode )
    input.thinkFunction()
, false)

module.exports = input

