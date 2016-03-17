constants = require './constants.js'
globalVariables = require './globalVariables.js'

sortCards = (array) ->
    sortNumber = (a, b) ->
        return a - b
    return array.sort sortNumber

getCardName = (n) ->
    cardName = ''
    switch n
        when 1
            cardName = 'bigJoker'
        when 2
            cardName = 'smallJoker'
        when 3
            cardName = 'sevenOfSpades'
        when 4
            cardName = 'sevenOfHearts'
        when 5
            cardName = 'sevenOfClubs'
        when 6
            cardName = 'sevenOfDiamonds'
        when 7
            cardName = 'twoOfSpades'
        when 8
            cardName = 'twoOfHearts'
        when 9
            cardName = 'twoOfClubs'
        when 10
            cardName = 'twoOfDiamonds'
        when 11
            cardName = 'aceOfSpades'
        when 12
            cardName = 'kingOfSpades'
        when 13
            cardName = 'queenOfSpades'
        when 14
            cardName = 'jackOfSpades'
        when 15
            cardName = 'tenOfSpades'
        when 16
            cardName = 'nineOfSpades'
        when 17
            cardName = 'eightOfSpades'
        when 18
            cardName = 'sixOfSpades'
        when 19
            cardName = 'fiveOfSpades'
        when 20
            cardName = 'aceOfHearts'
        when 21
            cardName = 'kingOfHearts'
        when 22
            cardName = 'queenOfHearts'
        when 23
            cardName = 'jackOfHearts'
        when 24
            cardName = 'tenOfHearts'
        when 25
            cardName = 'nineOfHearts'
        when 26
            cardName = 'eightOfHearts'
        when 27
            cardName = 'sixOfHearts'
        when 28
            cardName = 'fiveOfHearts'
        when 29
            cardName = 'aceOfClubs'
        when 30
            cardName = 'kingOfClubs'
        when 31
            cardName = 'queenOfClubs'
        when 32
            cardName = 'jackOfClubs'
        when 33
            cardName = 'tenOfClubs'
        when 34
            cardName = 'nineOfClubs'
        when 35
            cardName = 'eightOfClubs'
        when 36
            cardName = 'sixOfClubs'
        when 37
            cardName = 'fiveOfClubs'
        when 38
            cardName = 'aceOfDiamonds'
        when 39
            cardName = 'kingOfDiamonds'
        when 40
            cardName = 'queenOfDiamonds'
        when 41
            cardName = 'jackOfDiamonds'
        when 42
            cardName = 'tenOfDiamonds'
        when 43
            cardName = 'nineOfDiamonds'
        when 44
            cardName = 'eightOfDiamonds'
        when 45
            cardName = 'sixOfDiamonds'
        when 46
            cardName = 'fiveOfDiamonds'
    cardName

showPlayedCardsForUser = (n, valuesOfPlayedCards) ->
    startX = null
    startY = null
    userPlayedCards = null
    switch n
        when 0         # current user
            startX = globalVariables.screenWidth / 2 - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 8
            startY = globalVariables.screenHeight - 2 * globalVariables.scaledCardHeight - 2 * constants.MARGIN
            userPlayedCards = globalVariables.currentUserPlayedCards
        when 1         # the 1st user
            startX = globalVariables.screenWidth - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 4 - constants.MARGIN
            startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2
            userPlayedCards = globalVariables.user1PlayedCards
        when 2         # the 2nd user
            startX = globalVariables.screenWidth / 2 - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 8
            startY = constants.MARGIN
            userPlayedCards = globalVariables.user2PlayedCards
        when 3         # the 3rd user
            startX = constants.MARGIN
            startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2
            userPlayedCards = globalVariables.user3PlayedCards
    # remove played cards
    cardsToRemove = []
    for i in [0...userPlayedCards.children.length]
        cardsToRemove.push userPlayedCards.children[i]
    for i in [0...cardsToRemove.length]
        userPlayedCards.remove cardsToRemove[i]
    for i in [0...valuesOfPlayedCards.length]
        playedCard = userPlayedCards.create startX + i * globalVariables.scaledCardWidth / 4, startY, getCardName(valuesOfPlayedCards[i])
        playedCard.width = globalVariables.scaledCardWidth
        playedCard.height = globalVariables.scaledCardHeight

toggleCardSelection = (sprite) ->
    if not sprite.isSelected then sprite.y = sprite.y - constants.SELECTED_CARD_Y_OFFSET
    else sprite.y = sprite.y + constants.SELECTED_CARD_Y_OFFSET
    sprite.isSelected = !sprite.isSelected

module.exports =
    sortCards: sortCards
    getCardName: getCardName
    toggleCardSelection: toggleCardSelection
    showPlayedCardsForUser: showPlayedCardsForUser
