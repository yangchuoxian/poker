constants = require './constants.js'
globalVariables = require './globalVariables.js'
toolbox = require './toolbox.js'

getRoomInfo = (game) ->
    io.socket.get '/get_room_info',
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
    , (resData, jwres) ->
        if jwres.statusCode is 200
            globalVariables.textOfRoomName.text = resData.roomName
            usernames = resData.usernames
            switch usernames.length
                when 2
                    showPlayer3Info game, usernames[0]
                when 3
                    showPlayer3Info game, usernames[1]
                    showPlayer2Info game, usernames[0]
                when 4
                    showPlayer3Info game, usernames[2]
                    showPlayer2Info game, usernames[1]
                    showPlayer1Info game, usernames[0]
            readyPlayers = resData.readyPlayers
            for i in [0...readyPlayers.length]
                if globalVariables.player1Username
                    if readyPlayers[i] is globalVariables.player1Username.text then globalVariables.player1StatusText.text = 'Ready'
                if globalVariables.player2Username
                    if readyPlayers[i] is globalVariables.player2Username.text then globalVariables.player2StatusText.text = 'Ready'
                if globalVariables.player3Username
                    if readyPlayers[i] is globalVariables.player3Username.text then globalVariables.player3StatusText.text = 'Ready'

displayCards = (array) ->
    leftMargin = (globalVariables.screenWidth - (Math.floor(globalVariables.scaledCardWidth / 4) * array.length + Math.floor(3 * globalVariables.scaledCardWidth / 4))) / 2
    spritesShouldBeRemoved = []
    if globalVariables.cardsAtHand.children.length > 0
        for i in [0...globalVariables.cardsAtHand.children.length]
            spritesShouldBeRemoved.push globalVariables.cardsAtHand.children[i]
        for i in [0...spritesShouldBeRemoved.length]
            globalVariables.cardsAtHand.remove spritesShouldBeRemoved[i]
    for i in [0...array.length]
        cardName = toolbox.getCardName array[i]
        cardSprite = globalVariables.cardsAtHand.create(leftMargin + i * Math.floor(globalVariables.scaledCardWidth / 4), globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.MARGIN, cardName)
        cardSprite.scale.setTo globalVariables.scaleWidthRatio, globalVariables.scaleHeightRatio
        cardSprite.isSelected = false
        cardSprite.inputEnabled = true
        cardSprite.index = i
        cardSprite.value = array[i]
        cardSprite.input.useHandCursor = true
        cardSprite.events.onInputDown.add tapDownOnSprite, this
        cardSprite.events.onInputUp.add tapUp, this

showCoveredCards = () ->
    if not globalVariables.isShowingCoveredCards
        stageWidth = 11 * globalVariables.scaledCardWidth / 4 + 2 * constants.MARGIN
        stageHeight = globalVariables.scaledCardHeight + 2 * constants.MARGIN

        coveredCardsStage = globalVariables.coveredCards.create(globalVariables.screenWidth / 2 - stageWidth / 2, globalVariables.screenHeight / 2 - stageHeight / 2, 'stageBackground')
        coveredCardsStage.alpha = 0.3
        coveredCardsStage.width = stageWidth
        coveredCardsStage.height = stageHeight
        for i in [0...globalVariables.coveredCards.indexes.length]
            cardName = toolbox.getCardName(globalVariables.coveredCards.indexes[i])
            coveredCard = globalVariables.coveredCards.create(coveredCardsStage.x + constants.MARGIN + i * globalVariables.scaledCardWidth / 4, coveredCardsStage.y + constants.MARGIN, cardName)
            coveredCard.scale.setTo globalVariables.scaleWidthRatio, globalVariables.scaleHeightRatio
        globalVariables.isShowingCoveredCards = true

