constants = require './constants.js'
actions = require './actions.js'
toolbox = require './toolbox.js'
globalVariables = require './globalVariables.js'

###
Set status text for one player and clear status text for all other players
@param: username                                player username whose status text needs to be updated
@param: statusText                              the status text string
@return: -
###
setPlayerStatusTextForOneUserAndClearStatusTextForOthers = ( username, statusText ) ->
    globalVariables.meStatusText.text = ''
    globalVariables.player1StatusText.text = ''
    globalVariables.player2StatusText.text = ''
    globalVariables.player3StatusText.text = ''
    if username is globalVariables.username then globalVariables.meStatusText.text = statusText
    else if username is globalVariables.player1Username.text then globalVariables.player1StatusText.text = statusText
    else if username is globalVariables.player2Username.text then globalVariables.player2StatusText.text = statusText
    else if username is globalVariables.player3Username.text then globalVariables.player3StatusText.text = statusText

getRoomInfo = ( game ) ->
    io.socket.get '/get_room_info',
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
    , ( resData, jwres ) ->
        if jwres.statusCode is 200
            globalVariables.textOfRoomName.text = resData.roomName
            usernames = resData.usernames
            seats = [resData.seats.one, resData.seats.two, resData.seats.three, resData.seats.four]
            seatIndexOfCurrentUser = seats.indexOf( globalVariables.username )
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

