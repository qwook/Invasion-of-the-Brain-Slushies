
input       = require("../input")
baseObject  = require("./baseObject")
g           = require("../globals")
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


        x1 = 100
        y1 = 75
        x2 = input.mouseX
        y2 = input.mouseY

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

        canvas
            .drawLine
                strokeStyle: "#000"
                strokeWidth: 1
                x1: x1
                y1: y1
                x2: input.mouseX
                y2: input.mouseY

        count = 0
        while (x != ox || y != oy) && count < 50

            count++

            if maxX < maxY
                maxX = maxX + deltaX
                x += stepX
            else
                maxY = maxY + deltaY
                y += stepY

            canvas
                .drawRect
                    fillStyle: "rgba(255,0,0,0.5)"
                    x: @x + x * g.tileSize
                    y: @y + y * g.tileSize
                    width: g.tileSize
                    height: g.tileSize
                    fromCenter: false

            if loadedMap[y]? && loadedMap[y][x] == 1
                # y = mx + b
                # find the intersection between ray and tile
                
                initPoint = point( x1, y1 )
                endPoint = point( x2, y2 )

                #iPoint = point( 0, 0 )

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

                tempPoint = Math.rayToRayIntersection( initPoint, endPoint, topLeft, bottomLeft )
                if tempPoint?
                    iPoint = tempPoint
                tempPoint = Math.rayToRayIntersection( initPoint, endPoint, topRight, bottomRight )
                if tempPoint? && (!iPoint? || tempPoint.distance( initPoint ) < iPoint.distance( initPoint ))
                    iPoint = tempPoint
                tempPoint = Math.rayToRayIntersection( initPoint, endPoint, topLeft, topRight )
                if tempPoint? && (!iPoint? || tempPoint.distance( initPoint ) < iPoint.distance( initPoint ))
                    iPoint = tempPoint
                tempPoint = Math.rayToRayIntersection( initPoint, endPoint, bottomLeft, bottomRight )
                if tempPoint? && (!iPoint? || tempPoint.distance( initPoint ) < iPoint.distance( initPoint ))
                    iPoint = tempPoint

                canvas
                    .drawRect
                        fillStyle: "rgba(255,20,255,0.5)"
                        x: @x + x * g.tileSize
                        y: @y + y * g.tileSize
                        width: g.tileSize
                        height: g.tileSize
                        fromCenter: false


                if iPoint?
                    canvas.drawArc
                        fillStyle: "#0F0"
                        x: iPoint.x
                        y: iPoint.y
                        radius: 4

                    canvas
                        .drawLine
                            strokeStyle: "#000"
                            strokeWidth: 1
                            x1: x1
                            y1: y1
                            x2: iPoint.x
                            y2: iPoint.y
                    return

module.exports = map

