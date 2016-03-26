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
        # initialize number of winning chips for each user if it previously does not exist
        if not room.winning[userInSeatOne] then room.winning[userInSeatOne] = 0
        if not room.winning[userInSeatTwo] then room.winning[userInSeatTwo] = 0
        if not room.winning[userInSeatThree] then room.winning[userInSeatThree] = 0
        if not room.winning[userInSeatFour] then room.winning[userInSeatFour] = 0

        Room.update id: room.id,
            decks: decks
            coveredCards: coveredCards
            winning: room.winning
        .then (updatedRooms) ->
            sails.sockets.broadcast room.socketIds[0], 'cardsSent', {cards: deck1, usernameToCallScore: usernameToCallScore}
            sails.sockets.broadcast room.socketIds[1], 'cardsSent', {cards: deck2, usernameToCallScore: usernameToCallScore}
            sails.sockets.broadcast room.socketIds[2], 'cardsSent', {cards: deck3, usernameToCallScore: usernameToCallScore}
            sails.sockets.broadcast room.socketIds[3], 'cardsSent', {cards: deck4, usernameToCallScore: usernameToCallScore}
            Promise.resolve()
        .catch (err) -> Promise.reject err

    calculateGameResult: (room, isSurrender) ->
        users = [
            room.seats.one
            room.seats.two
            room.seats.three
            room.seats.four
        ]
        numOfWinningChipsForMaker = 0
        if isSurrender
            # 投降输一倍
            if room.aimedScore >= sails.config.constants.FLOOR_SCORES_FOR_DOUBLE_CHIPS_WHEN_SURRENDER
                numOfWinningChipsForMaker = -3 * sails.config.constants.NUM_OF_BASIC_CHIPS
                room.winning[room.maker] -= Math.abs(numOfWinningChipsForMaker)
                room.waterpool += Math.abs(numOfWinningChipsForMaker)
            # 投降输两倍
            else
                numOfWinningChipsForMaker = -2 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
                room.winning[room.maker] -= Math.abs(numOfWinningChipsForMaker)
                room.waterpool += Math.abs(numOfWinningChipsForMaker)
        else
            ############################# 得分不够，庄家胜利，双进单出 #############################
            # 清光
            if room.currentScore is 0 then numOfWinningChipsForMaker = 6 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
            # 小光
            else if room.currentScore < sails.config.constants.THRESHOLD_SCORES_FOR_XIAOGUANG then numOfWinningChipsForMaker = 4 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
            # 过庄
            else if room.currentScore < room.aimedScore then numOfWinningChipsForMaker = 2 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
            ############################# 超过喊分，闲家胜利，双进单出 #############################
            # 垮庄
            else if room.currentScore < (room.aimedScore + sails.config.constants.THRESHOLD_SCORES_FOR_DOUBLE_CHIPS) then numOfWinningChipsForMaker = -3 * sails.config.constants.NUM_OF_BASIC_CHIPS
            # 小到
            else if room.currentScore < (room.aimedScore + sails.config.constants.THRESHOLD_SCORES_FOR_TRIPLE_CHIPS) then numOfWinningChipsForMaker = -2 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
            # 大到
            else numOfWinningChipsForMaker = -3 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
            for i in [0...users.length]
                if users[i] isnt maker
                    room.winning[users[i]] -= numOfWinningChipsForMaker / 3
            if numOfWinningChipsForMaker > 0
                room.winning[room.maker] += (numOfWinningChipsForMaker + room.waterpool)
                room.waterpool = 0

        Room.update id: room.id,
            winning: room.winning
            waterpool: room.waterpool
        .then (updatedRooms) -> return numOfWinningChipsForMaker

