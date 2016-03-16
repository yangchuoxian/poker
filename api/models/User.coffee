###
User.coffee

@description :: TODO: You might write a short summary of how this model works and what it represents here.
@docs        :: http://sailsjs.org/#!documentation/models
###

module.exports =
    autoCreatedAt: true
    autoUpdatedAt: true
    schema: true
    tableName: 'user'
    attributes:
        username:
            type: 'string'
            unique: true
            required: true
            maxLength: 80
        password:
            type: 'string'
            required: true
            minLength: 6
        loginToken:
            type: 'string'
        email:
            type: 'string'
            unique: true
            maxLength: 100
        phone:
            type: 'string'
            minLength: 11
            maxLength: 11
        socketId:
            type: 'string'
        roomName:
            type: 'string'

