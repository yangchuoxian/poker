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
            if updatedRooms[0].readyPlayers.length is 4 then GameService.sendCards updatedRooms[0], updatedRooms[0].usernames[0]
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
        User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            currentUserObject = foundUserWithId
            Room.findOne name: foundUserWithId.roomName
        .then (foundRoomWithName) ->
            return Promise.reject '房间不存在' if not foundRoomWithName
            foundRoomWithName.passedUsernames.push currentUserObject.username
            Room.update id: foundRoomWithName.id,
                passedUsernames: foundRoomWithName.passedUsernames
        .then (updatedRooms) ->
            currentRoomObject = updatedRooms[0]
            res.send 'OK'
            nextUsernameToCallScore = RoomService.getNextUsernameToCallScore currentRoomObject, currentUserObject
            if nextUsernameToCallScore isnt ''     # At least one user have not passed yet
                sails.sockets.broadcast currentUserObject.roomName, 'userPassed',
                    aimedScore: currentRoomObject.aimedScore
                    passedUser: currentUserObject.username
                    usernameToCallScore: nextUsernameToCallScore
                Promise.resolve()
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
            index = foundRoomWithName.usernames.indexOf maker
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
        Room.update name: roomName,
            mainSuit: mainSuit
        .then (updatedRooms) ->
            return Promise.reject '房间不存在' if not updatedRooms
            sails.sockets.broadcast roomName, 'mainSuitChosen',
                mainSuit: mainSuit
            res.send 'OK'
        .catch (err) -> res.send 400, err

    playCards: (req, res) ->
        userId = req.param 'userId'
        playedCardValues = req.param 'playedCardValues'
        currentUserObject = null
        roomObject = null
        User.findOne id: userId
        .then (foundUserWithId) ->
            return Promise.reject '用户不存在' if not foundUserWithId
            currentUserObject = foundUserWithId
            Room.findOne name: foundUserWithId.roomName
        .then (foundRoomWithName) ->
            return Promise.reject '房间不存在' if not foundRoomWithName
            return Promise.reject '本轮所有玩家已出玩牌' if foundRoomWithName.playedCardValuesForCurrentRound.length is 4
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
                usernameWithLargestCardsForCurrentRound = Toolbox.getPlayerThatPlayedLargestCardsForThisRound updatedRoom.playedCardValuesForCurrentRound, updatedRoom.mainSuit
                scoresEarned = 0
                # if the username that played the largest cards is NOT the maker, then we calculate how many scores are earned for this round
                if usernameWithLargestCardsForCurrentRound isnt updatedRoom.maker
                    scoresEarned = Toolbox.calculateTotalScoresForThisRound updatedRoom.playedCardValuesForCurrentRound
                    Room.update id: updatedRoom.id,
                        currentScore: scoresEarned
                    .then () -> Promise.resolve()
                sails.sockets.broadcast currentUserObject.roomName, 'roundFinished',
                    scoresEarned: scoresEarned
                    usernameWithLargestCardsForCurrentRound: usernameWithLargestCardsForCurrentRound
            else
                sails.sockets.broadcast currentUserObject.roomName, 'cardPlayed',
                    playerName: currentUserObject.username
                    playedCardValues: playedCardValues
                    numberOfUsersPlayed: updatedRoom.playedCardValuesForCurrentRound.length
                Promise.resolve()
        .then () -> res.send 'OK'
        .catch (err) -> res.send 400, err