tapUp = (sprite, pointer) ->
    if pointer.x >= globalVariables.cardsAtHand.children[0].x and pointer.x <= (globalVariables.cardsAtHand.children[globalVariables.cardsAtHand.children.length - 1].x + globalVariables.cardsAtHand.children[globalVariables.cardsAtHand.children.length - 1].width) and pointer.y >= globalVariables.cardsAtHand.children[0].y and pointer.y <= (globalVariables.cardsAtHand.children[0].y + globalVariables.cardsAtHand.children[0].height)
        globalVariables.endSwipeCardIndex = -1
        for i in [0...globalVariables.cardsAtHand.children.length - 1]
            if pointer.x >= globalVariables.cardsAtHand.children[i].x and pointer.x <= globalVariables.cardsAtHand.children[i + 1].x
                globalVariables.endSwipeCardIndex = i
                break
        if globalVariables.endSwipeCardIndex is -1
            globalVariables.endSwipeCardIndex = globalVariables.cardsAtHand.children.length - 1
        if globalVariables.startSwipeCardIndex <= globalVariables.endSwipeCardIndex
            for i in [globalVariables.startSwipeCardIndex...globalVariables.endSwipeCardIndex + 1]
                toolbox.toggleCardSelection globalVariables.cardsAtHand.children[i]
        else
            for i in [globalVariables.endSwipeCardIndex...globalVariables.startSwipeCardIndex + 1]
                toolbox.toggleCardSelection globalVariables.cardsAtHand.children[i]

        selectedCardValues = []
        for i in [0...globalVariables.cardsAtHand.children.length]
            if globalVariables.cardsAtHand.children[i].isSelected then selectedCardValues.push globalVariables.cardsAtHand.children[i].value
        if globalVariables.gameStatus is constants.GAME_STATUS_SETTLING_COVERED_CARDS
            if selectedCardValues.length is 8
                globalVariables.settleCoveredCardsButton.inputEnabled = true
                globalVariables.settleCoveredCardsButton.setFrames 1, 0, 1
            else
                globalVariables.settleCoveredCardsButton.inputEnabled = false
                globalVariables.settleCoveredCardsButton.setFrames 2, 2, 2
        else if globalVariables.gameStatus is constants.GAME_STATUS_PLAYING
            if toolbox.validateSelectedCardsForPlay selectedCardValues
                globalVariables.playCardsButton.inputEnabled = true
                globalVariables.playCardsButton.setFrames 1, 0, 1
            else
                globalVariables.playCardsButton.inputEnabled = false
                globalVariables.playCardsButton.setFrames 2, 2, 2

tapDownOnSprite = (sprite, pointer) ->
    globalVariables.startSwipeCardIndex = sprite.index

hideLeftPlayer = (username) ->
    if  username == globalVariables.player1Username.text
        globalVariables.user1Avatar.destroy()
        globalVariables.player1Username.destroy()
        globalVariables.player1IsMakerIcon.destroy()
    else if username is globalVariables.player2Username.text
        globalVariables.user2Avatar.destroy()
        globalVariables.player2Username.destroy()
        globalVariables.player2IsMakerIcon.destroy()
    else if username is globalVariables.player3Username.text
        globalVariables.user3Avatar.destroy()
        globalVariables.player3Username.destroy()
        globalVariables.player3IsMakerIcon.destroy()

backgroundTapped = () ->
    if globalVariables.isShowingCoveredCards
        # cancel showing covered cards
        spritesShouldBeRemoved = []
        for i in [1...10]
            spritesShouldBeRemoved.push globalVariables.coveredCards.children[i]
        for i in [0...spritesShouldBeRemoved.length]
            globalVariables.coveredCards.remove spritesShouldBeRemoved[i]
        globalVariables.isShowingCoveredCards = false
    else
        # cancel card selections
        for i in [0...globalVariables.cardsAtHand.children.length]
            if globalVariables.cardsAtHand.children[i].isSelected
                toolbox.toggleCardSelection globalVariables.cardsAtHand.children[i]
    if globalVariables.gameStatus is constants.GAME_STATUS_SETTLING_COVERED_CARDS
        globalVariables.settleCoveredCardsButton.inputEnabled = false
        globalVariables.settleCoveredCardsButton.setFrames 2, 2, 2

