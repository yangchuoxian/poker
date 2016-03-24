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