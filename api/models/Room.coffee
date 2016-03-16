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
        currentGameStatus:
            type: 'integer'
        aimedScore:
            type: 'integer'
            defaultsTo: 80
        currentScore:
            type: 'integer'
        passedUsernames:
            type: 'array'
            array: true
            defaultsTo: []
        lastCaller:
            type: 'string'
        deck1:
            type: 'array'
            array: true
            defaultsTo: []
        deck2:
            type: 'array'
            array: true
            defaultsTo: []
        deck3:
            type: 'array'
            array: true
            defaultsTo: []
        deck4:
            type: 'array'
            array: true
            defaultsTo: []
        coveredCards:
            type: 'array'
            array: true
            defaultsTo: []