playSelectedCards = () ->
    selectedCards = []
    valuesOfCurrentUserPlayedCards = []
    for i in [0...globalVariables.cardsAtHand.children.length]
        if globalVariables.cardsAtHand.children[i].isSelected
            selectedCards.push globalVariables.cardsAtHand.children[i]
            valuesOfCurrentUserPlayedCards.push globalVariables.cardsAtHand.children[i].value
    if selectedCards.length is 0
        return
    for i in [0...selectedCards.length]
        globalVariables.cardsAtHand.remove selectedCards[i]
    # reposition the remaining cards
    numOfCardsLeft = globalVariables.cardsAtHand.children.length
    leftMargin = (globalVariables.screenWidth - (Math.floor(globalVariables.scaledCardWidth / 4) * numOfCardsLeft + Math.floor(3 * globalVariables.scaledCardWidth / 4))) / 2
    for i in [0...globalVariables.cardsAtHand.children.length]
        globalVariables.cardsAtHand.children[i].x = leftMargin + i * Math.floor(globalVariables.scaledCardWidth / 4)
        globalVariables.cardsAtHand.children[i].index = i
    toolbox.showPlayedCardsForUser 0, valuesOfCurrentUserPlayedCards

showPlayer1Info = (game, username) ->
    globalVariables.user1Avatar = game.add.sprite(globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'avatar')
    globalVariables.user1Avatar.width /= 2
    globalVariables.user1Avatar.height /= 2
    globalVariables.player1IsMakerIcon = game.add.sprite globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'makerIcon'
    globalVariables.player1IsMakerIcon.width = constants.MAKER_ICON_SIZE
    globalVariables.player1IsMakerIcon.height = constants.MAKER_ICON_SIZE
    globalVariables.player1IsMakerIcon.visible = false
    globalVariables.player1Username = game.add.text(globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY + constants.AVATAR_SIZE / 2 + constants.MARGIN, username, constants.TEXT_STYLE)
    globalVariables.player1Username.setTextBounds 0, 0, constants.AVATAR_SIZE, 25

showPlayer2Info = (game, username) ->
    globalVariables.user2Avatar = game.add.sprite(game.world.centerX - constants.AVATAR_SIZE / 2, constants.MARGIN, 'avatar')
    globalVariables.user2Avatar.width /= 2
    globalVariables.user2Avatar.height /= 2
    globalVariables.player2IsMakerIcon = game.add.sprite game.world.centerX - constants.AVATAR_SIZE / 2, constants.MARGIN, 'makerIcon'
    globalVariables.player2IsMakerIcon.width = constants.MAKER_ICON_SIZE
    globalVariables.player2IsMakerIcon.height = constants.MAKER_ICON_SIZE
    globalVariables.player2IsMakerIcon.visible = false
    globalVariables.player2Username = game.add.text(game.world.centerX - constants.AVATAR_SIZE / 2, constants.AVATAR_SIZE + 2 * constants.MARGIN, username, constants.TEXT_STYLE)
    globalVariables.player2Username.setTextBounds 0, 0, constants.AVATAR_SIZE, 25

showPlayer3Info = (game, username) ->
    globalVariables.user3Avatar = game.add.sprite(constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'avatar')
    globalVariables.user3Avatar.width /= 2
    globalVariables.user3Avatar.height /= 2
    globalVariables.player3IsMakerIcon = game.add.sprite constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'makerIcon'
    globalVariables.player3IsMakerIcon.width = constants.MAKER_ICON_SIZE
    globalVariables.player3IsMakerIcon.height = constants.MAKER_ICON_SIZE
    globalVariables.player3IsMakerIcon.visible = false
    globalVariables.player3Username = game.add.text(constants.MARGIN, game.world.centerY + constants.AVATAR_SIZE / 2 + constants.MARGIN, username, constants.TEXT_STYLE)
    globalVariables.player3Username.setTextBounds 0, 0, constants.AVATAR_SIZE, 25

sendGetReadyMessage = () ->
    csrfToken = document.getElementsByName('csrf-token')[0].content
    globalVariables.meStatusText.text = 'Ready'
    io.socket.post '/get_ready',
        _csrf: csrfToken
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
    , (resData, jwres) ->
        if jwres.statusCode is 200
            globalVariables.prepareButton.visible = false
            globalVariables.leaveButton.visible = false
        else console.log jwres

leaveRoom = () ->
    csrfToken = document.getElementsByName('csrf-token')[0].content
    io.socket.post '/leave_room',
        _csrf: csrfToken
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
    , (resData, jwres) ->
        if jwres.statusCode is 200 then window.location.href = '/'

raiseScore = () ->
    aimedScores = parseInt globalVariables.textOfAimedScores.text
    currentSetScores = parseInt globalVariables.callScoreStage.children[2].text
    if currentSetScores < (aimedScores - 5)
        currentSetScores += 5
        globalVariables.callScoreStage.children[2].text = '' + currentSetScores

