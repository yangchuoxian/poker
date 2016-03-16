Promise = require 'bluebird'
module.exports =
    generateLoginToken: ->
        s4 = -> Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
        s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

    shuffleCards: ->
        array = []
        for j in [0...2]
            for i in [1...47]
                array.push i
        copy = []
        n = array.length
        numOfIterations = n
        for i in [0...numOfIterations]
            j = Math.floor(Math.random() * n)
            copy.push array[j]
            array.splice j, 1
            n -= 1
        return copy
