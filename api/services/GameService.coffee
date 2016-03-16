Promise = require 'bluebird'
module.exports =
    sendCards: (room, usernameToCallScore) ->
        shuffledCards = Toolbox.shuffleCards()
        deck1 = shuffledCards.slice 0, sails.config.constants.numOfCardsForEachPlayer
        deck2 = shuffledCards.slice sails.config.constants.numOfCardsForEachPlayer, sails.config.constants.numOfCardsForEachPlayer * 2
        deck3 = shuffledCards.slice sails.config.constants.numOfCardsForEachPlayer * 2, sails.config.constants.numOfCardsForEachPlayer * 3
        deck4 = shuffledCards.slice sails.config.constants.numOfCardsForEachPlayer * 3, sails.config.constants.numOfCardsForEachPlayer * 4
        coveredCards = shuffledCards.slice sails.config.constants.numOfCardsForEachPlayer * 4, sails.config.constants.numOfCardsForEachPlayer * 4 + sails.config.constants.numOfCoveredCards
        Room.update id: room.id,
            deck1: deck1
            deck2: deck2
            deck3: deck3
            deck4: deck4
            coveredCards: coveredCards
        .then (updatedRooms) ->
            sails.sockets.broadcast room.socketIds[0], 'cardsSent', {cards: deck1, usernameToCallScore: usernameToCallScore}
            sails.sockets.broadcast room.socketIds[1], 'cardsSent', {cards: deck2, usernameToCallScore: usernameToCallScore}
            sails.sockets.broadcast room.socketIds[2], 'cardsSent', {cards: deck3, usernameToCallScore: usernameToCallScore}
            sails.sockets.broadcast room.socketIds[3], 'cardsSent', {cards: deck4, usernameToCallScore: usernameToCallScore}
            Promise.resolve()
        .catch (err) -> Promise.reject err