showCallScorePanel = (game, currentScore) ->
    globalVariables.callScoreStage = game.add.group()
    stageWidth = 11 * globalVariables.scaledCardWidth / 4 + 2 * constants.MARGIN
    stageHeight = globalVariables.scaledCardHeight + 2 * constants.MARGIN
    background = globalVariables.callScoreStage.create(globalVariables.screenWidth / 2 - stageWidth / 2, globalVariables.screenHeight / 2 - stageHeight / 2, 'stageBackground')
    background.alpha = 0.3
    background.width = stageWidth
    background.height = stageHeight

    raiseScoreButton = game.add.button(game.world.centerX - constants.ROUND_BUTTON_SIZE / 2 - constants.ROUND_BUTTON_SIZE - constants.MARGIN, game.world.centerY - stageHeight / 2 + constants.MARGIN, 'raiseScoreButton', raiseScore, this, 1, 0, 1, 0)
    globalVariables.callScoreStage.add(raiseScoreButton)

    currentScoreText = game.add.text(game.world.centerX - constants.ROUND_BUTTON_SIZE / 2, game.world.centerY - stageHeight / 2 + constants.MARGIN, '' + currentScore - 5, constants.LARGE_TEXT_STYLE)
    currentScoreText.setTextBounds(0, 0, constants.ROUND_BUTTON_SIZE, constants.ROUND_BUTTON_SIZE)
    globalVariables.callScoreStage.add currentScoreText

    lowerScoreButton = game.add.button(game.world.centerX + constants.ROUND_BUTTON_SIZE / 2 + constants.MARGIN, game.world.centerY - stageHeight / 2 + constants.MARGIN, 'lowerScoreButton', lowerScore, this, 1, 0, 1, 0)
    globalVariables.callScoreStage.add lowerScoreButton

    setScoreButton = game.add.button(game.world.centerX - constants.BUTTON_WIDTH - constants.MARGIN / 2, game.world.centerY + constants.ROUND_BUTTON_SIZE / 2, 'setScoreButton', setScore, this, 1, 0, 1, 0)
    globalVariables.callScoreStage.add setScoreButton

    passButton = game.add.button(game.world.centerX + constants.MARGIN / 2, game.world.centerY + constants.ROUND_BUTTON_SIZE / 2, 'passButton', pass, this, 1, 0, 1, 0)
    globalVariables.callScoreStage.add passButton

lowerScore = () ->
    aimedScores = parseInt globalVariables.textOfAimedScores.text
    currentSetScores = parseInt globalVariables.callScoreStage.children[2].text
    if currentSetScores > 5
        currentSetScores -= 5
        globalVariables.callScoreStage.children[2].text = '' + currentSetScores

setScore = () ->
    csrfToken = document.getElementsByName('csrf-token')[0].content
    aimedScore = parseInt globalVariables.callScoreStage.children[2].text
    io.socket.post '/set_score',
        score: aimedScore
        roomName: globalVariables.roomName
        _csrf: csrfToken
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
    , (resData, jwres) ->
        if jwres.statusCode is 200
            globalVariables.callScoreStage.destroy true, false
            globalVariables.meStatusText.text = '' + aimedScore

pass = () ->
    csrfToken = document.getElementsByName('csrf-token')[0].content
    globalVariables.meStatusText.text = '不要'
    io.socket.post '/pass',
        _csrf: csrfToken
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
        username: globalVariables.username
        roomName: globalVariables.roomName
    , (resData, jwres) ->
        if jwres.statusCode is 200 then globalVariables.callScoreStage.destroy true, false

surrender = () ->
    csrfToken = document.getElementsByName('csrf-token')[0].content
    globalVariables.prepareButton.visible = true
    globalVariables.leaveButton.visible = true
    globalVariables.meStatusText.text = '你输了'
    globalVariables.surrenderButton.visible = false
    globalVariables.settleCoveredCardsButton.visible = false

