constants = require './constants.js'
actions = require './actions.js'
toolbox = require './toolbox.js'
globalVariables = require './globalVariables.js'

getRoomInfo = (game) ->
    io.socket.get '/get_room_info',
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
    , (resData, jwres) ->
        if jwres.statusCode is 200
            globalVariables.textOfRoomName.text = resData.roomName
            usernames = resData.usernames
            seats = [resData.seats.one, resData.seats.two, resData.seats.three, resData.seats.four]
            seatIndexOfCurrentUser = seats.indexOf globalVariables.username
            for i in [seatIndexOfCurrentUser + 1...seatIndexOfCurrentUser + 4]
                if seats[i % 4] isnt ''
                    diff = i - seatIndexOfCurrentUser
                    switch diff
                        when 1 or -3 then actions.showPlayer1Info game, seats[i % 4]
                        when 2 or -2 then actions.showPlayer2Info game, seats[i % 4]
                        when 3 or -1 then actions.showPlayer3Info game, seats[i % 4]
            readyPlayers = resData.readyPlayers
            for i in [0...readyPlayers.length]
                if globalVariables.player1Username
                    if readyPlayers[i] is globalVariables.player1Username.text then globalVariables.player1StatusText.text = 'Ready'
                if globalVariables.player2Username
                    if readyPlayers[i] is globalVariables.player2Username.text then globalVariables.player2StatusText.text = 'Ready'
                if globalVariables.player3Username
                    if readyPlayers[i] is globalVariables.player3Username.text then globalVariables.player3StatusText.text = 'Ready'

