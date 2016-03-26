###
Room.coffee

@description :: TODO: You might write a short summary of how this model works and what it represents here.
@docs        :: http://sailsjs.org/#!documentation/models
###

module.exports =
    autoCreatedAt: true
    autoUpdatedAt: true
    schema: true
    tableName: 'room'
    attributes:
        name:
            type: 'string'
            unique: true
            required: true
            maxLength: 20
        password:
            type: 'string'
            required: true
        socketIds:
            type: 'array'
            array: true
            defaultsTo: []
        usernames:
            type: 'array'
            array: true
            defaultsTo: []
        readyPlayers:
            type: 'array'
            array: true
            defaultsTo: []
        seats:
            type: 'json'
            defaultsTo:
                one: ''
                two: ''
                three: ''
                four: ''
        aimedScore:
            type: 'integer'
            defaultsTo: 80
        currentScore:
            type: 'integer'
            defaultsTo: 0
        passedUsernames:
            type: 'array'
            array: true
            defaultsTo: []
        lastCaller:
            type: 'string'
        maker:
            type: 'string'
        mainSuit:
            type: 'integer'
        decks:
            type: 'json'
        coveredCards:
            type: 'array'
            array: true
            defaultsTo: []
        playedCardValuesForCurrentRound:
            type: 'array'
            array: true
            defaultsTo: []
        cardValueRanks:
            type: 'json'
            defaultsTo: {}
        firstScoreCallerUsername:
            type: 'string'
        winning:
            type: 'json'
            defaultsTo: {}
        # 投降的水钱
        waterpool:
            type: 'integer'
            defaultsTo: 0