settleCoveredCards = () ->
    valuesOfSelectedCoveredCards = []
    for i in [0...globalVariables.cardsAtHand.children.length]
        if globalVariables.cardsAtHand.children[i].isSelected then valuesOfSelectedCoveredCards.push globalVariables.cardsAtHand.children[i].value
    if valuesOfSelectedCoveredCards.length isnt 8
        return
    for i in [0...valuesOfSelectedCoveredCards.length]
        index = globalVariables.cardsAtHand.indexes.indexOf valuesOfSelectedCoveredCards[i]
        globalVariables.cardsAtHand.indexes.splice index, 1
    displayCards globalVariables.cardsAtHand.indexes
    coveredCardsIcon = globalVariables.coveredCards.create constants.MARGIN, constants.MARGIN, 'back'
    coveredCardsIcon.scale.setTo globalVariables.scaleWidthRatio, globalVariables.scaleHeightRatio
    coveredCardsIcon.inputEnabled = true
    globalVariables.coveredCards.indexes = valuesOfSelectedCoveredCards
    coveredCardsIcon.events.onInputDown.add showCoveredCards, this
    globalVariables.settleCoveredCardsButton.visible = false
    globalVariables.settleCoveredCardsButton.inputEnabled = false
    globalVariables.settleCoveredCardsButton.setFrames 2, 2, 2

    csrfToken = document.getElementsByName('csrf-token')[0].content
    io.socket.post '/settleCoveredCards',
        _csrf: csrfToken
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
        roomName: globalVariables.roomName
        coveredCards: globalVariables.coveredCards.indexes
        maker: globalVariables.username
        cardsAtHand: globalVariables.cardsAtHand.indexes
    , (resData, jwres) ->
        if jwres.statusCode is 200 then showSelectSuitPanel()

showSelectSuitPanel = () ->
    globalVariables.gameStatus = constants.GAME_STATUS_DECIDING_SUIT
    globalVariables.selectSuitButton.visible = true
    globalVariables.selectSuitButton.inputEnabled = false
    globalVariables.selectSuitButton.setFrames 2, 2, 2

    stageWidth = 4 * constants.SUIT_ICON_SIZE + 8 * constants.MARGIN
    stageHeight = 2 * constants.MARGIN + constants.SUIT_ICON_SIZE
    background = globalVariables.selectSuitStage.create globalVariables.screenWidth / 2 - stageWidth / 2, globalVariables.screenHeight / 2 - stageHeight / 2, 'stageBackground'
    background.alpha = 0.3
    background.width = stageWidth
    background.height = stageHeight

    spadeIcon = globalVariables.selectSuitStage.create background.x + constants.MARGIN, background.y + constants.MARGIN, 'spade'
    spadeIcon.width = constants.SUIT_ICON_SIZE
    spadeIcon.height = constants.SUIT_ICON_SIZE
    heartIcon = globalVariables.selectSuitStage.create background.x + 3 * constants.MARGIN + constants.SUIT_ICON_SIZE, background.y + constants.MARGIN, 'heart'
    heartIcon.width = constants.SUIT_ICON_SIZE
    heartIcon.height = constants.SUIT_ICON_SIZE
    clubIcon = globalVariables.selectSuitStage.create background.x + 5 * constants.MARGIN + 2 * constants.SUIT_ICON_SIZE, background.y + constants.MARGIN, 'club'
    clubIcon.width = constants.SUIT_ICON_SIZE
    clubIcon.height = constants.SUIT_ICON_SIZE
    diamondIcon = globalVariables.selectSuitStage.create background.x + 7 * constants.MARGIN + 3 * constants.SUIT_ICON_SIZE, background.y + constants.MARGIN, 'diamond'
    diamondIcon.width = constants.SUIT_ICON_SIZE
    diamondIcon.height = constants.SUIT_ICON_SIZE

    spadeIcon.inputEnabled = true
    spadeIcon.input.useHandCursor = true
    spadeIcon.events.onInputDown.add spadeTapped, this

    heartIcon.inputEnabled = true
    heartIcon.input.useHandCursor = true
    heartIcon.events.onInputDown.add heartTapped, this

    clubIcon.inputEnabled = true
    clubIcon.input.useHandCursor = true
    clubIcon.events.onInputDown.add clubTapped, this

    diamondIcon.inputEnabled = true
    diamondIcon.input.useHandCursor = true
    diamondIcon.events.onInputDown.add diamondTapped, this

    rectangle = globalVariables.selectSuitStage.create spadeIcon.x, spadeIcon.y, 'rectangle'
    rectangle.width = constants.SUIT_ICON_SIZE + 10
    rectangle.height = constants.SUIT_ICON_SIZE + 10
    rectangle.visible = false

    globalVariables.selectSuitStage.add background
    globalVariables.selectSuitStage.add spadeIcon
    globalVariables.selectSuitStage.add heartIcon
    globalVariables.selectSuitStage.add clubIcon
    globalVariables.selectSuitStage.add diamondIcon
    globalVariables.selectSuitStage.add rectangle

