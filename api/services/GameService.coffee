Promise = require 'bluebird'
module.exports =
    sendCards: (room, usernameToCallScore) ->
        shuffledCards = Toolbox.shuffleCards()
        deck1 = shuffledCards.slice 0, sails.config.constants.numOfCardsForEachPlayer
        deck2 = shuffledCards.slice sails.config.constants.numOfCardsForEachPlayer, sails.config.constants.numOfCardsForEachPlayer * 2
        deck3 = shuffledCards.slice sails.config.constants.numOfCardsForEachPlayer * 2, sails.config.constants.numOfCardsForEachPlayer * 3
        deck4 = shuffledCards.slice sails.config.constants.numOfCardsForEachPlayer * 3, sails.config.constants.numOfCardsForEachPlayer * 4

        deck1 = Toolbox.sortCards deck1
        deck2 = Toolbox.sortCards deck2
        deck3 = Toolbox.sortCards deck3
        deck4 = Toolbox.sortCards deck4
        coveredCards = shuffledCards.slice sails.config.constants.numOfCardsForEachPlayer * 4, sails.config.constants.numOfCardsForEachPlayer * 4 + sails.config.constants.numOfCoveredCards

        userInSeatOne = room.seats.one
        userInSeatTwo = room.seats.two
        userInSeatThree = room.seats.three
        userInSeatFour = room.seats.four

        decks = {}
        if userInSeatOne is usernameToCallScore
            decks[userInSeatOne] = deck1
            decks[userInSeatTwo] = deck2
            decks[userInSeatThree] = deck3
            decks[userInSeatFour] = deck4
        else if userInSeatTwo is usernameToCallScore
            decks[userInSeatTwo] = deck1
            decks[userInSeatThree] = deck2
            decks[userInSeatFour] = deck3
            decks[userInSeatOne] = deck4
        else if userInSeatThree is usernameToCallScore
            decks[userInSeatThree] = deck1
            decks[userInSeatFour] = deck2
            decks[userInSeatOne] = deck3
            decks[userInSeatTwo] = deck4
        else if userInSeatFour is usernameToCallScore
            decks[userInSeatFour] = deck1
            decks[userInSeatOne] = deck2
            decks[userInSeatTwo] = deck3
            decks[userInSeatThree] = deck4

        Room.update id: room.id,
            decks: decks
            coveredCards: coveredCards
        .then (updatedRooms) ->
            sails.sockets.broadcast room.socketIds[0], 'cardsSent', {cards: deck1, usernameToCallScore: usernameToCallScore}
            sails.sockets.broadcast room.socketIds[1], 'cardsSent', {cards: deck2, usernameToCallScore: usernameToCallScore}
            sails.sockets.broadcast room.socketIds[2], 'cardsSent', {cards: deck3, usernameToCallScore: usernameToCallScore}
            sails.sockets.broadcast room.socketIds[3], 'cardsSent', {cards: deck4, usernameToCallScore: usernameToCallScore}
            Promise.resolve()
        .catch (err) -> Promise.reject err