###
CommunicationController

@description :: Server-side logic for managing communications
@help        :: See http://links.sailsjs.org/docs/controllers
###

Promise = require 'bluebird'
module.exports =
    createNewRoom: (req, res) ->
        roomName = req.param 'roomName'
        password = req.param 'password'
        userId = req.param 'userId'
        socketId = sails.sockets.getId req
        sails.sockets.leave = Promise.promisify sails.sockets.leave
        currentUserObject = null
        bcrypt = Promise.promisifyAll require 'bcrypt'
        Room.findOne name: roomName
        .then (foundRoomWithName) ->
            return Promise.reject '房间名已存在' if foundRoomWithName
            User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            currentUserObject = foundUserWithId
            # If this user is in any other room, leave that room
            Room.findOne
                usernames: currentUserObject.username
                socketIds: socketId
        .then (foundPreviouslyEnteredRoom) ->
            # Leave previously entered room and
            # send a broadcast to notify remaining members in that previous that this user has left the room
            if foundPreviouslyEnteredRoom then RoomService.playerLeaveRoom currentUserObject.id, socketId
            sails.sockets.join = Promise.promisify sails.sockets.join
            sails.sockets.join socketId, roomName
        .then () -> bcrypt.genSaltAsync 10
        .then (salt) -> bcrypt.hashAsync password, salt
        .then (hash) ->
            Room.create
                name: roomName
                password: hash
                socketIds: [socketId]
                usernames: [currentUserObject.username]
                firstScoreCallerUsername: currentUserObject.username
                seats:
                    one: currentUserObject.username
                    two: ''
                    three: ''
                    four: ''
        .then (createdRoom) ->
            User.update id: currentUserObject.id,
                socketId: socketId
                roomName: roomName
        .then (updatedUsers) -> res.json {roomName: roomName}
        .catch (err) -> res.send 400, err

    joinRoom: (req, res) ->
        roomName = req.param 'roomName'
        password = req.param 'password'
        userId = req.param 'userId'
        socketId = sails.sockets.getId req
        roomObject = null
        currentUserObject = null
        sails.sockets.leave = Promise.promisify sails.sockets.leave
        comparePassword = Promise.promisify require('bcrypt').compare
        Room.findOne name: roomName
        .then (foundRoomWithName) ->
            return Promise.reject '房间不存在' if not foundRoomWithName
            return Promise.reject '人数已满' if foundRoomWithName.socketIds.length is 4
            roomObject = foundRoomWithName
            comparePassword password, foundRoomWithName.password
        .then (match) ->
            return Promise.reject '密码不正确' if not match
            User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            currentUserObject = foundUserWithId
            # If this user is in any other room, leave that room
            Room.findOne
                usernames: currentUserObject.username
                socketIds: socketId
        .then (foundPreviouslyEnteredRoom) ->
            # Leave previously entered room and
            # send a broadcast to notify remaining members in that previous that this user has left the room
            if foundPreviouslyEnteredRoom then RoomService.playerLeaveRoom currentUserObject.id, socketId
            sails.sockets.join = Promise.promisify sails.sockets.join
            sails.sockets.join socketId, roomName
        .then () ->
            dispatchedSeats = RoomService.dispatchSeatForJoinedPlayer roomObject, currentUserObject.username
            roomObject.usernames.push currentUserObject.username
            socketIds = roomObject.socketIds
            socketIds.push socketId
            Room.update id: roomObject.id,
                socketIds: socketIds
                usernames: roomObject.usernames
                seats: dispatchedSeats
        .then (updatedRooms) ->
            roomObject = updatedRooms[0]
            User.update id: currentUserObject.id,
                socketId: socketId
                roomName: roomName
        .then () ->
            sails.sockets.broadcast roomName, 'newPlayerJoined',
                newPlayer: currentUserObject.username
                seats: roomObject.seats
            res.json {roomName: roomName}
        .catch (err) -> res.send 400, err

    getRoomInfo: (req, res) ->
        userId = req.param 'userId'
        socketId = sails.sockets.getId req
        roomObject = null
        User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            Room.findOne name: foundUserWithId.roomName
        .then (foundRoomWithName) ->
            return Promise.reject '房间不存在' if not foundRoomWithName
            roomObject = foundRoomWithName
            # Now attach the socket id and room name to the logged in user
            User.update id: userId,
                socketId: socketId
                roomName: roomObject.name
        .then (updatedUsers) ->
            res.send
                roomName: roomObject.name
                readyPlayers: roomObject.readyPlayers
                seats: roomObject.seats
        .catch (err) -> res.send 400, err

    leaveRoom: (req, res) ->
        userId = req.param 'userId'
        socketId = sails.sockets.getId req
        RoomService.playerLeaveRoom userId, socketId
        .then () -> res.send 'OK'
        .catch (err) -> res.send 400, err

    getReady: (req, res) ->
        userId = req.param 'userId'
        currentUserObject = null
        User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            currentUserObject = foundUserWithId
            Room.findOne name: currentUserObject.roomName
        .then (foundRoomWithName) ->
            return Promise.reject '房间不存在' if not foundRoomWithName
            foundRoomWithName.readyPlayers.push currentUserObject.username
            Room.update id: foundRoomWithName.id,
                readyPlayers: foundRoomWithName.readyPlayers
        .then (updatedRooms) ->
            if updatedRooms[0].readyPlayers.length is 4 then RoomService.sendCards updatedRooms[0], updatedRooms[0].firstScoreCallerUsername
            else
                sails.sockets.broadcast updatedRooms[0].name, 'playerReady', {username: currentUserObject.username}
                Promise.resolve()
        .then -> res.send 'OK'
        .catch (err) -> res.send 400, err

    setScore: (req, res) ->
        score = req.param 'score'
        userId = req.param 'userId'
        roomName = req.param 'roomName'
        currentUserObject = null
        User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            currentUserObject = foundUserWithId
            Room.update name: roomName,
                aimedScore: score
                lastCaller: currentUserObject.username
        .then (updatedRooms) ->
            return Promise.reject '房间不存在' if not updatedRooms
            foundRoomWithName = updatedRooms[0]
            if score > 5
                nextUsernameToCallScore = RoomService.getNextUsernameToCallScore foundRoomWithName, currentUserObject
                if nextUsernameToCallScore  # At least one user have not passed yet
                    sails.sockets.broadcast currentUserObject.roomName, 'userCalledScore',
                        currentAimedScore: score
                        usernameCalledScore: currentUserObject.username
                        usernameToCallScore: nextUsernameToCallScore
                    return Promise.resolve()
            sails.sockets.broadcast currentUserObject.roomName, 'makerSettled',
                aimedScore: score
                makerUsername: currentUserObject.username
                coveredCards: foundRoomWithName.coveredCards
            Room.update id: foundRoomWithName.id,
                maker: currentUserObject.username
        .then () -> res.send 'OK'
        .catch (err) -> res.send 400, err

    pass: (req, res) ->
        userId = req.param 'userId'
        currentUserObject = null
        currentRoomObject = null
        didFirstCallerPassed = false
        User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            currentUserObject = foundUserWithId
            Room.findOne name: foundUserWithId.roomName
        .then (foundRoomWithName) ->
            return Promise.reject '房间不存在' if not foundRoomWithName
            currentRoomObject = foundRoomWithName
            # If the first caller passes, he/she is calling 80 since he/she CANNOT really pass
            if currentRoomObject.firstScoreCallerUsername is currentUserObject.username and
            currentRoomObject.passedUsernames.length is 0 and
            not currentRoomObject.lastCaller
                didFirstCallerPassed = true
                Room.update id: currentRoomObject.id,
                    lastCaller: currentUserObject.username
                .then (updatedRooms) -> currentRoomObject = updatedRooms[0]
        .then () ->
            if not didFirstCallerPassed
                currentRoomObject.passedUsernames.push currentUserObject.username
                Room.update id: currentRoomObject.id,
                    passedUsernames: currentRoomObject.passedUsernames
                .then (updatedRooms) -> currentRoomObject = updatedRooms[0]
        .then () -> res.send 'OK'
        .then () ->
            nextUsernameToCallScore = RoomService.getNextUsernameToCallScore currentRoomObject, currentUserObject
            if nextUsernameToCallScore              # At least one user have not passed yet
                if not didFirstCallerPassed
                    sails.sockets.broadcast currentUserObject.roomName, 'userPassed',
                        aimedScore: currentRoomObject.aimedScore
                        passedUser: currentUserObject.username
                        usernameToCallScore: nextUsernameToCallScore
                    return Promise.resolve()
                else
                    sails.sockets.broadcast currentUserObject.roomName, 'userCalledScore',
                        currentAimedScore: 80
                        usernameCalledScore: currentUserObject.username
                        usernameToCallScore: nextUsernameToCallScore
                    return Promise.resolve()
            else
                sails.sockets.broadcast currentUserObject.roomName, 'makerSettled',
                    aimedScore: currentRoomObject.aimedScore
                    makerUsername: currentRoomObject.lastCaller
                    coveredCards: currentRoomObject.coveredCards
                Room.update id: currentRoomObject.id,
                    maker: currentRoomObject.lastCaller
                .then () -> Promise.resolve()
        .catch (err) -> res.send 400, err

    settleCoveredCards: (req, res) ->
        roomName = req.param 'roomName'
        coveredCards = req.param 'coveredCards'
        cardsAtHand = req.param 'cardsAtHand'
        maker = req.param 'maker'
        Room.findOne name: roomName
        .then (foundRoomWithName) ->
            return Promise.reject '房间不存在' if not foundRoomWithName
            foundRoomWithName.decks[maker] = cardsAtHand
            foundRoomWithName.coveredCards = coveredCards
            Room.update id: foundRoomWithName.id,
                decks: foundRoomWithName.decks
                coveredCards: foundRoomWithName.coveredCards
                maker: maker
        .then (updatedRooms) ->
            sails.sockets.broadcast roomName, 'finishedSettlingCoveredCards',
                maker: maker
            res.send 'OK'
        .catch (err) -> res.send 400, err

    chooseMainSuit: (req, res) ->
        roomName = req.param 'roomName'
        maker = req.param 'maker'
        mainSuit = req.param 'mainSuit'
        cardValueRanks = Toolbox.getRanksForMainSuitCards mainSuit
        Room.update name: roomName,
            mainSuit: mainSuit
            cardValueRanks: cardValueRanks
        .then (updatedRooms) ->
            return Promise.reject '房间不存在' if not updatedRooms
            sails.sockets.broadcast roomName, 'mainSuitChosen',
                mainSuit: mainSuit
                maker: updatedRooms[0].maker
            res.send 'OK'
        .catch (err) -> res.send 400, err

    playCards: (req, res) ->
        userId = req.param 'userId'
        playedCardValues = req.param 'playedCardValues'
        currentUserObject = null
        User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            currentUserObject = foundUserWithId
            Room.findOne name: foundUserWithId.roomName
        .then (foundRoomWithName) ->
            return Promise.reject '房间不存在' if not foundRoomWithName
            return Promise.reject '本轮所有玩家已出玩牌' if foundRoomWithName.playedCardValuesForCurrentRound.length is 4
            # validate whether the played card is legal or not
            firstlyPlayedCardValues = []
            if foundRoomWithName.playedCardValuesForCurrentRound.length isnt 0 then firstlyPlayedCardValues = foundRoomWithName.playedCardValuesForCurrentRound[0].playedCardValues
            return Promise.reject '出牌不符合规则' if not Toolbox.validatePlayedCards(playedCardValues, firstlyPlayedCardValues, foundRoomWithName.decks[currentUserObject.username], foundRoomWithName.mainSuit, foundRoomWithName.cardValueRanks)
            # remove the played cards from the corresponding deck
            deck = foundRoomWithName.decks[currentUserObject.username]
            for i in [0...playedCardValues.length]
                index = deck.indexOf playedCardValues[i]
                deck.splice index, 1
            foundRoomWithName.decks[currentUserObject.username] = deck
            # push the played cards into current round played cards
            foundRoomWithName.playedCardValuesForCurrentRound.push
                username: currentUserObject.username
                playedCardValues: playedCardValues
            Room.update id: foundRoomWithName.id,
                decks: foundRoomWithName.decks
                playedCardValuesForCurrentRound: foundRoomWithName.playedCardValuesForCurrentRound
        .then (updatedRooms) ->
            updatedRoom = updatedRooms[0]
            # current round is finished, all 4 players have played cards
            if updatedRoom.playedCardValuesForCurrentRound.length is 4
                # get the username that played the largest cards for current round
                usernameWithLargestCardsForCurrentRound = Toolbox.getPlayerThatPlayedLargestCardsForThisRound updatedRoom.playedCardValuesForCurrentRound, updatedRoom.mainSuit, updatedRoom.cardValueRanks
                scoresEarned = 0
                # if the username that played the largest cards is NOT the maker, then we calculate how many scores are earned for this round
                if usernameWithLargestCardsForCurrentRound isnt updatedRoom.maker then scoresEarned = Toolbox.calculateTotalScoresForThisRound updatedRoom.playedCardValuesForCurrentRound
                # now that current round is finished, we should clear the played card values for current round
                Room.update id: updatedRoom.id,
                    currentScore: updatedRoom.currentScore + scoresEarned
                    playedCardValuesForCurrentRound: []
                .then (updatedRooms) ->
                    updatedRoom = updatedRooms[0]
                    shouldGameEnd = false
                    # earned scores has already reached the triple chip threshold, game should end in advance
                    if updatedRoom.currentScore >= (updatedRoom.aimedScore + sails.config.constants.THRESHOLD_SCORES_FOR_TRIPLE_CHIPS) then shouldGameEnd = true
                    # no more card left, all cards played out
                    if updatedRoom.decks[updatedRoom.maker].length is 0 then shouldGameEnd = true
                    roundFinishedInfo =
                        lastPlayerName: currentUserObject.username
                        playedCardValues: playedCardValues
                        scoresEarned: scoresEarned
                        usernameWithLargestCardsForCurrentRound: usernameWithLargestCardsForCurrentRound
                        shouldGameEnd: shouldGameEnd
                    if shouldGameEnd
                        RoomService.handleGameResult updatedRoom, false
                        .then (gameResults) ->
                            roundFinishedInfo.gameResults = gameResults
                            sails.sockets.broadcast currentUserObject.roomName, 'roundFinished', roundFinishedInfo
                    else sails.sockets.broadcast currentUserObject.roomName, 'roundFinished', roundFinishedInfo
            # current round is NOT finished yet
            else
                nextPlayerUsername = RoomService.findNextPlayerToPlayCard updatedRoom.seats, currentUserObject.username
                sails.sockets.broadcast currentUserObject.roomName, 'cardPlayed',
                    firstlyPlayedCardValues: updatedRoom.playedCardValuesForCurrentRound[0].playedCardValues
                    playerName: currentUserObject.username
                    playedCardValues: playedCardValues
                    nextPlayerUsername: nextPlayerUsername
                Promise.resolve()
        .then () -> res.send 'OK'
        # .catch (err) -> res.send 400, err

    surrender: (req, res) ->
        userId = req.param 'userId'
        currentUserObject = null
        currentRoomObject = null
        User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            currentUserObject = foundUserWithId
            Room.findOne name: currentUserObject.roomName
        .then (foundRoomWithName) ->
            return Promise.reject '房间不存在' if not foundRoomWithName
            return Promise.reject '闲家不能投降' if foundRoomWithName.maker isnt currentUserObject.username
            currentRoomObject = foundRoomWithName
            RoomService.handleGameResult currentRoomObject, true
        .then (gameResults) ->
            res.json
                gameResults: gameResults
                makerUsername: currentRoomObject.maker
        .catch (err) -> res.send 400, err