spadeTapped = () ->
    globalVariables.mainSuit = constants.SUIT_SPADE
    rectangle = globalVariables.selectSuitStage.children[globalVariables.selectSuitStage.children.length - 1]
    spadeIcon = globalVariables.selectSuitStage.children[1]
    rectangle.x = spadeIcon.x - 10
    rectangle.visible = true
    globalVariables.selectSuitButton.inputEnabled = true
    globalVariables.selectSuitButton.setFrames 1, 0, 1

heartTapped = () ->
    globalVariables.mainSuit = constants.SUIT_HEART
    rectangle = globalVariables.selectSuitStage.children[globalVariables.selectSuitStage.children.length - 1]
    heartIcon = globalVariables.selectSuitStage.children[2]
    rectangle.x = heartIcon.x - 10
    rectangle.visible = true
    globalVariables.selectSuitButton.inputEnabled = true
    globalVariables.selectSuitButton.setFrames 1, 0, 1

clubTapped = () ->
    globalVariables.mainSuit = constants.SUIT_CLUB
    rectangle = globalVariables.selectSuitStage.children[globalVariables.selectSuitStage.children.length - 1]
    clubIcon = globalVariables.selectSuitStage.children[3]
    rectangle.x = clubIcon.x - 10
    rectangle.visible = true
    globalVariables.selectSuitButton.inputEnabled = true
    globalVariables.selectSuitButton.setFrames 1, 0, 1

diamondTapped = () ->
    globalVariables.mainSuit = constants.SUIT_DIAMOND
    rectangle = globalVariables.selectSuitStage.children[globalVariables.selectSuitStage.children.length - 1]
    diamondIcon = globalVariables.selectSuitStage.children[4]
    rectangle.x = diamondIcon.x - 10
    rectangle.visible = true
    globalVariables.selectSuitButton.inputEnabled = true
    globalVariables.selectSuitButton.setFrames 1, 0, 1

selectSuit = () ->
    csrfToken = document.getElementsByName('csrf-token')[0].content
    io.socket.post '/chooseMainSuit',
        _csrf: csrfToken
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
        roomName: globalVariables.roomName
        maker: globalVariables.username
        mainSuit: globalVariables.mainSuit
    , (resData, jwres) ->
        if jwres.statusCode is 200
            globalVariables.surrenderButton.visible = false
            globalVariables.selectSuitButton.visible = false
            spritesShouldBeRemoved = []
            for i in [0...globalVariables.selectSuitStage.children.length]
                spritesShouldBeRemoved.push globalVariables.selectSuitStage.children[i]
            for i in [0...spritesShouldBeRemoved.length]
                globalVariables.selectSuitStage.remove spritesShouldBeRemoved[i]
            globalVariables.iconOfMainSuit.frame = globalVariables.mainSuit
            globalVariables.playCardsButton.visible = true
            globalVariables.playCardsButton.inputEnabled = false
            globalVariables.playCardsButton.setFrames 2, 2, 2
            globalVariables.gameStatus = constants.GAME_STATUS_PLAYING


module.exports =
    getRoomInfo: getRoomInfo
    displayCards: displayCards
    showCoveredCards: showCoveredCards
    tapUp: tapUp
    tapDownOnSprite: tapDownOnSprite
    backgroundTapped: backgroundTapped
    playSelectedCards: playSelectedCards
    showPlayer1Info: showPlayer1Info
    showPlayer2Info: showPlayer2Info
    showPlayer3Info: showPlayer3Info
    hideLeftPlayer: hideLeftPlayer
    sendGetReadyMessage: sendGetReadyMessage
    leaveRoom: leaveRoom
    showCallScorePanel: showCallScorePanel
    raiseScore: raiseScore
    lowerScore: lowerScore
    setScore: setScore
    pass: pass
    surrender: surrender
    settleCoveredCards: settleCoveredCards
    showSelectSuitPanel: showSelectSuitPanel
    selectSuit: selectSuit