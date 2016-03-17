constants = require './constants.js'
globalVariables = require './globalVariables.js'
toolbox = require './toolbox.js'

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

tapDownOnSprite = (sprite, pointer) ->
    globalVariables.startSwipeCardIndex = sprite.index

hideLeftPlayer = (username) ->
    if  username == globalVariables.player1Username.text
        globalVariables.user1Avatar.destroy()
        globalVariables.player1Username.destroy()
        globalVariables.player1IsMakerText.destroy()
    else if username is globalVariables.player2Username.text
        globalVariables.user2Avatar.destroy()
        globalVariables.player2Username.destroy()
        globalVariables.player2IsMakerText.destroy()
    else if username is globalVariables.player3Username.text
        globalVariables.user3Avatar.destroy()
        globalVariables.player3Username.destroy()
        globalVariables.player3IsMakerText.destroy()

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
    globalVariables.player1IsMakerText = game.add.text(globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, '', constants.RED_TEXT_STYLE)
    globalVariables.player1Username = game.add.text(globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY + constants.AVATAR_SIZE / 2 + constants.MARGIN, username, constants.TEXT_STYLE)
    globalVariables.player1Username.setTextBounds 0, 0, constants.AVATAR_SIZE, 25

showPlayer2Info = (game, username) ->
    globalVariables.user2Avatar = game.add.sprite(game.world.centerX - constants.AVATAR_SIZE / 2, constants.MARGIN, 'avatar')
    globalVariables.user2Avatar.width /= 2
    globalVariables.player2IsMakerText = game.add.text(game.world.centerX - constants.AVATAR_SIZE / 2, constants.MARGIN, '', constants.RED_TEXT_STYLE)
    globalVariables.user2Avatar.height /= 2
    globalVariables.player2Username = game.add.text(game.world.centerX - constants.AVATAR_SIZE / 2, constants.AVATAR_SIZE + 2 * constants.MARGIN, username, constants.TEXT_STYLE)
    globalVariables.player2Username.setTextBounds 0, 0, constants.AVATAR_SIZE, 25

showPlayer3Info = (game, username) ->
    globalVariables.user3Avatar = game.add.sprite(constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'avatar')
    globalVariables.user3Avatar.width /= 2
    globalVariables.user3Avatar.height /= 2
    globalVariables.player3IsMakerText = game.add.text(constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, '', constants.RED_TEXT_STYLE)
    globalVariables.player3Username = game.add.text(constants.MARGIN, game.world.centerY + constants.AVATAR_SIZE / 2 + constants.MARGIN, username, constants.TEXT_STYLE)
    globalVariables.player3Username.setTextBounds 0, 0, constants.AVATAR_SIZE, 25

sendGetReadyMessage = () ->
    csrfToken = document.getElementsByName('csrf-token')[0].content
    io.socket.post '/get_ready',
        _csrf: csrfToken
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
    , (resData, jwres) ->
        if jwres.statusCode is 200
            globalVariables.prepareButton.visible = false
            globalVariables.leaveButton.visible = false
            globalVariables.meStatusText.text = 'Ready'
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
    io.socket.post '/pass',
        _csrf: csrfToken
        userId: globalVariables.userId
        loginToken: globalVariables.loginToken
        username: globalVariables.username
        roomName: globalVariables.roomName
    , (resData, jwres) ->
        if jwres.statusCode is 200
            globalVariables.callScoreStage.destroy true, false
            globalVariables.meStatusText.text = '不要'

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

module.exports =
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