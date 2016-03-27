Promise = require 'bluebird'
module.exports =
    playerLeaveRoom: (userId, socketId) ->
        sails.sockets.leave = Promise.promisify sails.sockets.leave
        currentUserObject = null
        User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            currentUserObject = foundUserWithId
            Room.findOne name: currentUserObject.roomName
        .then (foundRoomWithName) ->
            return Promise.resolve() if not foundRoomWithName
            sails.sockets.leave(socketId, foundRoomWithName.name)
            .then () ->
                sails.sockets.broadcast foundRoomWithName.name, 'playerLeavedRoom', {username: currentUserObject.username}
                index = foundRoomWithName.socketIds.indexOf currentUserObject.socketId
                if index isnt -1 then foundRoomWithName.socketIds.splice index, 1
                index = foundRoomWithName.usernames.indexOf currentUserObject.username
                if index isnt -1 then foundRoomWithName.usernames.splice index, 1
                index = foundRoomWithName.readyPlayers.indexOf currentUserObject.username
                if index isnt -1 then foundRoomWithName.readyPlayers.splice index, 1
                # Decide which seat is vacant now since that user left
                if currentUserObject.username is foundRoomWithName.seats.one then foundRoomWithName.seats.one = ''
                else if currentUserObject.username is foundRoomWithName.seats.two then foundRoomWithName.seats.two = ''
                else if currentUserObject.username is foundRoomWithName.seats.three then foundRoomWithName.seats.three = ''
                else if currentUserObject.username is foundRoomWithName.seats.four then foundRoomWithName.seats.four = ''
                # If there is no more player in this room, delete this room
                if foundRoomWithName.usernames.length is 0 then Room.destroy().where id: foundRoomWithName.id
                else
                    Room.update id: foundRoomWithName.id,
                        socketIds: foundRoomWithName.socketIds
                        usernames: foundRoomWithName.usernames
                        readyPlayers: foundRoomWithName.readyPlayers
                        seats: foundRoomWithName.seats
        .then () -> User.update id: userId, {roomName: ''}
        .catch (err) -> Promise.reject err

    getNextUsernameToCallScore: (room, currentUser) ->
        nextUsernameToCallScore = ''
        if room.passedUsernames.length is 3 then return nextUsernameToCallScore
        usernamesInSeats = [room.seats.one, room.seats.two, room.seats.three, room.seats.four]
        index = usernamesInSeats.indexOf currentUser.username
        for i in [1...4]
            nextIndex = (index + i) % 4
            if usernamesInSeats[nextIndex] not in room.passedUsernames
                nextUsernameToCallScore = usernamesInSeats[nextIndex]
                break
        nextUsernameToCallScore

    dispatchSeatForJoinedPlayer: (room, newPlayerUsername) ->
        if room.seats.one is '' then room.seats.one = newPlayerUsername
        else if room.seats.two is '' then room.seats.two = newPlayerUsername
        else if room.seats.three is '' then room.seats.three = newPlayerUsername
        else if room.seats.four is '' then room.seats.four = newPlayerUsername
        room.seats

    findNextPlayerToPlayCard: (seats, currentPlayerUsername) ->
        if seats.one is currentPlayerUsername then return seats.two
        else if seats.two is currentPlayerUsername then return seats.three
        else if seats.three is currentPlayerUsername then return seats.four
        else if seats.four is currentPlayerUsername then return seats.one

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

    clearAfterGameEnd: (room, didBankerWin) ->
        firstScoreCallerUsername = ''
        # 本盘庄家胜，下盘第一个叫分的玩家是本盘庄家
        if didBankerWin then firstScoreCallerUsername = room.banker
        # 本盘闲家胜，下盘第一个叫分的玩家是本盘庄家的下家
        else
            if room.seats.one is room.banker then firstScoreCallerUsername = room.seats.two
            else if room.seats.two is room.banker then firstScoreCallerUsername = room.seats.three
            else if room.seats.three is room.banker then firstScoreCallerUsername = room.seats.four
            else if room.seats.four is room.banker then firstScoreCallerUsername = room.seats.one
        Room.update id: room.id,
            readyPlayers: []
            aimedScore: 80
            currentScore: 0
            passedUsernames: []
            lastCaller: ''
            banker: ''
            mainSuit: null
            decks: {}
            coveredCards: []
            playedCardValuesForCurrentRound: []
            cardValueRanks: {}
            firstScoreCallerUsername: firstScoreCallerUsername
        .then (updatedRooms) -> return updatedRooms[0]
        .catch (err) -> Promise.reject err

    handleGameResult: (room, isSurrender) ->
        users = [
            room.seats.one
            room.seats.two
            room.seats.three
            room.seats.four
        ]
        numOfWinningChipsForBanker = 0
        changedQuantityOfWaterpool = 0
        didBankerWin = false
        if isSurrender
            # 投降输一倍
            if room.aimedScore >= sails.config.constants.FLOOR_SCORES_FOR_DOUBLE_CHIPS_WHEN_SURRENDER
                numOfWinningChipsForBanker = -3 * sails.config.constants.NUM_OF_BASIC_CHIPS
                changedQuantityOfWaterpool = Math.abs numOfWinningChipsForBanker
            # 投降输两倍
            else
                numOfWinningChipsForBanker = -2 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
                changedQuantityOfWaterpool = Math.abs numOfWinningChipsForBanker
            room.winning[room.banker] += numOfWinningChipsForBanker
            room.waterpool += changedQuantityOfWaterpool
        else
            ############################# 得分不够，庄家胜利，双进单出 #############################
            if room.currentScore < room.aimedScore
                didBankerWin = true
                # 清光
                if room.currentScore is 0 then numOfWinningChipsForBanker = 6 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
                # 小光
                else if room.currentScore < sails.config.constants.THRESHOLD_SCORES_FOR_XIAOGUANG then numOfWinningChipsForBanker = 4 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
                # 过庄
                else numOfWinningChipsForBanker = 2 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
            ############################# 超过喊分，闲家胜利，双进单出 #############################
            else
                # 垮庄
                if room.currentScore < (room.aimedScore + sails.config.constants.THRESHOLD_SCORES_FOR_DOUBLE_CHIPS) then numOfWinningChipsForBanker = -3 * sails.config.constants.NUM_OF_BASIC_CHIPS
                # 小到
                else if room.currentScore < (room.aimedScore + sails.config.constants.THRESHOLD_SCORES_FOR_TRIPLE_CHIPS) then numOfWinningChipsForBanker = -2 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
                # 大到
                else numOfWinningChipsForBanker = -3 * 3 * sails.config.constants.NUM_OF_BASIC_CHIPS
            for i in [0...users.length]
                if users[i] isnt room.banker
                    room.winning[users[i]] -= numOfWinningChipsForBanker / 3
            if didBankerWin
                room.winning[room.banker] += (numOfWinningChipsForBanker + room.waterpool)
                changedQuantityOfWaterpool = -room.waterpool
                room.waterpool = 0

        firstScoreCallerUsername = ''
        # 本盘庄家胜，下盘第一个叫分的玩家是本盘庄家
        if didBankerWin then firstScoreCallerUsername = room.banker
        # 本盘闲家胜，下盘第一个叫分的玩家是本盘庄家的下家
        else
            if room.seats.one is room.banker then firstScoreCallerUsername = room.seats.two
            else if room.seats.two is room.banker then firstScoreCallerUsername = room.seats.three
            else if room.seats.three is room.banker then firstScoreCallerUsername = room.seats.four
            else if room.seats.four is room.banker then firstScoreCallerUsername = room.seats.one
        # clear info for this game since this game is finished
        Room.update id: room.id,
            readyPlayers: []
            aimedScore: 80
            currentScore: 0
            passedUsernames: []
            lastCaller: ''
            banker: ''
            mainSuit: null
            decks: {}
            coveredCards: []
            playedCardValuesForCurrentRound: []
            cardValueRanks: {}
            firstScoreCallerUsername: firstScoreCallerUsername
            winning: room.winning
            waterpool: room.waterpool
            nonBankerPlayersHaveNoMainSuit: sails.config.constants.FALSE
        .then (updatedRooms) ->
            numOfWinningChipsForBanker: numOfWinningChipsForBanker
            firstScoreCallerUsername: firstScoreCallerUsername
            changedQuantityOfWaterpool: changedQuantityOfWaterpool
            currentWaterpoll: updatedRooms[0].waterpool
        .catch (err) -> Promise.reject err
