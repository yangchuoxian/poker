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
                foundRoomWithName.socketIds.splice index, 1
                index = foundRoomWithName.usernames.indexOf currentUserObject.username
                foundRoomWithName.usernames.splice index, 1
                index = foundRoomWithName.readyPlayers.indexOf currentUserObject.username
                foundRoomWithName.readyPlayers.splice index, 1
                # If there is no more player in this room, delete this room
                if foundRoomWithName.usernames.length is 0 then Room.destroy().where id: foundRoomWithName.id
                else
                    Room.update id: foundRoomWithName.id,
                        socketIds: foundRoomWithName.socketIds
                        usernames: foundRoomWithName.usernames
                        readyPlayers: foundRoomWithName.readyPlayers
        .then () -> User.update id: userId, {roomName: ''}
        .catch (err) -> Promise.reject err

    getNextUsernameToCallScore: (room, currentUser) ->
        nextUsernameToCallScore = ''
        if room.passedUsernames.length is 3 then return nextUsernameToCallScore
        index = room.usernames.indexOf currentUser.username
        for i in [1...4]
            nextIndex = (index + i) % 4
            if room.usernames[nextIndex] not in room.passedUsernames
                nextUsernameToCallScore = room.usernames[nextIndex]
                break
        nextUsernameToCallScore