socketEventHandler = (game) ->
    io.socket.on 'newPlayerJoined', (data) ->
        newPlayerUsername = data.newPlayer
        seats = [data.seats.one, data.seats.two, data.seats.three, data.seats.four]
        seatIndexOfCurrentUser = seats.indexOf globalVariables.username
        seatIndexOfNewPlayer = seats.indexOf newPlayerUsername
        diff = seatIndexOfNewPlayer - seatIndexOfCurrentUser
        if diff is 1 or diff is -3 then actions.showPlayer1Info game, newPlayerUsername
        if diff is 2 or diff is -2 then actions.showPlayer2Info game, newPlayerUsername
        if diff is 3 or diff is -1 then actions.showPlayer3Info game, newPlayerUsername
        return

    io.socket.on 'playerLeavedRoom', (data) ->
        leftUsername = data.username
        actions.hideLeftPlayer leftUsername

    io.socket.on 'playerReady', (data) ->
        readyUsername = data.username
        if globalVariables.player1Username
            if readyUsername is globalVariables.player1Username.text then globalVariables.player1StatusText.text = 'Ready'
        if globalVariables.player2Username
            if readyUsername is globalVariables.player2Username.text then globalVariables.player2StatusText.text = 'Ready'
        if globalVariables.player3Username
            if readyUsername is globalVariables.player3Username.text then globalVariables.player3StatusText.text = 'Ready'

    io.socket.on 'cardsSent', (data) ->
        globalVariables.cardsAtHand.values = data.cards
        globalVariables.cardsAtHand.values = data.cards
        usernameToCallScore = data.usernameToCallScore
        globalVariables.cardsAtHand.values = toolbox.sortCards globalVariables.cardsAtHand.values
        actions.displayCards globalVariables.cardsAtHand.values
        globalVariables.meStatusText.text = ''
        globalVariables.player1StatusText.text = ''
        globalVariables.player2StatusText.text = ''
        globalVariables.player3StatusText.text = ''

        globalVariables.textOfAimedScores.text = '80'
        globalVariables.textOfCurrentScores.text = '0'
        if usernameToCallScore is globalVariables.username then actions.showCallScorePanel(game, 80)
        else
            if usernameToCallScore is globalVariables.player1Username.text then globalVariables.player1StatusText.text = '叫分中...'
            else if usernameToCallScore is globalVariables.player2Username.text then globalVariables.player2StatusText.text = '叫分中...'
            else if usernameToCallScore is globalVariables.player3Username.text then globalVariables.player3StatusText.text = '叫分中...'

    io.socket.on 'userCalledScore', (data) ->
        currentAimedScore = data.currentAimedScore
        usernameCalledScore = data.usernameCalledScore
        usernameToCallScore = data.usernameToCallScore
        globalVariables.textOfAimedScores.text = '' + currentAimedScore
        if usernameToCallScore is globalVariables.username
            globalVariables.meStatusText.text = '叫分中...'
            actions.showCallScorePanel game, currentAimedScore
        else if usernameToCallScore is globalVariables.player1Username.text then globalVariables.player1StatusText.text = '叫分中...'
        else if usernameToCallScore is globalVariables.player2Username.text then globalVariables.player2StatusText.text = '叫分中...'
        else if usernameToCallScore is globalVariables.player3Username.text then globalVariables.player3StatusText.text = '叫分中...'

        if usernameCalledScore is globalVariables.player1Username.text then globalVariables.player1StatusText.text = currentAimedScore + '分'
        else if usernameCalledScore is globalVariables.player2Username.text then globalVariables.player2StatusText.text = currentAimedScore + '分'
        else if usernameCalledScore is globalVariables.player3Username.text then globalVariables.player3StatusText.text = currentAimedScore + '分'

    io.socket.on 'userPassed', (data) ->
        passedUser = data.passedUser
        usernameToCallScore = data.usernameToCallScore
        currentAimedScore = data.aimedScore
        if passedUser is globalVariables.player1Username.text then globalVariables.player1StatusText.text = '不要'
        else if passedUser is globalVariables.player2Username.text then globalVariables.player2StatusText.text = '不要'
        else if passedUser is globalVariables.player3Username.text then globalVariables.player3StatusText.text = '不要'
        if usernameToCallScore is globalVariables.username then actions.showCallScorePanel game, currentAimedScore

    io.socket.on 'makerSettled', (data) ->
        aimedScore = data.aimedScore
        makerUsername = data.makerUsername
        globalVariables.textOfAimedScores.text = aimedScore + '分'
        if makerUsername is globalVariables.player1Username.text then globalVariables.player1IsMakerIcon.visible = true
        else if makerUsername is globalVariables.player2Username.text then globalVariables.player2IsMakerIcon.visible = true
        else if makerUsername is globalVariables.player3Username.text then globalVariables.player3IsMakerIcon.visible = true
        if makerUsername is globalVariables.username
            coveredCards = data.coveredCards
            globalVariables.cardsAtHand.values = globalVariables.cardsAtHand.values.concat coveredCards
            globalVariables.cardsAtHand.values = toolbox.sortCards globalVariables.cardsAtHand.values
            actions.displayCards globalVariables.cardsAtHand.values
            globalVariables.surrenderButton.visible = true
            globalVariables.settleCoveredCardsButton.visible = true
            globalVariables.settleCoveredCardsButton.inputEnabled = false
            globalVariables.settleCoveredCardsButton.setFrames 2, 2, 2

            globalVariables.player1StatusText.text = ''
            globalVariables.player2StatusText.text = ''
            globalVariables.player3StatusText.text = ''
        else if makerUsername is globalVariables.player1Username.text
            globalVariables.meStatusText.text = ''
            globalVariables.player1StatusText.text = '庄家埋底中...'
            globalVariables.player2StatusText.text = ''
            globalVariables.player3StatusText.text = ''
        else if makerUsername is globalVariables.player2Username.text
            globalVariables.meStatusText.text = ''
            globalVariables.player1StatusText.text = ''
            globalVariables.player2StatusText.text = '庄家埋底中...'
            globalVariables.player3StatusText.text = ''
        else if makerUsername is globalVariables.player3Username.text
            globalVariables.meStatusText.text = ''
            globalVariables.player1StatusText.text = ''
            globalVariables.player2StatusText.text = ''
            globalVariables.player3StatusText.text = '庄家埋底中...'
        globalVariables.gameStatus = constants.GAME_STATUS_SETTLING_COVERED_CARDS

    io.socket.on 'finishedSettlingCoveredCards', (data) ->
        makerUsername = data.maker
        if makerUsername is globalVariables.player1Username.text then globalVariables.player1StatusText.text = '庄家选主中...'
        else if makerUsername is globalVariables.player2Username.text then globalVariables.player2StatusText.text = '庄家选主中...'
        else if makerUsername is globalVariables.player3Username.text then globalVariables.player3StatusText.text = '庄家选主中...'

    io.socket.on 'mainSuitChosen', (data) ->
        mainSuit = data.mainSuit
        globalVariables.mainSuit = mainSuit
        globalVariables.iconOfMainSuit.frame = globalVariables.mainSuit
        globalVariables.meStatusText.text = ''
        globalVariables.player1StatusText.text = ''
        globalVariables.player2StatusText.text = ''
        globalVariables.player3StatusText.text = ''

    io.socket.on 'cardPlayed', (data) ->
        usernamePlayedCards = data.playerName
        playedCardValues = data.playedCardValues
        firstlyPlayedCardValues = data.firstlyPlayedCardValues
        globalVariables.firstlyPlayedCardValuesForCurrentRound = firstlyPlayedCardValues
        n = -1
        if usernamePlayedCards is globalVariables.player1Username.text then n = 1
        else if usernamePlayedCards is globalVariables.player2Username.text then n = 2
        else if usernamePlayedCards is globalVariables.player3Username.text then n = 3
        actions.showPlayedCardsForUser n, playedCardValues

    io.socket.on 'roundFinished', (data) ->
        usernamePlayedCards = data.lastPlayerName
        playedCardValues = data.playedCardValues
        scoresEarned = data.scoresEarned
        usernameWithLargestCardsForCurrentRound = data.usernameWithLargestCardsForCurrentRound
        n = -1
        if usernamePlayedCards is globalVariables.player1Username.text then n = 1
        else if usernamePlayedCards is globalVariables.player2Username.text then n = 2
        else if usernamePlayedCards is globalVariables.player3Username.text then n = 3
        actions.showPlayedCardsForUser n, playedCardValues
        actions.showBigStampForTheLargestPlayedCardsCurrentRound playedCardValues.length, usernameWithLargestCardsForCurrentRound, game

module.exports =
    getRoomInfo: getRoomInfo
    socketEventHandler: socketEventHandler