socketEventHandler = ( game ) ->
    io.socket.on 'newPlayerJoined', ( data ) ->
        newPlayerUsername = data.newPlayer
        seats = [data.seats.one, data.seats.two, data.seats.three, data.seats.four]
        seatIndexOfCurrentUser = seats.indexOf( globalVariables.username )
        seatIndexOfNewPlayer = seats.indexOf( newPlayerUsername )
        diff = seatIndexOfNewPlayer - seatIndexOfCurrentUser
        if diff is 1 or diff is -3 then actions.showPlayer1Info( game, newPlayerUsername )
        if diff is 2 or diff is -2 then actions.showPlayer2Info( game, newPlayerUsername )
        if diff is 3 or diff is -1 then actions.showPlayer3Info( game, newPlayerUsername )
        return

    io.socket.on 'playerLeavedRoom', ( data ) ->
        leftUsername = data.username
        actions.hideLeftPlayer( leftUsername )

    io.socket.on 'playerReady', ( data ) ->
        readyUsername = data.username
        if globalVariables.player1Username
            if readyUsername is globalVariables.player1Username.text then globalVariables.player1StatusText.text = 'Ready'
        if globalVariables.player2Username
            if readyUsername is globalVariables.player2Username.text then globalVariables.player2StatusText.text = 'Ready'
        if globalVariables.player3Username
            if readyUsername is globalVariables.player3Username.text then globalVariables.player3StatusText.text = 'Ready'

    io.socket.on 'cardsSent', ( data ) ->
        globalVariables.cardsAtHand.values = data.cards
        globalVariables.cardsAtHand.values = data.cards
        usernameToCallScore = data.usernameToCallScore
        globalVariables.cardsAtHand.values = toolbox.sortCards( globalVariables.cardsAtHand.values )
        actions.displayCards( globalVariables.cardsAtHand.values )
        globalVariables.meStatusText.text = ''
        globalVariables.player1StatusText.text = ''
        globalVariables.player2StatusText.text = ''
        globalVariables.player3StatusText.text = ''

        globalVariables.textOfAimedScores.text = '80'
        globalVariables.textOfCurrentScores.text = '0'
        if usernameToCallScore is globalVariables.username then actions.showCallScorePanel( game, 80 )
        else
            if usernameToCallScore is globalVariables.player1Username.text then globalVariables.player1StatusText.text = '叫分中...'
            else if usernameToCallScore is globalVariables.player2Username.text then globalVariables.player2StatusText.text = '叫分中...'
            else if usernameToCallScore is globalVariables.player3Username.text then globalVariables.player3StatusText.text = '叫分中...'

    io.socket.on 'userCalledScore', ( data ) ->
        currentAimedScore = data.currentAimedScore
        usernameCalledScore = data.usernameCalledScore
        usernameToCallScore = data.usernameToCallScore
        globalVariables.textOfAimedScores.text = '' + currentAimedScore
        if usernameToCallScore is globalVariables.username
            globalVariables.meStatusText.text = '叫分中...'
            actions.showCallScorePanel( game, currentAimedScore )
        else if usernameToCallScore is globalVariables.player1Username.text then globalVariables.player1StatusText.text = '叫分中...'
        else if usernameToCallScore is globalVariables.player2Username.text then globalVariables.player2StatusText.text = '叫分中...'
        else if usernameToCallScore is globalVariables.player3Username.text then globalVariables.player3StatusText.text = '叫分中...'

        if usernameCalledScore is globalVariables.player1Username.text then globalVariables.player1StatusText.text = currentAimedScore + '分'
        else if usernameCalledScore is globalVariables.player2Username.text then globalVariables.player2StatusText.text = currentAimedScore + '分'
        else if usernameCalledScore is globalVariables.player3Username.text then globalVariables.player3StatusText.text = currentAimedScore + '分'

    io.socket.on 'userPassed', ( data ) ->
        passedUser = data.passedUser
        usernameToCallScore = data.usernameToCallScore
        currentAimedScore = data.aimedScore
        if passedUser is globalVariables.player1Username.text then globalVariables.player1StatusText.text = '不要'
        else if passedUser is globalVariables.player2Username.text then globalVariables.player2StatusText.text = '不要'
        else if passedUser is globalVariables.player3Username.text then globalVariables.player3StatusText.text = '不要'
        if usernameToCallScore is globalVariables.username then actions.showCallScorePanel game, currentAimedScore

    io.socket.on 'bankerSurrendered', ( data ) -> actions.endGame( true, data, game )

    io.socket.on 'bankerSettled', ( data ) ->
        aimedScore = data.aimedScore
        bankerUsername = data.bankerUsername
        globalVariables.textOfAimedScores.text = aimedScore + '分'
        if bankerUsername is globalVariables.player1Username.text then globalVariables.player1IsBankerIcon.visible = true
        else if bankerUsername is globalVariables.player2Username.text then globalVariables.player2IsBankerIcon.visible = true
        else if bankerUsername is globalVariables.player3Username.text then globalVariables.player3IsBankerIcon.visible = true
        if bankerUsername is globalVariables.username
            coveredCards = data.coveredCards
            globalVariables.cardsAtHand.values = globalVariables.cardsAtHand.values.concat( coveredCards )
            globalVariables.cardsAtHand.values = toolbox.sortCards( globalVariables.cardsAtHand.values )
            actions.displayCards( globalVariables.cardsAtHand.values )

            actions.showAndEnableButton( globalVariables.surrenderButton )

            globalVariables.settleCoveredCardsButton.visible = true
            globalVariables.settleCoveredCardsButton.inputEnabled = false
            globalVariables.settleCoveredCardsButton.setFrames( 2, 2, 2 )
        globalVariables.gameStatus = constants.GAME_STATUS_SETTLING_COVERED_CARDS
        setPlayerStatusTextForOneUserAndClearStatusTextForOthers( bankerUsername, '庄家埋底中...' )

    io.socket.on 'finishedSettlingCoveredCards', ( data ) ->
        bankerUsername = data.banker
        setPlayerStatusTextForOneUserAndClearStatusTextForOthers( bankerUsername, '庄家选主中...' )

    io.socket.on 'mainSuitChosen', ( data ) ->
        globalVariables.gameStatus = constants.GAME_STATUS_PLAYING
        globalVariables.mainSuit = data.mainSuit
        # after main suit is decided, rank all card values
        globalVariables.cardValueRanks = toolbox.getRanksForMainSuitCards( globalVariables.mainSuit )
        bankerUsername = data.banker
        globalVariables.iconOfMainSuit.frame = globalVariables.mainSuit
        setPlayerStatusTextForOneUserAndClearStatusTextForOthers( bankerUsername, '出牌中...' )
        globalVariables.cardsAtHand.values = toolbox.sortCardsAfterMainSuitSettled( globalVariables.cardsAtHand.values, globalVariables.mainSuit )
        actions.displayCards( globalVariables.cardsAtHand.values )

    io.socket.on 'cardPlayed', ( data ) ->
        usernamePlayedCards = data.playerName
        playedCardValues = data.playedCardValues
        globalVariables.firstlyPlayedCardValuesForCurrentRound = data.firstlyPlayedCardValues
        nextPlayerUsername = data.nextPlayerUsername
        n = -1
        # record played cards as historical played cards and also show the played cards for the corresponding player
        if usernamePlayedCards is globalVariables.username
            globalVariables.meHistoricalPlayedCardValues.push( playedCardValues )
        else if usernamePlayedCards is globalVariables.player1Username.text
            globalVariables.player1HistoricalPlayedCardValues.push( playedCardValues )
            n = 1
        else if usernamePlayedCards is globalVariables.player2Username.text
            globalVariables.player2HistoricalPlayedCardValues.push( playedCardValues )
            n = 2
        else if usernamePlayedCards is globalVariables.player3Username.text
            globalVariables.player3HistoricalPlayedCardValues.push( playedCardValues )
            n = 3
        if n isnt -1 then actions.showPlayedCardsForUser( n, playedCardValues, true )
        # If it is the current player's turn to play card
        if nextPlayerUsername is globalVariables.username
            globalVariables.playCardsButton.inputEnabled = false
            globalVariables.playCardsButton.setFrames( 2, 2, 2 )
            globalVariables.playCardsButton.visible = true
        setPlayerStatusTextForOneUserAndClearStatusTextForOthers( nextPlayerUsername, '出牌中...' )

    io.socket.on 'roundFinished', ( data ) ->
        usernamePlayedCards = data.lastPlayerName
        playedCardValues = data.playedCardValues
        scoresEarnedCurrentRound = data.scoresEarnedCurrentRound
        usernameWithLargestCardsForCurrentRound = data.usernameWithLargestCardsForCurrentRound
        globalVariables.nonBankerPlayersHaveNoMainSuit = data.nonBankerPlayersHaveNoMainSuit
        n = -1
        if usernamePlayedCards is globalVariables.username
            globalVariables.meHistoricalPlayedCardValues.push( playedCardValues )
        else if usernamePlayedCards is globalVariables.player1Username.text
            globalVariables.player1HistoricalPlayedCardValues.push( playedCardValues )
            n = 1
        else if usernamePlayedCards is globalVariables.player2Username.text
            globalVariables.player2HistoricalPlayedCardValues.push( playedCardValues )
            n = 2
        else if usernamePlayedCards is globalVariables.player3Username.text
            globalVariables.player3HistoricalPlayedCardValues.push( playedCardValues )
            n = 3
        if n isnt -1 then actions.showPlayedCardsForUser( n, playedCardValues, true )
        actions.showBigStampForTheLargestPlayedCardsCurrentRound( playedCardValues.length, usernameWithLargestCardsForCurrentRound, game )
        # increase the scores earned so far
        globalVariables.textOfCurrentScores.text = parseInt( globalVariables.textOfCurrentScores.text ) + scoresEarnedCurrentRound
        actions.showEarnedScoreTextWithFadeOutEffect( scoresEarnedCurrentRound, game ) if scoresEarnedCurrentRound isnt 0
        globalVariables.firstlyPlayedCardValuesForCurrentRound = []

        # now that at least one round is finished, enable the button to check historically played card
        actions.showAndEnableButton( globalVariables.historicalButton )

        setTimeout(() ->
            # either already earned enough scores to triple chips or all cards have been played
            return actions.endGame( false, data.gameResults, game ) if data.shouldGameEnd
            globalVariables.bigSign.destroy()
            globalVariables.currentUserPlayedCards.removeAll()
            globalVariables.user1PlayedCards.removeAll()
            globalVariables.user2PlayedCards.removeAll()
            globalVariables.user3PlayedCards.removeAll()
            # if there are still cards to play
            if globalVariables.cardsAtHand.children.length isnt 0
                # if current player played the largest cards for this round, he/she should be the first to play for next round
                if usernameWithLargestCardsForCurrentRound is globalVariables.username
                    globalVariables.playCardsButton.inputEnabled = false
                    globalVariables.playCardsButton.setFrames( 2, 2, 2 )
                    globalVariables.playCardsButton.visible = true
                setPlayerStatusTextForOneUserAndClearStatusTextForOthers( usernameWithLargestCardsForCurrentRound, '出牌中...' )
        , 2000)

module.exports =
    getRoomInfo: getRoomInfo
    socketEventHandler: socketEventHandler
