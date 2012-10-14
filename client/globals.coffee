
# just global variables
# most of these should be owned by the CGame class
# todo: move variables to CGame or deprecate.

module.exports =
    tileSize: 10

    objectlist: []
    toremove: []

    difficulty: 0

    time: (new Date()).getTime()
    delta: 0

    score: 0
    lastScore: null

    missileFired: false

