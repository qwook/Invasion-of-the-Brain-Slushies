
require( "./point" )

# extend the Math library.

Math.rand = (a, b) ->
    c = a
    if ( b > a )
        c = b
        b = a

    b + Math.round(Math.random() * ( c - b ))

Math.randD = (a, b) ->
    c = a
    if ( b > a )
        c = b
        b = a

    b + Math.random() * ( c - b )

Math.rayToRayIntersection = ( p1, p2, p3, p4 ) ->
    # make sure the lines aren't parallel
    if ((p2.y - p1.y) / (p2.x - p1.y) != (p4.y - p3.y) / (p4.x - p3.x))
        d = (((p2.x - p1.x) * (p4.y - p3.y)) - (p2.y - p1.y) * (p4.x - p3.x))
        if (d != 0)
            r = (((p1.y - p3.y) * (p4.x - p3.x)) - (p1.x - p3.x) * (p4.y - p3.y)) / d
            s = (((p1.y - p3.y) * (p2.x - p1.x)) - (p1.x - p3.x) * (p2.y - p1.y)) / d
            if (r >= 0)
                if (s >= 0)
                    return point( p1.x + r * (p2.x - p1.x), p1.y + r * (p2.y - p1.y) )

