
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

        x1 = 100
        y1 = 100
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

        count = 0
        while (x != ox || y != oy) && count < 50

            count++

            if loadedMap[y]? && loadedMap[y][x] == 1
                # y = mx + b
                # find the intersection between ray and tile
                
                initPoint = point( x1, y1 )

                iPoint = point( 0, 0 )

                mA = vy/vx
                mB = vx/vy

                bA = y1 - (mA * x1)
                bB = y2 - (mA * x2)

                leftSide = x * g.tileSize
                rightSide = leftSide + g.tileSize
                upSide = y * g.tileSize
                downSide = upSide + g.tileSize

                upSideTest = (upSide - bA) * mB
                if upSideTest >= leftSide and upSideTest <= rightSide
                    iPoint = point( upSideTest, upSide )
                    canvas.drawArc
                        fillStyle: "black"
                        x: upSideTest
                        y: upSide
                        radius: 4
                leftSideTest = mA * leftSide + bA
                if leftSideTest >= upSide and leftSideTest <= downSide
                    newPoint = point(leftSide, leftSideTest)
                    canvas.drawArc
                        fillStyle: "black"
                        x: leftSide
                        y: leftSideTest
                        radius: 4
                    if iPoint.distance(initPoint) > newPoint.distance( initPoint )
                        iPoint = newPoint
                rightSideTest = mA * rightSide + bA
                if rightSideTest >= upSide and rightSideTest <= downSide
                    newPoint = point( rightSide, rightSideTest )
                    canvas.drawArc
                        fillStyle: "black"
                        x: rightSide
                        y: rightSideTest
                        radius: 4
                    if iPoint.distance(initPoint) > newPoint.distance( initPoint )
                        iPoint = newPoint
                downSideTest = (downSide - bA) * mB
                if downSideTest >= leftSide and downSideTest <= rightSide
                    newPoint = point( downSideTest, downSide )
                    if iPoint.distance(initPoint) > newPoint.distance( initPoint )
                        iPoint = newPoint

                canvas
                    .drawLine
                        strokeStyle: "#000"
                        strokeWidth: 1
                        x1: x1
                        y1: y1
                        x2: iPoint.x
                        y2: iPoint.y
                return

            if maxX < maxY
                maxX = maxX + deltaX
                x += stepX
            else
                maxY = maxY + deltaY
                y += stepY

            canvas
                .drawRect
                    fillStyle: "#F00"
                    x: @x + x * g.tileSize
                    y: @y + y * g.tileSize
                    width: g.tileSize
                    height: g.tileSize
                    fromCenter: false
        canvas
            .drawLine
                strokeStyle: "#000"
                strokeWidth: 1
                x1: x1
                y1: y1
                x2: input.mouseX
                y2: input.mouseY

module.exports = map

