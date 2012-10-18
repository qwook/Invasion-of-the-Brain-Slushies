
input       = require("../input")
baseObject  = require("./baseObject")
g           = require("../globals")
game        = require("../game")
point       = require("../point")

canvas = $("#canvas")

loadedMap =
    [
        [ 0, 0, 0, 0, 0, 0, 0, 1 ]
        [ 0, 0, 0, 0, 0, 0, 0, 0 ]
        [ 0, 0, 0, 0, 0, 0, 0, 0 ]
        [ 0, 0, 0, 0, 0, 0, 0, 0 ]
        [ 0, 0, 1, 0, 0, 1, 0, 0 ]
        [ 0, 0, 0, 0, 0, 0, 0, 0 ]
        [ 1, 0, 0, 0, 0, 0, 0, 1 ]
        [ 0, 1, 0, 0, 0, 0, 1, 0 ]
        [ 0, 0, 1, 1, 1, 1, 0, 0 ]
        [ 0, 0, 0, 0, 0, 0, 0, 0 ]
        [ 0, 0, 0, 0, 0, 0, 0, 0 ]
        [ 0, 0, 0, 0, 0, 0, 0, 0 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1 ]
        [ 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1 ]
    ]

class map extends baseObject
    className: "map"
    initialize: ->
    trace: ( pA, pB )->

        x1 = pA.x
        y1 = pA.y
        x2 = pB.x
        y2 = pB.y

        vx = x2 - x1
        vy = y2 - y1

        x = Math.floor(x1 / g.tileSize)
        y = Math.floor(y1 / g.tileSize)

        ox = Math.floor(x2 / g.tileSize)
        oy = Math.floor(y2 / g.tileSize)
        
        stepX = if vx > 0 then 1 else (if vx == 0 then 0 else -1)
        stepY = if vy > 0 then 1 else (if vy == 0 then 0 else -1)

        deltaX = 0
        deltaY = 0

        maxX = 1
        maxY = 1

        if vx != 0
            maxX = ((x + (vx > 0 && 1 || 0)) * g.tileSize - x1) / vx
            deltaX = Math.abs(g.tileSize / vx)
        if vy != 0
            maxY = ((y + (vy > 0 && 1 || 0)) * g.tileSize - y1) / vy
            deltaY = Math.abs(g.tileSize / vy)

        count = 0
        while ((x != ox || y != oy) && count < 50 || count == 0)

            if count != 0
                if maxX < maxY
                    maxX = maxX + deltaX
                    x += stepX
                else
                    maxY = maxY + deltaY
                    y += stepY

            if loadedMap[y]? && loadedMap[y][x] == 1

                initPoint = point( x1, y1 )
                endPoint = point( x2, y2 )

                mA = vy/vx
                mB = vx/vy

                bA = y1 - (mA * x1)
                bB = y2 - (mA * x2)

                leftSide = x * g.tileSize
                rightSide = leftSide + g.tileSize
                upSide = y * g.tileSize
                downSide = upSide + g.tileSize

                topLeft = point( leftSide, upSide )
                bottomLeft = point( leftSide, downSide )
                topRight = point( rightSide, upSide )
                bottomRight = point( rightSide, downSide )

                if ( x1 <= x2 )
                    tempPoint = Math.lineToRayIntersection( initPoint, endPoint, topLeft, bottomLeft )
                    if tempPoint?
                        iPoint = tempPoint
                else
                    tempPoint = Math.lineToRayIntersection( initPoint, endPoint, topRight, bottomRight )
                    if tempPoint? && (!iPoint? || tempPoint.distance( initPoint ) < iPoint.distance( initPoint ))
                        iPoint = tempPoint
                if ( y1 <= y2 )
                    tempPoint = Math.lineToRayIntersection( initPoint, endPoint, topLeft, topRight )
                    if tempPoint? && (!iPoint? || tempPoint.distance( initPoint ) < iPoint.distance( initPoint ))
                        iPoint = tempPoint
                else
                    tempPoint = Math.lineToRayIntersection( initPoint, endPoint, bottomLeft, bottomRight )
                    if tempPoint? && (!iPoint? || tempPoint.distance( initPoint ) < iPoint.distance( initPoint ))
                        iPoint = tempPoint

                if iPoint?
                    return iPoint

            count++

        

    render: () ->
        for v, y in loadedMap
            for tile, x in v
                if tile == 1
                    canvas
                        .drawRect
                            fillStyle: "#000"
                            x: @x + x * g.tileSize
                            y: @y + y * g.tileSize
                            width: g.tileSize
                            height: g.tileSize
                            fromCenter: false

        canvas.drawArc
            fillStyle: "#FF0"
            x: input.mouseX
            y: input.mouseY
            radius: 4

        ###iPoint = @trace( point( game.player.x, game.player.y ), point( input.mouseX, input.mouseY ) )

        if iPoint?
            console.log(iPoint.y)
            canvas.drawArc
                fillStyle: "#0F0"
                x: iPoint.x
                y: iPoint.y
                radius: 4###

module.exports = map

